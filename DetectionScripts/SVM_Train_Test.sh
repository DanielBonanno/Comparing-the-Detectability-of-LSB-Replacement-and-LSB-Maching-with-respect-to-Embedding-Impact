#! /bin/bash

root=$(pwd)
cd "libsvm-3.22"
libsvm_folder=$(pwd)

cd "$root"
mkdir -m 777 "SVMs"
cd "SVMs"
SVMs_folder=$(pwd)

cd "$root"
cd "Training_Testing_Features"
training_testing_features=$(pwd)


for alpha in 0.1 0.3 0.5 0.7 0.9 1
do		
		#create a folder for every alpha
		cd "$SVMs_folder"
		mkdir 	-m 777 "alpha_$alpha"
		cd 	"alpha_$alpha"
		mkdir 	-m 777 "LSB_Replacement"
		
		#perform a grid search for the C and Gamma parameters of the RBF kernel
		cd "$training_testing_features/alpha_$alpha/LSB_Replacement" #required, otherwise grid.py fails
		read last_line <<< $(python "$libsvm_folder/tools/grid.py" -out null "train-scale.libsvm"  |tail -1)
		last_line=($last_line)
		c=${last_line[0]}
		g=${last_line[1]}
		
		#train using the best C and Gamma values over the whole training set
		"$libsvm_folder/svm-train" -c $c -g $g "$training_testing_features/alpha_$alpha/LSB_Replacement/train-scale.libsvm"  "$SVMs_folder/alpha_$alpha/LSB_Replacement/model"

		#test using the testing set and obtain the accuracy
		read accuracy <<< $("$libsvm_folder/svm-predict" "$training_testing_features/alpha_$alpha/LSB_Replacement/test-scale.libsvm" "$SVMs_folder/alpha_$alpha/LSB_Replacement/model" "$SVMs_folder/alpha_$alpha/LSB_Replacement/predictions.txt")

		#write the output to file
		cat >"$SVMs_folder/alpha_$alpha/LSB_Replacement/Details_Results.txt" <<-EOL
		C Parameter: $c
		G Parameter: $g
		Accuracy: $accuracy
		EOL


		#repeat for LSB Matching
		cd "$SVMs_folder/alpha_$alpha"
		mkdir 	-m 777 "LSB_Matching"
		cd "LSB_Matching"

		cd "$training_testing_features/alpha_$alpha/LSB_Matching"	#required, otherwise grid.py fails
		read last_line <<< $(python "$libsvm_folder/tools/grid.py" -out null "train-scale.libsvm"  |tail -1)
		last_line=($last_line)
		c=${last_line[0]}
		g=${last_line[1]}
		
		"$libsvm_folder/svm-train" -c $c -g $g "$training_testing_features/alpha_$alpha/LSB_Matching/train-scale.libsvm"  "$SVMs_folder/alpha_$alpha/LSB_Matching/model"

		read accuracy <<< $("$libsvm_folder/svm-predict" "$training_testing_features/alpha_$alpha/LSB_Matching/test-scale.libsvm" "$SVMs_folder/alpha_$alpha/LSB_Matching/model" "$SVMs_folder/alpha_$alpha/LSB_Matching/predictions.txt")

		cat >"$SVMs_folder/alpha_$alpha/LSB_Matching/Details_Results.txt" <<-EOL
		C Parameter: $c
		G Parameter: $g
		Accuracy: $accuracy
		EOL

done
wait
echo "Finished"
