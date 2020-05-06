report 80265 "Rename Ledger TTT-MSREN"
{
    Caption = 'Rename Ledger Batch';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(RenameLedger; "Rename Ledger TTT-MSREN")
        {
            RequestFilterFields = "Entry Status", "Entry Type";
            trigger OnAfterGetRecord()
            var
                renameLedgMgt: Codeunit "Rename Ledger Mgt. TTT-MSREN";
            begin
                if ("Entry Status" = "Entry Status"::" ") or ("Entry Status" = "Entry Status"::Done) then
                    CurrReport.Skip();
                ClearLastError();
                if renameLedgMgt.run(RenameLedger) then begin
                    "Entry Status" := "Entry Status"::Done;
                    "Date of Processing" := today();
                    "Time of Processing" := time();
                    "Processed by" := copystr(UserId(), 1, maxstrlen("Processed by"));
                    clear("Error Description");
                    modify(true);
                end
                else begin
                    "Entry Status" := "Entry Status"::Failed;
                    "Error Description" := copystr(GetLastErrorText(), 1, maxstrlen("Error Description"));
                    Modify(true)
                end;
                Commit();
            end;
        }
    }
}