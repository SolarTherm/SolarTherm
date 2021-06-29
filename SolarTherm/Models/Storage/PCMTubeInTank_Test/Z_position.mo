within SolarTherm.Models.Storage.PCMTubeInTank_Test;

function Z_position
  input SI.Length L "Length of PCM tank";
  input Integer N_sec "Number of mesh elements";
  output SI.Length z_f[N_sec];
protected
  SI.Length dL "Length step";
algorithm
  dL := L / N_sec;
  for i in 1:N_sec loop
    z_f[i] := (i - 0.5) * dL;
  end for;
  
annotation (Documentation(info="<html>
  		<p> This function is to calculate the distance of the HTF (heat transfer fluid) node to the entrance. </p>   		  		
  		</html>"));   
  
end Z_position;
