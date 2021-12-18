#!/bin/tcsh -f

#global setup for output format
set KBold="\x1b\x5b1m"
set KDefault="\x1b\x5b0m"
set KUnderline="\x1b\x5b4m"
set KFlash="\x1b\x5b5m"

#end of global setup

set args = `printf "$argv" | wc | awk '{print $2}'`
set Proc_name=`echo $0 | awk '{n=split($1,scr,"/");print scr[n];}'`

if ( $args < 1 || $1 == '--help' || $1 == '-h' ) then

        printf "${KBold}Despcription: ${KDefault}convert txt file to .box file.\n"
        printf "${KBold}Usage:${KDefault}   $Proc_name <txt file1> <txt file2> [...] \n"

        exit(1)
endif




set i=1

while ( $i <= $args )
set txt=$argv[$i]
set starf=`echo $txt |sed 's/.txt/.star/'`


echo "convert $txt to $starf ..."
echo "\ndata_\n\nloop_\n_rlnCoordinateX #1\n_rlnCoordinateY #2\n" > $starf
gawk '$1~/[0-9]/ && $2~/[0-9]/{printf("%10.2f%10.2f\n", $1, $2);}' $txt >> $starf


@ i++

end





