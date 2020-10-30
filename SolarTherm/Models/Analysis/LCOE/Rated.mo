within SolarTherm.Models.Analysis.LCOE;
model Rated "LCOE rated"
  extends Template;
  parameter Integer y(final min=1)=25 "Expected lifetime of system";
  parameter Real r=0.082 "Discount rate";
  SolarTherm.Types.Money[y+1] I_t;
equation
  I_t[1:n]= I;
  I_t[n+1:y+1]=fill(0,y+1-n);
  lcoe=SolarTherm.Models.Analysis.LCOE.lcoe_function(I_t,M_year,E_year,y=y,r=r);
end Rated;
