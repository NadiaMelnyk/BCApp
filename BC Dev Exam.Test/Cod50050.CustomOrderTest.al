codeunit 50050 "Custom Order Test"
{

    Subtype = Test;

    //I have never written auto tests
    //So, the thing that I am capable for doing now in  Task 7 is to create test cases


    [Test]
    procedure CustomerOrderCreation()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order
        // [SCENARIO #0001] Successfully created Customer Order

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order

        // [WHEN] Opened Customer Order page

        // [THEN] Fill the fields 
    end;


    [Test]
    procedure ChangeConfirmedCustomOrder()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order
        // [SCENARIO #0002] Confermed order cannot be changed

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order

        // [WHEN] Opened Customer Order page

        // [THEN] Invoke Conferm action

        // [WHEN] Try to change the Header or associated lines

        // [THEN] Error message 'Status must be equal to 'Open' in Customer Order Header: No.=%1. Current value is 'Confirmed'.' is shown
    end;


    [Test]
    procedure SetCustomerOrderPaymentForZeroOrder()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Payment
        // [SCENARIO #0001] Customer Order Payment disabled if Order Amount is 0

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order

        // [WHEN] Opened Customer Order page

        // [THEN] Set Payment action should be disabled
    end;


    [Test]
    procedure SetCustomerOrderPaymentForOrder()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Payment
        // [SCENARIO #0002] Customer can create Payment for one Customer Order

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order with not zero Order Amount

        // [WHEN] Opened Customer Order page
        // [WHEN] Invoke Set Payment action

        // [WHEN] Custom Order Payment page is opened

        // [WHEN] Fill the fields (Payment Date, Paid Amount, G/L Account No.)
        // [THEN] Close the page and record should be inserted to Customer Order Payment
    end;


    [Test]
    procedure SetCustomerOrderPaymentForOrderExceedOrderAmount()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Payment
        // [SCENARIO #0003] Customer cannot pay more than Order Amount

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order with not zero Order Amount

        // [WHEN] Opened Customer Order page
        // [WHEN] Invoke Set Payment action

        // [WHEN] Custom Order Payment page is opened

        // [WHEN] Fill Paid Amount  with the value that is more then Order Amount

        // [THEN] Error message 'Current Payment Amount (%1) cannot be greater than the Remaining Amount (%2).' is shown
    end;


    [Test]
    procedure SetCustomerOrderPaymentForOrderEmptyGLAccount()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Payment
        // [SCENARIO #0004] Customer cannot pay without specifying GL Account

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order with not zero Order Amount

        // [WHEN] Opened Customer Order page
        // [WHEN] Invoke Set Payment action

        // [THEN] Custom Order Payment page is opened

        // [WHEN] Fill Paid Amount and Payment Date fields
        // [WHEN] Leave G/L Account No. field empty

        // [THEN] Error message 'G/L Account No. must be specified.' is shown
        // [THEN] Record in Custom Order Header is not created
    end;


    [Test]
    procedure ModifyCustomerOrderAfterSettingPayments()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Payment
        // [SCENARIO #0005] Customer cannot modify the Order if new Order Amount is less that Paid Amount for the Order

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order with not zero Order Amount

        // [WHEN] Opened Customer Order page
        // [WHEN] Invoke Set Payment action

        // [THEN] Custom Order Payment page is opened

        // [WHEN] Fill Paid Amount, Payment Date, and G/L Account No. fields
        // [WHEN] Close the Custom Order Payment page

        // [WHEN] Change the Order Line Amount to the value that is less than Paid Amount for the Order
        // [THEN] The error 'You cannot change line because new order amount (%1) is less than paid amount (%2)' is shown
    end;


    [Test]
    procedure SetCustomerOrderPaymentActionDisabled()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Payment
        // [SCENARIO #0006] Customer Order Payment disabled if Order Amount equals to Paid Amount

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order

        // [WHEN] Opened Customer Order page

        // [WHEN] Invoke Set Payment action 

        // [WHEN] Fill the fields (Payment Date, Paid Amount, G/L Account No.) with the values that equals to Order Amount
        // [WHEN] Close the page 
        // [THEN] The record should be inserted to Customer Order Payment

        // [THEN] Set Payment action should be disabled
    end;


    [Test]
    procedure PostCustomerOrderWithZeroAmount()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Posting
        // [SCENARIO #0001] Customer cannot post the order with zero Order Amount

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] A Customer Order with zero Order Amount

        // [WHEN] Opened Customer Order page
        // [WHEN] Invoke Post action

        // [THEN] The error 'You cannot post a document with zero amount.' is shown
    end;


    [Test]
    procedure PostCustomerOrderWithNotUniqueExternalDocumentNo()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Posting
        // [SCENARIO #0002] Customer cannot post the order with External Document No. that is already exist in Posted Header

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] Posted Customer Order with filled External Document No.
        // [GIVEN] Customer Order with the same External Document No. as in posted order

        // [WHEN] Opened Customer Order page
        // [WHEN] Invoke Post action

        // [THEN] The error 'Document was not posted: Posted order %1 has the same value in %2 as current document. %2 must be unicue.' is shown
    end;


    [Test]
    procedure PostCustomerOrderSuccessfully()
    var
        Customer: Record Customer;
        CustomerOrder: TestPage "Customer Order";
    begin
        // [FEATURE] Customer Order Posting
        // [SCENARIO #0003] Customer cannot posted successfully

        // [GIVEN] A Customer
        // [GIVEN] An Item
        // [GIVEN] Customer Order

        // [WHEN] Opened Customer Order page
        // [WHEN] Invoke Post action

        // [THEN] The records are inserted to Posted tables
    end;
}

