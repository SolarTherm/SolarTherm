#! /bin/env python2
# -*- coding: utf-8 -*-

from __future__ import division
import unittest

from solartherm import simulation
from solartherm import postproc

from math import pi
import xlsxwriter

class TestScheduler(unittest.TestCase):
	def setUp(self):
		fn = '../examples/SaltSCO2System.mo'
		sim = simulation.Simulator(fn)
		sim.compile_model()
		sim.compile_sim(args=['-s'])
		sim.simulate(start=0, stop='1y', step='300s',solver='dassl', nls='homotopy')
		self.res = postproc.SimResultElec(sim.res_fn)
		self.perf = self.res.calc_perf()

	def test_sched(self):
		def getval(n):
			return self.res.interpolate(n,1)

		print "-----------------------------------------------------------------------"
		print 'Energy per year:                          %6.2f MW'%(self.perf[0])
		print 'LCOE:                                     %6.2f USD/MWh'%(self.perf[1])
		print 'Capacity factor:                          %6.2f %%'%(self.perf[2])
		print "-----------------------------------------------------------------------"
		print 'Receiver thermal input at design point:   %6.2f MW'%(getval('R_des')/1e6)
		print 'Receiver thermal output at design point:  %6.2f MW'%(getval('Q_rec_out')/1e6)
		print 'Power block gross rating at design point: %6.2f MW'%(getval('P_gross')/1e6)
		print 'Solar multiple:                           %4.1f   '%(getval('SM'))
		print 'Receiver diameter:                        %4.2f  m'%(getval('D_receiver'))
		print 'Receiver height:                          %4.2f  m'%(getval('H_receiver'))
		print 'Tower height:                             %4.1f  m'%(getval('H_tower'))
		print 'Number of heliostats:                     %4.1f  m'%(getval('n_heliostat'))

		f = open('report.tex','w+')
		content = r'''\documentclass{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,makecell,graphicx,bm,multirow,threeparttable}

\title{LCOE comparison: Single and multi-tower sodium systems}
\author{}

\renewcommand\theadfont{\normalsize}

\begin{document}

\maketitle

\section{Salt single tower system}
\subsection{High-level performance parameters}

\begin{table}[!h]
\centering
\begin{tabular}{ ll } 
	\hline\hline
	{\bfseries Item} & \thead{\bfseries Sodium \\\bfseries single-tower}\\
	\hline
	Energy per year (MWh):                                  & %6.2f \\
	Capacity factor (\%%):                                  & %6.2f \\
	LCOE (\$/MWh):                                          & %6.2f \\
	\hline
	Number of modules:                                      & 1 \\
	Receiver thermal input at design point (MWt):           & %6.1f \\
	Receiver thermal output at design point (\%%):          & %6.1f \\
	Solar to thermal efficiency (\%%):                      & %6.2f \\
	Solar to electric efficiency (\%%):                     & %6.2f \\
	\hline
	Power block gross rating at design point (MWe):         & %6.1f \\
	Power block efficiency at design point (\%%):           & %6.1f \\
	\hline
	Full load hours of storage (h):                         & %6.1f \\
	Storage capacity (kWht):                                & %6.1f \\
	\hline
	Solar multiple:                                         & %6.1f \\
	\hline
	Receiver diameter (m):                                  & %6.1f \\
	Receiver height (m):                                    & %6.1f \\
	Tower height (m):                                       & %6.1f \\
	Number of heliostats:                                   & %i \\
	Number of heliostats per module:                        & %i \\
	\hline\hline
\end{tabular}
\end{table}

\subsection{Costing assuptions}

\begin{center}
\begin{tabular}{ ll } 
	\hline\hline
	{\bfseries Item} & \thead{\bfseries Sodium \\\bfseries single-tower} \\
	\hline
	Real discount rate (\%%):					& %2.1f \\
	Inflation rate rate (\%%):					& %2.1f \\
	Lifetime of plant (years):					& %i \\
	Construction time (years):					& %i \\
	Subsidies on initial investment costs (\$):			& %6.1f \\
	Field cost per design aperture area (\$/m$^2$):			& %6.1f \\
	Site improvements cost per area (\$/m$^2$):			& %6.1f \\
	Storage cost per energy capacity (\$/kWht):			& %6.1f \\
	Power block cost per gross rated power (\$/kWe):		& %6.1f \\
	Balance of plant cost per gross rated power (\$/kWe):		& %6.1f \\
	Land cost per area (\$/acre):					& %6.1f \\
	Fixed O\&M cost per nameplate per year (\$/year):		& %6.1f \\
	Variable O\&M cost per production per year (\$/kWe/year):	& %6.1f \\
	\hline\hline
\end{tabular}
\end{center}

\subsection{Equipment and maintenance costs}

\begin{center}
\begin{tabular}{ ll } 
	\hline\hline
	{\bfseries Item} & \thead{\bfseries Sodium \\\bfseries single-tower} \\
	\hline
	Field cost (M\$):			& %6.1f \\
	Site improvements cost (M\$):		& %6.1f \\
	Tower cost (M\$):			& %6.1f \\
	Receiver cost (M\$):			& %6.1f \\
	Heat exchanger cost (M\$):		& - \\
	Storage cost (M\$):			& %6.1f \\
	Power block cost (M\$):			& %6.1f \\
	Balance of plant cost (M\$):		& %6.1f \\
	Tower Piping cost (M\$):		& %6.1f \\
	Piping network cost (M\$):		& - \\
	Cold Pumps cost (M\$):			& %6.1f \\
	\hline
	Direct capital cost subtotal (M\$):	& %6.1f \\
	Contingency cost (M\$):			& %6.1f \\
	\hline
	Total direct capital cost (M\$):	& %6.1f \\
	EPC and owner costs (M\$):		& %6.1f \\
	Land cost (M\$):			& %6.1f \\
	\hline
	Total capital (installed cost) (M\$):	& %6.1f \\
	\hline\hline
\end{tabular}
\end{center}
\end{document}'''

		f.write(content%(
		self.perf[0],
		self.perf[2],
		self.perf[1],
		getval('R_des')/1e6,
		getval('Q_rec_out')/1e6,
		self.res.interpolate('receiver.E_rec',31536000)/self.res.interpolate('heliostatsField.E_dni',31536000)*100,
		self.res.interpolate('powerBlock.E_net',31536000)/self.res.interpolate('heliostatsField.E_dni',31536000)*100,
		getval('P_gross')/1e6,
		getval('eff_blk')*100,
		getval('t_storage'),
		getval('E_max')/3600/1e6,
		getval('SM'),
		getval('D_receiver'),
		getval('H_receiver'),
		getval('H_tower'),
		getval('n_heliostat'),
		getval('n_heliostat'),
		getval('r_disc')*100,
		getval('r_i')*100,
		getval('t_life'),
		getval('t_cons'),
		getval('f_Subs'),
		getval('pri_field'),
		getval('pri_site'),
		getval('pri_storage')*1e3*3600,
		getval('pri_block')*1e3,
		getval('pri_bop')*1e3,
		getval('pri_land')*4046.86,
		getval('pri_om_name')*1e3,
		getval('pri_om_prod')*1e6*3600,
		getval('C_field')/1e6,
		getval('C_site')/1e6,
		getval('C_tower')/1e6,
		getval('C_receiver')/1e6,
		getval('C_storage')/1e6,
		getval('C_block')/1e6,
		getval('C_bop')/1e6,
		getval('C_piping')/1e6,
		getval('C_pumps')/1e6,
		getval('C_cap_dir_sub')/1e6,
		getval('C_contingency')/1e6,
		getval('C_cap_dir_tot')/1e6,
		getval('C_EPC')/1e6,
		getval('C_land')/1e6,
		getval('C_cap')/1e6))
		f.close()

		workbook = xlsxwriter.Workbook('report.xlsx')
		worksheet = workbook.add_worksheet('sodium_single_tower')
		# Row names
		worksheet.write(0, 0, 'Item')
		worksheet.write(1, 0,'Energy per year (MWh)')
		worksheet.write(2, 0,'Capacity factor (\%)')
		worksheet.write(3, 0,'LCOE (\$/MWh)')
		worksheet.write(4, 0,'Number of modules')
		worksheet.write(5, 0,'Receiver thermal input at design point (MWt)')
		worksheet.write(6, 0,'Receiver thermal output at design point (\%)')
		worksheet.write(7, 0,'Solar to thermal efficiency (\%)')
		worksheet.write(8, 0,'Solar to electric efficiency (\%)')
		worksheet.write(9, 0,'Power block gross rating at design point (MWe)')
		worksheet.write(10, 0,'Power block efficiency at design point (\%)')
		worksheet.write(11, 0,'Full load hours of storage (h)')
		worksheet.write(12, 0,'Storage capacity (kWht)')
		worksheet.write(13, 0,'Solar multiple')
		worksheet.write(14, 0,'Receiver diameter (m)')
		worksheet.write(15, 0,'Receiver height (m)')
		worksheet.write(16, 0,'Tower height (m)')
		worksheet.write(17, 0,'Number of heliostats')
		worksheet.write(18, 0,'Number of heliostats per module')
		worksheet.write(19 ,0 ,'Field cost(M\$)')
		worksheet.write(20 ,0 ,'Site improvements cost(M\$)')
		worksheet.write(21 ,0 ,'Tower cost(M\$)')
		worksheet.write(22 ,0 ,'Receiver cost(M\$)')
		worksheet.write(23 ,0 ,'Heat exchanger cost(M\$)')
		worksheet.write(24 ,0 ,'Storage cost(M\$)')
		worksheet.write(25 ,0 ,'Power block cost(M\$)')
		worksheet.write(26 ,0 ,'Balance of plant cost(M\$)')
		worksheet.write(27 ,0 ,'Tower piping cost(M\$)')
		worksheet.write(28 ,0 ,'Piping network cost(M\$)')
		worksheet.write(29 ,0 ,'Cold Pumps cost(M\$)')
		worksheet.write(30 ,0 ,'Direct capital cost subtotal(M\$)')
		worksheet.write(31 ,0 ,'Contingency cost(M\$)')
		worksheet.write(32 ,0 ,'Total direct capital cost(M\$)')
		worksheet.write(33 ,0 ,'EPC and owner costs(M\$)')
		worksheet.write(34 ,0 ,'Land cost(M\$)')
		worksheet.write(35 ,0 ,'Total capital (installed cost)(M\$)')
		# values
		worksheet.write(0, 1, 'Value')
		worksheet.write(1, 1, round(self.perf[0],1))
		worksheet.write(2, 1, round(self.perf[2],2))
		worksheet.write(3, 1, round(self.perf[1],2))
		worksheet.write(4, 1, 1)
		worksheet.write(5, 1, round(getval('R_des')/1e6,1))
		worksheet.write(6, 1, round(getval('Q_rec_out')/1e6,1))
		worksheet.write(7, 1, round(self.res.interpolate('receiver.E_rec',31536000)/self.res.interpolate('heliostatsField.E_dni',31536000)*100,1))
		worksheet.write(8, 1, round(self.res.interpolate('powerBlock.E_net',31536000)/self.res.interpolate('heliostatsField.E_dni',31536000)*100,1))
		worksheet.write(9, 1, round(getval('P_gross')/1e6,1))
		worksheet.write(10, 1, round(getval('eff_blk')*100,1))
		worksheet.write(11, 1, round(getval('t_storage'),1))
		worksheet.write(12, 1, round(getval('E_max')/3600/1e6,1))
		worksheet.write(13, 1, round(getval('SM'),1))
		worksheet.write(14, 1, round(getval('D_receiver'),1))
		worksheet.write(15, 1, round(getval('H_receiver'),1))
		worksheet.write(16, 1, round(getval('H_tower'),1))
		worksheet.write(17, 1, round(getval('n_heliostat'),0))
		worksheet.write(18, 1, round(getval('n_heliostat'),0))
		worksheet.write(19, 1, round(getval('C_field')/1e6,1))
		worksheet.write(20, 1, round(getval('C_site')/1e6,1))
		worksheet.write(21, 1, round(getval('C_tower')/1e6,1))
		worksheet.write(22, 1, round(getval('C_receiver')/1e6,1))
		worksheet.write(23, 1, '-')
		worksheet.write(24, 1, round(getval('C_storage')/1e6,1))
		worksheet.write(25, 1, round(getval('C_block')/1e6,1))
		worksheet.write(26, 1, round(getval('C_bop')/1e6,1))
		worksheet.write(27, 1, round(getval('C_piping')/1e6,1))
		worksheet.write(28, 1, '-')
		worksheet.write(29, 1, round(getval('C_pumps')/1e6,1))
		worksheet.write(30, 1, round(getval('C_cap_dir_sub')/1e6,1))
		worksheet.write(31, 1, round(getval('C_contingency')/1e6,1))
		worksheet.write(32, 1, round(getval('C_cap_dir_tot')/1e6,1))
		worksheet.write(33, 1, round(getval('C_EPC')/1e6,1))
		worksheet.write(34, 1, round(getval('C_land')/1e6,1))
		worksheet.write(35, 1, round(getval('C_cap')/1e6,1))
		cell_format = workbook.add_format({'bold': True, 'font_color': 'red'})
		worksheet.set_column('A:A', 50, cell_format)
		workbook.close()

if __name__ == '__main__':
	unittest.main()
