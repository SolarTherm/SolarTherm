within SolarTherm.Storage;
model TankGeneric "Generic energy tank"
	import SI = Modelica.SIunits;
	parameter SI.Energy E_max = 1000 "Maximum energy";
	parameter SI.Energy E_0 = 0 "Starting energy";
	parameter SI.HeatFlowRate Q_flow_max "Maximum energy out to power block";

	input Real fac_in "Input factor";
	input Real fac_out "Output factor";
	input SI.HeatFlowRate Q_flow_in "Heat flow entering tank";
	output SI.HeatFlowRate Q_flow_out "Heat flow leaving tank";
	SI.Energy E(start=E_0, fixed=true, min=0, max=E_max) "Energy in tank";
initial equation
equation
	der(E) = fac_in*Q_flow_in - Q_flow_out;
	Q_flow_out = fac_out*Q_flow_max;
end TankGeneric;
