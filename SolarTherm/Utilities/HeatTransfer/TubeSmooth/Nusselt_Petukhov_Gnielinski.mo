within SolarTherm.Utilities.HeatTransfer.TubeSmooth;

function Nusselt_Petukhov_Gnielinski "Nu = f(Re,Pr), calculates Nusselt Number from Reynold and Prandtl numbers for fluids 0.5 < Pr < 2000 flowing through smooth tubes."
  input Real Re "Reynolds Number (-)";
  input Real Pr "Prandtl Number (-)";
  output Real Nu "Nusselt Number (-)";
protected
  Real f "Darcy Friction Factor (-)";
algorithm
  f := SolarTherm.Utilities.HeatTransfer.TubeSmooth.f_Darcy_Petukhov(Re);

  if Re <= 2300.0 then //Laminar Flow
    Nu := 3.66;
    
  elseif Re >= 3000.0 then //Turbulent Flow
    Nu := ((f/8.0)*(Re-1000.0)*Pr)/(1.0+1.27*((f/8.0)^0.5)*((Pr^(2.0/3.0))-1.0));
    
  else //Transition Flow
    Nu := 3.66 + SolarTherm.Utilities.Transition.Phis((Re - 2300.0) / 700.0)*(((f/8.0)*(2000.0)*Pr)/(1.0+1.27*((f/8.0)^0.5)*((Pr^(2.0/3.0))-1.0)) - 3.66);
    
  end if;
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false)),
    Documentation(info= "<html><head></head><body><div>Darcy friction factor for internal flow of gases through smooth circular tubes.</div><div><br></div><div><b>0 &lt; Re &lt;= 2300</b></div><div>For laminar flow conditions, a constant Nusselt number of 3.66 is assumed based on the constant temperature boundary conditions.</div><div><br></div><div>Nu = 3.66</div><div>Re &lt; 2300.</div><div><br></div><div><b>Re &gt;= 3000</b></div><div>For Re &gt;= 3000, the Gnielinski correlation is used:</div><div><br></div><div>Nu = [(f/8)(Re-1000)Pr] / [1+12.7*((f/8)^0.5)*(Pr^(2/3)-1)]</div><div>3000 &lt;= Re &lt;= 5.0e6</div><div>0.5 &lt;= Pr &lt;= 2000</div><div>This assumes temperature-differences are not large.</div><div><br></div><div><b>2300 &lt; Re &lt; 3000</b></div><div>The Phis function is used to transition the value of Nu.</div><div><br></div><div>Nu = Nu(2300) + [ Phis((Re-2300)/(3000-2300)) ] * [ Nu(3000) - Nu(2300) ]</div><div><br></div><img width=\"500\" src=\"modelica://SolarTherm/Resources/Utilities/HT_TubeSmooth_Nu.png\">&nbsp;</body></html>"));
end Nusselt_Petukhov_Gnielinski;