namespace AardvarkLabs.AgentDemo;

using Microsoft.HumanResources.Payables;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Customer;

permissionset 60000 ARD_CashFlowAgent
{
    Assignable = true;
    Caption = 'Cash Flow Agent Permissions', MaxLength = 30;
    Permissions =
        page "Customer List" = X,
        page "Vendor List" = X,
        page "Employee Ledger Entries" = X,
        page "ARD_Cash Flow Agent KPI" = X,
        page ARD_CashFlowAgentRoleCenter = X,
        codeunit ARD_CashFlowAgentSetup = X,
        codeunit ARD_CashFlowAgentMetadata = X,
        codeunit ARD_CashFlowAgentKPILogging = X,
        codeunit ARD_CashFlowAgentFactory = X,
        table ARD_CashFlowAgentKPI = X,
        tabledata ARD_CashFlowAgentKPI = RIMD,
        table ARD_CashflowAgentSetup = X,
        tabledata ARD_CashflowAgentSetup = RIMD,
        table Customer = X,
        tabledata Customer = R,
        table Vendor = X,
        tabledata Vendor = R,
        table "Employee Ledger Entry" = X,
        tabledata "Employee Ledger Entry" = R;
}
