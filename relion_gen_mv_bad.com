#!/bin/tcsh -f

#####**************************************************************************#####

#global setup for output format
set KBold="\x1b\x5b1m"
set KDefault="\x1b\x5b0m"
set KUnderline="\x1b\x5b4m"
set KFlash="\x1b\x5b5m"

#end of global setup

set args = `printf "$argv" | wc | awk '{print $2}'`
set Proc_name=`echo $0 | awk '{n=split($1,scr,"/");print scr[n];}'`


if ( $args < 1 || $1 == '--help' || $1 == '-h' ) then


        printf "${KBold}Despcription: ${KDefault}This program is used to move bad micrographs with bad ctfs to Micrographs/bad.\n"
        printf "${KBold}Usage:${KDefault}   $Proc_name <bad file> \n"
        printf "${KBold}example:${KDefault} $Proc_name micrographs_ctf_bad.star   \n"
exit
endif
########################################################################


if ( ! -d  Micrographs/bad ) then
mkdir Micrographs/bad
endif

set bad_star="$1"

sed 's/_shrink8.mrc/*/g' $bad_star> tempbad$$.star
sed -i 's/_shrink4.mrc/*/g'  tempbad$$.star
sed -i 's/.mrc/*/g'  tempbad$$.star
#sed -i 's/.ctf:mrc/*/g' tempbad$$.star
set rlnMicrographNameIndex=`gawk 'NR<50 && /_rlnMicrographName/{print $2}'  tempbad$$.star |cut -c 2- `

gawk '/Micrographs/{printf("mv %s  Micrographs/bad/ \n",$'$rlnMicrographNameIndex')}' tempbad$$.star > mv_bad.com

rm -f tempbad$$.star
chmod +x mv_bad.com

