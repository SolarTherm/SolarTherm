within SolarTherm.Models.Control;
model PI_reset
  extends Modelica.Blocks.Continuous.PI;
  Modelica.Blocks.Interfaces.BooleanInput reset annotation(Placement(visible=true, transformation(origin={-120,-60}, extent={{-20,-20},{20,20}}, rotation=0), iconTransformation(origin={-120,-80}, extent={{-20,-20},{20,20}}, rotation=-360)));
equation
  when reset then
    reinit(x, (y_start/k)-u);
  end when;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PI_reset;
