within SolarTherm.Models.PowerBlocks.sCO2Cycle.QuickCO2PB;
	model correlRecompPB
		import SI = Modelica.SIunits;
		import CV = Modelica.SIunits.Conversions;
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedPB = SolarTherm.Media.CO2.CO2_ph;
		replaceable package MedRec = SolarTherm.Media.SolidParticles.CarboHSP_ph;
		//Objective: having a few points in order to correlate. Should be feasible with for loops.
		parameter SI.Power P_nom = 100 * 10 ^ 6;
		parameter SI.AbsolutePressure p_high = CV.from_bar(250);
		parameter SI.AbsolutePressure p_low = CV.from_bar(80);
		parameter Real PR = p_high / p_low;
		parameter Real gamma = 0.28 "recompression fraction";
		parameter SI.ThermodynamicTemperature T_high = CV.from_degC(715) "inlet temperature of the turbine";
		parameter SI.ThermodynamicTemperature T_HTF_in = CV.from_degC(800) "inlet temperature of the HTF";
		parameter SI.ThermodynamicTemperature T_low = CV.from_degC(45) "Inlet temperature of the compressor";
		parameter SI.ThermodynamicTemperature T_amb_des = CV.from_degC(20) "ambient temperature at design";
		parameter SI.TemperatureDifference pinchHTR = 5;
		parameter SI.TemperatureDifference pinchLTR = 5;
		parameter SI.TemperatureDifference pinchExch = T_HTF_in - T_high;
		parameter SI.Efficiency eta_main_comp = 0.89;
		parameter SI.Efficiency eta_re_comp = 0.89;
		parameter SI.Efficiency eta_turb = 0.93;
		parameter Integer N_exch = 5;
		parameter Integer N_HTR = 15;
		parameter Integer N_LTR = 15;
		parameter Integer N_cooler = 15;
		parameter Integer N_points = 10;
		//parameter SI.ThermodynamicTemperature[N_points] T_high_frac (each fixed=false) "points for which efficiency will be calculated";
		//parameters to calculate
		// parameter SI.MassFlowRate m_des (fixed=false, start=P_nom/10^5) "mass flow rate at the outlet of the turbine";
		//parameter SI.Power[N_points] P_out (each fixed=false, each start=P_nom) "power at the outlet for off-design";
		//parameter SI.Efficiency eta_cycle (each fixed=false,each start=0.5) "efficiency of the cycle";
		//Inlet of the turbine
		parameter SI.SpecificEntropy s_in_turb(fixed = false, start = 2900) "inlet entropy to the turbine";
		parameter MedPB.ThermodynamicState state_in_turb(p.fixed = false, h.fixed = false);
		parameter SI.Power W_turb(each fixed = false);
		parameter MedPB.ThermodynamicState state_out_turb(p.fixed = false, h.fixed = false);
		//Main Compressor parameters
		parameter SI.SpecificEntropy s_in_mainComp(fixed = false, start = 1500) "inlet entropy to the main compressor";
		parameter SI.Power W_mainComp(fixed = false);
		//reCompressor parameters
		//	parameter SI.SpecificEntropy s_in_reComp (each fixed=false)"inlet entropy to the recompressor";
		//	parameter MedPB.ThermodynamicState state_out_reComp (each p=p_high, each h.fixed=false, each h.start=550000);
		//	parameter SI.Power W_reComp (each fixed=false);
		//Exchanger parameters. Calculated only at on-design
		parameter SolarTherm.Types.Conductance[N_exch - 1] UA_exch_dis(each fixed = false, each start = P_nom * 0.4 / N_exch);
		parameter SI.HeatFlowRate Q_dis_exch(fixed = false);
		parameter MedPB.ThermodynamicState[N_exch] state_CO2_exch(each p.fixed = false, each h.fixed = false, each h.start = 10 ^ 6);
		parameter MedRec.ThermodynamicState[N_exch] state_HTF_exch(each p.fixed = false, each h.fixed = false, each h.start = 6 * 10 ^ 5);
		parameter SI.TemperatureDifference[N_exch] deltaT_exch(each start = 20, each fixed = false);
		// HTR parameters
		parameter SolarTherm.Types.Conductance[N_HTR - 1] UA_HTR_dis(each fixed = false, each start = P_nom * 0.4 / N_HTR);
		parameter SI.HeatFlowRate Q_dis_HTR(fixed = false, start = 2 * 10 ^ 4);
		parameter MedPB.ThermodynamicState[N_HTR] state_HTR_turb(each p.fixed = false, each h.fixed = false, each h.start = 7 * 10 ^ 5);
		parameter MedPB.ThermodynamicState[N_HTR] state_HTR_comp(each p.fixed = false, each h.fixed = false, each h.start = 6 * 10 ^ 5);
		parameter SI.TemperatureDifference[N_HTR] deltaT_HTR(each start = 20, each fixed = false);
		//LTR parameters
		//	parameter SolarTherm.Types.Conductance[N_LTR-1] UA_LTR_dis (each fixed=false, each start=P_nom*0.4/N_HTR);
		//	parameter SI.HeatFlowRate Q_dis_LTR (fixed=false, start = 2*10^4);
		//	parameter SI.TemperatureDifference[N_LTR] deltaT_LTR (each start=20, each fixed=false);
		//	parameter MedPB.ThermodynamicState[N_LTR] state_LTR_turb (each p = p_low, each h.fixed=false, each h.start=6*10^5);
		//	parameter MedPB.ThermodynamicState[N_LTR] state_LTR_comp (each p = p_high, each h.fixed=false, each h.start=5*10^5);
		// Cooler parameters
		parameter MedPB.ThermodynamicState[N_cooler] state_cooler(each p.fixed = false, each h.fixed = false, each h.start = 4.5 * 10 ^ 5);
		parameter MedPB.ThermodynamicState state_cooler_out(p.fixed = false, h.fixed = false);
		parameter SI.HeatFlowRate Q_dis_cooler(fixed = false);
		parameter SolarTherm.Types.Conductance[N_cooler - 1] UA_cooler_dis(each fixed = false);
	initial equation
//Part I. On-design=first point
//Inlet of the turbine
		state_in_turb = MedPB.setState_pTX(p_high, T_high);
		s_in_turb = MedPB.specificEntropy(state_in_turb);
		state_out_turb = MedPB.setState_phX(p_low, state_in_turb.h + eta_turb * (MedPB.specificEnthalpy(MedPB.setState_psX(p_low, s_in_turb)) - state_in_turb.h));
		W_turb = state_out_turb.h - state_in_turb.h;
//High temperature recuperator
		for k in 1:N_HTR - 1 loop
			Q_dis_HTR = state_HTR_turb[k + 1].h - state_HTR_turb[k].h;
			Q_dis_HTR = state_HTR_comp[k + 1].h - state_HTR_comp[k].h;
			deltaT_HTR[k] = MedPB.temperature(state_HTR_turb[k]) - MedPB.temperature(state_HTR_comp[k]);
			Q_dis_HTR = UA_HTR_dis[k] * (deltaT_HTR[k] + deltaT_HTR[k + 1]) / 2;
			state_HTR_comp[k + 1].p = p_high;
//has to setState when doing isentropic enthalpy
			state_HTR_turb[k].p = p_low;
		end for;
		deltaT_HTR[N_HTR] = MedPB.temperature(state_HTR_turb[N_HTR]) - MedPB.temperature(state_HTR_comp[N_HTR]);
		min(deltaT_HTR) = pinchHTR;
		state_HTR_turb[N_HTR].p = p_low;
		state_HTR_turb[N_HTR].h = state_out_turb.h;
//state_LTR_turb[N_LTR].h=state_HTR_turb[1].h;
//Low temperature recuperator
//	for k in 1:(N_LTR-1) loop
//		Q_dis_LTR = state_LTR_turb[k+1].h-state_LTR_turb[k].h;
//		Q_dis_LTR = (1-gamma)*(state_LTR_comp[k+1].h-state_LTR_comp[k].h);
//		deltaT_LTR[k]=MedPB.temperature(state_LTR_turb[k])-MedPB.temperature(state_LTR_comp[k]);
//		m_des*Q_dis_LTR=UA_LTR_dis[k]*(deltaT_LTR[k]+deltaT_LTR[k+1])/2;
//	 end for;
//	 deltaT_LTR[N_LTR]=MedPB.temperature(state_LTR_turb[N_LTR])-MedPB.temperature(state_LTR_comp[N_LTR]);
//	 min(deltaT_LTR)=pinchLTR;
		state_cooler[1].h = state_HTR_turb[1].h;
//Cooler. UA (and therefore this part) are only for economical correlation
		for k in 1:N_cooler - 1 loop
			Q_dis_cooler = state_cooler[k + 1].h - state_cooler[k].h;
			Q_dis_cooler = -UA_cooler_dis[k] * (MedPB.temperature(state_cooler[k + 1]) - T_amb_des + MedPB.temperature(state_cooler[k]) - T_amb_des) / 2;
			state_cooler[k].p = p_low;
		end for;
		state_cooler[N_cooler] = state_cooler_out;
		state_cooler_out = MedPB.setState_pTX(p_low, T_low);
//Main compressor. Inlet supposed always the same for off-design
		s_in_mainComp = MedPB.specificEntropy(state_cooler_out);
		state_HTR_comp[1] = MedPB.setState_phX(p_high, state_cooler_out.h + eta_main_comp * (MedPB.specificEnthalpy(MedPB.setState_psX(p_high, s_in_mainComp)) - state_cooler_out.h));
		W_mainComp = state_HTR_comp[1].h - state_cooler_out.h;
// ReCompression loop
//	s_in_reComp=MedPB.specificEntropy(state_LTR_turb[1]);
//	state_out_reComp.h=state_LTR_turb[1].h+eta_re_comp*(MedPB.specificEnthalpy(MedPB.setState_psX(p_high,s_in_reComp))-state_LTR_turb[1].h);
//	W_reComp = m_des*gamma*(state_out_reComp.h-state_LTR_turb[1].h);
//	state_HTR_comp[1].h=(1-gamma)*state_LTR_comp[N_LTR].h+gamma*state_out_reComp.h;
//Exchanger. Done only on-design. After, only the TIT is varied.
//Q_dis_exch*(N_exch-1)=state_CO2_exch[N_exch].h-state_CO2_exch[1].h;
		state_CO2_exch[N_exch].h = state_in_turb.h;
		state_CO2_exch[1].h = state_HTR_comp[N_HTR].h;
		state_HTF_exch[N_exch] = MedRec.setState_pTX(10 ^ 5, T_HTF_in);
		for k in 1:N_exch - 1 loop
			Q_dis_exch = state_CO2_exch[k + 1].h - state_CO2_exch[k].h;
			Q_dis_exch = state_HTF_exch[k + 1].h - state_HTF_exch[k].h;
			Q_dis_exch = UA_exch_dis[k] * (deltaT_exch[k] + deltaT_exch[k + 1]) / 2;
			deltaT_exch[k] = MedRec.temperature(state_HTF_exch[k]) - MedPB.temperature(state_CO2_exch[k]);
			state_CO2_exch[k].p = p_high;
			state_HTF_exch[k].p = 10 ^ 5;
		end for;
		deltaT_exch[N_exch] = MedRec.temperature(state_HTF_exch[N_exch]) - MedPB.temperature(state_CO2_exch[N_exch]);
		state_CO2_exch[N_exch].p = p_high;
// P_nom=(-W_turb)-W_mainComp;
//eta_cycle=P_nom/(m_des*Q_dis_exch*(N_exch-1));
//Part II. Off-design points. Mass flow rate is kept constant
//for i in 2:(N_points+1) loop
//		//Inlet of the turbine
//		T_high_frac[i-1]=(0.75+(1.25-0.75)*(i-1)/(N_points-1))*(T_high-273.15)+273.15;
//		state_in_turb[i].h = MedPB.specificEnthalpy(MedPB.setState_pTX(p_high,T_high_frac[i-1]));
//		s_in_turb[i]=MedPB.specificEntropy(state_in_turb[i]);
//		state_HTR_turb[i,N_HTR].h= state_in_turb[i].h+eta_turb*(MedPB.specificEnthalpy(MedPB.setState_psX(p_high,s_in_turb[i]))-state_in_turb[i].h);
//		W_turb[i]=m_des*(state_HTR_turb[i,N_HTR].h-state_in_turb[i].h);
//		//High temperature recuperator
//	for k in 1:(N_HTR-1) loop
//		state_HTR_turb[i,k+1].h-state_HTR_turb[i,k].h=state_HTR_comp[i,k+1].h-state_HTR_comp[i,k].h;
//		deltaT_HTR[i,k]=MedPB.temperature(state_HTR_turb[i,k])-MedPB.temperature(state_HTR_comp[i,k]);
//		m_des*(state_HTR_turb[i,k+1].h-state_HTR_turb[i,k].h)=UA_HTR_dis[k]*(deltaT_HTR[i,k]+deltaT_HTR[i,k+1])/2;
//	 end for;
//	 deltaT_HTR[i,N_HTR]=MedPB.temperature(state_HTR_turb[i,N_HTR])-MedPB.temperature(state_HTR_comp[i,N_HTR]);
//	 state_LTR_turb[i,N_LTR].h=state_HTR_turb[i,1].h;
//	 //Low-temperature recuperator
//		for k in 1:(N_LTR-1) loop
//		 (1-gamma)*(state_LTR_comp[i,k+1].h-state_LTR_comp[i,k].h) = state_LTR_turb[i,k+1].h-state_LTR_turb[i,k].h;
//		deltaT_LTR[i,k]=MedPB.temperature(state_LTR_turb[i,k])-MedPB.temperature(state_LTR_comp[i,k]);
//		m_des*(state_LTR_turb[i,k+1].h-state_LTR_turb[i,k].h)=UA_LTR_dis[k]*(deltaT_LTR[i,k]+deltaT_LTR[i,k+1])/2;
//	 end for;
//	 deltaT_LTR[i,N_LTR]=MedPB.temperature(state_LTR_turb[i,N_LTR])-MedPB.temperature(state_LTR_comp[i,N_LTR]);
//	 //Inlet of the LTR. Main Compressor always has the same inlet so no off-design
//	 state_LTR_comp[i,1].h=state_cooler[N_cooler].h+eta_main_comp*(MedPB.specificEnthalpy(MedPB.setState_psX(p_high,s_in_mainComp))-state_cooler[N_cooler].h);
//	 // ReCompression loop
//	s_in_reComp[i]=MedPB.specificEntropy(state_LTR_turb[i,1]);
//	state_out_reComp[i].h=state_LTR_turb[i,1].h+eta_re_comp*(MedPB.specificEnthalpy(MedPB.setState_psX(p_high,s_in_reComp[i]))-state_LTR_turb[i,1].h);
//	W_reComp[i] = m_des*gamma*(state_out_reComp[i].h-state_LTR_turb[i,1].h);
//	state_HTR_comp[i,1].h=(1-gamma)*state_LTR_comp[i,N_LTR].h+gamma*state_out_reComp[i].h;
//	P_out[i-1]=(-W_turb[i])-W_mainComp-W_reComp[i];
//	eta_cycle[i]=P_out[i-1]/(m_des*(state_in_turb[i].h-state_HTR_comp[i,N_LTR].h));
//end for;
		annotation(
			experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
			__OpenModelica_simulationFlags(lv = "LOG_INIT,LOG_LS_V,LOG_NLS,LOG_NLS_V,LOG_RES_INIT,LOG_STATS", outputFormat = "mat", s = "dassl"));
	end correlRecompPB;

