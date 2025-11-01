page 50091 "Incoming Document Preview P"
{
    PageType = CardPart;
    SourceTable = "Incoming Document Factbox T";
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Caption = 'Incoming Document Preview';

    layout
    {
        area(Content)
        {
            field(ImageCount; ImageCount)
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
            field("Document Attached"; Rec."Document Attached")
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Next)
            {
                ApplicationArea = All;
                Image = NextRecord;
                trigger OnAction()
                begin
                    if PageNumber >= TotalPages then
                        exit;
                    PageNumber += 1;
                end;
            }
            action(Previous)
            {
                ApplicationArea = All;
                Image = PreviousRecord;
                trigger OnAction()
                begin
                    if PageNumber <= 1 then
                        exit;
                    PageNumber -= 1;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Document Entry No." <> xRec."Document Entry No." then
            PageNumber := 1;
        GeneratePreview(PageNumber);
    end;

    local procedure GeneratePreview(PageNumber: Integer)
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        PDFDocument: Codeunit "PDF Document";
        TempBlobImage: Codeunit "Temp Blob";
        TempBlobPDF: Codeunit "Temp Blob";
        InStrImage: InStream;
        InStr: InStream;
        OutStr: OutStream;
        FileName: Text;
    begin
        // Get the incoming document attachment file
        IncomingDocumentAttachment.Reset();
        IncomingDocumentAttachment.SetRange("Incoming Document Entry No.", Rec."Document Entry No.");
        if IncomingDocumentAttachment.FindFirst() then begin

            // Save file name
            FileName := IncomingDocumentAttachment.Name + '.' + IncomingDocumentAttachment."File Extension";

            // Calculate the blob file
            IncomingDocumentAttachment.CalcFields(Content);

            // Create Instream for the file
            IncomingDocumentAttachment.Content.CreateInStream(InStr);

            // Load the instream into PDFDoc
            PDFDocument.Load(InStr);
            TotalPages := PDFDocument.GetPdfPageCount(InStr);
            ImageCount := Format(PageNumber) + '/' + Format(TotalPages);

            // Create Outstream for Image
            TempBlobImage.CreateOutStream(OutStr);

            // Create Instream for Image
            TempBlobPDF.CreateInStream(InStrImage);

            // Convert PDF page to image
            PDFDocument.ConvertToImage(InStrImage, Enum::"Image Format"::Png, PageNumber);

            // Clear the field and import your image into the Media field
            Clear(Rec."Document Attached");
            Rec."Document Attached".ImportStream(InStrImage, FileName, 'image/png');
            Rec.Modify(true);
        end else
            ImageCount := '0/0';
    end;

    trigger OnOpenPage()
    begin
        PageNumber := 1;
    end;

    var
        ImageCount: Text[30];
        PageNumber: Integer;
        TotalPages: Integer;
}