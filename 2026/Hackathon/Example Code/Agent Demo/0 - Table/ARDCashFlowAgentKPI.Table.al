namespace AardvarkLabs.AgentDemo;

table 60001 ARD_CashFlowAgentKPI
{
    Access = Internal;
    Caption = 'Cash Flow Agent KPI';
    DataClassification = CustomerContent;
    InherentEntitlements = RIMDX;
    InherentPermissions = RIMDX;
    ReplicateData = false;
    DataPerCompany = false;

    fields
    {
        // This field is part of the IAgentMetadata.GetSummaryPageId() contract.
        // The platform filters on "User Security ID" when opening the summary page,
        // so it must be the primary key of this table.
        field(1; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            ToolTip = 'Specifies the unique identifier for the agent user.';
            DataClassification = EndUserPseudonymousIdentifiers;
            Editable = false;
        }
        field(2; LastRunDateTime; DateTime)
        {
            Caption = 'Last Run Date/Time';
            ToolTip = 'Specifies the date and time when the agent was last run.';
            DataClassification = SystemMetadata;
            Editable = true;
        }
    }
    keys
    {
        key(Key1; "User Security ID")
        {
            Clustered = true;
        }
    }
}