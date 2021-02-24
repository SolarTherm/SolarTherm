within SolarTherm.Models.CSP.CRS.HeliostatsField;
function TowerRadiusCalculator
	input Real angular_range;
	input Integer num_aperture;
	input Real W_rcv;
	output Real R_rcv_distance;
	algorithm
	   if tan(angular_range/(num_aperture-1))<1e-20 then R_rcv_distance:=W_rcv*1.2/2;
	   else
			R_rcv_distance:=W_rcv*1.2/2/tan(angular_range/(num_aperture-1));
	   end if;

end TowerRadiusCalculator;
