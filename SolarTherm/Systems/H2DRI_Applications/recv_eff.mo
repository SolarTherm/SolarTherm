within SolarTherm.Systems.H2DRI_Applications;

function recv_eff
  input Real mu "Non-dimensional mass flow rate (-)";
  output Real eff "Receiver efficiency (-)";
protected
  constant Real c0 = 0.1991159;
  constant Real c1 = 2.2985867;
  constant Real c2 = -3.8375046;
  constant Real c3 = 3.0930337;
  constant Real c4 = -0.9528549; 
algorithm
  eff := c0 + c1*mu + c2*(mu^2.0) + c3*(mu^3.0) + c4*(mu^4.0);
end recv_eff;