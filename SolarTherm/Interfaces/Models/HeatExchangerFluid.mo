within SolarTherm.Interfaces.Models;
partial model HeatExchangerFluid
  extends Icons.HeatExchangerModel2;

  replaceable package MA = Modelica.Media.Water.StandardWater constrainedby
    Modelica.Media.Interfaces.PartialMedium "Medium in one side"
      annotation (choicesAllMatching = true,Dialog(__Dymola_label="Medium A"));
  replaceable package MB = Modelica.Media.Water.StandardWater
  constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the other side"
      annotation (choicesAllMatching = true,Dialog(__Dymola_label="Medium B"));
  Modelica.Fluid.Interfaces.FluidPort_a port_a_in(redeclare package Medium =
        MA)
    annotation (Placement(transformation(extent={{-96,20},{-76,40}}),
        iconTransformation(extent={{-68,20},{-58,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_a_out(redeclare package Medium =
        MA)
    annotation (Placement(transformation(extent={{72,-22},{92,-2}}),
        iconTransformation(extent={{58,-10},{68,0}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_b_in(redeclare package Medium =
        MB)
    annotation (Placement(transformation(extent={{22,-36},{42,-16}}),
        iconTransformation(extent={{22,-32},{32,-22}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b_out(redeclare package Medium =
        MB)
    annotation (Placement(transformation(extent={{-38,42},{-18,62}}),
        iconTransformation(extent={{-34,40},{-24,50}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatExchangerFluid;
