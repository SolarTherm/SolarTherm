within SolarTherm.Interfaces.Models;
partial model ReceiverFluid
  extends SolarTherm.Interfaces.Models.Receiver;

  Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{10,-100},{30,-80}}), iconTransformation(extent={
            {10,-100},{30,-80}})));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{24,38},{44,58}}), iconTransformation(extent={{24,
            38},{44,58}})));
  replaceable package Medium = SolarTherm.Media.MoltenSalt.MoltenSalt_base
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true);

end ReceiverFluid;
