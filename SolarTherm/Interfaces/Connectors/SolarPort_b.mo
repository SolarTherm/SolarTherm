within SolarTherm.Interfaces.Connectors;
connector SolarPort_b "Generic solar connector at design outlet"
  extends SolarTherm.Interfaces.Connectors.SolarPort;
  output Modelica.SIunits.Angle dec "Solar declination angle";
  output Modelica.SIunits.Angle hra "Solar hour angle";
  output Modelica.SIunits.Irradiance dni "Direct Solar Irradiance";
  annotation(defaultComponentName = "port_b", Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={161,80,0},
          fillColor={255,170,0},
          fillPattern=FillPattern.Solid),                                                                                                    Ellipse(
          extent={{-30,30},{30,-30}},
          lineColor={161,80,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                                                                                                    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Ellipse(lineColor = {0, 127, 255}, fillColor = {0, 127, 255},
            fillPattern =                                                                                                   FillPattern.Solid, extent = {{-100, 100}, {100, -100}}, endAngle = 360), Ellipse(
          fillColor={255,170,0},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}},
          endAngle=360,
          lineColor={161,80,0}),                                                                                                    Ellipse(
          lineColor={161,80,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80,80},{80,-80}},
          endAngle=360)}),
    Documentation(info="<html>
<p><span style=\"font-family: MS Shell Dlg 2;\">This connector provide the sun position with respect the position of the solar plant at the Earth&apos;s surface. The direct solar irradiance is also provided, in order to be able to calculate the collected energy at the devices. This connector have the causality defined:</span></p>
<ul>
<li><b><span style=\"font-family: MS Shell Dlg 2;\">SolarPort_a</b> should be used in collector models.</span></li>
<li><b><span style=\"font-family: MS Shell Dlg 2;\">SolarPort_b</b> should be used in sun models.</span></li>
</ul>
</html>"));
end SolarPort_b;
