within SolarTherm.Icons;
partial class GridInput
protected
  constant Modelica.SIunits.Length towerHeight = 60; // height of the tower
  constant Modelica.SIunits.Length bladeLength = 40; // length of one blade
  constant Modelica.SIunits.Angle bladeAngle = 120; // angle between blades
  constant Modelica.SIunits.Length panelWidth = 60; // width of the PV panel
  constant Modelica.SIunits.Length panelHeight = 30; // height of the PV panel
public
	annotation(
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100, -100}, {100, 100}}),
      graphics={
	    Text(
		origin = {-10, 254}, 
		lineColor = {0, 0, 255}, 
		extent = {{-160, -114}, {160, -154}}, 
		textString = "%name"),
        // Draw the elevated wind turbine tower
        Line(
          points={{-60, -50}, {-60, 50}}, // coordinates are from bottom to top of the tower, moved up
          color={0, 0, 0},
          thickness=3),
        // Draw the turbine hub
        Ellipse(
          extent={{-75, 65}, {-45, 35}}, // coordinates for the circle representing the hub
          lineColor={0, 0, 0},
          fillColor={255, 255, 255},
          fillPattern=FillPattern.Solid),
        // Draw turbine blades
        Line(
          points={{-60, 50}, {-60 + bladeLength*cos(bladeAngle*Modelica.Constants.pi/180),
                                50 + bladeLength*sin(bladeAngle*Modelica.Constants.pi/180)}},
          color={0, 0, 0},
          thickness=3),
        Line(
          points={{-60, 50}, {-60 + bladeLength*cos(2*bladeAngle*Modelica.Constants.pi/180),
                                50 + bladeLength*sin(2*bladeAngle*Modelica.Constants.pi/180)}},
          color={0, 0, 0},
          thickness=3),
        Line(
          points={{-60, 50}, {-60 + bladeLength*cos(3*bladeAngle*Modelica.Constants.pi/180),
                                50 + bladeLength*sin(3*bladeAngle*Modelica.Constants.pi/180)}},
          color={0, 0, 0},
          thickness=3),
        // Draw multiple PV panels manually
         // First panel
        Rectangle(
          extent={{10, -50}, {70, -20}},
          lineColor={0, 0, 0},
          fillColor={114, 159, 207},
          fillPattern=FillPattern.Solid),
        Line(points={{10, -40}, {70, -40}}, color={0, 0, 0}),
        Line(points={{10, -30}, {70, -30}}, color={0, 0, 0}),
        Line(points={{40, -50}, {40, -20}}, color={0, 0, 0}),
        // Second panel
        Rectangle(
          extent={{15, -55}, {75, -25}},
          lineColor={0, 0, 0},
          fillColor={114, 159, 207},
          fillPattern=FillPattern.Solid),
        Line(points={{15, -45}, {75, -45}}, color={0, 0, 0}),
        Line(points={{15, -35}, {75, -35}}, color={0, 0, 0}),
        Line(points={{45, -55}, {45, -25}}, color={0, 0, 0}),
        // Third panel
        Rectangle(
          extent={{20, -60}, {80, -30}},
          lineColor={0, 0, 0},
          fillColor={114, 159, 207},
          fillPattern=FillPattern.Solid),
        Line(points={{20, -50}, {80, -50}}, color={0, 0, 0}),
        Line(points={{20, -40}, {80, -40}}, color={0, 0, 0}),
        Line(points={{50, -60}, {50, -30}}, color={0, 0, 0}),

        // Draw multiple PV panels manually with segment lines, moved upwards by 50 units
        // First panel (now at the lowest, was third originally)
        Rectangle(
          extent={{10, 10}, {70, 40}},
          lineColor={0, 0, 0},
          fillColor={114, 159, 207},
          fillPattern=FillPattern.Solid),
        Line(points={{10, 20}, {70, 20}}, color={0, 0, 0}),
        Line(points={{10, 30}, {70, 30}}, color={0, 0, 0}),
        Line(points={{40, 10}, {40, 40}}, color={0, 0, 0}),
        // Second panel (now in the middle, was second originally)
        Rectangle(
          extent={{15, 5}, {75, 35}},
          lineColor={0, 0, 0},
          fillColor={114, 159, 207},
          fillPattern=FillPattern.Solid),
        Line(points={{15, 15}, {75, 15}}, color={0, 0, 0}),
        Line(points={{15, 25}, {75, 25}}, color={0, 0, 0}),
        Line(points={{45, 5}, {45, 35}}, color={0, 0, 0}),
        // Third panel (now at the top, was first originally)
        Rectangle(
          extent={{20, 0}, {80, 30}}, // Moved up by 50 units
          lineColor={0, 0, 0},
          fillColor={114, 159, 207},
          fillPattern=FillPattern.Solid),
        Line(points={{20, 10}, {80, 10}}, color={0, 0, 0}),
        Line(points={{20, 20}, {80, 20}}, color={0, 0, 0}),
        Line(points={{50, 0}, {50, 30}}, color={0, 0, 0})
	})
);
end GridInput;