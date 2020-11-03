within SolarTherm.SolarPaces2019;

model ReceiverSimple_Flat
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
  parameter SI.CoefficientOfHeatTransfer h_convection=20.0 "W/m2K";
  SI.HeatFlowRate Q_loss;
  SI.HeatFlowRate Q_rcv;
  Modelica.Blocks.Interfaces.RealInput Tamb annotation (Placement(
        transformation(
        extent={{-12,-12},{12,12}},
        rotation=-90,
        origin={0,84}), iconTransformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={0,78})));
        
  SI.ThermalConductivity k_air "thermal conductivity of air";
  Real Re;
  Real Pr;
  Real Gr;
  Air.State Air_State_Film(h_start=Air.h_Tf(685.575)) "Properties at film temperature of air";
  Air.State Air_State_Amb(h_start=Air.h_Tf(298.15))  "Properties at ambuent temperature";
  SI.Temperature T_film "Film temperature of air";
  parameter SI.CoefficientOfHeatTransfer h_c_const = 20.0 "Constant heat transfer coefficient if model is simplified";
  SI.CoefficientOfHeatTransfer h_c "Convective heat transfer coefficient calculated at each timestep";
  SI.CoefficientOfHeatTransfer h_cn "Natural heat transfer coefficient calculated at each timestep";
  SI.CoefficientOfHeatTransfer h_cf "Forced heat transfer coefficient calculated at each timestep";
  parameter String convection = "Siebers" "Convection loss assumption {Constant,Siebers}";
  replaceable package Air = SolarTherm.Materials.Air_Table;
  Medium.BaseProperties HTF_in "Inlet properties of HTF";
  Modelica.Blocks.Interfaces.RealInput Wspd annotation(
    Placement(visible = true,transformation( origin = {-40, 84},extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation( origin = {-22, 78},extent = {{-6, -6}, {6, 6}}, rotation = -90)));
  
protected
  parameter SI.Length w_pa=D_rcv*pi/N_pa "Panel width"; //w_pa=D_rcv*sin(pi/N_pa)
  parameter Real N_tb_pa=div(w_pa,D_tb) "Number of tubes";
  parameter SI.Volume V_rcv=N_pa*N_tb_pa*H_rcv*pi*(D_tb/2-t_tb)^2;
  //parameter SI.Area A=N_pa*N_tb_pa*H_rcv*pi*D_tb/2 "Area";
  parameter SI.Area A=N_pa*H_rcv*w_pa "Flat area of receiver because effective emittance is already considered";
  parameter Medium.ThermodynamicState state_0=Medium.setState_pTX(1e5,T_0);
  parameter SI.SpecificEnthalpy h_0=Medium.specificEnthalpy(state_0);
  parameter SI.Temperature T_0=from_degC(290) "Start value of temperature";
  
  parameter SI.Length H_tower=30.0 "Tower Height";
  SI.Velocity Wspd_tower "Windspeed at tower height";
equation
  Wspd_tower=Wspd*((H_tower/10)^0.14);
  
  medium.h=(h_in+h_out)/2;
  h_in=inStream(fluid_a.h_outflow);
  fluid_b.h_outflow=max(h_0,h_out);
  fluid_a.h_outflow=0;

  heat.T=medium.T;
  fluid_b.m_flow=-fluid_a.m_flow;
  fluid_a.p=medium.p;
  fluid_b.p=medium.p;

  Q_loss=-A*sigma*em*(medium.T^4-Tamb^4)-A*h_convection*(medium.T-Tamb);
  0=ab*heat.Q_flow+Q_loss+fluid_a.m_flow*(h_in-h_out);
  Q_rcv=fluid_a.m_flow*(h_out-h_in);
  
  T_film = 0.5*(Tamb+HTF_in.T);
  Air_State_Amb.h = Air.h_Tf(Tamb);
  Air_State_Film.h = Air.h_Tf(T_film);
  k_air = Air_State_Amb.k;
  
  HTF_in.h = inStream(fluid_a.h_outflow);
  HTF_in.p = fluid_a.p;
  
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
    /*if concept == "Billboard" then
      Re = Air_State_Film.rho*max(0.0,Wspd)*D_rcv/Air_State_Film.mu; //x-scale, Film temperature
      Pr = Air_State_Film.cp*Air_State_Film.mu/Air_State_Film.k; //x-scale, Film temperature
      Gr = (9.81*(1/Tamb)*(HTF_in.T-Tamb)*(H_rcv^3))/((Air_State_Amb.mu/Air_State_Amb.rho)^2); //y-scale, Ambient temperature
      h_cn = (k_air/H_rcv)*0.098*(Gr^(1/3))*((HTF_in.T/Tamb)^(-0.14)); //y-scale, Ambient temperature
      h_cf = (k_air/D_rcv)*0.0307*(Re^0.8)*(Pr^0.6)*((HTF_in.T/Tamb)^(-0.4)); //x-scale, Film temperature
      h_c = (h_cn^3.2+h_cf^3.2)^(1/3.2);
    else //Cylindrical External*/
      Re = Air_State_Film.rho*max(0.0,Wspd_tower)*D_rcv/Air_State_Film.mu; //x-scale, Film Temperature
      Pr = Air_State_Film.cp*Air_State_Film.mu/Air_State_Film.k; //x-scale, Film Temperature
      Gr = (9.81*(1/Tamb)*(HTF_in.T-Tamb)*(D_rcv^3))/((Air_State_Amb.mu/Air_State_Amb.rho)^2); //y-scale, Ambient Temperature
      h_cn = (k_air/H_rcv)*0.098*(Gr^(1/3))*((HTF_in.T/Tamb)^(-0.14)); //y-scale, Ambient temperature
      h_cf = (k_air/D_rcv)*(0.3+0.488*(Re^0.5)*((1.0+((Re/282000)^0.625)))^0.8); //x-scale, Film temperature, smooth cylinder
      h_c = (h_cn^3.2+h_cf^3.2)^(1/3.2);
    //end if;

  end if;

end ReceiverSimple_Flat;
