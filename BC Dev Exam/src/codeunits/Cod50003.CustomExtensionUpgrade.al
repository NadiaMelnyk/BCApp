codeunit 50003 "Custom Extension Upgrade"
{
    Subtype = Upgrade;

    trigger OnCheckPreconditionsPerDatabase()
    var
        BaseAppId: Codeunit "BaseApp ID";
        Info: ModuleInfo;
    begin
        //The Custom Extension requires the Base Application version 20 or higher
        NavApp.GetModuleInfo(BaseAppId.Get(), Info);
        if Info.DataVersion.Major < 20 then
            Error('The Custom Extension requires the Base Application version 20 or higher.');
    end;

    trigger OnCheckPreconditionsPerCompany()
    var
        CustomerOrderPayment: Record "Customer Order Payment";
        EmptyLbl: Label '';
    begin
        //G/L Account No. must be not empty in the Customer Order Payment table
        CustomerOrderPayment.Reset();
        CustomerOrderPayment.SetFilter("G/L Account No.", '=%1', EmptyLbl);
        if not CustomerOrderPayment.IsEmpty() then
            Error('There are %1 payment(s) with empty G/L Account No. in the Customer Order Payment table in %2 company.', CustomerOrderPayment.Count, CompanyName);
    end;

    trigger OnUpgradePerDatabase()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        if UpgradeTag.HasUpgradeTag(OnUpgradePerDatabaseTagLbl) then
            exit;

        UpgradeCustomExtensionReportLayoutSelection();

        UpgradeTag.SetUpgradeTag(OnUpgradePerDatabaseTagLbl);
    end;

    trigger OnUpgradePerCompany()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        if UpgradeTag.HasUpgradeTag(OnUpgradePerCompanyTagLbl) then
            exit;

        UpgradeCustomExtensionFieldsAndTables();

        UpgradeTag.SetUpgradeTag(OnUpgradePerCompanyTagLbl);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure OnGetPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]]);
    begin
        PerCompanyUpgradeTags.Add(OnUpgradePerCompanyTagLbl);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerDatabaseUpgradeTags', '', false, false)]
    local procedure OnGetPerDatabaseUpgradeTags(var PerDatabaseUpgradeTags: List of [Code[250]]);
    begin
        PerDatabaseUpgradeTags.Add(OnUpgradePerDatabaseTagLbl);
    end;

    local procedure UpgradeCustomExtensionFieldsAndTables()
    var
        CustomerOrderLine: Record "Customer Order Line";
        CustomerOrderHeader: Record "Customer Order Header";
        Customer: Record Customer;
        EmptyLbl: Label '';
    begin
        //Set default location for non-posted Customer Order Line from Customer if Location Code on the line is empty
        CustomerOrderLine.Reset();
        CustomerOrderLine.SetRange("Location Code", '=%1', EmptyLbl);
        if CustomerOrderLine.FindSet(true) then
            repeat
                if CustomerOrderHeader.Get(CustomerOrderLine."Document No.") then
                    if Customer.Get(CustomerOrderHeader."Customer No.") then begin
                        CustomerOrderLine."Location Code" := Customer."Location Code";
                        CustomerOrderLine.Modify();
                    end;
            until CustomerOrderLine.Next() = 0;
    end;

    local procedure UpgradeCustomExtensionReportLayoutSelection()

    var
        myAppInfo: ModuleInfo;
        ReportNameLbl: Label './SalesReceivables/CustomerTop10List.rdlc';
    begin
        //Set standard layout as default in report layout selection for customized reports in the new version of the Custom Extension
        NavApp.GetCurrentModuleInfo(myAppInfo);
        if myAppInfo.AppVersion.Major = 2 then
            ReportLayoutSelectionMgmt.SetDefaultReportLayoutSelectionForCustomizedReports(ReportNameLbl);
    end;


    var
        ReportLayoutSelectionMgmt: Codeunit "Report Layout Selection Mgmt.";
        OnUpgradePerCompanyTagLbl: Label 'CustomeExtension-UpgradeToTheLowerVersionOfCustomExtension-OnUpgradePerCompany', Locked = true;
        OnUpgradePerDatabaseTagLbl: Label 'CustomeExtension-UpgradeToTheLowerVersionOfCustomExtension-OnUpgradePerDatabase', Locked = true;
}