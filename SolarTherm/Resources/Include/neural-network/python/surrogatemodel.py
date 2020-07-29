import numpy as np 
import pandas as pd 
import matplotlib.pyplot as plt
import seaborn as sns 
import os
import pickle

#Import modules inside keras
import tensorflow as tf
from tensorflow.keras import optimizers
from tensorflow.keras import backend
from tensorflow.keras.models import Sequential
from tensorflow.keras.models import model_from_json
from tensorflow.keras.layers import Dense
from tensorflow.keras.activations import relu,tanh,sigmoid

#Import scikitlearn for pre-processing the data
from sklearn.preprocessing import MinMaxScaler, StandardScaler, Normalizer
from sklearn.model_selection import train_test_split

#Import dataset
fn = "/home/philgun/Documents/PhD/Modelica/databank/rcv-eff/training-data-rcv-efficiency/training-data/res.csv"
df = pd.read_csv(fn)

print(df.describe())

#Input and output number
outputdim = 1
inputdim = 4 #in order: q[W], tamb[K],tin_k

#Find the min and max value
minval = df.min()
maxval = df.max()
min=[]
max=[]

for i in range(inputdim):
    min.append(minval[i])
    max.append(maxval[i])

print(minval)
print(maxval)

######################  DATA PRE_PROCESSING ############################ 

#split the raw into input (X) and ouput(y)
X_raw = df[df.columns[0:inputdim]].to_numpy()

y_raw = df[df.columns[-1]].to_numpy()
y_raw = y_raw.reshape(-1,1)

#Import the scaler
mm = MinMaxScaler()

#Scaling the data
X_scaled = mm.fit_transform(X_raw)
y_scaled = mm.fit_transform(y_raw)

#Split into train test - 85% training 15% testing
Xtrain,Xtest,ytrain,ytest = train_test_split(X_scaled,y_scaled,test_size=0.15)

######################  HYPER PARAMETER ############################ 
'''
Literature source to determine  as mmthe hyper parameter
https://web.archive.org/web/20140721050413/http://www.heatonresearch.com/node/707
'''

#Number of neurons in each hidden layer < 2*input_dim
num_neurons = 3*inputdim

#Neural network architecture
network_layout = []
for i in range(5):
    network_layout.append(num_neurons)

activation ='relu'
activation_out = 'relu'
learning_rate = 0.0001
opt = optimizers.Adam(learning_rate = learning_rate)
epochs = 200
batch_size = 128
filename = "/home/philgun/solartherm-particle/SolarTherm/Resources/Include/neural-network/trained-model/surrogate_receiver"

######################  BUILD MODEL ############################ 

#Building the neural network
model = Sequential()

#Adding input layer and first hidden layer
model.add(Dense(network_layout[0],  
                name = "Input",
                input_dim=inputdim,
                kernel_initializer='he_normal',
                activation=activation))

#Adding the rest of hidden layer
for numneurons in network_layout[1:]:
    model.add(Dense(numneurons,
                    kernel_initializer = 'he_normal',
                    activation=activation))

#Adding the output layer
model.add(Dense(outputdim,
                name="Output",
                kernel_initializer="he_normal",
                activation="relu"))

'''
fixing the problem of super high MAPE 
https://stackoverflow.com/questions/49729522/why-is-the-mean-average-percentage-errormape-extremely-high
'''
backend.set_epsilon(1)

#Compiling the model
model.compile(optimizer=opt,loss='mse',metrics=['mse','mae','mape'])
model.summary()

#Training the model
'''
More into epoch and batch size
https://machinelearningmastery.com/difference-between-a-batch-and-an-epoch/
'''
history = model.fit(x=Xtrain,y=ytrain,validation_data=(Xtest,ytest),batch_size=32,epochs=epochs)
print("Save model to disk..................")
model.save(filename) # ===> save model in SavedModel format
print("Done..................")

#Printing final scores from the last epoch
print("History test score: ",history.history["val_loss"][epochs-1])
print("History test percent error : ",history.history["val_mape"][epochs-1])

#Plot loss during training
plt.figure()
plt.plot(history.history['mse'],label='MSE training')
plt.plot(history.history['val_mse'],label='MSE validation')
plt.legend()

plt.figure()
plt.plot(history.history['mae'],label='MAE training')
plt.plot(history.history['val_mae'],label='MAE validation')
plt.title('MAE validation and training',fontsize=20)
plt.legend(fontsize=20)
plt.xlabel('epochs',fontsize=20)
plt.ylabel('MAE',fontsize=20)
plt.legend()

plt.figure()
plt.plot(history.history['mape'],label='MAPE training')
plt.plot(history.history['val_mape'],label='MAPE validation')
plt.title('MAPE validation and training',fontsize=20)
plt.legend(fontsize=20)
plt.xlabel('epochs',fontsize=20)
plt.ylabel('MAPE [%]',fontsize=20)
plt.legend()

plt.show()

# Evaluate the ANN
y_predict = model.predict(X_scaled)
rmse = np.sqrt(np.mean(y_predict - y_scaled)**2)
print("Root mean square error: %s"%rmse)

#Load model from SavedModel format
print("Reload model from disk..................")
loaded_model = tf.keras.models.load_model(filename)
print("Finished loading!")

#Evaluate the model
y_predict_load = loaded_model.predict(X_scaled)
rmse2 = np.sqrt(np.mean(y_predict_load-y_scaled)**2)
print("Root mean square error from loaded model: %s"%rmse2)

assert(rmse-rmse2 < 1e-5)

print("Assertion success!")

#Predict real data
#Get the scaler parameters ~ xmin xmax ymin ymax
df = pd.read_csv(fn)

#split the raw into input (X) and ouput(y)
X_raw = df[df.columns[0:inputdim]].to_numpy()
y_raw = df[df.columns[-1]].to_numpy()
y_raw = y_raw.reshape(-1,1)

#Get the scaler parameters ~ xmin xmax ymin ymax
mmx = MinMaxScaler()
mmy = MinMaxScaler()

mmx.fit(X_raw)
mmy.fit(y_raw)

x = [285700000,	268.15,	803.15,23]
x = np.array(x)
x = np.reshape(x,(-1,len(x)))

#Get the X_scaled ~ input to trained model
X_scaled = mmx.transform(x)

#Open and load the model
loaded_model = tf.keras.models.load_model(filename)

#Predict the y
y_predict = loaded_model.predict(X_scaled)

#Scale back y_predict to the original scale
y_predict = mmy.inverse_transform(y_predict)
#Return the predicted value 
y_predict = float(y_predict[0,-1])

print("y_predict: %.2f "%y_predict)
print("y_real: %.2f "%y_raw[1,0])






