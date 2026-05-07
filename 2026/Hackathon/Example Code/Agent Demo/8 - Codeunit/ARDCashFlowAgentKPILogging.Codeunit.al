namespace AardvarkLabs.AgentDemo;

codeunit 60003 ARD_CashFlowAgentKPILogging
{
    Access = Internal;
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;

    procedure UpdateKPI(AgentUserSecurityId: Guid)
    var
        AgentKPI: Record "ARD_CashFlowAgentKPI";
    begin
        if not AgentKPI.Get(AgentUserSecurityId) then begin
            AgentKPI.Init();
            AgentKPI."User Security ID" := AgentUserSecurityId;
            AgentKPI.Insert();
        end;

        AgentKPI.LastRunDateTime := CurrentDateTime();
        AgentKPI.Modify();
    end;
}