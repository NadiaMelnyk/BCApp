pageextension 50000 "Customer Card" extends "Customer Card" //21
{
    layout
    {
        addlast(General)
        {
            field("Total Cust Order Amount"; Rec."Total Cust Order Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Customer Order Amount field.';
            }
            field("Total Paid Cust Order Amount"; Rec."Total Paid Cust Order Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Paid Customer Order Amount field.';
            }
        }

        moveafter("Credit Limit (LCY)"; "Balance (LCY)2", ExpectedCustMoneyOwed, TotalMoneyOwed)

        modify("Balance (LCY)2")
        {
            Caption = 'Money Owed - Current (moved)';
        }
        modify(ExpectedCustMoneyOwed)
        {
            Caption = 'Money Owed - Expected (moved)';
        }
        modify(TotalMoneyOwed)
        {
            Caption = 'Money Owed - Total (moved)';
        }
    }
}