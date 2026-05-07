page 50203 ARD_CopilotSettings
{
    ApplicationArea = All;
    Caption = 'AardvarkLabs Copilot Settings';
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "Integer";
    DataCaptionExpression = '';
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
    IsolatedStorageWrapper: Codeunit ARD_IsolatedStorageWrapper;
    Endpoint: Text;
    Deployment: Text;
    UserAPIKey: Text;
    
    trigger OnAfterGetRecord()
    begin
        UserAPIKey := '*****';
        GetSettings();
    end;

    local procedure GetSettings()
    begin
        Deployment := IsolatedStorageWrapper.GetDeployment();
    end;
}
