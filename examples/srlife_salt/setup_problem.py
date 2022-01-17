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

    # Total flux function
    mat = sio.loadmat('srlife_input_salt.mat')
    t_data = mat['time'][0,:]/3600.
    flux = mat['flux']/1e6
    z_data = np.linspace(0, 1, flux.shape[2])
    Theta = np.linspace(0, 2*np.pi, flux.shape[1])
    fflux = RegularGridInterpolator(
        (t_data, Theta, z_data), 
        flux,
        bounds_error=False, 
        fill_value=0)
    h_flux = lambda t, theta, z: fflux((t,
                                        theta, 
                                        z/height))

    # Fluid temperature function
    T_data = mat['temperature']                     # Extracting temperatures. Time and axial positions are the same
    T_base = T_data[0,0]
    ftemps = RegularGridInterpolator((t_data, z_data), 
                                      T_data, bounds_error=False, 
                                      fill_value=T_base)
    fluid_temp = lambda t, z: ftemps((t, z/height))

    # ID pressure history
    p_max = 0.1    # MPa
    p_data = []
    for i in T_data[:,-1]:
        if i > T_base:
            p_data.append(1.0)
        else:
            p_data.append(0.0)
    funp = interp1d(t_data, 
                    p_data,
                    bounds_error=False,
                    fill_value=0)
    pressure = lambda t: p_max*funp(t)

    # Time increments throughout the 24 hour day
    times = np.linspace(0,24,24*2+1)

    # A mesh over the times and height (for the fluid temperatures)
    time_h, z_h = np.meshgrid(times, 
                              np.linspace(0,height,nz), 
                              indexing='ij')

    # A surface mesh over the outer surface (for the flux)
    time_s, theta_s, z_s = np.meshgrid(times, 
                                       np.linspace(0,2*np.pi,nt+1)[:nt], 
                                       np.linspace(0,height,nz), 
                                       indexing = 'ij')

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
                              fluid_temp(time_h,z_h)),
        "inner")
    tube_0.set_bc(
        receiver.HeatFluxBC(r_outer,
                            height,
                            nt,
                            nz,
                            times,
                            h_flux(time_s, theta_s, z_s)),
        "outer")
    tube_0.set_pressure_bc(
        receiver.PressureBC(times,
                            pressure(times)))

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
                              fluid_temp(time_h,z_h)),
        "inner")
    tube_1.set_bc(
        receiver.HeatFluxBC(r_outer, height,
                            nt,
                            nz,
                            times,
                            h_flux(time_s, theta_s, z_s)),
        "outer")
    tube_1.set_pressure_bc(
        receiver.PressureBC(times,
                            pressure(times)))

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
                              fluid_temp(time_h,z_h)), 
        "inner")
    tube_2.set_bc(
        receiver.HeatFluxBC(r_outer,
                            height,
                            nt,
                            nz,
                            times,
                            h_flux(time_s, theta_s, z_s)),
        "outer")
    tube_2.set_pressure_bc(
        receiver.PressureBC(times, 
                            pressure(times)))

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
                              fluid_temp(time_h,z_h)),
        "inner")
    tube_3.set_bc(
        receiver.HeatFluxBC(r_outer,
                            height,
                            nt,
                            nz,
                            times,
                            h_flux(time_s, theta_s, z_s)),
        "outer")
    tube_3.set_pressure_bc(
        receiver.PressureBC(times, 
                            pressure(times)))

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
