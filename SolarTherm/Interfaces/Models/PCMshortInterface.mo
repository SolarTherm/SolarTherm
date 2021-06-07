within SolarTherm.Interfaces.Models;

partial model PCMshortInterface
extends Icons.PCMshortIcon;
Modelica.Fluid.Interfaces.FluidPort_a fluid_a(redeclare package
    Medium =                                                             Medium) annotation (Placement(
      transformation(extent={{-10,30},{10,50}}),   iconTransformation(extent={{-10,30},
          {10,50}})));
Modelica.Fluid.Interfaces.FluidPort_b fluid_b(redeclare package
    Medium =                                                             Medium) annotation (Placement(
      transformation(extent={{-10,-48},{10,-28}}), iconTransformation(extent={{-10,-48},
          {10,-28}})));
replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium
  "Working fluid in the component"
    annotation (choicesAllMatching = true,Dialog(group="Media"));
replaceable package Salt =
    PCM.PCMsalt.Na2CO3_NaCl constrainedby PCM.PCMsalt.PartialSalt
  "Salt in the component"
    annotation (choicesAllMatching = true,Dialog(group="Media"));
end PCMshortInterface;
