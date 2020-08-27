within SolarTherm.SolarPaces2019;

model ReceiverSimple_Flat_SodiumBoiler
  extends Interfaces.Models.ReceiverHeat;
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
  parameter Real F_area=1 "Receiver area multiplier";
  parameter SI.CoefficientOfHeatTransfer h_convection=30.0;
  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rcv;
  //SI.HeatFlowRate Q_pip;
  Real Flux=Q_rcv/A;
  Real receiver_efficiency;
  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));
  //SI.SpecificEnthalpy inlet_enthalpy "Inlet specific enthalpy, also equal to storage enthalpy";
  //New stuff
  //SI.ThermodynamicTemperature T_HTF "Temperature of heat transfer fluid";
  parameter SI.TemperatureDifference T_super=50.0 "How much hotter the tube wall is compared to fluid";
  parameter SI.Area A=N_pa*H_rcv*w_pa "Area (flat)";
  //SI.Density inlet_density "density of storage HTF";

protected
  parameter SI.Length w_pa=D_rcv*sin(pi/N_pa) "Panel width";
  parameter Real N_tb_pa=div(w_pa,D_tb)   "Number of tubes";
  parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;

  parameter SI.Length L_tot=H_tower*F_mult+L_const "Total piping length";

  //parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1,T_0);
  //parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
  SI.Energy E_absorbed;
  SI.Energy E_net;
  Boolean on_internal;
  

public
  Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
        transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
            -24,-98},{-12,-86}})));
initial equation
  //h=h_0;
  //on = true;

equation

  //medium.h=(h_in+h_out)/2;
  //h_in=inStream(fluid_a.h_outflow);
  //fluid_b.h_outflow=h_out;
  //fluid_a.h_outflow=0;

  //heat.T=medium.T;
  //fluid_b.m_flow=-fluid_a.m_flow;
  //fluid_a.p=medium.p;
  //fluid_b.p=medium.p;

  //V_rcv*(medium.d/2)*(der(h_in)+der(h_out))=ab*heat.Q_flow+Q_pip+Q_loss+fluid_a.m_flow*(h_in-h_out);
  //Q_rcv=fluid_a.m_flow*(h_out-h_in);
  if ab*heat_a.Q_flow-A*sigma*em*((heat_a.T+T_super)^4-Tamb^4)-A*h_convection*(heat_a.T+T_super-Tamb) > 0.0 and on then
    on_internal = true;
  else
    on_internal = false;
  end if;
  if on_internal then
    //Q_pip=-L_tot*C_pip*1.0;
    Q_loss=-1.0*A*sigma*em*((heat_a.T+T_super)^4-Tamb^4)-A*h_convection*(heat_a.T+T_super-Tamb);
	//Q_rcv=ab*heat_a.Q_flow+Q_loss+Q_pip;
	Q_rcv=ab*heat_a.Q_flow+Q_loss;
	der(E_absorbed)=ab*heat_a.Q_flow;
	der(E_net)=Q_rcv;
  else
    //Q_pip=0;
    Q_loss=0.0;//V_rcv*(inlet_density/2)*der(inlet_enthalpy);
	Q_rcv=0.0;
	der(E_absorbed) = 0.0;
	der(E_net) = 0.0;
  end if;
  if E_absorbed > 0.0 then
    receiver_efficiency = E_net/E_absorbed;
  else
    receiver_efficiency = 0.0;
  end if;
  heat_b.Q_flow = -1.0*Q_rcv;
  //T_HTF = heat_a.T;
  heat_a.T=heat_b.T;
  heat_b.T=heat.T;
end ReceiverSimple_Flat_SodiumBoiler;