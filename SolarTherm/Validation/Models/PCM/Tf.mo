within SolarTherm.Validation.Models.PCM;

function Tf
  input Real h;
  output Real T;
  output Real f;
algorithm
  if h <= 661688.0 then //Solid
    f := 0.0;
    T := (1.0/856.0)*h + 300.0;
  elseif h >= 1092888.0 then
    f := 1.0;
    T := (1.0/1198.0)*h - (1092888.0/1198.0) + 1073.0;
  else
    T := 1073.0;
    f := (h-661688.0)/(4.312e5);
  end if;
end Tf;