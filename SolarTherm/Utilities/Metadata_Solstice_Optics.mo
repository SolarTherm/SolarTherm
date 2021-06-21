within SolarTherm.Utilities;

function Metadata_Solstice_Optics
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
    (meta[1], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // n_helios
    (meta[2], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // A_helio
    (meta[3], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Eff_design
    (meta[4], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Eff_annual
    (meta[5], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // H_rcv
    (meta[6], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // W_rcv
    (meta[7], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // H_tower
    (meta[8], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Q_in_rcv
    (meta[9], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // A_land
end Metadata_Solstice_Optics;
