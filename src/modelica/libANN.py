import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '0' 

#Import modules inside keras
import tensorflow as tf
from tensorflow.keras import backend,optimizers,initializers
from tensorflow.keras.models import Sequential
from tensorflow.keras.models import model_from_json
from tensorflow.keras.layers import Dense
from tensorflow.keras.activations import relu,tanh,sigmoid
from tensorflow.keras.callbacks import EarlyStopping

#Import scikitlearn for pre-processing the data
from sklearn.preprocessing import MinMaxScaler, StandardScaler
from sklearn.model_selection import train_test_split

class NNModelSequential(object):
    def __init__(self):
        pass
    def load_training_data(self):
        self.raw = np.genfromtxt(
            self.fn_data,
            delimiter=',',
            skip_header=1
        )

    def preprocessingInput(self, fn_data, input_dim, output_dim, scaling_method='MinMaxScaler',test_size=0.15,generalised_scaler=False):
        self.fn_data = fn_data

        #loading training data
        self.load_training_data()

        #split the raw into input (X) and ouput(y)
        self.X_raw = self.raw[:,0:input_dim]
        self.y_raw = self.raw[:,input_dim:input_dim+output_dim]

        #Split into train test - 85% training 15% testing
        Xtrain_raw, Xvalid_raw, ytrain_raw, yvalid_raw = train_test_split(
            self.X_raw, 
            self.y_raw,
            test_size=test_size
        )

        if generalised_scaler==False:
            #Import the scaler
            if scaling_method == 'MinMaxScaler':
                self.mmx = MinMaxScaler().fit(Xtrain_raw)
                self.mmy = MinMaxScaler().fit(ytrain_raw)
            elif scaling_method == 'StandardScaler':
                self.mmx = StandardScaler().fit(Xtrain_raw)
                self.mmy = StandardScaler().fit(ytrain_raw)
            else:
                raise Exception('scaling_method should be either MinMaxScaler or StandardScaler. {} is not valid'.format(scaling_method))
        
        else:
            #Import the scaler
            if scaling_method == 'MinMaxScaler':
                self.mmx = MinMaxScaler().fit(self.X_raw)
                self.mmy = MinMaxScaler().fit(self.y_raw)
            elif scaling_method == 'StandardScaler':
                self.mmx = StandardScaler().fit(self.X_raw)
                self.mmy = StandardScaler().fit(self.y_raw)
            else:
                raise Exception('scaling_method should be either MinMaxScaler or StandardScaler. {} is not valid'.format(scaling_method))
            
        #Scaling the data
        self.Xtrain = self.mmx.transform(Xtrain_raw)
        self.ytrain = self.mmy.transform(ytrain_raw)

        self.Xvalid = self.mmx.transform(Xvalid_raw)
        self.yvalid = self.mmy.transform(yvalid_raw)
        if scaling_method =='MinMaxScaler':
            #data max and min
            self.data_max_X = self.mmx.data_max_
            self.data_max_y = self.mmy.data_max_

            self.data_min_X = self.mmx.data_min_
            self.data_min_y = self.mmy.data_min_ 
    
    def initiate_early_stop(self):
        self.es = EarlyStopping(monitor='loss', mode='min',verbose=1,patience=500,restore_best_weights=True)
  
    def training_NN(self,prefix_res,input_dim,output_dim,network_layout,learning_rate,epochs,batch_size,count,activation,initializer,ES=False,verbose=1,with_validation=False,with_decay=False):
        self.prefix_res = prefix_res
        self.input_dim = input_dim
        self.output_dim = output_dim
        self.network_layout = network_layout
        self.learning_rate = learning_rate
        if with_decay:
            self.opt = optimizers.Adam(learning_rate = learning_rate,decay=0.001/epochs)
        else:
            self.opt = optimizers.Adam(learning_rate = learning_rate)
        self.epochs = epochs
        self.batch_size = batch_size
        self.activation = activation
        self.kernel_initializer = initializer

        if not os.path.exists(self.prefix_res):
            os.makedirs(self.prefix_res)

        ######################  BUILD MODEL ############################ 
        #Building the neural network
        self.model = Sequential()

        #Adding input layer and first hidden layer
        self.model.add(Dense(network_layout[0],  
                        name = "Input",
                        input_dim=self.input_dim,
                        kernel_initializer=self.kernel_initializer,
                        use_bias=True,
                        activation=self.activation))

        #Adding the rest of hidden layer
        for numneurons in self.network_layout[1:]:
            self.model.add(Dense(numneurons,
                            kernel_initializer=self.kernel_initializer,
                            use_bias = True,
                            activation=self.activation))

        #Adding the output layer
        self.model.add(Dense(self.output_dim,
                        name="Output",
                        kernel_initializer=self.kernel_initializer,
                        use_bias=True,
                        activation=self.activation))

        '''
        fixing the problem of super high MAPE 
        https://stackoverflow.com/questions/49729522/why-is-the-mean-average-percentage-errormape-extremely-high
        '''
        backend.set_epsilon(1)

        #Training the model
        '''
        More into epoch and batch size
        https://machinelearningmastery.com/difference-between-a-batch-and-an-epoch/
        '''

        #discard previous weight and start from fresh when the model got stuck
        print("COMPILE!")
        self.model.compile(optimizer=self.opt,loss='mse',metrics=['mse','mae','mape'])
        
        self.model.summary()
            
        if ES : #Use early stopping
            if with_validation:
                self.initiate_early_stop()
                self.history = self.model.fit(
                x=self.Xtrain,
                y=self.ytrain,
                validation_data=(self.Xvalid,self.yvalid),
                batch_size=self.batch_size,
                epochs=self.epochs,
                verbose=verbose,
                callbacks=[self.es]
                )
            else:
                self.initiate_early_stop()
                self.history = self.model.fit(
                x=self.Xtrain,
                y=self.ytrain,
                batch_size=self.batch_size,
                epochs=self.epochs,
                verbose=verbose,
                callbacks=[self.es]
                )

        else:
            self.history = self.model.fit(
            x=self.Xtrain,
            y=self.ytrain,
            validation_data=(self.Xvalid,self.yvalid),
            batch_size=self.batch_size,
            epochs=self.epochs,
            verbose=verbose
            )
        
        losses = self.history.history['loss'][:]
            
        #Save model
        self.fn_res = self.prefix_res+'/surrogate_model_%s'%(count)
        
        print(self.fn_res)
        print("Save model to disk..................")
        self.model.save(self.fn_res) # ===> save model in SavedModel format
        print("Done..................")
        return self.model
    
    def predict(self,x):
        X_scaled = self.mmx.transform(x)
        
        #Load the session and predict scaled value
        self.load_NN()
        y_predict = self.loaded_model.predict(X_scaled)

        #Predict real value
        y_predict_real = self.mmy.inverse_transform(y_predict)
        return y_predict_real
        
    def load_NN(self):
        self.loaded_model = tf.keras.models.load_model(self.fn_res)

    def plot_history(self):
        print("Test score : %s"%(self.history.history['val_loss'][self.epochs-1]))
        print("Error Percentage : %s"%(self.history.history['val_mape'][self.epochs-1]))

        fig,axes = plt.subplots(1,2)
        name1 = ['mse','mape']
        label1 = ['MSE Training','MAPE Training']

        name2 = ['val_mse','val_mape']
        label2 = ['MSE Validation','MAPE Validation']

        ylabel=['Value','Value[%]']

        for i,ax in enumerate(axes.flat):
            ax.plot(
                self.history.history[name1[i]],
                label=label1[i]
                )
                
            ax.plot(
                self.history.history[name2[i]],
                label=label2[i]
                )

            ax.set_xlabel('Epochs')
            ax.set_ylabel(ylabel[i])
            ax.legend()
        
        plt.show()
        




