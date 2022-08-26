within SolarTherm.Interfaces.Models;
partial model Dish
  extends SolarTherm.Icons.DishModel;
  Connectors.SolarPort_a solar annotation (Placement(transformation(extent={{
            -10,90},{10,110}}), iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat annotation (
      Placement(transformation(extent={{92,40},{112,60}}), iconTransformation(
          extent={{92,40},{112,60}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dish;