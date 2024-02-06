#Collobarated and worked with Molshree Singhal (N14131306)

class DecodeError(Exception): #'DecodeError' inherits from the base 'Exception'
    def __init__(self, message="Error decoding bits"):
        super().__init__(message) #initialize the exception with the provided message 

class ChunkError(Exception):
    def __init__(self, message="Error in chunking bits"):
        super().__init__(message) #initialize the exception with the provided message 


class BitList:
    #Method #1: the string should only consist of 0's and 1's
    #Error: ValueError
    def __init__ (self, bits):
        if not all(bit in '01' for bit in bits):
            raise ValueError("Format is invalid; does not consist of only 0's and 1's")
        self.bits = bits
    #Method #2: Equality on instances of this class
    def __eq__(self, other):
        if isinstance(other, BitList):
            return self.bits == other.bits
        return False
    #Method #3: supplying integers directly to a @staticmethod from_ints
    @staticmethod
    def from_ints(*ints):
        bits = ''.join(str(int(bit)) for bit in ints)
        if not all(bit in '01' for bit in bits):
            raise ValueError("Format is invalid; does not consist of only 0's and 1's")
        return BitList(bits)
    #Method #4: Converting to a str (no spaces between each bit)
    def __str__(self):
        return self.bits
    #Method #5: Bits in the series shifting left or right by one 
    # right -> left most bit should be duplicated
    # left -> a zero should be added to the right
    def arithmetic_shift_left(self):
        #if self.bits:
        self.bits = self.bits[1:] + '0'
    def arithmetic_shift_right(self):
        bits = self.bits[0] #identify the first element
        leftover = self.bits[:-1]
        self.bits = bits + leftover
        #if self.bits:
        #self.bits = '1' + self.bits[:-1]
    #Method #6: Another instance of 'BitList' (returning a new 'BitList' instance)
    def bitwise_and(self, otherBitList):
        if len(self.bits) != len(otherBitList.bits):
            raise ValueError("BitLists must have the same length for bitwise AND operation")
        result_bits = '' #new variable to store new BitList
        for bit1, bit2 in zip(self.bits, otherBitList.bits):
            #if the first element of both lists are equal to 1, then element = 1
            if bit1== '1' and bit2 == '1':
                result_bits += '1'
            else:
                result_bits += '0'
        return BitList(result_bits)
    #Method #7: Splitting the list (returns a list of lists containing the bits)
    def chunk(self, chunk_length):
        if len(self.bits) % chunk_length !=0:
            raise ChunkError("Cannot evenely split BitList into chunks of the specified length")
        chunks = [self.bits[i:i+chunk_length] for i in range(0, len(self.bits), chunk_length)]
        #final_list = [BitList(chunk) for chunk in chunks]
        #return final_list
        final_list = [list(map(int, chunk)) for chunk in chunks]
        return final_list
    #Method #8: Encoding a string and returning a string
    def decode(self, encoding='utf-8'):
        if encoding not in ['us-ascii', 'utf-8']:
            raise ValueError("Unsupported encoding")
        if encoding== 'us-ascii':
            ascii_str = ""
            # Loop through 8 bits at a time
            for i in range(0, len(self.bits), 7):
                decimal = int(self.bits[i:i+7], 2)
                ascii_char = chr(decimal)
                ascii_str += ascii_char
            return ascii_str

        # Initialize variables
        byte_idx = 0
        decoded_characters = ''
        chunked = [self.bits[start:start + 8] for start in range(0, len(self.bits), 8)]

        while byte_idx < len(chunked):
            leading_byte = chunked[byte_idx]

            if leading_byte[0] == '0':
                # Single-byte character
                decoded_characters += chr(int(leading_byte, 2))
                byte_idx += 1
            else:
                # Multi-byte character
                s = ''

                if leading_byte[:3] == '110':
                    num_cont_bytes = 1
                    s += leading_byte[3:]
                elif leading_byte[:4] == '1110':
                    num_cont_bytes = 2
                    s += leading_byte[4:]
                elif leading_byte[:5] == '11110':
                    num_cont_bytes = 3
                    s += leading_byte[5:]
                else:
                    raise DecodeError('Invalid leading byte')

                for _ in range(num_cont_bytes):
                    byte_idx += 1
                    cont_byte = chunked[byte_idx]

                    if cont_byte[:2] == '10':
                        s += cont_byte[2:]
                    else:
                        raise DecodeError("Invalid continuation byte")

                decoded_characters += chr(int(s, 2))
                byte_idx += 1

        return decoded_characters