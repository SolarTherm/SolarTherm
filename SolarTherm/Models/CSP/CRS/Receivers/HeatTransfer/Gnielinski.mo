within SolarTherm.Models.CSP.CRS.Receivers.HeatTransfer;
model Gnielinski
	extends PartialHeatTransfer;

	Medium.Density rho "Density";
	Medium.DynamicViscosity mu "Dynamic viscosity";
	Medium.ThermalConductivity lambda "Thermal conductivity";
	SI.SpecificHeatCapacity Cp "Specific heat capacity";

	Real Re "Reynolds number";
	Real Pr "Prandtl number";
	Real eps;

equation
	rho = Medium.density(state);
	mu = Medium.dynamicViscosity(state);
	lambda = Medium.thermalConductivity(state);
	Cp = Medium.specificHeatCapacityCp(state);
	Re = max(10,v * rho * D / mu);
	Pr = max(0,mu * Cp / lambda);
	Nu=(((eps/8)*Re*Pr)/(1+12.7*sqrt(eps/8)*(Pr^(2/3)-1)))*(1+(D/L)^(2/3));
	eps=1.8*log10(Re-1.5)^(-2);
end Gnielinski;
