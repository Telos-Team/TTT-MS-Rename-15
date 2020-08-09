table 80265 "Rename Ledger TTT-MSREN"
{
    DataClassification = CustomerContent;
    Caption = 'Rename Ledger';

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(2; "Old No."; code[20])
        {
            Caption = 'Old No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                recRef: RecordRef;
                fldRef: FieldRef;
            begin
                if "Old No." <> '' then begin
                    TESTFIELD("Table ID");
                    recRef.OPEN("Table ID");
                    fldRef := recRef.FIELD(1);
                    fldRef.SETRANGE("Old No.");
                    recRef.FINDFIRST();
                end;
            end;

            trigger OnLookup()
            var
                recRef: RecordRef;
                NewRecRef: RecordRef;
                fldRef: FieldRef;
            begin
                recRef.Open("Table ID");
                if PageLookupOK(recRef, NewRecRef) then begin
                    fldref := NewRecRef.field(1);
                    validate("Old No.", fldref.Value);
                end;

            end;
        }
        field(3; "New No."; code[20])
        {
            Caption = 'New No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                CheckNewNo("New No.");
                if "New No." = '' then
                    "Entry status" := "Entry status"::" "
                else
                    "Entry status" := "Entry status"::Ready;
            end;

            trigger OnLookup()
            var
                recRef: RecordRef;
                NewRecRef: RecordRef;
                fldRef: FieldRef;

            begin
                if "Entry Type" = "Entry Type"::Join then begin
                    recRef.Open("Table ID");
                    if PageLookupOK(recRef, NewRecRef) then begin
                        fldref := NewRecRef.field(1);
                        validate("New No.", fldref.Value);
                    end;
                end;
            end;
        }
        field(4; "Table ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table), "Object ID" = filter(15 | 18 | 23 | 27 | 156 | 5050));
            Caption = 'Table ID';
            DataClassification = CustomerContent;
            BlankZero = true;
        }
        field(5; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "Date of Creation"; Date)
        {
            Caption = 'Date of Creation';
            DataClassification = CustomerContent;
        }
        field(7; "Time of Creation"; Time)
        {
            Caption = 'Time of Creation';
            DataClassification = CustomerContent;
        }
        field(8; "Created by"; code[50])
        {
            TableRelation = User;
            Caption = 'Created by';
            DataClassification = CustomerContent;
        }

        field(9; "Old No. without relation"; Time)
        {
            Caption = 'Old No. without relation';
            DataClassification = CustomerContent;
        }

        field(10; "Entry Status"; Enum "Ledger Status TTT-MSREN")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }

        field(11; "Join to"; code[20])
        {
            Caption = 'Join to';
            DataClassification = CustomerContent;
        }

        field(12; "Entry Type"; enum "Ledger Action Type TTT-MSREN")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(13; "Date of Processing"; Date)
        {
            Caption = 'Date of Processing';
            DataClassification = CustomerContent;
        }
        field(14; "Time of Processing"; Time)
        {
            Caption = 'Time of Processing';
            DataClassification = CustomerContent;
        }

        field(15; "Processed by"; text[50])
        {
            TableRelation = User;
            Caption = 'Processed by';
            DataClassification = CustomerContent;
        }
        field(16; "Error Description"; text[250])
        {
            Caption = 'Error Description';
            DataClassification = CustomerContent;
        }
        field(24; "Table Description"; text[30])
        {
            Caption = 'Table Description';
            FieldClass = FlowField;
            CalcFormula = lookup (AllObjWithCaption."Object Caption" where("Object Type" = const(Table), "Object ID" = field("Table ID")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := NextLineNo();
        "Entry Status" := "Entry Status"::Ready;
        "Date of Creation" := Today();
        "Time of Creation" := time();
        "Created by" := copystr(UserId(), 1, maxstrlen("Created by"));
    end;

    var
        Label001Err: Label '%1 %2 already exists!', Comment = '%1 is table caption. %2 is new number';
        Label002Err: Label '%1 %2 does not exist!', Comment = '%1 is table caption. %2 is new number';
        Label003Err: Label 'A %1 can not be joined with itself!', Comment = '%1 is table caption';

    local procedure NextLineNo(): integer
    var
        renameLedg: record "Rename Ledger TTT-MSREN";
    begin
        if renameLedg.FindLast() then
            exit(renameLedg."Line No." + 1)
        else
            exit(1);
    end;

    procedure InsertRename(recRef: RecordRef)
    var
        fldRef: FieldRef;
    begin
        init();
        Validate("Entry Type", "Entry Type"::Rename);
        Validate("table id", recRef.Number);
        fldRef := recRef.Field(1);
        Validate("Old No.", fldRef.Value);
        insert(true);
        Commit();
        page.RunModal(page::"Rename Ledger Jnl. TTT-MSREN");
    end;

    procedure InsertJoin(recRef: RecordRef)
    var
        fldRef: FieldRef;
    begin
        init();
        Validate("Entry Type", "Entry Type"::Join);
        Validate("table id", recRef.Number);
        fldRef := recRef.Field(1);
        Validate("Old No.", fldRef.Value);
        insert(true);
        Commit();
        page.RunModal(page::"Rename Ledger Jnl. TTT-MSREN");
    end;

    procedure CheckNewNo(NewNo: code[20])
    var
        recRef: RecordRef;
        fldRef: FieldRef;
    begin
        if NewNo = '' then
            exit;
        case "Entry Type" of
            "entry type"::Rename:
                begin
                    recRef.Open("Table ID");
                    fldRef := recRef.field(1);
                    fldref.SetRange(NewNo);
                    if not recref.IsEmpty() then
                        error(Label001Err, recref.Caption, NewNo);
                end;
            "entry type"::join:
                begin
                    recRef.Open("Table ID");
                    if "Old No." = "NewNo" then
                        error(Label003Err, recRef.Caption);
                    fldRef := recRef.field(1);
                    fldref.SetRange(NewNo);
                    if recref.IsEmpty() then
                        error(Label002Err, recref.Caption, NewNo);
                end;
        end;
    end;

    procedure PageLookupOK(RecRelatedVariant: Variant; VAR recRef: RecordRef): Boolean
    var
        DataTypeManagement: Codeunit "Data Type Management";
        PageManagement: Codeunit "Page Management";
        RecordRefVariant: Variant;
        PageID: integer;
    begin
        CLEAR(recRef);

        IF NOT GUIALLOWED THEN
            EXIT(FALSE);

        IF NOT DataTypeManagement.GetRecordRef(RecRelatedVariant, recRef) THEN
            EXIT(FALSE);

        PageID := PageManagement.GetDefaultLookupPageID(recRef.NUMBER);

        IF PageID <> 0 THEN BEGIN
            RecordRefVariant := recRef;
            IF PAGE.RUNMODAL(PageID, RecordRefVariant) = ACTION::LookupOK THEN BEGIN
                DataTypeManagement.GetRecordRef(RecordRefVariant, recRef);
                EXIT(TRUE);
            END;
        END;

        EXIT(FALSE);

    end;


}