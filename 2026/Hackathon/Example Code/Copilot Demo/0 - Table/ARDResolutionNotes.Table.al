table 50001 ARD_ResolutionNotes
{
    Caption = 'Resolution Notes';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "ARD_No."; Integer)
        {
            Caption = 'No.';
            ToolTip = 'Unique identifier for the Resolution Note.';
            AutoIncrement = true;
        }
        field(2; "ARD_SalesHeaderNo."; Code[20])
        {
            Caption = 'Sales Header No.';
            ToolTip = 'Unique identifier for the Sales Header.';
        }
        field(3; ARD_Note; Text[2048])
        {
            Caption = 'Note';
            ToolTip = 'Detailed description of the Resolution Note.';
        }
    }
    keys
    {
        key(PK; "ARD_No.", "ARD_SalesHeaderNo.")
        {
            Clustered = true;
        }
    }
}
