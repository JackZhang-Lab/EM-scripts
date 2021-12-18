#!/bin/tcsh -f

#global setup for output format



#
set starf=Refine3D_noDNT/r3d2_local_ref_tail_motorB_data.star
#a spheric mrc to indicate the center 
set mrc_cen=Refine3D_noDNT/small_3D_sphere360_scale0.2_center2tail-motorB_rsmp.mrc

set proj=small_3D_sphere360_scale0.2_center2tail-motorB_rsmp_proj_all
set apix=2.68
set newsize=216


relion_project --i $mrc_cen --ang $starf --o $proj --angpix $apix

mrc_2ds_print_peaks   ${proj}.mrcs

./txt2box.com ${proj}_local_center.txt   $newsize > ${proj}_local_center.box

mrcs_local_ptcls_extract   r3d2_data_noDNT.mrcs  ${proj}_local_center.box

mv r3d2_data_noDNT_local_particles.mrcs   r3d2_data_noDNT_local_particles_tail-motorB_all.mrcs




exit

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

