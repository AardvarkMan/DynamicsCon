page 50000 ARD_CopilotSettings
{
    ApplicationArea = All;
    Caption = 'AardvarkLabs Copilot Settings';
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Integer";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(UseManagedResources; UseManagedResources)
                {
                    ApplicationArea = All;
                    Caption = 'Use Managed Resources';
                    ToolTip = 'Enable to use managed resources for Copilot services.';
                    trigger OnValidate()
                    begin
                        IsolatedStorageWrapper.SetUseManagedResources(UseManagedResources);
                    end;
                }
                field(accountName; AccountName)
                {
                    ApplicationArea = All;
                    Caption = 'AOAI Account Name';
                    ToolTip = 'Enter the Azure OpenAI account name.';

                    trigger OnValidate()
                    begin
                        IsolatedStorageWrapper.SetAOAIAccountName(AccountName);
                    end;
                }

                field(Endpoint; Endpoint)
                {
                    ApplicationArea = All;
                    Caption = 'Endpoint';
                    ToolTip = 'Enter the endpoint URL for the Copilot service.';

                    trigger OnValidate()
                    begin
                        IsolatedStorageWrapper.SetEndpoint(Endpoint);
                    end;
                }
                field(Deployment; Deployment)
                {
                    ApplicationArea = All;
                    Caption = 'Deployment';
                    ToolTip = 'Enter the deployment name for the Copilot service.';

                    trigger OnValidate()
                    begin
                        IsolatedStorageWrapper.SetDeployment(Deployment);
                    end;
                }
                field(APIKey; UserAPIKey)
                {
                    ApplicationArea = All;
                    Caption = 'API Key';
                    ToolTip = 'Enter the API key for the Copilot service.';
                    MaskType = Concealed;
                    trigger OnValidate()
                    begin
                        IsolatedStorageWrapper.SetSecretKey(UserAPIKey);
                    end;
                }

            }
        }
    }

    var
        AccountName: Text;
        Endpoint: Text;
        Deployment: Text;
        UserAPIKey: Text;
        UseManagedResources: Boolean;
        IsolatedStorageWrapper: Codeunit ARD_IsolatedStorageWrapper;

    trigger OnAfterGetRecord()
    begin
        UserAPIKey := '*****';
        GetSettings();
    end;

    local procedure GetSettings()
    begin
        Deployment := IsolatedStorageWrapper.GetDeployment();
        Endpoint := IsolatedStorageWrapper.GetEndpoint();
        UseManagedResources := IsolatedStorageWrapper.GetUseManagedResources();
        AccountName := IsolatedStorageWrapper.GetAOAIAccountName();
    end;
}
