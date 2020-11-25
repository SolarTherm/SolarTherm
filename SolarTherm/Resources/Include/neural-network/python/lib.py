import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
import seaborn as sns 
import os

#Import modules inside keras
import tensorflow as tf
from tensorflow.keras import backend,optimizers,initializers
from tensorflow.keras.models import Sequential
from tensorflow.keras.models import model_from_json
from tensorflow.keras.layers import Dense
from tensorflow.keras.activations import relu,tanh,sigmoid

#Import scikitlearn for pre-processing the data
from sklearn.preprocessing import MinMaxScaler
from sklearn.model_selection import train_test_split

class NNModelSequential(object):
    def __init__(self):
        pass
    def load_training_data(self):
        self.df = pd.read_csv(self.fn_data)

    def pre_process_input(self):
        #loading training data
        self.load_training_data()

        #split the raw into input (X) and ouput(y)
        self.X_raw = self.df[self.df.columns[0:self.input_dim]].to_numpy()

        #Convert to 2D array
        y_raw = self.df[self.df.columns[-1]].to_numpy()
        self.y_raw = y_raw.reshape(-1,1)

        #Import the scaler
        mm = MinMaxScaler()

        #Scaling the data
        X_scaled = mm.fit_transform(self.X_raw)
        y_scaled = mm.fit_transform(self.y_raw)

        #Split into train test - 85% training 15% testing
        self.Xtrain,self.Xtest,self.ytrain,self.ytest = train_test_split(X_scaled,y_scaled,test_size=0.15)
    
    def training_NN(self,fn_data,prefix_res,input_dim,output_dim,network_layout,learning_rate,epochs,batch_size):
        self.fn_data = fn_data
        self.prefix_res = prefix_res
        self.input_dim = input_dim
        self.output_dim = output_dim
        self.network_layout = network_layout
        self.learning_rate = learning_rate
        self.opt = optimizers.Adam(learning_rate = learning_rate)
        self.epochs = epochs
        self.batch_size = batch_size
        self.activation = 'relu'

        #load and pre_processed input
        self.pre_process_input()

        stagnant = True
        while stagnant: #If the model stagnant due to a bad weight initialization, build a new model with the same configuration
            
            ######################  BUILD MODEL ############################ 
            #Building the neural network
            self.model = Sequential()

            #Adding input layer and first hidden layer
            self.model.add(Dense(network_layout[0],  
                            name = "Input",
                            input_dim=self.input_dim,
                            kernel_initializer=initializers.RandomNormal(),
                            bias_initializer=initializers.Zeros(),
                            use_bias=True,
                            activation=self.activation))

            #Adding the rest of hidden layer
            for numneurons in self.network_layout[1:]:
                self.model.add(Dense(numneurons,
                                kernel_initializer=initializers.RandomNormal(),
                                bias_initializer=initializers.Zeros(),
                                activation=self.activation))

            #Adding the output layer
            self.model.add(Dense(self.output_dim,
                            name="Output",
                            kernel_initializer=initializers.RandomNormal(),
                            bias_initializer=initializers.Zeros(),
                            activation=self.activation))

            '''
            fixing the problem of super high MAPE 
            https://stackoverflow.com/questions/49729522/why-is-the-mean-average-percentage-errormape-extremely-high
            '''
            backend.set_epsilon(1)

            #Compiling the model
            self.model.compile(optimizer=self.opt,loss='mse',metrics=['mse','mae','mape'])
            self.model.summary()

            #Training the model
            '''
            More into epoch and batch size
            https://machinelearningmastery.com/difference-between-a-batch-and-an-epoch/
            '''
            history = self.model.fit(
                x=self.Xtrain,
                y=self.ytrain,
                validation_data=(self.Xtest,self.ytest),
                batch_size=self.batch_size,
                epochs=self.epochs
                )

            losses = history.history['val_loss'][:]

            for i in range(len(losses)-1):
                delta = losses[i+1]-losses[i]
                print('delta=',delta)
                if delta < 0:
                    stagnant=False

        #Save model
        self.fn_res = self.prefix_res+'surrogate_model_1'

        i=1
        while os.path.exists(self.fn_res):
            i+=1
            print(i)
            self.fn_res = self.prefix_res+'surrogate_model_%s'%(i)
        

        print("Save model to disk..................")
        self.model.save(self.fn_res) # ===> save model in SavedModel format
        print("Done..................")
    
    def predict(self,x,y):
        self.mmx = MinMaxScaler().fit(self.X_raw)
        self.mmy = MinMaxScaler().fit(self.y_raw)
        x = np.array(x)
        x = np.reshape(x,(-1,len(x)))
        X_scaled = self.mmx.transform(x)
        
        #Load the session and predict scaled value
        self.load_NN()
        y_predict = self.loaded_model.predict(X_scaled)

        #Predict real value
        y_predict_real = self.mmy.inverse_transform(y_predict)

        print('prediction =',y_predict_real[0,0],'true value = ',y)
        return y_predict_real

        
    def load_NN(self):
        self.loaded_model = tf.keras.models.load_model(self.fn_res)
    

