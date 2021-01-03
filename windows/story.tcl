package require sqlite3
package require Tk

::oo::class create story {
    variable db
    variable path
    variable winname

    constructor {filename {creation 0}} {
        my OpenDB $filename $creation
    }

    method ActionDB {action args} {
        variable db
        switch $action {
            "init" {
                db eval {CREATE TABLE story_infos(key TEXT, value TEXT)}
                db eval {INSERT INTO story_infos VALUES('name', 'new story')}
            }
        }
    }

    method OpenDB {filename creation} {
        variable db
        variable path
        set path $filename
        sqlite3 db $filename
        if {$creation} { my ActionDB "init" }
    }

    method closeStory {} {
        #
        #
        puts "close the story"
        #
    }

    method showStory {cnt} {
        variable path
        variable winname
        #
        set winname [string cat ".win" $cnt]
        #
        toplevel $winname
        wm protocol $winname WM_DELETE_WINDOW "messageStory $path closeStory"
        #
        bind $winname <Control-q> goOut
        bind $winname <Control-w> "messageStory $path closeStory"
        #
        #
    }

    method tryDB {} {
        variable db
        catch {db eval {select count(*) from sqlite_master}}
    }
}
