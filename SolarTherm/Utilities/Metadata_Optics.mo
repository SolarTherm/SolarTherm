within SolarTherm.Utilities;

function Metadata_Optics
    import Modelica.Utilities.Streams;
    import Modelica.Utilities.Strings;
    input String file;
    output Real[23] meta;
  protected
    String line;
    Integer i;
    Integer j;
  algorithm
    line := Streams.readLine(file, 5);
    Streams.close(file);
    j := 10;
    for i in 1:23 loop
      (meta[i], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    end for;
end Metadata_Optics;
