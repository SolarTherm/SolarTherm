within SolarTherm.Utilities.HeatTransfer.ParallelDuct;

function Nusselt_Gas"Nusselt number for air flowing through a flat duct"
  //Nusselt number equations were based on Kakac 1987
  input Real Re "Reynolds";
  input Real Pr "Prandtl";
  output Real Nu "Nusselt number";
protected
  Real f "Darcy Friction Factor";
algorithm
  if Re <= 2300.0 then //Laminar
    Nu := 7.5407;
    f := 96.0/max(Re, 1.0e-6);
    
  elseif Re >= 4000.0 then //Turbulent
    f := (5.12e-3) + (0.4572)/(Re^(1.0/3.2154));
    Nu := ((f/8.0)*(Re-1000.0)*Pr)/(1.0+1.27*((f/8.0)^0.5)*((Pr^(2.0/3.0))-1.0));
    
  else //Transition (Note that Kakac has the same equation for the range Re = 2300-1e6
    f := 0.216 + (9.2e-8)/(Re^(-1.5));
    Nu := ((f/8.0)*(Re-1000.0)*Pr)/(1.0+1.27*((f/8.0)^0.5)*((Pr^(2.0/3.0))-1.0));
    
  end if;
end Nusselt_Gas;