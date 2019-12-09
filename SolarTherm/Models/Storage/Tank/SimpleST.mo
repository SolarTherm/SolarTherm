within SolarTherm.Models.Storage.Tank;
model SimpleST "A simple energy model for a storage tank"
	import SI = Modelica.SIunits;
	parameter SI.Energy E_max = 1000 "Maximum energy";
	parameter SI.Energy E_0 = 0 "Starting energy";

	input SI.EnergyFlowRate E_flow_in "Energy flow entering tank";
	input SI.EnergyFlowRate E_flow_set "Target output Energy flow";
	output SI.EnergyFlowRate E_flow_out "Energy flow leaving tank";
	SI.Energy E(start=E_0, fixed=true, min=0, max=E_max) "Energy in tank";

equation
	der(E) = E_flow_in - E_flow_out;
	E_flow_out = E_flow_set;
end SimpleST;
