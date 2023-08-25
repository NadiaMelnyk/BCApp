tableextension 50000 "Sales & Receivables Setup" extends "Sales & Receivables Setup" //311
{
    fields
    {
        field(50000; "Custom Order No. Series"; Code[20])
        {
            Caption = 'Custom Order No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50001; "Posted Cust Order No. Series"; Code[20])
        {
            Caption = 'Posted Customer Order No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}
