// <summary>
// Executes the address generation process by interacting with the GenerateAddress object.
/// Updates the page caption, sets the user prompt, and attempts to generate an address
/// up to a maximum of 5 times. If successful, displays the result; otherwise, shows an error message.
// https://aardvarklabs.blog/2025/05/27/creating-data-driven-text-with-ai-in-business-central/
// </summary>
page 50002 ARDReminderPrompt
{
    ApplicationArea = All;
    Caption = 'Reminder Prompt';
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    PromptMode = Prompt;

    layout
    {
        area(prompt)
        {
            field(ResponseTone; ResponseTone)
            {
                Caption = 'Response Tone';
                ApplicationArea = All;
                ToolTip = 'Select the tone for the response.';
                ShowCaption = true;
                MultiLine = false;
                Editable = true;
            }
            field(ChatRequest; ChatRequest)
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;
                InstructionalText = 'Provide a additonal details on the customer.';

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }
        area(Content)
        {
            field(ReminderText; ReminderText)
            {
                Caption = 'Reminder Text';
                ApplicationArea = All;
                ToolTip = 'The generated reminder text.';
                ShowCaption = true;
                MultiLine = true;
                Editable = false;
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            // You can have custom behaviour for the main system actions in a PromptDialog page, such as generating a suggestion with copilot, regenerate, or discard the
            // suggestion. When you develop a Copilot feature, remember: the user should always be in control (the user must confirm anything Copilot suggests before any
            // change is saved).
            // This is also the reason why you cannot have a physical SourceTable in a PromptDialog page (you either use a temporary table, or no table).
            systemaction(Generate)
            {
                Caption = 'Generate';
                ToolTip = 'Generate Item Substitutions proposal with Dynamics 365 Copilot.';

                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
            systemaction(OK)
            {
                Caption = 'Confirm';
                ToolTip = 'Add selected Items to Substitutions.';
            }
            systemaction(Cancel)
            {
                Caption = 'Discard';
                ToolTip = 'Discard Items proposed by Dynamics 365 Copilot.';
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                ToolTip = 'Regenerate Item Substitutions proposal with Dynamics 365 Copilot.';
                trigger OnAction()
                begin
                    RunGeneration();
                end;
            }
        }
    }

    var
        GenerateReminderReminderText: Codeunit ARD_CopilotReminderGenerator;
        ChatRequest: Text;
        ReminderText: Text;
        ResponseTone: Option Friendly,Professional,Casual,Formal,Informative,Persuasive,Empathetic,Humorous,British,"space traveling droid";
        CustomerNo: Code[20];

    /// <summary>
    /// Executes the address generation process by interacting with the GenerateAddress object.
    /// Updates the page caption, sets the user prompt, and attempts to generate an address
    /// up to a maximum of 5 times. If successful, displays the result; otherwise, shows an error message.
    /// </summary>
    /// <remarks>
    /// The procedure uses a loop to retry the address generation process if the result is empty.
    /// It ensures that the process does not exceed 5 attempts to prevent infinite loops.
    /// </remarks>
    /// <exception cref="Error">
    /// Throws an error if the maximum number of attempts is reached without a successful result.
    /// </exception>
local procedure RunGeneration()
var
    InStr: InStream;
    Attempts: Integer;
    CustomerRec: Record Customer;
    CustomerLedgerEntry: Record "Cust. Ledger Entry";
    LastDocDate: Date;
begin

    CurrPage.Caption := ChatRequest;
    CustomerRec.Get(CustomerNo);
    CustomerLedgerEntry.SetFilter("Customer No.", '%1', CustomerRec."No.");
    CustomerLedgerEntry.SetFilter(Open, '%1', true);
    CustomerLedgerEntry.SetFilter("Document Type", '%1', CustomerLedgerEntry."Document Type"::Invoice);
    CustomerLedgerEntry.SetCurrentKey("Customer No.", "Document Type", "Document Date");
    CustomerLedgerEntry.SetAscending("Document Date", false);
    if CustomerLedgerEntry.FindFirst() then
        LastDocDate := CustomerLedgerEntry."Document Date"
    else
        LastDocDate := 0D;

    CustomerRec.CalcFields("Balance Due (LCY)");

    GenerateReminderReminderText.SetUserPrompt(ChatRequest, CustomerRec.Contact, Format(ResponseTone), CustomerRec."Balance Due (LCY)", LastDocDate);
    ReminderText := '';
    Attempts := 0;
    while (StrLen(ReminderText) = 0) AND (Attempts < 5) do begin
        if GenerateReminderReminderText.Run() then
            ReminderText := GenerateReminderReminderText.GetCompletionResult();
        Attempts += 1;
    end;

    if (Attempts < 5) then begin
        CurrPage.Update();
    end else
        Error('Something went wrong. Please try again. ' + GetLastErrorText());
end;

    procedure SetCustomer(No: Code[20])
    begin
        CustomerNo := No;
    end;

    procedure GetResult(): Text
    begin
        exit(ReminderText);
    end;
}
