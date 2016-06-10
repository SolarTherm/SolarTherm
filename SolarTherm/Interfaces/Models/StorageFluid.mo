within SolarTherm.Interfaces.Models;
partial model StorageFluid
  extends SolarTherm.Icons.StorageModel;
  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,40},{-90,60}}), iconTransformation(extent={
            {-110,40},{-90,60}})));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{90,-80},{110,-60}}), iconTransformation(extent={
            {90,-80},{110,-60}})));
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_base
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true);
end StorageFluid;
