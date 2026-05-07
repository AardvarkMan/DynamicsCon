pageextension 50000 ARD_CustomerCard extends "Customer Card"
{
    actions
    {
        addbefore(Email_Promoted)
        {
            actionref(GenerateAddress_Pro; GenerateAddress){}
            actionref(GenerateReminder_Pro; GenerateReminder){}
        }

        addbefore(Email)
        {
            action(GenerateAddress)
            {
                ApplicationArea = All;
                Caption = 'Generate Address';
                ToolTip = 'Generate address using Dynamics 365 Copilot.';
                Image = Sparkle;
                trigger OnAction()
                var
                    AddressPrompt: Page "ARD_AddressPrompt";
                    AddressDict: Dictionary of [Text, Text];
                begin
                    // Open the address prompt page when the action is clicked
                    if AddressPrompt.RunModal() = Action::OK then begin
                        AddressDict := AddressPrompt.GetResult();
                        if AddressDict.Count() > 0 then begin
                            // Loop through the dictionary and set the address fields
                            if AddressDict.ContainsKey('addressline1') then Rec."Address" := AddressDict.Get('addressline1');
                            if AddressDict.ContainsKey('addressline2') then Rec."Address 2" := AddressDict.Get('addressline2');
                            if AddressDict.ContainsKey('city') then Rec."City" := AddressDict.Get('city');
                            if AddressDict.ContainsKey('state') then Rec."Country/Region Code" := AddressDict.Get('state');
                            if AddressDict.ContainsKey('postalcode') then Rec."Post Code" := AddressDict.Get('postalcode');
                            if AddressDict.ContainsKey('phone') then Rec."Phone No." := AddressDict.Get('phone');
                            if AddressDict.ContainsKey('email') then Rec."E-Mail" := AddressDict.Get('email');
                        end;
                    end;
                end;
            }
            //Added in https://aardvarklabs.blog/2025/05/27/creating-data-driven-text-with-ai-in-business-central/
            action(GenerateReminder)
            {
                ApplicationArea = All;
                Caption = 'Generate Reminder';
                ToolTip = 'Generate reminder using Dynamics 365 Copilot.';
                Image = Sparkle;
                trigger OnAction()
                var
                    GenerateReminder: PAge ARDReminderPrompt;
                    ReminderText: Text;
                begin
                    // Open the reminder generation process
                    GenerateReminder.SetCustomer(Rec."No.");
                    if GenerateReminder.RunModal() = Action::OK then begin
                        ReminderText := GenerateReminder.GetResult();
                        if ReminderText <> '' then begin
                            // Display the generated reminder text
                            Message('Generated Reminder: %1', ReminderText);
                        end else begin
                            Error('No reminder text generated.');
                        end;
                    end;
                end;
            }
        }
    }
}
