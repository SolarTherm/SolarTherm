within SolarTherm.Models.Storage.PCM.DirectContact;

function CV_Location
    input Real dz[:]; //Array of thicknesses of PCM with length L
    output Real z[size(dz,1)]; //Array of element centroids
protected
    Real L;
    Integer N;
algorithm
    L := sum(dz);
    N := size(dz,1);
    z[1] := 0.5*dz[1]-L;
    for i in 2:N loop
        z[i] := sum(dz[1:i-1])+0.5*dz[i]-L;
    end for;
end CV_Location;