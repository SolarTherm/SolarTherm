constant=42

import logging, os,shutil,time,functools
logging.disable(logging.WARNING)
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"

import warnings
warnings.filterwarnings("ignore",category =RuntimeWarning)

import numpy as np
np.random.seed(constant)
import tensorflow as tf
tf.random.set_seed(constant)

import pandas as pd
from tensorflow.keras import backend, initializers,optimizers
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense,Dropout
from tensorflow.keras.activations import tanh,relu
from tensorflow.keras.callbacks import EarlyStopping

from sklearn.preprocessing import MinMaxScaler, StandardScaler
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error, r2_score
from sklearn.model_selection import train_test_split
from bayes_opt import BayesianOptimization as BO

import matplotlib.pyplot as plt

class Trainer(object):
    def __init__(self, fn_data, wd="./result_bayesian_opt"):
        self.fn_data = fn_data
        self.wd = wd

        if not os.path.exists(self.wd):
            os.makedirs(self.wd)

        #Split the data into train and test
        self.df = pd.read_csv(self.fn_data).sample(frac=1).reset_index(drop=True)

    def preprocessing_data(self, inputsize=7, outputsize=1, scaling_method="MinMax", output_threshold=0.2):
        self.scaling_method = scaling_method
        self.inputsize = inputsize
        self.outputsize = outputsize 

        self.df = self.df[self.df[self.df.columns[-1]] >= output_threshold]

        self.df_train = self.df[0:int(0.9 * self.df.shape[0])]

        self.df_test = self.df[int(0.1 * self.df.shape[0]):-1]

        #Separate X raw from y raw
        self.X_raw = self.df_train.iloc[:, 0:self.inputsize].to_numpy()
        self.y_raw = self.df_train.iloc[:,self.inputsize: self.inputsize+self.outputsize].to_numpy()

        self.X_test_raw = self.df_test.iloc[:,0:self.inputsize].to_numpy()
        self.y_test_raw = self.df_test.iloc[:,self.inputsize:self.inputsize+self.outputsize].to_numpy()
        
        #Split the train raw data into train and valid data
        self.X_train, self.X_valid, self.y_train, self.y_valid = train_test_split(
            self.X_raw,
            self.y_raw,
            test_size=0.3
        )

        #Convert vector into matrix 2-D if necessary
        if outputsize == 1:
            self.y_train = np.array(self.y_train).reshape(-1,1)
            self.y_valid = np.array(self.y_valid).reshape(-1,1)
            self.y_test_raw = np.array(self.y_test_raw).reshape(-1,1)
        
        #Fit the scaler to training data
        self.scaler_X = MinMaxScaler().fit(self.X_train)
        self.scaler_y = MinMaxScaler().fit(self.y_train)

        #Scale the training data
        self.X_train = self.scaler_X.transform(self.X_train)
        self.y_train = self.scaler_y.transform(self.y_train)

        #Scale the validation data
        self.X_valid = self.scaler_X.transform(self.X_valid)
        self.y_valid = self.scaler_y.transform(self.y_valid)

        #Scale the X test
        self.X_test = self.scaler_X.transform(self.X_test_raw)

    def generate_model(self, dropout, nPercent, nShrink):
        neuronCount = int(nPercent * 20)
        
        #***************************** Construct neural network
        model = Sequential()
        layer = 0

        while neuronCount>2 and layer<5:
            #************************* The first (0th) layer needs an input input_dim(neuronCount)
            if layer==0:
                model.add(Dense(
                    neuronCount, 
                    name = "Input",
                    input_dim=self.inputsize,
                    kernel_initializer="he_uniform",
                    use_bias=True,
                    activation="relu"
                ))
            else:
                model.add(Dense(
                    neuronCount, 
                    kernel_initializer="he_uniform",
                    use_bias=True,
                    activation="relu"
                )) 

            layer += 1

            #*************************** Add dropout after each hidden layer
            model.add(Dropout(dropout,seed=constant))

            #*************************** Shrink neuron count for each layer
            neuronCount = neuronCount * nShrink

        #***************************** Output Layer
        model.add(Dense(
            self.outputsize,
            name="Output",
            kernel_initializer = "he_uniform",
            activation='relu',
            use_bias=True
        ))

        return model
    
    '''
        Function to evaluate the obj fun given set of hyper parameter values
    '''
    def eval_net(self, verbose, loss_function, batch_size, nPercent, nShrink,lr,dropout):

        #****************************** Generate Model
        model = self.generate_model(dropout,nPercent,nShrink)

        #****************************** Compile model and callbacks
        model.compile(
            loss="mse",
            optimizer=optimizers.Adam(lr=lr),
            metrics = ['mse','mae','mape']
        )

        monitor = EarlyStopping(
            monitor="val_mape",
            mode='min', 
            min_delta=0.5,
            patience=500,
            restore_best_weights=True
        )
        
        #****************************** Set epsilon to 1 s.t. mape < 100%
        backend.set_epsilon(1)

        #****************************** Train
        history = model.fit(
            x = self.X_train,
            y = self.y_train,
            validation_data = (self.X_valid,self.y_valid),
            batch_size = int(batch_size),
            epochs = int(5000),
            callbacks = [monitor],
            verbose = verbose
        )

        #****************************** Predict test data
        pred = self.scaler_y.inverse_transform(model.predict(self.X_test))
        
        #*************************** Get the score
        if loss_function.lower() == "mse":
            score = min(history.history["val_loss"])
            score = score * -1
        elif loss_function.lower() == "rmse":
            score = (min(history.history["val_loss"]))**0.5
            score = score * -1
        else:
            raise ValueError(
                "Valid loss function to be optimised are: mse, rmse (case insensitive). Your loss function: %s"%(loss_function)
            )

        #*************************** Create epochs file if it is not there
        fnepoch = "%s/epochs.csv"%(self.wd)
        if not os.path.exists(fnepoch):
            f = open(fnepoch,"w")
            f.write("Epochs_needed\n")
            f.close()
        f = open(fnepoch,"a")
        f.write("%s\n"%(monitor.stopped_epoch))
        f.close()

        #*************************** Create score file if it is not there
        fnscore = "%s/score.csv"%(self.wd)
        if not os.path.exists(fnscore):
            f = open(fnscore,"w")
            f.write("Scores\n")
            f.write("%s\n"%(-10000)) #initial score
            f.close()

        #*************************** Get the best score (RMSE)
        dfscores = pd.read_csv(fnscore)
        bestScore = dfscores.Scores.max()
        
        #****************************** If score at this iteration is better than historical score then:
        if score > bestScore:
            #****************************** Save model 
            model.save("%s/surrogate_model"%(self.wd)) 

            #****************************** Save Prediction vs True data
            PRED = pred[:,0]
            TEST = self.y_test_raw[:,0]

            df = pd.DataFrame(zip(PRED,TEST),columns=['Prediction','Test'])
            df.to_csv("%s/prediction_vs_test.csv"%(self.wd),index=False)

            #****************************** Plot and save
            if loss_function.lower() == "r2":
                s = score
            else:
                s = score * -1
                
            fig,ax = plt.subplots()
            ax.scatter(
                TEST,PRED,c="black",s=2
            )
            ax.set_title("Test vs. Pred value of the best model. %s: %.6f"%(loss_function.upper(),s))
            ax.set_xlabel("Test data")
            ax.set_ylabel("Prediction")
            ax.set_xlim(
                TEST.min(),TEST.max()
            )
            ax.set_ylim(
                TEST.min(),TEST.max()
            )
            fig.savefig("%s/45DegPlot.png"%(self.wd))

            #****************************** Save the boundaries of the better model
            if self.scaling_method == "MinMax":
                maxdata = "%s/max.txt"%(self.wd)
                mindata = "%s/min.txt"%(self.wd)

                Xmax = self.scaler_X.data_max_

                try:
                    ymax = self.scaler_y.data_max_
                except:
                    ymax=[-1000000]

                write=""

                for i in range(len(Xmax)):
                    write+="%s,"%(Xmax[i])
                write+="%s"%(ymax[0])
                f = open(maxdata,"w")
                f.write(write)
                f.close()

                Xmin = self.scaler_X.data_min_

                try:
                    ymin = self.scaler_y.data_min_
                except:
                    ymin = [-1000000]

                write=""
                
                for i in range(len(Xmin)):
                    write+="%s,"%(Xmin[i])
                write+="%s"%(ymin[0])
                f = open(mindata,"w")
                f.write(write)
                f.close()
            else:
                maxdata = "%s/mean.txt"%(self.wd)
                mindata = "%s/std.txt"%(self.wd)

                Xmax = self.scaler_X.mean_

                try:
                    ymax = self.scaler_y.mean_
                except:
                    ymax = [-100000]

                write=""

                for i in range(len(Xmax)):
                    write+="%s,"%(Xmax[i])
                write+="%s"%(ymax[0])
                f = open(maxdata,"w")
                f.write(write)
                f.close()

                Xmin = self.scaler_X.var_

                try:
                    ymin = self.scaler_y.var_
                except:
                    ymin = [-100000]

                write=""
                
                for i in range(len(Xmin)):
                    write+="%s,"%(Xmin[i]**0.5)
                write+="%s"%(ymin[0]**0.5)
                f = open(mindata,"w")
                f.write(write)
                f.close()

        #*********************** Append the score anyway
        f = open(fnscore,"a")
        f.write("%s\n"%(score))
        f.close()

        #****************************** Clear session to release memory
        tf.keras.backend.clear_session()

        return score


