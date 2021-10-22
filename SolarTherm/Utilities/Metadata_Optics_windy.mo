within SolarTherm.Utilities;

function Metadata_Optics_windy
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
    (meta[1], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    (meta[2], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    (meta[3], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    (meta[4], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    (meta[5], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    (meta[6], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    (meta[7], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    (meta[8], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
    (meta[9], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file);
end Metadata_Optics_windy;
