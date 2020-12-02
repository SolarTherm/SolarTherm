within SolarTherm.Models.CSP.CRS.Receivers;
model ParticleReceiver_3Apertures
	extends Interfaces.Models.ReceiverFluid;
	
	import Modelica.SIunits.Conversions.*;
	import SolarTherm.Utilities.*;
	
	import SolarTherm.Utilities.SurrogateModelsSingleOutput.*;
    import ln = Modelica.Math.log;

	parameter SI.Length H_drop_design = 2 "Receiver drop height" annotation(Dialog(group="Technical data"));
	parameter SI.Length W_rcv = 2 "Receiver width" annotation(Dialog(group="Technical data"));
	parameter SI.Length L_rcv = 1 "Receiver length(depth)" annotation(Dialog(group="Technical data"));

	parameter SI.Area A = H_drop_design * W_rcv "Receiver aperture area" annotation(Dialog(group="Technical data"));

	parameter SI.Length th_c_in = 1 "Curtain thicknesss at the inlet" annotation(Dialog(group="Technical data"));

	parameter SI.Efficiency em "Emissivity" annotation(Dialog(group="Technical data"));
	parameter SI.Efficiency ab "Absorptivity" annotation(Dialog(group="Technical data"));

	parameter Boolean const_alpha = true "If true then constant convective heat transfer coefficient";
	parameter SI.CoefficientOfHeatTransfer alpha=1 if const_alpha "Convective heat transfer coefficient";
	
	parameter Boolean use_neural_network = true;
	parameter Integer inputsize = 5;
	parameter Integer outputsize = 1;
    parameter String saved_model_dir = "/home/philgun/Documents/codecodecode/codecodecode/ML/script/robust_rcv/surrogate_model_3";
    parameter Real[inputsize] X_max = {5.04906372e+01, 1.47403013e+03, 3.14955603e+02, 1.36460943e+03, 9.99896884e+08};
    parameter Real[inputsize] X_min = {4.51463536e+00, 1.02218597e+03, 2.53080041e+02, 7.52944510e+02, 2.45868147e+07};
    parameter Real out_max = 0.964303;
    parameter Real out_min = 0.427611;
    parameter SI.MassFlowRate m_flow_rec_max = 2000;
	
	parameter SI.Temperature T_0=from_degC(550) "Start value of temperature";
	parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
	parameter SI.SpecificEnthalpy h_0=SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(T_0);
	parameter SI.Temperature T_out = from_degC(800) "Temperature at outlet";
	parameter Real level_off_ub = 10;
	parameter Real level_off_lb=5;
	
	parameter SI.Length Z_rcv_lv1 = 200 "Top receiver height [m] if any";
	parameter SI.Length Z_rcv_lv2 = 200 "Mid receiver height [m] if any";
	parameter SI.Length Z_rcv_lv3 = 200 "Bottom receiver height [m] if any";
	
	parameter Real z0 = 1e-3 "Surface roughness of desert According to https://is.gd/m7EaZT";
	
	parameter Real Wspd_scaler_lv1 = (ln(Z_rcv_lv1/z0))/(ln(2/z0));
	parameter Real Wspd_scaler_lv2 = (ln(Z_rcv_lv2/z0))/(ln(2/z0));
	parameter Real Wspd_scaler_lv3 = (ln(Z_rcv_lv3/z0))/(ln(2/z0));
	
	Boolean logic(start=true);

	Medium.BaseProperties medium;

	SI.SpecificEnthalpy h_in "Specific enthalpy at inlet";
	SI.SpecificEnthalpy h_out(start=h_0) "Specific enthalpy at outlet";

	Modelica.SIunits.ThermodynamicTemperature T_in=Medium.temperature(state_in) "Temperature at inlet";
    
    /*Initialise variables for each receiver aperture*/
    SI.HeatFlowRate Q_in_1;
	SI.HeatFlowRate Q_loss_1 "Total losses";
	SI.HeatFlowRate Q_rcv_1 "Heat flow captured by curtain";
	SI.Efficiency eta_rcv_1;
	SI.Efficiency eta_rcv_dummy_1;
	Real ratio_1;
	SI.MassFlowRate mdot_1;
	
	SI.HeatFlowRate Q_in_2;
	SI.HeatFlowRate Q_loss_2 "Total losses";
	SI.HeatFlowRate Q_rcv_2 "Heat flow captured by curtain";
	SI.Efficiency eta_rcv_2;
	SI.Efficiency eta_rcv_dummy_2;
	Real ratio_2;
	SI.MassFlowRate mdot_2;
	
	SI.HeatFlowRate Q_in_3;
	SI.HeatFlowRate Q_loss_3 "Total losses";
	SI.HeatFlowRate Q_rcv_3 "Heat flow captured by curtain";
	SI.Efficiency eta_rcv_3;
	SI.Efficiency eta_rcv_dummy_3;
	Real ratio_3;
	SI.MassFlowRate mdot_3;
	
	SI.Velocity Wspd_lv1;
	SI.Velocity Wspd_lv2;
	SI.Velocity Wspd_lv3;

	Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
		visible = true,transformation(
		
		origin={0, 88},extent={{-12,-12},{12,12}},
		rotation=-90), iconTransformation(
		
		origin={24, 80},extent={{-6,-6},{6,6}},
		rotation=-90)));

	Modelica.Blocks.Interfaces.BooleanInput on_1 annotation (Placement(
		transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
		-24,-98},{-12,-86}})));
    
    Modelica.Blocks.Interfaces.BooleanInput on_2 annotation(
    Placement(visible = true, transformation(extent = {{-38, -64}, {2, -24}}, rotation = 0), iconTransformation(extent = {{-24, -68}, {-12, -56}}, rotation = 0)));
    
    Modelica.Blocks.Interfaces.BooleanInput on_3 annotation(
    Placement(visible = true, transformation(extent = {{-38, -34}, {2, 6}}, rotation = 0), iconTransformation(extent = {{-24, -84}, {-12, -72}}, rotation = 0)));
    	
	Real const_coeff;
	Real Qin_coeff;
	Real Tamb_coeff;
	Real T_in_coeff;
	Real log10Qin_coeff;
	Real log10Tin_coeff;
	Real log10Tamb_coeff;
	
	/*Input for each aperture*/
	Real raw_input_1[inputsize];
	Real raw_input_2[inputsize];
	Real raw_input_3[inputsize];
	
	/*Initialise the ANN session for each aperture*/
    STNeuralNetwork session_1 = STNeuralNetwork(saved_model_dir) if use_neural_network == true
    "Initialise neural network session if use_neural_network == true";
    STNeuralNetwork session_2 = STNeuralNetwork(saved_model_dir) if use_neural_network == true
    "Initialise neural network session if use_neural_network == true";
    STNeuralNetwork session_3 = STNeuralNetwork(saved_model_dir) if use_neural_network == true
    "Initialise neural network session if use_neural_network == true";
	
	Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,h_in);
	Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_b.p,h_out);
    Modelica.Blocks.Interfaces.RealInput Wdir annotation(
        Placement(visible = true, transformation(origin = {-38, 88}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-24, 80}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealInput Wspd annotation(
        Placement(visible = true, transformation(origin = {38, 88}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {2.22045e-16, 80}, extent = {{-6, -6}, {6, 6}}, rotation = -90)));
    Modelica.Blocks.Interfaces.RealOutput m_flow_out annotation(
    Placement(visible = true, transformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Interfaces.RealInput level annotation(
    Placement(visible = true, transformation(origin = {36, -36}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {36, -36}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
 
equation
	Wspd_lv1 = Wspd_scaler_lv1 * Wspd;
	Wspd_lv2 = Wspd_scaler_lv2 * Wspd;
	Wspd_lv3 = Wspd_scaler_lv3 * Wspd;
	
	medium.h=(h_in+h_out)/2; // temperature for thermal losses = average of inlet and outlet pcl temperatures
	h_in=inStream(fluid_a.h_outflow);
	fluid_b.h_outflow=max(h_0,h_out);
	fluid_a.h_outflow=0;
	
	h_out = SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(T_out);

	heat.T=medium.T;
	fluid_b.m_flow=-fluid_a.m_flow; // mass conservation
	fluid_a.p=medium.p; // no pressure drops (it should all be ambient pressure)
	fluid_b.p=medium.p;
    
    // Coefficient of regression as a function of H_drop_design
    //https://arachnoid.com/polysolve/ ~> good online regression tool that can copy paste!
    const_coeff =  2.0670321487297178e+002 * H_drop_design^0
      -3.7589011531648175e+001 * H_drop_design^1
     +  2.5401852483174929e+000 * H_drop_design^2
      -7.2926201120112652e-002 * H_drop_design^3
     +  7.0156772828302248e-004 * H_drop_design^4
      -8.2778014112627156e-006 * H_drop_design^5
     +  3.9474975799394878e-007 * H_drop_design^6
     +  1.0395429397054944e-008 * H_drop_design^7
      -3.4911374420337237e-010 * H_drop_design^8
      -6.9159250092917056e-012 * H_drop_design^9
      -7.2308972728387389e-014 * H_drop_design^10
     +  7.8497675914587239e-015 * H_drop_design^11
     +  4.5092455308182630e-017 * H_drop_design^12
     +  6.7666460046292914e-020 * H_drop_design^13
      -7.9572118607684537e-020 * H_drop_design^14
      -3.1113420865780432e-022 * H_drop_design^15
      -5.7156975884210857e-024 * H_drop_design^16
     +  8.6551130701591358e-025 * H_drop_design^17
     +  1.5908840447186100e-027 * H_drop_design^18
      -3.9577226622651846e-029 * H_drop_design^19
      -7.0800820578365189e-030 * H_drop_design^20
     +  1.0061641001599101e-031 * H_drop_design^21
      -2.4459710795169099e-034 * H_drop_design^22;
                                   
    Qin_coeff = 4.8355222337164881e-004 * H_drop_design^0
      -5.2692081035808641e-005 * H_drop_design^1
     +  1.1454047510165739e-007 * H_drop_design^2
     +  5.2358228816192376e-008 * H_drop_design^3
     +  2.5338536208081132e-009 * H_drop_design^4
      -1.1066407516572144e-010 * H_drop_design^5
      -1.4714561917693080e-012 * H_drop_design^6
      -9.0958054189237395e-016 * H_drop_design^7
     +  4.5530335671456266e-016 * H_drop_design^8
     +  8.6427366720789316e-017 * H_drop_design^9
      -2.6995073278877324e-019 * H_drop_design^10
      -4.0889114241971051e-020 * H_drop_design^11
      -7.3583968110936962e-022 * H_drop_design^12
     +  1.4532699200221540e-023 * H_drop_design^13
     +  1.1168069789461256e-025 * H_drop_design^14
     +  8.6695552425434406e-027 * H_drop_design^15
      -6.2306046732273416e-029 * H_drop_design^16
      -1.0633026383620650e-030 * H_drop_design^17
      -6.5618400825100010e-032 * H_drop_design^18
     +  2.4132125966570870e-034 * H_drop_design^19
      -1.7546219349305755e-035 * H_drop_design^20
     +  1.2978514246596846e-036 * H_drop_design^21
      -1.3691431156570650e-038 * H_drop_design^22;
     
    
    if H_drop_design >=23 and H_drop_design < 44 then        
      Tamb_coeff = -6.0564787669851192e-004 * H_drop_design^0
     +  1.2387673133541983e-004 * H_drop_design^1
      -9.6018507665429403e-006 * H_drop_design^2
     +  3.2461248170974139e-007 * H_drop_design^3
      -1.9575827997476415e-009 * H_drop_design^4
      -1.3243829097455648e-010 * H_drop_design^5
     +  1.8859490235231210e-012 * H_drop_design^6
     +  2.4601987160446375e-015 * H_drop_design^7
     +  3.3751778694692145e-016 * H_drop_design^8
     +  3.5305296657278122e-017 * H_drop_design^9
      -1.1210233457922617e-018 * H_drop_design^10
      -2.2606087652195218e-020 * H_drop_design^11
     +  5.2157269205338420e-022 * H_drop_design^12
     +  6.4601788276815344e-024 * H_drop_design^13
      -7.1218712420629363e-027 * H_drop_design^14
     +  1.5303887156057249e-027 * H_drop_design^15
      -8.3779884446942864e-029 * H_drop_design^16
      -2.1092970546532549e-030 * H_drop_design^17
      -6.9134510953569153e-033 * H_drop_design^18
     +  2.1682390073338590e-033 * H_drop_design^19
     +  4.1550766315427546e-037 * H_drop_design^20
      -7.9794359748047042e-037 * H_drop_design^21
     +  7.0297368151307933e-039 * H_drop_design^22;
    else
      Tamb_coeff = 2.70257218114028e-6 * H_drop_design + 3.50395513025411e-5;
    end if;   
    
    T_in_coeff = 5.4497284056089550e-002 * H_drop_design^0
      -1.0063255540394543e-002 * H_drop_design^1
     +  6.9136958873509480e-004 * H_drop_design^2
      -2.0309945072279083e-005 * H_drop_design^3
     +  2.0405792376180526e-007 * H_drop_design^4
      -2.2708976350585085e-009 * H_drop_design^5
     +  1.1115821833699230e-010 * H_drop_design^6
     +  2.6467314007297094e-012 * H_drop_design^7
      -9.5564489405292125e-014 * H_drop_design^8
      -1.9033345628434729e-015 * H_drop_design^9
      -1.8831020345244929e-017 * H_drop_design^10
     +  2.2185935300847668e-018 * H_drop_design^11
     +  1.1896759099070252e-020 * H_drop_design^12
      -1.3507567530769800e-023 * H_drop_design^13
      -2.1995633169503721e-023 * H_drop_design^14
      -8.9117056782818212e-026 * H_drop_design^15
      -1.1979552400047048e-027 * H_drop_design^16
     +  2.3648001458151023e-028 * H_drop_design^17
     +  5.6003478182306226e-031 * H_drop_design^18
      -1.4613864481389472e-032 * H_drop_design^19
      -1.9202741644142080e-033 * H_drop_design^20
     +  2.6869689899639818e-035 * H_drop_design^21
      -5.4874279637055902e-038 * H_drop_design^22;
          
     log10Qin_coeff =  -1.5036796879434187e+001 * H_drop_design^0
     +  3.1859519830340299e+000 * H_drop_design^1
      -2.8397428738380265e-001 * H_drop_design^2
     +  1.4094900953470912e-002 * H_drop_design^3
      -4.2384805770051895e-004 * H_drop_design^4
     +  7.7883000271129381e-006 * H_drop_design^5
      -8.0728134610782028e-008 * H_drop_design^6
     +  3.6308100823637902e-010 * H_drop_design^7;

    log10Tin_coeff  = -1.0038834167480192e+002 * H_drop_design^0
     +  1.8493131694801889e+001 * H_drop_design^1
      -1.2659666799989657e+000 * H_drop_design^2
     +  3.6969924811517403e-002 * H_drop_design^3
      -3.6546953643440861e-004 * H_drop_design^4
     +  4.0830130539293590e-006 * H_drop_design^5
      -2.0250129790499153e-007 * H_drop_design^6
      -4.9266862219248962e-009 * H_drop_design^7
     +  1.7488874599009432e-010 * H_drop_design^8
     +  3.5304854944060260e-012 * H_drop_design^9
     +  3.4532308339006739e-014 * H_drop_design^10
      -4.0532139335156347e-015 * H_drop_design^11
      -2.2352677001789913e-017 * H_drop_design^12
     +  2.1309576812437203e-020 * H_drop_design^13
     +  4.0240496921880490e-020 * H_drop_design^14
     +  1.6607491789894543e-022 * H_drop_design^15
     +  2.3017746266050291e-024 * H_drop_design^16
      -4.3345415761172247e-025 * H_drop_design^17
      -1.0232002302512547e-027 * H_drop_design^18
     +  2.5271466061836604e-029 * H_drop_design^19
     +  3.5127578247682477e-030 * H_drop_design^20
      -4.8466250829139132e-032 * H_drop_design^21
     +  9.4145761050034729e-035 * H_drop_design^22;
    
    if H_drop_design > 44 then
      log10Tamb_coeff = 0.004927 * H_drop_design - 0.216788;
    else
      log10Tamb_coeff = 0;
    end if;
    
    /* These raw_input should be supplied by the system model such that the ParticleReceiver 
    model is agnostic to the input dimension of the neural network
    raw_input[1] = heat.Q_flow;
    raw_input[2] = Tamb;
    raw_input[3] = T_in;
    raw_input[4] = H_drop_design;
    */
    
    when level > level_off_ub then
      logic = true;
    elsewhen level < level_off_lb then
      logic = false;
    end when;  
    
    //Energy Balance
    Q_in_1 = ratio_1 * heat.Q_flow;
    Q_in_2 = ratio_2 * heat.Q_flow;
    Q_in_3 = ratio_3 * heat.Q_flow;
    
    Q_in_1 = Q_rcv_1 + Q_loss_1;
    Q_in_2 = Q_rcv_2 + Q_loss_2;
    Q_in_3 = Q_rcv_3 + Q_loss_3;
    
    if on_1 then
        if use_neural_network == true then
          eta_rcv_dummy_1  = predict(
            session_1, 
            raw_input_1, 
            inputsize,
            X_max,
            X_min,
            out_max,
            out_min
            );
                      
        else
          eta_rcv_dummy_1 = const_coeff + Qin_coeff * (heat.Q_flow/1e6) + Tamb_coeff * Tamb + 
                        T_in_coeff * T_in + log10Qin_coeff * Modelica.Math.log10((heat.Q_flow/1e6)) + 
                        log10Tin_coeff * Modelica.Math.log10(T_in) + log10Tamb_coeff * Modelica.Math.log10(Tamb);
        end if;
        
        eta_rcv_1 = eta_rcv_dummy_1;
                
        Q_loss_1 = (1-eta_rcv_1) * Q_in_1;
        
        if logic then
          mdot_1 = Q_rcv_1/(h_out-h_in);
        else
          mdot_1 = 0;
        end if;
	else
      eta_rcv_dummy_1  = 0;
      eta_rcv_1 = 0;
      Q_loss_1 = 0;
      mdot_1 = 0;
	end if;
	
	if on_2 then
        if use_neural_network == true then
          eta_rcv_dummy_2  = predict(
            session_2, 
            raw_input_2, 
            inputsize,
            X_max,
            X_min,
            out_max,
            out_min
            );
        else
          eta_rcv_dummy_2 = const_coeff + Qin_coeff * (heat.Q_flow/1e6) + Tamb_coeff * Tamb + 
                        T_in_coeff * T_in + log10Qin_coeff * Modelica.Math.log10((heat.Q_flow/1e6)) + 
                        log10Tin_coeff * Modelica.Math.log10(T_in) + log10Tamb_coeff * Modelica.Math.log10(Tamb);
        end if;
        
        eta_rcv_2 = eta_rcv_dummy_2;
                
        Q_loss_2 = (1-eta_rcv_2) * Q_in_2; 
        
        if logic then
          mdot_2 = Q_rcv_2/(h_out-h_in);
        else
          mdot_2 = 0;
        end if;
        
	else
      eta_rcv_dummy_2  = 0;
      eta_rcv_2 = 0;
      Q_loss_2 = 0; 
      mdot_2 = 0;
	end if;
    
    if on_3 then
        if use_neural_network == true then
        eta_rcv_dummy_3  = predict(
            session_3, 
            raw_input_3, 
            inputsize,
            X_max,
            X_min,
            out_max,
            out_min
            );
        else
          eta_rcv_dummy_3 = const_coeff + Qin_coeff * (heat.Q_flow/1e6) + Tamb_coeff * Tamb + 
                        T_in_coeff * T_in + log10Qin_coeff * Modelica.Math.log10((heat.Q_flow/1e6)) + 
                        log10Tin_coeff * Modelica.Math.log10(T_in) + log10Tamb_coeff * Modelica.Math.log10(Tamb);
        end if;
        
        eta_rcv_3 = eta_rcv_dummy_3;
                
        Q_loss_3 = (1-eta_rcv_3) * Q_in_3;
        
        if logic then
          mdot_3 = Q_rcv_3/(h_out-h_in);
        else
          mdot_3 = 0;
        end if;
        
	else
      eta_rcv_dummy_3  = 0;
      eta_rcv_3 = 0; 
      Q_loss_3 = 0;
      mdot_3 = 0;
	end if;
	
	fluid_a.m_flow = mdot_1 + mdot_2 + mdot_3;
	//M flow signal
	m_flow_out = fluid_a.m_flow;
	
	annotation (Documentation(info = "<html>
</html>", revisions = "<html>
<ul>
<li>A Shirazi:<br>Released first version. </li>
</ul>
</html>"),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end ParticleReceiver_3Apertures;