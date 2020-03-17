within SolarTherm.Models.Control;
model m_flow_calculation
  import SI = Modelica.SIunits;
  import CN = Modelica.Constants;
  import MA = Modelica.Math;
  replaceable package Medium1 = Media.Sodium.Sodium_pT "Medium props for Sodium";
  replaceable package Medium2 = Media.ChlorideSalt.ChlorideSalt_pT "Medium props for Molten Salt";

  parameter SI.MassFlowRate m_flow_max_CS=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_CS=0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_min_CS_safe=0.1*m_flow_start_CS "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_start_CS=0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_max_Na=1400 "Maximum mass flow rate";
  parameter SI.MassFlowRate m_flow_min_Na=0 "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_min_Na_safe=0.1*m_flow_start_Na "Mass flow rate when control off";
  parameter SI.MassFlowRate m_flow_start_Na=0 "Mass flow rate when control off";
  parameter SI.HeatFlowRate Q_flow_rec=0;
  
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

  Modelica.Blocks.Interfaces.RealInput Q_out_rec(start=Q_flow_rec, nominal=Q_flow_rec)
    annotation (
    Placement(visible = true, transformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_rec
    annotation (
    Placement(visible = true, transformation(extent = {{100, -68}, {136, -32}}, rotation = 0), iconTransformation(extent = {{100, -68}, {136, -32}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealOutput m_flow_hs(start=m_flow_start_CS,nominal=m_flow_start_CS)
    annotation (
    Placement(visible = true, transformation(extent = {{100, 30}, {136, 66}}, rotation = 0), iconTransformation(extent = {{100, 30}, {136, 66}}, rotation = 0)));
  
  Medium1.ThermodynamicState state_Na1= Medium1.setState_pTX(Medium1.p_default, T_out_rec_ref);
  Medium1.ThermodynamicState state_Na2= Medium1.setState_pTX(Medium1.p_default, T_input_rec);
  Medium2.ThermodynamicState state_CS1= Medium2.setState_pTX(Medium2.p_default, T_output_cs);
  Medium2.ThermodynamicState state_CS2= Medium2.setState_pTX(Medium2.p_default, T_input_hs);
  SI.SpecificEnthalpy h_Na1= Medium1.specificEnthalpy(state_Na1);
  SI.SpecificEnthalpy h_Na2= Medium1.specificEnthalpy(state_Na2);
  SI.SpecificEnthalpy h_CS1= Medium2.specificEnthalpy(state_CS1);
  SI.SpecificEnthalpy h_CS2= Medium2.specificEnthalpy(state_CS2);
  SI.MassFlowRate m_flow_rec_internal(start=m_flow_start_Na);
  SI.MassFlowRate m_flow_rec_internal_lim_min(start=m_flow_start_Na);
  SI.MassFlowRate m_flow_hs_internal(start=m_flow_start_CS, nominal=m_flow_start_CS);
  SI.MassFlowRate m_flow_hs_internal_lim_min(start=m_flow_start_CS, nominal=m_flow_start_CS);

equation

  if sf_on then
    if noEvent((h_Na1-h_Na2)<0) then
      m_flow_rec_internal=m_flow_min_Na_safe;
      m_flow_hs_internal=m_flow_min_CS_safe;
    else
      m_flow_rec_internal=Q_out_rec/(h_Na1-h_Na2);
      m_flow_hs_internal=Q_out_rec/(h_CS2-h_CS1);
    end if;    
  else
    m_flow_rec_internal=0;
    m_flow_hs_internal=0;
  end if;
  
  m_flow_rec_internal_lim_min=max(m_flow_min_Na, m_flow_rec_internal);
  m_flow_hs_internal_lim_min=max(m_flow_min_CS, m_flow_hs_internal);
  m_flow_rec=min(m_flow_max_Na, m_flow_rec_internal_lim_min);
  m_flow_hs=min(m_flow_max_CS, m_flow_hs_internal_lim_min);

end m_flow_calculation;
