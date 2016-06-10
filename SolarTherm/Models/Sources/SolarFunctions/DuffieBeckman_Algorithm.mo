within SolarTherm.Models.Sources.SolarFunctions;
function DuffieBeckman_Algorithm "Sun position using Duffie and Beckman"
  extends SolarTherm.Models.Sources.SolarFunctions.solarPosition;

protected
 constant Real ang_vel(quantity="AngularVelocity", unit="deg/h") = 360/24
    "Angular velocity of earth";
 SI.Angle B "Approximate angle of earth in its orbit";
 Real E "Equation of time";
 Real t_solar "Local solar time (solar noon at 12hrs)";
 parameter nSI.Angle_deg lon_st=ang_vel*(t_zone) "Standard meridian for 

   the local time zone";
    Real time_offset;
algorithm
 // The approximate oribital angle is calculated taking noon UTC as zero
 // eq. 1.4.2 from [1] in radians
 B :=(2*pi/365)*(t/3600 - 12)/24;
                              //(day-1+(hour-12)/24);
 // The equation of time accounts for orbital eccentricity and axial tilt
 // eq. 1.5.3 from [1] in hours
 E :=229.18*(0.000075 + 0.001868*cos(B) - 0.032077*sin(B) - 0.014615*cos(2*B) -
    0.04089*sin(2*B));
 // The local solar time is calculated by applying the equation of time
 // correction and correcting for the difference between the location and
 // the time zone meridian
 // eq. 1.5.2 from [1] in hours

 time_offset:=-4*lon + 60*t_zone + E;
 t_solar :=t/60 - time_offset;

 // The hour angle converts the solar time to an angle and lines up solar
 // noon with zero
 //hra =from_deg(ang_vel*(mod(t_solar, 24)-12));
 hra :=from_deg(mod(t_solar/4, 360) - 180);

  // Calculating th declination from approximate orbital angle
 // eq. 1.6.1b
 dec :=0.006918 - 0.399912*cos(B) + 0.070257*sin(B) - 0.006758*cos(2*B) + 0.000907
    *sin(2*B) - 0.002697*cos(3*B) + 0.00148*sin(3*B);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DuffieBeckman_Algorithm;
