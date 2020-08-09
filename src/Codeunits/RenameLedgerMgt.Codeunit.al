codeunit 80265 "Rename Ledger Mgt. TTT-MSREN"
{
    TableNo = "Rename Ledger TTT-MSREN";
    trigger OnRun()
    begin
        RenameLedg := rec;
        case RenameLedg."Entry Type" of
            renameledg."Entry Type"::Rename:
                HandlRename(RenameLedg);
            renameledg."Entry Type"::Join:
                HandlJoin(RenameLedg);
        end;
    end;

    local procedure HandlRename(var pRenameLedg: record "Rename Ledger TTT-MSREN")
    var
        recRef: RecordRef;
        fldRef: FieldRef;
    begin
        recRef.open(pRenameLedg."Table ID");
        fldRef := recRef.FIELD(1);
        fldRef.SetRange(pRenameLedg."Old No.");
        recRef.FindFirst();
        recref.Rename(pRenameLedg."New No.");
    end;

    local procedure HandlJoin(var pRenameLedg: record "Rename Ledger TTT-MSREN")
    var
        recRef: RecordRef;
        recRef2: RecordRef;
        fldRef: FieldRef;
    begin
        OnBeforeJoin(pRenameLedg);

        recRef.open(pRenameLedg."Table ID");
        fldRef := recRef.FIELD(1);
        fldRef.SetRange(pRenameLedg."New No.");
        recRef.FindFirst();
        recRef2 := recref;
        recRef.Delete(false);

        clear(recRef);
        clear(fldRef);
        recRef.open(pRenameLedg."Table ID");
        fldRef := recRef.FIELD(1);
        fldRef.SetRange(pRenameLedg."Old No.");
        recRef.FindFirst();
        recref.Rename(pRenameLedg."New No.");

        clear(recRef);
        clear(fldRef);
        recRef.open(pRenameLedg."Table ID");
        fldRef := recRef.FIELD(1);
        fldRef.SetRange(pRenameLedg."New No.");
        recRef.FindFirst();

        COPYRecRef2OtherRecRef(recRef2, recRef);
        recRef.Modify(false);
    end;

    procedure COPYRecRef2OtherRecRef(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        fromFldRef: FieldRef;
        toFldRef: FieldRef;
        idx: Integer;
    begin
        for idx := 2 to FromRecRef.FieldCount() do begin // Skip PK !
            fromFldRef := FromRecRef.FieldIndex(idx);
            if fromFldRef.Active() then
                if ToRecRef.FieldExist(fromFldRef.Number()) then begin
                    toFldRef := ToRecRef.field(fromFldRef.number());
                    if (toFldRef.Name() = fromfldref.name()) and
                       (toFldRef.type() = fromFldRef.type()) and
                       (toFldRef.Class() = fromFldRef.Class()) and
                       (tofldref.Length() = fromFldRef.Length()) then
                        if fromFldRef.Class() = fromFldRef.Class::Normal then
                            toFldRef.Value := fromFldRef.Value;  // OBS vedr. BLOB / Media !!!
                end;
        end;
    end;

    local procedure OnBeforeJoin(pRenameLedg: record "Rename Ledger TTT-MSREN")
    var
        CommentLine: Record "Comment Line";
        ShipToAddr: Record "Ship-to Address";
        DefaultDim: Record "Default Dimension";
        CustBankAcc: Record "Customer Bank Account";
        MyCust: Record "My Customer";
        OrderAddr: Record "Order Address";
        ItemTranslation: Record "Item Translation";
        ItemUOM: Record "Item Unit of Measure";
        AvgCostAdjmtEntryPoint: Record "Avg. Cost Adjmt. Entry Point";
        ItemAnalysisViewEntry: Record "Item Analysis View Entry";
        PlanningAssignment: Record "Planning Assignment";
        ContactProfileAnswer: Record "Contact Profile Answer";
        ContJobResponsibility: Record "Contact Job Responsibility";
    begin
        case pRenameLedg."Table ID" of
            Database::"G/L Account":
                begin
                    CommentLine.SetRange("Table Name", CommentLine."Table Name"::"G/L Account");
                    CommentLine.SetRange("No.", pRenameLedg."Old No.");
                    CommentLine.DeleteAll();
                end;
            Database::Customer:
                begin
                    CommentLine.SetRange("Table Name", CommentLine."Table Name"::Customer);
                    CommentLine.SetRange("No.", pRenameLedg."Old No.");
                    CommentLine.DeleteAll();

                    ShipToAddr.SetRange("Customer No.", pRenameLedg."Old No.");
                    ShipToAddr.DeleteAll();

                    DefaultDim.SetRange("Table ID", Database::Customer);
                    DefaultDim.SetRange("No.", pRenameLedg."Old No.");
                    DefaultDim.DeleteAll();

                    CustBankAcc.SetRange("Customer No.", pRenameLedg."Old No.");
                    CustBankAcc.DeleteAll();

                    MyCust.SetRange("Customer No.", pRenameLedg."Old No.");
                    MyCust.DeleteAll();
                end;
            Database::Vendor:
                begin
                    CommentLine.SetRange("Table Name", CommentLine."Table Name"::Vendor);
                    CommentLine.SetRange("No.", pRenameLedg."Old No.");
                    CommentLine.DeleteAll();

                    OrderAddr.SetRange("Vendor No.", pRenameLedg."Old No.");
                    OrderAddr.DeleteAll();
                end;
            Database::Item:
                begin
                    CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
                    CommentLine.SetRange("No.", pRenameLedg."Old No.");
                    CommentLine.DeleteAll();

                    ItemTranslation.SetRange("Item No.", pRenameLedg."Old No.");
                    ItemTranslation.DeleteAll();

                    ItemUOM.SetRange("Item No.", pRenameLedg."Old No.");
                    ItemUOM.DeleteAll();

                    AvgCostAdjmtEntryPoint.SetRange("Item No.", pRenameLedg."Old No.");
                    AvgCostAdjmtEntryPoint.DeleteAll();

                    ItemAnalysisViewEntry.SetRange("Item No.", pRenameLedg."Old No.");
                    ItemAnalysisViewEntry.DeleteAll();

                    PlanningAssignment.SetRange("Item No.", pRenameLedg."Old No.");
                    PlanningAssignment.DeleteAll();
                end;
            Database::Contact:
                begin
                    ContactProfileAnswer.SetRange("Contact No.", pRenameLedg."Old No.");
                    ContactProfileAnswer.DeleteAll();

                    ContJobResponsibility.SetRange("Contact No.", pRenameLedg."Old No.");
                    ContJobResponsibility.DeleteAll();
                end;
        end;
    end;

    var
        RenameLedg: Record "Rename Ledger TTT-MSREN";
}