namespace AardvarkLabs.AgentDemo;

using System.Agents;
using System.Reflection;
using System.Security.AccessControl;

codeunit 60000 ARD_CashFlowAgentSetup
{
    Access = Internal;

    procedure TryGetAgent(var AgentUserSecurityId: Guid): Boolean
    var
        CashFlowAgentSetupRec: Record ARD_CashflowAgentSetup;
    begin
        if CashFlowAgentSetupRec.FindFirst() then begin
            AgentUserSecurityId := CashFlowAgentSetupRec."User Security ID";
            exit(true);
        end;

        exit(false);
    end;

    procedure GetInitials(): Text[4]
    begin
        exit(AgentInitialsLbl);
    end;

    procedure GetSetupPageId(): Integer
    begin
        exit(Page::"ARD_Cash Flow Agent Setup");
    end;

    procedure GetSummaryPageId(): Integer
    begin
        exit(Page::"ARD_Cash Flow Agent KPI");
    end;

    procedure EnsureSetupExists(UserSecurityID: Guid)
    var
        CashFlowAgentSetupRec: Record ARD_CashflowAgentSetup;
    begin
        if not CashFlowAgentSetupRec.Get(UserSecurityID) then begin
            CashFlowAgentSetupRec."User Security ID" := UserSecurityID;
            CashFlowAgentSetupRec.Insert();
        end;
    end;

    [NonDebuggable]
    procedure GetInstructions(): SecretText
    var
        Instructions: Text;
    begin
        Instructions := NavApp.GetResourceAsText('Instructions/InstructionsV1.txt');
        exit(Instructions);
    end;
    
    procedure GetDefaultProfile(var TempAllProfile: Record "All Profile" temporary)
    var
        CurrentModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(CurrentModuleInfo);
        //This should use the CurrentModuleInfo.Id not the BaseApplicationAppIdTok, but we aren't creating our own profiles, so this should be the base application id.
        Agent.PopulateDefaultProfile(DefaultProfileTok, BaseApplicationAppIdTok, TempAllProfile);
    end;

    procedure GetDefaultAccessControls(var TempAccessControlBuffer: Record "Access Control Buffer" temporary)
    begin
        Clear(TempAccessControlBuffer);
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := BaseApplicationAppIdTok;
        TempAccessControlBuffer."Role ID" := D365ReadPermissionSetTok;
        TempAccessControlBuffer.Insert();

        TempAccessControlBuffer.Init();
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := BaseApplicationAppIdTok;
        TempAccessControlBuffer."Role ID" := D365SalesPermissionSetTok;
        TempAccessControlBuffer.Insert();

        TempAccessControlBuffer.Init();
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := BaseApplicationAppIdTok;
        TempAccessControlBuffer."Role ID" := D365PayableAgentPermissionSetTok;
        TempAccessControlBuffer.Insert();

        TempAccessControlBuffer.Init();
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := BaseApplicationAppIdTok;
        TempAccessControlBuffer."Role ID" := D365ReceivableAgentPermissionSetTok;
        TempAccessControlBuffer.Insert();

        TempAccessControlBuffer.Init();
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := BaseApplicationAppIdTok;
        TempAccessControlBuffer."Role ID" := D365AccountantAgentPermissionSetTok;
        TempAccessControlBuffer.Insert();
    end;

    var
        Agent: Codeunit Agent;
        DefaultProfileTok: Label 'BUSINESS MANAGER', Locked = true;
        AgentInitialsLbl: Label 'CF', MaxLength = 4;
        BaseApplicationAppIdTok: Label '437dbf0e-84ff-417a-965d-ed2bb9650972', Locked = true;
        D365ReadPermissionSetTok: Label 'D365 READ', Locked = true;
        D365SalesPermissionSetTok: Label 'D365 SALES', Locked = true;
        D365PayableAgentPermissionSetTok: Label 'D365 ACC. PAYABLE', Locked = true;
        D365ReceivableAgentPermissionSetTok: Label 'D365 ACC. RECEIVABLE', Locked = true;
        D365AccountantAgentPermissionSetTok: Label 'D365 ACCOUNTANTS', Locked = true;

}