within SolarTherm.Types;
function to_dollarperMWh
  "Convert from dollar per Joule to dollar per mega Watt hour"
  extends Modelica.SIunits.Icons.Conversion;
  input SolarTherm.Types.EnergyPrice dpJ "Dollar per Joule value";
  output SolarTherm.Types.EnergyPrice_kWh dpMWh "Dollar per MWh value";
algorithm
  dpMWh := dpJ*(3.6e9);
  annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-20,100},{-100,54}},
          lineColor={0,0,0},
          textString="$/J"), Text(
          extent={{100,-50},{-10,-100}},
          lineColor={0,0,0},
          textString="$/MWh")}));
end to_dollarperMWh;
