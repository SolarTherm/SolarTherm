within SolarTherm.Models.CSP.CRS.Receivers;
model PBS_Receiver
  extends Interfaces.Models.ReceiverFluid;
  Medium.BaseProperties medium;
  Medium.BaseProperties medium_out;
  Medium.BaseProperties medium_in; //new
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out( start=h_0);
  //SI.MassFlowRate m_flow;
  parameter SI.Length H_rcv=1 "Receiver height"
                                               annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_rcv=1 "Receiver diameter"
                                                   annotation(Dialog(group="Technical data"));
  parameter Integer N_pa = 1 "Number of panels" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_tb=1 "Tube outer diameter"
                                                    annotation(Dialog(group="Technical data"));
  parameter SI.Thickness t_tb=1 "Tube wall thickness"
                                                     annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency ab=1 "Coating absortance"
                                                   annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency em=1 "Coating Emitance"
                                                 annotation(Dialog(group="Technical data"));
  parameter SI.HeatFlowRate Q_des_blk = 200.0e6 "Power block design heat input rate, also defocus power";
  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rad;
  SI.HeatFlowRate Q_conv;
  
  //SI.Temperature T_4 "Power 4 average of inlet and outlet (K)";
  //SI.Temperature T_avg "Linear average of inlet and outlet (K)";
  
  SI.HeatFlowRate Q_rcv;
  SI.HeatFlowRate Q_rcv_in;
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
    
  Modelica.Blocks.Interfaces.RealOutput Q_rcv_raw annotation(
    Placement(visible = true, transformation(origin = {108, 2}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {25, -25}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanInput defocus annotation (Placement(
        visible = true,transformation(extent = {{-126, -88}, {-86, -48}}, rotation = 0),iconTransformation(extent = {{-44, -36}, {-20, -12}}, rotation = 0)));
  parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width"; //w_pa=D_rcv*sin(pi/N_pa)
  parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
  parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
  parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
  parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
  parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
  parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
  parameter SI.Temperature T_max=from_degC(700) "Target outlet temperature";
  parameter SI.CoefficientOfHeatTransfer h_conv=20.0 "Convective loss coefficient (W/m2K)";
  
  //SI.Temperature T_in=Medium.temperature(Medium.setState_phX(1e5,h_in));
  //SI.Temperature T_out=Medium.temperature(Medium.setState_phX(1e5,h_out));
  SI.Temperature T_in;
  SI.Temperature T_out;
  parameter SI.SpecificEnthalpy h_out_ref = Medium.specificEnthalpy(Medium.setState_pTX(1e5,T_max));
equation
  
  h_in=inStream(fluid_a.h_outflow);
  //fluid_b.h_outflow=max(h_0,h_out);
  //fluid_a.h_outflow=h_in;
  fluid_a.h_outflow = medium_in.h;
  fluid_b.h_outflow = medium_out.h;
  
  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;
  
  //New
  medium_in.h = h_in;
  T_in = medium_in.T;
  T_out = medium_out.T;
  medium_in.p = fluid_a.p;
  
  
  
  //if fluid_a.m_flow > 1.0e-3 then
   // 0 = ab * heat.Q_flow + Q_loss + fluid_a.m_flow * (h_in - h_out);
   // 0 = ab * heat.Q_flow + Q_loss + Q_rcv_raw;
  //else
  //  h_in = h_out;
  //end if;
  //Q_loss=-A*sigma*em*(medium.T^4-Tamb^4);
  //0=ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
  //Q_rcv=fluid_a.m_flow*(h_out-h_in);
  //Q_rcv = (if defocus == true then min(Q_rcv_raw,Q_des_blk) else Q_rcv_raw);
  //Q_rcv_in = ab*heat.Q_flow;
  medium.h=0.5*(h_in+h_out);
  
  //T_4 = (0.20*(T_in^4 + (T_in^3)*(T_out) + (T_in^2)*(T_out^2) + (T_in)*(T_out^3) + T_out^4));
  //T_avg = 0.5*(T_in + T_out);
  
  Q_rad = A*sigma*em*((medium.T^4)-(Tamb^4));
  Q_conv = A*h_conv*(medium.T-Tamb);
  
  Q_rcv_raw = ab*heat.Q_flow-Q_rad-Q_conv; //Theoretical net receiver output before curtailment
  if fluid_a.m_flow > 1e-6 then
    Q_loss = -1.0*(Q_rad+Q_conv);
    Q_rcv = (if defocus == true then min(Q_rcv_raw,Q_defocus) else Q_rcv_raw);
    //Q_rcv = (if defocus == true then min(Q_rcv_raw,Q_des_blk) else Q_rcv_raw);
    //Q_rcv=fluid_a.m_flow*(h_out-h_in);
    h_out = h_in + Q_rcv/fluid_a.m_flow;
    Q_rcv_in = ab*heat.Q_flow;
    //medium.h=(h_in+h_out)/2;
  else
    Q_loss = 0.0;
    Q_rcv = 0.0;
    h_out = h_out_ref;//h_in;
    Q_rcv_in = 0.0;
    //medium.h=(Medium.specificEnthalpy(Medium.setState_pTX(1e5,T_0))+Medium.specificEnthalpy(Medium.setState_pTX(1e5,T_max)))/2;
  end if;
  //net_gain = ab * heat.Q_flow + Q_loss > 1e-3;
  //pb_threshold = ab * heat.Q_flow + Q_loss >= Q_des_blk;
  
  medium_out.h = h_out;
  medium_out.p = medium.p;
  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>by Zebedee Kee, Receiver used in Packed Bed Storage Annual System Model. Only Radiative Losses. </li>
</ul>
</html>"));
end PBS_Receiver;