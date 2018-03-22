within SolarTherm.Icons;
partial class PowerBlock

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          extent={{-60,-40},{60,-80}},
          fillColor={122,122,122},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-40,50},{40,50},{60,-60},{-60,-60},{-40,50}},
          fillColor={122,122,122},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-40,60},{40,40}},
          lineColor={122,122,122},
          fillColor={165,165,165},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-28,-20},{0,-10},{-8,-4},{-28,-20}},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,-2},{-10,-12},{-2,-18},{18,-2}},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PowerBlock;
