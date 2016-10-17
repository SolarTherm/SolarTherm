within SolarTherm.Types;
function to_MWh "Convert from Joule to mega Watt hour"
  extends Modelica.SIunits.Icons.Conversion;
  input SI.Energy J "Joule value";
  output SolarTherm.Types.Energy_MWh MWh "MWh value";
algorithm
  MWh := J/(3.6e9);
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-20,100},{-100,54}},
          lineColor={0,0,0},
          textString="J"), Text(
          extent={{100,-50},{-10,-100}},
          lineColor={0,0,0},
          textString="MWh")}));
end to_MWh;
