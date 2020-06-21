from PIL import Image
import numpy as np
import random
import sys
import os.path

def LSB_Matching(cover_image, stego_image, data_file, alpha, key):
    #read the data file into an array
    text_file = open(data_file, "r")
    data = [temp.strip('\n\r') for temp in text_file]
    data = [int(i) for i in data]
    text_file.close()

    #obtain the number of bits to be embedded
    message_length = len(data)

    #load the cover image and copy the data over to the stego image
    im = Image.open(cover_image)
    (x, y) = im.size
    stego = np.array(im.getdata()).reshape(y, x)

    #work out the capacity according to the alpha value specified
    capacity = int(round(alpha*x*y))

    #if the message is too large, display this information to the user and exit
    if(message_length>capacity):
        print('Data is too large')
        return None

    #make the stego image a 1d array. this will make indexing easier
    stego_1d = stego.ravel()

    #initlialize a random number generator, with the key being the seed
    #(this is required so that the decoder can also get the same random numbers)
    #obtain a list of indexes, which denote which pixels must be changed
    random.seed(key)
    indexes = random.sample(xrange(x*y), message_length)

    #from the random pixels selected, check which LSBs need to be changed by the LSB matching algorithm
    bit_changes = abs((stego_1d[indexes] % 2) - data)

    #for every LSB that needs to be changed
    for i in range(0,len(bit_changes)):
        if (bit_changes[i] == 1):
            #select 0 or 1 randomly
            add_or_sub = random.randint(0,1)
            #if the random number is a 0 and the pixel value is not 255 OR the pixel value is a 0, add 1
            if ((add_or_sub == 0) and (stego_1d[indexes[i]] != 255)) or (stego_1d[indexes[i]] == 0):
                stego_1d[indexes[i]] = stego_1d[indexes[i]] + bit_changes[i]
            #otherwise, subtract 1
            else:
                stego_1d[indexes[i]] = stego_1d[indexes[i]] - bit_changes[i]

    #save the stego image
    im = Image.fromarray(np.uint8(stego))
    im.save(stego_image)

if __name__ == "__main__":
    if(len(sys.argv) != 6):
        print('Incorrect number of input arguments.')
        print('5 arguments must be input: the cover image name, the stego image name, the data file name, the alpha parameter and the key')
        sys.exit()

    cover_image = sys.argv[1]
    stego_image = sys.argv[2]
    data_file = sys.argv[3]

    #ensure alpha and key are numeric
    try:
        alpha = float(sys.argv[4])
    except ValueError:
        print('Please enter a number for alpha')
        sys.exit()

    try:
        key = int(sys.argv[5])
    except ValueError:
        print('Please enter a number for the key')
        sys.exit()


    # Check that alpha is in range
    if (alpha <= 0):
        print('Alpha must be greater than 0')
        sys.exit()
    if (alpha > 1):
        print('Alpha must be less than or equal to 1')
        sys.exit()

     # Check cover image and data file exist
    if (not (os.path.exists(cover_image))):
        print('Cover image does not exist')
        sys.exit()

    if (not (os.path.exists(data_file))):
        print('Data file does not exist')
        sys.exit()

    LSB_Matching(cover_image, stego_image, data_file, alpha, key)