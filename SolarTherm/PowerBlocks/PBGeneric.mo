within SolarTherm.PowerBlocks;
model PBGeneric "Generic power block model"
	import SI = Modelica.SIunits;

	parameter SI.Efficiency eff = 0.5 "Power cycle efficiency";

	input SI.HeatFlowRate Q_flow "Heat flow entering power block";
	SI.Power P_out "Electrical output power";
equation
	P_out = eff*Q_flow;
end PBGeneric;
