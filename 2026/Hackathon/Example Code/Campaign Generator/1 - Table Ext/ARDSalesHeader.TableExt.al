tableextension 50200 ARD_SalesHeader extends "Sales Header"
{
    fields
    {
        field(50200; ARD_Campaign; Integer)
        {
            Caption = 'Campaign';
            DataClassification = CustomerContent;
        }
        field(50201; ARD_CampaignName; Text[50])
        {
            Caption = 'Campaign Name';
            FieldClass = FlowField;
            CalcFormula = lookup(ARD_Campaign.ARD_Name WHERe("ARD_No." = field(ARD_Campaign)));
        }
    }
}
