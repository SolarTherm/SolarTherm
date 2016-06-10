within SolarTherm.Icons;
partial model GeneratorModel

  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
                   graphics={
                     Line(
                       points=  {{-66, 0}, {-56.2, 29.9}, {-49.8, 46.5},
                        {-44.2, 58.1}, {-39.3, 65.2}, {-34.3, 69.2},
                        {-29.4, 69.8}, {-24.5, 67}, {-19.6, 61}, {-14.6, 52},
                        {-9, 38.6}, {-1.98, 18.6}, {12.79, -26.9}, {19.1, -44},
                        {24.8, -56.2}, {29.7, -64}, {34.6, -68.6}, {39.5, -70},
                        {44.5, -67.9}, {49.4, -62.5}, {54.3, -54.1},
                        {59.9, -41.3}, {67, -21.7}, {74, 0}},
                       thickness=  1),
                     Ellipse(
                       origin=  {0, -4},
                       lineThickness=  1,
                       extent=  {{-100, 104}, {100, -96}},
                       endAngle=  360)}),
              Diagram(coordinateSystem(preserveAspectRatio=false)));
end GeneratorModel;
