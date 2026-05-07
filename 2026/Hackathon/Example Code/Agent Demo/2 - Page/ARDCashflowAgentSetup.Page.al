namespace AardvarkLabs.AgentDemo;

using System.Agents;
using System.AI;

page 60000 "ARD_Cash Flow Agent Setup"
{
    PageType = ConfigurationDialog;
    Extensible = false;
    ApplicationArea = All;
    IsPreview = true;
    Caption = 'Set up Cash Flow Review Agent';
    InstructionalText = 'The Cash Flow Review Agent reviews and analyzes cash flow data to provide insights and recommendations.';
    AdditionalSearchTerms = 'Cash Flow Review Agent, Agent';
    SourceTable = ARD_CashflowAgentSetup;
    SourceTableTemporary = true;
    InherentEntitlements = X;
    InherentPermissions = X;

    layout
    {
        area(Content)
        {
            part(AgentSetupPart; "Agent Setup Part")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(OK)
            {
                Caption = 'Update';
                Enabled = IsUpdated;
                ToolTip = 'Apply the changes to the agent setup.';
            }

            systemaction(Cancel)
            {
                Caption = 'Cancel';
                ToolTip = 'Discards the changes and closes the setup page.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not AzureOpenAI.IsEnabled(Enum::"Copilot Capability"::"Cash Flow Agent") then
            Error(CashFlowAgentNotEnabledErr);

        IsUpdated := false;
        InitializePage();
    end;

    trigger OnAfterGetRecord()
    begin
        InitializePage();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IsUpdated := IsUpdated or CurrPage.AgentSetupPart.Page.GetChangesMade();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IsUpdated := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Agent: Codeunit Agent;
        CashFlowAgentSetup: Codeunit ARD_CashFlowAgentSetup;
    begin
        if CloseAction = CloseAction::Cancel then
            exit(true);

        CurrPage.AgentSetupPart.Page.GetAgentSetupBuffer(tempAgentSetupBuffer);

        if IsNullGuid(tempAgentSetupBuffer."User Security ID") then
            tempAgentSetupBuffer."Agent Metadata Provider" := Enum::"Agent Metadata Provider"::"Cash Flow Agent";

        if GlobalAgentSetup.GetChangesMade(tempAgentSetupBuffer) then begin
            Rec."User Security ID" := GlobalAgentSetup.SaveChanges(tempAgentSetupBuffer);

            Agent.SetInstructions(Rec."User Security ID", CashFlowAgentSetup.GetInstructions());
        end;

        CashFlowAgentSetup.EnsureSetupExists(Rec."User Security ID");
        exit(true);
    end;

    local procedure InitializePage()
    var
        AgentSetup: Codeunit "Agent Setup";
    begin
        if Rec.IsEmpty() then
            Rec.Insert();

        CurrPage.AgentSetupPart.Page.GetAgentSetupBuffer(tempAgentSetupBuffer);
        if tempAgentSetupBuffer.IsEmpty() then
            AgentSetup.GetSetupRecord(
                tempAgentSetupBuffer,
                Rec."User Security ID",
                Enum::"Agent Metadata Provider"::"Cash Flow Agent",
                AgentNameLbl + ' - ' + CompanyName(),
                DefaultDisplayNameLbl,
                AgentSummaryLbl);

        CurrPage.AgentSetupPart.Page.SetAgentSetupBuffer(tempAgentSetupBuffer);
        CurrPage.AgentSetupPart.Page.Update(false);

        IsUpdated := IsUpdated or CurrPage.AgentSetupPart.Page.GetChangesMade();
    end;

    var
        tempAgentSetupBuffer: Record "Agent Setup Buffer";
        GlobalAgentSetup: Codeunit "Agent Setup";
        AzureOpenAI: Codeunit "Azure OpenAI";
        IsUpdated: Boolean;
        CashFlowAgentNotEnabledErr: Label 'The Cash Flow Agent capability is not enabled in Copilot capabilities.\\Please enable the capability before setting up the agent.';
        AgentNameLbl: Label 'Cash Flow Agent';
        DefaultDisplayNameLbl: Label 'Cash Flow Agent';
        AgentSummaryLbl: Label 'Reviews and analyzes cash flow data to provide insights and recommendations.';
}
