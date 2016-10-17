within SolarTherm.Models.Analysis.LCOE;
model Rated_nominal "LCOE nominal"
  extends Template;
  parameter Integer y(final min= 1)=25 "Expected lifetime of system";
  parameter Real r=0.082 "Real discount rate";
  parameter Real i=0.025 "Inflaction rate";
//protected
  Real d=(1+r)*(1+i)-1;
  SolarTherm.Types.Money[y+1] I_t;
  SolarTherm.Types.Money F_t[y];
  nSI.Energy_kWh E_t[y];
equation
  I_t[1:n]= I;
  I_t[n+1:y+1]=fill(0,y+1-n);
  for i in 1:y loop
      E_t[i]=E_year/((1 + d)^i);
      F_t[i]=(I_t[i+1] + M_year)/((1 + d)^i);
  end for;
  lcoe= min(0.5,(I_t[1] + sum(F_t))/sum(E_t));
end Rated_nominal;
