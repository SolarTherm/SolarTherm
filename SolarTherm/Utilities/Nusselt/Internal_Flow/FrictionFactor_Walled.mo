within SolarTherm.Utilities.Nusselt.Internal_Flow;

function FrictionFactor_Walled "Friction factor for air flowing through a flat duct"
  //Friction factor equations were based on Kakac 1987
  input Real Re "Reynolds";
  output Real f "Friction Factor";
algorithm
  if Re <= 2300.0 then //Laminar
    f := 96.0/max(Re, 1.0e-6);
    
  elseif Re >= 4000.0 then //Turbulent
    f := (5.12e-3) + (0.4572)/(Re^(1.0/3.2154));
   
  else //Transition
    f := 0.216 + (9.2e-8)/(Re^(-1.5));
  end if;

annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)));
end FrictionFactor_Walled;