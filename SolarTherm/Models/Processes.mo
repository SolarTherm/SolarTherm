within SolarTherm.Models;
package Processes
  extends Modelica.Icons.Package;

  model GenericThermalProcess
  	extends SolarTherm.Icons.Thermal;
  	Modelica.Blocks.Interfaces.RealInput Q_in "Thermal power input" 
  		annotation(
  		Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), 
  		iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  	Modelica.Blocks.Interfaces.RealInput Q_schedule annotation (
  		Placement(transformation(extent={{-16,-16},{16,16}},rotation=-90,origin={0,108}), 
  		iconTransformation(extent={{-11,-11},{11,11}},rotation=-90,origin={-41,97})));
  
  equation
  	Q_in - Q_schedule = 0;	
  end GenericThermalProcess;
  annotation(
  	Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
  		Line(
		  origin={-47.5,11.6667},
		  points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
  		  smooth=Smooth.Bezier),
  		Polygon(
		  origin={-50.0,68.333},
		  pattern=LinePattern.None,
		  fillPattern=FillPattern.Solid,
  		  points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}}),
  		Line(
		  origin={2.5,11.6667},
		  points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
  		  smooth=Smooth.Bezier),
  		Polygon(
		  origin={0.0,68.333},
		  pattern=LinePattern.None,
		  fillPattern=FillPattern.Solid,
  		  points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}}),
  		Line(
		  origin={52.5,11.6667},
		  points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
  		  smooth=Smooth.Bezier),
  		Polygon(
		  origin={50.0,68.333},
		  pattern=LinePattern.None,
		  fillPattern=FillPattern.Solid,
  		  points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}})}),
    Documentation(info="<html>
<p>
This package contains libraries to model heat processes.
</p>
</html>"));
end Processes;