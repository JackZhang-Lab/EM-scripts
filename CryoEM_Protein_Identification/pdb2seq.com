#!/bin/csh -f



#####**************************************************************************#####

#Author: Kai Zhang
#Last Edit: 2009-2-27

#####**************************************************************************#####
#global setup for output format
set KBold="\x1b\x5b1m"
set KDefault="\x1b\x5b0m"
set KUnderline="\x1b\x5b4m"
set KFlash="\x1b\x5b5m"

#end of global setup
set args = `echo $argv | wc | awk '{print $2}'`
set Proc_name=`echo $0 | awk '{n=split($1,scr,"/");print scr[n];}'`

if ( $args < 1 || $1 == '--help' || $1 == '-h' ) then
	printf "${KBold}Despcription: ${KDefault}This program is used to corvert a pdb file to sequnce file.\n"
	echo "Usage: $Proc_name <pdb file> [sequnce file]" 
	printf "${KBold}Example:${KDefault} $Proc_name gapank.pdb gapank.seq\n"
	printf "${KBold}Example:${KDefault} $Proc_name gapank.pdb\n"
	exit(1)
endif

set input_pdb_file=${1}

set e_name = `echo $1 | awk '{n=split($1,scr,".");print toupper(scr[n]);}'`

if ( ${#argv} == 1) then

	if ( $e_name == "PDB" ) then

		set pdb_file_len=`echo $input_pdb_file |wc|awk '{print$3}'`
		@ pdb_file_len=$pdb_file_len - 5
		set input_pdb_file_cut=`echo $input_pdb_file |cut -c 1-$pdb_file_len`
		set output_seq_file=${input_pdb_file_cut}.seq
	else
		set output_seq_file=${input_pdb_file}.seq

	endif

endif

if  ( ${#argv} >= 2) then
set output_seq_file=${2}
endif

echo "converting $input_pdb_file to ${output_seq_file}"
pdbset xyzin $input_pdb_file <<EOF >${input_pdb_file}.temp
sequnce single ${output_seq_file}
EOF

rm -f ${input_pdb_file}.temp
rm -f XYZOUT
