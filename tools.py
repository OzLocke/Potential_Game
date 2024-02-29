import math
import numpy as np

def query_subarray(df, target):
    #Convert board into a numpy array
    df = np.array(df)
    #Get the indices of the subarray that contains the piece (col_indices is not used, but the functin requires it exist)
    row_indices, col_indices = np.nonzero(df == target)
    #Pull the row itself, using ravel to remove excess arrays (e.g. turns [[0,1]] to [0,1])
    return(np.ravel(df[row_indices]))