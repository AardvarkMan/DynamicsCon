namespace AardvarkLabs.AgentDemo;

using System.Agents;
using System.AI;
using System.Reflection;
using System.Security.AccessControl;

codeunit 60001 ARD_CashFlowAgentFactory implements IAgentFactory
{
    
    Access = Internal;

    procedure GetDefaultInitials(): Text[4]
    begin
        exit(AgentSetup.GetInitials());
    end;

    procedure GetFirstTimeSetupPageId(): Integer
    begin
        exit(AgentSetup.GetSetupPageId());
    end;

    procedure ShowCanCreateAgent(): Boolean
    var
        AgentSetupRec: Record ARD_CashflowAgentSetup;
    begin
        exit(AgentSetupRec.IsEmpty());
    end;

    procedure GetCopilotCapability(): Enum "Copilot Capability"
    begin
        exit("Copilot Capability"::"Cash Flow Agent");
    end;

    procedure GetDefaultProfile(var TempAllProfile: Record "All Profile" temporary)
    begin
        AgentSetup.GetDefaultProfile(TempAllProfile);
    end;

    procedure GetDefaultAccessControls(var TempAccessControlTemplate: Record "Access Control Buffer" temporary)
    begin
        AgentSetup.GetDefaultAccessControls(TempAccessControlTemplate);
    end;

    var
        AgentSetup: Codeunit ARD_CashFlowAgentSetup;
    
}
