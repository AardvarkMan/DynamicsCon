table 50200 ARD_Campaign
{
    Caption = 'AI Campaign';
    DataClassification = ToBeClassified;
    DataCaptionFields = ARD_Name;
    
    fields
    {
        field(1; "ARD_No."; Integer)
        {
            Caption = 'No.';
            ToolTip = 'Unique identifier for the AI Campaign.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; ARD_Name; Text[50])
        {
            Caption = 'Name';
            ToolTip = 'Name of the AI Campaign.';
            DataClassification = CustomerContent;
        }
        field(3; ARD_StartDate; Date)
        {
            Caption = 'Start Date';
            ToolTip = 'Start date of the AI Campaign.';
            DataClassification = CustomerContent;
        }
        field(4; ARD_EndDate; Date)
        {
            Caption = 'End Date';
            ToolTip = 'End date of the AI Campaign.';
            DataClassification = CustomerContent;
        }
        field(5; ARD_MaxQuantity; Decimal)
        {
            Caption = 'Max Quantity';
            ToolTip = 'Maximum quantity of items in the AI Campaign.';
            DataClassification = CustomerContent;
        }
        field(6; ARD_CurrentQuantity; Decimal)
        {
            Caption = 'Current Quantity';
            ToolTip = 'Current quantity of items in the AI Campaign.';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "ARD_No.")
        {
            Clustered = true;
        }
    }
}
