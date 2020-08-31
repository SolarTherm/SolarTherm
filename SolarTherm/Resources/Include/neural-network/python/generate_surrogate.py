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

#import costum module
from lib import NNModelSequential

fn_data = "/home/philgun/Documents/PhD/Modelica/databank/rcv-eff/training_data_rcv_eff_20082020/res.csv"
prefix_res = "/home/philgun/solartherm-particle/SolarTherm/Resources/Include/neural-network/trained-model/"
input_dim = 4 
output_dim = 1
learning_rate = 0.0001
epochs = 200
batch_size = 32

#Number of neurons in each hidden layer < 2*input_dim
num_neurons = 3*input_dim

#Neural network architecture
network_layout = []
for i in range(5):
    network_layout.append(num_neurons)

model = NNModelSequential()
model.training_NN(
    fn_data,
    prefix_res,
    input_dim,
    output_dim,
    network_layout,
    learning_rate,
    epochs,
    batch_size
    
)
x = [783459291.3,314.275101,828.283384,31.161965]
predict = model.predict(x,0.95)



