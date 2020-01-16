within SolarTherm.Interfaces.Models;
partial model StorageFluid4P
  extends SolarTherm.Icons.StorageModel;
  Modelica.Fluid.Interfaces.FluidPort_a fluid_ar(redeclare package Medium = Medium) annotation (Placement(
        transformation(extent={{-110,40},{-90,60}}), iconTransformation(extent={
            {-110,40},{-90,60}})));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_br(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{-110, -80}, {-90, -60}}, rotation = 0), iconTransformation(extent = {{-110, -80}, {-90, -60}}, rotation = 0)));
        
  Modelica.Fluid.Interfaces.FluidPort_a fluid_ap(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{90, -80}, {110, -60}}, rotation = 0), iconTransformation(extent = {{90, -80}, {110, -60}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b fluid_bp(redeclare package Medium = Medium) annotation (Placement(
        visible = true,transformation(extent = {{90, 40}, {110, 60}}, rotation = 0), iconTransformation(extent = {{90, 40}, {110, 60}}, rotation = 0)));
  replaceable package Medium = SolarTherm.Media.Sodium.Sodium_dTX
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choicesAllMatching = true,Dialog(group="Working fluid"));
end StorageFluid4P;