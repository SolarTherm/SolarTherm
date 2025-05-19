within SolarTherm.Systems.H2DRI_Applications;

function recv_h
  input Real m_dot "Receiver mass flow rate (kg/s)";
  output Real h "Effective receiver convective heat loss coef (W/m2K)";
protected
  constant Real h0 = 120.4;
  constant Real h1 = 0.4002;
  constant Real h2 = -0.001664;
  constant Real h3 = 3.422e-6;
  constant Real h4 = -2.786e-09; 
algorithm
  h := h0 + h1*m_dot + h2*(m_dot^2.0) + h3*(m_dot^3.0) + h4*(m_dot^4.0);
end recv_h;