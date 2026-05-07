pageextension 50002 ARD_SalesQuote extends "Sales Quote"
{
    actions
    {
        AddAfter(MakeOrder_Promoted)
        {
            actionref(ARD_ValidateAddressref; ARD_ValidateAddress)
            {
            }
        }
        Addafter(MakeOrder)
        {
            // Defines the 'Validate Address' action for the Sales Quote page extension.
            // This action allows users to validate the address of the Sales Quote using Dynamics 365 Copilot.
            action(ARD_ValidateAddress)
            {
            ApplicationArea = All;
            Caption = 'Validate Address';
            ToolTip = 'Validate the address of the Sales Quote using Dynamics 365 Copilot.';
            Image = SparkleFilled;

            trigger OnAction()
            var
                Customer: Record Customer;
                ShipToAddress: Record "Ship-to Address";
                ValidateAddressPrompt: Page "ARD_ValidateAddressPrompt";
            begin
                // Check if Ship-to Code is not specified
                if Rec."Ship-to Code" = '' then begin
                // Pre-populate the prompt page with the current Ship-to address
                ValidateAddressPrompt.SetCurrentAddress(
                    Rec."Ship-to Address",
                    Rec."Ship-to Address 2",
                    Rec."Ship-to City",
                    Rec."Ship-to County",
                    Rec."Ship-to Country/Region Code",
                    Rec."Ship-to Post Code"
                );

                // Add all related Ship-to addresses for the customer
                ShipToAddress.setfilter("Customer No.", '%1', Rec."Sell-to Customer No.");
                if ShipToAddress.FindSet() then begin
                    repeat
                    ValidateAddressPrompt.AddTestAddress(
                        ShipToAddress.Code,
                        ShipToAddress."Address",
                        ShipToAddress."Address 2",
                        ShipToAddress."City",
                        ShipToAddress."County",
                        ShipToAddress."Country/Region Code",
                        ShipToAddress."Post Code"
                    );
                    until ShipToAddress.Next() = 0;
                end;

                // Add the default customer address for validation
                if Customer.Get(Rec."Sell-to Customer No.") then begin
                    ValidateAddressPrompt.AddTestAddress(
                    'Default',
                    Customer."Address",
                    Customer."Address 2",
                    Customer."City",
                    Customer."County",
                    Customer."Country/Region Code",
                    Customer."Post Code"
                    );
                end;

                // Run the prompt page and handle OK action
                if ValidateAddressPrompt.RunModal() = Action::OK then begin
                    // No additional logic on OK
                end;
                end else
                // Prompt user to select a Ship-to Code before validating
                Message('Please select a Ship-to Code before validating the address.');
            end;
            }
        }
    }
}
