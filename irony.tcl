#!/usr/bin/wish

package require Tk

set iry(title) "Irony"

proc readLang {name} {
    global iry
    set dblang [open [string cat "lang/" $name {.yml}]]
    set ln 1
    set lvl 0
    set prt ""
    set seq {}
    while {[gets $dblang line] >= 0} {
        if {$line == ""} {continue}
        regexp {^[ ]*} $line tmp
        set spf [expr [string length $tmp] / 2]
        if {$lvl < $spf} {
            if {$prt == ""} {
                error "ERROR line $ln ($line) => bad indentation"
            } else {
                set prt ""
                set lvl $spf
            }
        } elseif {$lvl > $spf} {
            if {$spf == 0} {
                set seq {}
                set prt ""
                set lvl 0
            } else {
                set lvl $spf
                set prt [lindex $seq [expr {$spf - 1}]]
                set seq [lrange $seq 0 [expr {$spf - 1}]]
            }
        }
        set tmp [split [string trim $line] ":"]
        set head [lindex $tmp 0]
        set tail [string range [string trim [lindex $tmp 1]] 1 {end-1}]
        if {$tail == ""} {
            set prt $head
            lappend seq $prt
        } else {
            set tmp2 $seq
            regsub {\\n} $tail "\n" tail
            set iry([join [lappend tmp2 $head] "_"]) $tail
        }
        incr ln
    }
    close $dblang
}

readLang "en"

source "styles/irony_style.tcl"

source "windows/dialogs.tcl"
source "windows/story.tcl"
source "windows/startup.tcl"

set stories [dict create]
set story_cnt 0

proc addStory {filename aStory} {
    global stories story_cnt
    dict set stories $filename $aStory
    $aStory showStory $story_cnt
    wm withdraw .
    incr story_cnt
    return [expr {$story_cnt - 1}]
}

proc checkStory {filename} {
    global stories
    return [dict exists $stories $filename]
}

proc messageStory {filename message args} {
    global stories
    #puts $filename
    #puts $message
    set aStory [dict get $stories $filename]
    switch $message {
        default { $aStory $message }
    }
}

proc goOut {} { exit }

vwait forever
