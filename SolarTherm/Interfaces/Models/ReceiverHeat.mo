within SolarTherm.Interfaces.Models;
partial model ReceiverHeat
  extends SolarTherm.Interfaces.Models.Receiver;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heat_a annotation (
      Placement(visible = true,transformation(extent = {{22, 40}, {42, 60}}, rotation = 0), iconTransformation(
          extent = {{-110, 20}, {-90, 40}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat_b annotation (
      Placement(visible = true,transformation(extent = {{10, -100}, {30, -80}}, rotation = 0), iconTransformation(
          extent = {{24, 40}, {44, 60}}, rotation = 0)));
end ReceiverHeat;