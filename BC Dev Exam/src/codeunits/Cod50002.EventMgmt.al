codeunit 50002 "Event Mgmt."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', false, false)]
    local procedure SalesPostYesNo_OnBeforeConfirmSalesPost(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        PostedCustomerOrderHeader: Record "Posted Customer Order Header";
        ConfirmationLbl: Label 'Customer %1 (%2) has related Posted Customer Orders. Do you want to continue?', Comment = '%1 = Customer Name, %2 = Customer No';
    begin
        PostedCustomerOrderHeader.Reset();
        PostedCustomerOrderHeader.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
        if not PostedCustomerOrderHeader.IsEmpty then
            if not Confirm(StrSubstNo(ConfirmationLbl, SalesHeader."Sell-to Customer No.", SalesHeader."Sell-to Customer Name"), true) then
                IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeOnDelete', '', false, false)]
    local procedure Customer_OnBeforeOnDelete(var Customer: Record Customer; var IsHandled: Boolean)
    var
        ConfirmationLbl: Label 'Are you sure you want to delete customer %1 (%2)?', Comment = '%1 = Customer Name, %2 = Customer No';
    begin
        if not Confirm(ConfirmationLbl, false, Customer.Name, Customer."No.") then
            Error('');
    end;
}
