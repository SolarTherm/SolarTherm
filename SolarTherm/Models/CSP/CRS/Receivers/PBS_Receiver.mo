within SolarTherm.Models.CSP.CRS.Receivers;
model PBS_Receiver
  extends Interfaces.Models.ReceiverFluid;
  Medium.BaseProperties medium;
  Medium.BaseProperties medium_out;
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
equation
  
  h_in=inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=max(h_0,h_out);
  fluid_a.h_outflow=h_0;

  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;
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
  medium.h=(h_in+h_out)/2;
  
  Q_rcv_raw = ab*heat.Q_flow-A*sigma*em*((medium.T)^4-Tamb^4); //Theoretical net receiver output before curtailment
  if fluid_a.m_flow > 1e-3 then
    Q_loss = -1.0*A*sigma*em*(medium.T^4-Tamb^4);
    Q_rcv = (if defocus == true then min(Q_rcv_raw,Q_defocus) else Q_rcv_raw);
    //Q_rcv = (if defocus == true then min(Q_rcv_raw,Q_des_blk) else Q_rcv_raw);
    //Q_rcv=fluid_a.m_flow*(h_out-h_in);
    h_out = h_in + Q_rcv/fluid_a.m_flow;
    Q_rcv_in = ab*heat.Q_flow;
    //medium.h=(h_in+h_out)/2;
  else
    Q_loss = 0.0;
    Q_rcv = 0.0;
    h_out = h_in;
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
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end PBS_Receiver;