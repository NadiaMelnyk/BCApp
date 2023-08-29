table 50001 "Customer Order Line"
{
    Caption = 'Customer Order Line';
    DataClassification = CustomerContent;
    DrillDownPageID = "Customer Order Lines";
    LookupPageID = "Customer Order Lines";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Customer Order Header"."No.";
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

            trigger OnValidate()
            var
                StandardText: Record "Standard Text";
                GLAcc: Record "G/L Account";
                Item: Record Item;
            begin
                case Type of
                    Type::" ":
                        begin
                            StandardText.Get("No.");
                            Description := StandardText.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            Description := GLAcc.Name;
                        end;
                    Type::Item:
                        begin
                            Item.Get("No.");
                            Description := Item.Description;
                        end;
                end;
            end;
        }
        field(22; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(23; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;

            trigger OnValidate()
            var
                Text001Lbl: Label 'You cannot change Location Code if Line Type is not Item';
            begin
                if Rec.Type <> Rec.Type::Item then
                    Error(Text001Lbl)
            end;
        }
        field(30; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                CalculateLineAmount();
            end;
        }
        field(40; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                CalculateLineAmount();
            end;
        }
        field(41; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;

            trigger OnValidate()
            begin
                CalculateLineAmount();
            end;
        }
        field(42; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            Editable = false;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                CustomerOrderLine: Record "Customer Order Line";
                CustomerOrderHeader: Record "Customer Order Header";
            begin
                CustomerOrderLine.Reset();
                CustomerOrderLine.SetRange("Document No.", Rec."Document No.");
                CustomerOrderLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
                CustomerOrderLine.CalcSums("Line Amount");

                if not CustomerOrderHeader.Get("Document No.") then
                    exit;

                if CustomerOrderLine."Line Amount" + Rec."Line Amount" < CustomerOrderHeader.CalculatePaidAmount() then
                    Error('You cannot change line because new order amount (%1) is less than paid amount (%2)', CustomerOrderLine."Line Amount" + Rec."Line Amount", CustomerOrderHeader.CalculatePaidAmount());
            end;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestStatusOpen();
    end;

    trigger OnModify()
    begin
        TestStatusOpen();
    end;

    trigger OnDelete()
    begin
        TestStatusOpen();
    end;

    var
        CustomerOrderHeader: Record "Customer Order Header";

    local procedure TestStatusOpen()
    begin
        GetSalesHeader();
        CustomerOrderHeader.TestField(Status, CustomerOrderHeader.Status::Open);
    end;

    local procedure GetSalesHeader()
    begin
        TestField("Document No.");

        if "Document No." <> CustomerOrderHeader."No." then
            if not CustomerOrderHeader.Get("Document No.") then
                Clear(CustomerOrderHeader);
    end;

    local procedure CalculateLineAmount()
    begin
        Rec.Validate("Line Amount", Rec.Quantity * Rec."Unit Price" * (1 - Rec."Line Discount %" / 100));
    end;
}
