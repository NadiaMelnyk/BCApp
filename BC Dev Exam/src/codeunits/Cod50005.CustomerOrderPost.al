codeunit 50005 "Customer Order Post"
{
    TableNo = "Customer Order Header";

    trigger OnRun()
    var
        CustomerOrderHeader: Record "Customer Order Header";
    begin
        CustomerOrderHeader.Copy(Rec);
        Code(CustomerOrderHeader);
        Rec := CustomerOrderHeader;
    end;

    local procedure "Code"(var CustomerOrderHeader: Record "Customer Order Header")
    begin
        ConfirmPost(CustomerOrderHeader);
        if CustomerOrderHeader.FindSet() then
            repeat
                RunPost(CustomerOrderHeader);
                Commit();
            until CustomerOrderHeader.Next() = 0;
    end;

    local procedure ConfirmPost(CustomerOrderHeader: Record "Customer Order Header")
    var
        CustomerOrderPayment: Record "Customer Order Payment";
        ConfirmQuestion: Text;
        ConfirmQuestionFullyPaidLbl: Label 'Do you want to post %1 order?', Comment = '%1 = Order No.';
        ConfirmQuestionNotFullyPaidLbl: Label 'Order is not paid fully. Are you sure you want to post %1 order?', Comment = '%1 = Order No.';
        ConfirmQuestionSeveralDocumentsLbl: Label 'The number of orders that will be posted is %1. Do you want to continue?', Comment = '%1 = Order No.';
    begin
        if CustomerOrderHeader.Count > 1 then begin
            if not Confirm(ConfirmQuestionSeveralDocumentsLbl, true, CustomerOrderHeader.Count) then
                exit;
        end else begin
            CustomerOrderPayment.Reset();
            CustomerOrderPayment.SetRange("Document No.", CustomerOrderHeader."No.");
            CustomerOrderPayment.CalcSums("Paid Amount");

            CustomerOrderHeader.CalcFields("Order Amount");

            if CustomerOrderPayment."Paid Amount" = CustomerOrderHeader."Order Amount" then
                ConfirmQuestion := ConfirmQuestionFullyPaidLbl
            else
                ConfirmQuestion := ConfirmQuestionNotFullyPaidLbl;

            if not Confirm(ConfirmQuestion, true, CustomerOrderHeader."No.") then
                exit;
        end;
    end;

    local procedure RunPost(var CustomerOrderHeader: Record "Customer Order Header")
    begin
        RunCheckBeforePosting(CustomerOrderHeader);
        TransferDataToPostedTables(CustomerOrderHeader);
    end;

    local procedure RunCheckBeforePosting(CustomerOrderHeader: Record "Customer Order Header")
    var
        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
    begin
        CustomerOrderHeader.TestField("Customer No.");
        CustomerOrderHeader.TestField("Document Date");
        CustomerOrderHeader.TestField("Posting Date");
        CustomerOrderHeader.TestField("External Document No.");

        PostedCustomerOrderHeader.Reset();
        PostedCustomerOrderHeader.SetRange("External Document No.", CustomerOrderHeader."External Document No.");
        if PostedCustomerOrderHeader.FindFirst() then
            Error('Posted order %1 has the same value in %2 as current document. %2 must be unicue.', PostedCustomerOrderHeader."No.", PostedCustomerOrderHeader.FieldCaption("External Document No."));
    end;

    local procedure TransferDataToPostedTables(var CustomerOrderHeader: Record "Customer Order Header")
    var
        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
    begin
        TransferCustomOrderHeader(CustomerOrderHeader, PostedCustomerOrderHeader);
        TransferCustomOrderLines(CustomerOrderHeader, PostedCustomerOrderHeader);
        TransferCustomOrderPayments(CustomerOrderHeader, PostedCustomerOrderHeader);

        DeleteNonPostedData(CustomerOrderHeader);
    end;

    local procedure TransferCustomOrderHeader(CustomerOrderHeader: Record "Customer Order Header"; var PostedCustomerOrderHeader: Record "Posted Customer Order Header")
    var
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        PostedCustomerOrderHeader.Init();
        NoSeries.Get(CustomerOrderHeader."Posting No. Series");
        NoSeriesMgt.InitSeries(CustomerOrderHeader."Posting No. Series", PostedCustomerOrderHeader."No. Series", PostedCustomerOrderHeader."Posting Date", PostedCustomerOrderHeader."No.", PostedCustomerOrderHeader."No. Series");
        PostedCustomerOrderHeader.Insert();

        PostedCustomerOrderHeader.TransferFields(CustomerOrderHeader, false);
        PostedCustomerOrderHeader."Posted By" := CopyStr(UserId(), 1, MaxStrLen(PostedCustomerOrderHeader."Posted By"));
        PostedCustomerOrderHeader."Order No." := CustomerOrderHeader."No.";
        PostedCustomerOrderHeader.Modify();
    end;

    local procedure TransferCustomOrderLines(CustomerOrderHeader: Record "Customer Order Header"; PostedCustomerOrderHeader: Record "Posted Customer Order Header")
    var
        CustomerOrderLine: Record "Customer Order Line";
        PostedCustomerOrderLine: Record "Posted Customer Order Line";
    begin
        CustomerOrderLine.Reset();
        CustomerOrderLine.SetRange("Document No.", CustomerOrderHeader."No.");
        if CustomerOrderLine.FindSet() then
            repeat
                PostedCustomerOrderLine.Init();
                PostedCustomerOrderLine.TransferFields(CustomerOrderLine);
                PostedCustomerOrderLine."Document No." := PostedCustomerOrderHeader."No.";
                PostedCustomerOrderLine."Customer No." := PostedCustomerOrderHeader."Customer No.";
                PostedCustomerOrderLine.Insert();
            until CustomerOrderLine.Next() = 0;
    end;

    local procedure TransferCustomOrderPayments(CustomerOrderHeader: Record "Customer Order Header"; PostedCustomerOrderHeader: Record "Posted Customer Order Header")
    var
        CustomerOrderPayment: Record "Customer Order Payment";
        PostedCustomerOrderPayment: Record "Posted Customer Order Payment";
    begin
        CustomerOrderPayment.Reset();
        CustomerOrderPayment.SetRange("Document No.", CustomerOrderHeader."No.");
        if CustomerOrderPayment.FindSet() then
            repeat
                PostedCustomerOrderPayment.Init();
                PostedCustomerOrderPayment.TransferFields(CustomerOrderPayment);
                PostedCustomerOrderPayment."Document No." := PostedCustomerOrderHeader."No.";
                PostedCustomerOrderPayment."Customer No." := PostedCustomerOrderHeader."Customer No.";
                PostedCustomerOrderPayment.Insert();
            until CustomerOrderPayment.Next() = 0;
    end;

    local procedure DeleteNonPostedData(var CustomerOrderHeader: Record "Customer Order Header")
    begin
        CustomerOrderHeader.DeleteLines();
        CustomerOrderHeader.DeletePayments();
        CustomerOrderHeader.Delete();
    end;



    procedure SetAndPostPaymentAfterPosting(PostedCustomerOrderHeader: Record "Posted Customer Order Header")
    var
        CustomerOrderPayment: Record "Customer Order Payment";
        PostedCustomerOrderPayment: Record "Posted Customer Order Payment";
    begin
        CustomerOrderPayment.Reset();
        CustomerOrderPayment.SetRange("Document No.", PostedCustomerOrderHeader."No.");
        if CustomerOrderPayment.FindSet() then
            repeat
                PostedCustomerOrderPayment.Init();
                PostedCustomerOrderPayment.TransferFields(CustomerOrderPayment);
                PostedCustomerOrderPayment."Document No." := PostedCustomerOrderHeader."No.";
                PostedCustomerOrderPayment."Customer No." := PostedCustomerOrderHeader."Customer No.";
                PostedCustomerOrderPayment.Insert();

                CustomerOrderPayment.Delete();
            until CustomerOrderPayment.Next() = 0;
    end;
}
