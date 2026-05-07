codeunit 50200 ARD_CopilotSetup
{
    Subtype = Install;
    InherentEntitlements = X;
    InherentPermissions = X;
    Access = Internal;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        EnvironmentInfo: Codeunit "Environment Information";
        CopilotCapability: Codeunit "Copilot Capability";
        LearnMoreUrlTxt: Label 'https://aardvarklabs.blog', Locked = true;
    begin
        // Verify that environment in a Business Central online environment
        if EnvironmentInfo.IsSaaSInfrastructure() then
            // Register capability 
            if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Campaign Manager") then
                CopilotCapability.RegisterCapability(
                Enum::"Copilot Capability"::"Campaign Manager",
                Enum::"Copilot Availability"::Preview,
                Enum::"Copilot Billing Type"::"Microsoft Billed",
                LearnMoreUrlTxt);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Copilot AI Capabilities", 'OnRegisterCopilotCapability', '', false, false)]
    local procedure OnRegisterCopilotCapability()
    begin
        RegisterCapability();
    end;
}