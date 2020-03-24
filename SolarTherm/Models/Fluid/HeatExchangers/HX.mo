within SolarTherm.Models.Fluid.HeatExchangers;
model HX
  extends SolarTherm.Interfaces.Models.HeatExchangerFluid;
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  import SolarTherm.{Models,Media};
  import Modelica.Math.Vectors;
  import FI = SolarTherm.Models.Analysis.Finances;
  import UF = SolarTherm.Models.Fluid.HeatExchangers.Utilities;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";
  
  //Design Parameters
  parameter SI.HeatFlowRate Q_d_des = 50e6 "Design Heat Flow Rate";
  parameter SI.Temperature T_Na1_des = 740 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter SI.Temperature T_MS1_des = 500 + 273.15 "Desing Molten Salt Cold Fluid Temperature";
  parameter SI.Temperature T_MS2_des = 720 + 273.15 "Desing Molten Salt Hot Fluid Temperature";
  parameter SI.Pressure p_Na1_des = 101325 "Design Sodium Inlet Pressure";
  parameter SI.Pressure p_MS1_des = 101325 "Design Molten Salt Inlet Pressure";
  
  //Input parameters
  parameter SI.Temperature T_Na2_input = 520 + 273.15 "Optimal outlet sodium temperature";
  //Use ratio_cond to constrain the design of the HX: if "true" the HX will be forced to have L/D_s aspect ratio<ratio_max.
  parameter Boolean ratio_cond = true "Activate ratio constraint";  //Default value = true
  parameter Real ratio_max = 10 "Maximum L/D_s ratio"; //If ratio_cond = true provide a value (default value = 10)
  //Use it to constrain the design of the HX: if "true" the HX will be forced to have L<L_max.
  parameter Boolean L_max_cond = false "Activate maximum HX length constraint"; //Default value = false
  parameter SI.Length L_max_input = 1 "Maximum HX length"; //If L_max_cond = true provide a value (default value = 10)
  //If optimize_and_run is "true", d_o, N_p and layout will be chosen as results of the optimization, otherwise provide the following input values:
  parameter Boolean optimize_and_run = true; 
  parameter SI.Length d_o_input = 0.00635 "Optimal Outer Tube Diameter";
  parameter Integer N_p_input = 1 "Optimal Tube passes number";
  parameter Integer layout_input = 2 "Optimal Tube Layout";
  parameter Boolean N_t_input_on = false "Activate fixed number of tubes";
  parameter Integer N_t_input = 1 "Input Number of tubes";
  
  //Auxiliary parameters
  parameter FI.EnergyPrice_kWh c_e = /*0.13 / 0.9175*/ 0.073 "Power cost";
  parameter Real r = 0.05 "Real interest rate";
  parameter Real H_y(unit = "h") = /*4500*/ 5600 "Operating hours";
  parameter Integer n(unit = "h") = 30 "Operating years";
  parameter FI.MassPrice material_sc = 84 "Material HX Specific Cost";
  
  //Velocity limits
  parameter SI.Velocity v_max_MS_lim_min = 0.50;
  parameter SI.Velocity v_max_MS_lim_max = 1.50;
  parameter SI.Velocity v_Na_lim_min = 4/3.281;
  parameter SI.Velocity v_Na_lim_max = 8/3.281;
  
  //Minimum and initial states
  parameter Medium1.ThermodynamicState state_Na_in_0 = Medium1.setState_pTX(p_Na1_des, T_Na1_des);
  parameter Medium2.ThermodynamicState state_MS_in_0 = Medium2.setState_pTX(p_MS1_des, T_MS1_des);
  parameter SI.SpecificEnthalpy h_Na_in_0 = Medium1.specificEnthalpy(state_Na_in_0);
  parameter SI.SpecificEnthalpy h_MS_in_0 = Medium2.specificEnthalpy(state_MS_in_0);
  parameter Medium1.ThermodynamicState state_Na_out_0 = Medium1.setState_pTX(p_Na1_des, T_Na2_design);
  parameter Medium2.ThermodynamicState state_MS_out_0 = Medium2.setState_pTX(p_MS1_des, T_MS2_des);
  parameter SI.SpecificEnthalpy h_Na_out_0 = Medium1.specificEnthalpy(state_Na_out_0);
  parameter SI.SpecificEnthalpy h_MS_out_0 = Medium2.specificEnthalpy(state_MS_out_0);
  parameter SI.MassFlowRate m_flow_Na_min_des(fixed = false) "Sodium minimum mass flow rate";
  parameter SI.MassFlowRate m_flow_MS_min_des(fixed = false) "Molten-Salt minimum mass flow rate";
  parameter SI.Temperature T_Na2_min = 505 + 273.15 "Desing Sodium Hot Fluid Temperature";
  parameter Medium1.ThermodynamicState state_Na_min = Medium1.setState_pTX(p_Na1_des, T_Na2_min);
  parameter SI.SpecificEnthalpy h_Na_min = Medium1.specificEnthalpy(state_Na_min);
  parameter SI.TemperatureDifference DT1_start=T_Na1_des-T_MS2_des;
  parameter SI.TemperatureDifference DT2_start=T_Na2_design-T_MS1_des;
  parameter SI.TemperatureDifference LMTD_start=(DT1_start - DT2_start) / MA.log(DT1_start / DT2_start);
  
  //Optimal Parameter Values
  parameter SI.MassFlowRate m_flow_Na_design(fixed = false)"Sodium mass flow rate";
  parameter SI.MassFlowRate m_flow_MS_design(fixed = false) "Molten-Salt mass flow rate";
  parameter Real F_design(fixed = false) "Temperature correction factor";
  parameter SI.ThermalConductance UA_design(fixed = false) "UA";
  parameter Integer N_t(fixed = false) "Number of tubes";
  parameter SI.CoefficientOfHeatTransfer U_design(fixed = false) "Heat tranfer coefficient";
  parameter SI.Area A_HX(fixed = false) "Exchange Area";
  parameter SI.Pressure Dp_tube_design(fixed = false) "Tube-side pressure drop";
  parameter SI.Pressure Dp_shell_design(fixed = false) "Shell-side pressure drop";
  parameter FI.MoneyPerYear TAC(fixed = false) "Total Annualized Cost";
  parameter SI.CoefficientOfHeatTransfer h_s_design(fixed = false) "Shell-side Heat tranfer coefficient";
  parameter SI.CoefficientOfHeatTransfer h_t_design(fixed = false) "Tube-side Heat tranfer coefficient";
  parameter SI.Length D_s(fixed = false) "Shell Diameter";
  parameter SI.Length D_s_out(fixed = false) "Outer Shell Diameter";
  parameter Integer N_baffles(fixed = false) "Number of baffles";
  parameter SI.Length l_b(fixed = false) "Baffle spacing";
  parameter SI.Velocity v_Na_design(fixed = false) "Sodium velocity in tubes";
  parameter SI.Velocity v_max_MS_design(fixed = false) "Molten Salt velocity in shell";
  parameter SI.Volume V_HX(fixed = false) "Heat-Exchanger Total Volume";
  parameter SI.Mass m_HX(fixed = false) "Heat-Exchanger Total Mass";
  parameter SI.Mass m_material_HX(fixed = false) "Heat-Exchanger Material Mass";
  parameter FI.Money_USD C_BEC_HX(fixed = false) "Bare cost @2018";
  parameter FI.MoneyPerYear C_pump_design(fixed = false) "Annual pumping cost";
  parameter Real ex_eff_design(fixed = false) "HX Exergetic Efficiency";
  parameter Real en_eff_design(fixed = false) "HX Energetic Efficiency";
  parameter SI.Length L(fixed = false) "Tube length";
  parameter Real ratio_HX(fixed = false) ;
  parameter Real penalty(fixed = false) ;
  parameter SI.Length d_o(fixed = false) "Optimal Outer Tube Diameter";
  parameter Integer N_p(fixed = false) "Optimal Tube passes number";
  parameter Integer N_sp(fixed = false) "Optimal Tube passes number";
  parameter Integer layout(fixed = false) "Optimal Tube Layout";
  parameter SI.Temperature T_Na2_design(fixed = false) "Optimal outlet sodium temperature";
  parameter Integer N_t_min(fixed = false) "Minimum Number of tubes";
  parameter Integer N_t_max(fixed = false) "Maximum Number of tubes";
  
  //Variables
  SI.MassFlowRate m_flow_Na(start=m_flow_Na_design, nominal=m_flow_Na_design) "Sodium mass flow rate";
  SI.MassFlowRate m_flow_MS(start=m_flow_MS_design, nominal=m_flow_MS_design) "Molten Salt mass flow rate";
  SI.Temperature T_Na1(final start=T_Na1_des, nominal=T_Na1_des) "Sodium Hot Fluid Temperature";
  SI.Temperature T_MS1(final start=T_MS1_des, nominal=T_MS1_des) "Molten Salt Cold Fluid Temperature";
  SI.Temperature T_MS2(start=T_MS2_des, nominal=T_MS2_des) "Molten Salt Hot Fluid Temperature";
  SI.Temperature T_Na2(start=T_Na2_design, nominal=T_Na2_design) "Sodium Cold Fluid Temperature";
  SI.Pressure p_Na1 "Sodium Inlet Pressure";
  SI.Pressure p_MS1 "Molten Salt Inlet Pressure";
  SI.Pressure p_Na2 "Sodium Outlet Pressure";
  SI.Pressure p_MS2 "Molten Salt Outlet Pressure";
  SI.CoefficientOfHeatTransfer U(start=U_design, nominal=U_design) "Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_s "Shell-side Heat tranfer coefficient";
  SI.CoefficientOfHeatTransfer h_t "Tube-side Heat tranfer coefficient";
  SI.HeatFlowRate Q(final start=Q_d_des,nominal=Q_d_des) "Design Heat Flow Rate";
  Real F "Temperature correction factor";
  SI.TemperatureDifference DT1(start=DT1_start, nominal=DT1_start) "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2(start=DT2_start, nominal=DT2_start) "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD(start=LMTD_start, nominal=LMTD_start) "Logarithmic mean temperature difference";
  SI.Pressure Dp_tube(start=Dp_tube_design, nominal=Dp_tube_design) "Tube-side pressure drop";
  SI.Pressure Dp_shell(start=Dp_shell_design, nominal=Dp_shell_design) "Shell-side pressure drop";
  SI.Velocity v_Na(start=v_Na_design, nominal=v_Na_design) "Sodium velocity in tubes";
  SI.Velocity v_max_MS(start=v_max_MS_design, nominal=v_max_MS_design) "Molten Salt velocity in shell";
  
  //Fluid Properties
  SI.Temperature Tm_Na(start=(T_Na1_des+T_Na2_design)/2, nominal=(T_Na1_des+T_Na2_design)/2) "Mean Sodium Fluid Temperature";
  SI.Temperature Tm_MS(start=(T_MS1_des+T_MS2_des)/2, nominal=(T_MS1_des+T_MS2_des)/2) "Mean Molten Salts Fluid Temperature";
  SI.ThermalConductivity k_Na "Sodium Conductivity @mean temperature";
  SI.ThermalConductivity k_MS "Molten Salts Conductivity @mean temperature";
  SI.Density rho_Na "Sodium density @mean temperature";
  SI.Density rho_MS "Molten Salts density @mean temperature";
  SI.DynamicViscosity mu_Na "Sodium dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_MS "Molten Salts  dynamic viscosity @mean temperature";
  SI.DynamicViscosity mu_Na_wall "Sodium dynamic viscosity @wall temperature";
  SI.DynamicViscosity mu_MS_wall "Molten salts dynamic viscosity @wall temperature";
  SI.SpecificHeatCapacity cp_Na "Sodium specific heat capacity @mean temperature";
  SI.SpecificHeatCapacity cp_MS "Molten Salts specific heat capacity @mean temperature";
  Medium1.ThermodynamicState state_mean_Na;
  Medium1.ThermodynamicState state_input_Na;
  Medium1.ThermodynamicState state_output_Na;
  Medium2.ThermodynamicState state_mean_MS;
  Medium2.ThermodynamicState state_wall_MS;
  Medium2.ThermodynamicState state_input_MS;
  Medium2.ThermodynamicState state_output_MS;
  
  //Ports Variables
  SI.SpecificEnthalpy h_Na_in(start = h_Na_in_0, nominal = h_Na_in_0);
  SI.SpecificEnthalpy h_MS_in(start = h_MS_in_0, nominal = h_MS_in_0);
  SI.SpecificEnthalpy h_MS_out(start = h_MS_out_0, nominal = h_MS_out_0);
  SI.SpecificEnthalpy h_Na_out(start = h_Na_out_0, nominal = h_Na_out_0);
  
  //Real Input
  Modelica.Blocks.Interfaces.BooleanInput HF_on annotation(
    Placement(visible = true, transformation(origin = {26, 46}, extent = {{-6, -6}, {6, 6}}, rotation = -90), iconTransformation(origin = {26, 46}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));


initial algorithm
  if optimize_and_run == true then
    T_Na2_design := T_Na2_input;
    (m_flow_Na_design, m_flow_MS_design, F_design, UA_design, A_HX, U_design, N_t, Dp_tube_design, Dp_shell_design, h_s_design, h_t_design, D_s, D_s_out, N_baffles, l_b, v_Na_design, v_max_MS_design, V_HX, m_HX, m_material_HX, C_BEC_HX, C_pump_design, TAC, ex_eff_design, en_eff_design, L, ratio_HX, penalty, d_o, N_p, N_sp, layout, N_t_min, N_t_max):= UF.Optimize_HX(Q_d_des = Q_d_des, T_Na1_des = T_Na1_des, T_Na2_des = T_Na2_design, T_MS1_des = T_MS1_des, T_MS2_des = T_MS2_des, p_Na1_des = p_Na1_des, p_MS1_des = p_MS1_des, c_e = c_e, r = r, H_y = H_y, n = n, material_sc=material_sc, ratio_max=ratio_max, ratio_cond=ratio_cond, L_max_cond=L_max_cond, L_max_input=L_max_input);
  else
    d_o:=d_o_input;
    N_p:=N_p_input;
    N_sp:=N_p_input;
    layout:=layout_input;
    T_Na2_design := T_Na2_input;
    (m_flow_Na_design, m_flow_MS_design, F_design, UA_design, A_HX, U_design, N_t, Dp_tube_design, Dp_shell_design, h_s_design, h_t_design, D_s, D_s_out, N_baffles, l_b, v_Na_design, v_max_MS_design, V_HX, m_HX, m_material_HX, C_BEC_HX, C_pump_design, TAC, ex_eff_design, en_eff_design, L, ratio_HX, penalty, N_t_min, N_t_max):= UF.Design_HX(Q_d = Q_d_des, T_Na1 = T_Na1_des, T_MS1 = T_MS1_des, T_MS2 = T_MS2_des, d_o = d_o, N_p = N_p, N_sp = N_sp, layout = layout, T_Na2 = T_Na2_design, p_MS1 = p_MS1_des, p_Na1 = p_Na1_des, c_e = c_e, r = r, H_y = H_y, n = n, material_sc=material_sc, ratio_max=ratio_max, ratio_cond=ratio_cond, L_max_cond=L_max_cond, L_max_input=L_max_input, N_t_input_on=N_t_input_on, N_t_input=N_t_input);            
  end if;
  
  m_flow_MS_min_des := 1e-3;
  m_flow_Na_min_des := 1e-3;
  
equation
//Mass conservation equations
  port_a_in.m_flow + port_a_out.m_flow = 0;
  port_b_in.m_flow + port_b_out.m_flow = 0;
  m_flow_Na = port_a_in.m_flow;
  m_flow_MS = port_b_in.m_flow;

//Fluids Enthalpies
  port_b_out.h_outflow = h_MS_out;
  port_a_out.h_outflow = h_Na_out;
  h_Na_in = if HF_on then inStream(port_a_in.h_outflow) else h_Na_out_0;
  h_MS_in = inStream(port_b_in.h_outflow);

//Shouldn't have reverse flows
  port_a_in.h_outflow = 0.0;
  port_b_in.h_outflow = 0.0;

//Other ports equations
  port_a_out.Xi_outflow = inStream(port_a_in.Xi_outflow);
  port_a_in.Xi_outflow = inStream(port_a_out.Xi_outflow);
  port_b_out.Xi_outflow = inStream(port_b_in.Xi_outflow);
  port_b_in.Xi_outflow = inStream(port_b_out.Xi_outflow);
  port_a_out.C_outflow = inStream(port_a_in.C_outflow);
  port_a_in.C_outflow = inStream(port_a_out.C_outflow);
  port_b_out.C_outflow = inStream(port_b_in.C_outflow);
  port_b_in.C_outflow = inStream(port_b_out.C_outflow);

//Fluid temperatures and pressures
  T_Na1 = Medium1.temperature(state_input_Na);
  T_Na2 = Medium1.temperature(state_output_Na);
  T_MS1 = Medium2.temperature(state_input_MS);
  T_MS2 = Medium2.temperature(state_output_MS);
  p_Na1 = port_a_in.p;
  p_MS1 = port_b_in.p;
  p_Na2 = port_a_out.p;
  p_MS2 = port_b_out.p;
  p_Na2 = p_Na1; //-Dp_tube;
  p_MS2 = p_MS1; //-Dp_shell;

//Molten Salt properties
  Tm_MS = (T_MS1 + T_MS2) / 2;
  state_mean_MS = Medium2.setState_pTX(p_MS1, Tm_MS);
  state_input_MS = Medium2.setState_phX(p_MS1, h_MS_in);
  state_output_MS = Medium2.setState_phX(p_MS1, h_MS_out);
  state_wall_MS = Medium2.setState_pTX(p_MS1, Tm_Na);
  rho_MS = Medium2.density(state_mean_MS);
  cp_MS = Medium2.specificHeatCapacityCp(state_mean_MS);
  mu_MS = Medium2.dynamicViscosity(state_mean_MS);
  k_MS = Medium2.thermalConductivity(state_mean_MS);
  mu_MS_wall = Medium2.dynamicViscosity(state_wall_MS);

//Sodium properties
  Tm_Na = (T_Na1 + T_Na2) / 2;
  state_mean_Na = Medium1.setState_pTX(p_Na1, Tm_Na);
  state_input_Na = Medium1.setState_phX(p_Na1, h_Na_in);
  state_output_Na = Medium1.setState_phX(p_Na1, h_Na_out);
  rho_Na = Medium1.density(state_mean_Na);
  cp_Na = Medium1.specificHeatCapacityCp(state_mean_Na);
  mu_Na = Medium1.dynamicViscosity(state_mean_Na);
  mu_Na_wall = mu_Na;
  k_Na = Medium1.thermalConductivity(state_mean_Na);

//Problem
  Q = max(m_flow_Na_min_des, m_flow_Na) * (h_Na_in - h_Na_out);
  Q = max(m_flow_MS_min_des, m_flow_MS) * (h_MS_out - h_MS_in);
  DT1 = T_Na1 - T_MS2;
  DT2 = T_Na2 - T_MS1;  
  LMTD = if not HF_on then 0 else if noEvent(DT1 / DT2 <= 0) then 0 else if noEvent(abs(DT1 - DT2)<1e-3) then DT1 else (DT1 - DT2) / MA.log(DT1 / DT2);  
  F = 1;
  (U, h_s, h_t)=UF.HTCs(d_o=d_o, N_p=N_p, N_sp=N_p, layout=layout, N_t=N_t, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_MS, state_wall_MS=state_wall_MS, m_flow_Na=m_flow_Na, m_flow_MS=m_flow_MS, l_b=l_b);    
  Q = U * A_HX * F * LMTD;
  (Dp_tube, Dp_shell, v_Na, v_max_MS)=UF.Dp_losses(d_o=d_o, N_p=N_p, N_sp=N_p, layout=layout, N_t=N_t, L=L, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_MS, state_wall_MS=state_wall_MS, m_flow_Na=m_flow_Na, m_flow_MS=m_flow_MS, l_b=l_b, N=N_baffles);

annotation( Documentation(info = "<html>
	<p>
		<b>HX</b> provide an optimizated design of a Shell and Tubes HX, based on some input parameters and it models the HX operating conditions based on a LMTD approach.
	</p>
	</html>", revisions = "<html>
	<ul>
		<li><i>Jan 2020</i> by Salvatore Guccione:<br>
		Released first version.</li>
			</ul>
	</html>"));
	
end HX;
