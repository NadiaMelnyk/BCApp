codeunit 50001 "Custom Extension Install"
{
    SubType = Install;

    trigger OnInstallAppPerCompany()
    begin
        CreateNewSeriesForCustomerOrder();
    end;

    trigger OnInstallAppPerDatabase()
    var
        myAppInfo: ModuleInfo;
        ReportNameLbl: Label './src/reportextensions/layouts/CustomerTop10ListModified.rdlc';
    begin
        NavApp.GetCurrentModuleInfo(myAppInfo);
        if myAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then
            ReportLayoutSelectionMgmt.SetDefaultReportLayoutSelectionForCustomizedReports(ReportNameLbl);
    end;

    local procedure CreateNewSeriesForCustomerOrder()
    var
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        CustomerOrderNoSeriesCodeLbl: Label 'CUST-ORD';
        CustomerOrderNoSeriesDescriptionLbl: Label 'Customer Orders';
        CustomerOrderNoSeriesStartingNoLbl: Label 'CO00001';
        CustomerOrderNoSeriesEndingNoLbl: Label 'CO99999';
        PostedCustomerOrderNoSeriesCodeLbl: Label 'P-CUST-ORD';
        PostedCustomerOrderNoSeriesDescriptionLbl: Label 'Posted Customer Orders';
        PostedCustomerOrderNoSeriesStartingNoLbl: Label 'PCO00001';
        PostedCustomerOrderNoSeriesEndingNoLbl: Label 'PCO99999';
    begin
        if not SalesReceivableSetup.Get() then
            SalesReceivableSetup.Insert();

        if SalesReceivableSetup."Custom Order No. Series" = '' then begin
            SalesReceivableSetup."Custom Order No. Series" := GetNoSeries(CustomerOrderNoSeriesCodeLbl, CustomerOrderNoSeriesDescriptionLbl, CustomerOrderNoSeriesStartingNoLbl, CustomerOrderNoSeriesEndingNoLbl);
            SalesReceivableSetup.Modify();
        end;

        if SalesReceivableSetup."Posted Cust Order No. Series" = '' then begin
            SalesReceivableSetup."Posted Cust Order No. Series" := GetNoSeries(PostedCustomerOrderNoSeriesCodeLbl, PostedCustomerOrderNoSeriesDescriptionLbl, PostedCustomerOrderNoSeriesStartingNoLbl, PostedCustomerOrderNoSeriesEndingNoLbl);
            SalesReceivableSetup.Modify();
        end;
    end;

    local procedure GetNoSeries(SeriesCode: Code[20]; Description: Text[100]; StartingNo: Code[20]; EndingNo: Code[20]): Code[20];
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if NoSeries.Get(SeriesCode) then
            exit(SeriesCode);

        NoSeries.Init();
        NoSeries.Code := SeriesCode;
        NoSeries.Description := Description;
        NoSeries."Default Nos." := true;
        NoSeries."Manual Nos." := true;
        NoSeries.Insert();

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeries.Code;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine.Validate("Starting No.", StartingNo);
        NoSeriesLine.Validate("Ending No.", EndingNo);
        NoSeriesLine.Validate("Increment-by No.", 1);
        NoSeriesLine.Insert(true);
        exit(SeriesCode);
    end;

    var
        ReportLayoutSelectionMgmt: Codeunit "Report Layout Selection Mgmt.";
}