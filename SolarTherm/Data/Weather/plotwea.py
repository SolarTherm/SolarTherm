import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

df = pd.read_csv("solana_tmy_2008.csv")

df.loc[df.DNI < 0,"DNI"] = 0

for c in df.columns:
	df.loc[np.isnan(df[c]) ,c] = 0

df.to_csv("solana_2008_noNAN.csv",index=False)

lb,ub = 0,20

fig,ax = plt.subplots()

ax.plot(
	df.time/ (24*3600),df.DNI
)
ax.set_xlabel("Day")
ax.set_ylabel("DNI")
ax.set_xlim(lb,ub)
plt.show()
