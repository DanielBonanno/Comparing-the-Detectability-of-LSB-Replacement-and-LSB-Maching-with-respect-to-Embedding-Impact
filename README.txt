Order in which to run:

Get_Stego_Images.sh
Get_Spam_Features.sh
Get_Training_Testing_Sets.sh
SVM_Train_Test.sh

Some Notes:
Get_Stego_Images.sh works on the images found in the folder Covers (not included) which were labelled 1.pgm, 2.pgm.... The dataset from where these images were obtained is referenced in the report.

Furthermore, this script makes use of the Python scripts developed in Question 2. These are looked for in the folder Question 2/ , in an upper level.

Both libsvm-3.22 and the Spam Feature Extraction Tools are donwloaded from resources referenced in the report. Their internal structure was not modified (only makefiles were run with default settings).

The results were obtained from the SVM folder created by the final script. However, this also included the SVM models and the predictions, which are not included due to size issues. Thus, these were copy-pasted over.
