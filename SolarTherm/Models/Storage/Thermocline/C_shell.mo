within SolarTherm.Models.Storage.Thermocline;

function C_shell "Cost of tank shell"
import CN = Modelica.Constants;
  input Real rho_f "density of fluid";
  input Real H "tank height";
  input Real D "tank diameter";
  input Real sigma_yield "yield strength of metal";
  input Real rho_shell "tank metal density";
  input Real pri_shell "tank USD/kg metal";
  output Real C "total cost of tank shell";
protected
  Real f_safety = 4 "safety factor of yield stress/hoop stress";
  Real t_0 = 6e-3 "minimum shell thickness";
  Real t_top = 6e-3 "roof thickness";
  Real t_bot = 8e-3 "base thickness";
  Real t_1 "thickness of wall at the base";
  Real p "pressure at the base wall";
  Real V_shell "volume of shell material used";
algorithm
  p := rho_f*9.81*H;
  t_1 := max(t_0,p*D*f_safety/(2.0*sigma_yield)); //Cannot be smaller than t_0
  V_shell := CN.pi*(H/6)*(-2.0*t_0*t_0 +4.0*t_0*t_1+4.0*t_1*t_1 +3.0*D*(t_0+t_1)) + 0.25*CN.pi*D*D*(t_top+t_bot);
  C := rho_shell*V_shell*pri_shell;
  /*
  Modelica.Utilities.Streams.print("Effective storage density (kg/m3) = "+String(rho_eff));
  Modelica.Utilities.Streams.print("Tank Height (m) = "+String(H));
  Modelica.Utilities.Streams.print("Tank Diameter (m) = "+String(D));
  Modelica.Utilities.Streams.print("Yield Stress (Pa) = "+String(sigma_yield));
  Modelica.Utilities.Streams.print("Rho shell (kg/m3) = "+String(rho_shell));
  Modelica.Utilities.Streams.print("Pri shell (USD/kg) = "+String(pri_shell));
  Modelica.Utilities.Streams.print("Pressure = "+String(p));
  Modelica.Utilities.Streams.print("Bottom thickness = "+String(t_1));
  Modelica.Utilities.Streams.print("Shell volume = "+String(V_shell));
  Modelica.Utilities.Streams.print("Shell cost (USD) = "+String(C));
  */
end C_shell;