namespace AardvarkLabs.AgentDemo;

using System.Agents;

codeunit 60002 ARD_CashFlowAgentMetadata implements IAgentMetadata
{
    
    Access = Internal;

    procedure GetInitials(AgentUserId: Guid): Text[4]
    begin
        exit(AgentSetup.GetInitials());
    end;

    procedure GetSetupPageId(AgentUserId: Guid): Integer
    begin
        exit(AgentSetup.GetSetupPageId());
    end;

    procedure GetSummaryPageId(AgentUserId: Guid): Integer
    begin
        exit(AgentSetup.GetSummaryPageId());
    end;

    procedure GetAgentTaskMessagePageId(AgentUserId: Guid; MessageId: Guid): Integer
    begin
        exit(Page::"Agent Task Message Card");
    end;

    procedure GetAgentAnnotations(AgentUserId: Guid; var Annotations: Record "Agent Annotation")
    begin
        Clear(Annotations);
    end;

    var
        AgentSetup: Codeunit ARD_CashFlowAgentSetup;
}
