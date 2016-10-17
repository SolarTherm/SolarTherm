within SolarTherm.Types;
function from_MWh "Convert from mega Watt hour to Joule"
  extends Modelica.SIunits.Icons.Conversion;
  input SolarTherm.Types.Energy_MWh MWh "MWh value";
  output SI.Energy J "Joule value";
algorithm
  J := 3.6e9*MWh;
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{12,100},{-100,52}},
          lineColor={0,0,0},
          textString="MWh"), Text(
          extent={{100,-44},{12,-100}},
          lineColor={0,0,0},
          textString="J")}));
end from_MWh;
