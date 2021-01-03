package require sqlite3
package require Tk

wm attributes . -type dialog

grid [ttk::frame .startup -style irony.TFrame -padding 30] -column 0 -row 0 -sticky nwes
grid columnconfigure . 0 -weight 1
grid rowconfigure . 0 -weight 1
grid columnconfigure .startup 1 -weight 1
grid rowconfigure .startup 0 -weight 1
grid rowconfigure .startup 6 -weight 1

# startup form
grid [ttk::label .startup.title -text $iry(title) -style irony_startup.TLabel] -column 1 -row 1 -pady 20
ttk::button .startup.new -text $iry(startup_new) -command newStory -style irony_startup.TButton
grid .startup.new -column 1 -row 2 -pady 20
ttk::button .startup.load -text $iry(startup_loadbtn) -command openStory -style irony_startup.TButton
grid .startup.load -column 1 -row 3

# startup loading
ttk::label .startup.loading -text $iry(startup_loading) -style irony_startup_load.TLabel
grid .startup.loading -column 1 -row 4 -pady 20
ttk::label .startup.loaddots -text $iry(startup_loaddots) -style irony_startup_load.TLabel
grid .startup.loaddots -column 1 -row 5

grid remove .startup.loading
grid remove .startup.loaddots

bind . <Control-q> goOut
bind . <Control-n> ".startup.new invoke"
bind . <Control-o> ".startup.load invoke"

proc startupSwitch {dir} {
    if {$dir} {
        grid remove .startup.title
        grid remove .startup.new
        grid remove .startup.load
        grid .startup.loading
        grid .startup.loaddots
    } else {
        grid remove .startup.loading
        grid remove .startup.loaddots
        grid .startup.title
        grid .startup.new
        grid .startup.load
    }
}

proc ironyTypes {} { return {{{Irony Story} {*.iry}} {{All file} *}} }

proc newStory {} {
    set filename [tk_getSaveFile -title {Irony - New Story} -filetypes [ironyTypes] -initialfile "story.iry"]
    if {[expr {$filename != ""}]} {
        if {[checkStory $filename]} {
            global iry
            diagInfo story_alreadyopen
            return
        }
        startupSwitch 1
        if {[expr [file exists $filename] == 1]} {
            if {[catch {file delete $filename}]} {
                global iry
                diagInfo startup_failreplace
                startupSwitch 0
                return
            }
        }
        if {[catch {story new $filename 1} new_story]} {
            puts $new_story
            global iry
            diagInfo startup_failcreate
            startSwitch 0
        } else { addStory $filename $new_story }
    }
}

proc openStory {} {
    set filename [tk_getOpenFile -title {Irony - Open a Story} -filetypes [ironyTypes]]
    if {[expr {$filename != ""}]} {
        if {[checkStory $filename]} {
            global iry
            diagInfo startup_alreadyopen
            return
        }
        startupSwitch 1
        if {[catch {story new $filename} new_story]} {
            global iry
            diagInfo startup_failopen
            startupSwitch 0
        } else {
            if {[$new_story tryDB]} {
                global iry
                diagInfo startup_failbadfile
                startupSwitch 0
            } else { addStory $filename $new_story }
        }
    }
}

proc showStartup {} {
    startupSwitch 0
    wm state . normal
}
