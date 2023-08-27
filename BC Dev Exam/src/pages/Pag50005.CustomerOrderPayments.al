page 50005 "Customer Order Payments"
{
    Caption = 'Customer Order Payments';
    PageType = ListPlus;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(OrderAmount; OrderAmount)
                {
                    Caption = 'Order Amount';
                    ToolTip = 'Specifies the value of the Order Amount field.';
                    DecimalPlaces = 0 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        CustomOrderLine: Record "Customer Order Line";
                    begin
                        CustomOrderLine.Reset();
                        CustomOrderLine.SetRange("Document No.", CurrentDocumentNo);
                        Page.RunModal(0, CustomOrderLine);
                    end;
                }
                field(PaidAmount; PaidAmount)
                {
                    Caption = 'Paid Amount';
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                    DecimalPlaces = 0 : 5;
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        CustomOrderPayment: Record "Customer Order Payment";
                    begin
                        CustomOrderPayment.Reset();
                        CustomOrderPayment.SetRange("Document No.", CurrentDocumentNo);
                        Page.RunModal(0, CustomOrderPayment);
                    end;
                }
                field(RemainingAmount; RemainingAmount)
                {
                    Caption = 'Remaining Amount';
                    ToolTip = 'Specifies the value of the Remaining Amount field.';
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                }
            }
            Group("Current Payment")
            {
                field("Payment Date"; PaymentDate)
                {
                    ToolTip = 'Specifies the value of the Payment Date field.';
                }
                field("Paid Amount"; CurrentPaidAmount)
                {
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                    DecimalPlaces = 0 : 5;

                    trigger OnValidate()
                    begin
                        if RemainingAmount - CurrentPaidAmount < 0 then
                            Error('Current Payment Amount (%1) cannot be greater than the Remaining Amount (%2).', CurrentPaidAmount, RemainingAmount);
                    end;
                }
                field("G/L Account No."; GLAccountNo)
                {
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                    TableRelation = "G/L Account"."No.";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        OrderAmount := 0;
        PaidAmount := 0;
        RemainingAmount := 0;
        TotalInTransaction := 0;

        if CustomerOrderHeader.Get(CurrentDocumentNo) then
            CustomerOrderHeader.CalcFields("Order Amount");
        OrderAmount := CustomerOrderHeader."Order Amount";

        CustomerOrderPayment.Reset();
        CustomerOrderPayment.SetRange("Document No.", CurrentDocumentNo);
        CustomerOrderPayment.CalcSums("Paid Amount");
        PaidAmount := CustomerOrderPayment."Paid Amount";

        RemainingAmount := OrderAmount - PaidAmount;

        PaymentDate := WorkDate();
    end;

    trigger OnClosePage()
    var
        CustomerOrderPaymentToInsert: Record "Customer Order Payment";
    begin
        if CurrentPaidAmount = 0 then
            exit;

        if GLAccountNo = '' then
            Error('G/L Account No. must be specified.');

        CustomerOrderPaymentToInsert.Init();
        CustomerOrderPaymentToInsert.Insert();
        CustomerOrderPaymentToInsert."Document No." := CurrentDocumentNo;
        CustomerOrderPaymentToInsert."Payment Date" := PaymentDate;
        CustomerOrderPaymentToInsert."Paid Amount" := CurrentPaidAmount;
        CustomerOrderPaymentToInsert."G/L Account No." := GLAccountNo;
        CustomerOrderPaymentToInsert."Created By" := UserId();
        CustomerOrderPaymentToInsert.Modify();

    end;

    var
        CustomerOrderPayment: Record "Customer Order Payment";
        CustomerOrderHeader: Record "Customer Order Header";
        PaymentDate: Date;
        CurrentDocumentNo: Code[20];
        GLAccountNo: Code[20];
        OrderAmount: Decimal;
        PaidAmount: Decimal;
        CurrentPaidAmount: Decimal;
        RemainingAmount: Decimal;
        TotalInTransaction: Decimal;

    procedure SetCurrentOrderNo(DocumentNo: Code[20])
    begin
        CurrentDocumentNo := DocumentNo;
    end;
}