page 50006 "Posted Customer Order"
{
    Caption = 'Posted Customer Order';
    PageType = Document;
    Editable = false;
    SourceTable = "Posted Customer Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
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
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order No. field.';
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
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Paid Amount field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Posted By field.';
                }

            }
            part(PostedOrderLines; "Posted Customer Order Subform")
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
                Provider = PostedOrderLines;
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
            action(SetPayment)
            {
                Caption = 'Set and Post payment';
                ApplicationArea = All;
                ToolTip = 'Executes the Set and Post payment action. This action can be used if customer pay some money after the order was posted.';
                Image = Payment;
                Enabled = DynamicEnabled;

                trigger OnAction()
                var
                    CustomerOrderPayments: Page "Customer Order Payments";
                    CustomerOrderPost: Codeunit "Customer Order Post";
                begin
                    CustomerOrderPayments.SetIsRunFromPostedOrder(true);
                    CustomerOrderPayments.SetCurrentOrderNo(Rec."No.");
                    CustomerOrderPayments.RunModal();
                    CustomerOrderPost.SetAndPostPaymentAfterPosting(Rec);
                    SetPaymentEnabled();
                    CurrPage.Update();
                end;
            }
        }
        area(Promoted)
        {
            actionref(SetPayment_promoted; SetPayment)
            {
            }
        }
    }

    var
        DynamicEnabled: Boolean;


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