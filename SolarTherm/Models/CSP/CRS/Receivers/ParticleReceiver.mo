within SolarTherm.Models.CSP.CRS.Receivers;
model ParticleReceiver
	extends Interfaces.Models.ReceiverFluid;
	
	import Modelica.SIunits.Conversions.*;

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
	parameter Integer inputsize = 4;
    parameter String saved_model_dir = "/home/philgun/solartherm-particle/SolarTherm/Resources/Include/neural-network/trained-model/surrogate_receiver";
	
	parameter Real c0 = -0.00000000000812828041;
	parameter Real c1 = 0.0000000221705242;
	parameter Real c2 = -0.0000229149451;
	parameter Real c3 = 0.0109275916;
	parameter Real c4 = -1.25070245;

	Medium.BaseProperties medium;

	SI.SpecificEnthalpy h_in "Specific enthalpy at inlet";
	SI.SpecificEnthalpy h_out(start=h_0) "Specific enthalpy at outlet";

	SI.Temperature T_in=Medium.temperature(state_in) "Temperature at inlet";

	SI.HeatFlowRate Q_loss "Total losses";
	SI.HeatFlowRate Q_rcv "Heat flow captured by curtain";
	SI.Efficiency eta_rcv;

	Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
		transformation(
		extent={{-12,-12},{12,12}},
		rotation=-90,
		origin={0,84}), iconTransformation(
		extent={{-6,-6},{6,6}},
		rotation=-90,
		origin={0,78})));

	Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
		transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
		-24,-98},{-12,-86}})));

	parameter SI.Temperature T_0=from_degC(550) "Start value of temperature";
	parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
	parameter SI.SpecificEnthalpy h_0=SolarTherm.Media.SolidParticles.CarboHSP_utilities.h_T(T_0);
	parameter SI.Temperature T_out = from_degC(800) "Temperature at outlet";
	
	Real const_coeff;
	Real Qin_coeff;
	Real Tamb_coeff;
	Real T_in_coeff;
	Real log10Qin_coeff;
	Real log10Tin_coeff;
	Real log10Tamb_coeff;
	
	Medium.ThermodynamicState state_in=Medium.setState_phX(fluid_a.p,h_in);
	Medium.ThermodynamicState state_out=Medium.setState_phX(fluid_b.p,h_out);

equation
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

    //Energy Balance
    heat.Q_flow = Q_loss + Q_rcv;
    if on then
          if use_neural_network == true then
            eta_rcv = SolarTherm.Utilities.st_surrogate({heat.Q_flow, Tamb, T_in, H_drop_design},inputsize,saved_model_dir);
          else
            eta_rcv = const_coeff + Qin_coeff * (heat.Q_flow/1e6) + Tamb_coeff * Tamb + 
                      T_in_coeff * T_in + log10Qin_coeff * Modelica.Math.log10((heat.Q_flow/1e6)) + 
                      log10Tin_coeff * Modelica.Math.log10(T_in) + log10Tamb_coeff * Modelica.Math.log10(Tamb);
          end if;
      Q_loss= (1-eta_rcv) * heat.Q_flow;
      fluid_a.m_flow = Q_rcv/(h_out-h_in);
	else
      eta_rcv = 0;
      Q_loss=0; // when the receiver is 'off', assume no thermal losses
      fluid_a.m_flow = 0;
	end if;
	//eta_rcv = (heat.Q_flow/1e6)^4*c0 + (heat.Q_flow/1e6)^3 *c1 + (heat.Q_flow/1e6)^2 *c2 + (heat.Q_flow/1e6)*c3 + c4;
	annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>A Shirazi:<br>Released first version. </li>
</ul>
</html>"));
end ParticleReceiver;
