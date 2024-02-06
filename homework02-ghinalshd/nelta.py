#Ghina Al Shdaifat - N12299542 - gha2009 
#Homeowrk #2
import csv
class LabeledList:
    def __init__(self, data=None, index=None):
        if index is None:
            index = list(range(len(data)))
        self.values = data
        self.index = index

    def __str__(self):
        max_len = max([len(str(label)) for label in self.index])
        s = ''
        for label, value in zip(self.index, self.values):
            s += f'{label:>{max_len}} {value}\n'
        return s
    '''
        s = ''
        max_len = max([len(str(label)) for label in self.index])
        vals_max_len = max([len(str(v)) for v in self.values])
        format_spec = f'>{max_len}'
        for index, data in zip(self.index, self.values):
            s += f'{index:{format_spec}} {str(data):>{vals_max_len}}\n'
        return s
        '''
    
    def __repr__(self):
        return self.__str__()
    
    def __gt__(self, scalar):
        return LabeledList([value > scalar for value in self.values], self.index)
    
    def __lt__(self, scalar):
        return LabeledList([value < scalar for value in self.values], self.index)
    
    def map(self,f):
        return LabeledList(list(map(f, self.values)), self.index)
    
    def __eq__(self, scalar):
        return LabeledList([value == scalar for value in self.values], self.index)
    
    def __ne__(self, scalar):
        return LabeledList([value != scalar for value in self.values], self.index)
    
    def __iter__(self):
        return iter(self.values)

    def __next__(self):
        if self.index < len(self.values):
            result = self.values[self.index]
            self.index += 1
            return result
        else:
            raise StopIteration
        
    def __getitem__(self, key_list):
        # try our best to make list of keys:
        # 1. first, if it's a labeled list, use the labeled list's 
        #    values property as the list of keys
        if isinstance(key_list, LabeledList):
            key_list = key_list.values
        # 2. at this point, if we still don't have a list, then assume we 
        #    have a non-sequence type, and wrap in a list
        if not isinstance(key_list, list):
            key_list = [key_list]
        # now that we definitely have a list... check if it's only
        # booleans; one way to do this is filter for only boolean values
        # and check the length against the original unfiltered list
        if len([v for v in key_list if type(v) is bool]) == len(key_list):
            # we have a bunch of booleans, keep only the values that
            # have the same label as the labels that have true
            return self.__filter(key_list) 
        else:
            # we have a bunch of keys... so get all values with a matching
            # label / key
            index = [] # labels for returned LabeledList
            data = []  # values for returned LabeledList
            for key in key_list: 
                # find key matches, and get back both the label and value
                for label, val in self.__find(key):
                    index.append(label)
                    data.append(val)
            return data[0] if len(data) == 1 else LabeledList(data, index)

    def __filter(self, filter_list):
        """ given a list of booleans, only give back the values
        that align with True as a LabeledList
        """
        index = []
        data = []
        if len(filter_list) != len(self.index):
            raise IndexError('Length of indexes does not match length of boolean list')
        for i, include in enumerate(filter_list):
            if include:
                index.append(self.index[i])
                data.append(self.values[i])
        return LabeledList(data, index)
    
    def __find(self, k):
        """give back all labels and values based on key
        """
        index, data = [], []
        matches = [(label, self.values[i]) for i, label in enumerate(self.index) if k == label]
        if len(matches) == 0:
            raise KeyError(f'Index label not found {k}')
        return matches
    

    
class Table:
    def __init__(self, data, index = None, columns = None):
        if index is None:
            index = list(range(len(data)))
        if columns is None:
            columns = list(range(len(data[0])))
        self.values = data
        self.index = index
        self.columns = columns

    def __str__(self):
        s = '\t'
        max_len = max([len(str(label)) for label in self.index])
        vals_max_len = max([len(str(v)) for v in self.values])
        for i in self.columns:
            s+=str(i)+'\t'
        s+='\n'
        format_spec = f'>{max_len}'
       
        for index, data in zip(self.index, self.values):
            string = '\t'
            string += '\t'.join(map(str,data))
            s += f'{index:{format_spec}}{string:{vals_max_len}}\n'
        return s
        '''
        # Calculate column widths
        col_widths = [max(len(str(col)), max(len(str(row[i])) for row in self.data)) for i, col in enumerate(self.columns)]

        # Create the header row
        header_row = ' ' * (max(col_widths) + 1)
        header_row += ' '.join([f'{col:{width}}' for col, width in zip(self.columns, col_widths)])
        header_row += '\n'

        # Create rows for data
        data_rows = ''
        for i, row in enumerate(self.data):
            data_rows += f'{self.index[i]:>{max(len(str(self.index[i])), max(col_widths))}} | '
            data_rows += ' '.join([f'{cell:{col_widths[j]}}' for j, cell in enumerate(row)])
            data_rows += '\n'

        return header_row + data_rows
        
        max_row_label_width = max([len(str(label)) for label in self.index])
        max_col_label_width = max([len(str(label)) for label in self.columns])
        format_spec = f'>{max_col_label_width}'
        result = ''
        result+= ' ' * (max_row_label_width + 1)
        for col_label in self.columns:
            result += f'{col_label:{format_spec}} '
        result += '\n'
        # Print rows with labels
        for i, row in enumerate(self.values):
            result += f'{self.index[i]:>{max_row_label_width}} | '
            for value in row:
                result += f'{value:{format_spec}} '
            result += '\n'
        return result
        '''
    
    def __repr__(self):
        return self.__str__()
    
    def __getitem__(self, col_list):
        #1. if the key is a LabeledList, select columns based on its values
        if isinstance(col_list, LabeledList):
            selected_columns = [col for col in self.columns if col in col_list.values]
            selected_data = [[row[self.columns.index(col)] for col in selected_columns] for row in self.values]
            return Table(selected_data, self.index, selected_columns)
        elif isinstance(col_list, list):
            if all(isinstance(col, bool) for col in col_list):
                #if the key is a list of boolean values, select the rows based on 'True' values
                if len(col_list) != len(self.index):
                    raise IndexError("Length of boolean list does not match the number of rows.")
                selected_data = [row for row, include in zip(self.values, col_list) if include]
                return Table(selected_data, [label for label, include in zip(self.index, col_list) if include], self.columns)
            else:
                #if the key is a list of column names, select specified columns
                selected_columns = [col for col in self.columns if col in col_list]
                selected_data = [[row[self.columns.index(col)] for col in selected_columns] for row in self.values]
                return Table(selected_data, self.index, selected_columns)
        else:
            #if the key is a single value, select that column for all rows
            if col_list in self.columns:
                selected_data = [[row[self.columns.index(col_list)]] for row in self.values]
                return LabeledList([value[0] for value in selected_data], self.index)
            else:
                raise KeyError(f"Column '(col_list)' not found in the table.")

    def head(self, n):
        if n <=0:
            raise ValueError("n must be a positive integer.")
        if n>= len(self.index):
            return self
        return Table(self.values[:n], self.index[:n], self.columns)
    
    def tail(self, n):
        if n <= 0:
            raise ValueError("n must be a positive integer.")
        if n>=len(self.index):
            return self
        return Table(self.values[-n:], self.index[-n:], self.columns)
    
    def shape(self):
        return (len(self.index), len(self.columns))
    
    def read_csv(fn):
        with open(fn) as f:
            reader = csv.reader(f)
            columns = next(reader)
            data = []
            for row in reader:
                data_row = []
                for item in row:
                    try:
                        data_row.append(float(item))
                    except ValueError:
                        data_row.append(item)
                data.append(data_row)
        index = [i for i in range(len(data))]
        return Table(data, index, columns)
        
    
    if __name__ == '__main__':
        pass


