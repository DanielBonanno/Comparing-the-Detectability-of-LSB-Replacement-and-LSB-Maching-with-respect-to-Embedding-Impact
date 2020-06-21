#! /bin/bash

root=$(pwd)
cd "SPAM_Features"
features_folder=$(pwd)

#Create a folder for the training and testing features
cd "$root"
mkdir -m 777 "Training_Testing_Features"
cd "Training_Testing_Features"
training_testing_folder=$(pwd)
cd "$root"

#Use the python script to combine the 1st order and 2nd order Spam features into a single file for the covers
python Combine_1stOrder_2ndOrder_SPAM_Features.py "$features_folder/Covers/F1_T4.fea" "$features_folder/Covers/F2_T3.fea" "$features_folder/Covers/Combined_Features.fea"

#similarly, use the same script to combine the 1st order and 2nd order features for the stego images for both LSB Replacement and LSB Matching
for alpha in 0.1 0.3 0.5 0.7 0.9 1
do		
	
		python Combine_1stOrder_2ndOrder_SPAM_Features.py "$features_folder/alpha_$alpha/LSB_Replacement/F1_T4.fea" "$features_folder/alpha_$alpha/LSB_Replacement/F2_T3.fea" "$features_folder/alpha_$alpha/LSB_Replacement/Combined_Features.fea"	
		python Combine_1stOrder_2ndOrder_SPAM_Features.py "$features_folder/alpha_$alpha/LSB_Matching/F1_T4.fea" "$features_folder/alpha_$alpha/LSB_Matching/F2_T3.fea" "$features_folder/alpha_$alpha/LSB_Matching/Combined_Features.fea"			
done
wait
echo "Feature Combining Finished"


#for very alpha value
for alpha in 0.1 0.3 0.5 0.7 0.9 1
do		
		cd "$training_testing_folder"
		mkdir 	-m 777 "alpha_$alpha"
		cd 	"alpha_$alpha"
		mkdir 	-m 777 "LSB_Replacement"
		cd "LSB_Replacement"
		#use the fea2libsvm to convert the combined features into libsvm features and split them into 80/20 for training/testing
		"$root/Spam_Feature_Extraction_Tools/fea2libsvm" --seed 0 --ratio 0.8 -c "$features_folder/Covers/Combined_Features.fea" -s "$features_folder/alpha_$alpha/LSB_Replacement/Combined_Features.fea"	 
		cd "$root"		
		
		#scale the training and testing features in the range -1 to +1, so that features with large ranges do not dominate features which have a smaller range
		./libsvm-3.22/svm-scale -l -1 -u +1 -s "$training_testing_folder/alpha_$alpha/LSB_Replacement/range" "$training_testing_folder/alpha_$alpha/LSB_Replacement/train.libsvm" > "$training_testing_folder/alpha_$alpha/LSB_Replacement/train-scale.libsvm"
		./libsvm-3.22/svm-scale -r "$training_testing_folder/alpha_$alpha/LSB_Replacement/range" "$training_testing_folder/alpha_$alpha/LSB_Replacement/test.libsvm" > "$training_testing_folder/alpha_$alpha/LSB_Replacement/test-scale.libsvm"

		#use the python script so that the same cover and stego image are not both used in training
		python Different_Cover_Stego.py "$training_testing_folder/alpha_$alpha/LSB_Replacement/train-scale.libsvm" "$training_testing_folder/alpha_$alpha/LSB_Replacement/train-scale.libsvm"
		#use the python script so that the same cover and stego image are not both used in testing
		python Different_Cover_Stego.py "$training_testing_folder/alpha_$alpha/LSB_Replacement/test-scale.libsvm" "$training_testing_folder/alpha_$alpha/LSB_Replacement/test-scale.libsvm"

		#repeat the process for lsb matching
		cd "$training_testing_folder/alpha_$alpha"
		mkdir 	-m 777 "LSB_Matching"
		cd "LSB_Matching"
		"$root/Spam_Feature_Extraction_Tools/fea2libsvm" --seed 0 --ratio 0.8 -c "$features_folder/Covers/Combined_Features.fea" -s "$features_folder/alpha_$alpha/LSB_Matching/Combined_Features.fea"
		cd "$root"
		./libsvm-3.22/svm-scale -l -1 -u +1 -s "$training_testing_folder/alpha_$alpha/LSB_Matching/range" "$training_testing_folder/alpha_$alpha/LSB_Matching/train.libsvm" > "$training_testing_folder/alpha_$alpha/LSB_Matching/train-scale.libsvm"
		./libsvm-3.22/svm-scale -r "$training_testing_folder/alpha_$alpha/LSB_Matching/range" "$training_testing_folder/alpha_$alpha/LSB_Matching/test.libsvm" > "$training_testing_folder/alpha_$alpha/LSB_Matching/test-scale.libsvm"

		python Different_Cover_Stego.py "$training_testing_folder/alpha_$alpha/LSB_Matching/train-scale.libsvm"  "$training_testing_folder/alpha_$alpha/LSB_Matching/train-scale.libsvm"
		python Different_Cover_Stego.py "$training_testing_folder/alpha_$alpha/LSB_Matching/test-scale.libsvm" "$training_testing_folder/alpha_$alpha/LSB_Matching/test-scale.libsvm"
	
done
wait
echo "Finished"
