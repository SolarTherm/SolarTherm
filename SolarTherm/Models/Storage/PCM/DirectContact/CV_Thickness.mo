within SolarTherm.Models.Storage.PCM.DirectContact;

function CV_Thickness
  input Real r;
  //common ratio, growth parameter of the uneven mesh
  input Real L;
  input Integer N;
  output Real dz[N];
protected
  Integer n;
  Real a;
algorithm
  n := div(N,2);
  if rem(N,2)==0 then //even number
    a := (L/2)*((1.0-r)/(1.0-r^n));
    for i in 1:N loop
      if i <= n then
        dz[i] := a*(r^i);
      else
        dz[i] := a*(r^(N-i+1));
      end if;
    end for;
  else //odd number
    a := (L/2.0)/(((1.0-r^n)/(1.0-r))+(r^(n+1.0)/2.0));
    for i in 1:N loop
      if i <= n+1 then
        dz[i] := a*(r^i);
      else
        dz[i] := a*(r^(N-i+1));
      end if;
    end for;
  end if;

end CV_Thickness;