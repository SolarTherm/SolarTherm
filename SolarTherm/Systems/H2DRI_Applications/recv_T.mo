within SolarTherm.Systems.H2DRI_Applications;

function recv_T
  input Real m_dot "Receiver mass flow rate (kg/s)";
  output Real T "Effective receiver Temperature (K)";
protected
  constant Real t0 = 1028.0;
  constant Real t1 = -1.568;
  constant Real t2 = 0.01054;
  constant Real t3 = -2.589e-5;
  constant Real t4 = 2.342e-8;
algorithm
  T := t0 + t1*m_dot + t2*(m_dot^2.0) + t3*(m_dot^3.0) + t4*(m_dot^4.0);
end recv_T;