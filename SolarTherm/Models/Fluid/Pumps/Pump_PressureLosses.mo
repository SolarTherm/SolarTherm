within SolarTherm.Models.Fluid.Pumps;
model Pump_PressureLosses
  extends SolarTherm.Interfaces.Models.Pump;
  Modelica.Blocks.Interfaces.RealInput m_flow annotation (Placement(
        visible = true,transformation(
        
        origin={-10, 78},extent={{-20,-20},{20,20}},
        rotation=-90), iconTransformation(
        
        origin={0,86},extent={{-14,-14},{14,14}},
        rotation=-90)));
  parameter Real k_loss(unit="J/kg")=0.55e3;
  parameter Real eff_pump=0.75;
  SI.Power W_loss;
  Medium.ThermodynamicState state_input_medium;
  SI.Density rho_medium;
  Modelica.Blocks.Interfaces.RealInput Dp_loss annotation (Placement(
      visible = true, transformation(
      
      origin = {-1, -113},extent = {{15, -15}, {-15, 15}},
      rotation = -90)));
  
equation
  fluid_b.m_flow=-m_flow;
  fluid_a.m_flow=m_flow;
  fluid_a.h_outflow=fluid_b.h_outflow;
  fluid_b.h_outflow=inStream(fluid_a.h_outflow);
  fluid_a.Xi_outflow=fluid_b.Xi_outflow;
  fluid_b.Xi_outflow=inStream(fluid_a.Xi_outflow);
  state_input_medium = Medium.setState_phX(fluid_a.p, inStream(fluid_a.h_outflow));
  rho_medium = Medium.density(state_input_medium);
  W_loss=m_flow*k_loss+m_flow*Dp_loss/rho_medium/eff_pump;    
  
  annotation (Documentation(revisions="<html>
<ul>
<li><i>Jan 2020</i> by Salvatore Guccione:<br>
		Released first version.</li>
</ul>
</html>"));
end Pump_PressureLosses;