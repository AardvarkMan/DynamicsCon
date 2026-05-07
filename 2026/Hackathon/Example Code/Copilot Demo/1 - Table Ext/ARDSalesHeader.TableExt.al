tableextension 50000 ARD_SalesHeader extends "Sales Header"
{
    fields
    {
        field(50000; ARD_ResolutionNote; Blob)
        {
            Caption = 'Resolution Note';
            DataClassification = CustomerContent;
            ToolTip = 'Attach a resolution note to the sales order.';
        }
    }
}
