page 50001 ARD_AddressPrompt
{
    ApplicationArea = All;
    Caption = 'Address Prompt';
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
                InstructionalText = 'Provide a an address for the customer.';

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
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
        GenerateAddress: Codeunit ARD_CopilotAddressCleanup;
        ChatRequest: Text;
        AddressDict: Dictionary of [Text, Text];

    /// <summary>
    /// Executes the address generation process by interacting with the GenerateAddress object.
    /// Updates the page caption, sets the user prompt, and attempts to generate an address
    /// up to a maximum of 5 times. If successful, displays the result; otherwise, shows an error message.
    /// </summary>
    /// <remarks>
    /// The procedure uses a loop to retry the address generation process if the result is empty.
    /// It ensures that the process does not exceed 5 attempts to prevent infinite loops.
    /// </remarks>
    /// <exception cref="Error">
    /// Throws an error if the maximum number of attempts is reached without a successful result.
    /// </exception>
    local procedure RunGeneration()
    var
        InStr: InStream;
        Attempts: Integer;
    begin
        CurrPage.Caption := ChatRequest;
        GenerateAddress.SetUserPrompt(ChatRequest);

        Attempts := 0;
        while (AddressDict.Count() = 0) AND (Attempts < 5) do begin
            if GenerateAddress.Run() then
                AddressDict := GenerateAddress.GetResult();
            Attempts += 1;
        end;

        if (Attempts < 5) then begin
            message(GenerateAddress.GetCompletionResult());
        end else
            Error('Something went wrong. Please try again. ' + GetLastErrorText());
    end;

    procedure GetResult(): Dictionary of [Text, Text]
    begin
        exit(AddressDict);
    end;
}
