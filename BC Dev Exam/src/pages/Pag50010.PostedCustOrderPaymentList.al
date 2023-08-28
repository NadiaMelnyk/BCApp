page 50010 "Posted Cust Order Payment List"
{
    ApplicationArea = All;
    Caption = 'Posted Customer Order Payments';
    PageType = List;
    SourceTable = "Posted Customer Order Payment";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Date field.';
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the G/L Account No. field.';
                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
            }
        }
    }
}
