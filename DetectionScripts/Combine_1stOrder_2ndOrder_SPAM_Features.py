import sys
import os.path

def Combine_Features(Order1_File, Order2_File, output_file):
    #open the file and read the first order features
    #the newline and the name of the image file are stripped
    #due to the way the features are processed when converted to libsvm features, 
    #the last value must also be stripped. this is identical in both files.
    #if this value is not stripped, we end up with an extra feature
    text_file = open(Order1_File, "r")
    Order_1 = [temp.strip('\n\r') for temp in text_file]
    Order_1 = [line.rsplit(' ', 2)[0] for line in Order_1]
    text_file.close()

    #Similarly, read in the second order features. the newline and
    #image name are not stripped this time
    text_file = open(Order2_File, "r")
    Order_2 = text_file.readlines()
    text_file.close()

    #combine the features into a single line
    Combined = [o1+ " " + o2 for o1, o2 in zip(Order_1, Order_2)]

    #write the output to file
    with open(output_file, 'w') as output_file:
        for line in range(0, len(Combined)):
            output_file.write("%s" % Combined[line])

if __name__ == "__main__":
    if(len(sys.argv) != 4):
        print('Incorrect number of input arguments.')
        print('3 arguments must be input: the first order features file name, the second order features file name and output file name')
        sys.exit()

    order_1_file = sys.argv[1]
    order_2_file = sys.argv[2]
    output_file =  sys.argv[3]

    #Check that the feature files exist
    if (not (os.path.exists(order_1_file))):
        print('1st Order Features file does not exist')
        sys.exit()

    if (not (os.path.exists(order_2_file))):
        print('2nd Order Features file does not exist')
        sys.exit()

    Combine_Features(order_1_file, order_2_file, output_file)
