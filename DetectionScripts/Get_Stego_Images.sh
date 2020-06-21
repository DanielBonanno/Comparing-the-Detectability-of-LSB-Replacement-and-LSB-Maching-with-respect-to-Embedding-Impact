#! /bin/bash

root=$(pwd)
mkdir -m 777 "Stego_Images"
cd "Stego_Images"
stego_folder=$(pwd)

for alpha in 0.1 0.3 0.5 0.7 0.9 1
do	
	
	#Create a new folder for every alpha
	mkdir 	-m 777 "alpha_$alpha"
	cd 	"alpha_$alpha"
	alpha_Folder=$(pwd)
	#Create a folder for LSB Replacement and another one for LSB Matching
	mkdir 	-m 777 "LSB_Replacement"
	mkdir	-m 777 "LSB_Matching"
	cd 	"../../../EmbeddingScripts"

	#for every cover image
	for cover in {1..10000}
	do
		#Generate a data file and perform LSB Replacement
		python ./Generate_Data_File.py "$alpha_Folder/Data_$alpha.txt"  $alpha
		python ./LSB_Replacement.py  "$root/Covers/$cover.pgm" "$alpha_Folder/LSB_Replacement/$cover.pgm" "$alpha_Folder/Data_$alpha.txt" $alpha $RANDOM

		#Generate another data file and perform LSB Matching
		python ./Generate_Data_File.py "$alpha_Folder/Data_$alpha.txt"  $alpha
		python ./LSB_Matching.py  "$root/Covers/$cover.pgm" "$alpha_Folder/LSB_Matching/$cover.pgm" "$alpha_Folder/Data_$alpha.txt" $alpha $RANDOM

	done
	cd 	"$stego_folder"
done
wait
echo "Finished"
