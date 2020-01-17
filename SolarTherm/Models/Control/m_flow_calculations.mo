within SolarTherm.Models.Control;
model m_flow_calculations
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
    
  
  Modelica.Blocks.Interfaces.RealInput Q_out_rec(start=Q_rec_out)
    annotation (
    Placement(visible = true, transformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110},extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  
  Modelica.Blocks.Interfaces.RealOutput m_flow_rec
    annotation (
    Placement(visible = true, transformation(extent = {{100, -68}, {136, -32}}, rotation = 0), iconTransformation(extent = {{100, -68}, {136, -32}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.RealOutput m_flow_hs
    annotation (
    Placement(visible = true, transformation(extent = {{100, 30}, {136, 66}}, rotation = 0), iconTransformation(extent = {{100, 30}, {136, 66}}, rotation = 0)));
  
  Medium1.ThermodynamicState state_mean_Na;
  Medium1.ThermodynamicState state_Na1;
  Medium1.ThermodynamicState state_Na2;
  Medium2.ThermodynamicState state_wall_CS;
  Medium2.ThermodynamicState state_mean_CS;
  Medium2.ThermodynamicState state_CS1;
  Medium2.ThermodynamicState state_CS2;
  
  SI.SpecificEnthalpy h_Na1;
  SI.SpecificEnthalpy h_Na2;
  SI.SpecificEnthalpy h_CS1;
  SI.SpecificEnthalpy h_CS2;
  SI.CoefficientOfHeatTransfer U "Heat tranfer coefficient";  
  SI.HeatFlowRate Q_calc "Design Heat Flow Rate";
  SI.TemperatureDifference DT1 "Sodium-Molten Salt temperature difference 1";
  SI.TemperatureDifference DT2 "Sodium-Molten Salt temperature difference 2";
  SI.TemperatureDifference LMTD "Logarithmic mean temperature difference";
  SI.Area A "Optimal Exchange Area";
  Real err "When condition";
  Real err2 "When condition";
  Integer iter "counter";
  SI.MassFlowRate m_flow_rec_internal;
  SI.MassFlowRate m_flow_hs_internal;
  SI.Temperature Tm_CS;
  SI.Temperature Tm_Na;
  SI.Temperature T_CS2_calc;

algorithm
  Tm_Na:=(T_input_rec+T_out_rec_ref)/2;
  Tm_CS:=(T_output_cs+T_input_hs)/2;
  state_Na1:= Medium1.setState_pTX(Medium1.p_default, T_out_rec_ref);
  state_Na2:= Medium1.setState_pTX(Medium1.p_default, T_input_rec);
  state_mean_Na:= Medium1.setState_pTX(Medium1.p_default, Tm_Na);
  state_CS1:= Medium2.setState_pTX(Medium2.p_default, T_output_cs);
  state_CS2:= Medium2.setState_pTX(Medium2.p_default, T_input_hs);
  state_mean_CS:= Medium2.setState_pTX(Medium2.p_default, Tm_CS);
  state_wall_CS:= Medium2.setState_pTX(Medium2.p_default, Tm_Na);
  h_Na1:= Medium1.specificEnthalpy(state_Na1);
  h_Na2:= Medium1.specificEnthalpy(state_Na2);
  h_CS1:= Medium2.specificEnthalpy(state_CS1);
  h_CS2:= Medium2.specificEnthalpy(state_CS2);
  
  if sf_on then
  m_flow_rec_internal:=Q_out_rec/max((h_Na1-h_Na2),1e-3);
  A:=CN.pi*d_o*L*N_t;
  DT1:= T_out_rec_ref - T_input_hs;
  DT2:= T_input_rec - T_output_cs;
  LMTD:= if noEvent(DT1 / DT2 <= 0 or abs(DT1 - DT2)<1e-3) then 0 else (DT1 - DT2) / MA.log(DT1 / DT2);
  
  Q_calc:=Q_out_rec;
  err:=10;
  iter:=1;
  
  while noEvent(err>tol and iter<max_iter) loop
    m_flow_hs_internal:=Q_calc/max((h_CS2-h_CS1),1e-3);
    U:=SolarTherm.Models.Fluid.HeatExchangers.HTCs(d_o=d_o, N_p=N_p, N_sp=N_sp, layout=layout, N_t=N_t, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_CS, state_wall_MS=state_wall_CS, m_flow_Na=m_flow_rec_internal, m_flow_MS=m_flow_hs_internal, L=L);
    Q_calc:=U*A*LMTD;
    err:= abs(Q_calc-Q_out_rec)/max(Q_out_rec,1e-3);
    iter:=iter+1;
  end while;
  
  if noEvent(err>tol) then
    err2:=0;
    iter:=1;
    while noEvent((err>tol or err2>tol) and iter<max_iter) loop
      h_CS2:=h_CS1+Q_calc/max(m_flow_hs_internal,1e-3);
      state_CS2:= Medium2.setState_phX(Medium2.p_default, h_CS2);
      T_CS2_calc:=Medium2.temperature(state_CS2);
      U:=SolarTherm.Models.Fluid.HeatExchangers.HTCs(d_o=d_o, N_p=N_p, N_sp=N_sp, layout=layout, N_t=N_t, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_CS, state_wall_MS=state_wall_CS, m_flow_Na=m_flow_rec_internal, m_flow_MS=m_flow_hs_internal, L=L);
      DT1:= T_out_rec_ref - T_CS2_calc;
      DT2:= T_input_rec - T_output_cs;
      LMTD:= if noEvent(DT1 / DT2 <= 0 or abs(DT1 - DT2)<1e-3) then 0 else (DT1 - DT2) / MA.log(DT1 / DT2);
      Q_calc:=U*A*LMTD;
      err:= abs(Q_calc-Q_out_rec)/max(Q_out_rec,1e-3);
      err2:=abs(T_CS2_calc-T_input_hs)/T_input_hs;
      if noEvent(err2>tol) then
          m_flow_hs_internal:=Q_calc/max((h_CS2-h_CS1),1e-3);
          U:=SolarTherm.Models.Fluid.HeatExchangers.HTCs(d_o=d_o, N_p=N_p, N_sp=N_sp, layout=layout, N_t=N_t, state_mean_Na=state_mean_Na, state_mean_MS=state_mean_CS, state_wall_MS=state_wall_CS, m_flow_Na=m_flow_rec_internal, m_flow_MS=m_flow_hs_internal, L=L);
          Q_calc:=U*A*LMTD;
          err:= abs(Q_calc-Q_out_rec)/max(Q_out_rec,1e-3);
      end if;
      iter:=iter+1;
    end while;
  end if;
  
  m_flow_rec:=m_flow_rec_internal;
  m_flow_hs:=m_flow_hs_internal;
  else
  m_flow_rec:=0;
  m_flow_hs:=0;
  end if;
  
  
end m_flow_calculations;