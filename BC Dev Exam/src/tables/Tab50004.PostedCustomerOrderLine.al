table 50004 "Posted Customer Order Line"
{
    Caption = 'Posted Customer Order Line';
    DataClassification = CustomerContent;
    //TODO
    // DrillDownPageID = "Posted Customer Order Lines";
    // LookupPageID = "Posted Customer Order Lines";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Posted Customer Order Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(20; "Type"; Enum "Customer Order Line Type")
        {
            Caption = 'Type';
        }
        field(21; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item WHERE(Blocked = CONST(false));
            ValidateTableRelation = false;
        }
        field(22; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(23; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(30; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(40; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(41; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
        }
        field(42; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
