tableextension 50001 Customer extends Customer //18
{
    fields
    {
        field(50000; "Total Cust Order Amount"; Decimal)
        {
            Caption = 'Total Customer Order Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Posted Customer Order Line"."Line Amount" where("Customer No." = field("No.")));
        }
        field(50001; "Total Paid Cust Order Amount"; Decimal)
        {
            Caption = 'Total Paid Customer Order Amount';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("Posted Customer Order Payment"."Paid Amount" where("Customer No." = field("No.")));
        }
    }
}
