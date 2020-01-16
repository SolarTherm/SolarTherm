within SolarTherm.Models.Storage.PCM;

function CV_Mass
    input Real M; //Total mass of PCM
    input Real dz[:]; //array of thicknesses
    output Real m[size(dz,1)]; //array of masses of each element
protected
    Integer N;
algorithm
    N := size(dz,1);
    for i in 1:N loop
        m[i] := M*(dz[i]/sum(dz));
    end for;
end CV_Mass;