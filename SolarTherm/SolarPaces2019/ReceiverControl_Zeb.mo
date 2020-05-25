within SolarTherm.SolarPaces2019;

model ReceiverControl_Zeb
  extends Icons.Control;
  parameter Real T_df_on=1123 "Level of start defocus";
  parameter Real T_df_off=1098 "Level of stop defocus";
  Modelica.Blocks.Interfaces.RealInput T_HTF "Temperature of the HTF in storage"
    annotation (Placement(transformation(extent={{-130,40},{-90,80}})));
    Modelica.Blocks.Interfaces.BooleanOutput defocus(start=false) annotation (Placement(visible = true, transformation(origin = {106,0}, extent = {{-12, -10}, {12, 10}}, rotation = 0), iconTransformation(origin = {106,0}, extent = {{-12, -10}, {12, 10}}, rotation = 0)));
algorithm
  when T_HTF > T_df_on then
    defocus := true;
  end when;
  when T_HTF < T_df_off then
    defocus := false;
  end when;
end ReceiverControl_Zeb;