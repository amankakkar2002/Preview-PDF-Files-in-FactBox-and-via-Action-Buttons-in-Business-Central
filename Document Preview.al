codeunit 50091 "Incoming Document Factbox C"
{
    [EventSubscriber(ObjectType::Table, database::"Incoming Document Attachment", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertEvent(RunTrigger: Boolean; var Rec: Record "Incoming Document Attachment")
    var
        IncomingDocumentFactboxT: Record "Incoming Document Factbox T";
    begin
        if not IncomingDocumentFactboxT.Get(Rec."Incoming Document Entry No.") then begin
            IncomingDocumentFactboxT.Init();
            IncomingDocumentFactboxT."Document Entry No." := Rec."Incoming Document Entry No.";
            IncomingDocumentFactboxT.Insert();
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Incoming Document Attachment", OnAfterModifyEvent, '', false, false)]
    local procedure OnAfterModifyEvent(RunTrigger: Boolean; var Rec: Record "Incoming Document Attachment")
    var
        IncomingDocumentFactboxT: Record "Incoming Document Factbox T";
    begin
        if not IncomingDocumentFactboxT.Get(Rec."Incoming Document Entry No.") then begin
            IncomingDocumentFactboxT.Init();
            IncomingDocumentFactboxT."Document Entry No." := Rec."Incoming Document Entry No.";
            IncomingDocumentFactboxT.Insert();
        end;
    end;
}
