enum 50001 "Customer Order Line Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; Item)
    {
        Caption = 'Item';
    }
    value(2; "G/L Account")
    {
        Caption = 'G/L Account';
    }
}
