within SolarTherm.Systems.H2DRI_Applications;

function recv_refl
  input Real m_dot "Receiver mass flow rate (kg/s)";
  output Real refl "Effective receiver reflectance";
protected
  constant Real r0 = 0.209 "Polynomial deg-0 coefficient";
  constant Real r1 = -0.001906;
  constant Real r2 = 1.007e-5;
  constant Real r3 = -2.41e-8;
  constant Real r4 = 2.142e-11;
algorithm
  refl := r0 + r1*m_dot + r2*(m_dot^2.0) + r3*(m_dot^3.0) + r4*(m_dot^4.0);
end recv_refl;
