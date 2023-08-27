table 50002 "Customer Order Payment"
{
    Caption = 'Customer Order Payments';
    DataClassification = CustomerContent;
    LookupPageId = "Customer Order Payment List";
    DrillDownPageId = "Customer Order Payment List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Customer Order Header"."No.";
        }
        field(20; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
        }
        field(30; "Created By"; Text[50])
        {
            Caption = 'Created By';
        }
        field(40; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            DecimalPlaces = 0 : 5;
        }
        field(50; "G/L Account No."; Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account"."No.";
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
