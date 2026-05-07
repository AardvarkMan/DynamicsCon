page 50006 ARD_ResolutionNotes
{
    ApplicationArea = All;
    Caption = 'Resolution Notes';
    PageType = ListPart;
    SourceTable = ARD_ResolutionNotes;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(ARD_Note; Rec.ARD_Note)
                {
                    MultiLine = true;
                }
            }
        }
    }
    actions
    {
        area(Prompting)
        {
            action(GenerateNote)
            {
                ApplicationArea = All;
                Caption = 'Generate Note';
                ToolTip = 'Generate a resolution note using Dynamics 365 Copilot.';
                Image = Sparkle;

                trigger OnAction()
                var
                    Notes: Record ARD_ResolutionNotes;
                    SalesHeader: Record "Sales Header";
                    CopilotResolutionSummary: Codeunit ARD_CopilotResolutionSummary;
                    ResolutionNotePrompt: Page ARD_ResolutionNotesPrompt;
                    NoteText: Text;
                    oStream: OutStream;
                begin
                    // Find the related Sales Header record using the Sales Header No. from the Resolution Notes
                    if SalesHeader.Get(Enum::"Sales Document Type"::Invoice, Rec."ARD_SalesHeaderNo.") then begin
                        Notes.SetRange("ARD_SalesHeaderNo.", Rec."ARD_SalesHeaderNo.");
                        if Notes.FindSet() then
                            repeat
                                ResolutionNotePrompt.AddNotes(Notes.ARD_Note);
                            until Notes.Next() = 0;

                        ResolutionNotePrompt.SetCustomer(SalesHeader."Bill-to Customer No.");

                        // Show the resolution note prompt to the user
                        if ResolutionNotePrompt.RunModal() = Action::OK then begin
                            // If the user confirmed, generate the resolution note
                            NoteText := ResolutionNotePrompt.GetResult();
                            // The note is likely to be larger than 2048 characters, so we use a stream to write it to a BLOB field
                            SalesHeader.ARD_ResolutionNote.CreateOutStream(oStream, TextEncoding::UTF16);
                            oStream.WriteText(NoteText, StrLen(NoteText));
                            SalesHeader.Modify();
                        end;
                    end;
                end;
            }
        }
    }
}
