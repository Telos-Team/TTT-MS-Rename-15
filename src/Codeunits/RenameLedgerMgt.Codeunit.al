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
        fldRef.SetRange(pRenameLedg."old No.");
        recRef.FindFirst();
        recref.Rename(pRenameLedg."New No.");

        clear(recRef);
        clear(fldRef);
        recRef.open(pRenameLedg."Table ID");
        fldRef := recRef.FIELD(1);
        fldRef.SetRange(pRenameLedg."new No.");
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

    var
        RenameLedg: Record "Rename Ledger TTT-MSREN";
}