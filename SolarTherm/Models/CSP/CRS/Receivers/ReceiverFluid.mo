within SolarTherm.Models.CSP.CRS.Receivers;
model ReceiverFluid
  extends Interfaces.Models.ReceiverFluid;
  Medium.BaseProperties medium;
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out(start=h_0, fixed=true);
  //SI.MassFlowRate m_flow;
  parameter SI.Length H_tower=10 "Tower height"
                                               annotation(Dialog(group="Technical data"));
  parameter SI.Length H_rcv=1 "Receiver height"
                                               annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_rcv=1 "Receiver diameter"
                                                   annotation(Dialog(group="Technical data"));
  parameter Integer N_pa = 1 "Number of panels" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_tb=1 "Tube outer diameter"
                                                    annotation(Dialog(group="Technical data"));
  parameter SI.Thickness t_tb=1 "Tube wall thickness"
                                                     annotation(Dialog(group="Technical data"));

  parameter SI.Efficiency ab=1 "Absortance"
                                           annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency em=1 "Emitance"
                                         annotation(Dialog(group="Technical data"));
  parameter SI.Temperature T_0=from_degC(574) "Start value of temperature";

  parameter SI.Length L_const=0 "Piping length constant" annotation(Dialog(group="Piping"));
  parameter Real F_mult=1 "Piping length multiplier "
                                                     annotation(Dialog(group="Piping"));
  parameter Real C_pip(unit="W/m")=1000 "Piping loss coeficient" annotation(Dialog(group="Piping"));

  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rcv;
  SI.HeatFlowRate Q_pip;
  Real Flux=Q_rcv/A;
  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));

protected
  parameter SI.Length w_pa=D_rcv*sin(pi/N_pa) "Panel width";
  parameter Real N_tb_pa=div(w_pa,D_tb)   "Number of tubes";
  parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;

  parameter SI.Length L_tot=H_tower*F_mult+L_const "Total piping length";
  parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2) "Area";
  parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1,T_0);
  parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
public
  Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
        transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
            -24,-98},{-12,-86}})));
initial equation
  //h=h_0;
equation
  medium.h=(h_in+h_out)/2;
  h_in=inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=h_out;
  fluid_a.h_outflow=0;

  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;

  // no pressure drops
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;

  // 
  V_rcv*(medium.d/2)*(der(h_in)+der(h_out))=ab*heat.Q_flow+Q_pip+Q_loss+fluid_a.m_flow*(h_in-h_out);

  // heat supplied to the working fluid
  Q_rcv=fluid_a.m_flow*(h_out-h_in);

  if on then
    Q_pip=-L_tot*C_pip; // piping loss on a per-total-length-of-pipe basis
    Q_loss=-A*sigma*em*(medium.T^4-Tamb^4); // radiative losses assumes medium temp == outer wall temp
  else
    Q_pip=0;
    Q_loss=V_rcv*(medium.d/2)*der(h_in);
  end if;

  annotation (Documentation(revisions="<html>
<ul>
<li>Alberto de la Calle:<br>Released first version. </li>
</ul>
</html>"));
end ReceiverFluid;
