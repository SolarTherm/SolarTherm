within SolarTherm.Interfaces.Models;
partial model Receiver_Dish
  extends SolarTherm.Icons.ReceiverDishModel;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heat annotation (
      Placement(visible = true,transformation(extent = {{-110, 20}, {-90, 40}}, rotation = 0), iconTransformation(
          extent = {{-110, 18}, {-90, 38}}, rotation = 0)));

end Receiver_Dish;