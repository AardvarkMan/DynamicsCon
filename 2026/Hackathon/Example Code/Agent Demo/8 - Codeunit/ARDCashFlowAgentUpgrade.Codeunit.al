namespace AardvarkLabs.AgentDemo;

using System.Agents;
using System.AI;
using System.Security.AccessControl;

codeunit 60005 ARD_CashFlowAgentUpgrade
{
    Subtype = Upgrade;
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;

    trigger OnUpgradePerDatabase()
    var
        AgentSetupRec: Record ARD_CashflowAgentSetup;
    begin

        if not AgentSetupRec.FindSet() then
            exit;

        repeat
            InstallAgent(AgentSetupRec);
        until AgentSetupRec.Next() = 0;
    end;

    local procedure InstallAgent(var AgentSetupRec: Record ARD_CashflowAgentSetup)
    begin
        InstallAgentInstructions(AgentSetupRec);
    end;

    local procedure InstallAgentInstructions(var AgentSetupRec: Record ARD_CashflowAgentSetup)
    var
        Agent: Codeunit Agent;
        AgentSetup: Codeunit ARD_CashFlowAgentSetup;
    begin
        Agent.SetInstructions(AgentSetupRec."User Security ID", AgentSetup.GetInstructions());
    end;
}
