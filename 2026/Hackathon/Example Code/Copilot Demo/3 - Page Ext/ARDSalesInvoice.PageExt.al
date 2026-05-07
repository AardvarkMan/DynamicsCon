pageextension 50003 ARD_SalesInvoice extends "Sales Invoice"
{
    layout
    {
        addafter(SalesLines)
        {
            part(ResolutionNotes; ARD_ResolutionNotes)
            {
                ApplicationArea = All;
                SubPageLink = "ARD_SalesHeaderNo." = field("No.");
                Visible = true;
            }

            group(ResolutionNotesGroup)
            {
                Caption = 'Resolution Notes';
                field(ResolutionNotes_Text; ResolutionNotes)
                {
                    ApplicationArea = All;
                    Caption = 'Resolution Notes';
                    ToolTip = 'The generated resolution notes for this invoice.';
                    Editable = true;
                    MultiLine = true;
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;

                    Trigger OnValidate()
                    begin
                        SetRichText(ResolutionNotes);
                    end;
                }
            }
        }
    }

    var
        ResolutionNotes: Text;

    trigger OnAfterGetCurrRecord()
    begin
        ResolutionNotes := GetRichText();
    end;

    /// <summary>
    /// Retrieves the rich text value from the ARD_ResolutionNote BLOB field of the current record.
    /// </summary>
    /// <returns>
    /// The text content extracted from the ARD_ResolutionNote field, using UTF-16 encoding and line feed as separator.
    /// </returns>
    /// <remarks>
    /// Utilizes the "Type Helper" codeunit to read the BLOB as text and handle any field-specific errors.
    /// </remarks>
    procedure GetRichText(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        TextValue: Text;
        istream: InStream;
    begin
        Rec.CalcFields(ARD_ResolutionNote);
        Rec.ARD_ResolutionNote.CreateInStream(istream, TextEncoding::UTF16);
        TextValue := TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(istream, TypeHelper.LFSeparator(), Rec.FieldName(ARD_ResolutionNote));
        exit(TextValue);
    end;

    /// <summary>
    /// Sets the rich text value for the ARD_ResolutionNote field of the current record.
    /// </summary>
    /// <param name="NewValue">The new text value to be written as rich text.</param>
    /// <remarks>
    /// This procedure creates an OutStream for the ARD_ResolutionNote BLOB field using UTF-16 encoding,
    /// writes the provided text to the stream, and then modifies the record to save the changes.
    /// </remarks>
    procedure SetRichText(NewValue: Text)
    var
        oStream: OutStream;
    begin
        Rec.ARD_ResolutionNote.CreateOutStream(oStream, TextEncoding::UTF16);
        oStream.WriteText(NewValue, StrLen(NewValue));
        Rec.Modify();
    end;
}
