page 50004 ARD_ItemRecommendations
{
    ApplicationArea = All;
    Caption = 'Item Recommendations';
    PageType = ListPart;
    SourceTable = ARD_CopilotItemRecommendations;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("ARD_No."; Rec."ARD_No.")
                {
                }
                field(ARD_Description; Rec.ARD_Description)
                {
                }
                field(ARD_Select; Rec.ARD_Select)
                {
                }
                field(ARD_Quantity; Rec.ARD_Quantity)
                {
                }
            }
        }
    }



    // Loads item recommendations from a temporary record into the page's source table.
    // Parameters:
    //   tmpItemRecommendation: Temporary record containing item recommendations to load.
    procedure Load(var tmpItemRecommendation: Record ARD_CopilotItemRecommendations temporary)
    begin
        // Clear existing records from the page's source table.
        Rec.Reset();
        Rec.DeleteAll();

        // Iterate through the temporary recommendations and insert them into the source table.
        tmpItemRecommendation.Reset();
        if tmpItemRecommendation.FindSet() then
            repeat
                Rec.Copy(tmpItemRecommendation, false);
                Rec.Insert();
            until tmpItemRecommendation.Next() = 0;

        // Refresh the page to show the new records.
        CurrPage.Update(false);
    end;


    // Adds the selected recommended items to the Sales Order as new Sales Lines.
    // Parameters:
    //   SalesHeaderNo: The document number of the Sales Order.
    //   MaxSalesLineCount: The current maximum line number in the Sales Order (used to avoid conflicts).
    procedure AddSelectedItems(SalesHeaderNo: Code[20]; MaxSalesLineCount: Integer)
    var
        SalesLine: Record "Sales Line";
        SelectedItemRecommendations: Record "ARD_CopilotItemRecommendations" temporary;
    begin
        // Copy all records from the current page to a temporary record variable.
        SelectedItemRecommendations.copy(Rec, true);
        // Filter to only those recommendations that are selected.
        SelectedItemRecommendations.SetRange(ARD_Select, true);
        if SelectedItemRecommendations.FindSet() then
            repeat
                // Increment line number to avoid conflicts.
                MaxSalesLineCount += 1000;
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesLine."Document Type"::Order);
                SalesLine.Validate("Document No.", SalesHeaderNo);
                SalesLine.Validate("Line No.", MaxSalesLineCount);
                SalesLine.Validate("Type", SalesLine."Type"::Item);
                SalesLine.Validate("No.", SelectedItemRecommendations."ARD_No.");
                SalesLine.Validate(Quantity, SelectedItemRecommendations.ARD_Quantity);
                // Insert the new Sales Line.
                SalesLine.Insert(true);
            until SelectedItemRecommendations.Next() = 0;
    end;
}
