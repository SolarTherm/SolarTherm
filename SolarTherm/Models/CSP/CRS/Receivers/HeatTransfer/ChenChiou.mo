within SolarTherm.Models.CSP.CRS.Receivers.HeatTransfer;
model ChenChiou
	extends PartialHeatTransfer;

	Medium.Density rho "Density";
	Medium.DynamicViscosity mu "Dynamic viscosity";
	Medium.ThermalConductivity lambda "Thermal conductivity";
	SI.SpecificHeatCapacity Cp "Specific heat capacity";

	Real Re "Reynolds number";
	Real Pr "Prandtl number";
	Real Pec "Peclet number";

equation
	rho = Medium.density(state);
	mu = Medium.dynamicViscosity(state);
	lambda = Medium.thermalConductivity(state);
	Cp = Medium.specificHeatCapacityCp(state);
	Re = max(0,v * rho * D / mu);
	Pr = max(0,mu * Cp / lambda);
	Pec =Re*Pr;
	Nu=5.6 + 0.0165 * Pec ^ 0.85 * Pr ^ 0.01;

end ChenChiou;
