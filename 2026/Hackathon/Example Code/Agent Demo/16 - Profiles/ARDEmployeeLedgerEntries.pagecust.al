namespace AardvarkLabs.AgentDemo;
using Microsoft.HumanResources.Payables;

pagecustomization ARD_EmployeeLedgerEntries customizes "Employee Ledger Entries"
{
    ClearLayout = true;
    ClearActions = true;
    
    AboutText = 'This page shows the employee ledger entries relevant to the cash flow agent.';
    Description = 'Employee Ledger Entries';

    layout
    {
        modify("Employee No.")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Amount")
        {
            Visible = true;
        }
        modify("Remaining Amount")
        {
            Visible = true;
        }
    }
}