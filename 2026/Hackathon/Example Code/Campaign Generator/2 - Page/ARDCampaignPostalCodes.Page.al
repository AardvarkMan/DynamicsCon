page 50205 ARD_CampaignPostalCodes
{
    ApplicationArea = All;
    Caption = 'Campaign Postal Codes';
    PageType = ListPart;
    SourceTable = ARD_CampaignPostalCode;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ARD_PostalCode; Rec.ARD_PostalCode)
                {
                }
                field(ARD_RegionName; Rec.ARD_RegionName)
                {
                }
            }
        }
    }
}
