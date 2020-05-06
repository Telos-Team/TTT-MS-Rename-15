/* pageextension 80265 "Customer Card TTT-MSREN" extends "Customer Card"
{
    actions
    {
        addlast("F&unctions")
        {
            action("Rename TTT-MSREN")
            {
                Caption = 'Rename';
                ApplicationArea = All;
                ToolTip = 'Rename';
                Image = ReOpen;
                trigger OnAction()
                var
                    renameLedg: record "Rename Ledger TTT-MSREN";
                    recRef: RecordRef;
                begin
                    recref.GetTable(rec);
                    renameLedg.InsertRename((recref));
                end;
            }
            action("Join TTT-MSREN")
            {
                Caption = 'Join';
                ApplicationArea = All;
                ToolTip = 'Join';
                Image = ReOpen;
                trigger OnAction()
                var
                    renameLedg: record "Rename Ledger TTT-MSREN";
                    recRef: RecordRef;
                begin
                    recref.GetTable(rec);
                    renameLedg.InsertJoin(recref);
                end;
            }
        }
    }
} */