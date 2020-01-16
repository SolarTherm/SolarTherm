within SolarTherm.Interfaces.Models;
partial model Lift
  extends Icons.LiftModel;
  replaceable package Medium = SolarTherm.Media.SolidParticles.CarboHSP_ph
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(visible = true,transformation(extent={{-110,-12},{-90,8}},  rotation=
           0), iconTransformation(extent = {{24, 0}, {44, 20}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(visible = true,transformation(extent={{110,-10},{90,10}}, rotation=0), iconTransformation(extent = {{-28, 0}, {-48, 20}}, rotation = 0)));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
              100}})),                  Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end Lift;