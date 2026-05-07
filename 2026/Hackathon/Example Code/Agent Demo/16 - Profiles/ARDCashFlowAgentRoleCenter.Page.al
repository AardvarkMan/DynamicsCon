namespace AardvarkLabs.AgentDemo;

using Microsoft.HumanResources.Payables;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;

page 60002 ARD_CashFlowAgentRoleCenter
{
    ApplicationArea = All;
    Caption = 'Cash Flow Agent Role Center';
    PageType = RoleCenter;

    actions
    {
        area(Embedding)
        {
            action(ARD_Customers)
            {
                Caption = 'Customers';
                ToolTip = 'View customer list and details';
                Image = Customer;
                RunObject = page "Customer List";
            }
            action(ARD_Vendors)
            {
                Caption = 'Vendors';
                ToolTip = 'View vendor list and details';
                Image = Vendor;
                RunObject = page "Vendor List";
            }
            action(ARD_EmployeeLedgerEntries)
            {
                Caption = 'Employee Ledger Entries';
                ToolTip = 'View employee ledger entries';
                Image = Employee;
                RunObject = page "Employee Ledger Entries";
            }

        }
    }
}
