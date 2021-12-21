#!/usr/bin/env python3

import numpy as np
import time
import sys
sys.path.append('../..')

from srlife import receiver, solverparams, library, thermal, structural, system, damage, managers

if __name__ == "__main__":
  # Load the receiver we previously saved
  model = receiver.Receiver.load("model.hdf5")

  # Choose the material models
  fluid_mat = library.load_fluid("sodium", "base") # Sodium model
  # Base 316H thermal and damage models, a simplified deformation model to 
  # cut down on the run time of the 3D analysis
  thermal_mat, deformation_mat, damage_mat = library.load_material("316H", "base", "base", "base")

  # Cut down on run time for now by making the tube analyses 1D
  # This is not recommended for actual design evaluation
  for panel in model.panels.values():
    for tube in panel.tubes.values():
      tube.make_2D(tube.h/2)

  # Setup some solver parameters
  params = solverparams.ParameterSet()
  params['progress_bars'] = True # Print a progress bar to the screen as we solve
  params['nthreads'] = 4 # Solve will run in multithreaded mode, set to number of available cores
  params['system']['atol'] = 1.0e-4 # During the standby very little happens, lower the atol to accept this result

  # Choose the solvers, i.e. how we are going to solve the thermal,
  # single tube, structural system, and damage calculation problems.
  # Right now there is only one option for each
  # Define the thermal solver to use in solving the heat transfer problem
  thermal_solver = thermal.FiniteDifferenceImplicitThermalSolver(
      params["thermal"])
  # Define the structural solver to use in solving the individual tube problems
  structural_solver = structural.PythonTubeSolver(params["structural"])
  # Define the system solver to use in solving the coupled structural system
  system_solver = system.SpringSystemSolver(params["system"])
  # Damage model to use in calculating life
  damage_model = damage.TimeFractionInteractionDamage(params['damage'])

  # The solution manager
  solver = managers.SolutionManager(model, thermal_solver, thermal_mat, fluid_mat,
      structural_solver, deformation_mat, damage_mat,
      system_solver, damage_model, pset = params)

  # Actually solve for life
  t_init = time.time()
  life = solver.solve_life()
  print("Best estimate life: %f daily cycles" % life)
  elapsed = time.time() - t_init
  hours, rem = divmod(elapsed, 3600)
  minutes, seconds = divmod(rem, 60)
  print("Elapsed time: {:0>2}:{:0>2}:{:05.2f}".format(int(hours),int(minutes),seconds))
  
  # Save the tube data out for additional visualization
  for pi, panel in model.panels.items():
    for ti, tube in panel.tubes.items():
      tube.write_vtk("tube-%s-%s" % (pi, ti))
