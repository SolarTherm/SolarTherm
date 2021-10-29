from scipy.optimize import minimize, Bounds
from scipy import optimize
import numpy as np
import functools
from matplotlib import pyplot as plt
import random
import sys

def sigmoid(x, pars):
    """ 
        https://stackoverflow.com/questions/43213069/fit-bipolar-sigmoid-python
        General sigmoid function
        a adjusts amplitude : T_max
        b adjusts y offset  : T_min
        c adjusts x offset  : the smaller the c, the more sigmoid moves to the right
        d adjusts slope 
    """
    a,b,c,d = pars

    y = ((a-b) / (1 + np.exp(-d*(x-c)))) + b
    return y

def customFunction(x, pars):
    #Function: superposition of sigmoid
    a,b,c,d,e,f,g,h = pars
    
    y1 = sigmoid(x,[a,b,c,d])
    y2 = sigmoid(x,[e,f,g,h])
    
    return y1 - y2

def mse(x,T,pars):
    y = sigmoid(x,pars)
    L2 = sum((T - y)**2)/y.shape[0]

    return L2

def estimate_offset(T):
    #Sigmoid is always symetrical, as such location of the offset point will always be around when the temperature is at the average
    if abs(T[-1] - T[0]) > 1e-3: #If the remperature is not flat
        average_temp = sum(T)/len(T)

        #Locate where the offset is
        offset = np.where(T>average_temp)
        offset = (offset[0][0]+ offset[0][0]-2)/2
    else:
        offset = 100
    return offset

def estimate_top_bot_temp(T):
    if T[-1] - T[0] > 1e-3: #If the remperature is not flat
        T_bot = T[0]
        T_top  = T[-1]
    else:   
        T_bot,T_top = T[0],T[0]          
        
    return T_bot, T_top

def fit(input):
    # Get the input from dictionary
    T = input["Temperatures"]
    N = input["num_discretisation"]
    try:
        u_flow = input["u_flow"]
    except:
        u_flow = 100

    #Several assertions
    try:
        assert(len(T) == N)
    except:
        raise AssertionError("Length of temperature from Modelica is not the same as the number of discretisation. Num. of discretisation is %s, length of temperature array is %s"%(N,len(T)))
    
    #Convert type of T if necessary
    if not isinstance(T,np.ndarray):
        T = np.array(T).reshape(-1,)

    #Discretisations
    X = np.arange(1,N+1,dtype=np.int32)

    #Partially initialise the model
    objfunc = functools.partial(
        mse,    #Lost function (L2)
        X,      #Discretisations
        T       #True temp
    )

    #Initial values
    T_max_init, T_min_init = estimate_top_bot_temp(T)
    offset_init = estimate_offset(T)

    if u_flow <0: 
        #Charging
        bounds = Bounds(
                [max(T)-40  , min(T)-40 ,   -20,   0],          #LB
                [max(T)     , min(T)    ,   120,   2]          #UB                    
        )

        #Since when charging flows comes from the top of the tank, the pertubation comes from the top (offset 100)
        par0 = [
            max(T),min(T), offset_init, 0.5
        ]

    else:
        #Charging
        bounds = Bounds(
                [max(T)-40  , min(T)-40 ,   -20,   0],          #LB
                [max(T)     , min(T)    ,   120,   2]          #UB                    
        )

        #Since when charging flows comes from the top of the tank, the pertubation comes from the top (offset 100)
        par0 = [
            max(T),min(T), offset_init, 0.5
        ]
    
    #Do the regression - method: Trust Constraint of scipy
    res = minimize(
        objfunc,par0,method="trust-constr",bounds=bounds
    )

    params = []
    
    for p in res.x:  
        params.append(p)
    
    #Return the params of regression
    return params

if __name__=='__main__':
    fig,ax = plt.subplots()
    import random
    for _ in range(1000):
        #Check if the formulation of sigmoid can only lead to a single solution
        T_max = random.uniform(680+273.15,720+273.15)
        T_min = random.uniform(510+273.15,550+273.15)
        offset = random.uniform(0.0,100)
        slope = random.uniform(1e-3,1.0) 

        e = -10
        f = 0
        g = 100
        h = 0.5

        uniform = random.random()>0.9

        if uniform:            
            print("UNIFORM!!")
            y_true = np.ones((100,)) * (510+273.15)

        else:
            y_true = customFunction(
                np.arange(1,101,1,dtype=np.int32), 
                [
                    T_max,
                    T_min,
                    offset,
                    slope,
                    e,f,g,h
                ]
            )
        
        for _ in range(5):   
            inputs = {"Temperatures": y_true, "num_discretisation" : y_true.shape[0], "u_flow": -100}

            res = np.array(fit(inputs))

            print(res)

            y_pred = customFunction(np.arange(1,101,1,dtype=np.int32), res)

            score = sum((y_pred - y_true)**2)/y_true.shape[0]

            ax.plot(
                np.arange(1,101,1,dtype=np.int32),y_true,label="True"
            )
            
            ax.plot(
                np.arange(1,101,1,dtype=np.int32),y_pred,label="Regression"
            )
            ax.legend()

            ax.yaxis.set_ticks(np.arange(490+273.15, 750+273.15,10))
        
            if not uniform:
                ax.set_title(
                    "T_max %s, T_min %s, offset %s, slope %s ,e %s f %s g %s h %s\nT_max_pred %s, T_min_pred %s, offset_pred %s, slope_pred %s, e_pred %s, f pred %s g pred %s h pred %s"%(
                        round(T_max,3),
                        round(T_min,3),
                        round(offset,3),
                        round(slope,3),
                        round(e,3),
                        round(f,3),
                        round(g,3),
                        round(h,3),
                        round(res[0],3),
                        round(res[1],3),
                        round(res[2],3),
                        round(res[3],3),
                        round(res[4],3),
                        round(res[5],3),
                        round(res[6],3),
                        round(res[7],3)
                    )
                )
                
            else:
                ax.set_title(
                    "UNIFORM\nT_max_pred %s, T_min_pred %s, offset_pred %s, slope_pred %s, e_pred %s, f pred %s g pred %s h pred %s"%(
                        round(res[0],3),
                        round(res[1],3),
                        round(res[2],3),
                        round(res[3],3),
                        round(res[4],3),
                        round(res[5],3),
                        round(res[6],3),
                        round(res[7],3)
                    )
                )

                    
            if y_true[0] == y_true[-1]:
                plt.pause(0.5)
                ax.cla()
            else:
                plt.pause(0.1)
                ax.cla()
    plt.show()



    



