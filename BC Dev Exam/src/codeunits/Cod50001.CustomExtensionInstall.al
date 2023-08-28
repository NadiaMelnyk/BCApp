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
        ReportName: Label './src/reportextensions/layouts/CustomerTop10ListModified.rdl';
    begin
        NavApp.GetCurrentModuleInfo(myAppInfo);
        if myAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then
            ReportLayoutSelectionMgmt.SetDefaultReportLayoutSelectionForCustomizedReports(ReportName);
    end;

    local procedure CreateNewSeriesForCustomerOrder()
    var
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        CustomerOrderNoSeriesCode: Label 'CUST-ORD';
        CustomerOrderNoSeriesDescription: Label 'Customer Orders';
        CustomerOrderNoSeriesStartingNo: Label 'CO00001';
        CustomerOrderNoSeriesEndingNo: Label 'CO99999';
        PostedCustomerOrderNoSeriesCode: Label 'P-CUST-ORD';
        PostedCustomerOrderNoSeriesDescription: Label 'Posted Customer Orders';
        PostedCustomerOrderNoSeriesStartingNo: Label 'PCO00001';
        PostedCustomerOrderNoSeriesEndingNo: Label 'PCO99999';
    begin
        if not SalesReceivableSetup.Get() then
            SalesReceivableSetup.Insert();

        if SalesReceivableSetup."Custom Order No. Series" = '' then begin
            SalesReceivableSetup."Custom Order No. Series" := GetNoSeries(CustomerOrderNoSeriesCode, CustomerOrderNoSeriesDescription, CustomerOrderNoSeriesStartingNo, CustomerOrderNoSeriesEndingNo);
            SalesReceivableSetup.Modify();
        end;

        if SalesReceivableSetup."Posted Cust Order No. Series" = '' then begin
            SalesReceivableSetup."Posted Cust Order No. Series" := GetNoSeries(PostedCustomerOrderNoSeriesCode, PostedCustomerOrderNoSeriesDescription, PostedCustomerOrderNoSeriesStartingNo, PostedCustomerOrderNoSeriesEndingNo);
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