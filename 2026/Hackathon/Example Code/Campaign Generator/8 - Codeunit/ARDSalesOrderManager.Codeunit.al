codeunit 50204 ARD_SalesOrderManager
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure "Release Sales Document_OnBeforeReleaseSalesDoc"(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean; var SkipCheckReleaseRestrictions: Boolean; SkipWhseRequestOperations: Boolean)
    begin
        ProcessSalesDocument(SalesHeader);
    end;

    local procedure ProcessSalesDocument(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        AICampaign: Record ARD_Campaign;
        AICampaignItem: Record ARD_CampaignItem;
        AICampaignPostalCode: Record ARD_CampaignPostalCode;
        Description: Text;
        DescriptionLbl: Label 'Free Item: %1', Comment = '%1 Label for free item description';
        LineNo: Integer;
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        AICampaignPostalCode.SetRange(ARD_PostalCode, SalesHEader."Ship-to Post Code");
        if AICampaignPostalCode.FindSet() then
            repeat
                AICampaign.Get(AICampaignPostalCode."ARD_CampaignNo.");

                if (AICampaign.ARD_EndDate <> 0D) AND (AICampaign."ARD_EndDate" < Today) then
                    continue;

                if (AICampaign.ARD_StartDate <> 0D) AND (AICampaign."ARD_StartDate" > Today) then
                    continue;

                if AICampaign.ARD_CurrentQuantity >= AICampaign.ARD_MaxQuantity then
                    continue;

                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetAscending("Line No.", false);
                if SalesLine.FindFirst() then
                    LineNo := SalesLine."Line No." + 10000
                else
                    LineNo := 10000;

                AICampaignItem.SetRange("ARD_CampaignNo.", AICampaign."ARD_No.");
                if AICampaignItem.FindSet() then begin
                    repeat
                        AICampaignItem.CalcFields("ARD_ItemName");
                        Description := StrSubstNo(DescriptionLbl, AICampaignItem.ARD_ItemName);

                        SalesLine.Init();
                        SalesLine.Validate("Document Type", SalesHeader."Document Type");
                        SalesLine.Validate("Document No.", SalesHeader."No.");
                        SalesLine.Validate("Line No.", LineNo);
                        SalesLine.Validate(Type, SalesLine.Type::Item);
                        SalesLine.Validate("No.", AICampaignItem."ARD_ItemNo.");
                        SalesLine.Description := CopyStr(Description, 1, 100); // Ensure Description is within the defined length
                        SalesLine.Validate(Quantity, 1);
                        SalesLine.Insert(true);

                        LineNo += 10000;
                    until AICampaignItem.Next() = 0;
                    
                    AICampaign.ARD_CurrentQuantity += 1;
                    AICampaign.Modify();

                    SalesHeader.ARD_Campaign := AICampaign."ARD_No.";
                    break; // Exit after processing the first valid campaign
                end;
            until AICampaignPostalCode.Next() = 0;
    end;

}
