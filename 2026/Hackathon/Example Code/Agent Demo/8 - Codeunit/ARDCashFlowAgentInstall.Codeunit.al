namespace AardvarkLabs.AgentDemo;

using System.Agents;
using System.AI;
using System.Security.AccessControl;

codeunit 60004 ARD_CashFlowAgentInstall
{
    Subtype = Install;
    Access = Internal;
    InherentEntitlements = X;
    InherentPermissions = X;

    trigger OnInstallAppPerDatabase()
    var
        AgentSetupRec: Record ARD_CashflowAgentSetup;
    begin
        RegisterCapability();

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

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        LearnMoreUrlTxt: Label 'https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/ai/ai-development-toolkit-sales-validation', Locked = true;
    begin
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Cash Flow Agent") then
            CopilotCapability.RegisterCapability(
            Enum::"Copilot Capability"::"Cash Flow Agent",
            Enum::"Copilot Availability"::Preview,
            "Copilot Billing Type"::"Microsoft Billed",
            LearnMoreUrlTxt);
    end;
}
