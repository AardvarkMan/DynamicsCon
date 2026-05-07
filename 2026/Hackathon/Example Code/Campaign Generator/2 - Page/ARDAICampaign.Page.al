page 50201 ARD_AICampaign
{
    ApplicationArea = All;
    Caption = 'AI Campaign';
    PageType = Card;
    SourceTable = ARD_Campaign;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(ARD_Name; Rec.ARD_Name)
                {
                }
                group(Details)
                {
                    Caption = 'Details';
                    field(ARD_StartDate; Rec.ARD_StartDate)
                    {
                    }
                    field(ARD_EndDate; Rec.ARD_EndDate)
                    {
                    }
                    field(ARD_MaxQuantity; Rec.ARD_MaxQuantity)
                    {
                    }
                    field(ARD_CurrentQuantity; Rec.ARD_CurrentQuantity)
                    {
                        Editable = false;
                    }
                }
            }
            group(Items)
            {
                Caption = 'Campaign Items';

                part(CampaignItems; ARD_CampaignItem)
                {
                    ApplicationArea = All;
                    SubPageLink = "ARD_CampaignNo." = field("ARD_No.");
                }
            }
            group(PostalCodes)
            {
                Caption = 'Campaign Postal Codes';

                part(CampaignPostalCodes; ARD_CampaignPostalCodes)
                {
                    ApplicationArea = All;
                    SubPageLink = "ARD_CampaignNo." = field("ARD_No.");
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            Action(GenerateCampaignRegion)
            {
                Caption = 'Generate Campaign Regions';
                ToolTip = 'Generate a new campaign region based on AI suggestions.';
                Image = Sparkle;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CampaignPrompt: Page ARD_CampaignPrompt;
                    CampaignRegionText: Text;
                begin
                    if CampaignPrompt.RunModal() = Action::OK then begin
                        CampaignRegionText := CampaignPrompt.GetResult();
                        ParsePostalCodes(CampaignRegionText);
                    end;
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        DeleteCampaignPostalCodes();
        DeleteCampaignItems();
        exit(true);
    end;

    local procedure DeleteCampaignPostalCodes()
    var
        CampaignPostalCode: Record ARD_CampaignPostalCode;
    begin
        CampaignPostalCode.SetRange("ARD_CampaignNo.", Rec."ARD_No.");
        if CampaignPostalCode.FindSet() then
            CampaignPostalCode.DeleteAll(true);
    end;

    local procedure DeleteCampaignItems()
    var
        CampaignItem: Record ARD_CampaignItem;
    begin
        CampaignItem.SetRange("ARD_CampaignNo.", Rec."ARD_No.");
        if CampaignItem.FindSet() then
            CampaignItem.DeleteAll(true);
    end;

    local procedure ParsePostalCodes(PostalCodesJSON: Text): Text
    var
        CampaignPostalCode: Record ARD_CampaignPostalCode;
        RegionName: Text;
        PostalCode: Text;
        JObject: JsonObject;
        JPostalObject: JsonObject;
        JCodeArray: JsonArray;
        JCodeToken: JsonToken;
        JArray: JsonArray;
        JToken: JsonToken;
    begin
        DeleteCampaignPostalCodes();

        if not JObject.ReadFrom(PostalCodesJSON) then
            Error('Invalid JSON format.');

        if not JObject.Get('PostalCodes', JToken) then
            Error('PostalCodes field not found in JSON.');

        if not JToken.IsArray() then
            Error('PostalCodes field is not an array.');

        JArray := JToken.AsArray();

        foreach JToken in JArray do begin
            JPostalObject := JToken.AsObject();
            RegionName := JPostalObject.GetText('Region Name', true);
            JCodeArray := JPostalObject.GetArray('Postal Codes', true);

            foreach JCodeToken in JCodeArray do begin
                if not JCodeToken.IsValue() then
                    Error('Postal Codes should be an array of strings.');

                PostalCode := JCodeToken.AsValue().AsText();

                CampaignPostalCode.Init();
                CampaignPostalCode."ARD_CampaignNo." := Rec."ARD_No.";
                CampaignPostalCode.ARD_PostalCode := CopyStr(PostalCode, 1, 10); // Ensure Postal Code is within the defined length
                CampaignPostalCode.ARD_RegionName := CopyStr(RegionName, 1, 100); // Ensure Region Name is within the defined length
                CampaignPostalCode.Insert(true);
            end;
        end;
    end;
}
