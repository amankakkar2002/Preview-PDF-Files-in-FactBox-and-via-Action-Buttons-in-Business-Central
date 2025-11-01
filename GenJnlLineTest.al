pageextension 50091 "GenJnlLineTestExt" extends "General Journal"
{
    layout
    {

        addlast(factboxes)
        {
            part("Document Preview Factbox"; "Incoming Document Preview P")
            {
                SubPageLink = "Document Entry No." = field("Incoming Document Entry No.");
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(IncomingDocument)
        {
            action("Preview Incoming Document")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = View;
                trigger OnAction()
                var
                    IncomingDocument: Record "Incoming Document";
                    IncDocAttachmentOverview: Record "Inc. Doc. Attachment Overview";
                    IncomingDocumentAttachment: Record "Incoming Document Attachment";
                    SortingOrder: Integer;
                begin
                    if not IncomingDocument.Get(Rec."Incoming Document Entry No.") then
                        Error('No incoming document found.');

                    IncomingDocumentAttachment.Reset();
                    IncomingDocumentAttachment.SetRange("Incoming Document Entry No.", Rec."Incoming Document Entry No.");
                    if IncomingDocumentAttachment.FindFirst() then begin
                        InsertFromIncomingDocumentAttachment(IncDocAttachmentOverview, IncomingDocumentAttachment, SortingOrder, IncDocAttachmentOverview."Attachment Type"::"Supporting Attachment", 0);
                        ViewFile(IncomingDocumentAttachment, IncDocAttachmentOverview.Name + '.' + IncDocAttachmentOverview."File Extension");
                    end;
                end;
            }
        }
    }

    local procedure ViewFile(var IncomingDocumentAttachment: Record "Incoming Document Attachment"; FileName: Text)
    var
        FileInStream: InStream;
    begin
        IncomingDocumentAttachment.CalcFields(Content);
        IncomingDocumentAttachment.Content.CreateInStream(FileInStream);
        File.ViewFromStream(FileInStream, FileName, true);
    end;

    local procedure InsertFromIncomingDocumentAttachment(var TempIncDocAttachmentOverview: Record "Inc. Doc. Attachment Overview" temporary; IncomingDocumentAttachment: Record "Incoming Document Attachment"; var SortingOrder: Integer; AttachmentType: Option; Indentation2: Integer)
    begin
        Clear(TempIncDocAttachmentOverview);
        TempIncDocAttachmentOverview.Init();
        TempIncDocAttachmentOverview.TransferFields(IncomingDocumentAttachment);
        AssignSortingNo(TempIncDocAttachmentOverview, SortingOrder);
        TempIncDocAttachmentOverview."Attachment Type" := AttachmentType;
        TempIncDocAttachmentOverview.Indentation := Indentation2;
        TempIncDocAttachmentOverview.Insert(true);
    end;

    local procedure AssignSortingNo(var TempIncDocAttachmentOverview: Record "Inc. Doc. Attachment Overview" temporary; var SortingOrder: Integer)
    begin
        SortingOrder += 1;
        TempIncDocAttachmentOverview."Sorting Order" := SortingOrder;
    end;
}