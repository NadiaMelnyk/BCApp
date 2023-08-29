report 50000 "Customer Order"
{
    Caption = 'Customer Order';
    UsageCategory = None;
    ApplicationArea = All;
    DefaultRenderingLayout = DefaultLayout;

    dataset
    {
        dataitem(PostedCustomerOrderHeader; "Posted Customer Order Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Customer No.";

            column(ReportCaption; ReportCaptionLbl)
            {
            }
            column(PageNo; PageNoLbl)
            {
            }
            column(OrderNo; OrderNoLbl)
            {
            }
            column(PrintPayments; PrintPayments)
            {
            }
            column(No_PostedCustomerOrderHeader; "No.")
            {
            }
            column(DocumentDate_PostedCustomerOrderHeader; "Document Date")
            {
            }
            column(PostingDate_PostedCustomerOrderHeader; "Posting Date")
            {
            }
            column(CustomerNo_PostedCustomerOrderHeader; "Customer No.")
            {
            }
            column(CustomerName_PostedCustomerOrderHeader; "Customer Name")
            {
            }
            column(CreatedBy_PostedCustomerOrderHeader; "Created By")
            {
            }
            column(ExternalDocumentNo_PostedCustomerOrderHeader; "External Document No.")
            {
            }
            column(OrderAmount_PostedCustomerOrderHeader; "Order Amount")
            {
            }
            column(PaidAmount_PostedCustomerOrderHeader; "Paid Amount")
            {
            }
            column(PostedBy_PostedCustomerOrderHeader; "Posted By")
            {
            }
            column(No_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("No."))
            {
            }
            column(DocumentDate_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("Document Date"))
            {
            }
            column(PostingDate_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("Posting Date"))
            {
            }
            column(CustomerNo_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("Customer No."))
            {
            }
            column(CustomerName_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("Customer Name"))
            {
            }
            column(CreatedBy_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("Created By"))
            {
            }
            column(ExternalDocumentNo_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("External Document No."))
            {
            }
            column(OrderAmount_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("Order Amount"))
            {
            }
            column(PaidAmount_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("Paid Amount"))
            {
            }
            column(PostedBy_PostedCustomerOrderHeader_Caption; PostedCustomerOrderHeader.FieldCaption("Posted By"))
            {
            }
            column(TotalOrderAmount; TotalOrderAmountLbl)
            {
            }
            column(TotalPaidAmount; TotalPaidAmountLbl)
            {
            }
            column(Type_PostedCustomerOrderLine_Caption; PostedCustomerOrderLine.FieldCaption("Type"))
            {
            }
            column(No_PostedCustomerOrderLine_Caption; PostedCustomerOrderLine.FieldCaption("No."))
            {
            }

            column(Description_PostedCustomerOrderLine_Caption; PostedCustomerOrderLine.FieldCaption("Description"))
            {
            }
            column(Quantity_PostedCustomerOrderLine_Caption; PostedCustomerOrderLine.FieldCaption("Quantity"))
            {
            }
            column(UnitPrice_PostedCustomerOrderLine_Caption; PostedCustomerOrderLine.FieldCaption("Unit Price"))
            {
            }
            column(LineDiscount_PostedCustomerOrderLine_Caption; PostedCustomerOrderLine.FieldCaption("Line Discount %"))
            {
            }
            column(LineAmount_PostedCustomerOrderLine_Caption; PostedCustomerOrderLine.FieldCaption("Line Amount"))
            {
            }
            column(LocationCode_PostedCustomerOrderLine_Caption; PostedCustomerOrderLine.FieldCaption("Location Code"))
            {
            }
            column(PaymentDate_PostedCustomerOrderPayment_Caption; PostedCustomerOrderPayment.FieldCaption("Payment Date"))
            {
            }
            column(PaidAmount_PostedCustomerOrderPayment_Caption; PostedCustomerOrderPayment.FieldCaption("Paid Amount"))
            {
            }
            column(GLAccountNo_PostedCustomerOrderPayment_Caption; PostedCustomerOrderPayment.FieldCaption("G/L Account No."))
            {
            }
            dataitem(PostedCustomerOrderLine; "Posted Customer Order Line")
            {

                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = PostedCustomerOrderHeader;
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(Document_No_PostedCustomerOrderLine; "Document No.")
                {
                }
                column(Type_PostedCustomerOrderLine; "Type")
                {
                }
                column(No_PostedCustomerOrderLine; "No.")
                {
                }
                column(Description_PostedCustomerOrderLine; Description)
                {
                }
                column(Quantity_PostedCustomerOrderLine; Quantity)
                {
                }
                column(UnitPrice_PostedCustomerOrderLine; "Unit Price")
                {
                }
                column(LineDiscount_PostedCustomerOrderLine; "Line Discount %")
                {
                }
                column(LineAmount_PostedCustomerOrderLine; "Line Amount")
                {
                }
                column(LocationCode_PostedCustomerOrderLine; "Location Code")
                {
                }
            }
            dataitem(PostedCustomerOrderPayment; "Posted Customer Order Payment")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = PostedCustomerOrderHeader;
                DataItemTableView = SORTING("Document No.", "Payment Date", "Entry No.");
                column(Document_No_PostedCustomerOrderPayment; "Document No.")
                {
                }
                column(PaymentDate_PostedCustomerOrderPayment; "Payment Date")
                {
                }
                column(PaidAmount_PostedCustomerOrderPayment; "Paid Amount")
                {
                }
                column(GLAccountNo_PostedCustomerOrderPayment; "G/L Account No.")
                {
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Options';
                    field(PrintPayments; PrintPayments)
                    {
                        Caption = 'Print Payments';
                        ApplicationArea = All;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            PrintPayments := true;
        end;
    }

    rendering
    {
        layout(DefaultLayout)
        {
            Caption = 'Default Layout';
            Type = RDLC;
            LayoutFile = './src/reports/layouts/CustomerOrder.rdlc';
        }
    }

    var
        PrintPayments: Boolean;
        ReportCaptionLbl: Label 'Customer Order';
        OrderNoLbl: Label 'Order';
        PageNoLbl: Label 'Page';
        TotalOrderAmountLbl: Label 'Total Amount';
        TotalPaidAmountLbl: Label 'Total Paid';


}