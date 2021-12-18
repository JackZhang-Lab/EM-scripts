#!/bin/tcsh -f

#global setup for output format
set KBold="\x1b\x5b1m"
set KDefault="\x1b\x5b0m"
set KUnderline="\x1b\x5b4m"
set KFlash="\x1b\x5b5m"

#end of global setup


set args = "${#argv}"
set Proc_name=`echo $0 | awk '{n=split($1,scr,"/");print scr[n];}'`


if ( $args < 1 || $1 == '--help' || $1 == '-h' ) then


        printf "${KBold}Despcription: ${KDefault}This program is used to create a star file of raw micrographs for RELION to start\n"
        printf "${KBold}Usage:${KDefault}   $Proc_name <micrographs>\n"
        printf "${KBold}example:${KDefault} $Proc_name Micrographs/data*.mrc \n"
      printf "${KBold}<<<<<  A Kind Reminding: if you find this script useful, please acknowledge Dr. Kai Zhang from MRC-LMB.  >>>>>${KDefault}\n"

        exit(1)
endif


####################################################################################################

set output_star="all_micrographs.star"

set all_micrographs="$argv"

echo ""  > $output_star 
echo "data_micrographs" >>  $output_star 
echo "" >>  $output_star 
echo "loop_" >>  $output_star
echo "_rlnMicrographName #1" >>  $output_star
foreach mrcf ($all_micrographs)

echo $mrcf >>  $output_star

end

      printf "${KBold}<<<<<  A Kind Reminding: if you find this script useful, please acknowledge Dr. Kai Zhang from MRC-LMB.  >>>>>${KDefault}\n"

