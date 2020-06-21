import sys
import os.path
import random

def Different_Cover_Stego(Features_File, output_file):
    #open the file and read the features
    text_file = open(Features_File, "r")
    features = [temp.strip('\n\r') for temp in text_file]
    text_file.close()

    #the number of images to be used is the actual length divided by 2
    # (since there are cover and stego counterparts of the same image)
    #Ex: cover_1, cover_2, cover_3, cover_4, stego_from_1, stego_from_2, stego_from_3, stego_from_4
    # but we will keep: cover_1, cover_3, stego_from_2, stego_from 4
    number_of_images = len(features)/2;

    #split the features into 2 different arrays
    #Ex: features_neg = cover_1, cover_2, cover_3, cover_4
    #    features_pos = stego_from_1, stego_from_2, stego_from_3, stego_from_4
    features_neg = features[0:number_of_images]
    features_pos = features[number_of_images:len(features)]

    #obtain a random list of indexes
    #Ex: 0, 2, 1, 4
    indexes = random.sample(range(0, number_of_images), number_of_images)

    #split this random list into indexes that will be kept from the cover and from the stego set
    #Ex: indexes_neg = 0, 2
    #    indexes_pos = 1, 3
    indexes_neg = indexes[0:number_of_images/2]
    indexes_pos = indexes[number_of_images/2:len(indexes)]

    #Set the output
    #Ex: cover_1, cover_3, stego_from_2, stego_from 4
    output = []
    for i in range(0,len(indexes_neg)):
        output.append(features_neg[indexes_neg[i]])
    for i in range(0,len(indexes_pos)):
        output.append(features_pos[indexes_pos[i]])

    #write the output to file
    with open(output_file, 'w') as output_file:
        for line in range(0, len(output)):
            output_file.write("%s \n" % output[line])

if __name__ == "__main__":
    if(len(sys.argv) != 3):
        print('Incorrect number of input arguments.')
        print('2 arguments must be input: the features file name and output file name')
        sys.exit()

    features_file = sys.argv[1]
    output_file = sys.argv[2]

    #Check that the feature files exist
    if (not (os.path.exists(features_file))):
        print('Features file does not exist')
        sys.exit()

    Different_Cover_Stego(features_file, output_file)

