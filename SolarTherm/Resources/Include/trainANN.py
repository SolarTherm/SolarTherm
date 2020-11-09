import numpy as np
import os
import tensorflow as tf
import argparse

#constant = 42
constant = 21
tf.random.set_seed(constant)
np.random.seed(constant)


from tensorflow.keras import backend, initializers, optimizers
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.activations import relu,tanh

from sklearn.preprocessing import MinMaxScaler,StandardScaler
from sklearn.model_selection import train_test_split

import libANN as ANNlib
import pandas as pd

import time

#FIXME: ENABLE HYPERPARAMETER OPTIMISATION

def trainANN(fn_data,prefix_res,count):
    count = int(count)
    print("Training data: %s"%fn_data)
    print("Prefix of the result folder: %s"%prefix_res)
    now = time.time()

    #Network architecture - Non Deviation Model
    #The best architecture for eta_gross = [15,15,15]
    #The best architecture for eta_Q = [15,15]
    #for eta_gross, the best epoch is 300
    #for eta_Q, the best epoch is 475

    #Network architecture - #Deviation Model
    #400 training points
    #The best architecture for eta_gross  = [50,50,50,50,50,50]
    #for eta_gross, the best epoch is 1500, batch size 32, lr 0.001

    #The best architecture for eta_Q  = [60,60,60,60,60,60]
    #for eta_Q, the best epoch is 1500 , batch size 32, lr 0.001

    #50 training points
    #The best architecture for eta_gross = [60,60,60,60,60,60]
    #for eta_gross , the best epoch is 1500, batch size 32, lr 0.001

    #The best architecture for eta_Q   = [60,60,60,60,60,60]
    #for eta_Q, the best epoch is 3000 , batch size 32, lr 0.001

    #100 training points
    #The best architecture for eta_gross  = [45,45,45,45]
    #for eta_gross, the best epoch is 2500, batch size 20, lr 0.001
    #generalised scaler = true

    #The best architecture for eta_Q  = [10,10,10,10]
    #for eta_Q, the best epoch is 2500 , batch size 20w, lr 0.001

    #Training data
    if count==0:
        network_layout = [50,50,50,50,50,50]
    elif count==1:
        network_layout = [60,60,60,60,60,60]

    #Hyper Parameter
    lr = 0.001
    batch_size=32
    activation = 'relu'
    initializer = 'he_uniform'

    epochs = 1500
    input_dim = 3
    output_dim = 1

    if not os.path.exists(prefix_res):
        os.makedirs(prefix_res)

    #Load Data
    model = ANNlib.NNModelSequential()
    model.preprocessingInput(
        fn_data=fn_data,
        input_dim=input_dim,
        output_dim=output_dim,
        scaling_method='MinMaxScaler',
        test_size=0.2,
        generalised_scaler=True
        )

    #Training my NN
    model.training_NN(
        prefix_res = prefix_res,
        input_dim = input_dim,
        output_dim = output_dim,
        network_layout=network_layout,
        learning_rate=lr,
        epochs=epochs,
        batch_size=batch_size,
        count=count,
        activation=activation,
        initializer=initializer,
        ES=False,
        verbose=0,
        with_validation=False
    )

    #Test
    y_predict = model.predict(x = model.X_raw)
    y_true = model.y_raw

    Y = np.concatenate((y_predict,y_true),axis=1)
    np.savetxt('%s/predvstrue%s.csv'%(prefix_res,count),Y,delimiter=',')

    #model.plot_history()
    print('it took %s s'%(time.time() - now))

    saved_model_path = model.fn_res

    return saved_model_path

if __name__=="__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        'file_path_training_data',
        help = 'file path to the training data',
        type = str
        )

    parser.add_argument(
        'prefixres',
        help = 'prefix of the result',
        type = str,
        default = '.'
    )

    parser.add_argument(
        'count',
        help = 'index of the folder in which the surrogate ANN model will be saved',
        type = str,
        default = "0"
    )

    arguments = parser.parse_args()

    filepath = arguments.file_path_training_data
    prefixres = arguments.prefixres
    count = arguments.count

    trainANN(filepath,prefixres,count)
    print(os.getcwd())
