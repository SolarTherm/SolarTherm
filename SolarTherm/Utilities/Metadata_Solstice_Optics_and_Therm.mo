within SolarTherm.Utilities;

function Metadata_Solstice_Optics_and_Therm
    import Modelica.Utilities.Streams;
    import Modelica.Utilities.Strings;
    input String file;
    output Real[24] meta;
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
    (meta[3], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // eff_des
    (meta[4], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // d_receiver
    (meta[5], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // h_receiver
    (meta[6], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // H_tower
    (meta[7], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // eff_rec_design, thermal?
    (meta[8], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // CoT1
    (meta[9], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // CoT2
    (meta[10], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // CoT3
    (meta[11], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // CoT4
    (meta[12], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // CoT'1
    (meta[13], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // CoT'2
    (meta[14], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // CoT'3
    (meta[15], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // CoT'4
    (meta[16], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Coh1
    (meta[17], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Coh2
    (meta[18], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Coh3
    (meta[19], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Coh4
    (meta[20], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // Coh5
    (meta[21], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // eff_abs
    (meta[22], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // eff_emi
    (meta[23], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // SM  
    (meta[24], j) := Strings.scanReal(line, j+1, message="Metadata cannot be read " + file); // A_land            
end Metadata_Solstice_Optics_and_Therm;
