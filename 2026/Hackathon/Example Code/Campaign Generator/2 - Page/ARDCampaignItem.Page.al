page 50202 ARD_CampaignItem
{
    ApplicationArea = All;
    Caption = 'Campaign Item';
    PageType = ListPart;
    SourceTable = ARD_CampaignItem;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("ARD_ItemNo."; Rec."ARD_ItemNo.")
                {
                }
                field(ARD_ItemName; Rec.ARD_ItemName)
                {
                }
            }
        }
    }
}
