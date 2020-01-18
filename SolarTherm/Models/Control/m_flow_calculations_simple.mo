within SolarTherm.Models.Control;
model m_flow_calculations_simple
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";

  parameter SI.Length d_o=1 "Outer Tube diameter";
  parameter Integer N_p=1 "Number of tube-passes";
  parameter Integer N_sp=1 "Number of shell-passes";
  parameter Integer layout=1 "Tube layout";
  parameter Integer N_t=1 "Number of tubes";
  parameter SI.Length L=1 "Tube length";
  parameter Real tol=0.1 "Heat transfer coefficient tollerance";
  parameter Integer max_iter=1000 "counter";
  parameter SI.HeatFlowRate Q_rec_out;
  
  Modelica.Blocks.Interfaces.RealInput T_input_rec 
    annotation(
    Placement(visible = true, transformation(extent = {{-140, 40}, {-100, 80}}, rotation = 0), iconTransformation(extent = {{-140, 40}, {-100, 80}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.BooleanInput sf_on 
    annotation(
    Placement(visible = true, transformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0), iconTransformation(extent = {{-132, 72}, {-92, 112}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput T_output_cs
    annotation (
    Placement(visible = true, transformation(extent = {{-140, -80}, {-100, -40}}, rotation = 0), iconTransformation(extent = {{-140, -80}, {-100, -40}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealInput T_out_rec_ref 
    annotation(
    Placement(visible = true, transformation(extent = {{-140, 0}, {-100, 40}}, rotation = 0), iconTransformation(extent = {{-140, 0}, {-100, 40}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealInput T_input_hs
    annotation (
    Placement(visible = true, transformation(extent = {{-140, -40}, {-100, 0}}, rotation = 0), iconTransformation(extent = {{-140, -40}, {-100, 0}}, rotation = 0)));
    
  
  Modelica.Blocks.Interfaces.RealInput Q_out_rec(start=Q_rec_out, nominal=Q_rec_out)
    annotation (
    Placement(visible = true, transformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_rec
    annotation (
    Placement(visible = true, transformation(extent = {{100, -68}, {136, -32}}, rotation = 0), iconTransformation(extent = {{100, -68}, {136, -32}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealOutput m_flow_hs
    annotation (
    Placement(visible = true, transformation(extent = {{100, 30}, {136, 66}}, rotation = 0), iconTransformation(extent = {{100, 30}, {136, 66}}, rotation = 0)));
  
  Medium1.ThermodynamicState state_Na1;
  Medium1.ThermodynamicState state_Na2;
  Medium2.ThermodynamicState state_CS1;
  Medium2.ThermodynamicState state_CS2;
  SI.SpecificEnthalpy h_Na1;
  SI.SpecificEnthalpy h_Na2;
  SI.SpecificEnthalpy h_CS1;
  SI.SpecificEnthalpy h_CS2;
  SI.MassFlowRate m_flow_rec_internal;
  SI.MassFlowRate m_flow_hs_internal;

equation
  state_Na1= Medium1.setState_pTX(Medium1.p_default, T_out_rec_ref);
  state_Na2= Medium1.setState_pTX(Medium1.p_default, T_input_rec);
  state_CS1= Medium2.setState_pTX(Medium2.p_default, T_output_cs);
  state_CS2= Medium2.setState_pTX(Medium2.p_default, T_input_hs);
  h_Na1= Medium1.specificEnthalpy(state_Na1);
  h_Na2= Medium1.specificEnthalpy(state_Na2);
  h_CS1= Medium2.specificEnthalpy(state_CS1);
  h_CS2= Medium2.specificEnthalpy(state_CS2);
  
  if sf_on then
    m_flow_rec_internal=Q_out_rec/(h_Na1-h_Na2);
    m_flow_hs_internal=Q_out_rec/(h_CS2-h_CS1);
  else
    m_flow_rec_internal=0;
    m_flow_hs_internal=0;
  end if;
  
  m_flow_rec=m_flow_rec_internal;
  m_flow_hs=m_flow_hs_internal;
  
end m_flow_calculations_simple;