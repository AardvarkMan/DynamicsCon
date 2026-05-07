namespace AardvarkLabs.AgentDemo;

using Microsoft.Finance.RoleCenters;

profile ARD_CashFlowAgent
{
    Caption = 'Cash Flow Agent';
    Description = 'Agent that reviews cash flow and provides recommendations to the user.';
    Enabled = true;
    RoleCenter = ARD_CashFlowAgentRoleCenter;
    Customizations =
        ARD_EmployeeLedgerEntries,
        ARD_CustomerList,
        ARD_VendorList;
}