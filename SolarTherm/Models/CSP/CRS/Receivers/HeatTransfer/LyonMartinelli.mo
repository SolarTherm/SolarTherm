within SolarTherm.Models.CSP.CRS.Receivers.HeatTransfer;
model LyonMartinelli
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
	Nu=7.0+0.025 *(Re*Pr);

end LyonMartinelli;
