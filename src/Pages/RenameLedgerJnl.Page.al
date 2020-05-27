page 80265 "Rename Ledger Jnl. TTT-MSREN"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Rename Ledger TTT-MSREN";
    Caption = 'Rename Ledger Journal';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Line No."; "Line No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                    ToolTip = 'Line number in journal';
                    Editable = LineIsEditable;
                }
                field("Type"; "Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of action';
                    Editable = LineIsEditable;
                }
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    ToolTip = 'Table ID reference';
                    Editable = LineIsEditable;
                }
                field("Table Description"; "Table Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Table description';
                }
                field("Old No."; "Old No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Old/current number';
                    Editable = LineIsEditable;
                }
                field("Description"; "Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Description';
                }
                field("New No."; "New No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'New number after execution';
                    Editable = LineIsEditable;
                }
                field("Status"; "Entry Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status for the journal line';
                    Editable = false;
                }
                field("Error Description"; "Error Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Error description if execution failed';
                    Editable = LineIsEditable;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area("Processing")
        {
            group("Functions")
            {
                Caption = 'Functions';

                action("Execute Line")
                {
                    ApplicationArea = All;
                    Caption = 'Execute Line';
                    Image = Post;
                    ToolTip = 'Execute action on current line';

                    trigger OnAction()
                    var
                        renameLedgEntry: record "Rename Ledger TTT-MSREN";
                    begin
                        renameLedgEntry.get(rec."Line No.");
                        renameLedgEntry.SetRecFilter();
                        report.Run(report::"Rename Ledger TTT-MSREN", false, true, renameLedgEntry);
                        CurrPage.Update(false);
                    end;
                }
                action("Execute All")
                {
                    ApplicationArea = All;
                    Caption = 'Execute All';
                    Image = Post;
                    ToolTip = 'Execute action on all lines';

                    trigger OnAction()
                    var
                        renameLedgEntry: record "Rename Ledger TTT-MSREN";
                    begin
                        renameLedgEntry.copy(rec);
                        report.Run(report::"Rename Ledger TTT-MSREN", false, true, renameLedgEntry);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    var
        LineIsEditable: Boolean;

    trigger
    OnAfterGetCurrRecord()
    begin
        CalcFields("Table Description");
        LineIsEditable := "Entry Status" <> "Entry Status"::Done;
    end;
}