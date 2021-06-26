within SolarTherm.Utilities;

function Metadata_reader
    import Modelica.Utilities.Streams;
    import Modelica.Utilities.Strings;
    input String file;
    output Real[1] meta;
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
end Metadata_reader;
