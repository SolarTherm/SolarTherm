within SolarTherm.Models.CSP.CRS.Receivers;
model ReceiverSimple_3
  extends Interfaces.Models.ReceiverFluid;
  Medium.BaseProperties medium;
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

  //SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rcv;
  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));
        
    Modelica.Blocks.Interfaces.RealOutput Q_recv_in annotation(
    Placement(visible = true, transformation(origin = {108, 90}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {25, 9}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    
    Modelica.Blocks.Interfaces.RealOutput Q_loss = -A*sigma*em*(medium.T^4-Tamb^4) annotation(
    Placement(visible = true, transformation(origin = {108, 64}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {25, -13}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
    
  Modelica.Blocks.Interfaces.BooleanOutput net_gain annotation(
    Placement(visible = true, transformation(origin = {108, 30}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {25, -37}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));

  parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width"; //w_pa=D_rcv*sin(pi/N_pa)
  parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
  parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
  parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
  parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
  parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
  parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
equation
  medium.h=(h_in+h_out)/2;
  h_in=inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=max(h_0,h_out);
  fluid_a.h_outflow=h_0;

  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;
  if fluid_a.m_flow > 1.0e-6 then
    0 = ab * heat.Q_flow + Q_loss + fluid_a.m_flow * (h_in - h_out);
  else
    h_in = h_out;
  end if;
  //Q_loss=-A*sigma*em*(medium.T^4-Tamb^4);
  //0=ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
  Q_rcv=fluid_a.m_flow*(h_out-h_in);
  
  Q_recv_in = ab*heat.Q_flow;
  net_gain = ab * heat.Q_flow + Q_loss > 1e-6;

  annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end ReceiverSimple_3;