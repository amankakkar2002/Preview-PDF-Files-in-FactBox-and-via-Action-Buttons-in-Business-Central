codeunit 50091 "Incoming Document Factbox C"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Import Attachment - Inc. Doc.", OnAfterImportAttachment, '', false, false)]
    local procedure OnAfterImportAttachment(var IncomingDocumentAttachment: Record "Incoming Document Attachment")
    var
        IncomingDocumentFactboxT: Record "Incoming Document Factbox T";
    begin
        if not IncomingDocumentFactboxT.Get(IncomingDocumentAttachment."Incoming Document Entry No.") then begin
            IncomingDocumentFactboxT.Init();
            IncomingDocumentFactboxT."Document Entry No." := IncomingDocumentAttachment."Incoming Document Entry No.";
            IncomingDocumentFactboxT.Insert();
        end;
    end;
}