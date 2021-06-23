within SolarTherm.Models.CSP.CRS.Receivers;

model SodiumReceiverASTRI

  extends Interfaces.Models.ReceiverFluid;
  Medium.BaseProperties medium;
  Medium.BaseProperties medium_out;

  //SI.MassFlowRate m_flow;
  parameter SI.Length H_rcv=1 "Receiver height" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_rcv=1 "Receiver diameter" annotation(Dialog(group="Technical data"));
  parameter Integer N_pa = 1 "Number of panels" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_tb=1 "Tube outer diameter" annotation(Dialog(group="Technical data"));
  parameter SI.Thickness t_tb=1 "Tube wall thickness" annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency ab=1 "Coating absortance" annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency em=1 "Coating Emitance" annotation(Dialog(group="Technical data"));
  parameter SI.HeatFlowRate Q_des_blk = 200.0e6 "Power block design heat input rate, also defocus power";
  
  parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width"; //w_pa=D_rcv*sin(pi/N_pa)
  parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
  //parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
  //parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
  parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
  parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
  parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
  parameter SI.Temperature T_max=from_degC(700) "Target outlet temperature";

  parameter Real[4] CL = {945.7112573259491,0.02720568,-0.00172737,0.07126733} "Coefficients to calculate T_ext_linear";
  parameter Real[4] C4L = {953.7130902079241,0.02170311,-0.00196636,0.08407119} "Coefficients to calculate T_ext_4_linear";
  parameter Real[5] CH = {7.61828573e-04,-3.54208032e-02,5.93470995e-01,-9.37379885e-01,9.26793247} "Coefficients to calculate h_ext";

  Modelica.Blocks.Interfaces.RealInput Wspd annotation (Placement(
				transformation(
				extent={{-12,-12},{12,12}},
				rotation=-90,
				origin={-20,84}), iconTransformation(
				extent={{-6,-6},{6,6}},
				rotation=-90,
				origin={-20,78})));
  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));      
  Modelica.Blocks.Interfaces.RealInput Q_defocus "Required defocus heat rate" annotation (Placement(
        visible = true,transformation(
        
        origin={44,84},extent={{-12,-12},{12,12}},
        rotation=-90), iconTransformation(
        
        origin={22,-54},extent={{-6,-6},{6,6}},
        rotation=180)));  
  Modelica.Blocks.Interfaces.BooleanInput defocus annotation (Placement(
        visible = true,transformation(extent = {{-126, -88}, {-86, -48}}, rotation = 0),iconTransformation(extent = {{-44, -36}, {-20, -12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Q_rcv_raw annotation(
    Placement(visible = true, transformation(origin = {108, 2}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {25, -25}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  
  
  SI.Temperature T_in=Medium.temperature(Medium.setState_phX(1e5,h_in));
  SI.Temperature T_out=Medium.temperature(Medium.setState_phX(1e5,h_out));
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out( start=h_0);

 
  SI.HeatFlowRate Q_rcv "Incident energy on the receiver (after defocus), before reflection";
  SI.HeatFlowRate Q_rcv_in "Incident energy on the receiver after reflection losses";
  SI.HeatFlowRate Q_rec "Heat flow captured by HTF after piping losses";   
  SI.HeatFlowRate Q_loss "Thermal (convective and emmisive) losses from the receiver";
  SI.HeatFlowRate Q_refl  "Receiver losses due to reflection";
  SI.HeatFlowRate Q_rad  "Receiver losses due to re-radiation";
  SI.HeatFlowRate Q_conv "Receiver losses due to forced convection";
  SI.Temperature T_ext_linear "Space average temperature for convective loss";
  SI.Temperature T_ext_4_linear "Fourth degree space average temperature for radiative loss";
  SI.CoefficientOfHeatTransfer h_conv "External convective coefficient";

  SI.Efficiency eff "Calculated receiver efficiency";
  SI.Efficiency eta_rec "Receiver efficiency as calculated from correlation";
  SI.Energy E_rec(start=0) "Acummulated receiver energy";
  SI.Energy E_ref(start=0) "Acummulated reflective loss";
  SI.Energy E_rad(start=0) "Acummulated radiative loss";
  SI.Energy E_conv(start=0) "Acummulated convective loss";


  
equation
  medium.h=(h_in+h_out)/2;  
  h_in=inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=max(h_0,h_out);
  fluid_a.h_outflow=h_0;

  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;

  Q_rcv_raw = heat.Q_flow-Q_refl-Q_rad-Q_conv; //Theoretical net receiver output before curtailment
  Q_refl = (1-ab)*(max(1,heat.Q_flow));
  Q_rad = em*sigma*H_rcv*D_rcv*pi*(T_ext_4_linear^4 - (max(1,Tamb))^4);
  Q_conv = h_conv*H_rcv*D_rcv*pi*(T_ext_linear-(max(1,Tamb)));           
  T_ext_linear = CL[1] + CL[2]*(max(1,heat.Q_flow))/1e6 + CL[3]*(max(1,Tamb)) + CL[4]*(max(1,Wspd));
  T_ext_4_linear = C4L[1] + C4L[2]*(max(1,heat.Q_flow))/1e6 + C4L[3]*(max(1,Tamb)) + C4L[4]*(max(1,Wspd));
  h_conv = CH[5] + CH[4]*Wspd + CH[3]*Wspd^2 + CH[2]*Wspd^3 + CH[1]*Wspd^4;  
 
  if fluid_a.m_flow > 1e-6 then // The receiver is on.
    Q_rcv_in = heat.Q_flow - Q_refl;  
    Q_loss = -1.0*(Q_rad + Q_conv); // Receiver thermal losses
    Q_rcv = (if defocus == true then min(Q_rcv_raw,Q_defocus) else Q_rcv_raw);
    h_out = h_in + Q_rcv/fluid_a.m_flow;
	eta_rec = ((max(1,heat.Q_flow))-Q_refl-Q_rad-Q_conv)/(max(1,heat.Q_flow));    
  else
    Q_rcv_in = 0.0;  
    Q_loss = 0.0;
    Q_rcv = 0.0;
    h_out = h_in;
    eta_rec=0;
  end if;

  der(E_rec) = Q_rec;
  der(E_ref) = Q_refl;
  der(E_rad) = Q_rad;
  der(E_conv) = Q_conv;
  Q_rec = fluid_a.m_flow*h_out + fluid_b.m_flow*h_in; // energy taken by the HTF
  eff = Q_rec/max(1,heat.Q_flow); // receiver total efficiency (thermal and optical)
  //Q_out = heat.Q_flow*eta_rec;
  
  medium_out.h = h_out;
  medium_out.p = medium.p;
  
  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));

end SodiumReceiverASTRI;