'''
    This script is a warpper to generate the surrogate model for receiver. The modelica varname and UB-LB is obtained by reading ./variables.csv
'''
from neural_network import data, bayesian
import argparse
import pandas as pd
import functools
from bayes_opt import BayesianOptimization as BO
import time

constant = 42

#Generate the data
'''
    Wrapper function to generate training data.
    @parameters:
        simdir,type: str, direactory where the simulation will happen
        ST_path, type: str, path to solartherm e.g. $HOME/solartherm/SolarTherm
    @return:
        fn_data, type: str, path to the file where the training data is stored
'''
def generate_data(simdir, ST_path, numdata):
    res = data.Data(simdir = simdir, ST_path=ST_path)
    
    #Reading the variable names, UB and LB from a csv
    df = pd.read_csv('./variables.csv')
    modelicavarname = df['VariableNames'].to_list()
    UB = df['UB'].to_list()
    LB = df['LB'].to_list()

    #Generate LHS
    res.generate_LHS(
        numdata=numdata,
        modelicavarname=modelicavarname,
        UB=UB,
        LB=LB
    )
    
    #Run
    fn_data = res.run()
    return fn_data

#Training

if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument('--simdir',type=str,default='./simulation_surrogate_receiver',help="folder to stash simulation result when gathering training data")
    parser.add_argument('--ST_path',type=str,default="../../../SolarTherm", help="path to SolarTherm e.g. /home/solartherm/SolarTherm")
    parser.add_argument('--numdata',type=int, default=2000, help="Number of data points")
    parser.add_argument('--inputsize', type=int, default=7, help="input dim to the surrogate model")
    parser.add_argument('--outputsize', type=int, default=1, help="output dim to the surrogate model")

    args = parser.parse_args()

    fn_data = generate_data(
        simdir = args.simdir,
        ST_path= args.ST_path,
        numdata= args.numdata
    )

    trainer = bayesian.Trainer(fn_data, wd="./result_bayesian_opt")
    trainer.preprocessing_data(inputsize=args.inputsize, outputsize=args.outputsize)
    verbose = 0

    batch_size = 512

    objfunc = functools.partial(
        trainer.eval_net, verbose, "mse", batch_size
    )

    parameterbounds = {
        'nPercent':(0,1),
        'nShrink':(0,1),
        'lr':(0.001,0.1),
        'dropout':(0,0.499)
    }

    opt = BO(
        f=objfunc,
        pbounds=parameterbounds,
        verbose=2,
        random_state=constant
    )

    start_time = time.time()
    
    opt.maximize(init_points=200,n_iter=200)
    
    delta = time.time() - start_time

    print("Total time: %s s"%delta)

    print(opt.max)

    f = open("%s/dump.txt"%(trainer.wd),'w')
    f.write("%s\n"%(opt.max))
    f.close()













    
