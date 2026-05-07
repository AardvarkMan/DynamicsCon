table 50000 "ARD_CopilotItemRecommendations"
{
    Caption = 'Copilot Item Recommendations';
    DataClassification = CustomerContent;
    TableType = Temporary;
    fields
    {
        field(1; "ARD_No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Unique identifier for the Item Recommendation.';
        }
        field(2; ARD_Description; Text[100])
        {
            Caption = 'Description';
            ToolTip = 'Description of the Item Recommendation.';
        }
        field(3; ARD_Select; Boolean)
        {
            Caption = 'Select';
            ToolTip = 'Indicates whether the Item Recommendation is selected for further processing.';
            InitValue = false;
        }
        field(4; ARD_Quantity; Decimal)
        {
            Caption = 'Quantity';
            ToolTip = 'Quantity of the Item Recommendation.';
            InitValue = 1;
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
