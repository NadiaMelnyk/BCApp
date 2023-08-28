codeunit 50001 "Custom Extension Install"
{
    SubType = Install;

    trigger OnInstallAppPerCompany()
    begin
        CreateNewSeriesForCustomerOrder();
    end;

    trigger OnInstallAppPerDatabase()
    begin
        SetDefaultReportLayoutSelectionForCustomizedReports();
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

    procedure SetDefaultReportLayoutSelectionForCustomizedReports()
    var
        ReportLayoutList: Record "Report Layout List";
        ReportName: Label './src/reportextensions/layouts/CustomerTop10ListModified.rdl';
    begin
        ReportLayoutList.Reset();
        ReportLayoutList.SetRange("Report ID", 111);
        ReportLayoutList.SetFilter("Name", '%1', ReportName);
        if ReportLayoutList.FindFirst() then
            SetDefaultReportLayoutSelection(ReportLayoutList);
    end;

    procedure SetDefaultReportLayoutSelection(SelectedReportLayoutList: Record "Report Layout List")
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        EmptyGuid: Guid;
    begin
        // Add to TenantReportLayoutSelection table with an Empty Guid.
        AddLayoutSelection(SelectedReportLayoutList, EmptyGuid);

        // Add to the report layout selection table
        if ReportLayoutSelection.get(SelectedReportLayoutList."Report ID", CompanyName) then begin
            ReportLayoutSelection.Type := GetReportLayoutSelectionCorrespondingEnum(SelectedReportLayoutList);
            ReportLayoutSelection.Modify(true);
        end else begin
            ReportLayoutSelection."Report ID" := SelectedReportLayoutList."Report ID";
            ReportLayoutSelection."Company Name" := CompanyName;
            ReportLayoutSelection."Custom Report Layout Code" := '';
            ReportLayoutSelection.Type := GetReportLayoutSelectionCorrespondingEnum(SelectedReportLayoutList);
            ReportLayoutSelection.Insert(true);
        end;
    end;

    local procedure AddLayoutSelection(SelectedReportLayoutList: Record "Report Layout List"; UserId: Guid): Boolean
    var
        TenantReportLayoutSelection: Record "Tenant Report Layout Selection";
    begin
        TenantReportLayoutSelection.Init();
        TenantReportLayoutSelection."App ID" := SelectedReportLayoutList."Application ID";
        TenantReportLayoutSelection."Layout Name" := SelectedReportLayoutList."Name";
        TenantReportLayoutSelection."Report ID" := SelectedReportLayoutList."Report ID";
        TenantReportLayoutSelection."User ID" := UserId;
        if not TenantReportLayoutSelection.Insert(true) then
            TenantReportLayoutSelection.Modify(true);
    end;

    local procedure GetReportLayoutSelectionCorrespondingEnum(SelectedReportLayoutList: Record "Report Layout List"): Integer
    begin
        case SelectedReportLayoutList."Layout Format" of
            SelectedReportLayoutList."Layout Format"::RDLC:
                exit(0);
            SelectedReportLayoutList."Layout Format"::Word:
                exit(1);
            SelectedReportLayoutList."Layout Format"::Excel:
                exit(3);
            SelectedReportLayoutList."Layout Format"::Custom:
                exit(4);
        end
    end;
}