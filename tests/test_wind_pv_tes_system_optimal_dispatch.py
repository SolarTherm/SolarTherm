#! /bin/env python

from __future__ import division
import unittest

from solartherm import simulation
import DyMat

from math import pi
import os

class TestScheduler(unittest.TestCase):
    def setUp(self):
        fn = f'{st_folder}/examples/WindPVSimpleSystemOptimalDispatch.mo'
        sim = simulation.Simulator(fn)
        sim.compile_model()
        sim.compile_sim(args=['-s'])
        sim.simulate(start=0, stop='2d', step='30m', solver='dassl', nls='homotopy', tolerance = '1e-06')

    def test_sched(self):
        df=DyMat.DyMatFile('WindPVSimpleSystemOptimalDispatch_res.mat')
        Q_flow_dis=df.data('Q_flow_dis')/1.e6
        Q_flow_chg=df.data('Q_flow_chg')/1.e6
        E_max=df.data('E_max')[0]
        E=df.data('E')/E_max*100
        times=df.abscissa('Q_flow_dis')[0]/3600.

        import matplotlib.pyplot as plt
        import numpy as np
        import math
        fig,axes=plt.subplots(1,1,figsize=(18,4))
        axes.plot(times,Q_flow_dis,ls='--',marker='*',color='tab:red',label='Q_flow_dis')
        axes.plot(times,Q_flow_chg,ls='-',color='tab:blue',label='Q_flow_chg')
        axes.set_xlabel('time (h)')
        axes.set_ylabel('Thermal Power [MW]')
        max_Q_flow_chg = np.amax(Q_flow_chg)
        upper_limit = math.ceil(max_Q_flow_chg / 10) * 10 + 10
        axes.set_ylim([0,upper_limit])

        axe2=axes.twinx()
        axe2.plot(times,E,ls='--',color='tab:green',label='Storage Level')
        axe2.set_ylabel('Storage Level [%]')
        axe2.set_ylim([0,100])
        axes.legend(loc='best')
        plt.savefig('fig_WindPVSimpleSystemOptimalDispatch.png',dpi=300)
        # Deleting simulation files
        os.system('rm WindPVSimpleSystemOptimalDispatch*')

if __name__ == '__main__':
    script_dir = os.path.dirname(__file__)  # Get the directory where the script is located
    st_folder = os.path.abspath(os.path.join(script_dir, os.pardir))  # Set st_folder as the parent directory
    commands = f'cd {st_folder} && scons && scons install && cd tests'
    os.system(commands)
    unittest.main()
