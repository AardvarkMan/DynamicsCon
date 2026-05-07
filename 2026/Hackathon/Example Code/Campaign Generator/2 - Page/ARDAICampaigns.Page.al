page 50200 ARD_AICampaigns
{
    ApplicationArea = All;
    Caption = 'AI Campaigns';
    PageType = List;
    SourceTable = ARD_Campaign;
    UsageCategory = Lists;
    CardPageId = ARD_AICampaign;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("ARD_No."; Rec."ARD_No.")
                {
                }
                field(ARD_Name; Rec.ARD_Name)
                {
                }
                field(ARD_StartDate; Rec.ARD_StartDate)
                {
                }
                field(ARD_EndDate; Rec.ARD_EndDate)
                {
                }
            }
        }
    }
}
