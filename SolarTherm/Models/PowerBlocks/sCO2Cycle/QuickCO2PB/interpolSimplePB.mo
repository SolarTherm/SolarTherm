within SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB;
	model interpolSimplePB "This model calculates a few off-design points as initial equation and after interpolate over them"
		import SI = Modelica.SIunits;
		import CV = Modelica.SIunits.Conversions;
		import FI = SolarTherm.Models.Analysis.Finances;
		extends SolarTherm.Media.CO2.PropCO2;
		extends Icons.PowerBlock;
		
		input SI.ThermodynamicTemperature T_amb;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
		
		//Objective: having a few points in order to interpolate the HTF outlet temperature and the TIT. Should be feasible with for loops in the initial equation.
		parameter SI.Power P_nom = 100 * 10 ^ 6;
		parameter SI.AbsolutePressure p_high = CV.from_bar(250);
		parameter SI.AbsolutePressure p_low = CV.from_bar(80);
		parameter Real PR = p_high / p_low;
		parameter SI.ThermodynamicTemperature T_high = CV.from_degC(715) "inlet temperature of the turbine";
		parameter SI.ThermodynamicTemperature T_HTF_in_des = CV.from_degC(800) "inlet temperature of the HTF";
		parameter SI.ThermodynamicTemperature T_low = CV.from_degC(45) "Inlet temperature of the compressor";
		parameter SI.ThermodynamicTemperature T_amb_des = CV.from_degC(20) "ambient temperature at design";
		parameter SI.TemperatureDifference pinchHTR = 5;
		parameter SI.TemperatureDifference pinchExch = T_HTF_in_des - T_high;
		parameter SI.Efficiency eta_comp = 0.89;
		parameter SI.Efficiency eta_turb = 0.93;
		parameter Integer N_exch = 5;
		parameter Integer N_HTR = 15;
		parameter Integer N_cooler = 15;
		
		//Variables for real time calculation
		//Exchanger variables
		Boolean m_sup "indicates if mass flow from tank is superior enough to calculate";
		SI.MassFlowRate m_HTF_bis "mass flow rate used for switching off the PB";
		SI.ThermodynamicTemperature T_HTF_in "Inlet temperature of HTF";
		SI.ThermodynamicTemperature T_HTF_out "Outlet temperature of HTF";
		SI.ThermodynamicTemperature TIT_CO2 "Turbine inlet Temperature of CO2";
		SI.ThermodynamicTemperature T_CO2_in_HX "CO2 temperature at the inlet of the exchanger";
		
		MedPB.ThermodynamicState[N_exch] state_CO2_HX(each h.start = 10 ^ 6);
		MedRec.ThermodynamicState[N_exch] state_HTF_HX(each h.start = 6 * 10 ^ 5);
		SI.TemperatureDifference[N_exch] deltaT_HX(each start = 20);
		
		//PowerBlock variables
		 Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = MedRec) annotation (Placement(
					transformation(extent={{-54,22},{-34,42}}),	iconTransformation(extent={{-48,30},
							{-40,38}})));
		Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = MedRec) annotation (Placement(
					transformation(extent={{-74,-60},{-54,-40}}),iconTransformation(extent={{-62,-48},
							{-54,-40}})));
		
		Modelica.Blocks.Interfaces.RealOutput W_net(
			quantity="Power",
			unit="W",
			displayUnit="W") "Net electric power output" annotation (Placement(
					visible = true,transformation(extent = {{78, -22}, {98, -2}}, rotation = 0), iconTransformation(extent = {{46, -10}, {56, 0}}, rotation = 0)));
		
		SI.Power P_cooling "Cooling power necessary to cool down the fluid";
		parameter FI.Money C_PB (fixed=false) "Overall cost of the power block";
		parameter SI.ThermodynamicTemperature T_HTF_out_des (fixed=false);
		parameter MedPB.ThermodynamicState state_comW_out (p.fixed=false, h.fixed=false);
		//Off-design parameters for calculation
		parameter Integer N_points = 10;
		parameter SI.ThermodynamicTemperature[N_points] T_high_frac(each fixed = false) "points for which efficiency will be calculated";
		
		//parameters to calculate on and off-design
		parameter SI.MassFlowRate m_des(fixed = false, start = P_nom / 10 ^ 5) "mass flow rate at the outlet of the turbine";
		parameter SI.Power[N_points] W_out(each fixed = false, each start = P_nom) "power at the outlet for off-design";
		parameter SI.Efficiency eta_cycle_on(fixed = false, start = 0.5) "efficiency of the cycle";
		parameter SI.Efficiency[N_points] eta_cycle_off(each fixed = false, each start = 0.5) "efficiency of the cycle";
		// bougé pour voir ce qu'il se passe
		parameter SI.Power W_comp(fixed = false);
		parameter SI.HeatFlowRate Q_dis_exch(fixed = false);
		parameter MedPB.ThermodynamicState state_cooler_out(p.fixed = false, h.fixed = false);
	protected
	
		//Inlet of the turbine
		parameter SI.SpecificEntropy[N_points + 1] s_in_turb(each fixed = false, each start = 2900) "inlet entropy to the turbine";
		parameter MedPB.ThermodynamicState[N_points + 1] state_in_turb(each p.fixed = false, each h.fixed = false);
		parameter SI.Power[N_points + 1] W_turb(each fixed = false);
		parameter MedPB.ThermodynamicState[N_points + 1] state_out_turb(each p.fixed = false, each h.fixed = false);
		
		//Main Compressor parameters
		parameter SI.SpecificEntropy s_in_mainComp(fixed = false, start = 1500) "inlet entropy to the main compressor";
		
		//Exchanger parameters. Calculated only at on-design
		parameter SolarTherm.Types.Conductance[N_exch - 1] UA_exch_dis(each fixed = false, each start = P_nom * 0.4 / N_exch);
		
		parameter MedPB.ThermodynamicState[N_exch] state_CO2_exch(each p.fixed = false, each h.fixed = false, each h.start = 10 ^ 6);
		parameter MedRec.ThermodynamicState[N_exch] state_HTF_exch(each p.fixed = false, each h.fixed = false, each h.start = 6 * 10 ^ 5);
		parameter SI.TemperatureDifference[N_exch] deltaT_exch(each start = 20, each fixed = false);
		
		// HTR parameters
		parameter SolarTherm.Types.Conductance[N_HTR - 1] UA_HTR_dis(each fixed = false, each start = P_nom * 0.4 / N_HTR);
		parameter SI.HeatFlowRate Q_dis_HTR(fixed = false, start = 2 * 10 ^ 4);
		parameter MedPB.ThermodynamicState[N_points + 1, N_HTR] state_HTR_turb(each p.fixed = false, each h.fixed = false, each h.start = 7 * 10 ^ 5);
		parameter MedPB.ThermodynamicState[N_points + 1, N_HTR] state_HTR_comp(each p.fixed = false, each h.fixed = false, each h.start = 6 * 10 ^ 5);
		parameter SI.TemperatureDifference[N_points + 1, N_HTR] deltaT_HTR(each start = 20, each fixed = false);
		parameter SI.ThermodynamicTemperature[N_points] T_CO2_in_HX_table (each fixed=false);
		
		// Cooler parameters
		parameter MedPB.ThermodynamicState[N_cooler] state_cooler(each p.fixed = false, each h.fixed = false, each h.start = 4.5 * 10 ^ 5);
		parameter SI.Power P_cool_des (fixed=false) "on-design power necessary to run the fans";
		parameter SI.HeatFlowRate Q_dis_cooler(fixed = false);
		parameter SolarTherm.Types.Conductance[N_cooler - 1] UA_cooler_dis(each fixed = false);
		
			//Financial analysis
		parameter FI.Money C_HTR (fixed=false) "cost of the high temperature heat recuperator";
		
		parameter FI.Money C_turbine (fixed=false) "cost of the turbine";
		parameter FI.Money C_compressor (fixed=false) "cost of the main compressor";
		
		parameter FI.Money C_exchanger (fixed=false) "cost of the exchanger";
		parameter FI.Money C_generator (fixed=false) "cost of the generator";
		parameter FI.Money C_cooler (fixed=false) "cost of the cooler";
		
		parameter FI.Money pri_exchanger = 150 "price of the primary exchanger in $/(kW_th). Objective for next-gen CSP with particles";
		
		
	initial equation
	//Part I. On-design=first point
	//Inlet of the turbine
		state_in_turb[1] = MedPB.setState_pTX(p_high, T_high);
		s_in_turb[1] = MedPB.specificEntropy(state_in_turb[1]);
		state_out_turb[1] = MedPB.setState_phX(p_low, state_in_turb[1].h + eta_turb * (MedPB.specificEnthalpy(MedPB.setState_psX(p_low, s_in_turb[1])) - state_in_turb[1].h));
		W_turb[1] = m_des * (state_out_turb[1].h - state_in_turb[1].h);
		
	//High temperature recuperator
		for k in 1:N_HTR - 1 loop
			Q_dis_HTR = state_HTR_turb[1, k + 1].h - state_HTR_turb[1, k].h;
			Q_dis_HTR = state_HTR_comp[1, k + 1].h - state_HTR_comp[1, k].h;
			deltaT_HTR[1, k] = MedPB.temperature(state_HTR_turb[1, k]) - MedPB.temperature(state_HTR_comp[1, k]);
			m_des * Q_dis_HTR = UA_HTR_dis[k] * (deltaT_HTR[1, k] + deltaT_HTR[1, k + 1]) / 2;
			state_HTR_comp[1, k + 1].p = p_high;
	//need to use setState when doing isentropic enthalpy
			state_HTR_turb[1, k].p = p_low;
		end for;
		
		deltaT_HTR[1, N_HTR] = MedPB.temperature(state_HTR_turb[1, N_HTR]) - MedPB.temperature(state_HTR_comp[1, N_HTR]);
		min(deltaT_HTR[1]) = pinchHTR;
		
		state_HTR_turb[1, N_HTR].p = p_low;
		state_HTR_turb[1, N_HTR].h = state_out_turb[1].h;
		state_cooler[1].h = state_HTR_turb[1, 1].h;
		
	//Cooler. UA (and therefore this part) are only for economical correlation
		for k in 1:N_cooler - 1 loop
			Q_dis_cooler = state_cooler[k + 1].h - state_cooler[k].h;
			m_des * Q_dis_cooler = -UA_cooler_dis[k] * (MedPB.temperature(state_cooler[k + 1]) - T_amb_des + MedPB.temperature(state_cooler[k]) - T_amb_des) / 2;
			state_cooler[k].p = p_low;
		end for;
		state_cooler[N_cooler] = state_cooler_out;
		state_cooler_out = MedPB.setState_pTX(p_low, T_low);
		P_cool_des * (T_low - T_amb_des)/(-m_des * Q_dis_cooler*(N_cooler-1))= 1.49*10^6*(35.7-30)/(136.6*10^6);
		
		
	//Main compressor. Inlet supposed always the same for off-design
		s_in_mainComp = MedPB.specificEntropy(state_cooler_out);
		state_HTR_comp[1, 1] = MedPB.setState_phX(p_high, state_cooler_out.h + (MedPB.specificEnthalpy(MedPB.setState_psX(p_high, s_in_mainComp)) - state_cooler_out.h)/eta_comp);
		W_comp = m_des * (state_HTR_comp[1, 1].h - state_cooler_out.h);
		state_comW_out=state_HTR_comp[1, 1]; //pour voir ce qu'il se passe
		
	//Exchanger. Done only on-design. After, only the TIT is varied.
		state_CO2_exch[N_exch].h = state_in_turb[1].h;
		state_CO2_exch[1].h = state_HTR_comp[1, N_HTR].h;
		state_HTF_exch[N_exch] = MedRec.setState_pTX(10 ^ 5, T_HTF_in_des);
		for k in 1:N_exch - 1 loop
			Q_dis_exch = state_CO2_exch[k + 1].h - state_CO2_exch[k].h;
			Q_dis_exch = state_HTF_exch[k + 1].h - state_HTF_exch[k].h;
			m_des * Q_dis_exch = UA_exch_dis[k] * (deltaT_exch[k] + deltaT_exch[k + 1]) / 2;
			deltaT_exch[k] = MedRec.temperature(state_HTF_exch[k]) - MedPB.temperature(state_CO2_exch[k]);
			state_CO2_exch[k].p = p_high;
			state_HTF_exch[k].p = 10 ^ 5;
		end for;
		deltaT_exch[N_exch] = MedRec.temperature(state_HTF_exch[N_exch]) - MedPB.temperature(state_CO2_exch[N_exch]);
		T_HTF_out_des = MedRec.temperature(state_HTF_exch[1]);
		state_CO2_exch[N_exch].p = p_high;
		P_nom = (-W_turb[1]) - W_comp;
		eta_cycle_on = P_nom / (m_des * Q_dis_exch * (N_exch - 1));
		
		//Part I.2. Financial analysis
		C_HTR= if MedPB.temperature(state_HTR_turb[1,N_exch])>=550+273.15 then 49.45*sum(UA_HTR_dis)^0.7544*(1+0.02141*(MedPB.temperature(state_HTR_turb[1,N_exch])-550-273.15)) else 49.45*sum(UA_HTR_dis)^0.7544;
		C_turbine= if T_high>= 550+273.15 then 406200*(-W_turb[1]/10^6)^0.8*(1+1.137*10^(-5)*(T_high-550-273.15)^2) else 406200*(-W_turb[1]/10^6)^0.8;
		C_compressor = 1230000*(W_comp/10^6)^0.3392;
		C_cooler = 32.88*sum(UA_cooler_dis)^0.75;
		C_generator = 108900*(P_nom/10^6)^0.5463;
		C_exchanger = pri_exchanger*m_des*Q_dis_exch * (N_exch - 1)/1000;
		C_PB=(C_HTR+C_turbine+C_compressor+C_generator+C_cooler+C_exchanger)*1.05;
		
	//Part II. Off-design points. Mass flow rate is kept constant
		for i in 2:N_points + 1 loop
	//		//Inlet of the turbine
			T_high_frac[i - 1] = (0.8 + (1.2 - 0.8) * (i - 1) / (N_points - 1)) * (T_high - 273.15) + 273.15;
			state_in_turb[i] = MedPB.setState_pTX(p_high, T_high_frac[i - 1]);
			s_in_turb[i] = MedPB.specificEntropy(state_in_turb[i]);
			state_out_turb[i] = MedPB.setState_phX(p_low, state_in_turb[i].h + eta_turb * (MedPB.specificEnthalpy(MedPB.setState_psX(p_low, s_in_turb[i])) - state_in_turb[i].h));
			state_HTR_turb[i, N_HTR] = state_out_turb[i];
			W_turb[i] = m_des * (state_out_turb[i].h - state_in_turb[i].h);
	//High temperature recuperator
			for k in 1:N_HTR - 1 loop
				state_HTR_turb[i, k + 1].h - state_HTR_turb[i, k].h = state_HTR_comp[i, k + 1].h - state_HTR_comp[i, k].h;
				deltaT_HTR[i, k] = MedPB.temperature(state_HTR_turb[i, k]) - MedPB.temperature(state_HTR_comp[i, k]);
				m_des * (state_HTR_turb[i, k + 1].h - state_HTR_turb[i, k].h) = UA_HTR_dis[k] * (deltaT_HTR[i, k] + deltaT_HTR[i, k + 1]) / 2;
				state_HTR_turb[i, k].p = p_low;
				state_HTR_comp[i, k + 1].p = p_high;
			end for;
			deltaT_HTR[i, N_HTR] = MedPB.temperature(state_HTR_turb[i, N_HTR]) - MedPB.temperature(state_HTR_comp[i, N_HTR]);
			T_CO2_in_HX_table[i-1]=MedPB.temperature(state_HTR_comp[i,N_HTR]);
	//	 //Inlet of the HTR. Main Compressor always has the same inlet so no off-design
			state_HTR_comp[i, 1] = MedPB.setState_phX(p_high, state_cooler[N_cooler].h +	(MedPB.specificEnthalpy(MedPB.setState_psX(p_high, s_in_mainComp)) - state_cooler[N_cooler].h)/eta_comp);
			W_out[i - 1] = (-W_turb[i]) - W_comp;
			eta_cycle_off[i - 1] = W_out[i - 1] / (m_des * (state_in_turb[i].h - state_HTR_comp[i, N_HTR].h));
		end for;
	equation
		//Exchanger code
		m_sup=fluid_a.m_flow >=0.5*m_des;
		m_HTF_bis=if m_sup then fluid_a.m_flow else m_des;
		for k in 1:N_exch - 1 loop
			m_des * (state_CO2_HX[k + 1].h - state_CO2_HX[k].h) = m_HTF_bis * (state_HTF_HX[k + 1].h - state_HTF_HX[k].h);
			m_des * (state_CO2_HX[k + 1].h - state_CO2_HX[k].h) = UA_exch_dis[k] * (deltaT_HX[k] + deltaT_HX[k + 1]) / 2;
			deltaT_HX[k] = MedRec.temperature(state_HTF_HX[k]) - MedPB.temperature(state_CO2_HX[k]);
			state_HTF_HX[k].p = state_HTF_HX[k + 1].p;
			state_CO2_HX[k].p = state_CO2_HX[k + 1].p;
		end for;
		deltaT_HX[N_exch] = MedRec.temperature(state_HTF_HX[N_exch]) - MedPB.temperature(state_CO2_HX[N_exch]);
		state_HTF_HX[N_exch] = if m_sup then MedRec.setState_phX(fluid_a.p, inStream(fluid_a.h_outflow)) else state_HTF_exch[N_exch];
		//The TIT and T_CO2 at the inlet of the HX are interpolated from previous points
		T_HTF_in = MedRec.temperature(state_HTF_HX[N_exch]);
		T_HTF_out = MedRec.temperature(state_HTF_HX[1]);
		TIT_CO2 = MedPB.temperature(state_CO2_HX[N_exch]);
		T_CO2_in_HX = Modelica.Math.Vectors.interpolate(T_high_frac, T_CO2_in_HX_table, TIT_CO2);
		state_CO2_HX[1] = MedPB.setState_pTX(p_high, T_CO2_in_HX);
		// Power Block calculations
		P_cooling = P_cool_des * ((T_low-T_amb_des)/(max(T_amb + 5, T_low)-T_amb)) ^ (3 / 0.805); 
		W_net = if m_sup then max(0,Modelica.Math.Vectors.interpolate(T_high_frac, W_out, TIT_CO2)-P_cooling) else 0;
		
		//Connectors obligations
		fluid_b.p = fluid_a.p;
		fluid_a.m_flow + fluid_b.m_flow = 0;
		fluid_b.h_outflow = state_HTF_HX[1].h;
		fluid_a.h_outflow=0; //shouldn't flow back
		annotation(
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
			__OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
	end interpolSimplePB;


