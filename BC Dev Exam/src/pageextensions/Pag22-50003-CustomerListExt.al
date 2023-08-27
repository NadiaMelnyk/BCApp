pageextension 50003 "Customer List" extends "Customer List" //22
{
    layout
    {
        movelast(Control1; "Responsibility Center", "Location Code")

        movebefore(Name; "Phone No.")

        modify("Responsibility Center")
        {
            Caption = 'Responsibility Center (moved)';
        }

        modify("Location Code")
        {
            Caption = 'Location Code (moved)';
        }

        modify("Phone No.")
        {

            Caption = 'Phone No. (moved)';
        }

    }

    var
        myInt: Integer;
}