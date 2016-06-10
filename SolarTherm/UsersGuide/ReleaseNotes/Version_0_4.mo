within SolarTherm.UsersGuide.ReleaseNotes;
model Version_0_4 "Version 0.4 (20 May, 2016)"
                                                     extends
    Modelica.Icons.ReleaseNotes;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>The following changes has been added to library:</p>
<ul>
<li>Inclusion of new models of receiver, tank, and control devices (I and PI with reset, discharge logic schemes, and pump control models).</li>
<li>Inclusion the DataTable model like a wrapper to get data from file. Tested in Dymola and OpenModelica.</li>
<li>Inclusion of new runable examples and tested in Dymola and OpenModelica (unless Control 2).</li>
</ul>
<p><i><span style=\"font-family: MS Shell Dlg 2;\">by Alberto de la Calle (20 May 2016).</span></i></p>
</html>"));
end Version_0_4;
