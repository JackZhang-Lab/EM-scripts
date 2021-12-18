#!/bin/tcsh -f


set pattern="[ILMNDQEPK][NDQEPK][AVTSCILMNDQEPK][QEPKHFYWR][AVTSCILMNDQEPK][NDQEPKHFYWR][A-Z][AVTSCILMNDQEPK][A-Z][HFYWRKM][NDQEPKHFYWR][NDQEPKHFYWR][HFYWRW][AVTSCILMNDQEPK][HFYWRMKNQ][MNDQEPHFYWR]"


#######search control pane
set sc="N"    ###Y for searching ciliary_protein_sequence

set rv="N"      ####Y for reversing the sequence

set sp="N"      #####Y for searching the clamydomonas proteome 


###################################################################

echo "pattern is $pattern"

echo "\t\t"
echo "search the pattern in Central pair protein database"

gawk -v pattern="$pattern" 'match($0, pattern) {print $1,substr($0, RSTART, RLENGTH)}' CP_protein_sequence_aliases_short.txt

echo "\t\t"

if ($sc =~ "Y") then

echo "search the pattern in Ciliar protein database"

gawk -v pattern="$pattern" 'match($0, pattern) {print $1,substr($0, RSTART, RLENGTH)}' ciliary_protein_sequence.txt

echo "\t\t"
echo "\t\t"

endif

if ($sp =~ "Y") then

echo "search the pattern in Chlamy protein database"

gawk -v pattern="$pattern" 'match($0, pattern) {print $1,substr($0, RSTART, RLENGTH)}' Creinhardtii_281_v5_6_protein_oneline.fasta

echo "\t\t"
echo "\t\t"

endif


if ($rv =~ "Y") then
set s=`echo "$pattern" | sed 's/\]//g' | sed 's/\[/ /g'| sed 's/{/@/g' | sed 's/}/@/g' | sed 's/@]/\}/g' | sed 's/@]/\}/g'`
echo "$s"

echo "$s" | gawk '{for(i=NF;i!=0;i--) {printf("%s","["$i"]")}}'

echo "$s" | gawk '{for(i=NF;i!=0;i--) {printf("%s","["$i"]")}}' | gawk '{$1=$0;printf("%s",$0)}' | gawk '{str=$1;substr(str,1); print str}' > reverse


cat reverse

cat reverse | sed 's/@]/}/g' | sed 's/@/]{/g' | gawk '{print $1}' > m


cat m

set revpat="`cat m `"
echo "the reverse pattern is strings $revpat"


rm reverse m
echo "\t\t"
echo "\t\t"

echo "search the reverse pattern in Central pair protein database"



gawk -v pattern="$revpat" 'match($0, pattern) {print $1,substr($0, RSTART, RLENGTH)}' CP_protein_sequence_aliases_short.txt

echo "\t\t"
echo "\t\t"

if ($sc =~ "Y") then

echo "search the reverse pattern in Ciliar protein database"

gawk -v pattern="$revpat" 'match($0, pattern) {print $1,substr($0, RSTART, RLENGTH)}' ciliary_protein_sequence.txt

echo "\t\t"
echo "\t\t"

endif  


if ($sp =~ "Y") then

echo "search the reverse pattern in Chlamy proteome database"


gawk -v pattern="$revpat" 'match($0, pattern) {print $1,substr($0, RSTART, RLENGTH)}' Creinhardtii_281_v5_6_protein_oneline.fasta
echo "\t\t"
echo "\t\t"


endif  


endif  

