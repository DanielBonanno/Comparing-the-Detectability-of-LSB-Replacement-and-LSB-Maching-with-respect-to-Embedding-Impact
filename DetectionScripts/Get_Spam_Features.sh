#! /bin/bash

root=$(pwd)
mkdir -m 777 "SPAM_Features"
cd "SPAM_Features"
features_folder=$(pwd)
#create a folder for the cover features
mkdir -m 777 "Covers"

#use the spam extraction tool on the cover images using the parameters provided
cd "$root/Spam_Feature_Extraction_Tools"
./spam -I "../Covers" --T1 4 --T2 3 --output-file-1st "$features_folder/Covers/F1_T4.fea" --output-file-2nd "$features_folder/Covers/F2_T3.fea"


for alpha in 0.1 0.3 0.5 0.7 0.9 1
do		
	# for every alpha, create a folder in the main features folder
	cd "$features_folder"
	mkdir 	-m 777 "alpha_$alpha"
	cd 	"alpha_$alpha"
	alpha_features_folder=$(pwd)
	
	#create a folder for features of stego images obtained by LSB_Replacement and another for LSB_Matching
	mkdir 	-m 777 "LSB_Replacement"
	mkdir	-m 777 "LSB_Matching"
	cd 	 "$root/Spam_Feature_Extraction_Tools"

	#use the spam extraction tool on all the stego images to obtain the spam features
	./spam -I "../Stego_Images/alpha_$alpha/LSB_Replacement" --T1 4 --T2 3 --output-file-1st "$alpha_features_folder/LSB_Replacement/F1_T4.fea" --output-file-2nd "$alpha_features_folder/LSB_Replacement/F2_T3.fea"

	./spam -I "../Stego_Images/alpha_$alpha/LSB_Matching" --T1 4 --T2 3 --output-file-1st "$alpha_features_folder/LSB_Matching/F1_T4.fea" --output-file-2nd "$alpha_features_folder/LSB_Matching/F2_T3.fea"

done
wait
echo "Finished"
