permissionset 50000 Ard_CopilotDemo
{
    Assignable = true;
    Permissions = tabledata ARD_CopilotItemRecommendations = RIMD,
        tabledata ARD_ResolutionNotes = RIMD,
        table ARD_CopilotItemRecommendations = X,
        table ARD_ResolutionNotes = X,
        codeunit ARDCopilotItemRecommendations = X,
        codeunit ARD_AddressMatchFinder = X,
        codeunit ARD_CopilotAddressCleanup = X,
        codeunit ARD_CopilotReminderGenerator = X,
        codeunit ARD_CopilotResolutionSummary = X,
        codeunit ARD_CopilotSetup = X,
        codeunit ARD_IsolatedStorageWrapper = X,
        page ARDReminderPrompt = X,
        page ARD_AddressPrompt = X,
        page ARD_CopilotSettings = X,
        page ARD_ItemRecommendationPrompt = X,
        page ARD_ItemRecommendations = X,
        page ARD_ResolutionNotes = X,
        page ARD_ValidateAddressPrompt = X;
}