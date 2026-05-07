namespace AardvarkLabs.AgentDemo;

using Microsoft.CashFlow.Account;
using System.Agents;

pageextension 60000 ARD_CashFlowAccounts extends "Chart of Cash Flow Accounts"
{
    actions
    {
        addbefore("Indent Chart of Cash Flow Accounts_Promoted")
        {
            actionref(RecCashFlowAgentSummary; CashFlowAgentSummary){}
        }
        addbefore("Indent Chart of Cash Flow Accounts")
        {
            action(CashFlowAgentSummary)
            {
                Caption = 'Cash Flow Agent Summary';
                ToolTip = 'View a summary of the Cash Flow Agent performance.';
                Image = CashFlow;
                ApplicationArea = All;

                trigger OnAction()
                var
                    AgentTask: Record "Agent Task";
                    Agent: Codeunit Agent;
                    AgentTaskBuilder: Codeunit "Agent Task Builder";
                    AgentSetup: Codeunit ARD_CashFlowAgentSetup;
                    AgentKPI: Codeunit ARD_CashFlowAgentKPILogging;
                    AgentUserSecurityId: Guid;
                    TaskTitle: Text[150];
                    From: Text[250];
                    Message: Text;
                begin
                    if not AgentSetup.TryGetAgent(AgentUserSecurityId) then
                        Error(SVAgentDoesNotExistErr);

                    if not Agent.IsActive(AgentUserSecurityId) then
                        Error(SVAgentNotActiveErr);

                    Message := StrSubstNo(TaskMessageLbl);
                    TaskTitle := CopyStr(StrSubstNo(TaskTitleLbl), 1, MaxStrLen(TaskTitle));
                    From := CopyStr(UserId(), 1, MaxStrLen(From));

                    AgentKPI.UpdateKPI(AgentUserSecurityId);

                    AgentTask := AgentTaskBuilder.Initialize(AgentUserSecurityId, TaskTitle)
                        .AddTaskMessage(From, Message)
                        .Create();

                    Message(TaskAssignedMsg, AgentTask.ID);
                end;
            }
        }
    }
    var
        SVAgentDoesNotExistErr: Label 'The Cash Flow Agent has not been created.';
        SVAgentNotActiveErr: Label 'The Cash Flow Agent is not active.';
        TaskMessageLbl: Label 'Run and process Cash Flow Analysis.', Locked = true;
        TaskTitleLbl: Label 'Cash Flow Analysis';
        TaskAssignedMsg: Label 'Task %1 assigned successfully', Comment = '%1 = Task ID';
}
