reportextension 50000 "Customer - Top 10 List" extends "Customer - Top 10 List" //111
{
    RDLCLayout = './src/reportextensions/layouts/CustomerTop10ListModified.rdl';

    dataset
    {
        add(Integer)
        {
            column(TotalCustOrderAmount; Customer."Total Cust Order Amount")
            {
            }
            column(TotalCustOrderAmount_Caption; TotalCustOrderAmount)
            {
            }
            column(TotalPaidCustOrderAmount; Customer."Total Paid Cust Order Amount")
            {
            }
            column(TotalPaidCustOrderAmount_Caption; Customer.FieldCaption("Total Paid Cust Order Amount"))
            {
            }
            column(SalespersonCode; Customer."Salesperson Code")
            {
                IncludeCaption = true;
            }
            column(ShowCustomerOrderAmount; ShowCustomerOrderAmount)
            {
            }
            column(ShowPaidCustomerOrderAmount; ShowPaidCustomerOrderAmount)
            {
            }
        }
        modify(Integer)
        {
            trigger OnAfterAfterGetRecord()
            begin
                Customer.CalcFields("Total Cust Order Amount", "Total Paid Cust Order Amount")
            end;
        }
    }
    requestpage
    {
        layout
        {
            addlast(Options)
            {
                field(ShowCustomerOrderAmount; ShowCustomerOrderAmount)
                {
                    Caption = 'Show Customer Order Amount';
                    ApplicationArea = All;
                }
                field(ShowPaidCustomerOrderAmount; ShowPaidCustomerOrderAmount)
                {
                    Caption = 'Show Paid Customer Order Amount';
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        TotalCustOrderAmount: Label 'Customer Order Amount';
        ShowCustomerOrderAmount: Boolean;
        ShowPaidCustomerOrderAmount: Boolean;
}
