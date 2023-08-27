table 50000 "Customer Order Header"
{
    Caption = 'Customer Order Header';
    DataCaptionFields = "No.", "Customer Name";
    DataClassification = CustomerContent;

    DrillDownPageId = "Customer Orders";
    LookupPageID = "Customer Orders";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                ChangeCustomOrderNo();
            end;
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Customer: Record Customer;
                Confirmed: Boolean;
                ConfirmChangeQst: Label 'Do you want to change %1?', Comment = '%1 = a Field Caption';
                Text005Lbl: Label 'You cannot reset %1 because the document still has one or more lines.', Comment = '%1 = a Field Caption';
            begin
                if "No." = '' then
                    InitRecord();
                TestStatusOpen();

                if ("Customer No." <> xRec."Customer No.") and
                   (xRec."Customer No." <> '') then begin
                    if not GuiAllowed() then
                        Confirmed := true
                    else
                        Confirmed := Confirm(ConfirmChangeQst, false, FieldCaption("Customer No."));

                    if Confirmed then begin
                        CustomerOrderLine.SetRange("Document No.", "No.");
                        if "Customer No." = '' then begin
                            if CustomerOrderLine.FindFirst() then
                                Error(Text005Lbl, FieldCaption("Customer No."));
                            Init();
                            GetSalesSetup();
                            "No. Series" := xRec."No. Series";
                            InitRecord();
                            InitNoSeries();
                            exit;
                        end;
                        CustomerOrderLine.Reset();
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                if Customer.Get("Customer No.") then
                    Rec."Customer Name" := Customer.Name;
            end;
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                CustomerName: Text;
            begin
                CustomerName := "Customer Name";
                Rec.LookupSellToCustomerName(CustomerName);
                "Customer Name" := CopyStr(CustomerName, 1, MaxStrLen("Customer Name"));
            end;

            trigger OnValidate()
            var
                Customer: Record Customer;
                CustomLookupStateManager: Codeunit "Custom Lookup State Manager";
                StandardCodesMgt: Codeunit "Standard Codes Mgt.";
                IsHandled: Boolean;
            begin
                if CustomLookupStateManager.IsRecordSaved() then begin
                    Customer := CustomLookupStateManager.GetSavedRecord();
                    if Customer."No." <> '' then begin
                        CustomLookupStateManager.ClearSavedRecord();
                        Validate("Customer No.", Customer."No.");
                    end;
                end;
            end;
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
        field(40; "Order Amount"; Decimal)
        {
            Caption = 'Order Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Customer Order Line"."Line Amount" where("Document No." = Field("No.")));
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(50; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(60; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
        }
        field(61; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            Editable = false;
        }
        field(70; Status; Enum "Customer Order Status")
        {
            Caption = 'Status';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        GetSalesSetup();

        if "No." = '' then
            InitNoSeries();

        InitRecord();

        if "Customer No." <> '' then
            Validate("Customer No.", Rec."Customer No.");

        if SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" then
            "Posting Date" := 0D
        else
            "Posting Date" := WorkDate();

        "Document Date" := WorkDate();

        "Created By" := UserId();

        SetView('');
    end;

    trigger OnModify()
    begin
        TestStatusOpen();
    end;

    trigger OnDelete()
    begin
        DeleteLines();
        DeletePayments();
    end;

    trigger OnRename()
    begin
        ChangeCustomOrderNo();
    end;


    var
        CustomerOrderLine: Record "Customer Order Line";
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        StatusCheckSuspended: Boolean;


    local procedure InitNoSeries()
    begin
        GetSalesSetup();
        NoSeries.Get(SalesSetup."Custom Order No. Series");
        NoSeries.TestField("Default Nos.", true);

        NoSeriesMgt.InitSeries(SalesSetup."Custom Order No. Series", xRec."No. Series", "Posting Date", "No.", "No. Series");
    end;

    local procedure GetSalesSetup()
    begin
        SalesSetup.Get();
    end;

    local procedure InitRecord()
    begin
        GetSalesSetup();

        InitPostingNoSeries();
    end;

    local procedure InitPostingNoSeries()
    begin
        GetSalesSetup();
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Cust Order No. Series");
    end;

    local procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;

        TestField(Status, Status::Open);
    end;

    local procedure DeleteLines()
    var
        CustomerOrderLine: Record "Customer Order Line";
    begin
        CustomerOrderLine.SetRange("Document No.", "No.");
        CustomerOrderLine.DeleteAll();
    end;

    local procedure DeletePayments()
    begin
        Error('DeletePayments is not defined'); //TODO
        //You can't delete Order if there are some payments;
    end;

    local procedure ChangeCustomOrderNo()
    begin
        if "No." <> xRec."No." then begin
            GetSalesSetup();
            NoSeriesMgt.TestManual(SalesSetup."Custom Order No. Series");
            "No. Series" := '';
        end;
    end;

    procedure LookupSellToCustomerName(var CustomerName: Text): Boolean
    var
        Customer: Record Customer;
        CustomLookupStateManager: Codeunit "Custom Lookup State Manager";
        RecVariant: Variant;
        SearchCustomerName: Text;
    begin
        SearchCustomerName := CustomerName;

        if "Customer No." <> '' then
            Customer.Get("Customer No.");

        if Customer.SelectCustomer(Customer) then begin
            if Rec."Customer Name" = Customer.Name then
                CustomerName := SearchCustomerName
            else
                CustomerName := Customer.Name;

            RecVariant := Customer;
            CustomLookupStateManager.SaveRecord(RecVariant);

            exit(true);
        end;
    end;

    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    procedure PostOrder()
    var
        ZeroAmountErr: Label 'You cannot post a document with zero amount.';
    begin
        if Rec."Order Amount" = 0 then
            Error(ZeroAmountErr);

        //TODO: Add code to execute the action.
    end;

    procedure CalculatePaidAmount(): Decimal
    var
        CustomerOrderPayment: Record "Customer Order Payment";
    begin
        CustomerOrderPayment.Reset();
        CustomerOrderPayment.SetRange("Document No.", "No.");
        CustomerOrderPayment.CalcSums("Paid Amount");
        exit(CustomerOrderPayment."Paid Amount");
    end;
}

