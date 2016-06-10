within SolarTherm.Interfaces.Connectors;
connector SolarPort_a "Generic solar connector at design inlet"
  extends SolarTherm.Interfaces.Connectors.SolarPort;
  input Modelica.SIunits.Angle dec "Solar declination angle";
  input Modelica.SIunits.Angle hra "Solar hour angle";
  input Modelica.SIunits.Irradiance dni "Direct Solar Irradiance";
  annotation(defaultComponentName = "port_a", Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={161,80,0},
          fillColor={255,170,0},
          fillPattern=FillPattern.Solid)}),                                                                                                    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={  Ellipse(lineColor=  {0, 127, 255}, fillColor=  {0, 127, 255},
            fillPattern=                                                                                                    FillPattern.Solid, extent=  {{-100, 100}, {100, -100}}, endAngle=  360), Ellipse(
          fillColor={255,170,0},
          fillPattern=FillPattern.Solid,
          extent={{-100,100},{100,-100}},
          endAngle=360,
          lineColor={161,80,0})}),
    Documentation(info="<html>
<p>This connector provide the sun position with respect the position of the solar plant at the Earth&apos;s surface. The direct solar irradiance is also provided, in order to be able to calculate the collected energy at the devices. This connector have the causality defined:</p>
<ul>
<li><b>SolarPort_a</b> should be used in collector models.</li>
<li><b><span style=\"font-family: MS Shell Dlg 2;\">SolarPort_b</b> should be used in sun models.</span></li>
</ul>
</html>"));
end SolarPort_a;
