within SolarTherm.Utilities.Blocks;

block Bound
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real low = 0.0;
  parameter Real high = 1.0;
equation
  y = min(high,max(low, u));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Text(origin = {0, 64}, lineColor = {160, 160, 164}, extent = {{-90, 36}, {90, -36}}, textString = "max = %high"), Text(origin = {0, -66}, lineColor = {160, 160, 164}, extent = {{-90, 36}, {90, -36}}, textString = "min = %low")}), Documentation(info= "<html><head></head><body><p>
This block returns the output <b>y</b>&nbsp;as the real value of <b>u</b>&nbsp;bound between <b>maxval </b>and <b>minval</b>.</p>
<pre>    y = min ( high, <strong>max</strong> ( low , u ) );
</pre>
</body></html>"));
end Bound;