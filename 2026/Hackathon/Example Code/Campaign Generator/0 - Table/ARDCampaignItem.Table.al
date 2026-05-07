table 50201 ARD_CampaignItem
{
    Caption = 'Campaign Item';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "ARD_CampaignNo."; Integer)
        {
            Caption = 'Campaign No.';
            ToolTip = 'Unique identifier for the AI Campaign.';
            DataClassification = CustomerContent;
        }
        field(2; ARD_CampaignName; Text[50])
        {
            Caption = 'Campaign Name';
            FieldClass = FlowField;
            CalcFormula = lookup(ARD_Campaign.ARD_Name WHERe("ARD_No." = field("ARD_CampaignNo.")));
        }
        field(3; "ARD_ItemNo."; Code[20])
        {
            Caption = 'Item No.';
            ToolTip = 'Unique identifier for the item in the AI Campaign.';
            DataClassification = CustomerContent;
            TableRelation = Item;
        }
        field(4; ARD_ItemName; Text[100])
        {
            Caption = 'Item Name';
            ToolTip = 'Name of the item in the AI Campaign.';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("ARD_ItemNo.")));
        }
    }
    keys
    {
        key(PK; "ARD_CampaignNo.", "ARD_ItemNo.")
        {
            Clustered = true;
        }
    }
}
