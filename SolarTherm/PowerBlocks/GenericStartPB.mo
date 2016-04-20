within SolarTherm.PowerBlocks;
model GenericStartPB "Generic power block model"
 extends SolarTherm.PowerBlocks.PowerBlock;
 import SI = Modelica.SIunits;

 parameter SI.Efficiency eff_des = 0.5 "Power cycle efficiency at design";
 parameter SI.HeatFlowRate Q_flow_des
    "Heat of power block at design (max value)";
 parameter SI.Temperature T_amb_des "Ambient temperature at design";

 parameter Real cf[:] "Fraction operation factor coefficients";
 parameter Real ca[:] "Ambient temperature factor coefficients";

 parameter SI.HeatFlowRate Q_flow_disp(min=0) = 0 "Min input for dispatch";
 parameter SI.HeatFlowRate Q_flow_heat(min=0) = 0 "Max input for heating";
 parameter SI.Time t_heat(min=0) = 0 "Time to heat when at max input";
 parameter SI.Time t_cool(min=0) = 3600 "Time for system to cool";

 parameter Boolean startup_energy = t_heat > 0;
 parameter SI.HeatFlowRate Q_flow_cool = Q_flow_heat*t_heat/(t_heat + t_cool);
 parameter SI.Energy E_on = Q_flow_cool*t_cool;

 input SI.HeatFlowRate Q_flow "Heat flow entering power block";
 input SolarTherm.Interfaces.WeatherBus wbus;

 SI.HeatFlowRate Q_flow_cyc "Heat flow to power cycle";

 SI.HeatFlowRate Q_flow_heat_net if startup_energy "Net heating power";
 SI.Energy E_heat if startup_energy "Energy used to start";
 Boolean on if startup_energy;
 Boolean heated if startup_energy;
protected
 SolarTherm.Utilities.Polynomial.Poly fac_fra(c=cf);
 SolarTherm.Utilities.Polynomial.Poly fac_amb(c=ca);
initial equation
 if startup_energy then
  assert(Q_flow_disp > 0, "Heating power should be strictly positive");
  E_heat = 0;
 end if;
equation
 if startup_energy then
  Q_flow_heat_net = min(Q_flow_cyc, Q_flow_heat) - Q_flow_cool;
  heated = E_heat >= E_on;
  on = heated and Q_flow_cyc >= Q_flow_disp;

  if (E_heat > E_on and Q_flow_heat_net >= 0)
    or (E_heat < 0 and Q_flow_heat_net <= 0) then
   der(E_heat) = 0;
  else
   der(E_heat) = Q_flow_heat_net;
  end if;
  if on then
   P = Q_flow_cyc*eff_des*fac_fra.y*fac_amb.y;
  else
   P = 0;
  end if;
 else
  P = Q_flow_cyc*eff_des*fac_fra.y*fac_amb.y;
 end if;

 Q_flow_cyc = min(Q_flow, Q_flow_des); // Discard heat above design
 fac_fra.x = Q_flow_cyc/Q_flow_des;
 fac_amb.x = wbus.Tdry - T_amb_des;
end GenericStartPB;
