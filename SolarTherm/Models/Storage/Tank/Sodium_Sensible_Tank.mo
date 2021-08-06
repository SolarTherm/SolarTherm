within SolarTherm.Models.Storage.Tank;
model Sodium_Sensible_Tank
  import CN = Modelica.Constants;
  import CV = Modelica.SIunits.Conversions;
  extends Interfaces.Models.StorageFluid_TwoTanks;
  replaceable package Fluid_Package = SolarTherm.Materials.Sodium_Table;
  replaceable package Tank_Package_Hot = SolarTherm.Materials.SS316L;
  replaceable package Tank_Package_Cold = SolarTherm.Materials.SS316L;
  
  //Fluid Material States
  Fluid_Package.State fluid_hot "Model which calculates properties at inlet of the section";
  Fluid_Package.State fluid_cold "Model which calculates properties at outlet of the section";
  
  //Storage Parameter Settings
  parameter SI.Energy E_max = 144.0e9 "Maximum storage capacity";
  parameter Real ar = 1.0 "Aspect ratio of tanks";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank = 0.0 "W/m2K";//0.4 for 2tank molten salt.
  parameter SI.Temperature T_min = CV.from_deg(520) "Cold tank design temperature";
  parameter SI.Temperature T_max = CV.from_deg(740) "Hot tank design temperature";
  
  parameter SI.SpecificEnthalpy h_min = Fluid_Package.h_Tf(T_min,0.0) "Cold tank design enthalpy";
  parameter SI.SpecificEnthalpy h_max = Fluid_Package.h_Tf(T_max,1.0) "Hot tank design enthalpy";
  
  parameter SI.Density rho_cold = Fluid_Package.rho_Tf(T_min,0.0) "Cold tank fluid density";
  parameter SI.Density rho_hot = Fluid_Package.rho_Tf(T_max,1.0) "Hot tank fluid density";
  
  parameter SI.Mass m_total = E_max/(h_max-h_min) "Total mass of HTF (kg)";
  
  parameter SI.Temperature T_cold_set = CV.from_deg(500) "Minimum cold tank temperature when aux heater is triggered";
  parameter SI.Temperature T_hot_set = CV.from_deg(720) "Minimum hot tank temperature when aux heater is triggered";
  
  parameter SI.Diameter D_tank_hot=H_tank_hot/ar "Diameter";
  parameter SI.Height H_tank_hot=(4.0*V_tank_hot*(ar^2)/(CN.pi))^(1.0/3.0) "Height";
  parameter SI.Volume V_tank_hot=m_total/rho_hot;
  parameter SI.Area A_surf_tank_hot=0.25*CN.pi*D_tank_hot*D_tank_hot*H_tank_hot "Total hot tank surface area";
  
  parameter SI.Diameter D_tank_cold=H_tank_cold/ar "Diameter";
  parameter SI.Height H_tank_cold=(4.0*V_tank_cold*(ar^2)/(CN.pi))^(1.0/3.0) "Height";
  parameter SI.Volume V_tank_cold=m_total/rho_cold;
  parameter SI.Area A_surf_tank_cold=0.25*CN.pi*D_tank_cold*D_tank_cold*H_tank_cold "Total cold tank surface area";

  parameter Real L_start=0.01 "Percentage level of hot tank to start";
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_hot=0.0 "Heat loss coefficient of hot tank"; 
  parameter SI.CoefficientOfHeatTransfer U_loss_tank_cold=U_loss_tank_hot "Heat loss coefficient of cold tank";

  parameter SI.Power W_max= 30e8 "Hot Tank Heater Capacity";
  parameter SI.Efficiency e_ht=0.99 "Tank Heater Efficiency";
  
  parameter Real C_filler = 0.0;
  parameter Real C_fluid = m_total*Fluid_Package.cost;
  parameter Real C_total = C_filler + C_fluid + C_tank + C_insulation + C_encapsulation;
  parameter Real C_tank = C_shell_hot + C_shell_cold;
  parameter Real C_insulation = C_insulation_cold + C_insulation_hot;
  parameter Real C_insulation_hot = if U_loss_tank_hot > 1e-3 then CpA_external_insulation(T_max,U_loss_tank_hot)*A_surf_tank_hot else 0.0;
  parameter Real C_insulation_cold = if U_loss_tank_cold > 1e-3 then CpA_external_insulation(T_min,U_loss_tank_cold)*A_surf_tank_cold else 0.0;
  parameter Real C_encapsulation = 0.0;//No encapsulation exists
  
  parameter Real C_shell_hot = SolarTherm.Models.Storage.Thermocline.C_shell(rho_hot,H_tank_hot,D_tank_hot,Tank_Package_Hot.sigma_yield(T_max),Tank_Package_Hot.rho_Tf(298.15,0.0),4.0);
  parameter Real C_shell_cold = SolarTherm.Models.Storage.Thermocline.C_shell(rho_cold,H_tank_cold,D_tank_cold,Tank_Package_Cold.sigma_yield(T_min),Tank_Package_Cold.rho_Tf(298.15,0.0),4.0);
  
  Modelica.Blocks.Interfaces.RealOutput h_tank_outlet_hot = fluid_hot.h "Enthalpy of hot_tank fluid" annotation (Placement(visible = true, transformation(origin = {107, 3}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {61, 73}, extent = {{-5, -5}, {5, 5}}, rotation = 0))) ;
  
  Modelica.Blocks.Interfaces.RealOutput h_tank_outlet_cold = fluid_cold.h "Enthalpy of cold_tank fluid" annotation (Placement(visible = true, transformation(origin = {107, 3}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = { -57, -27}, extent = {{5, -5}, {-5, 5}}, rotation = 0))) ;
  
  Modelica.Blocks.Interfaces.RealOutput L_hot "Hot Tank level in %"
                                          annotation (Placement(visible = true,transformation(
          extent = {{96, 44}, {116, 64}}, rotation = 0), iconTransformation(origin = {61, 33}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  
  Modelica.Blocks.Interfaces.RealOutput L_cold "Cold Tank level in %"
                                          annotation (Placement(visible = true,transformation(
          extent = {{96, 44}, {116, 64}}, rotation = 0), iconTransformation(origin = {-57, -65}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  
  SI.Volume V_hot "Volume of hot fluid (m3)";
  SI.Volume V_cold "Volume of cold fluid (m3)";

  SI.Mass m_hot (start=(L_start)*m_total) "Mass of hot fluid (kg)";
  SI.Mass m_cold (start=m_total-(L_start)*m_total) "Mass of cold fluid (kg)";

  Medium.BaseProperties medium_hot;
  Medium.BaseProperties medium_cold;

  SI.Area A_loss_hot "heat loss area of hot tank (m2)";
  SI.Area A_loss_cold "heat loss area of cold tank (m2)";
  
  SI.HeatFlowRate Q_loss_hot "Heat loss rate of hot tank (Wth)";
  SI.HeatFlowRate Q_loss_cold "Heat loss rate of cold tank (Wth)";

  SI.Power W_net_hot "Net electrical consumption of hot aux heater (We)";
  SI.Power W_loss_hot "Gross heat consumption of hot aux heater (Wth)";
  
  SI.Power W_net_cold "Net electrical consumption of cold aux heater (We)";
  SI.Power W_loss_cold "Gross heat consumption of cold aux heater (Wth)";
      
  Modelica.Blocks.Interfaces.RealInput p_amb annotation (Placement(
        visible = true,transformation(
        
        origin={0,108},extent={{-16,-16},{16,16}},
        rotation=-90), iconTransformation(
        
        origin={38, 98},extent={{-8, -8}, {8, 8}},
        rotation=-90)));

  Modelica.Blocks.Interfaces.RealInput T_amb annotation (Placement(
        visible = true,transformation(
        
        origin={0,108},extent={{-16,-16},{16,16}},
        rotation=-90), iconTransformation(
        
        origin={-30, 98},extent={{-8, -8}, {8, 8}},
        rotation=-90)));


algorithm
  //Hot tank Aux heater
  when fluid_hot.T<T_hot_set then
	W_net_hot:=min(-Q_loss_hot,W_max)*1.05;
  elsewhen fluid_hot.T>T_hot_set+1.0 then
	W_net_hot:=0;
  end when;
  
  //Cold tank Aux heater
  when fluid_cold.T<T_cold_set then
	W_net_cold:=min(-Q_loss_cold,W_max)*1.05;
  elsewhen fluid_cold.T>T_cold_set+1.0 then
	W_net_cold:=0;
  end when;

initial equation
  fluid_cold.h = h_min;
  fluid_hot.h = h_max;
  //medium.h=Medium.specificEnthalpy(state_i);
  //m=Medium.density(state_i)*V_t*L_start/100;
equation
  Q_loss_hot = -1.0*A_loss_hot*U_loss_tank_hot*(fluid_hot.T - T_amb); //negative is heat loss
  Q_loss_cold = -1.0*A_loss_cold*U_loss_tank_cold*(fluid_cold.T - T_amb);

  medium_cold.p = p_amb;
  medium_hot.p = p_amb;
  medium_cold.h = fluid_cold.h;
  medium_hot.h = fluid_hot.h;
  
  
  fluid_hb.h_outflow = medium_hot.h; //Hot tank outlet
  fluid_cb.h_outflow = medium_cold.h; //Cold tank outlet
  
  fluid_ha.p = p_amb;
  fluid_hb.p = p_amb;
  fluid_ca.p = p_amb;
  fluid_cb.p = p_amb;
  
  //Hot tank conservation equations
  der(m_hot) = fluid_ha.m_flow + fluid_hb.m_flow;
  m_hot*der(fluid_hot.h)+ fluid_hot.h*der(m_hot) = Q_loss_hot + W_net_hot + fluid_ha.m_flow*inStream(fluid_ha.h_outflow) + fluid_hb.m_flow*fluid_hot.h;
  
  //Cold tank conservation equations
  der(m_cold) = fluid_ca.m_flow + fluid_cb.m_flow;
  m_cold*der(fluid_cold.h) + fluid_cold.h*der(m_cold) = Q_loss_cold + W_net_cold + fluid_ca.m_flow*inStream(fluid_ca.h_outflow) + fluid_cb.m_flow*fluid_cold.h;
  
  //Hot tank Level
  V_hot = m_hot/fluid_hot.rho;
  L_hot = V_hot/V_tank_hot;
  A_loss_hot = 2.0*CN.pi*(D_tank_hot/2.0)*H_tank_hot*(L_hot/100.0);
  
  //Cold tank Level
  V_cold = m_cold/fluid_cold.rho;
  L_cold = V_cold/V_tank_cold;
  A_loss_cold = 2.0*CN.pi*(D_tank_cold/2.0)*H_tank_cold*(L_cold/100.0);

  W_loss_hot=W_net_hot/e_ht;
  W_loss_cold=W_net_cold/e_ht;
  
  //Trivial equations
  fluid_ha.h_outflow = fluid_hot.h;
  fluid_ca.h_outflow = fluid_cold.h;

  annotation (Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Text(origin = {-55, 99}, extent = {{-11, 13}, {11, -13}}, textString = "T_amb"), Text(origin = {63, 99}, extent = {{-11, 13}, {11, -13}}, textString = "p_amb")}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>Zebedee Kee July 2021:<br>Released first version. </li>
</ul>
</html>"));
end Sodium_Sensible_Tank;