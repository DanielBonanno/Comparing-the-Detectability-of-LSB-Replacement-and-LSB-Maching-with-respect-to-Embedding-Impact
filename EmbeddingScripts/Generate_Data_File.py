import random
import sys

#Function to create a data file with a random binary stream, dependent on the alpha value given
def Generate_Data(output_file, alpha):
    # calculate message length based on the alpha provided
    message_length = int(round(alpha*512*512))

    #generrate a random 0 or 1 and write it to file
    with open(output_file, 'w') as output_file:
        for i in range(0, message_length):
            output_file.write("%s\n" % random.randint(0, 1))

if __name__ == "__main__":

    #Check that there are enough input arguments
    if(len(sys.argv) != 3):
        print('Incorrect number of input arguments.')
        print('2 arguments must be input: the output file name and the alpha required')
        sys.exit()

    #Assign them to the corresponding variables
    output_file = sys.argv[1]

    #ensure alpha is numeric
    try:
        alpha = float(sys.argv[2])
    except ValueError:
        print('Please enter a number for alpha')
        sys.exit()


    #Check that alpha is in range
    if (alpha<=0):
        print('Alpha must be greater than 0')
        sys.exit()
    if(alpha>1):
        print('Alpha must be less than or equal to 1')
        sys.exit()

    #Call the function
    Generate_Data(output_file, alpha)