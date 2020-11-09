import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
import tensorflow as tf
from sklearn.preprocessing import MinMaxScaler
import seaborn as sns
import random
import time
from mpl_toolkits.mplot3d import Axes3D
import seaborn as sns

T_HTF_in_base = 1243.27
load_base = 1
T_amb_base = 39 + 273.15
eta_Q_base = 0.9998537337
eta_gross_base = 0.49991927091306

#KRIGING SECTION
fn_test = "/home/philgun/Documents/codecodecode/codecodecode/GSL_Project/test_data/20_Oct_2020/test_data_OAT.csv"
df_test = pd.read_csv(fn_test)

fn_krig = './result_kriging100.csv'
df_krig = pd.read_csv(fn_krig,header=None)
df_krig.columns = ['eta_gross_krig','eta_Q_krig']
#END OF KRIGING SECTION

#ANN SECTION
saved_model_dir_eta_gross = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/sCO2_Trained_Model/concept-deviation/eta_gross/surrogate_model_2"
saved_model_dir_eta_Q = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/sCO2_Trained_Model/concept-deviation/eta_Q/surrogate_model_2"
model_gross = tf.keras.models.load_model(saved_model_dir_eta_gross)
model_Q = tf.keras.models.load_model(saved_model_dir_eta_Q)

fn_data_training_gross = '/home/philgun/Documents/codecodecode/codecodecode/GSL_Project/training_data/config0/deviation_eta_gross.csv'
fn_data_training_Q =  '/home/philgun/Documents/codecodecode/codecodecode/GSL_Project/training_data/config0/deviation_eta_Q.csv'
df = pd.read_csv(fn_data_training_Q)
X = df[df.columns[0:3]]
q = df.deviation_eta_Q
gross = pd.read_csv(fn_data_training_gross).deviation_eta_gross
mmx = MinMaxScaler().fit(X)

mmq = MinMaxScaler().fit(np.array(q).reshape(-1,1))
mmgross = MinMaxScaler().fit(np.array(gross).reshape(-1,1))

df_test = df_test[df_test.columns[6:9]]
df_test['load'] = load_base - df_test.load
df_test['T_HTF_in'] = T_HTF_in_base - df_test.T_HTF_in
df_test['T_amb_input'] = T_amb_base- df_test.T_amb_input
X_test = df_test[df_test.columns[0:3]]

X_test_scaled = mmx.transform(X_test)

print(X_test_scaled)
now = time.time()
q_pred_real = eta_Q_base - mmq.inverse_transform(model_Q.predict(X_test_scaled))
gross_pred_real = eta_gross_base - mmgross.inverse_transform(model_gross.predict(X_test_scaled))
delta = time.time() - now
print('it took %s seconds for ANN to compute'%(delta))
#END OF ANN SECTION

df_test = pd.read_csv(fn_test)
df_test = pd.concat([df_test,df_krig],axis=1)

df_test = pd.concat(
    (
        df_test,
        pd.DataFrame(gross_pred_real,columns=['eta_gross_ANN']),
        pd.DataFrame(q_pred_real,columns=['eta_Q_ANN'])
        ),axis=1
)

df_test = df_test.drop(columns=df_test.columns[11])
df_test = df_test[df_test.columns[6:]]

T_amb_unique = df_test.T_amb_input.unique()

for i in range(len(T_amb_unique)):
    T_amb = T_amb_unique[i]
    if T_amb != 312.15:
        dfsort = df_test[df_test.T_amb_input==T_amb]
        dfsort['deviation_eta_gross_kriging'] = dfsort['eta_gross'] - dfsort['eta_gross_krig']
        dfsort['deviation_eta_Q_kriging'] = dfsort['eta_Q'] - dfsort['eta_Q_krig']
        dfsort['deviation_eta_gross_ANN'] = dfsort['eta_gross'] - dfsort['eta_gross_ANN']
        dfsort['deviation_eta_Q_ANN'] = dfsort['eta_Q'] - dfsort['eta_Q_ANN']

        print(dfsort)

        LOAD = dfsort['load'].to_numpy().reshape(5,5)
        T_HTF_IN = dfsort['T_HTF_in'].to_numpy().reshape(5,5)
        DEV_PB_KRIG = dfsort['deviation_eta_gross_kriging'].to_numpy().reshape(5,5)
        DEV_HX_KRIG = dfsort['deviation_eta_Q_kriging'].to_numpy().reshape(5,5)
        DEV_PB_ANN = dfsort['deviation_eta_gross_ANN'].to_numpy().reshape(5,5)
        DEV_HX_ANN =  dfsort['deviation_eta_Q_ANN'].to_numpy().reshape(5,5)

        DEVIATIONS = []
        DEVIATIONS.append(DEV_PB_KRIG)
        DEVIATIONS.append(DEV_PB_ANN)
        DEVIATIONS.append(DEV_HX_KRIG)
        DEVIATIONS.append(DEV_HX_ANN)

        fig,axes = plt.subplots(2,2)
        fig.tight_layout(pad=2)

        med=15

        subtitles = [
            "Kriging Absolute Deviation $\eta_{PB}$",
            "ANN Absolute Deviation $\eta_{PB}$",
            "Kriging Absolute Deviation $\eta_{HX}$",
            "ANN Absolute Deviation $\eta_{HX}$",
            "Distribution of Kriging Deviation $\eta_{PB}$",
            "Distribution of ANN Deviation $\eta_{PB}$"
            "Distribution of Kriging Deviation $\eta_{HX}$",
            "Distribution of ANN Deviation $\eta_{HX}$"
            ]


        for j,ax in enumerate(axes.flat):
            dev = abs(DEVIATIONS[j])
            clev = np.linspace(1e-9,5e-2,100)
            plot = ax.contourf(LOAD, T_HTF_IN,dev,clev, cmap='inferno')
            cons = ax.contour(LOAD,T_HTF_IN,dev,color='k')

            ax.clabel(cons,inline=1,fmt='%.0e')
            ax.set_xlabel("Load",fontsize=med)
            ax.set_ylabel("$T_{HTF,in}$ K",fontsize=med)
            ax.tick_params(axis='both',labelsize=med)
            colorbar = fig.colorbar(plot,ax=ax,format='%.0e')
            colorbar.set_label("Absolute Deviation",rotation=270,labelpad=20,fontsize=med)
            ax.set_title(subtitles[j],fontsize=med)



        
        fig.suptitle("100 Training Data Points Absolute Deviation of The Surrogate Models for $T_{amb}$ %s K"%(T_amb),fontsize=med)
        plt.show()



'''
        
        xlabel = ["Kriging Deviation $\eta_{PB}$",
        "ANN Deviation $\eta_{PB}$",
        "Kriging Deviation $\eta_{HX}$",
        "ANN Deviation $\eta_{HX}$"
        ]
            elif j >= 4:
                dev = DEVIATIONS[i-4]
                sns.distplot(dev,kde=False,ax=ax)
                print(subtitles[i])
                ax.set_title(subtitles[i],fontsize=med)
                ax.set_xlabel(xlabel[i-4],fontsize=med)
                ax.set_ylabel("Frequency",fontsize=med)
                '''



