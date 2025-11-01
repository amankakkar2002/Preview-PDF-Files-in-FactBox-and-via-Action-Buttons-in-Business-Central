table 50091 "Incoming Document Factbox T"
{
    fields
    {
        field(1; "Document Entry No."; Integer)
        {
            Caption = 'Document Entry No.';
        }
        field(2; "Document Attached"; Media)
        {
            Caption = 'Document Attached';
            ExtendedDatatype = Document;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document Entry No.")
        {
            Clustered = true;
        }
    }
}