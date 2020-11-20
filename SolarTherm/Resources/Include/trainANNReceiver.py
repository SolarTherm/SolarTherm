import numpy as np
import os
import tensorflow as tf
import argparse

constant = 42
tf.random.set_seed(constant)
np.random.seed(constant)


from tensorflow.keras import backend, initializers, optimizers
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.activations import relu,tanh

from sklearn.preprocessing import MinMaxScaler,StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error as mae
from sklearn.metrics import r2_score

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
        network_layout = [15,15,15]

    #Hyper Parameter
    lr = 0.001
    batch_size=128
    activation = 'relu'
    initializer = 'he_uniform'

    epochs = 2500
    input_dim = 5
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
    
    print(model.X_raw)
    
    maxdata = "%s/max.txt"%(prefix_res)
    mindata = "%s/min.txt"%(prefix_res)

    X_max = model.data_max_X
    y_max = model.data_max_y

    X_min = model.data_min_X
    y_min = model.data_min_y

    write_max = "%s,%s,%s,%s,%s,%s"%(X_max[0],X_max[1],X_max[2],X_max[3],X_max[4],y_max[0])
    write_min = "%s,%s,%s,%s,%s,%s"%(X_min[0],X_min[1],X_min[2],X_min[3],X_min[4],y_min[0])

    w = open(maxdata,'w')
    w.write(write_max)
    w.close()

    w = open(mindata,'w')
    w.write(write_min)
    w.close()

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
        verbose=1,
        with_validation=False
    )

    #Test
    y_predict = model.predict(x = model.X_raw)
    y_true = model.y_raw

    Y = np.concatenate((y_predict,y_true),axis=1)
    np.savetxt('%s/predvstrain%s.csv'%(prefix_res,count),Y,delimiter=',')

    #model.plot_history()
    print('it took %s s'%(time.time() - now))

    #Read validation data
    fn_val = "%s/validation_data.csv"%(prefix_res)
    raw = np.genfromtxt(fn_val,skip_header=1,delimiter=',')

    X_raw_val = raw[:,0:input_dim]
    y_raw_val = raw[:,input_dim:input_dim+output_dim]
    y_pred_val_real = model.predict(x=X_raw_val)

    Y = np.concatenate((y_predict,y_true),axis=1)
    np.savetxt('%s/predvsval%s.csv'%(prefix_res,count),Y,delimiter=',')

    r2 = r2_score(y_raw_val,y_pred_val_real)
    score = mae(y_raw_val,y_pred_val_real)

    print("================================================================================================================")
    print("================================================================================================================")
    print("MAE: %s\n"%(score))
    print("R squared : %s\n"%(r2))
    print("================================================================================================================")
    print("================================================================================================================")

    fnscore = "%s/score.txt"%(prefix_res)
    f = open(fnscore,'a')
    f.write("%s,%s\n"%(score,r2))
    f.close()

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
