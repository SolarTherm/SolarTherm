within SolarTherm.Types;
function to_year "Convert from second to year"
  extends Modelica.SIunits.Icons.Conversion;
  input SI.Time s "second value";
  output SolarTherm.Types.Time_year year "year value";
algorithm
  year := s/(60*60*24*365);
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-6,100},{-100,48}},
          lineColor={0,0,0},
          textString="s"), Text(
          extent={{100,-48},{-10,-98}},
          lineColor={0,0,0},
          textString="year")}));
end to_year;
