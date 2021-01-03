proc diagDismiss {} {
    grab release .diag
    destroy .diag
}

proc diagInfo {whichone {btnCommand diagDismiss}} {
    global iry
    toplevel .diag
    wm protocol .diag WM_DELETE_WINDOW diagDismiss
    wm transient .diag
    wm attributes .diag -type dialog
    ttk::frame .diag.f -style irony.TFrame -padding 15
    grid .diag.f -column 0 -row 0 -sticky nwes
    grid columnconfigure .diag 0 -weight 1
    grid rowconfigure .diag 0 -weight 1
    grid columnconfigure .diag.f 0 -weight 1
    grid columnconfigure .diag.f 2 -weight 1
    grid rowconfigure .diag.f 0 -weight 1
    grid rowconfigure .diag.f 3 -weight 1
    ttk::label .diag.f.content -text $iry([string cat $whichone "_text"])\
        -style irony_dialog.TLabel
    grid .diag.f.content -column 1 -row 1 -padx 5 -pady 5
    ttk::button .diag.f.btn -text $iry([string cat $whichone "_btn"])\
        -style irony_dialog.TButton -command $btnCommand
    grid .diag.f.btn -column 1 -row 2
    bind .diag <Return> ".diag.f.btn invoke"
    tkwait visibility .diag
    grab set .diag
    tkwait window .diag
}
