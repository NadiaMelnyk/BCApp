table 50003 "Posted Customer Order Header"
{
    Caption = 'Posted Customer Order Header';
    DataCaptionFields = "No.", "Customer Name";
    DataClassification = CustomerContent;

    //TODO
    // DrillDownPageId = "Posted Customer Orders"; 
    // LookupPageID = "Posted Customer Orders";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            TableRelation = Customer.Name;
        }
        field(20; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(22; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(30; "Created By"; Text[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(31; "Posted By"; Text[50])
        {
            Caption = 'Posted By';
            Editable = false;
        }
        field(40; "Order Amount"; Decimal)
        {
            Caption = 'Order Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Posted Customer Order Line"."Line Amount" where("Document No." = Field("No.")));
        }
        field(41; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Posted Customer Order Payment"."Paid Amount" where("Document No." = Field("No.")));
        }
        field(50; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(60; "Order No. Series"; Code[20])
        {
            Caption = 'Order No. Series';
        }
        field(61; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
        }
        field(80; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
