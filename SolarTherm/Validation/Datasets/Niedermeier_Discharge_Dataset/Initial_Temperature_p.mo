within SolarTherm.Validation.Datasets.Niedermeier_Discharge_Dataset;

function Initial_Temperature_p "Input height array and number of particle CVs, output enthalpy array based on constant Quartzite_Sand properties"
  input SI.Length[:] z_f;
  input Integer N_p;
  output SI.Temperature[size(z_f, 1), N_p] T_p;
protected
  Integer N_f = size(z_f, 1);
  Integer j;
  SI.Length[42] z_data = {0.0906478466, 0.1914985403, 0.2779419921, 0.3691878579, 0.4724397587, 0.5552814, 0.6381230413, 0.7197640791, 0.8110099449, 0.8878485687, 0.8974533967, 0.9550823646, 1.0631366793, 1.1654280973, 1.2648380669, 1.3642480365, 1.4679801786, 1.5241684223, 1.5817973902, 1.7186661889, 1.7834987777, 1.9491820603, 2.1364762059, 2.2301232787, 2.3813993194, 2.4750463921, 2.6047115698, 2.7992093364, 2.8856527882, 2.979299861, 3.0297252079, 3.3034628053, 3.4403316039, 3.5699967817, 3.6204221285, 3.7716981692, 3.858141621, 3.9445850728, 4.0310285246, 4.1895081862, 4.275951638, 4.4056168158};
  SI.Temperature[42] T_data = {595.7609546651, 598.1159424539, 600.4713814762, 602.5646538181, 605.5746070744, 607.5371345012, 609.9418143824, 612.5102920346, 616.3066701267, 619.3829547119, 620.8892474379, 623.2455889272, 627.7619853208, 631.5711182806, 635.0266195237, 638.4821207668, 642.5663256861, 645.3353879229, 648.3795221191, 654.2706014592, 656.9214856348, 662.123869801, 663.9521176501, 664.7679854736, 665.5165442957, 665.7428755134, 666.1318388155, 666.2240032639, 666.483312132, 666.6113872487, 666.4132957294, 667.5182914367, 667.7760209875, 668.0667281886, 668.1634049723, 668.4534353232, 668.9420084269, 668.8410449247, 668.9365936245, 668.9316300557, 668.9289226545, 669.0231176537};
algorithm
  for i in 1:N_f loop
    j := 0;
    while j <= 42 loop
      if z_f[i] < z_data[1] then
        for k in 1:N_p loop
          T_p[i, k] := T_data[1] + (z_f[i] - z_data[1]) / (z_data[2] - z_data[1]) * (T_data[2] - T_data[1]);
        end for;
        break;
      elseif z_f[i] >= z_data[j] and z_f[i] <= z_data[j + 1] then
        for k in 1:N_p loop
          T_p[i, k] := T_data[j] + (T_data[j + 1] - T_data[j]) * (z_f[i] - z_data[j]) / (z_data[j + 1] - z_data[j]);
        end for;
        break;
      elseif z_f[i] > z_data[42] then
        for k in 1:N_p loop
          T_p[i, k] := T_data[41] + (z_f[i] - z_data[41]) / (z_data[42] - z_data[41]) * (T_data[42] - T_data[41]);
        end for;
        break;
      else
        j := j + 1;
      end if;
    end while;
  end for;
end Initial_Temperature_p;