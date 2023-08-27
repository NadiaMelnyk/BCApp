pageextension 50001 "Customer Details FactBox" extends "Customer Details FactBox" //9084
{
    layout
    {
        addlast(content)
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
    }
}