within SolarTherm.Media;
package ConstSodium "Sodium model with constant properties"
	constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1] const_sodium(
		each chemicalFormula="Na",
		each structureFormula="Na",
		each casRegistryNumber="",
		each iupacName="sodium",
		each molarMass=0.02298977
		);
	extends Modelica.Media.Interfaces.PartialSimpleMedium(
		mediumName="Sodium",
		cp_const=1277, // 700K
		cv_const=1045, // 700K
		d_const=852, // 700K
		eta_const=2.64e-4, // 700K
		lambda_const=68.00, // 700K
		a_const=2353, // 700K
		T_min=370.9,
		//T_min=100,
		T_max=1154.7,
		T0=700,
		MM_const=0.02298977,
		fluidConstants=const_sodium
		);
end ConstSodium;
