within SolarTherm.Types;
function from_dollarperMWh
  "Convert from dollar per mega Watt hour to dollar per Joule"
  extends Modelica.SIunits.Icons.Conversion;
  input SolarTherm.Types.EnergyPrice_MWh dpMWh "Dollar per MWh value";
  output SolarTherm.Types.EnergyPrice dpJ "Dollar per Joule value";
algorithm
  dpJ := dpMWh/(3.6e9);
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{12,100},{-100,52}},
          lineColor={0,0,0},
          textString="$/MWh"), Text(
          extent={{100,-44},{12,-100}},
          lineColor={0,0,0},
          textString="$/J")}));
end from_dollarperMWh;
