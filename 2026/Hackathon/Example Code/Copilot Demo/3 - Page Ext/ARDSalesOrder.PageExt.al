pageextension 50001 ARD_SalesOrder extends "Sales Order Subform"
{
    actions
    {

        addbefore("&Line")
        {
            Action(GenerateRecommendations)
            {
                ApplicationArea = All;
                Caption = 'Generate Recommendations';
                ToolTip = 'Generate item recommendations using Dynamics 365 Copilot.';
                Image = Sparkle;

                /// <summary>
                /// Triggered when the action is executed. 
                /// Iterates through all sales lines related to the current sales order, accumulating the total length of their descriptions.
                /// If the accumulated description length exceeds 10,000 characters, adds the current sales line's description to the item recommendation prompt.
                /// Tracks the maximum line number among the sales lines.
                /// Sets up the item recommendation prompt page with the current document number and the maximum line number found.
                /// Opens the item recommendation prompt page and handles the result if the user confirms the action.
                /// </summary>
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";
                    ItemRecommendationPrompt: Page "ARD_ItemRecommendationPrompt";
                    MaxSalesLineCount: Integer;
                    DescriptionCount: Integer;
                begin
                    // Initialize counters
                    MaxSalesLineCount := 0;
                    DescriptionCount := 0;

                    // Filter sales lines for the current sales order
                    SalesLine.Setfilter("Document No.", '%1', Rec."Document No.");

                    // Iterate through all sales lines for the current document
                    if SalesLine.FindSet() then begin
                        repeat
                            // Accumulate the total length of descriptions
                            DescriptionCount += StrLen(SalesLine."Description");

                            // If the accumulated description length does not exceeds 10,000, add the current description to the prompt
                            if DescriptionCount <= 10000 then
                                ItemRecommendationPrompt.AddItemDescription(SalesLine."Description");

                            // Track the maximum line number
                            If SalesLine."Line No." > MaxSalesLineCount then
                                MaxSalesLineCount := SalesLine."Line No.";
                        until SalesLine.Next() = 0;
                    end;

                    // Set up the item recommendation prompt page with the document number and max line number
                    ItemRecommendationPrompt.SetSalesHeader(Rec."Document No.", MaxSalesLineCount);

                    // Open the item recommendation prompt page and handle the result if the user confirms
                    if ItemRecommendationPrompt.RunModal() = Action::OK then begin
                        // Handle confirmed action (add logic here if needed)
                    end;
                end;
            }
        }
    }
}
