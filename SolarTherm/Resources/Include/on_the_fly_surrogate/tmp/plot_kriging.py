import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
import tensorflow as tf
from sklearn.preprocessing import MinMaxScaler
import seaborn as sns
import random
import time

eta_Q_base = 0.9998537337
eta_gross_base = 0.49991927091306

fn_test = "/home/philgun/Documents/codecodecode/codecodecode/GSL_Project/test_data/19_Oct_2020/test_data.csv"
df_test = pd.read_csv(fn_test)

fn_krig = './result_kriging_400.csv'
df_krig = pd.read_csv(fn_krig,header=None)
df_krig.columns = ['eta_gross_krig','eta_Q_krig']

saved_model_dir_eta_gross = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/sCO2_Trained_Model/concept-deviation/eta_gross/surrogate_model_0"
saved_model_dir_eta_Q = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/sCO2_Trained_Model/concept-deviation/eta_Q/surrogate_model_0"
model_gross = tf.keras.models.load_model(saved_model_dir_eta_gross)
model_Q = tf.keras.models.load_model(saved_model_dir_eta_Q)

fn_data_training_gross = '/home/philgun/Documents/codecodecode/codecodecode/GSL_Project/training_data/19_Oct_2020/deviation_eta_gross.csv'
fn_data_training_Q =  '/home/philgun/Documents/codecodecode/codecodecode/GSL_Project/training_data/19_Oct_2020/deviation_eta_Q.csv'
df = pd.read_csv(fn_data_training_Q)
X = df[df.columns[0:3]]
q = df.deviation_eta_Q
gross = pd.read_csv(fn_data_training_gross).deviation_eta_gross
mmx = MinMaxScaler().fit(X)

mmq = MinMaxScaler().fit(np.array(q).reshape(-1,1))
mmgross = MinMaxScaler().fit(np.array(gross).reshape(-1,1))


df_test = df_test[df_test.columns[6:9]]
df_test['load'] = 1 - df_test.load
df_test['T_HTF_in'] = 1243.27 - df_test.T_HTF_in
df_test['T_amb_input'] = 39 + 273.15- df_test.T_amb_input
X_test = df_test[df_test.columns[0:3]]

X_test_scaled = mmx.transform(X_test)

print(X_test_scaled)
now = time.time()
q_pred_real = eta_Q_base - mmq.inverse_transform(model_Q.predict(X_test_scaled))
gross_pred_real = eta_gross_base - mmgross.inverse_transform(model_gross.predict(X_test_scaled))
delta = time.time() - now
print('it took %s seconds for ANN to compute'%(delta))

df_test = pd.read_csv(fn_test)
df_test = pd.concat([df_test,df_krig],axis=1)

df_test = pd.concat(
    (
        df_test,
        pd.DataFrame(gross_pred_real,columns=['eta_gross_ANN']),
        pd.DataFrame(q_pred_real,columns=['eta_Q_ANN'])
        ),axis=1
)

med = 15
fig,axes = plt.subplots(2,3)
fig.tight_layout(pad=2.5)
lendata = len(df_test)
varname = ['load','T_HTF_in','T_amb_input']
labels = ['load','$T_{HTF,in}$ K','$T_{amb,in}$ K']


for i,ax in enumerate(axes.flat):
	if i < 3:
		dfplot = df_test[i*10:(i+1)*10]
		ax.plot(dfplot[varname[i]],dfplot.eta_gross,label='expensive',marker='^')
		ax.plot(dfplot[varname[i]],dfplot.eta_gross_krig,label='kriging',ls='--',marker='o')
		ax.plot(dfplot[varname[i]],dfplot.eta_gross_ANN,label='ANN',ls='-.',marker='o')
		ax.tick_params(axis='both',labelsize=med)
		ax.set_xlabel(labels[i],fontsize=med)
		ax.set_ylabel("$\eta_{PB}$",fontsize=med)
		ax.set_title("$\eta_{PB}$ vs. %s"%labels[i],fontsize=med)

		if i==0:
			ax.scatter(1,0.4999192709,marker='s',c='k',s=60)
		
		elif i==1:
			ax.scatter(1243.27,0.4999192709,marker='s',c='k',s=60)
		
		elif i==2:
			ax.scatter(312.15,0.4999192709,marker='s',c='k',s=60)
		ax.legend(fontsize=med)

	else:
		dfplot = df_test[(i-3)*10:(i-3+1)*10]
		print(dfplot)
		ax.plot(dfplot[varname[i-3]],dfplot.eta_Q,label='expensive',marker='^')
		ax.plot(dfplot[varname[i-3]],dfplot.eta_Q_krig,label='kriging',marker='o',ls='--')
		ax.plot(dfplot[varname[i-3]],dfplot.eta_Q_ANN,label='ANN',marker='o',ls='-.')
		ax.legend(fontsize=med)
		ax.tick_params(axis='both',labelsize=med)
		ax.set_xlabel(labels[i-3],fontsize=med)
		ax.set_ylabel("$\eta_{HX}$",fontsize=med)
		ax.set_title("$\eta_{HX}$ vs. %s"%labels[i-3],fontsize=med)

		if i==3:
			ax.scatter(1,0.9998537337,marker='s',c='k',s=60)
		
		elif i==4:
			ax.scatter(1243.27,0.9998537337,marker='s',c='k',s=60)
		
		elif i==5:
			ax.scatter(312.15,0.9998537337,marker='s',c='k',s=60)
			#ax.yaxis.set_ticks(np.linspace(0.998,1.001,5))

fig.suptitle('100 Training Points for Kriging and ANN, 30 Test Points , Kriging computing time = 0.021 s, ANN %s s, ANN training time 140 s'%(round(delta,2)),fontsize=med)

plt.show()
