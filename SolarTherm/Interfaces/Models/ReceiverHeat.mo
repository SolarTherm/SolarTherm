within SolarTherm.Interfaces.Models;
partial model ReceiverHeat
  extends SolarTherm.Interfaces.Models.Receiver;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat_a annotation (
      Placement(transformation(extent={{22,40},{42,60}}), iconTransformation(
          extent={{22,40},{42,60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat_b annotation (
      Placement(transformation(extent={{10,-100},{30,-80}}), iconTransformation(
          extent={{10,-100},{30,-80}})));
end ReceiverHeat;
