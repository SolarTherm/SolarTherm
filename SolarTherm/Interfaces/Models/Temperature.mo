within SolarTherm.Interfaces.Models;
partial model Temperature

  extends Icons.Temperature;
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_base
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=0),
        iconTransformation(extent={{110,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealOutput T(final quantity="ThermodynamicTemperature",
                                          final unit = "K", displayUnit = "degC", min=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,94}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,102})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
              100}})),                  Diagram(coordinateSystem(
          preserveAspectRatio=false)),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Temperature;
