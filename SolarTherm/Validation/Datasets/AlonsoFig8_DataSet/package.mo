within SolarTherm.Validation.Datasets;

package AlonsoFig8_DataSet "Provides the initial temerature and enthalpy distributions of the validation case used by Niedermeier (2018) based on Pacheco (2002) experimental data"
  
  constant SI.Length z_f_sim_0p0h[30] = {-0.1614788879, 0.0570309486, 0.0570309486, 0.2635347502, 0.4562316115, 0.6183130836, 0.7803945557, 0.8902497757, 1.0127113325, 1.1351728892, 1.2987979944, 1.4469867689, 1.5601865272, 1.665839635, 1.7714927427, 1.9131639554, 2.1508834479, 2.3285727655, 2.4570373397, 2.6047115698, 2.8251423719, 2.979299861, 3.1521867646, 3.3034628053, 3.4715472949, 3.6444341985, 3.8149198951, 3.9878067987, 4.1726997373, 4.297562501};
  constant SI.Temperature T_f_sim_degC_0p0h[30] = {320.962014658, 322.5714783169, 321.6191126544, 326.7267747413, 331.6314886946, 336.0946352425, 341.8139192591, 346.5217271469, 352.5451807468, 357.3174229075, 363.0367554006, 368.5304132175, 373.7245956006, 378.8115757796, 383.2811602877, 388.1787984546, 391.0926211294, 392.2968684502, 392.7278253179, 393.2250658404, 393.3108047658, 393.5816515426, 394.0304235564, 394.6262977767, 394.8942979006, 395.4251704026, 395.7753464226, 395.977816972, 395.7373219256, 396.2338460718};
  constant SI.Length z_f_sim_0p5h[28] = {0.0258152577, 0.1770912984, 0.5084578636, 0.687107664, 0.8282986353, 0.9550823646, 1.0415258164, 1.1625466489, 1.2547529975, 1.3872996236, 1.5581283498, 1.8051096407, 1.9924037862, 2.114865343, 2.2488526933, 2.3958065613, 2.5460535133, 2.6637812619, 2.815217383, 2.9885616594, 3.1401807296, 3.3351587376, 3.5303768662, 3.6780510964, 3.9229742098, 4.1438852533, 4.2745109139, 4.4776530256};
  constant SI.Temperature T_f_sim_degC_0p5h[28] = {289.7631429505, 289.7022132656, 289.7126195732, 291.4127840056, 295.9097567087, 303.9464500124, 309.9589204334, 318.6193964678, 323.7059543618, 329.1484532194, 334.811714459, 342.954456224, 351.1375466691, 356.1659423528, 361.5296699867, 367.4061118699, 373.7724452248, 378.448833012, 383.8831676941, 388.3955372797, 390.7460269906, 392.0263496983, 393.0078341699, 393.209512935, 393.699955424, 394.3242886332, 394.5385680794, 395.517017378};
  constant SI.Length z_f_sim_1p0h[38] = {0.0786418116, 0.1914985403, 0.5084578636, 0.6621351113, 0.8974533967, 1.0703403003, 1.2828471194, 1.4281201425, 1.5865998042, 1.7454224954, 1.8627386085, 1.9563856813, 2.0442698573, 2.1436798269, 2.2397281067, 2.3649339, 2.53267536, 2.7055622636, 2.8592395113, 2.974497447, 3.0931170725, 3.2141379051, 3.3590335957, 3.4734682605, 3.5940088516, 3.7188716153, 3.8781516793, 4.0382321456, 4.2131772266, 4.3840059528, 4.5544916494, 4.715372518, 4.8762533867, 5.0371342553, 5.2260292056, 5.3877104765, 5.5493917475, 5.637436004};
  constant SI.Temperature T_f_sim_degC_1p0h[38] = {289.6991215365, 289.7026657138, 289.7126195732, 289.7174456868, 289.6460192047, 289.8484897541, 289.8354592473, 290.3326243617, 291.5855287112, 295.8597417969, 300.3953729631, 305.5870647268, 310.4501735586, 316.331690402, 321.1950556211, 327.0961483879, 333.7656300862, 340.0763769534, 345.87749753, 350.314543475, 355.2508659591, 359.7866134692, 365.7192881945, 370.3167560964, 375.0626657745, 379.5328535468, 384.5514587551, 388.1470139717, 390.6295969987, 391.9673353772, 392.7936942285, 393.1731247922, 393.5919635901, 394.6807423714, 395.0515655278, 395.2865243684, 395.5944614206, 395.6848002356};
  constant SI.Length z_f_sim_1p5h[38] = {0.0258152577, 0.1770912984, 0.5084578636, 0.6621351113, 0.8974533967, 1.0703403003, 1.2828471194, 1.4281201425, 1.5457792853, 1.7858999847, 1.9515832673, 2.107661722, 2.2805486256, 2.4102138033, 2.6407296748, 2.7790391976, 2.9062345624, 3.0124365175, 3.1161686597, 3.2141379051, 3.3240445795, 3.433127983, 3.5607349832, 3.6866954416, 3.8200653387, 3.9345000034, 4.0742502505, 4.2135202562, 4.3383830199, 4.4768526233, 4.6593443548, 4.8450376958, 5.0496205317, 5.198015124, 5.3925128905, 5.6127378749, 5.7911132516, 5.9327844643};
  constant SI.Temperature T_f_sim_degC_1p5h[38] = {289.828823341, 289.7022132656, 289.7126195732, 289.7174456868, 289.6460192047, 289.8484897541, 289.8354592473, 290.2341037759, 290.1392781834, 289.6870562524, 289.9549809682, 289.8613619042, 290.0638324536, 290.8560691731, 294.7712915792, 298.8872275277, 304.171925396, 309.0224734052, 314.5888601085, 319.1961321311, 324.6210307555, 329.2127008575, 334.5086711483, 339.1515389908, 344.2562788371, 348.6961138018, 354.1092827078, 359.8442704457, 364.5114993896, 370.0330007223, 376.7162381013, 382.48278724, 387.7452852548, 389.4642036632, 391.736285186, 392.7847045146, 393.4236528765, 393.7236637073};
  constant SI.Length z_f_sim_2p0h[37] = {0.1314683655, 0.2059057823, 0.5084578636, 0.6621351113, 0.8974533967, 1.0703403003, 1.2828471194, 1.4281201425, 1.5457792853, 1.7858999847, 1.9515832673, 2.107661722, 2.2805486256, 2.4102138033, 2.6455320888, 2.8136165784, 3.0393300359, 3.2218217674, 3.4001971442, 3.5648513381, 3.7428836853, 3.8965609329, 4.0118188686, 4.1222743904, 4.2279274982, 4.3623950899, 4.5016650955, 4.6169230313, 4.7657978649, 4.9314811476, 5.0879026318, 5.2138630901, 5.3328257452, 5.4587862036, 5.601417899, 5.7691593591, 5.9219790328};
  constant SI.Temperature T_f_sim_degC_2p0h[37] = {289.7007805131, 289.7031181619, 289.7126195732, 289.7174456868, 289.6460192047, 289.8484897541, 289.8354592473, 290.3326243617, 290.2377987692, 289.6870562524, 289.9549809682, 289.8613619042, 290.0638324536, 289.9693839012, 289.9767738877, 290.1134132306, 290.0548211945, 290.6188355238, 291.8582903133, 294.3686989018, 299.1490196859, 304.8598297255, 309.5595972325, 314.9160178287, 319.6811640941, 325.7279828709, 331.676431878, 336.2119984088, 342.0622284622, 348.5697902769, 354.6548301502, 359.2976979928, 364.2049442194, 368.7633658455, 374.0337703918, 379.3345196662, 383.5264437438};
  //Sandia's experimental data
  constant SI.Length z_f_exp_0p0h[49] = {0.337236534, 0.4145199063, 0.4777517564, 0.6533957845, 0.8079625293, 0.8220140515, 0.8782201405, 0.9414519906, 1.0117096019, 1.0960187354, 1.2365339578, 1.3419203747, 1.4051522248, 1.4402810304, 1.4613583138, 1.5386416862, 1.5667447307, 1.6299765808, 1.6510538642, 1.6932084309, 1.756440281, 1.8266978923, 1.8758782201, 1.9953161593, 2.0515222482, 2.262295082, 2.5152224824, 2.6557377049, 2.7259953162, 3.0772833724, 3.224824356, 3.3793911007, 3.5480093677, 3.7166276347, 3.9133489461, 4.1170960187, 4.3208430913, 4.5245901639, 4.6159250585, 4.6861826698, 4.7915690867, 4.8618266979, 4.9039812646, 5.0725995316, 5.3957845433, 5.2833723653, 5.4871194379, 5.6487119438, 5.831381733};
  constant SI.Temperature T_f_exp_degC_0p0h[49] = {331.2625431258, 334.1536067829, 337.0442194511, 338.9755789569, 338.4028231898, 341.2918573973, 345.5302500733, 348.4208627416, 350.7339842605, 353.0475567682, 351.3189167249, 354.4034545742, 357.1014950278, 360.7614945769, 364.6136153517, 368.4675400816, 371.1644530633, 374.2476379462, 377.1368976481, 379.8342616186, 382.1471576431, 385.2305680204, 387.3504408415, 390.0502852504, 391.0149502785, 391.7920039687, 393.5332716982, 393.152637157, 393.7326087447, 394.1290278937, 394.7114799197, 394.1387241527, 395.1069970911, 396.0752700295, 397.0444449455, 397.4361287122, 397.4426680497, 398.0269240309, 397.8372832435, 394.9509549688, 392.4508985952, 389.1794258913, 387.2550567118, 389.9564795815, 387.2708413196, 389.5780999842, 389.1994948926, 390.1675423366, 389.4031163326};
  constant SI.Length z_f_exp_0p5h[54] = {0.3442622951, 0.5409836066, 0.6533957845, 0.850117096, 0.8711943794, 0.8922716628, 0.9484777518, 1.018735363, 1.0960187354, 1.1030444965, 1.1803278689, 1.2576112412, 1.2786885246, 1.3840749415, 1.4613583138, 1.4613583138, 1.5245901639, 1.5737704918, 1.644028103, 1.6651053864, 1.700234192, 1.81264637, 1.8618266979, 1.8829039813, 1.9601873536, 1.981264637, 1.9953161593, 2.1990632319, 2.1990632319, 2.2201405152, 2.2552693208, 2.2693208431, 2.4309133489, 2.5362997658, 2.6838407494, 2.7540983607, 2.9297423888, 3.0983606557, 3.2107728337, 3.3793911007, 3.5199063232, 3.8290398126, 4.0608899297, 4.3489461358, 4.5878220141, 4.7845433255, 4.9180327869, 5.1147540984, 5.2552693208, 5.2903981265, 5.37470726, 5.5152224824, 5.6978922717, 5.8243559719};
  constant SI.Temperature T_f_exp_degC_0p5h[54] = {291.400320202, 290.4437729722, 292.9508196721, 293.3422779444, 295.8463932171, 300.0836584211, 304.1294788825, 307.4054614743, 311.0668139897, 312.9927616299, 309.5289422058, 308.1834171421, 312.420682346, 316.2755090536, 319.936861569, 323.2105892169, 327.8343518164, 330.7245134958, 333.4227794439, 337.4674724333, 340.7423275532, 342.6716576093, 344.9841026451, 347.8733623469, 351.7272870769, 354.6165467788, 356.1575754843, 357.5121203238, 360.2081313279, 362.7122466007, 366.3722461497, 371.3795747176, 376.5842108824, 381.2093264482, 385.4506505513, 388.5340609286, 389.8877037906, 387.9673935103, 390.4744402102, 390.0947076465, 391.8323674657, 393.1902947212, 394.1605971092, 394.9401312377, 395.525514691, 395.5318285341, 396.1138295713, 395.3498545561, 393.8137867274, 391.3114754098, 389.9661758405, 391.3186912305, 391.5171262994, 390.5583241256};
  constant SI.Length z_f_exp_1p0h[56] = {0.3302107728, 0.4918032787, 0.5971896956, 0.6674473068, 0.7728337237, 0.8711943794, 0.9203747073, 1.0046838407, 1.1241217799, 1.243559719, 1.1733021077, 1.2857142857, 1.4473067916, 1.5878220141, 1.644028103, 1.6932084309, 1.7283372365, 1.8477751756, 1.8969555035, 1.9601873536, 1.9601873536, 1.9601873536, 1.9953161593, 2.0163934426, 2.1358313817, 2.2201405152, 2.2552693208, 2.2833723653, 2.2903981265, 2.4800936768, 2.5714285714, 2.6697892272, 2.7400468384, 2.831381733, 2.9227166276, 3.0983606557, 3.1545667447, 3.1826697892, 3.2669789227, 3.4355971897, 3.62529274, 3.6955503513, 3.7798594848, 3.8782201405, 4.018735363, 4.1662763466, 4.3840749415, 4.6159250585, 4.8196721311, 5.0093676815, 5.1077283372, 5.2271662763, 5.3887587822, 5.5433255269, 5.7330210773, 5.8173302108};
  constant SI.Temperature T_f_exp_degC_1p0h[56] = {289.666719282, 289.6719056531, 291.7935824295, 292.5661262318, 290.0660698582, 294.6909599296, 297.5811216091, 298.7392608294, 298.3579498049, 291.2366112702, 295.2783728324, 288.5419532325, 288.354567389, 290.4773716373, 294.7157643133, 297.028209349, 300.1104922543, 302.6177644486, 305.1227816989, 308.7836832255, 312.2499830879, 315.1385663066, 317.257988139, 320.7249644846, 320.7287978894, 323.6200870408, 327.2800865898, 329.5918551424, 333.636097143, 335.9530520667, 339.6148555708, 342.5065957111, 346.3602949467, 350.40724288, 353.683901955, 352.726678242, 355.8096376305, 358.3139783976, 361.2052675491, 364.6769792771, 369.3048007757, 373.1585000113, 376.4349335919, 380.2895348051, 383.95291677, 386.8462353711, 388.9715200577, 391.0972557332, 393.0295172165, 394.5761832818, 394.3867679888, 391.887162604, 388.6186213273, 389.7790154915, 389.9776760548, 389.2100931292};
  constant SI.Length z_f_exp_1p5h[46] = {0.3723653396, 0.5339578454, 0.62529274, 0.7447306792, 0.8149882904, 0.9484777518, 1.1241217799, 1.18735363, 1.243559719, 1.3911007026, 1.5878220141, 1.7775175644, 2.0093676815, 2.1639344262, 2.3325526932, 2.5222482436, 2.5995316159, 2.6978922717, 2.7611241218, 2.8454332553, 2.9016393443, 2.9859484778, 3.112412178, 3.2037470726, 3.2599531616, 3.4707259953, 3.6393442623, 3.7798594848, 3.9344262295, 4.0468384075, 4.1662763466, 4.3489461358, 4.4543325527, 4.7072599532, 4.7915690867, 4.8477751756, 4.9601873536, 5.0515222482, 5.206088993, 5.2833723653, 5.3044496487, 5.3114754098, 5.3817330211, 5.4871194379, 5.6276346604, 5.7962529274};
  constant SI.Temperature T_f_exp_degC_1p5h[46] = {289.4755000338, 289.6732586195, 292.75734548, 291.2206011681, 289.87485061, 292.7677182222, 295.8545110154, 293.3531016754, 289.503461339, 288.3527634338, 289.8996549936, 290.483459986, 291.453762374, 289.7255733195, 291.4641351162, 291.0850790358, 295.1315759803, 299.1787494081, 303.8025120076, 309.1972399486, 313.0504881954, 318.0600717072, 321.3378582542, 325.3848061876, 327.8900489323, 330.9779691975, 334.2571087108, 337.7279184612, 342.5471847025, 346.594809119, 350.6426590299, 356.2331161071, 362.3988093896, 366.8360881232, 372.808532708, 378.7800753151, 383.4054163754, 387.4523643087, 391.1161972625, 387.0746611947, 383.4164656008, 378.024669087, 376.2937740997, 380.1486008073, 384.9674160597, 386.7059778565};
  constant SI.Length z_f_exp_2p0h[41] = {0.3653395785, 0.5339578454, 0.6393442623, 0.8290398126, 1.0117096019, 1.1170960187, 1.1943793911, 1.3419203747, 1.5386416862, 1.6932084309, 1.8266978923, 1.981264637, 2.1007025761, 2.2833723653, 2.3817330211, 2.4871194379, 2.6346604215, 2.7049180328, 2.8173302108, 2.9156908665, 3.2037470726, 3.5269320843, 3.7868852459, 3.8922716628, 4.0117096019, 4.131147541, 4.2084309133, 4.3840749415, 4.6018735363, 4.81264637, 4.9039812646, 4.9461358314, 4.9882903981, 5.0444964871, 5.1077283372, 5.1428571429, 5.2271662763, 5.3606557377, 5.5854800937, 5.6978922717, 5.8173302108};
  constant SI.Temperature T_f_exp_degC_2p0h[41] = {287.5495523936, 287.3623920446, 289.6766410355, 286.7941461655, 288.533158951, 290.4622635128, 289.3093106636, 287.5808961147, 288.5500710307, 289.9030374095, 291.0627550905, 291.2602881818, 290.3012605137, 290.4996955826, 292.0434302208, 290.8913793492, 292.051548019, 291.2835141047, 290.3242609421, 288.9794123616, 288.6035132027, 290.5396080907, 293.6291068167, 298.2542223826, 303.8426500101, 310.201366496, 315.9810133718, 322.726678242, 329.8588405078, 336.4130606354, 343.7337362167, 348.356822333, 354.3279139513, 360.1068843439, 365.8860802309, 372.0495185695, 375.7110965793, 378.2188197623, 381.6923354455, 383.0439488579, 382.4700656189};
  
  
end AlonsoFig8_DataSet;
