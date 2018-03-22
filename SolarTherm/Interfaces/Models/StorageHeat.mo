within SolarTherm.Interfaces.Models;
partial model StorageHeat
  extends SolarTherm.Icons.StorageModel;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat_a annotation (
      Placement(transformation(extent={{-110,40},{-90,60}}), iconTransformation(
          extent={{-110,40},{-90,60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat_b annotation (
      Placement(transformation(extent={{90,-80},{110,-60}}), iconTransformation(
          extent={{90,-80},{110,-60}})));
end StorageHeat;
