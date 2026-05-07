pageextension 50200 ARD_SalesOrder extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field(ARD_CampaignName; REC.ARD_CampaignName)
            {
                ApplicationArea = All;
                Caption = 'Campaign Name';
                ToolTip = 'Name of the AI Campaign associated with this Sales Order.';
                Editable = false;
            }
        }
    }
    
}
