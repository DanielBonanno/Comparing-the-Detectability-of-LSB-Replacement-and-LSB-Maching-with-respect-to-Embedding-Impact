from PIL import Image
import numpy as np
import random
import sys
import os.path

def LSB_Extraction(stego_image, output_file, alpha, key):

    #load the stego image and transform it into a 1d array
    im = Image.open(stego_image)
    (x, y) = im.size
    stego = np.array(im.getdata()).reshape(y, x)
    stego_1d = stego.ravel()

    #initlialize a random number generator, with the key being the seed and
    #obtain a list of indexes which denote which pixels were changed
    message_length = int(round(alpha*x*y))
    random.seed(key)
    indexes = random.sample(xrange(x*y), message_length)

    #obtain the LSB of each pixel
    data = (stego_1d[indexes] %2)

    #save the data in the output file specified
    with open(output_file, 'w') as output_file:
        for bit in data:
            output_file.write("%s\n" % bit)


if __name__ == "__main__":
    if(len(sys.argv) != 5):
        print('Incorrect number of input arguments.')
        print('4 arguments must be input: the stego image name, the output file name, alpha and the key')
        sys.exit()

    stego_image = sys.argv[1]
    output_file = sys.argv[2]

    #ensure alpha and key are numeric
    try:
        alpha = float(sys.argv[3])
    except ValueError:
        print('Please enter a number for alpha')
        sys.exit()

    try:
        key = int(sys.argv[4])
    except ValueError:
        print('Please enter a number for the key')
        sys.exit()


    #Check that alpha is in range
    if (alpha<=0):
        print('Alpha must be greater than 0')
        sys.exit()
    if(alpha>1):
        print('Alpha must be less than or equal to 1')
        sys.exit()

    #Check stego image does exist
    if (not(os.path.exists(stego_image))):
        print('Stego image does not exist')
        sys.exit()

    LSB_Extraction(stego_image, output_file, alpha,key)

