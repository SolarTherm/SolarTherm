within SolarTherm.Models.PowerBlocks.sCO2Cycle.DirectDesign;
model Exchanger
	import Modelica.SIunits.Conversions.*;
	extends SolarTherm.Interfaces.Models.HeatExchangerInterface;
	replaceable package MedPB = SolarTherm.Media.CarbonDioxide;
	replaceable package MedRec = SolarTherm.Media.ChlorideSaltPH.ChlorideSaltPH_ph;
	parameter Modelica.SIunits.Temperature T_out_CO2_des = from_degC(715);
	parameter Modelica.SIunits.Power P_nom_des = 164000;
	parameter Real ratio_m_des = 1 "ratio of m_CO2_des/m_HTF_des at design point";
	parameter Integer N_exch = 8;
	parameter Modelica.SIunits.HeatFlowRate Q_HX_des(fixed = false);
	parameter Modelica.SIunits.MassFlowRate m_CO2_des(fixed = false);
	parameter Modelica.SIunits.MassFlowRate m_HTF_des(fixed = false);
	parameter Modelica.SIunits.ThermalConductance UA_HX(fixed = false) "on-design conductance of the overall exchanger";
	parameter Modelica.SIunits.ThermalConductance[N_exch-1] UA_HX_dis(each fixed = false) "on-design conductance of the exchanger";
	parameter Modelica.SIunits.SpecificEnthalpy h_in_HTF_des(fixed = false, start = 855e3);
	parameter Modelica.SIunits.SpecificEnthalpy h_in_CO2_des(fixed = false, start = 9e5);
	parameter Modelica.SIunits.SpecificEnthalpy h_out_HTF_des(fixed = false);
	parameter Modelica.SIunits.SpecificEnthalpy h_out_CO2_des(fixed = false, start = 1.2e6);
	parameter Real[N_exch] deltaT_des(each fixed = false, each start = 75);
	parameter Modelica.SIunits.AbsolutePressure p_in_CO2_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_in_HTF_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_out_CO2_des(fixed = false);
	parameter Modelica.SIunits.AbsolutePressure p_out_HTF_des(fixed = false);
	parameter Modelica.SIunits.Temperature[N_exch] T_CO2_des(each fixed = false, start={from_degC(600) + 120*(i/N_exch) for i in 1:N_exch});
	parameter Modelica.SIunits.Temperature[N_exch] T_HTF_des(each fixed = false, start = {from_degC(650) + 120*(i/N_exch) for i in 1:N_exch});
	parameter MedPB.ThermodynamicState[N_exch] state_CO2_des(each p.fixed = false, each h.fixed = false, each p.start = 25e6, each h.start = 1e6);
	parameter MedPB.ThermodynamicState[N_exch] state_HTF_des(each p.fixed = false, each h.fixed = false, each p.start = 1e5, each h.start = 855004);

	MedPB.ThermodynamicState[N_exch] state_CO2;
	MedPB.ThermodynamicState[N_exch] state_HTF;
	Modelica.SIunits.SpecificEnthalpy[N_exch] h_CO2(start = {9.9e5 + (i/N_exch)*2e5 for i in 1:N_exch});
	Modelica.SIunits.SpecificEnthalpy[N_exch] h_HTF(start={6e5 + (i/N_exch)*2e5 for i in 1:N_exch});
	Modelica.SIunits.TemperatureDifference[N_exch] deltaT "Temperature difference in the heat exchangers";
	Modelica.SIunits.HeatFlowRate Q_HX;
	Modelica.SIunits.Temperature T_CO2_out;
	Modelica.SIunits.Temperature T_HTF_out;
	Modelica.SIunits.TemperatureDifference deltaTAve;
	Modelica.SIunits.MassFlowRate m_HTF_bis (start=P_nom_des/1e5);
	
	input Boolean m_sup "when m_sup=false, m_HTF=m_HTF_design and P_elec=0 -> allows switching off the PB";
	
initial equation
	for i in 1:N_exch loop
	deltaT_des[i] = MedRec.temperature(state_HTF_des[i]) - MedPB.temperature(state_CO2_des[i]);
	state_CO2_des[i] = MedPB.setState_pTX(p_in_CO2_des, T_CO2_des[i]);
	state_HTF_des[i] = MedRec.setState_pTX(p_in_HTF_des, T_HTF_des[i]);
	end for;

	T_CO2_des[N_exch]=T_out_CO2_des;

	for i in 1:(N_exch-1) loop
	Q_HX_des = ratio_m_des * (state_CO2_des[i+1].h - state_CO2_des[i].h);
	Q_HX_des =(state_HTF_des[i+1].h - state_HTF_des[i].h);
	m_HTF_des*Q_HX_des = UA_HX_dis[i] * (deltaT_des[i] + deltaT_des[i+1]) / 2;
	end for;

	UA_HX=sum(UA_HX_dis);

	p_in_CO2_des = p_out_CO2_des;
	p_in_HTF_des = p_out_HTF_des;
	h_in_HTF_des = MedRec.specificEnthalpy(state_HTF_des[N_exch]);
	h_out_HTF_des = MedRec.specificEnthalpy(state_HTF_des[1]);
	h_in_CO2_des = state_CO2_des[1].h;
	h_out_CO2_des = state_CO2_des[N_exch].h;
	m_CO2_des = ratio_m_des * m_HTF_des;

equation
	// Asigning props to each node
	for i in 1:N_exch loop
		deltaT[i] = if m_sup then MedRec.temperature(state_HTF[i]) - MedPB.temperature(state_CO2[i]) else deltaT_des[i];
		state_CO2[i] = MedPB.setState_phX(port_c_in.p, h_CO2[i]);
		state_HTF[i] = MedRec.setState_phX(port_h_in.p, h_HTF[i]);
	end for;
	
	T_CO2_out = MedPB.temperature(state_CO2[N_exch]); // Cold outlet temperature at the last node
	T_HTF_out = MedRec.temperature(state_HTF[1]);	 // Hot outlet temperature at the first node
	
	deltaTAve = (deltaT[1] + deltaT[N_exch]) / 2; // Setting an average temperature difference
	
	h_CO2[N_exch] = port_c_out.h_outflow;
	h_CO2[1] = inStream(port_c_in.h_outflow);
	
	h_HTF[N_exch] = if m_sup then inStream(port_h_in.h_outflow) else h_in_HTF_des;
	
	port_h_out.h_outflow = if m_sup then h_HTF[1] else inStream(port_h_in.h_outflow);
	
	m_HTF_bis = if m_sup then port_h_in.m_flow else m_HTF_des;
	
	Q_HX = port_c_in.m_flow * (h_CO2[N_exch] - h_CO2[1]);
	
	Q_flow = Q_HX_des;
	
	for i in 1:(N_exch-1) loop 
	m_HTF_bis*(h_HTF[i+1]-h_HTF[i])=port_c_in.m_flow*(h_CO2[i+1]-h_CO2[i]);
	port_c_in.m_flow*(h_CO2[i+1]-h_CO2[i])=UA_HX_dis[i]* (1 / 2 * abs(m_HTF_bis / m_HTF_des + port_c_in.m_flow / m_CO2_des)) ^ 0.8* (deltaT[i] + deltaT[i+1]) / 2;
	end for;
	
	port_h_in.h_outflow = 0; //inStream(port_h_out.h_outflow);
	port_c_in.h_outflow = 0; //inStream(port_c_out.h_outflow);
	
	//It is necessary to have one equation in a cycle that doesn't imply a circular equality on the mass flow rates
	//port_c_out.m_flow + port_c_in.m_flow = 0;
	
	port_h_in.m_flow + port_h_out.m_flow = 0;
	//port_c_in.m_flow = if m_sup then port_h_in.m_flow else m_CO2_des * 0.8;
	
	// Pressure equality
	port_c_out.p = port_c_in.p;
	port_h_in.p = port_h_out.p;

annotation(
	experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
	Icon(coordinateSystem(initialScale = 1, extent = {{-40, -40}, {40, 40}})),
	Diagram(coordinateSystem(initialScale = 1, extent = {{-40, -40}, {40, 40}})));
end Exchanger;
