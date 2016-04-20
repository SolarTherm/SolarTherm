within SolarTherm.Receivers;
partial model Receiver "Partial receiver model"
 import SI = Modelica.SIunits;
 parameter Integer nelem = 1 "Number of aperture elements";
 input SolarTherm.Interfaces.WeatherBus wbus;
 input SI.RadiantPower R[nelem] "Radiant power on aperture";
end Receiver;
