within SolarTherm.Utilities;
function Round "Rounds a float (Real) to the nearest integer"
    input Real number;
    output Integer int;
  protected
    Integer quotient;
    Real remainder;
  algorithm
    if number - integer(number) >= 0.5 then
      int := integer(number + 1);
    else
      int := integer(number);
    end if;
end Round;