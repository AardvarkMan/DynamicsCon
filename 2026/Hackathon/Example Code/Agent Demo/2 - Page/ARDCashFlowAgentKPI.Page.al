namespace AardvarkLabs.AgentDemo;

page 60001 "ARD_Cash Flow Agent KPI"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Cash Flow Agent Summary';
    SourceTable = ARD_CashFlowAgentKPI;
    Editable = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            cuegroup(KeyMetrics)
            {
                Caption = 'Key Performance Indicators';

                field("Last Run Date/Time"; Rec.LastRunDateTime)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        GetRelevantAgent();
    end;

    /// <summary>
    /// Retrieves the relevant agent's KPI record for display.
    /// This page is launched via IAgentMetadata.GetSummaryPageId(). The platform sets a filter on the
    /// "User Security ID" field before opening the page, so the source record may not be fully populated
    /// on open - the filter is evaluated here to resolve and load the correct record.
    /// </summary>
    local procedure GetRelevantAgent()
    var
        UserSecurityIDFilter: Text;
    begin
        if IsNullGuid(Rec."User Security ID") then begin
            UserSecurityIDFilter := Rec.GetFilter("User Security ID");
            if not Evaluate(Rec."User Security ID", UserSecurityIDFilter) then
                Error(AgentDoesNotExistErr);
        end;

        if not Rec.Get(Rec."User Security ID") then
            Rec.Insert();
    end;

    var
        AgentDoesNotExistErr: Label 'The agent does not exist. Please check the configuration.';
}
