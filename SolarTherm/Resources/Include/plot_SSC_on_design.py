import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

df = pd.read_csv("res_ssc_on_design.csv")
dfturchi = pd.read_csv("turchi_on_design_recomp_thermal_eff.csv")
dfneises = pd.read_csv("neises_on_design_recomp_thermal_eff.csv")
med = 12
fig,ax = plt.subplots()
ax.plot(df.TIT,df.eta_cycle,marker="o",c='k',ls="--",label="SSC $\eta_{cycle}$")
#ax.plot(dfturchi.TIT,dfturchi.eta_cycle,marker="^",c='red',label="Turchi $\eta_{cycle}$")
ax.plot(dfneises.UA,dfneises.eta_cycle,marker="^",c='red',label="Neises $\eta_{cycle}$")

ax.set_xlabel("UA value [MW/K]",fontsize=med)
ax.set_ylabel("Cycle Thermal Efficiency",fontsize=med)
ax.set_title("Comparison of SolarTherm SSC vs. Neises et. al.",fontsize=med)
ax.legend(fontsize=med)
ax.tick_params(axis='both',labelsize=med)
ax.grid(True)
plt.show()
