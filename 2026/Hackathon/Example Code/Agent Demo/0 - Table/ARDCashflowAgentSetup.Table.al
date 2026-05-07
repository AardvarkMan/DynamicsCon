namespace AardvarkLabs.AgentDemo;

table 60000 ARD_CashflowAgentSetup
{
    Access = Internal;
    Caption = 'Cash Flow Review Agent Setup';
    DataClassification = CustomerContent;
    InherentEntitlements = RIMDX;
    InherentPermissions = RIMDX;
    ReplicateData = false;
    DataPerCompany = false;

    fields
    {
        // The platform uses a field named "User Security ID" to open the setup and summary pages
        // defined in IAgentMetadata. This field must exist with this exact name on the source table.
        field(1; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            ToolTip = 'Specifies the unique identifier for the user.';
            DataClassification = EndUserPseudonymousIdentifiers;
            Editable = false;
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
