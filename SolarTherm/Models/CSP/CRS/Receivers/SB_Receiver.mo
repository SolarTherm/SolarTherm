within SolarTherm.Models.CSP.CRS.Receivers;

model SB_Receiver
  import CN = Modelica.Constants;
  extends Interfaces.Models.ReceiverFluid;
  redeclare replaceable package Medium = SolarTherm.Media.Sodium.Sodium_ph;
  replaceable package Air = SolarTherm.Media.Materials.Air_Table;
  parameter String concept = "Billboard" "Type of receiver {Billboard,Cylindrical}";
  parameter String convection = "Siebers" "Convection loss assumption {Constant,Siebers}";
  parameter SI.Length H_tower = 20 "Tower height" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Length H_rcv = 2.0 "Receiver height" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Diameter D_rcv = 2.0 "Receiver diameter or Width depending on concept" annotation(
    Dialog(group = "Technical data"));
  parameter Integer N_pa = 20 "Number of panels for cylindrical, otherwise ignored" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Diameter D_tb = 40.0e-3 "Tube outer diameter" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Thickness t_tb = 1.25e-3 "Tube wall thickness" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Efficiency ab = 0.961 "Absortance after view factor calcs" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Efficiency em = 0.920 "Emitance after view factor calcs" annotation(
    Dialog(group = "Technical data"));
  parameter SI.Temperature T_0 = 1073.0 "Start value of temperature";
  //parameter SI.Length L_const=0 "Piping length constant" annotation(Dialog(group="Piping"));
  //parameter Real F_mult=1 "Piping length multiplier "
  parameter Real C_pip(unit = "W/m") = 1000 "Piping loss coeficient" annotation(
    Dialog(group = "Piping"));
  parameter SI.CoefficientOfHeatTransfer h_c_const = 20.0 "Constant heat transfer coefficient if model is simplified";
  SI.CoefficientOfHeatTransfer h_c "Convective heat transfer coefficient calculated at each timestep";
  SI.CoefficientOfHeatTransfer h_cn "Natural heat transfer coefficient calculated at each timestep";
  SI.CoefficientOfHeatTransfer h_cf "Forced heat transfer coefficient calculated at each timestep";
  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rcv;
  //SI.HeatFlowRate Q_pip;
  Real Flux = Q_rcv / A_material;
  Real receiver_efficiency;
  Modelica.Blocks.Interfaces.RealInput Tamb annotation(
    Placement(visible = true,transformation( origin = {36, 84},extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation( origin = {20, 78},extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Wspd annotation(
    Placement(visible = true,transformation( origin = {-40, 84},extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation( origin = {-22, 78},extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  //SI.SpecificEnthalpy inlet_enthalpy "Inlet specific enthalpy, also equal to storage enthalpy";
  //New stuff
  //SI.ThermodynamicTemperature T_HTF "Temperature of heat transfer fluid";
  parameter SI.TemperatureDifference T_super = 50.0 "How much hotter the tube wall is compared to fluid";
  parameter SI.Area A_aperture = if concept == "Cylindrical" then CN.pi * H_rcv * D_rcv else CN.pi * D_rcv "Area (flat)";
  parameter SI.Area A_material = if concept == "Cavity" then 2.0 * A_aperture else 1.0 * A_aperture "Area used for cost relationship";
  Medium.BaseProperties HTF_in "Inlet properties of HTF";
  Medium.BaseProperties HTF_out "Outlet properties of HTF";
  //Medium.BaseProperties HTF_avg "Average properties of HTF";
  SI.SpecificEnthalpy h_in;
  SI.SpecificEnthalpy h_out;
  Air.State Air_State_Film "Properties at film temperature of air";
  Air.State Air_State_Amb "Properties at ambuent temperature";
  SI.Temperature T_film "Film temperature of air";
  Modelica.Blocks.Interfaces.RealOutput Q_recv_in annotation(
    Placement(visible = true, transformation(origin = {108, 90}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {25, -1}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  /*Modelica.Blocks.Interfaces.BooleanInput on annotation (Placement(
          transformation(extent={{-38,-94},{2,-54}}), iconTransformation(extent={{
              -24,-98},{-12,-86}})));*/
protected
  parameter SI.Length w_pa = D_rcv * sin(pi / N_pa) "Panel width";
  parameter Real N_tb_pa = div(w_pa, D_tb) "Number of tubes";
  parameter SI.Volume V_rcv = N_pa * N_tb_pa * H_rcv * pi * (D_tb / 2 - t_tb) ^ 2;
  //parameter SI.Length L_tot=H_tower*F_mult+L_const "Total piping length";
  //parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1,T_0);
  //parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
  SI.Energy E_absorbed;
  SI.Energy E_net;
  SI.ThermalConductivity k_air "thermal conductivity of air";
  Real Re;
  Real Pr;
  Real Gr;
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
  //calculate convective loss
  T_film = 0.5*(Tamb+HTF_in.T);
  Air_State_Amb.h = Air.h_Tf(Tamb);
  Air_State_Film.h = Air.h_Tf(T_film);
  k_air = Air_State_Amb.k;
  
  if convection == "Constant" then
    Re = 0.0;
    Pr = 0.0;
    Gr = 0.0;
    h_cf = 0.0;
    h_cn = 0.0;
    h_c = h_c_const;
  else
    //Gr is for natural convection, use Tamb and y-scale
    //Pr and Re are for forced convection, use T_film and x-scale
    //Natural convection uses y-scale (height)
    //Forced convection uses x-scale (diameter)
    if concept == "Billboard" then
      Re = Air_State_Film.rho*max(0.0,Wspd)*D_rcv/Air_State_Film.mu; //x-scale, Film temperature
      Pr = Air_State_Film.cp*Air_State_Film.mu/Air_State_Film.k; //x-scale, Film temperature
      Gr = (9.81*(1/Tamb)*(HTF_in.T-Tamb)*(H_rcv^3))/((Air_State_Amb.mu/Air_State_Amb.rho)^2); //y-scale, Ambient temperature
      h_cn = (k_air/H_rcv)*0.098*(Gr^(1/3))*((HTF_in.T/Tamb)^(-0.14)); //y-scale, Ambient temperature
      h_cf = (k_air/D_rcv)*0.0307*(Re^0.8)*(Pr^0.6)*((HTF_in.T/Tamb)^(-0.4)); //x-scale, Film temperature
      h_c = (h_cn^3.2+h_cf^3.2)^(1/3.2);
    else //Cylindrical External
      Re = Air_State_Film.rho*max(0.0,Wspd)*D_rcv/Air_State_Film.mu; //x-scale, Film Temperature
      Pr = Air_State_Film.cp*Air_State_Film.mu/Air_State_Film.k; //x-scale, Film Temperature
      Gr = (9.81*(1/Tamb)*(HTF_in.T-Tamb)*(D_rcv^3))/((Air_State_Amb.mu/Air_State_Amb.rho)^2); //y-scale, Ambient Temperature
      h_cn = (k_air/H_rcv)*0.098*(Gr^(1/3))*((HTF_in.T/Tamb)^(-0.14)); //y-scale, Ambient temperature
      h_cf = (k_air/D_rcv)*(0.3+0.488*(Re^0.5)*((1.0+((Re/282000)^0.625)))^0.8); //x-scale, Film temperature, smooth cylinder
      h_c = (h_cn^3.2+h_cf^3.2)^(1/3.2);
    end if;
  end if;
    
  Q_recv_in = heat.Q_flow;
  
  fluid_a.h_outflow = 0;
  heat.T = HTF_in.T;
  fluid_b.m_flow + fluid_a.m_flow = 0;

//Zebedee
  HTF_in.h = inStream(fluid_a.h_outflow);
  HTF_in.p = fluid_a.p;
  
  HTF_out.h = fluid_b.h_outflow;
  HTF_out.p = fluid_b.p;
  
  HTF_out.T = HTF_in.T;

  h_in = HTF_in.h;
  h_out = HTF_out.h;
  if fluid_a.m_flow > 1.0e-6 then
    0 = ab * heat.Q_flow + Q_loss + fluid_a.m_flow * (h_in - h_out);
  else
    h_in = h_out;
  end if;
  Q_rcv = fluid_a.m_flow * (h_out - h_in);
  Q_loss = -A_aperture * CN.sigma * em * (HTF_in.T ^ 4 - Tamb ^ 4);
  der(E_absorbed) = ab * heat.Q_flow;
  der(E_net) = Q_rcv;
  if E_absorbed > 0.0 then
    receiver_efficiency = E_net / E_absorbed;
  else
    receiver_efficiency = 0.0;
  end if;
  annotation(
    Dialog(group = "Piping"));
end SB_Receiver;