table 50202 ARD_CampaignPostalCode
{
    Caption = 'Campaign Postal Code';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "ARD_CampaignNo."; Integer)
        {
            Caption = 'Campaign No.';
            ToolTip = 'Unique identifier for the AI Campaign.';
            DataClassification = CustomerContent;
        }
        field(2; ARD_PostalCode; Text[10])
        {
            Caption = 'Postal Code';
            ToolTip = 'Postal code associated with the AI Campaign.';
            DataClassification = CustomerContent;
        }
        field(3; ARD_RegionName; Text[100])
        {
            Caption = 'Region Name';
            ToolTip = 'Name of the region associated with the postal code.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "ARD_CampaignNo.",ARD_PostalCode)
        {
            Clustered = true;
        }
    }
}
