within SolarTherm.Utilities;

function Metadata_Optics
    import Modelica.Utilities.Streams;
    import Modelica.Utilities.Strings;
    input String file;
    output Real[9] meta;
  protected
    String line;
    Integer i;
    Integer j;
  algorithm
    line := Streams.readLine(file, 5);
    Streams.close(file);

    i := 10;
    j := 10;
    (meta[1], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // number of heliostats
    (meta[2], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // area of a heliostat
    (meta[3], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // optical eff at design
    (meta[4], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // annual optical eff
    (meta[5], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // receiver height
    (meta[6], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // receiver width
    (meta[7], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // tower height
    (meta[8], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Q in recv
    (meta[9], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // land area
end Metadata_Optics;
