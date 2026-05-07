page 50003 ARD_ItemRecommendationPrompt
{
    ApplicationArea = All;
    Caption = 'Item Recommendation Prompt';
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    PromptMode = Prompt;

    layout
    {
        area(prompt)
        {
            field(ChatRequest; ChatRequest)
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;
                InstructionalText = 'Provide any additional product description here.';

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }

        area(Content)
        {
            part(SubItemRecommendations; ARD_ItemRecommendations)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            // You can have custom behaviour for the main system actions in a PromptDialog page, such as generating a suggestion with copilot, regenerate, or discard the
            // suggestion. When you develop a Copilot feature, remember: the user should always be in control (the user must confirm anything Copilot suggests before any
            // change is saved).
            // This is also the reason why you cannot have a physical SourceTable in a PromptDialog page (you either use a temporary table, or no table).
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Generate Item Substitutions proposal with Dynamics 365 Copilot.';

                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
            systemaction(OK)
            {
                Caption = 'Confirm';
                ToolTip = 'Add selected Items to Substitutions.';
            }
            systemaction(Cancel)
            {
                Caption = 'Discard';
                ToolTip = 'Discard Items proposed by Dynamics 365 Copilot.';
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate Item Substitutions proposal with Dynamics 365 Copilot.';
                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
        }
    }

    var
        TmpItemRecommendations: Record "ARD_CopilotItemRecommendations" temporary;
        JSONDescriptions: JsonArray;
        ChatRequest: Text;
        RequestResponse: Text;
        SalesHeaderNo: Code[20];
        MaxSalesLineCount: Integer;

    /// <summary>
    /// Trigger executed when the page is about to close.
    /// If the close action is OK, it adds the selected items from the SubItemRecommendations page
    /// to the current context using the provided SalesHeaderNo and MaxSalesLineCount.
    /// </summary>
    /// <param name="closeAction">The action that caused the page to close.</param>
    /// <returns>Boolean indicating whether the page should close.</returns>
    trigger OnQueryClosePage(closeAction: Action): Boolean
    begin
        if CloseAction = Action::OK then
            CurrPage.SubItemRecommendations.Page.AddSelectedItems(SalesHeaderNo, MaxSalesLineCount);
    end;

    procedure SetSalesHeader(var SalesHeaderRec: Code[20]; MaxSalesLine: Integer)
    begin
        SalesHeaderNo := SalesHeaderRec;
    end;

    local procedure RunGeneration()
    var
        GenerateRecommdation: Codeunit ARDCopilotItemRecommendations;
        InStr: InStream;
        Attempts: Integer;
    begin
        RequestResponse := '';
        CurrPage.Caption := ChatRequest;
        GenerateRecommdation.SetItemDescriptions(JSONDescriptions);
        GenerateRecommdation.SetUserPrompt(ChatRequest);

        Attempts := 0;
        while (StrLen(RequestResponse) = 0) AND (Attempts < 5) do begin
            if GenerateRecommdation.Run() then
                RequestResponse := GenerateRecommdation.GetResult();
            Attempts += 1;
        end;

        if (Attempts < 5) then begin
            message(GenerateRecommdation.GetCompletionResult());
            SearchItemDescriptions(RequestResponse);
        end else
            Error('Something went wrong. Please try again. ' + GetLastErrorText());
    end;

    // Adds a new item description to the JSONDescriptions array
    procedure AddItemDescription(Description: Text)
    begin
        JSONDescriptions.add(Description);
    end;

    // Parses the provided JSON text to extract the 'Keywords' array and calls SearchItemDescriptions with it
    procedure SearchItemDescriptions(Description: Text)
    var
        JObject: JsonObject;
        JArray: JsonArray;
    begin
        JObject.ReadFrom(Description); // Parse the JSON text into a JsonObject
        JArray := JObject.GetArray('Keywords'); // Extract the 'Keywords' array from the JsonObject
        SearchItemDescriptions(JArray); // Call the overloaded SearchItemDescriptions procedure with the extracted array
    end;

    // Searches for items matching the provided descriptions and loads them into the temporary recommendations table
    procedure SearchItemDescriptions(Descriptions: JsonArray)
    var
        ItemRec: Record Item;
        DescriptionToken: JsonToken;
        SearchText: Text;
        FoundItems: list of [code[20]];
    begin
        // Clear previous recommendations
        TmpItemRecommendations.Reset();
        TmpItemRecommendations.DeleteAll();

        // Iterate over each description keyword
        foreach DescriptionToken in Descriptions do begin
            SearchText := DescriptionToken.AsValue().AsText();
            clear(ItemRec);
            // Use the Full Text Search features to find items matching the description
            ItemRec.setfilter(Description, '&&' + SearchText + '*');
            if ItemRec.findset() then
                repeat
                    // Avoid duplicates
                    if not FoundItems.Contains(ItemRec."No.") then begin
                        TmpItemRecommendations.Init();
                        TmpItemRecommendations."ARD_No." := ItemRec."No.";
                        TmpItemRecommendations."ARD_Description" := ItemRec.Description;
                        TmpItemRecommendations.Insert();
                        FoundItems.Add(ItemRec."No.");
                    end;
                until ItemRec.next() = 0;
        end;

        // Load the found recommendations into the subpage
        CurrPage.SubItemRecommendations.Page.Load(TmpItemRecommendations);
    end;
}
