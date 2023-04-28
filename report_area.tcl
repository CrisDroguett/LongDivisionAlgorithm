# ---------------------------------------------------------------------------------- 
# Noah Fishman, Cris Droguett
# EECE 573 - report_area.tcl - Final Project
#
# This script takes data from whichever file you need to read from by taking an argument
# in the command line. It then parses the read file for the specific pieces of data 
# you want and then saves it into the file report_area.rpt
# ---------------------------------------------------------------------------------- 

proc report_area {args} {

	# Open file you are writing to
	set fileWrite "area.rpt"
	set fw [open $fileWrite w]

	# Time
	# Prints the system time in the specified format
	set sysTime [clock seconds]
	puts $fw "# Noah Fishman, Cris Droguett EECE 573-01\n"
	puts $fw "File created on [clock format $sysTime -format {%A %D, %T}]\n"

	set fileName [lindex $args 0]
	set fr [open $fileName r]
	set contents [read -nonewline $fr]
	close $fr
	set lines [split $contents "\n"]

	# Finding and printing Slice LUTs used
	set count 0
	foreach elem $lines {
		foreach word $elem {
			incr count		
			if {$word == "Slice"} {
				set nextword [lindex $elem $count]
				if {($nextword == "LUTs*") || ($nextword == "LUTs")} {
					# Uses count+2 since the number of slice LUTs is 2 words after 
					# the identifier words "Slice LUTs"
					set utilized [lindex $elem $count+2] ;
					puts $fw "Slice LUTs used: $utilized"
				}
			}
		}
		set count 0
	}

	# Finding and printing the Primitives table
	# Reads and writes until the script parses to the next section
	set lineCount 0
	set primCount 0
	puts $fw "\nPrimitives Table"
	foreach elem $lines  {
		incr lineCount
		foreach word $elem {
			# Finds the word Primitives twice to find where we want to read + write the subsequent table
			# Want to skip the Primitives in the table of contents
			if {($word == "Primitives")} {
				incr primCount
				if {$primCount == 2} {
					break
				}
			}
		}
		if {$primCount == 2} {
			set nextline [lindex $lines $lineCount]
			if {($nextline == "8. Black Boxes") || ($nextline == "9. Black Boxes")} {
				break
			}
			puts $fw [lindex $lines $lineCount]
		}
	}

	# Finding and printing the Slice Logic Distribution table (if it exists)
	# Reads and writes until the script parses to the next section
	set lineCount 0
	set instanceCount 0
	puts $fw "\nSlice Logic Distribution Table"
	foreach elem $lines  {
		incr lineCount
		# Want to skip this line table of contents and go directly to where the data is below
		if {$elem == "1. Slice Logic"} {
			incr instanceCount
		}
		if {$instanceCount == 2} {
			set nextline [lindex $lines $lineCount]
			if {$nextline == "1.1 Summary of Registers by Type"} {
				break
			}
			puts $fw [lindex $lines $lineCount]
		}
	}	

	close $fw
	puts "Area report $fileWrite successfully created"
}