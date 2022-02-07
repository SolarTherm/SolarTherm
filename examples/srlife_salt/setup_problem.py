#!/usr/bin/env python3
# coding: utf-8

import os
import numpy as np
import DyMat
import time
from scipy.interpolate import interp1d, RegularGridInterpolator
import matplotlib.pyplot as plt
import scipy.io as sio

import sys
sys.path.append('../..')

from srlife import receiver

if __name__=="__main__":
    t_init = time.time()
    # Setup the base receiver
    period = 24.0                                   # Loading cycle period, hours
    days = 1                                        # Number of cycles represented in the problem 
    panel_stiffness = "disconnect"                  # Panels are disconnected from one another
    model = receiver.Receiver(period,               # Instatiating a receiver model
                              days, 
                              panel_stiffness)

    # Setup each of the two panels
    tube_stiffness = "rigid"
    panel_0 = receiver.Panel(tube_stiffness)
    panel_1 = receiver.Panel(tube_stiffness)

    # Basic receiver geometry (Updated to Gemasolar)
    r_outer = 42.16/2.0                             # Panel tube outer radius (mm)
    thickness = 1.2                                 # Panel tube thickness (mm)
    height = 10500.0                                # Panel tube height (mm)

    # Tube discretization
    nr = 12                                         # Number of radial elements in the panel tube cross-section
    nt = 91                                         # Number of circumferential elements in the panel tube cross-section
    nz = 50                                         # Number of axial elements in the panel tube

    # Import BCs
    mat = sio.loadmat('../st_nash_tube_stress_res.mat')
    fluid_temp = mat['fluid_temp'][:,0:nz]
    h_flux = mat['h_flux'][:,:,0:nz]
    times = mat['times'].flatten()
    pressure = mat['pressure'].flatten()
    T_base = fluid_temp[0,0]

    # Setup Tube 0 in turn and assign it to the correct panel
    tube_0 = receiver.Tube(r_outer,
                           thickness,
                           height,
                           nr,
                           nt,
                           nz,
                           T0 = T_base)
    tube_0.set_times(times)
    tube_0.set_bc(
        receiver.ConvectiveBC(r_outer-thickness,
                              height,
                              nz,
                              times,
                              fluid_temp),
        "inner")
    tube_0.set_bc(
        receiver.HeatFluxBC(r_outer,
                            height,
                            nt,
                            nz,
                            times,
                            h_flux),
        "outer")
    tube_0.set_pressure_bc(
        receiver.PressureBC(times,
                            pressure))

    # Tube 1
    tube_1 = receiver.Tube(r_outer,
                           thickness,
                           height,
                           nr,
                           nt,
                           nz,
                           T0 = T_base)
    tube_1.set_times(times)
    tube_1.set_bc(
        receiver.ConvectiveBC(r_outer-thickness,
                              height,
                              nz,
                              times,
                              fluid_temp),
        "inner")
    tube_1.set_bc(
        receiver.HeatFluxBC(r_outer, height,
                            nt,
                            nz,
                            times,
                            h_flux),
        "outer")
    tube_1.set_pressure_bc(
        receiver.PressureBC(times,
                            pressure))

    # Tube 2
    tube_2 = receiver.Tube(r_outer, 
                           thickness, 
                           height, 
                           nr, 
                           nt, 
                           nz, 
                           T0 = T_base)
    tube_2.set_times(times)
    tube_2.set_bc(
        receiver.ConvectiveBC(r_outer-thickness,
                              height, 
                              nz, 
                              times, 
                              fluid_temp), 
        "inner")
    tube_2.set_bc(
        receiver.HeatFluxBC(r_outer,
                            height,
                            nt,
                            nz,
                            times,
                            h_flux),
        "outer")
    tube_2.set_pressure_bc(
        receiver.PressureBC(times, 
                            pressure))

    # Tube 3
    tube_3 = receiver.Tube(r_outer, 
                           thickness, 
                           height, 
                           nr, 
                           nt, 
                           nz, 
                           T0 = T_base)
    tube_3.set_times(times)
    tube_3.set_bc(
        receiver.ConvectiveBC(r_outer-thickness,
                              height,
                              nz,
                              times,
                              fluid_temp),
        "inner")
    tube_3.set_bc(
        receiver.HeatFluxBC(r_outer,
                            height,
                            nt,
                            nz,
                            times,
                            h_flux),
        "outer")
    tube_3.set_pressure_bc(
        receiver.PressureBC(times, 
                            pressure))

    # Assign to panel 0
    panel_0.add_tube(tube_0, "tube0")
    panel_0.add_tube(tube_1, "tube1")

    # Assign to panel 1
    panel_1.add_tube(tube_2, "tube2")
    panel_1.add_tube(tube_3, "tube3")

    # Assign the panels to the receiver
    model.add_panel(panel_0, "panel0")
    model.add_panel(panel_1, "panel1")

    # Save the receiver to an HDF5 file
    model.save('%s/model.hdf5'%os.getcwd())
    elapsed = time.time() - t_init
    hours, rem = divmod(elapsed, 3600)
    minutes, seconds = divmod(rem, 60)
    print("Elapsed time: {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))
