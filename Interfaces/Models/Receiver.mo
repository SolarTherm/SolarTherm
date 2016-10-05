within SolarTherm.Interfaces.Models;
partial model Receiver
  extends SolarTherm.Icons.ReceiverModel;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat annotation (
      Placement(transformation(extent={{-110,20},{-90,40}}), iconTransformation(
          extent={{-110,20},{-90,40}})));

end Receiver;
