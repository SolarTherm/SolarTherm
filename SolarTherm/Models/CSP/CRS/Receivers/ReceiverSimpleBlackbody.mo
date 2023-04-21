within SolarTherm.Models.CSP.CRS.Receivers;
model ReceiverSimpleBlackbody

 /* A flat plate (aperature) given by the area
  blackbody behaviour, abs=1, ems=1
  no convection, conduction losses
  no working fluid nor flow path
  working at a constant temperature */
  
  parameter SI.Area A_recv = 100 "Receiver area m2";
  parameter SI.Efficiency ab=1 "Coating absortance" annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency em=1 "Coating Emitance" annotation(Dialog(group="Technical data"));
  parameter Real sigma = 5.67e-8 "Stefan-Boltzmann constant";
  parameter SI.Temperature T_recv=800 "receiver surface temperature (K)";

  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rcv;
  SI.HeatFlowRate Q_rcv_net;
  SI.Energy E_rcv(start = 0, fixed = true);


  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        visible = true,transformation(
        
        origin={0,100},extent={{-18, -18},{18, 18}},
        rotation=-90), iconTransformation(
        
        origin={0,78},extent={{-6,-6},{6,6}},
        rotation=-90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat annotation(
    Placement(visible = true, transformation(origin = {-90, 4}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-110, 20}, {-90, 40}}, rotation = 0)));
equation

  Q_loss= if heat.Q_flow >0 then -A_recv*sigma*em*(T_recv^4-Tamb^4) else 0;
  
  0=ab*heat.Q_flow+Q_loss+Q_rcv;
  
  heat.T=T_recv;

  Q_rcv_net=max(-Q_rcv,0);
  der(E_rcv)=Q_rcv_net;

  annotation (Documentation(info = "<html>
</html>", revisions = "<html>
<ul>
<li>Ye Wang:<br>Released first version. </li>
</ul>
</html>"),
    Diagram);
end ReceiverSimpleBlackbody;
