block TestSTMotab
    import SolarTherm.Utilities.Tables.STMotab;
    import Modelica.Utilities.Files;
    parameter String weafile = Files.loadResource("modelica://SolarTherm/Data/Weather/Mildura_Real2010_Created20130430.motab");
    STMotab.STMotab table = STMotab.STMotab(weafile);
    parameter Integer dnicol(fixed=false);
    parameter String dniunits(fixed=false);
    parameter Real dnival(fixed=false);
    parameter Real t1(fixed=true) = 31500000.;
initial algorithm
    dnicol := STMotab.findColByLabel(table, "dni");
    dniunits := STMotab.getColUnits(table,"dni");
    dnival := STMotab.getValue(table,t1,dnicol); // should equal 976.
    annotation(experiment(StartTime=0.0, StopTime=4.0, Interval=0.01, Tolerance=1e-06));
end TestSTMotab;

// vim: ts=4:sw=4:et:tw=80
