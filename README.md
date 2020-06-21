# Comparing the Detectability of LSB Replacement and LSB Maching with respect to Embedding Impact

Work related to the unit: CCE5208 - Multimedia Security

This work compares LSB Replacement and LSB Matching in the spatial domain of 8bpp, 512x512 pixel images.

A variable embedding capacity (alpha) is used. This determines the amount of pixels which will contin infromation. A maximum of 1 single bit can be represented per image pixel. If alpha < 1 (ie, not all pixels have embedding information), then the selection of pixels which do have information is distributed randomly in the image.

A script to perform extraction of the hidden data is also included.

Apart from embedding information in images, this work also makes use of and SVM classifier (from LibSVM), which is trained to determine whether images have hidden information or not. It is trained on Subractive Pixel Adjacency Matrix (SPAM) feature set to perform blind steganalysis. SPAM feature extraction was used, but not implemented. It was obtained from this link : https://jabriffa.wordpress.com/other/hugo-source-code/.

The report also gives details of the detection accuracy for both methods, for varying values of alpha.