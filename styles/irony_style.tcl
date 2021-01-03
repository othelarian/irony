package require Tk

#set basecol black
#set acc1col "#e80"
#set acc2col white
#set inv1col black

set basecol gray
set acc1col "#16c"
set acc2col white
set inv1col white

#ttk::style configure irony.TButton
ttk::style configure irony.TFrame -background $basecol
#ttk::style configure irony.TLabel

ttk::style configure irony_dialog.TButton -foreground $acc2col\
    -background $acc1col -font "Serif 14"
ttk::style map irony_dialog.TButton\
    -background [list active $acc2col]\
    -foreground [list active $acc1col]
ttk::style configure irony_dialog.TLabel -foreground $inv1col\
    -background $basecol -font "Serif 14"

ttk::style configure irony_startup.TButton -foreground $acc2col\
    -background $acc1col -font "Serif 20"
ttk::style map irony_startup.TButton\
    -background [list active $acc2col]\
    -foreground [list active $acc1col]
ttk::style configure irony_startup.TLabel -foreground $acc1col\
    -background $basecol -font "Serif 50"
ttk::style configure irony_startup_load.TLabel -background $basecol\
    -foreground $acc1col -font "Serif 40"
