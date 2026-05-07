codeunit 50202 ARD_IsolatedStorageWrapper
{
    SingleInstance = true;
    Access = Internal;

    var
        IsolatedStorageSecretKeyKeyLbl: Label 'CopilotSecret', Locked = true;
        IsolatedStorageDeploymentKeyLbl: Label 'CopilotDeployment', Locked = true;

    procedure GetSecretKey() SecretKey: SecretText
    var
        BlankSecret: SecretText;
    begin
        if IsolatedStorage.Get(IsolatedStorageSecretKeyKeyLbl, SecretKey) = false then SecretKey := BlankSecret;
    end;

    procedure GetDeployment() Deployment: Text
    begin
        if IsolatedStorage.Get(IsolatedStorageDeploymentKeyLbl, Deployment) = false then Deployment := '';
    end;

    procedure SetSecretKey(SecretKey: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageSecretKeyKeyLbl, SecretKey);
    end;

    procedure SetDeployment(Deployment: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageDeploymentKeyLbl, Deployment);
    end;
}