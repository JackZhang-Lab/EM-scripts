#!/bin/tcsh -f

#global setup for output format
set KBold="\x1b\x5b1m"
set KDefault="\x1b\x5b0m"
set KUnderline="\x1b\x5b4m"
set KFlash="\x1b\x5b5m"

#end of global setup

set args = `printf "$argv" | wc | awk '{print $2}'`
set Proc_name=`echo $0 | awk '{n=split($1,scr,"/");print scr[n];}'`

if ( $args < 2 || $1 == '--help' || $1 == '-h' ) then

        printf "${KBold}Despcription: ${KDefault}convert txt file to .box file.\n"
        printf "${KBold}Usage:${KDefault}   $Proc_name <txt file> <boxsize> \n"

        exit(1)
endif

set txt_file = $1
set boxsize = $2

gawk '//{printf("%8d %8d %8d %8d\n", $2 - '$boxsize'/2, $3 - '$boxsize'/2, '$boxsize', '$boxsize' );}' $txt_file 

