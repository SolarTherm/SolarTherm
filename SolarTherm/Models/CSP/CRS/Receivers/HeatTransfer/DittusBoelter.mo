within SolarTherm.Models.CSP.CRS.Receivers.HeatTransfer;
model DittusBoelter
	extends PartialHeatTransfer;

	Medium.Density rho "Density";
	Medium.DynamicViscosity mu "Dynamic viscosity";
	Medium.ThermalConductivity lambda "Thermal conductivity";
	SI.SpecificHeatCapacity Cp "Specific heat capacity";

	Real Re "Reynolds number";
	Real Pr "Prandtl number";

equation
	rho = Medium.density(state);
	mu = Medium.dynamicViscosity(state);
	lambda = Medium.thermalConductivity(state);
	Cp = Medium.specificHeatCapacityCp(state);
	Re = max(0,v * rho * D / mu);
	Pr = max(0,mu * Cp / lambda);
	Nu=0.023*Re^(0.8)*Pr^(0.4);

	annotation (Documentation(info="<html>
		<p>The Dittus-Boelter equation is valid for:</p>
		<dl><dt>0.6 &le; Pr &le; 160</dt>
		<dl><dt>Re ? 10 000</dt>
		<dl><dt>L ? 10</dt>
		</dl></html>"));
end DittusBoelter;
