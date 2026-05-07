codeunit 50002 ARD_IsolatedStorageWrapper
{
    SingleInstance = true;
    Access = Internal;

    var
        IsolatedStorageSecretKeyKey: Label 'CopilotSecret', Locked = true;
        IsolatedStorageDeploymentKey: Label 'CopilotDeployment', Locked = true;
        IsolatedStorageEndpointKey: Label 'CopilotEndpoint', Locked = true;
        IsolatedStorageUseManagedResources: Label 'CopilotUseManagedResources', Locked = true;
        IsolatedStorageAOAIAccountName: Label 'AOAIAccountName', Locked = true;

   procedure GetSecretKey() SecretKey: SecretText
    var
        BlankSecret: SecretText;
    begin
        BlankSecret := SecretStrSubstNo('');
        if IsolatedStorage.Get(IsolatedStorageSecretKeyKey, SecretKey) = false then SecretKey := BlankSecret;
    end;

    procedure GetDeployment() Deployment: Text
    begin
        if IsolatedStorage.Get(IsolatedStorageDeploymentKey, Deployment) = false then Deployment := '';
    end;

    procedure GetEndpoint() Endpoint: Text
    begin
        if IsolatedStorage.Get(IsolatedStorageEndpointKey, Endpoint) = false then Endpoint := '';
    end;

    // Added the Account Name to take advantage of the Managed Resource Authorization
    procedure GetAOAIAccountName() AOAIAccountName: Text
    begin
        if IsolatedStorage.Get(IsolatedStorageAOAIAccountName, AOAIAccountName) = false then AOAIAccountName := '';
    end;

    procedure SetSecretKey(SecretKey: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageSecretKeyKey, SecretKey);
    end;

    procedure SetDeployment(Deployment: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageDeploymentKey, Deployment);
    end;

    procedure SetEndpoint(Endpoint: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageEndpointKey, Endpoint);
    end;

    // Added the UseManagedResources to take advantage of the Managed Resource Authorization
    procedure GetUseManagedResources(): Boolean
    var
        UseManagedResourcesText: Text;
    begin
        if IsolatedStorage.Get(IsolatedStorageUseManagedResources, UseManagedResourcesText) then
            exit(UseManagedResourcesText = '1');
        exit(false);
    end;

    // Added the UseManagedResources to take advantage of the Managed Resource Authorization
    procedure SetUseManagedResources(UseManagedResources: Boolean)
    begin
        if UseManagedResources then
            IsolatedStorage.Set(IsolatedStorageUseManagedResources, '1')
        else
            IsolatedStorage.Set(IsolatedStorageUseManagedResources, '0');
    end;

    // Added the Account Name to take advantage of the Managed Resource Authorization
    procedure SetAOAIAccountName(AOAIAccountName: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageAOAIAccountName, AOAIAccountName);
    end;

}