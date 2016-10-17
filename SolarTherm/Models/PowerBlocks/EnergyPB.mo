within SolarTherm.Models.PowerBlocks;
model EnergyPB "Generator with fixed efficiency"
 extends SolarTherm.Models.PowerBlocks.PowerBlock;
 import SI = Modelica.SIunits;
 parameter SI.Efficiency eff = 1.0 "Efficiency of generator";
 parameter SI.Power P_max "Generator maximum electrical power";
  SolarTherm.Models.Fluid.Interfaces.EnergyPort p;
equation
 P = eff*p.P;
end EnergyPB;
