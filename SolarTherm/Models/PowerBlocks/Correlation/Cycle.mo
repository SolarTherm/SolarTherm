within SolarTherm.Models.PowerBlocks.Correlation;
partial model Cycle
  input Real T_ND;
  output Real k_q "Non-design heat fraction";
  output Real k_w "Non-design gross power fraction";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Cycle;
