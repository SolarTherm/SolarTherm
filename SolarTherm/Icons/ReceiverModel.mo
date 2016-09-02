within SolarTherm.Icons;
partial class ReceiverModel

      annotation(Icon(graphics={
        Rectangle(
          origin={-21,38},
          fillColor={108,108,108},
          fillPattern=FillPattern.VerticalCylinder,
          extent={{-13,40},{55,-18}},
          lineColor={0,0,0}),
        Line(
          origin={-56,44},
          points={{-40,-24},{20,0}},
          color={255,170,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          origin={-56,54},
          points={{-40,0},{20,0}},
          color={255,170,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Line(
          origin={-56,32},
          points={{-40,-40},{20,0}},
          color={255,170,0},
          thickness=0.5,
          arrow={Arrow.None,Arrow.Filled}),
        Rectangle(
          extent={{-20,20},{20,-100}},
          lineColor={129,129,129},
          fillColor={179,179,179},
          fillPattern=FillPattern.VerticalCylinder)},
        coordinateSystem(initialScale = 0.1)), Diagram);
end ReceiverModel;
