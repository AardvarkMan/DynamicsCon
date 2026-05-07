namespace AardvarkLabs.AgentDemo;
using Microsoft.Purchases.Vendor;

pagecustomization ARD_VendorList customizes "Vendor List"
{
    ClearLayout = true;
    ClearActions = true;

    AboutText = 'This page shows the vendors relevant to the cash flow agent.';
    Description = 'Vendor List';

    layout
    {
        modify("No.")
        {
            Visible = true;
        }
        modify(Name)
        {
            Visible = true;
        }
        modify("Balance (LCY)")
        {
            Visible = true;
        }
    }
}