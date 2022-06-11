model TestLoadPredictExistingSurrogate

	/*                                               DEFINITION                                                                         */
	//                        A simple modelica model to load and predict existing ANN and Kriging........................................

	import SolarTherm.Utilities.Kriging_OnTheFly.*;
	import SolarTherm.Utilities.ANN_OnTheFly.*;

	//******************************** Parameters -- for initalisation of the OTF object
	parameter Real P_gross = 100000000/0.9; 
	parameter Real T_in_ref_blk = 1073.15;
	parameter Real p_high = 25000000.0;
	parameter Real PR = 2.57;
	parameter Real pinch_PHX = 15.0;
	parameter Real dTemp_HTF_PHX = 250.0;
	parameter Real load_base = 1.0;
	parameter Real eta_gross_base = 0.5;
	parameter Real eta_Q_base = 1.0;
	parameter String SolarTherm_path = Modelica.Utilities.Files.loadResource(
                                                        "modelica://SolarTherm");

	parameter String base_path = Modelica.Utilities.Files.loadResource(
                                                        "modelica://SolarTherm/Data/SurrogateModels/PowerBlock");

	parameter Integer inputsize = 3;
	parameter Integer outputsize = 2;
	parameter Real tolerance = 0.006;
	parameter Integer which_PB_model = 1 /*SSC sCO2 PB*/;
	parameter Integer htf_choice = 50;
	parameter Real dT_PHX_hot_approach = 93.831340;
	parameter Real dT_PHX_cold_approach = 15.0;
	parameter Real eta_isen_mc = 0.89;
	parameter Real eta_isen_rc = 0.89;
	parameter Real eta_isen_t = 0.93;
	parameter Real dT_mc_approach = 6.0;
	parameter Real T_amb_base = 41.0 + 273.15 - dT_mc_approach;
	parameter String HTF_name = "CarboHSP";


  
	//********************************** On design efficiency values
	parameter Integer inputsize = 3;
	parameter Integer outputsize = 2;
	parameter Real tolerance_kriging = 2.5e-3;
	parameter Real tolerance_ANN= 1.5e-3;

	//******************** Kriging
	Kriging_properties Kriging_variables = Kriging_properties(
		                                 P_gross, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base,
		                                 eta_gross_base,  eta_Q_base, base_path,
		                                 SolarTherm_path, inputsize, outputsize, tolerance_kriging, which_PB_model,
		                                 htf_choice,dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc, eta_isen_rc, 
		                                 eta_isen_t, dT_mc_approach, HTF_name);
	//******************** ANN PB
	parameter Integer index_0 = 0;
	ANN_properties session_PB = ANN_properties(
		                                 P_gross, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base,
		                                 eta_gross_base, eta_Q_base, 
		                                 index_0, base_path, SolarTherm_path, inputsize, outputsize, tolerance_ANN, 
		                                 which_PB_model, htf_choice,dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc,
		                                 eta_isen_rc, eta_isen_t, dT_mc_approach, HTF_name);

	//******************** ANN HX
	parameter Integer index_1 = 1;
	ANN_properties session_HX = ANN_properties(
		                                 P_gross, T_in_ref_blk, p_high, PR, pinch_PHX, dTemp_HTF_PHX, load_base, T_amb_base,
		                                 eta_gross_base, eta_Q_base,
		                                 index_1, base_path, SolarTherm_path, inputsize, outputsize, tolerance_ANN, 
		                                 which_PB_model, htf_choice, dT_PHX_hot_approach, dT_PHX_cold_approach, eta_isen_mc,
		                                 eta_isen_rc, eta_isen_t, dT_mc_approach, HTF_name);

	parameter Real [inputsize] raw_input = {1.0, 1073.15, 20 +273.15};

	//Results
	Real deviation_eta_gross_Kriging; 
	Real deviation_eta_Q_Kriging;
	Real deviation_eta_gross_ANN; 
	Real deviation_eta_Q_ANN;

  equation
	deviation_eta_gross_Kriging = OTF_Kriging_interpolate(Kriging_variables, raw_input, "eta_gross", "spherical"); 
	deviation_eta_Q_Kriging = OTF_Kriging_interpolate(Kriging_variables, raw_input, "eta_Q", "spherical");

	deviation_eta_gross_ANN = OTF_ANN_predict(session_PB, raw_input, 0);
	deviation_eta_Q_ANN = OTF_ANN_predict(session_HX, raw_input, 1);

  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"),
    Diagram);

end TestLoadPredictExistingSurrogate;
