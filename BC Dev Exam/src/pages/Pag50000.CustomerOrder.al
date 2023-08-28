page 50000 "Customer Order"
{
    Caption = 'Customer Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Customer Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Customer No. field.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the value of the Customer Name field.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookupSellToCustomerName(Text));
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Order Amount"; Rec."Order Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Amount field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
            part(OrderLines; "Customer Order Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
        area(factboxes)
        {
            part(Control1900316107; "Customer Details FactBox")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "No." = FIELD("Customer No.");
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                ApplicationArea = Basic, Suite;
                Provider = OrderLines;
                SubPageLink = "No." = FIELD("No.");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(ChangeStatus)
            {
                Caption = 'Change Status';
                Image = Status;
                action(Reopen)
                {
                    Caption = 'Reopen';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Reopen action.';
                    Image = ReOpen;

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Open;
                        Rec.SuspendStatusCheck(true);
                        Rec.Modify();
                        CurrPage.Update();
                        Rec.SuspendStatusCheck(false);
                    end;
                }
                action(Confirm)
                {
                    Caption = 'Confirm';
                    ApplicationArea = All;
                    ToolTip = 'Executes the Confirm action.';
                    Image = Confirm;

                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Confirmed;
                        Rec.SuspendStatusCheck(true);
                        Rec.Modify();
                        CurrPage.Update();
                        Rec.SuspendStatusCheck(false);
                    end;
                }
            }
            action(Post)
            {
                Caption = 'Post';
                ApplicationArea = All;
                ToolTip = 'Executes the Post action.';
                Image = Post;

                trigger OnAction()
                begin
                    Rec.PostOrder();
                end;
            }
            action(SetPayment)
            {
                Caption = 'Set payment';
                ApplicationArea = All;
                ToolTip = 'Executes the Set payment action.';
                Image = Payment;
                Enabled = DynamicEnabled;

                trigger OnAction()
                var
                    CustomerOrderPayments: Page "Customer Order Payments";
                begin
                    CustomerOrderPayments.SetIsRunFromPostedOrder(false);
                    CustomerOrderPayments.SetCurrentOrderNo(Rec."No.");
                    CustomerOrderPayments.RunModal();
                    SetPaymentEnabled();
                    CurrPage.Update();
                end;
            }
        }
        area(Promoted)
        {
            group(ChangeStatus_promoted)
            {
                Caption = 'Change Status';
                Image = Status;
                actionref(Reopen_promoted; Reopen)
                {
                }
                actionref(Confirm_promoted; Confirm)
                {
                }
            }
            actionref(Post_promoted; Post)
            {
            }
            actionref(SetPayment_promoted; SetPayment)
            {
            }
        }
    }

    var
        DynamicEnabled: Boolean;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if (Rec."Customer No." = '') and (Rec.GetFilter("Customer No.") <> '') then
            CurrPage.Update(false);
    end;

    trigger OnAfterGetRecord()
    begin
        SetPaymentEnabled();
    end;

    trigger OnOpenPage()
    begin
        SetPaymentEnabled();
    end;

    local procedure SetPaymentEnabled()
    begin
        DynamicEnabled := false;
        if Rec.CalculatePaidAmount() <> Rec."Order Amount" then
            DynamicEnabled := true;
    end;
}