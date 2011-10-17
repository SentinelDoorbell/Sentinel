
set X 	   0
set IMAGES [glob -nocomplain IMAGES/*.jp*g]

proc server { port } {
    set s [socket -server accept $port]
    vwait forever
}

proc accept { sock addr port } {
    global client

    puts "Connection received from ${addr}:${port}"

    set client $sock

    fconfigure $sock -translation binary
	
    fileevent $sock readable [list readData $sock]
}

proc readData { sock } {

    while { [gets $sock line] >= 0 } {
        if { [regexp GET $line] } {
            send_data $sock
        }
    }
}


proc send_next_image { sock } {
    global IMAGES
    global X

    set fileName [lindex $IMAGES [expr $X % [llength $IMAGES]]]
	
    set fd [open $fileName "rb"]
	
    set data [read $fd]
    puts -nonewline $sock "Content-type: image/jpeg\n\n"
    puts -nonewline $sock $data
    puts  $sock "\n--xstringx"
    flush $sock

    close $fd
}

proc send_data { sock } {
    global X
    set msg ""

    if { $X == 0 } {
    	set msg "HTTP/1.0 200\n"
    	append msg "Content-type: multipart/x-mixed-replace;boundary=xstringx"
	append msg "\n\n--xstringx\n"
        puts -nonewline $sock $msg
        flush $sock
	    
	send_next_image $sock
    } else {
	send_next_image $sock
    }

    incr X

    puts $msg
    after 500 [list send_data $sock]

    fileevent $sock readable ""
    fileevent $sock writeble "" 
}

server 8080
