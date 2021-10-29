import pandas as pd
import numpy as np
from matplotlib import pyplot as plt
from DyMat import DyMatFile as D
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
import os
import argparse
from solartherm import simulation
import shutil

class Data(object):
    def __init__(self,fnmat="res.mat"):
        self.fnmat = fnmat
        self.data = D(self.fnmat)

    def gen_dataframe(self):
        time = self.data.abscissa("epsilon_stg",valuesOnly=True)
        try:
            SOC = self.data.data("tank_level")
        except:
            SOC = self.data.data("thermocline_Tank.SOC")
        mdot = self.data.data("thermocline_Tank.Tank_A.m_flow")
        epsilon = self.data.data("epsilon_stg")
        self.t_cycle = self.data.data("t_cycle")[-1]

        #Generate the data frame
        self.df = pd.DataFrame(
            zip(time,SOC,mdot,epsilon),
            columns=["time","SOC","mdot","epsilon"]
        )

        #All the Ls
        try:
            self.SOC_start_charging = self.data.data("SOC_start_charging")[-1]
            self.SOC_stop_charging = self.data.data("SOC_stop_charging")[-1]
            self.SOC_start_discharging = self.data.data("SOC_start_discharging")[-1]
            self.SOC_stop_discharging = self.data.data("SOC_stop_discharging")[-1]

            if self.SOC_start_discharging < 1e-3:
                self.SOC_start_discharging = self.SOC_stop_discharging * 1.05
        except:
            df_charging = self.df[self.df.mdot<0]
            self.SOC_stop_charging = df_charging.SOC.max()
            self.SOC_start_charging = self.SOC_stop_charging - 0.05
            df_discharging = self.df[self.df.mdot>0]
            self.SOC_stop_discharging = df_discharging.SOC.min()
            self.SOC_start_discharging = self.SOC_stop_discharging + 0.05

        return self.df
    
    def gen_training_data(self):
        #*************** Gen data for only the equilibrium cycle
        self.df_charging = self.df[
            (self.df.mdot < 0) & 
            (self.df.time > 5 * self.t_cycle)
        ]

        self.df_discharging = self.df[
            (self.df.mdot>0) &
            (self.df.time > 5 * self.t_cycle)
        ]

        #Replace all the epsilon that is greater than 1 with 1
        self.df_discharging.loc[self.df_discharging.epsilon > 1.0, "epsilon"] = 1
        self.df_charging.loc[self.df_charging.epsilon > 1.0, "epsilon"] = 1

        #self.df_discharging = self.df_discharging.drop(
        #    self.df_discharging[
        #        (self.df_discharging.SOC>0.75) & (self.df_discharging.epsilon<0.99)
        #    ].index
        #)
        
        return self.df_charging.drop(columns="time"), self.df_discharging.drop(columns="time")

    def init_plot(self):
        fig,axes = plt.subplots(1,2)
        fig.tight_layout(pad=2)
        dfs = [self.df_charging, self.df_discharging]
        titles = ["$\epsilon$ vs. level charging","$\epsilon$ vs. level discharging"]
        for i,ax in enumerate(axes.flat):
            df = dfs[i]
            ax.scatter(
                df.SOC, df.epsilon, c = "red", s = 5
            )
            ax.set_xlabel(
                "State-of-charge [-]"
            )
            ax.set_ylabel(
                "$\epsilon$"
            )
            ax.set_title(titles[i])
            ax.set_xlim(0,1.01)
            ax.set_ylim(0,1.01)
        plt.show()

def find_L_flat(df,mode):
    print(mode)
    if mode == "charging":
        df = df.sort_values(by="epsilon",ascending=False).reset_index(drop=True)
    else:
        df = df.sort_values(by="epsilon",ascending=False).reset_index(drop=True)

    #Search the L_flat
    L_flat = None
    y_flat = df.epsilon.iloc[0]

    for i in range(df.shape[0]):
        dy = y_flat - df.epsilon.iloc[i]
        if dy != np.nan:
            if abs(dy) > 2e-3:
                L_flat = df.SOC.iloc[i+1]
                break
    return L_flat
                
def regression(df, plot = False, mode = "charging"):
    #Find the L_flat
    L_flat = find_L_flat(df,mode)
    if mode == "charging":
        df_reg = df[
            df.SOC > L_flat
        ]
    elif mode == "discharging":
        df_reg = df[
            df.SOC < L_flat
        ]
    else:
        raise ValueError("Either charging or discharging. Your mode is {}".format(mode))

    #Do the polynomial regression
    X = df_reg.SOC.to_numpy().reshape(-1,1)
    y = df_reg.epsilon.to_numpy().reshape(-1,1)

    poly = PolynomialFeatures(
        degree = 5, 
        include_bias=False
    )

    X = poly.fit_transform(X)
    print(poly.get_feature_names())

    #Do the Multi-variate linear regression
    model = LinearRegression()
    model.fit(X,y)
    coef = model.coef_
    intercept = model.intercept_
    
    #Predict the y_pred using pure matrix multiplication
    #y_pred = X@coef.T + np.full((X.shape[0],1), intercept)
    y_pred = model.predict(X)

    #Surrogate model metrics
    r2 = r2_score(y_pred, y)
    mse = mean_squared_error(y, y_pred)

    #Plot?
    fig,ax = plt.subplots()
    ax.scatter(
        df.SOC, df.epsilon,label="Full data", s = 1, c = "black"
    )

    #Plot true data
    ax.scatter(
        X[:,0],y,label="Ground truth", s = 5, c = "red"
    )
    ax.scatter(
        X[:,0],y_pred,label="Prediction", s =5, c = "blue"
    )
    ax.axvline(L_flat,label="Flat region limit",ls="--",c="green")
    ax.legend()
    ax.set_xlabel("State-of-charge")
    ax.set_ylabel("$\epsilon$")
    ax.set_title(
        "R2 = %.3f MSE: %.5f"%(r2,mse)
    )
    if plot == True:
        plt.show()
    else:
        plt.savefig("./%s.png"%(mode))

    return [round(val,3) for val in coef[0]], intercept, L_flat

def run_regression(param):
    #All params to start the simulation
    T_max = param["T_max"]
    T_min = param["T_min"]
    eta = param["eta"]
    d_p = param["d_p"]
    E_max = param["E_max"]
    t_storage = param["t_storage"]
    ar = param["ar"]
    cwd = param['cwd']
    fn_mo = param["fn_mo"]
    
    #Copy fn_mo to cwd
    if not os.path.exists(cwd):
        os.makedirs(cwd)

    shutil.copy(fn_mo, cwd)

    print(
        "\n\nSimulating constant charging-discharging for 6-cycles with parameters:\n"
    )
    for key, value in param.iteritems():
        print("%s : %s"%(key,value))

    sim_start_time = str(0)
    t_cycle  = 2 * t_storage * 3600
    sim_end_time = str(t_cycle * 6) #6-cycles

    print(
        "6-cycle period: %s s\n\n"%(t_cycle * 6)
    )

    #Start the simulation
    sim = simulation.Simulator(fn_mo, suffix = "0")
    sim.compile_model()
    sim.compile_sim()

    par_n = ["T_max","T_min","eta","d_p","E_max","t_storage","ar"]
    par_v = [
        str(T_max), str(T_min), str(eta), str(d_p), str(E_max), str(t_storage), str(ar)
    ]

    sim.load_init()
    sim.update_pars(par_n, par_v)

    sim.simulate(
        start=sim_start_time, 
        stop=sim_end_time, 
        step="30", 
        tolerance="1e-03",
        solver="dassl",
        nls="homotopy"
    )

    #Read data and generate datafarmes
    fn_mat = "Part2_MgO_6h_10h_8h_res_0.mat"
    data = Data(fn_mat)
    data.gen_dataframe()
    df_charging, df_discharging = data.gen_training_data()

    #Regression
    C_charging,intercept_charging, L_flat_chg = regression(df_charging, plot=False, mode="charging")
    C_discharging, intercept_discharging, L_flat_dis = regression(df_discharging, plot=False, mode="discharging")

    C_storage = data.data.data("thermocline_Tank.Tank_A.C_section")[-1]

    #Return list with 14 length
    res = []
    
    for c in C_charging:
        res.append(c)
    for c in intercept_charging:
        res.append(c)
    
    for c in C_discharging:
        res.append(c)
    for c in intercept_discharging:
        res.append(c)
        
    res.append(L_flat_chg)
    res.append(L_flat_dis)
    res.append(C_storage)

    try:
        assert(len(res) == 15)
    except:
        raise ValueError("Return list dimension is not 15. The dimension is %s"%(len(res)))
        pass

    print(
        "Coeff charging: ", C_charging
    )

    print(
        "Intercept charging: ", intercept_charging
    )

    print(
        "Coeff discharging: ", C_discharging
    )

    print(
        "Intercept discharging: ", intercept_discharging
    )

    print(
        "L_flat charging: ", L_flat_chg
    )

    print(
        "L_flat discharging: ", L_flat_dis
    )

    print(
        "C_storage [USD]: ", C_storage
    )

    return res

if __name__ == '__main__':
    #Instantiate parser
    param = {
        "T_max" : 720 + 273.15,
        "T_min" : 510 + 273.15,
        "eta": 0.26,
        "d_p" : 0.1,
        "E_max" : 8.64e12,
        "t_storage"  : 10,
        "ar" : 2.0,
        "cwd" : "./test",
        "fn_mo": "/home/philgun/solartherm-zeb/SolarTherm/Systems/Publications/Thermocline/Constant_Charging/Time_Controlled/Part2_MgO_6h_10h_8h.mo"
    }
    res = run_regression(param)
    for r in res:
        print(r)
