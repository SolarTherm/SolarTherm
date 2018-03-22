within SolarTherm.Types;
function from_year "Convert from year to second"
  extends Modelica.SIunits.Icons.Conversion;
  input SolarTherm.Types.Time_year year "year value";
  output Modelica.SIunits.Time s "second value";
algorithm
  s := (60*60*24*365)*year;
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{10,100},{-100,52}},
          lineColor={0,0,0},
          textString="year"), Text(
          extent={{100,-54},{20,-100}},
          lineColor={0,0,0},
          textString="s")}));
end from_year;
