within SolarTherm.Models.PowerBlocks.sCO2Cycle.OffDesign;
	model test
		extends SolarTherm.Media.CO2.PropCO2;
		replaceable package MedRec=SolarTherm.Media.SolidParticles.CarboHSP_ph;
		MedRec.ThermodynamicState trial;
		Real bis;
	equation
		trial=MedRec.setState_pTX(10^5,800+273.15);
		bis=MedRec.specificHeatCapacityCp(trial);
	end test;
