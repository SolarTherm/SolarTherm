#! /bin/env python

from __future__ import division
import cleantest
import pytest

from solartherm import simulation
from solartherm import postproc

from math import pi
import os


def test_ref2solstice():
	fn = '../examples/HeliostatsIPH.mo'
	sim = simulation.Simulator(fn)
	sim.compile_model()
	sim.compile_sim(args=['-s'])

	fb=0.5
	R1=50
	H_helio=10
	n_row_oelt=3
	n_col_oelt=5
	target_aligned=1
	P_net=56e4
	H_recv=3
	H_tower=120
	T_recv=500+273.15

	sim.update_pars(['fb','R1', 'H_helio', 'n_row_oelt', 'n_col_oelt', 'target_aligned', 'P_net', 'H_recv', 'T_recv', 'H_tower'],[str(fb),str(R1), str(H_helio), str(n_row_oelt), str(n_col_oelt), str(target_aligned), str(P_net), str(H_recv), str(T_recv), str(H_tower)]) # reduce oelt resolution
	sim.simulate(start=0, stop='1y', step='5m',solver='dassl', nls='newton')
	res=postproc.SimResult(sim.res_fn)
	
	C=res.get_values('C_cap')[-1]
	f=res.get_values('CRF')[-1]
	Tl=res.get_values('rec_T_amb_des')[-1]
	Th=res.get_values('T_recv')[-1]
	eta=1.-Tl/Th

	E_sol=res.get_values('E_sol')[-1]/1e6/3600.
	E_inc=res.get_values('E_inc')[-1]/1e6/3600.
	E_recv=res.get_values('E_net')[-1]/1e6/3600.
	Ex=E_recv*eta # MWh

	LCOX=f*C/Ex
	LCOH=f*C/E_recv

	eff_recv=E_recv/E_inc
	eff_field=E_inc/E_sol
	eff_sys=E_recv/E_sol
	eff_ex=Ex/E_sol

	print(LCOH, eff_recv, eff_field, eff_sys, eff_ex)
	
	assert abs(eff_field- 0.551)/0.551 < 0.1 # field efficiency
	assert abs(eff_recv- 0.539)/0.539 < 0.1 # receiver efficiency
	assert abs(eff_sys- 0.297)/0.297 < 0.1 # system efficiency
	cleantest.clean('HeliostatsIPH')

# vim: ts=4:sw=4:noet:tw=80
