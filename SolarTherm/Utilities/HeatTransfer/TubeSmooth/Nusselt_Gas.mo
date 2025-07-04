within SolarTherm.Utilities.HeatTransfer.TubeSmooth;

function Nusselt_Gas
  input Real Re "Reynolds";
  output Real f "Darcy Friction Factor";
algorithm
  if Re <= 2300.0 then //Laminar
    f := 64.0/max(Re, 1.0e-6);
    
  elseif Re >= 4000.0 then //Turbulent
    f := (0.790*log(Re) - 1.64)^(-2.0);
    
  else //Transition
    f := (64.0/2300.0) + SolarTherm.Utilities.Phis((Re - 2300.0) / 1700.0)*((0.790*log(4000.0) - 1.64)^(-2.0) - (64.0/2300.0)); //f = f_low + Phis*(f_high-f_low)
  end if;
end Nusselt_Gas;