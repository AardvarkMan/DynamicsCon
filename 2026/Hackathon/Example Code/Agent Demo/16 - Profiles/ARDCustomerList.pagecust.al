namespace AardvarkLabs.AgentDemo;

using Microsoft.Sales.Customer;

pagecustomization ARD_CustomerList customizes "Customer List"
{
    ClearLayout = true;
    ClearActions = true;

    AboutText = 'This page shows the customers relevant to the cash flow agent.';
    Description = 'Customer List';

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