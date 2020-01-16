within SolarTherm.Models.CSP.CRS.Receivers;

model SB_Receiver
  import CN = Modelica.Constants;
  extends Interfaces.Models.ReceiverFluid;
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_dTX;
  parameter String concept = "Cavity" "Type of receiver {Cavity,Billboard,Cylindrical}";
  parameter SI.Length H_tower=20 "Tower height"
                                               annotation(Dialog(group="Technical data"));
  parameter SI.Length H_rcv=2.0 "Receiver height"
                                               annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_rcv=2.0 "Receiver diameter or Width depending on concept"
                                                   annotation(Dialog(group="Technical data"));
  parameter Integer N_pa = 20 "Number of panels for cylindrical, otherwise ignored" annotation(Dialog(group="Technical data"));
  parameter SI.Diameter D_tb=40.0e-3 "Tube outer diameter"
                                                    annotation(Dialog(group="Technical data"));
  parameter SI.Thickness t_tb=1.25e-3 "Tube wall thickness"
                                                     annotation(Dialog(group="Technical data"));

  parameter SI.Efficiency ab=0.961 "Absortance after view factor calcs"
                                           annotation(Dialog(group="Technical data"));
  parameter SI.Efficiency em=0.920 "Emitance after view factor calcs"
                                         annotation(Dialog(group="Technical data"));
  parameter SI.Temperature T_0=1073.0 "Start value of temperature";

  //parameter SI.Length L_const=0 "Piping length constant" annotation(Dialog(group="Piping"));
  //parameter Real F_mult=1 "Piping length multiplier "
                                                     annotation(Dialog(group="Piping"));
                                                       parameter Real C_pip(unit="W/m")=1000 "Piping loss coeficient" annotation(Dialog(group="Piping"));
                                                       
  parameter SI.CoefficientOfHeatTransfer h_convection=20.0 "Convective heat transfer coefficient";
  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rcv;
  //SI.HeatFlowRate Q_pip;
  Real Flux=Q_rcv/A_material;
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
  parameter SI.Area A_aperture=(if concept == "Cylindrical" then CN.pi*H_rcv*D_rcv else CN.pi*D_rcv) "Area (flat)";
  parameter SI.Area A_material=(if concept == "Cavity" then 2.0*A_aperture else 1.0*A_aperture) "Area used for cost relationship";
  
  Medium.BaseProperties HTF_in "Inlet properties of HTF";
  Medium.BaseProperties HTF_out "Outlet properties of HTF";
  //Medium.BaseProperties HTF_avg "Average properties of HTF";
  
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;

protected
  parameter SI.Length w_pa=D_rcv*sin(pi/N_pa) "Panel width";
  parameter Real N_tb_pa=div(w_pa,D_tb)   "Number of tubes";
  parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;

  //parameter SI.Length L_tot=H_tower*F_mult+L_const "Total piping length";

  //parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1,T_0);
  //parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
  SI.Energy E_absorbed;
  SI.Energy E_net;
public
  /*Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
        transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
            -24,-98},{-12,-86}})));*/
initial equation
  //HTF_in.T = T_0;
  //HTF_in.X[2] = 0.0;
  //HTF_out.T = T_0;
  //HTF_out.X[2] = 0.2;
  //HTF_avg.T = T_0;
  //HTF_avg.X[2] = 0.1;
  //on = false;
equation
  //HTF_avg.h=(HTF_in.h+HTF_out.h)/2;
  //HTF_avg.T = HTF_in.T;
  //calculate m_flow here
  fluid_a.m_flow = (ab*heat.Q_flow+Q_loss)/(SolarTherm.Media.Sodium.Sodium_utilities.h_fg_T(HTF_in.T));

  fluid_a.h_outflow=0;

  heat.T=HTF_in.T;

  fluid_b.m_flow + fluid_a.m_flow = 0;
  fluid_a.p = fluid_b.p;

  //Zebedee
  HTF_in.h = inStream(fluid_a.h_outflow);
  HTF_out.h = fluid_b.h_outflow;
  
  HTF_out.T = HTF_in.T;
  
  h_in = HTF_in.h;
  h_out = HTF_out.h;
  
  0 = ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
  Q_rcv=fluid_a.m_flow*(h_out-h_in);
  Q_loss=-A_aperture*CN.sigma*em*(HTF_in.T^4-Tamb^4);

  der(E_absorbed)=ab*heat.Q_flow;
  der(E_net)=Q_rcv;

  if E_absorbed > 0.0 then
    receiver_efficiency = E_net/E_absorbed;
  else
    receiver_efficiency = 0.0;
  end if;
end SB_Receiver;