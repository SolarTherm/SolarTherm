import pandas as pd
import numpy as np
import math
'''
df = pd.read_csv('solana_tmy_2008_original_data.csv')
df.loc[df.dni<0,"dni"] = 0

#Check the nan
for i in range(df.shape[0]):
    if i%1000 == 0:
        print(i)

    bb = np.isnan(df.iloc[i])

    if any(bb) == True:
        #Check if the previous data does not contain any nan
        cc = np.isnan(df.iloc[i-1])
        if not any(cc) == True:
            df.iloc[i] = df.iloc[i-1]


df["time"] = [x * 300 for x in range(105121)]
df["hour"] = [int(x/3600) for x in df.time]

df.to_csv("solana_clean_5Minutes.csv",index=False)
'''
df = pd.read_csv("solana_clean_5Minutes.csv")

df = df.drop(axis=0, index=df.index[-1])

#Average data
data = df.groupby(by="hour").agg(np.nanmean).reset_index().drop(columns="hour")
data.time = [x * 3600 for x in range(8760)]
data.to_csv("solana_clean_hourly.csv",index=False)

#15 minutes weather data
df_ = pd.read_csv("solana_clean_5Minutes.csv")[0:-1]
df_.hour = [int(x/(15*60)) for x in df_.time]
data = df_.groupby(by="hour").agg(np.nanmean).reset_index().drop(columns="hour")
data.time = [x * 900 for x in range(35040)]
data.to_csv("solana_clean_15Minutes.csv",index=False)

#30 minutes weather data
df_ = pd.read_csv("solana_clean_5Minutes.csv")[0:-1]
df_.hour = [int(x/(30*60)) for x in df_.time]
data = df_.groupby(by="hour").agg(np.nanmean).reset_index().drop(columns="hour")
data.time = [x * 1800 for x in range(17520)]
data.to_csv("solana_clean_30Minutes.csv",index=False)

        


