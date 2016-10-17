within SolarTherm.Models.Sources.Weather;
function getMetadata "Get metadata from file"
 import Modelica.Utilities.Streams;
 import Modelica.Utilities.Strings;
 input String file;
 output Metadata meta;
protected
 String line;
 Integer i;
 Integer j;
algorithm
 line := Streams.readLine(file, 7);
 Streams.close(file);
 // scanString expects string literals, so doing manually
 // Check first part is #METADATA
 i := Strings.find(line, ",", 1);
 assert(i > 0, "Metadata cannot be read " + file);
 assert(Strings.substring(line, 1, i-1) == "#METADATA",
  "Metadata cannot be read " + file);
 j := Strings.find(line, ",", i+1);
 meta.name := Strings.substring(line, i+1, j-1);
 (meta.lat, j) := Strings.scanReal(line, j+1,
  message="Metadata cannot be read " + file);
 (meta.lon, j) := Strings.scanReal(line, j+1,
  message="Metadata cannot be read " + file);
 (meta.elev, j) := Strings.scanReal(line, j+1,
  message="Metadata cannot be read " + file);
 (meta.tzone, j) := Strings.scanReal(line, j+1,
  message="Metadata cannot be read " + file);
 (meta.tstart, j) := Strings.scanReal(line, j+1,
  message="Metadata cannot be read " + file);
end getMetadata;
