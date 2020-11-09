/* update bound parameters and variable attributes (start, nominal, min, max) */
#include "sCO2PBCalculator_Using_JPidea_model.h"
#if defined(__cplusplus)
extern "C" {
#endif


/*
equation index: 1204
type: SIMPLE_ASSIGN
_omcQuot_245354415254._powerBlock._reCompressor._eta_comp = powerBlock.reCompressor.eta_design
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1204(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1204};
  data->modelData->realVarsData[265].attribute /* powerBlock.reCompressor.eta_comp variable */.start = data->simulationInfo->realParameter[628] /* powerBlock.reCompressor.eta_design PARAM */;
    data->localData[0]->realVars[265] /* powerBlock.reCompressor.eta_comp variable */ = data->modelData->realVarsData[265].attribute /* powerBlock.reCompressor.eta_comp variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[265].info /* powerBlock.reCompressor.eta_comp */.name, (modelica_real) data->localData[0]->realVars[265] /* powerBlock.reCompressor.eta_comp variable */);
  TRACE_POP
}

/*
equation index: 1205
type: SIMPLE_ASSIGN
_omcQuot_245354415254._powerBlock._mainCompressor._eta_comp = powerBlock.mainCompressor.eta_design
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1205(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1205};
  data->modelData->realVarsData[255].attribute /* powerBlock.mainCompressor.eta_comp variable */.start = data->simulationInfo->realParameter[595] /* powerBlock.mainCompressor.eta_design PARAM */;
    data->localData[0]->realVars[255] /* powerBlock.mainCompressor.eta_comp variable */ = data->modelData->realVarsData[255].attribute /* powerBlock.mainCompressor.eta_comp variable */.start;
    infoStreamPrint(LOG_INIT, 0, "updated start value: %s(start=%g)", data->modelData->realVarsData[255].info /* powerBlock.mainCompressor.eta_comp */.name, (modelica_real) data->localData[0]->realVars[255] /* powerBlock.mainCompressor.eta_comp variable */);
  TRACE_POP
}
OMC_DISABLE_OPT
int sCO2PBCalculator_Using_JPidea_updateBoundVariableAttributes(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  /* min ******************************************************** */
  
  infoStreamPrint(LOG_INIT, 1, "updating min-values");
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  /* max ******************************************************** */
  
  infoStreamPrint(LOG_INIT, 1, "updating max-values");
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  /* nominal **************************************************** */
  
  infoStreamPrint(LOG_INIT, 1, "updating nominal-values");
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  /* start ****************************************************** */
  infoStreamPrint(LOG_INIT, 1, "updating primary start-values");
  sCO2PBCalculator_Using_JPidea_eqFunction_1204(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1205(data, threadData);
  if (ACTIVE_STREAM(LOG_INIT)) messageClose(LOG_INIT);
  
  TRACE_POP
  return 0;
}

void sCO2PBCalculator_Using_JPidea_updateBoundParameters_0(DATA *data, threadData_t *threadData);

/*
equation index: 1206
type: SIMPLE_ASSIGN
_omcQuot_246373653237 = exp(0.3537 * (-273.15 + T_amb_input))
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1206(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1206};
  data->localData[0]->realVars[22] /* $cse27 variable */ = exp((0.3537) * (-273.15 + data->simulationInfo->realParameter[4] /* T_amb_input PARAM */));
  TRACE_POP
}

/*
equation index: 1207
type: SIMPLE_ASSIGN
tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1207(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1207};
  data->simulationInfo->extObjs[39] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1208
type: SIMPLE_ASSIGN
tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1208(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1208};
  data->simulationInfo->extObjs[37] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1209
type: SIMPLE_ASSIGN
tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1209(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1209};
  data->simulationInfo->extObjs[36] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1210
type: SIMPLE_ASSIGN
tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1210(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1210};
  data->simulationInfo->extObjs[38] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1211
type: SIMPLE_ASSIGN
powerBlock._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1211(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1211};
  data->simulationInfo->extObjs[31] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1212
type: SIMPLE_ASSIGN
powerBlock._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1212(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1212};
  data->simulationInfo->extObjs[29] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1213
type: SIMPLE_ASSIGN
powerBlock._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1213(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1213};
  data->simulationInfo->extObjs[28] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1214
type: SIMPLE_ASSIGN
powerBlock._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1214(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1214};
  data->simulationInfo->extObjs[30] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1215
type: SIMPLE_ASSIGN
powerBlock._HTR._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1215(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1215};
  data->simulationInfo->extObjs[3] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1216
type: SIMPLE_ASSIGN
powerBlock._HTR._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1216(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1216};
  data->simulationInfo->extObjs[1] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1217
type: SIMPLE_ASSIGN
powerBlock._HTR._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1217(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1217};
  data->simulationInfo->extObjs[0] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1218
type: SIMPLE_ASSIGN
powerBlock._HTR._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1218(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1218};
  data->simulationInfo->extObjs[2] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1219
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1219(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1219};
  data->simulationInfo->extObjs[19] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1220
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1220(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1220};
  data->simulationInfo->extObjs[17] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1221
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1221(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1221};
  data->simulationInfo->extObjs[16] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1222
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1222(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1222};
  data->simulationInfo->extObjs[18] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1223
type: SIMPLE_ASSIGN
powerBlock._cooler._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1223(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1223};
  data->simulationInfo->extObjs[11] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1224
type: SIMPLE_ASSIGN
powerBlock._cooler._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1224(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1224};
  data->simulationInfo->extObjs[9] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1225
type: SIMPLE_ASSIGN
powerBlock._cooler._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1225(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1225};
  data->simulationInfo->extObjs[8] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1226
type: SIMPLE_ASSIGN
powerBlock._cooler._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1226(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1226};
  data->simulationInfo->extObjs[10] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1227
type: SIMPLE_ASSIGN
powerBlock._turbine._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1227(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1227};
  data->simulationInfo->extObjs[35] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1228
type: SIMPLE_ASSIGN
powerBlock._turbine._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1228(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1228};
  data->simulationInfo->extObjs[33] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1229
type: SIMPLE_ASSIGN
powerBlock._turbine._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1229(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1229};
  data->simulationInfo->extObjs[32] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1230
type: SIMPLE_ASSIGN
powerBlock._turbine._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1230(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1230};
  data->simulationInfo->extObjs[34] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1231
type: SIMPLE_ASSIGN
powerBlock._exchanger._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1231(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1231};
  data->simulationInfo->extObjs[15] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1232
type: SIMPLE_ASSIGN
powerBlock._exchanger._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1232(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1232};
  data->simulationInfo->extObjs[13] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1233
type: SIMPLE_ASSIGN
powerBlock._exchanger._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1233(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1233};
  data->simulationInfo->extObjs[12] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1234
type: SIMPLE_ASSIGN
powerBlock._exchanger._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1234(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1234};
  data->simulationInfo->extObjs[14] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1235
type: SIMPLE_ASSIGN
powerBlock._reCompressor._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1235(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1235};
  data->simulationInfo->extObjs[27] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1236
type: SIMPLE_ASSIGN
powerBlock._reCompressor._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1236(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1236};
  data->simulationInfo->extObjs[25] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1237
type: SIMPLE_ASSIGN
powerBlock._reCompressor._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1237(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1237};
  data->simulationInfo->extObjs[24] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1238
type: SIMPLE_ASSIGN
powerBlock._reCompressor._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1238(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1238};
  data->simulationInfo->extObjs[26] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1239
type: SIMPLE_ASSIGN
powerBlock._LTR._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1239(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1239};
  data->simulationInfo->extObjs[7] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1240
type: SIMPLE_ASSIGN
powerBlock._LTR._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1240(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1240};
  data->simulationInfo->extObjs[5] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1241
type: SIMPLE_ASSIGN
powerBlock._LTR._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1241(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1241};
  data->simulationInfo->extObjs[4] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1242
type: SIMPLE_ASSIGN
powerBlock._LTR._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1242(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1242};
  data->simulationInfo->extObjs[6] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1243
type: SIMPLE_ASSIGN
powerBlock._mixer._tableIDh_p_s = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_S.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1243(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1243};
  data->simulationInfo->extObjs[23] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT38, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1244
type: SIMPLE_ASSIGN
powerBlock._mixer._tableIDd_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Density", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1244(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1244};
  data->simulationInfo->extObjs[21] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT31, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1245
type: SIMPLE_ASSIGN
powerBlock._mixer._tableIDT_p_h = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Temperature", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_H.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1245(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1245};
  data->simulationInfo->extObjs[20] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT39, _OMC_LIT35, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1246
type: SIMPLE_ASSIGN
powerBlock._mixer._tableIDh_p_T = Modelica.Blocks.Types.ExternalCombiTable2D.constructor("Enthalpy", "/home/philgun/.local/lib/omlibrary/SolarTherm/Data/CO2/Props_from_P_T.txt", {}, Modelica.Blocks.Types.Smoothness.LinearSegments)
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1246(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1246};
  data->simulationInfo->extObjs[22] = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT37, _OMC_LIT40, _OMC_LIT36, 1);
  TRACE_POP
}

/*
equation index: 1247
type: SIMPLE_ASSIGN
source._T = T_HTF_in
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1247(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1247};
  data->simulationInfo->realParameter[685] /* source.T PARAM */ = data->simulationInfo->realParameter[2] /* T_HTF_in PARAM */;
  TRACE_POP
}
extern void sCO2PBCalculator_Using_JPidea_eqFunction_21(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_22(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_905(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_906(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_909(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_907(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_908(DATA *data, threadData_t *threadData);


/*
equation index: 1255
type: SIMPLE_ASSIGN
sink._medium._state._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1255(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1255};
  data->simulationInfo->realParameter[681] /* sink.medium.state.p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1256
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[1]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1256(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1256};
  data->simulationInfo->realParameter[539] /* powerBlock.exchanger.state_HTF[1].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1257
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[2]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1257(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1257};
  data->simulationInfo->realParameter[540] /* powerBlock.exchanger.state_HTF[2].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1258
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[3]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1258(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1258};
  data->simulationInfo->realParameter[541] /* powerBlock.exchanger.state_HTF[3].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1259
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[4]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1259(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1259};
  data->simulationInfo->realParameter[542] /* powerBlock.exchanger.state_HTF[4].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1260
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[5]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1260(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1260};
  data->simulationInfo->realParameter[543] /* powerBlock.exchanger.state_HTF[5].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1261
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[6]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1261(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1261};
  data->simulationInfo->realParameter[544] /* powerBlock.exchanger.state_HTF[6].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1262
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[7]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1262(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1262};
  data->simulationInfo->realParameter[545] /* powerBlock.exchanger.state_HTF[7].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1263
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[8]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1263(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1263};
  data->simulationInfo->realParameter[546] /* powerBlock.exchanger.state_HTF[8].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1264
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[9]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1264(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1264};
  data->simulationInfo->realParameter[547] /* powerBlock.exchanger.state_HTF[9].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1265
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[10]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1265(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1265};
  data->simulationInfo->realParameter[548] /* powerBlock.exchanger.state_HTF[10].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1266
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[11]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1266(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1266};
  data->simulationInfo->realParameter[549] /* powerBlock.exchanger.state_HTF[11].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1267
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[12]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1267(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1267};
  data->simulationInfo->realParameter[550] /* powerBlock.exchanger.state_HTF[12].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1268
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[13]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1268(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1268};
  data->simulationInfo->realParameter[551] /* powerBlock.exchanger.state_HTF[13].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1269
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[14]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1269(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1269};
  data->simulationInfo->realParameter[552] /* powerBlock.exchanger.state_HTF[14].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1270
type: SIMPLE_ASSIGN
powerBlock._exchanger._state_HTF[15]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1270(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1270};
  data->simulationInfo->realParameter[553] /* powerBlock.exchanger.state_HTF[15].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1271
type: SIMPLE_ASSIGN
liftSimple._fluid_b._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1271(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1271};
  data->simulationInfo->realParameter[16] /* liftSimple.fluid_b.p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1272
type: SIMPLE_ASSIGN
powerBlock._fluid_a._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1272(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1272};
  data->simulationInfo->realParameter[585] /* powerBlock.fluid_a.p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1273
type: SIMPLE_ASSIGN
powerBlock._exchanger._HTF_port_a._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1273(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1273};
  data->simulationInfo->realParameter[430] /* powerBlock.exchanger.HTF_port_a.p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1274
type: SIMPLE_ASSIGN
powerBlock._exchanger._HTF_port_b._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1274(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1274};
  data->simulationInfo->realParameter[431] /* powerBlock.exchanger.HTF_port_b.p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1275
type: SIMPLE_ASSIGN
powerBlock._fluid_b._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1275(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1275};
  data->simulationInfo->realParameter[586] /* powerBlock.fluid_b.p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1276
type: SIMPLE_ASSIGN
sink._ports[1]._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1276(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1276};
  data->simulationInfo->realParameter[683] /* sink.ports[1].p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1277
type: SIMPLE_ASSIGN
sink._medium._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1277(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1277};
  data->simulationInfo->realParameter[680] /* sink.medium.p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1278
type: SIMPLE_ASSIGN
sink._state._p = sink.p
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1278(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1278};
  data->simulationInfo->realParameter[684] /* sink.state.p PARAM */ = data->simulationInfo->realParameter[682] /* sink.p PARAM */;
  TRACE_POP
}

/*
equation index: 1279
type: SIMPLE_ASSIGN
powerBlock._splitter._gamma = powerBlock.gamma
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1279(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1279};
  data->simulationInfo->realParameter[642] /* powerBlock.splitter.gamma PARAM */ = data->simulationInfo->realParameter[587] /* powerBlock.gamma PARAM */;
  TRACE_POP
}

/*
equation index: 1280
type: SIMPLE_ASSIGN
powerBlock._splitter._gamma_var = powerBlock.splitter.gamma
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1280(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1280};
  data->simulationInfo->realParameter[643] /* powerBlock.splitter.gamma_var PARAM */ = data->simulationInfo->realParameter[642] /* powerBlock.splitter.gamma PARAM */;
  TRACE_POP
}

/*
equation index: 1281
type: SIMPLE_ASSIGN
powerBlock._cooler._T_amb = T_amb_input
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1281(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1281};
  data->simulationInfo->realParameter[340] /* powerBlock.cooler.T_amb PARAM */ = data->simulationInfo->realParameter[4] /* T_amb_input PARAM */;
  TRACE_POP
}

/*
equation index: 1282
type: SIMPLE_ASSIGN
powerBlock._T_amb = T_amb_input
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1282(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1282};
  data->simulationInfo->realParameter[314] /* powerBlock.T_amb PARAM */ = data->simulationInfo->realParameter[4] /* T_amb_input PARAM */;
  TRACE_POP
}

/*
equation index: 1283
type: SIMPLE_ASSIGN
T_amb_in._y = T_amb_input
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1283(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1283};
  data->simulationInfo->realParameter[3] /* T_amb_in.y PARAM */ = data->simulationInfo->realParameter[4] /* T_amb_input PARAM */;
  TRACE_POP
}

/*
equation index: 1298
type: SIMPLE_ASSIGN
powerBlock._pinch_recuperator = pinch_recuperator
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1298(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1298};
  data->simulationInfo->realParameter[613] /* powerBlock.pinch_recuperator PARAM */ = data->simulationInfo->realParameter[27] /* pinch_recuperator PARAM */;
  TRACE_POP
}

/*
equation index: 1299
type: SIMPLE_ASSIGN
powerBlock._LTR._pinchRecuperator = powerBlock.pinch_recuperator
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1299(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1299};
  data->simulationInfo->realParameter[245] /* powerBlock.LTR.pinchRecuperator PARAM */ = data->simulationInfo->realParameter[613] /* powerBlock.pinch_recuperator PARAM */;
  TRACE_POP
}

/*
equation index: 1300
type: SIMPLE_ASSIGN
powerBlock._LTR._ratio_m_des = 1.0 - powerBlock.gamma
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1300(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1300};
  data->simulationInfo->realParameter[246] /* powerBlock.LTR.ratio_m_des PARAM */ = 1.0 - data->simulationInfo->realParameter[587] /* powerBlock.gamma PARAM */;
  TRACE_POP
}

/*
equation index: 1302
type: SIMPLE_ASSIGN
powerBlock._p_high = p_high
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1302(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1302};
  data->simulationInfo->realParameter[610] /* powerBlock.p_high PARAM */ = data->simulationInfo->realParameter[24] /* p_high PARAM */;
  TRACE_POP
}

/*
equation index: 1303
type: SIMPLE_ASSIGN
powerBlock._reCompressor._p_high_des = powerBlock.p_high
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1303(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1303};
  data->simulationInfo->realParameter[632] /* powerBlock.reCompressor.p_high_des PARAM */ = data->simulationInfo->realParameter[610] /* powerBlock.p_high PARAM */;
  TRACE_POP
}

/*
equation index: 1305
type: SIMPLE_ASSIGN
powerBlock._N_shaft = powerBlock.choiceN[3]
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1305(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1305};
  data->simulationInfo->realParameter[307] /* powerBlock.N_shaft PARAM */ = data->simulationInfo->realParameter[319] /* powerBlock.choiceN[3] PARAM */;
  TRACE_POP
}

/*
equation index: 1306
type: SIMPLE_ASSIGN
powerBlock._reCompressor._N_design = powerBlock.N_shaft
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1306(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1306};
  data->simulationInfo->realParameter[622] /* powerBlock.reCompressor.N_design PARAM */ = data->simulationInfo->realParameter[307] /* powerBlock.N_shaft PARAM */;
  TRACE_POP
}

/*
equation index: 1307
type: SIMPLE_ASSIGN
powerBlock._T_HTF_in_des = T_in_ref_blk
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1307(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1307};
  data->simulationInfo->realParameter[312] /* powerBlock.T_HTF_in_des PARAM */ = data->simulationInfo->realParameter[6] /* T_in_ref_blk PARAM */;
  TRACE_POP
}

/*
equation index: 1308
type: SIMPLE_ASSIGN
powerBlock._exchanger._T_in_HTF_des = powerBlock.T_HTF_in_des
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1308(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1308};
  data->simulationInfo->realParameter[464] /* powerBlock.exchanger.T_in_HTF_des PARAM */ = data->simulationInfo->realParameter[312] /* powerBlock.T_HTF_in_des PARAM */;
  TRACE_POP
}

/*
equation index: 1309
type: SIMPLE_ASSIGN
T_cold_set = T_in_ref_blk - dTemp_HTF_PHX
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1309(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1309};
  data->simulationInfo->realParameter[5] /* T_cold_set PARAM */ = data->simulationInfo->realParameter[6] /* T_in_ref_blk PARAM */ - data->simulationInfo->realParameter[9] /* dTemp_HTF_PHX PARAM */;
  TRACE_POP
}

/*
equation index: 1310
type: SIMPLE_ASSIGN
powerBlock._T_HTF_out = T_cold_set
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1310(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1310};
  data->simulationInfo->realParameter[313] /* powerBlock.T_HTF_out PARAM */ = data->simulationInfo->realParameter[5] /* T_cold_set PARAM */;
  TRACE_POP
}

/*
equation index: 1311
type: SIMPLE_ASSIGN
powerBlock._exchanger._T_out_HTF_des = powerBlock.T_HTF_out
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1311(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1311};
  data->simulationInfo->realParameter[466] /* powerBlock.exchanger.T_out_HTF_des PARAM */ = data->simulationInfo->realParameter[313] /* powerBlock.T_HTF_out PARAM */;
  TRACE_POP
}

/*
equation index: 1312
type: SIMPLE_ASSIGN
powerBlock._pinch_PHX = pinch_PHX
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1312(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1312};
  data->simulationInfo->realParameter[612] /* powerBlock.pinch_PHX PARAM */ = data->simulationInfo->realParameter[26] /* pinch_PHX PARAM */;
  TRACE_POP
}

/*
equation index: 1313
type: SIMPLE_ASSIGN
powerBlock._exchanger._pinch_PHX = powerBlock.pinch_PHX
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1313(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1313};
  data->simulationInfo->realParameter[507] /* powerBlock.exchanger.pinch_PHX PARAM */ = data->simulationInfo->realParameter[612] /* powerBlock.pinch_PHX PARAM */;
  TRACE_POP
}

/*
equation index: 1316
type: SIMPLE_ASSIGN
powerBlock._turbine._N_shaft = powerBlock.N_shaft
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1316(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1316};
  data->simulationInfo->realParameter[648] /* powerBlock.turbine.N_shaft PARAM */ = data->simulationInfo->realParameter[307] /* powerBlock.N_shaft PARAM */;
  TRACE_POP
}

/*
equation index: 1317
type: SIMPLE_ASSIGN
powerBlock._T_amb_des = blk_T_amb_des
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1317(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1317};
  data->simulationInfo->realParameter[315] /* powerBlock.T_amb_des PARAM */ = data->simulationInfo->realParameter[8] /* blk_T_amb_des PARAM */;
  TRACE_POP
}

/*
equation index: 1318
type: SIMPLE_ASSIGN
powerBlock._turbine._T_amb = powerBlock.T_amb_des
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1318(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1318};
  data->simulationInfo->realParameter[650] /* powerBlock.turbine.T_amb PARAM */ = data->simulationInfo->realParameter[315] /* powerBlock.T_amb_des PARAM */;
  TRACE_POP
}

/*
equation index: 1319
type: SIMPLE_ASSIGN
powerBlock._PR = PR
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1319(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1319};
  data->simulationInfo->realParameter[308] /* powerBlock.PR PARAM */ = data->simulationInfo->realParameter[0] /* PR PARAM */;
  TRACE_POP
}

/*
equation index: 1320
type: SIMPLE_ASSIGN
powerBlock._turbine._PR = powerBlock.PR
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1320(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1320};
  data->simulationInfo->realParameter[649] /* powerBlock.turbine.PR PARAM */ = data->simulationInfo->realParameter[308] /* powerBlock.PR PARAM */;
  TRACE_POP
}

/*
equation index: 1321
type: SIMPLE_ASSIGN
powerBlock._turbine._eta_design = powerBlock.eta_turb
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1321(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1321};
  data->simulationInfo->realParameter[653] /* powerBlock.turbine.eta_design PARAM */ = data->simulationInfo->realParameter[429] /* powerBlock.eta_turb PARAM */;
  TRACE_POP
}

/*
equation index: 1324
type: SIMPLE_ASSIGN
powerBlock._T_low = T_low
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1324(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1324};
  data->simulationInfo->realParameter[316] /* powerBlock.T_low PARAM */ = data->simulationInfo->realParameter[7] /* T_low PARAM */;
  TRACE_POP
}

/*
equation index: 1325
type: SIMPLE_ASSIGN
powerBlock._cooler._T_low = powerBlock.T_low
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1325(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1325};
  data->simulationInfo->realParameter[342] /* powerBlock.cooler.T_low PARAM */ = data->simulationInfo->realParameter[316] /* powerBlock.T_low PARAM */;
  TRACE_POP
}

/*
equation index: 1326
type: SIMPLE_ASSIGN
powerBlock._cooler._T_amb_des = powerBlock.T_amb_des
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1326(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1326};
  data->simulationInfo->realParameter[341] /* powerBlock.cooler.T_amb_des PARAM */ = data->simulationInfo->realParameter[315] /* powerBlock.T_amb_des PARAM */;
  TRACE_POP
}

/*
equation index: 1327
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._p_high_des = powerBlock.p_high
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1327(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1327};
  data->simulationInfo->realParameter[599] /* powerBlock.mainCompressor.p_high_des PARAM */ = data->simulationInfo->realParameter[610] /* powerBlock.p_high PARAM */;
  TRACE_POP
}

/*
equation index: 1329
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._N_design = powerBlock.N_shaft
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1329(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1329};
  data->simulationInfo->realParameter[589] /* powerBlock.mainCompressor.N_design PARAM */ = data->simulationInfo->realParameter[307] /* powerBlock.N_shaft PARAM */;
  TRACE_POP
}

/*
equation index: 1330
type: SIMPLE_ASSIGN
powerBlock._mainCompressor._eta_design = powerBlock.eta_comp_main
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1330(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1330};
  data->simulationInfo->realParameter[595] /* powerBlock.mainCompressor.eta_design PARAM */ = data->simulationInfo->realParameter[424] /* powerBlock.eta_comp_main PARAM */;
  TRACE_POP
}

/*
equation index: 1331
type: SIMPLE_ASSIGN
powerBlock._HTR._pinchRecuperator = powerBlock.pinch_recuperator
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1331(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1331};
  data->simulationInfo->realParameter[110] /* powerBlock.HTR.pinchRecuperator PARAM */ = data->simulationInfo->realParameter[613] /* powerBlock.pinch_recuperator PARAM */;
  TRACE_POP
}

/*
equation index: 1333
type: SIMPLE_ASSIGN
powerBlock._pri_exchanger = pri_exchanger
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1333(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1333};
  data->simulationInfo->realParameter[616] /* powerBlock.pri_exchanger PARAM */ = data->simulationInfo->realParameter[668] /* pri_exchanger PARAM */;
  TRACE_POP
}

/*
equation index: 1334
type: SIMPLE_ASSIGN
powerBlock._pri_generator = pri_generator
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1334(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1334};
  data->simulationInfo->realParameter[617] /* powerBlock.pri_generator PARAM */ = data->simulationInfo->realParameter[669] /* pri_generator PARAM */;
  TRACE_POP
}

/*
equation index: 1335
type: SIMPLE_ASSIGN
powerBlock._pri_cooler = pri_cooler
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1335(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1335};
  data->simulationInfo->realParameter[615] /* powerBlock.pri_cooler PARAM */ = data->simulationInfo->realParameter[667] /* pri_cooler PARAM */;
  TRACE_POP
}

/*
equation index: 1336
type: SIMPLE_ASSIGN
powerBlock._pri_compressor = pri_compressor
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1336(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1336};
  data->simulationInfo->realParameter[614] /* powerBlock.pri_compressor PARAM */ = data->simulationInfo->realParameter[666] /* pri_compressor PARAM */;
  TRACE_POP
}

/*
equation index: 1337
type: SIMPLE_ASSIGN
powerBlock._pri_turbine = pri_turbine
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1337(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1337};
  data->simulationInfo->realParameter[619] /* powerBlock.pri_turbine PARAM */ = data->simulationInfo->realParameter[671] /* pri_turbine PARAM */;
  TRACE_POP
}

/*
equation index: 1338
type: SIMPLE_ASSIGN
powerBlock._pri_recuperator = pri_recuperator
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1338(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1338};
  data->simulationInfo->realParameter[618] /* powerBlock.pri_recuperator PARAM */ = data->simulationInfo->realParameter[670] /* pri_recuperator PARAM */;
  TRACE_POP
}

/*
equation index: 1340
type: SIMPLE_ASSIGN
powerBlock._ratio_m_des = 1.0 - powerBlock.gamma
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1340(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1340};
  data->simulationInfo->realParameter[620] /* powerBlock.ratio_m_des PARAM */ = 1.0 - data->simulationInfo->realParameter[587] /* powerBlock.gamma PARAM */;
  TRACE_POP
}

/*
equation index: 1343
type: SIMPLE_ASSIGN
powerBlock._eta_motor = eta_motor
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1343(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1343};
  data->simulationInfo->realParameter[427] /* powerBlock.eta_motor PARAM */ = data->simulationInfo->realParameter[10] /* eta_motor PARAM */;
  TRACE_POP
}

/*
equation index: 1345
type: SIMPLE_ASSIGN
powerBlock._par_fr = par_fr
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1345(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1345};
  data->simulationInfo->realParameter[611] /* powerBlock.par_fr PARAM */ = data->simulationInfo->realParameter[25] /* par_fr PARAM */;
  TRACE_POP
}

/*
equation index: 1346
type: SIMPLE_ASSIGN
powerBlock._f_fixed_load = f_fixed_load
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1346(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1346};
  data->simulationInfo->realParameter[584] /* powerBlock.f_fixed_load PARAM */ = data->simulationInfo->realParameter[11] /* f_fixed_load PARAM */;
  TRACE_POP
}

/*
equation index: 1347
type: SIMPLE_ASSIGN
powerBlock._nu_min = nu_min_blk
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1347(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1347};
  data->simulationInfo->realParameter[609] /* powerBlock.nu_min PARAM */ = data->simulationInfo->realParameter[23] /* nu_min_blk PARAM */;
  TRACE_POP
}

/*
equation index: 1348
type: SIMPLE_ASSIGN
powerBlock._external_parasities = external_parasities
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1348(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1348};
  data->simulationInfo->booleanParameter[3] /* powerBlock.external_parasities PARAM */ = data->simulationInfo->booleanParameter[0] /* external_parasities PARAM */;
  TRACE_POP
}
extern void sCO2PBCalculator_Using_JPidea_eqFunction_904(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_903(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_902(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_901(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_900(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_23(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_899(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_24(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_25(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_20(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_19(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_18(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_17(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_16(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_15(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_14(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_13(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_12(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_11(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_10(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_9(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_8(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_7(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_6(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_5(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_4(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_3(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_2(DATA *data, threadData_t *threadData);

extern void sCO2PBCalculator_Using_JPidea_eqFunction_1(DATA *data, threadData_t *threadData);


/*
equation index: 1383
type: ALGORITHM

  assert(T_amb_input >= 0.0, "Variable violating min constraint: 0.0 <= T_amb_input, has value: " + String(T_amb_input, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1383(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1383};
  modelica_boolean tmp0;
  static const MMC_DEFSTRINGLIT(tmp1,66,"Variable violating min constraint: 0.0 <= T_amb_input, has value: ");
  modelica_string tmp2;
  static int tmp3 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp3)
  {
    tmp0 = GreaterEq(data->simulationInfo->realParameter[4] /* T_amb_input PARAM */,0.0);
    if(!tmp0)
    {
      tmp2 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[4] /* T_amb_input PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp1),tmp2);
      {
        FILE_INFO info = {"/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation/sCO2PBCalculator_Using_JPidea.mo",32,3,32,48,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nT_amb_input >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp3 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1384
type: ALGORITHM

  assert(T_HTF_in >= 0.0, "Variable violating min constraint: 0.0 <= T_HTF_in, has value: " + String(T_HTF_in, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1384(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1384};
  modelica_boolean tmp4;
  static const MMC_DEFSTRINGLIT(tmp5,63,"Variable violating min constraint: 0.0 <= T_HTF_in, has value: ");
  modelica_string tmp6;
  static int tmp7 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp7)
  {
    tmp4 = GreaterEq(data->simulationInfo->realParameter[2] /* T_HTF_in PARAM */,0.0);
    if(!tmp4)
    {
      tmp6 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[2] /* T_HTF_in PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp5),tmp6);
      {
        FILE_INFO info = {"/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation/sCO2PBCalculator_Using_JPidea.mo",31,3,31,46,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nT_HTF_in >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp7 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1385
type: ALGORITHM

  assert(source.T >= 300.0 and source.T <= 1370.0, "Variable violating min/max constraint: 300.0 <= source.T <= 1370.0, has value: " + String(source.T, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1385(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1385};
  modelica_boolean tmp8;
  modelica_boolean tmp9;
  static const MMC_DEFSTRINGLIT(tmp10,79,"Variable violating min/max constraint: 300.0 <= source.T <= 1370.0, has value: ");
  modelica_string tmp11;
  static int tmp12 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp12)
  {
    tmp8 = GreaterEq(data->simulationInfo->realParameter[685] /* source.T PARAM */,300.0);
    tmp9 = LessEq(data->simulationInfo->realParameter[685] /* source.T PARAM */,1370.0);
    if(!(tmp8 && tmp9))
    {
      tmp11 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[685] /* source.T PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp10),tmp11);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",24,5,26,42,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.T >= 300.0 and source.T <= 1370.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp12 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1386
type: ALGORITHM

  assert(sink.T >= 300.0 and sink.T <= 1370.0, "Variable violating min/max constraint: 300.0 <= sink.T <= 1370.0, has value: " + String(sink.T, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1386(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1386};
  modelica_boolean tmp13;
  modelica_boolean tmp14;
  static const MMC_DEFSTRINGLIT(tmp15,77,"Variable violating min/max constraint: 300.0 <= sink.T <= 1370.0, has value: ");
  modelica_string tmp16;
  static int tmp17 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp17)
  {
    tmp13 = GreaterEq(data->simulationInfo->realParameter[672] /* sink.T PARAM */,300.0);
    tmp14 = LessEq(data->simulationInfo->realParameter[672] /* sink.T PARAM */,1370.0);
    if(!(tmp13 && tmp14))
    {
      tmp16 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[672] /* sink.T PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp15),tmp16);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",24,5,26,42,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.T >= 300.0 and sink.T <= 1370.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp17 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1387
type: ALGORITHM

  assert(sink.p >= 0.0 and sink.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= sink.p <= 100000000.0, has value: " + String(sink.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1387(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1387};
  modelica_boolean tmp18;
  modelica_boolean tmp19;
  static const MMC_DEFSTRINGLIT(tmp20,80,"Variable violating min/max constraint: 0.0 <= sink.p <= 100000000.0, has value: ");
  modelica_string tmp21;
  static int tmp22 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp22)
  {
    tmp18 = GreaterEq(data->simulationInfo->realParameter[682] /* sink.p PARAM */,0.0);
    tmp19 = LessEq(data->simulationInfo->realParameter[682] /* sink.p PARAM */,100000000.0);
    if(!(tmp18 && tmp19))
    {
      tmp21 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[682] /* sink.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp20),tmp21);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",10,5,12,42,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.p >= 0.0 and sink.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp22 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1388
type: ALGORITHM

  assert(sink.medium.state.p >= 0.0 and sink.medium.state.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= sink.medium.state.p <= 100000000.0, has value: " + String(sink.medium.state.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1388(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1388};
  modelica_boolean tmp23;
  modelica_boolean tmp24;
  static const MMC_DEFSTRINGLIT(tmp25,93,"Variable violating min/max constraint: 0.0 <= sink.medium.state.p <= 100000000.0, has value: ");
  modelica_string tmp26;
  static int tmp27 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp27)
  {
    tmp23 = GreaterEq(data->simulationInfo->realParameter[681] /* sink.medium.state.p PARAM */,0.0);
    tmp24 = LessEq(data->simulationInfo->realParameter[681] /* sink.medium.state.p PARAM */,100000000.0);
    if(!(tmp23 && tmp24))
    {
      tmp26 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[681] /* sink.medium.state.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp25),tmp26);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/SolidParticles/CarboHSP_ph/package.mo",71,3,71,51,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.medium.state.p >= 0.0 and sink.medium.state.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp27 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1389
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[1].p >= 0.0 and powerBlock.exchanger.state_HTF[1].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[1].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[1].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1389(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1389};
  modelica_boolean tmp28;
  modelica_boolean tmp29;
  static const MMC_DEFSTRINGLIT(tmp30,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[1].p <= 100000000.0, has value: ");
  modelica_string tmp31;
  static int tmp32 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp32)
  {
    tmp28 = GreaterEq(data->simulationInfo->realParameter[539] /* powerBlock.exchanger.state_HTF[1].p PARAM */,0.0);
    tmp29 = LessEq(data->simulationInfo->realParameter[539] /* powerBlock.exchanger.state_HTF[1].p PARAM */,100000000.0);
    if(!(tmp28 && tmp29))
    {
      tmp31 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[539] /* powerBlock.exchanger.state_HTF[1].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp30),tmp31);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[1].p >= 0.0 and powerBlock.exchanger.state_HTF[1].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp32 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1390
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[2].p >= 0.0 and powerBlock.exchanger.state_HTF[2].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[2].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[2].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1390(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1390};
  modelica_boolean tmp33;
  modelica_boolean tmp34;
  static const MMC_DEFSTRINGLIT(tmp35,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[2].p <= 100000000.0, has value: ");
  modelica_string tmp36;
  static int tmp37 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp37)
  {
    tmp33 = GreaterEq(data->simulationInfo->realParameter[540] /* powerBlock.exchanger.state_HTF[2].p PARAM */,0.0);
    tmp34 = LessEq(data->simulationInfo->realParameter[540] /* powerBlock.exchanger.state_HTF[2].p PARAM */,100000000.0);
    if(!(tmp33 && tmp34))
    {
      tmp36 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[540] /* powerBlock.exchanger.state_HTF[2].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp35),tmp36);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[2].p >= 0.0 and powerBlock.exchanger.state_HTF[2].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp37 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1391
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[3].p >= 0.0 and powerBlock.exchanger.state_HTF[3].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[3].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[3].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1391(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1391};
  modelica_boolean tmp38;
  modelica_boolean tmp39;
  static const MMC_DEFSTRINGLIT(tmp40,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[3].p <= 100000000.0, has value: ");
  modelica_string tmp41;
  static int tmp42 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp42)
  {
    tmp38 = GreaterEq(data->simulationInfo->realParameter[541] /* powerBlock.exchanger.state_HTF[3].p PARAM */,0.0);
    tmp39 = LessEq(data->simulationInfo->realParameter[541] /* powerBlock.exchanger.state_HTF[3].p PARAM */,100000000.0);
    if(!(tmp38 && tmp39))
    {
      tmp41 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[541] /* powerBlock.exchanger.state_HTF[3].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp40),tmp41);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[3].p >= 0.0 and powerBlock.exchanger.state_HTF[3].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp42 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1392
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[4].p >= 0.0 and powerBlock.exchanger.state_HTF[4].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[4].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[4].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1392(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1392};
  modelica_boolean tmp43;
  modelica_boolean tmp44;
  static const MMC_DEFSTRINGLIT(tmp45,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[4].p <= 100000000.0, has value: ");
  modelica_string tmp46;
  static int tmp47 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp47)
  {
    tmp43 = GreaterEq(data->simulationInfo->realParameter[542] /* powerBlock.exchanger.state_HTF[4].p PARAM */,0.0);
    tmp44 = LessEq(data->simulationInfo->realParameter[542] /* powerBlock.exchanger.state_HTF[4].p PARAM */,100000000.0);
    if(!(tmp43 && tmp44))
    {
      tmp46 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[542] /* powerBlock.exchanger.state_HTF[4].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp45),tmp46);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[4].p >= 0.0 and powerBlock.exchanger.state_HTF[4].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp47 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1393
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[5].p >= 0.0 and powerBlock.exchanger.state_HTF[5].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[5].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[5].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1393(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1393};
  modelica_boolean tmp48;
  modelica_boolean tmp49;
  static const MMC_DEFSTRINGLIT(tmp50,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[5].p <= 100000000.0, has value: ");
  modelica_string tmp51;
  static int tmp52 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp52)
  {
    tmp48 = GreaterEq(data->simulationInfo->realParameter[543] /* powerBlock.exchanger.state_HTF[5].p PARAM */,0.0);
    tmp49 = LessEq(data->simulationInfo->realParameter[543] /* powerBlock.exchanger.state_HTF[5].p PARAM */,100000000.0);
    if(!(tmp48 && tmp49))
    {
      tmp51 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[543] /* powerBlock.exchanger.state_HTF[5].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp50),tmp51);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[5].p >= 0.0 and powerBlock.exchanger.state_HTF[5].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp52 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1394
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[6].p >= 0.0 and powerBlock.exchanger.state_HTF[6].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[6].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[6].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1394(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1394};
  modelica_boolean tmp53;
  modelica_boolean tmp54;
  static const MMC_DEFSTRINGLIT(tmp55,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[6].p <= 100000000.0, has value: ");
  modelica_string tmp56;
  static int tmp57 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp57)
  {
    tmp53 = GreaterEq(data->simulationInfo->realParameter[544] /* powerBlock.exchanger.state_HTF[6].p PARAM */,0.0);
    tmp54 = LessEq(data->simulationInfo->realParameter[544] /* powerBlock.exchanger.state_HTF[6].p PARAM */,100000000.0);
    if(!(tmp53 && tmp54))
    {
      tmp56 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[544] /* powerBlock.exchanger.state_HTF[6].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp55),tmp56);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[6].p >= 0.0 and powerBlock.exchanger.state_HTF[6].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp57 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1395
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[7].p >= 0.0 and powerBlock.exchanger.state_HTF[7].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[7].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[7].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1395(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1395};
  modelica_boolean tmp58;
  modelica_boolean tmp59;
  static const MMC_DEFSTRINGLIT(tmp60,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[7].p <= 100000000.0, has value: ");
  modelica_string tmp61;
  static int tmp62 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp62)
  {
    tmp58 = GreaterEq(data->simulationInfo->realParameter[545] /* powerBlock.exchanger.state_HTF[7].p PARAM */,0.0);
    tmp59 = LessEq(data->simulationInfo->realParameter[545] /* powerBlock.exchanger.state_HTF[7].p PARAM */,100000000.0);
    if(!(tmp58 && tmp59))
    {
      tmp61 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[545] /* powerBlock.exchanger.state_HTF[7].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp60),tmp61);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[7].p >= 0.0 and powerBlock.exchanger.state_HTF[7].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp62 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1396
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[8].p >= 0.0 and powerBlock.exchanger.state_HTF[8].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[8].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[8].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1396(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1396};
  modelica_boolean tmp63;
  modelica_boolean tmp64;
  static const MMC_DEFSTRINGLIT(tmp65,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[8].p <= 100000000.0, has value: ");
  modelica_string tmp66;
  static int tmp67 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp67)
  {
    tmp63 = GreaterEq(data->simulationInfo->realParameter[546] /* powerBlock.exchanger.state_HTF[8].p PARAM */,0.0);
    tmp64 = LessEq(data->simulationInfo->realParameter[546] /* powerBlock.exchanger.state_HTF[8].p PARAM */,100000000.0);
    if(!(tmp63 && tmp64))
    {
      tmp66 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[546] /* powerBlock.exchanger.state_HTF[8].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp65),tmp66);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[8].p >= 0.0 and powerBlock.exchanger.state_HTF[8].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp67 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1397
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[9].p >= 0.0 and powerBlock.exchanger.state_HTF[9].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[9].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[9].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1397(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1397};
  modelica_boolean tmp68;
  modelica_boolean tmp69;
  static const MMC_DEFSTRINGLIT(tmp70,109,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[9].p <= 100000000.0, has value: ");
  modelica_string tmp71;
  static int tmp72 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp72)
  {
    tmp68 = GreaterEq(data->simulationInfo->realParameter[547] /* powerBlock.exchanger.state_HTF[9].p PARAM */,0.0);
    tmp69 = LessEq(data->simulationInfo->realParameter[547] /* powerBlock.exchanger.state_HTF[9].p PARAM */,100000000.0);
    if(!(tmp68 && tmp69))
    {
      tmp71 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[547] /* powerBlock.exchanger.state_HTF[9].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp70),tmp71);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[9].p >= 0.0 and powerBlock.exchanger.state_HTF[9].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp72 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1398
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[10].p >= 0.0 and powerBlock.exchanger.state_HTF[10].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[10].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[10].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1398(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1398};
  modelica_boolean tmp73;
  modelica_boolean tmp74;
  static const MMC_DEFSTRINGLIT(tmp75,110,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[10].p <= 100000000.0, has value: ");
  modelica_string tmp76;
  static int tmp77 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp77)
  {
    tmp73 = GreaterEq(data->simulationInfo->realParameter[548] /* powerBlock.exchanger.state_HTF[10].p PARAM */,0.0);
    tmp74 = LessEq(data->simulationInfo->realParameter[548] /* powerBlock.exchanger.state_HTF[10].p PARAM */,100000000.0);
    if(!(tmp73 && tmp74))
    {
      tmp76 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[548] /* powerBlock.exchanger.state_HTF[10].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp75),tmp76);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[10].p >= 0.0 and powerBlock.exchanger.state_HTF[10].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp77 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1399
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[11].p >= 0.0 and powerBlock.exchanger.state_HTF[11].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[11].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[11].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1399(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1399};
  modelica_boolean tmp78;
  modelica_boolean tmp79;
  static const MMC_DEFSTRINGLIT(tmp80,110,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[11].p <= 100000000.0, has value: ");
  modelica_string tmp81;
  static int tmp82 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp82)
  {
    tmp78 = GreaterEq(data->simulationInfo->realParameter[549] /* powerBlock.exchanger.state_HTF[11].p PARAM */,0.0);
    tmp79 = LessEq(data->simulationInfo->realParameter[549] /* powerBlock.exchanger.state_HTF[11].p PARAM */,100000000.0);
    if(!(tmp78 && tmp79))
    {
      tmp81 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[549] /* powerBlock.exchanger.state_HTF[11].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp80),tmp81);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[11].p >= 0.0 and powerBlock.exchanger.state_HTF[11].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp82 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1400
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[12].p >= 0.0 and powerBlock.exchanger.state_HTF[12].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[12].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[12].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1400(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1400};
  modelica_boolean tmp83;
  modelica_boolean tmp84;
  static const MMC_DEFSTRINGLIT(tmp85,110,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[12].p <= 100000000.0, has value: ");
  modelica_string tmp86;
  static int tmp87 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp87)
  {
    tmp83 = GreaterEq(data->simulationInfo->realParameter[550] /* powerBlock.exchanger.state_HTF[12].p PARAM */,0.0);
    tmp84 = LessEq(data->simulationInfo->realParameter[550] /* powerBlock.exchanger.state_HTF[12].p PARAM */,100000000.0);
    if(!(tmp83 && tmp84))
    {
      tmp86 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[550] /* powerBlock.exchanger.state_HTF[12].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp85),tmp86);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[12].p >= 0.0 and powerBlock.exchanger.state_HTF[12].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp87 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1401
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[13].p >= 0.0 and powerBlock.exchanger.state_HTF[13].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[13].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[13].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1401(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1401};
  modelica_boolean tmp88;
  modelica_boolean tmp89;
  static const MMC_DEFSTRINGLIT(tmp90,110,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[13].p <= 100000000.0, has value: ");
  modelica_string tmp91;
  static int tmp92 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp92)
  {
    tmp88 = GreaterEq(data->simulationInfo->realParameter[551] /* powerBlock.exchanger.state_HTF[13].p PARAM */,0.0);
    tmp89 = LessEq(data->simulationInfo->realParameter[551] /* powerBlock.exchanger.state_HTF[13].p PARAM */,100000000.0);
    if(!(tmp88 && tmp89))
    {
      tmp91 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[551] /* powerBlock.exchanger.state_HTF[13].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp90),tmp91);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[13].p >= 0.0 and powerBlock.exchanger.state_HTF[13].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp92 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1402
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[14].p >= 0.0 and powerBlock.exchanger.state_HTF[14].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[14].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[14].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1402(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1402};
  modelica_boolean tmp93;
  modelica_boolean tmp94;
  static const MMC_DEFSTRINGLIT(tmp95,110,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[14].p <= 100000000.0, has value: ");
  modelica_string tmp96;
  static int tmp97 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp97)
  {
    tmp93 = GreaterEq(data->simulationInfo->realParameter[552] /* powerBlock.exchanger.state_HTF[14].p PARAM */,0.0);
    tmp94 = LessEq(data->simulationInfo->realParameter[552] /* powerBlock.exchanger.state_HTF[14].p PARAM */,100000000.0);
    if(!(tmp93 && tmp94))
    {
      tmp96 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[552] /* powerBlock.exchanger.state_HTF[14].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp95),tmp96);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[14].p >= 0.0 and powerBlock.exchanger.state_HTF[14].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp97 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1403
type: ALGORITHM

  assert(powerBlock.exchanger.state_HTF[15].p >= 0.0 and powerBlock.exchanger.state_HTF[15].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[15].p <= 100000000.0, has value: " + String(powerBlock.exchanger.state_HTF[15].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1403(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1403};
  modelica_boolean tmp98;
  modelica_boolean tmp99;
  static const MMC_DEFSTRINGLIT(tmp100,110,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.state_HTF[15].p <= 100000000.0, has value: ");
  modelica_string tmp101;
  static int tmp102 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp102)
  {
    tmp98 = GreaterEq(data->simulationInfo->realParameter[553] /* powerBlock.exchanger.state_HTF[15].p PARAM */,0.0);
    tmp99 = LessEq(data->simulationInfo->realParameter[553] /* powerBlock.exchanger.state_HTF[15].p PARAM */,100000000.0);
    if(!(tmp98 && tmp99))
    {
      tmp101 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[553] /* powerBlock.exchanger.state_HTF[15].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp100),tmp101);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.state_HTF[15].p >= 0.0 and powerBlock.exchanger.state_HTF[15].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp102 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1404
type: ALGORITHM

  assert(liftSimple.fluid_b.p >= 0.0 and liftSimple.fluid_b.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= liftSimple.fluid_b.p <= 100000000.0, has value: " + String(liftSimple.fluid_b.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1404(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1404};
  modelica_boolean tmp103;
  modelica_boolean tmp104;
  static const MMC_DEFSTRINGLIT(tmp105,94,"Variable violating min/max constraint: 0.0 <= liftSimple.fluid_b.p <= 100000000.0, has value: ");
  modelica_string tmp106;
  static int tmp107 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp107)
  {
    tmp103 = GreaterEq(data->simulationInfo->realParameter[16] /* liftSimple.fluid_b.p PARAM */,0.0);
    tmp104 = LessEq(data->simulationInfo->realParameter[16] /* liftSimple.fluid_b.p PARAM */,100000000.0);
    if(!(tmp103 && tmp104))
    {
      tmp106 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[16] /* liftSimple.fluid_b.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp105),tmp106);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",15,5,15,79,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nliftSimple.fluid_b.p >= 0.0 and liftSimple.fluid_b.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp107 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1405
type: ALGORITHM

  assert(powerBlock.fluid_a.p >= 0.0 and powerBlock.fluid_a.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.fluid_a.p <= 100000000.0, has value: " + String(powerBlock.fluid_a.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1405(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1405};
  modelica_boolean tmp108;
  modelica_boolean tmp109;
  static const MMC_DEFSTRINGLIT(tmp110,94,"Variable violating min/max constraint: 0.0 <= powerBlock.fluid_a.p <= 100000000.0, has value: ");
  modelica_string tmp111;
  static int tmp112 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp112)
  {
    tmp108 = GreaterEq(data->simulationInfo->realParameter[585] /* powerBlock.fluid_a.p PARAM */,0.0);
    tmp109 = LessEq(data->simulationInfo->realParameter[585] /* powerBlock.fluid_a.p PARAM */,100000000.0);
    if(!(tmp108 && tmp109))
    {
      tmp111 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[585] /* powerBlock.fluid_a.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp110),tmp111);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",15,5,15,79,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.fluid_a.p >= 0.0 and powerBlock.fluid_a.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp112 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1406
type: ALGORITHM

  assert(powerBlock.exchanger.HTF_port_a.p >= 0.0 and powerBlock.exchanger.HTF_port_a.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.HTF_port_a.p <= 100000000.0, has value: " + String(powerBlock.exchanger.HTF_port_a.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1406(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1406};
  modelica_boolean tmp113;
  modelica_boolean tmp114;
  static const MMC_DEFSTRINGLIT(tmp115,107,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.HTF_port_a.p <= 100000000.0, has value: ");
  modelica_string tmp116;
  static int tmp117 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp117)
  {
    tmp113 = GreaterEq(data->simulationInfo->realParameter[430] /* powerBlock.exchanger.HTF_port_a.p PARAM */,0.0);
    tmp114 = LessEq(data->simulationInfo->realParameter[430] /* powerBlock.exchanger.HTF_port_a.p PARAM */,100000000.0);
    if(!(tmp113 && tmp114))
    {
      tmp116 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[430] /* powerBlock.exchanger.HTF_port_a.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp115),tmp116);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",15,5,15,79,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.HTF_port_a.p >= 0.0 and powerBlock.exchanger.HTF_port_a.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp117 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1407
type: ALGORITHM

  assert(powerBlock.exchanger.HTF_port_b.p >= 0.0 and powerBlock.exchanger.HTF_port_b.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.HTF_port_b.p <= 100000000.0, has value: " + String(powerBlock.exchanger.HTF_port_b.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1407(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1407};
  modelica_boolean tmp118;
  modelica_boolean tmp119;
  static const MMC_DEFSTRINGLIT(tmp120,107,"Variable violating min/max constraint: 0.0 <= powerBlock.exchanger.HTF_port_b.p <= 100000000.0, has value: ");
  modelica_string tmp121;
  static int tmp122 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp122)
  {
    tmp118 = GreaterEq(data->simulationInfo->realParameter[431] /* powerBlock.exchanger.HTF_port_b.p PARAM */,0.0);
    tmp119 = LessEq(data->simulationInfo->realParameter[431] /* powerBlock.exchanger.HTF_port_b.p PARAM */,100000000.0);
    if(!(tmp118 && tmp119))
    {
      tmp121 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[431] /* powerBlock.exchanger.HTF_port_b.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp120),tmp121);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",15,5,15,79,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.HTF_port_b.p >= 0.0 and powerBlock.exchanger.HTF_port_b.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp122 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1408
type: ALGORITHM

  assert(powerBlock.fluid_b.p >= 0.0 and powerBlock.fluid_b.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.fluid_b.p <= 100000000.0, has value: " + String(powerBlock.fluid_b.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1408(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1408};
  modelica_boolean tmp123;
  modelica_boolean tmp124;
  static const MMC_DEFSTRINGLIT(tmp125,94,"Variable violating min/max constraint: 0.0 <= powerBlock.fluid_b.p <= 100000000.0, has value: ");
  modelica_string tmp126;
  static int tmp127 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp127)
  {
    tmp123 = GreaterEq(data->simulationInfo->realParameter[586] /* powerBlock.fluid_b.p PARAM */,0.0);
    tmp124 = LessEq(data->simulationInfo->realParameter[586] /* powerBlock.fluid_b.p PARAM */,100000000.0);
    if(!(tmp123 && tmp124))
    {
      tmp126 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[586] /* powerBlock.fluid_b.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp125),tmp126);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",15,5,15,79,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.fluid_b.p >= 0.0 and powerBlock.fluid_b.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp127 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1409
type: ALGORITHM

  assert(sink.ports[1].p >= 0.0 and sink.ports[1].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= sink.ports[1].p <= 100000000.0, has value: " + String(sink.ports[1].p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1409(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1409};
  modelica_boolean tmp128;
  modelica_boolean tmp129;
  static const MMC_DEFSTRINGLIT(tmp130,89,"Variable violating min/max constraint: 0.0 <= sink.ports[1].p <= 100000000.0, has value: ");
  modelica_string tmp131;
  static int tmp132 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp132)
  {
    tmp128 = GreaterEq(data->simulationInfo->realParameter[683] /* sink.ports[1].p PARAM */,0.0);
    tmp129 = LessEq(data->simulationInfo->realParameter[683] /* sink.ports[1].p PARAM */,100000000.0);
    if(!(tmp128 && tmp129))
    {
      tmp131 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[683] /* sink.ports[1].p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp130),tmp131);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",15,5,15,79,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.ports[1].p >= 0.0 and sink.ports[1].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp132 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1410
type: ALGORITHM

  assert(sink.medium.p >= 0.0, "Variable violating min constraint: 0.0 <= sink.medium.p, has value: " + String(sink.medium.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1410(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1410};
  modelica_boolean tmp133;
  static const MMC_DEFSTRINGLIT(tmp134,68,"Variable violating min constraint: 0.0 <= sink.medium.p, has value: ");
  modelica_string tmp135;
  static int tmp136 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp136)
  {
    tmp133 = GreaterEq(data->simulationInfo->realParameter[680] /* sink.medium.p PARAM */,0.0);
    if(!tmp133)
    {
      tmp135 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[680] /* sink.medium.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp134),tmp135);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Media/package.mo",4477,7,4477,60,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.medium.p >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp136 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1411
type: ALGORITHM

  assert(sink.state.p >= 0.0 and sink.state.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= sink.state.p <= 100000000.0, has value: " + String(sink.state.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1411(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1411};
  modelica_boolean tmp137;
  modelica_boolean tmp138;
  static const MMC_DEFSTRINGLIT(tmp139,86,"Variable violating min/max constraint: 0.0 <= sink.state.p <= 100000000.0, has value: ");
  modelica_string tmp140;
  static int tmp141 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp141)
  {
    tmp137 = GreaterEq(data->simulationInfo->realParameter[684] /* sink.state.p PARAM */,0.0);
    tmp138 = LessEq(data->simulationInfo->realParameter[684] /* sink.state.p PARAM */,100000000.0);
    if(!(tmp137 && tmp138))
    {
      tmp140 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[684] /* sink.state.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp139),tmp140);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/SolidParticles/CarboHSP_ph/package.mo",71,3,71,51,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.state.p >= 0.0 and sink.state.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp141 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1412
type: ALGORITHM

  assert(powerBlock.cooler.T_amb >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.cooler.T_amb, has value: " + String(powerBlock.cooler.T_amb, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1412(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1412};
  modelica_boolean tmp142;
  static const MMC_DEFSTRINGLIT(tmp143,78,"Variable violating min constraint: 0.0 <= powerBlock.cooler.T_amb, has value: ");
  modelica_string tmp144;
  static int tmp145 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp145)
  {
    tmp142 = GreaterEq(data->simulationInfo->realParameter[340] /* powerBlock.cooler.T_amb PARAM */,0.0);
    if(!tmp142)
    {
      tmp144 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[340] /* powerBlock.cooler.T_amb PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp143),tmp144);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",381,4,381,89,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.cooler.T_amb >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp145 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1413
type: ALGORITHM

  assert(liftSimple.eff >= 0.0, "Variable violating min constraint: 0.0 <= liftSimple.eff, has value: " + String(liftSimple.eff, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1413(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1413};
  modelica_boolean tmp146;
  static const MMC_DEFSTRINGLIT(tmp147,69,"Variable violating min constraint: 0.0 <= liftSimple.eff, has value: ");
  modelica_string tmp148;
  static int tmp149 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp149)
  {
    tmp146 = GreaterEq(data->simulationInfo->realParameter[15] /* liftSimple.eff PARAM */,0.0);
    if(!tmp146)
    {
      tmp148 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[15] /* liftSimple.eff PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp147),tmp148);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/Fluid/Pumps/LiftSimple.mo",16,2,16,64,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nliftSimple.eff >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp149 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1414
type: ALGORITHM

  assert(liftSimple.dh >= 0.0, "Variable violating min constraint: 0.0 <= liftSimple.dh, has value: " + String(liftSimple.dh, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1414(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1414};
  modelica_boolean tmp150;
  static const MMC_DEFSTRINGLIT(tmp151,68,"Variable violating min constraint: 0.0 <= liftSimple.dh, has value: ");
  modelica_string tmp152;
  static int tmp153 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp153)
  {
    tmp150 = GreaterEq(data->simulationInfo->realParameter[13] /* liftSimple.dh PARAM */,0.0);
    if(!tmp150)
    {
      tmp152 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[13] /* liftSimple.dh PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp151),tmp152);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/Fluid/Pumps/LiftSimple.mo",14,2,14,52,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nliftSimple.dh >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp153 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1415
type: ALGORITHM

  assert(sink.X[5] >= 0.0 and sink.X[5] <= 1.0, "Variable violating min/max constraint: 0.0 <= sink.X[5] <= 1.0, has value: " + String(sink.X[5], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1415(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1415};
  modelica_boolean tmp154;
  modelica_boolean tmp155;
  static const MMC_DEFSTRINGLIT(tmp156,75,"Variable violating min/max constraint: 0.0 <= sink.X[5] <= 1.0, has value: ");
  modelica_string tmp157;
  static int tmp158 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp158)
  {
    tmp154 = GreaterEq(data->simulationInfo->realParameter[677] /* sink.X[5] PARAM */,0.0);
    tmp155 = LessEq(data->simulationInfo->realParameter[677] /* sink.X[5] PARAM */,1.0);
    if(!(tmp154 && tmp155))
    {
      tmp157 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[677] /* sink.X[5] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp156),tmp157);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.X[5] >= 0.0 and sink.X[5] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp158 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1416
type: ALGORITHM

  assert(sink.X[4] >= 0.0 and sink.X[4] <= 1.0, "Variable violating min/max constraint: 0.0 <= sink.X[4] <= 1.0, has value: " + String(sink.X[4], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1416(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1416};
  modelica_boolean tmp159;
  modelica_boolean tmp160;
  static const MMC_DEFSTRINGLIT(tmp161,75,"Variable violating min/max constraint: 0.0 <= sink.X[4] <= 1.0, has value: ");
  modelica_string tmp162;
  static int tmp163 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp163)
  {
    tmp159 = GreaterEq(data->simulationInfo->realParameter[676] /* sink.X[4] PARAM */,0.0);
    tmp160 = LessEq(data->simulationInfo->realParameter[676] /* sink.X[4] PARAM */,1.0);
    if(!(tmp159 && tmp160))
    {
      tmp162 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[676] /* sink.X[4] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp161),tmp162);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.X[4] >= 0.0 and sink.X[4] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp163 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1417
type: ALGORITHM

  assert(sink.X[3] >= 0.0 and sink.X[3] <= 1.0, "Variable violating min/max constraint: 0.0 <= sink.X[3] <= 1.0, has value: " + String(sink.X[3], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1417(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1417};
  modelica_boolean tmp164;
  modelica_boolean tmp165;
  static const MMC_DEFSTRINGLIT(tmp166,75,"Variable violating min/max constraint: 0.0 <= sink.X[3] <= 1.0, has value: ");
  modelica_string tmp167;
  static int tmp168 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp168)
  {
    tmp164 = GreaterEq(data->simulationInfo->realParameter[675] /* sink.X[3] PARAM */,0.0);
    tmp165 = LessEq(data->simulationInfo->realParameter[675] /* sink.X[3] PARAM */,1.0);
    if(!(tmp164 && tmp165))
    {
      tmp167 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[675] /* sink.X[3] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp166),tmp167);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.X[3] >= 0.0 and sink.X[3] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp168 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1418
type: ALGORITHM

  assert(sink.X[2] >= 0.0 and sink.X[2] <= 1.0, "Variable violating min/max constraint: 0.0 <= sink.X[2] <= 1.0, has value: " + String(sink.X[2], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1418(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1418};
  modelica_boolean tmp169;
  modelica_boolean tmp170;
  static const MMC_DEFSTRINGLIT(tmp171,75,"Variable violating min/max constraint: 0.0 <= sink.X[2] <= 1.0, has value: ");
  modelica_string tmp172;
  static int tmp173 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp173)
  {
    tmp169 = GreaterEq(data->simulationInfo->realParameter[674] /* sink.X[2] PARAM */,0.0);
    tmp170 = LessEq(data->simulationInfo->realParameter[674] /* sink.X[2] PARAM */,1.0);
    if(!(tmp169 && tmp170))
    {
      tmp172 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[674] /* sink.X[2] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp171),tmp172);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.X[2] >= 0.0 and sink.X[2] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp173 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1419
type: ALGORITHM

  assert(sink.X[1] >= 0.0 and sink.X[1] <= 1.0, "Variable violating min/max constraint: 0.0 <= sink.X[1] <= 1.0, has value: " + String(sink.X[1], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1419(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1419};
  modelica_boolean tmp174;
  modelica_boolean tmp175;
  static const MMC_DEFSTRINGLIT(tmp176,75,"Variable violating min/max constraint: 0.0 <= sink.X[1] <= 1.0, has value: ");
  modelica_string tmp177;
  static int tmp178 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp178)
  {
    tmp174 = GreaterEq(data->simulationInfo->realParameter[673] /* sink.X[1] PARAM */,0.0);
    tmp175 = LessEq(data->simulationInfo->realParameter[673] /* sink.X[1] PARAM */,1.0);
    if(!(tmp174 && tmp175))
    {
      tmp177 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[673] /* sink.X[1] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp176),tmp177);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.X[1] >= 0.0 and sink.X[1] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp178 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1420
type: ALGORITHM

  assert(sink.h >= -10000000000.0 and sink.h <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= sink.h <= 10000000000.0, has value: " + String(sink.h, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1420(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1420};
  modelica_boolean tmp179;
  modelica_boolean tmp180;
  static const MMC_DEFSTRINGLIT(tmp181,93,"Variable violating min/max constraint: -10000000000.0 <= sink.h <= 10000000000.0, has value: ");
  modelica_string tmp182;
  static int tmp183 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp183)
  {
    tmp179 = GreaterEq(data->simulationInfo->realParameter[679] /* sink.h PARAM */,-10000000000.0);
    tmp180 = LessEq(data->simulationInfo->realParameter[679] /* sink.h PARAM */,10000000000.0);
    if(!(tmp179 && tmp180))
    {
      tmp182 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[679] /* sink.h PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp181),tmp182);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",27,5,30,39,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.h >= -10000000000.0 and sink.h <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp183 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1421
type: ALGORITHM

  assert(sink.d >= 0.0 and sink.d <= 100000.0, "Variable violating min/max constraint: 0.0 <= sink.d <= 100000.0, has value: " + String(sink.d, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1421(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1421};
  modelica_boolean tmp184;
  modelica_boolean tmp185;
  static const MMC_DEFSTRINGLIT(tmp186,77,"Variable violating min/max constraint: 0.0 <= sink.d <= 100000.0, has value: ");
  modelica_string tmp187;
  static int tmp188 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp188)
  {
    tmp184 = GreaterEq(data->simulationInfo->realParameter[678] /* sink.d PARAM */,0.0);
    tmp185 = LessEq(data->simulationInfo->realParameter[678] /* sink.d PARAM */,100000.0);
    if(!(tmp184 && tmp185))
    {
      tmp187 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[678] /* sink.d PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp186),tmp187);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",13,3,20,44,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.d >= 0.0 and sink.d <= 100000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp188 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1422
type: ALGORITHM

  assert(sink.flowDirection >= Modelica.Fluid.Types.PortFlowDirection.Entering and sink.flowDirection <= Modelica.Fluid.Types.PortFlowDirection.Bidirectional, "Variable violating min/max constraint: Modelica.Fluid.Types.PortFlowDirection.Entering <= sink.flowDirection <= Modelica.Fluid.Types.PortFlowDirection.Bidirectional, has value: " + String(sink.flowDirection, "d"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1422(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1422};
  modelica_boolean tmp189;
  modelica_boolean tmp190;
  static const MMC_DEFSTRINGLIT(tmp191,177,"Variable violating min/max constraint: Modelica.Fluid.Types.PortFlowDirection.Entering <= sink.flowDirection <= Modelica.Fluid.Types.PortFlowDirection.Bidirectional, has value: ");
  modelica_string tmp192;
  static int tmp193 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp193)
  {
    tmp189 = GreaterEq(data->simulationInfo->integerParameter[10] /* sink.flowDirection PARAM */,1);
    tmp190 = LessEq(data->simulationInfo->integerParameter[10] /* sink.flowDirection PARAM */,3);
    if(!(tmp189 && tmp190))
    {
      tmp192 = modelica_integer_to_modelica_string_format(data->simulationInfo->integerParameter[10] /* sink.flowDirection PARAM */, (modelica_string) mmc_strings_len1[100]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp191),tmp192);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",776,5,778,95,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsink.flowDirection >= Modelica.Fluid.Types.PortFlowDirection.Entering and sink.flowDirection <= Modelica.Fluid.Types.PortFlowDirection.Bidirectional", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp193 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1423
type: ALGORITHM

  assert(source.X[5] >= 0.0 and source.X[5] <= 1.0, "Variable violating min/max constraint: 0.0 <= source.X[5] <= 1.0, has value: " + String(source.X[5], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1423(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1423};
  modelica_boolean tmp194;
  modelica_boolean tmp195;
  static const MMC_DEFSTRINGLIT(tmp196,77,"Variable violating min/max constraint: 0.0 <= source.X[5] <= 1.0, has value: ");
  modelica_string tmp197;
  static int tmp198 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp198)
  {
    tmp194 = GreaterEq(data->simulationInfo->realParameter[690] /* source.X[5] PARAM */,0.0);
    tmp195 = LessEq(data->simulationInfo->realParameter[690] /* source.X[5] PARAM */,1.0);
    if(!(tmp194 && tmp195))
    {
      tmp197 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[690] /* source.X[5] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp196),tmp197);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.X[5] >= 0.0 and source.X[5] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp198 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1424
type: ALGORITHM

  assert(source.X[4] >= 0.0 and source.X[4] <= 1.0, "Variable violating min/max constraint: 0.0 <= source.X[4] <= 1.0, has value: " + String(source.X[4], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1424(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1424};
  modelica_boolean tmp199;
  modelica_boolean tmp200;
  static const MMC_DEFSTRINGLIT(tmp201,77,"Variable violating min/max constraint: 0.0 <= source.X[4] <= 1.0, has value: ");
  modelica_string tmp202;
  static int tmp203 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp203)
  {
    tmp199 = GreaterEq(data->simulationInfo->realParameter[689] /* source.X[4] PARAM */,0.0);
    tmp200 = LessEq(data->simulationInfo->realParameter[689] /* source.X[4] PARAM */,1.0);
    if(!(tmp199 && tmp200))
    {
      tmp202 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[689] /* source.X[4] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp201),tmp202);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.X[4] >= 0.0 and source.X[4] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp203 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1425
type: ALGORITHM

  assert(source.X[3] >= 0.0 and source.X[3] <= 1.0, "Variable violating min/max constraint: 0.0 <= source.X[3] <= 1.0, has value: " + String(source.X[3], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1425(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1425};
  modelica_boolean tmp204;
  modelica_boolean tmp205;
  static const MMC_DEFSTRINGLIT(tmp206,77,"Variable violating min/max constraint: 0.0 <= source.X[3] <= 1.0, has value: ");
  modelica_string tmp207;
  static int tmp208 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp208)
  {
    tmp204 = GreaterEq(data->simulationInfo->realParameter[688] /* source.X[3] PARAM */,0.0);
    tmp205 = LessEq(data->simulationInfo->realParameter[688] /* source.X[3] PARAM */,1.0);
    if(!(tmp204 && tmp205))
    {
      tmp207 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[688] /* source.X[3] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp206),tmp207);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.X[3] >= 0.0 and source.X[3] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp208 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1426
type: ALGORITHM

  assert(source.X[2] >= 0.0 and source.X[2] <= 1.0, "Variable violating min/max constraint: 0.0 <= source.X[2] <= 1.0, has value: " + String(source.X[2], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1426(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1426};
  modelica_boolean tmp209;
  modelica_boolean tmp210;
  static const MMC_DEFSTRINGLIT(tmp211,77,"Variable violating min/max constraint: 0.0 <= source.X[2] <= 1.0, has value: ");
  modelica_string tmp212;
  static int tmp213 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp213)
  {
    tmp209 = GreaterEq(data->simulationInfo->realParameter[687] /* source.X[2] PARAM */,0.0);
    tmp210 = LessEq(data->simulationInfo->realParameter[687] /* source.X[2] PARAM */,1.0);
    if(!(tmp209 && tmp210))
    {
      tmp212 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[687] /* source.X[2] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp211),tmp212);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.X[2] >= 0.0 and source.X[2] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp213 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1427
type: ALGORITHM

  assert(source.X[1] >= 0.0 and source.X[1] <= 1.0, "Variable violating min/max constraint: 0.0 <= source.X[1] <= 1.0, has value: " + String(source.X[1], "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1427(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1427};
  modelica_boolean tmp214;
  modelica_boolean tmp215;
  static const MMC_DEFSTRINGLIT(tmp216,77,"Variable violating min/max constraint: 0.0 <= source.X[1] <= 1.0, has value: ");
  modelica_string tmp217;
  static int tmp218 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp218)
  {
    tmp214 = GreaterEq(data->simulationInfo->realParameter[686] /* source.X[1] PARAM */,0.0);
    tmp215 = LessEq(data->simulationInfo->realParameter[686] /* source.X[1] PARAM */,1.0);
    if(!(tmp214 && tmp215))
    {
      tmp217 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[686] /* source.X[1] PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp216),tmp217);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",31,5,34,90,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.X[1] >= 0.0 and source.X[1] <= 1.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp218 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1428
type: ALGORITHM

  assert(source.h >= -10000000000.0 and source.h <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= source.h <= 10000000000.0, has value: " + String(source.h, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1428(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1428};
  modelica_boolean tmp219;
  modelica_boolean tmp220;
  static const MMC_DEFSTRINGLIT(tmp221,95,"Variable violating min/max constraint: -10000000000.0 <= source.h <= 10000000000.0, has value: ");
  modelica_string tmp222;
  static int tmp223 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp223)
  {
    tmp219 = GreaterEq(data->simulationInfo->realParameter[692] /* source.h PARAM */,-10000000000.0);
    tmp220 = LessEq(data->simulationInfo->realParameter[692] /* source.h PARAM */,10000000000.0);
    if(!(tmp219 && tmp220))
    {
      tmp222 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[692] /* source.h PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp221),tmp222);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",27,5,30,39,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.h >= -10000000000.0 and source.h <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp223 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1429
type: ALGORITHM

  assert(source.d >= 0.0 and source.d <= 100000.0, "Variable violating min/max constraint: 0.0 <= source.d <= 100000.0, has value: " + String(source.d, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1429(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1429};
  modelica_boolean tmp224;
  modelica_boolean tmp225;
  static const MMC_DEFSTRINGLIT(tmp226,79,"Variable violating min/max constraint: 0.0 <= source.d <= 100000.0, has value: ");
  modelica_string tmp227;
  static int tmp228 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp228)
  {
    tmp224 = GreaterEq(data->simulationInfo->realParameter[691] /* source.d PARAM */,0.0);
    tmp225 = LessEq(data->simulationInfo->realParameter[691] /* source.d PARAM */,100000.0);
    if(!(tmp224 && tmp225))
    {
      tmp227 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[691] /* source.d PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp226),tmp227);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",13,3,20,44,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.d >= 0.0 and source.d <= 100000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp228 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1430
type: ALGORITHM

  assert(source.p >= 0.0 and source.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= source.p <= 100000000.0, has value: " + String(source.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1430(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1430};
  modelica_boolean tmp229;
  modelica_boolean tmp230;
  static const MMC_DEFSTRINGLIT(tmp231,82,"Variable violating min/max constraint: 0.0 <= source.p <= 100000000.0, has value: ");
  modelica_string tmp232;
  static int tmp233 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp233)
  {
    tmp229 = GreaterEq(data->simulationInfo->realParameter[693] /* source.p PARAM */,0.0);
    tmp230 = LessEq(data->simulationInfo->realParameter[693] /* source.p PARAM */,100000000.0);
    if(!(tmp229 && tmp230))
    {
      tmp232 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[693] /* source.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp231),tmp232);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",10,5,12,42,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.p >= 0.0 and source.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp233 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1431
type: ALGORITHM

  assert(source.flowDirection >= Modelica.Fluid.Types.PortFlowDirection.Entering and source.flowDirection <= Modelica.Fluid.Types.PortFlowDirection.Bidirectional, "Variable violating min/max constraint: Modelica.Fluid.Types.PortFlowDirection.Entering <= source.flowDirection <= Modelica.Fluid.Types.PortFlowDirection.Bidirectional, has value: " + String(source.flowDirection, "d"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1431(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1431};
  modelica_boolean tmp234;
  modelica_boolean tmp235;
  static const MMC_DEFSTRINGLIT(tmp236,179,"Variable violating min/max constraint: Modelica.Fluid.Types.PortFlowDirection.Entering <= source.flowDirection <= Modelica.Fluid.Types.PortFlowDirection.Bidirectional, has value: ");
  modelica_string tmp237;
  static int tmp238 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp238)
  {
    tmp234 = GreaterEq(data->simulationInfo->integerParameter[12] /* source.flowDirection PARAM */,1);
    tmp235 = LessEq(data->simulationInfo->integerParameter[12] /* source.flowDirection PARAM */,3);
    if(!(tmp234 && tmp235))
    {
      tmp237 = modelica_integer_to_modelica_string_format(data->simulationInfo->integerParameter[12] /* source.flowDirection PARAM */, (modelica_string) mmc_strings_len1[100]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp236),tmp237);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Sources.mo",776,5,778,95,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nsource.flowDirection >= Modelica.Fluid.Types.PortFlowDirection.Entering and source.flowDirection <= Modelica.Fluid.Types.PortFlowDirection.Bidirectional", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp238 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1432
type: ALGORITHM

  assert(powerBlock.state_HTF_in_des.h >= -10000000000.0 and powerBlock.state_HTF_in_des.h <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.state_HTF_in_des.h <= 10000000000.0, has value: " + String(powerBlock.state_HTF_in_des.h, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1432(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1432};
  modelica_boolean tmp239;
  modelica_boolean tmp240;
  static const MMC_DEFSTRINGLIT(tmp241,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.state_HTF_in_des.h <= 10000000000.0, has value: ");
  modelica_string tmp242;
  static int tmp243 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp243)
  {
    tmp239 = GreaterEq(data->simulationInfo->realParameter[644] /* powerBlock.state_HTF_in_des.h PARAM */,-10000000000.0);
    tmp240 = LessEq(data->simulationInfo->realParameter[644] /* powerBlock.state_HTF_in_des.h PARAM */,10000000000.0);
    if(!(tmp239 && tmp240))
    {
      tmp242 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[644] /* powerBlock.state_HTF_in_des.h PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp241),tmp242);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/SolidParticles/CarboHSP_ph/package.mo",72,3,72,41,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.state_HTF_in_des.h >= -10000000000.0 and powerBlock.state_HTF_in_des.h <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp243 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1433
type: ALGORITHM

  assert(powerBlock.state_HTF_in_des.p >= 0.0 and powerBlock.state_HTF_in_des.p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.state_HTF_in_des.p <= 100000000.0, has value: " + String(powerBlock.state_HTF_in_des.p, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1433(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1433};
  modelica_boolean tmp244;
  modelica_boolean tmp245;
  static const MMC_DEFSTRINGLIT(tmp246,103,"Variable violating min/max constraint: 0.0 <= powerBlock.state_HTF_in_des.p <= 100000000.0, has value: ");
  modelica_string tmp247;
  static int tmp248 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp248)
  {
    tmp244 = GreaterEq(data->simulationInfo->realParameter[645] /* powerBlock.state_HTF_in_des.p PARAM */,0.0);
    tmp245 = LessEq(data->simulationInfo->realParameter[645] /* powerBlock.state_HTF_in_des.p PARAM */,100000000.0);
    if(!(tmp244 && tmp245))
    {
      tmp247 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[645] /* powerBlock.state_HTF_in_des.p PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp246),tmp247);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/SolidParticles/CarboHSP_ph/package.mo",71,3,71,51,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.state_HTF_in_des.p >= 0.0 and powerBlock.state_HTF_in_des.p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp248 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1434
type: ALGORITHM

  assert(powerBlock.pinch_recuperator >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.pinch_recuperator, has value: " + String(powerBlock.pinch_recuperator, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1434(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1434};
  modelica_boolean tmp249;
  static const MMC_DEFSTRINGLIT(tmp250,83,"Variable violating min constraint: 0.0 <= powerBlock.pinch_recuperator, has value: ");
  modelica_string tmp251;
  static int tmp252 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp252)
  {
    tmp249 = GreaterEq(data->simulationInfo->realParameter[613] /* powerBlock.pinch_recuperator PARAM */,0.0);
    if(!tmp249)
    {
      tmp251 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[613] /* powerBlock.pinch_recuperator PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp250),tmp251);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1948,7,1948,53,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.pinch_recuperator >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp252 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1435
type: ALGORITHM

  assert(powerBlock.reCompressor.phi_opt >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.phi_opt, has value: " + String(powerBlock.reCompressor.phi_opt, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1435(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1435};
  modelica_boolean tmp253;
  static const MMC_DEFSTRINGLIT(tmp254,86,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.phi_opt, has value: ");
  modelica_string tmp255;
  static int tmp256 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp256)
  {
    tmp253 = GreaterEq(data->simulationInfo->realParameter[635] /* powerBlock.reCompressor.phi_opt PARAM */,0.0);
    if(!tmp253)
    {
      tmp255 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[635] /* powerBlock.reCompressor.phi_opt PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp254),tmp255);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",600,4,600,81,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.phi_opt >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp256 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1436
type: ALGORITHM

  assert(p_high >= 0.0, "Variable violating min constraint: 0.0 <= p_high, has value: " + String(p_high, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1436(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1436};
  modelica_boolean tmp257;
  static const MMC_DEFSTRINGLIT(tmp258,61,"Variable violating min constraint: 0.0 <= p_high, has value: ");
  modelica_string tmp259;
  static int tmp260 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp260)
  {
    tmp257 = GreaterEq(data->simulationInfo->realParameter[24] /* p_high PARAM */,0.0);
    if(!tmp257)
    {
      tmp259 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[24] /* p_high PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp258),tmp259);
      {
        FILE_INFO info = {"/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation/sCO2PBCalculator_Using_JPidea.mo",24,3,24,82,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\np_high >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp260 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1437
type: ALGORITHM

  assert(powerBlock.p_high >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.p_high, has value: " + String(powerBlock.p_high, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1437(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1437};
  modelica_boolean tmp261;
  static const MMC_DEFSTRINGLIT(tmp262,72,"Variable violating min constraint: 0.0 <= powerBlock.p_high, has value: ");
  modelica_string tmp263;
  static int tmp264 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp264)
  {
    tmp261 = GreaterEq(data->simulationInfo->realParameter[610] /* powerBlock.p_high PARAM */,0.0);
    if(!tmp261)
    {
      tmp263 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[610] /* powerBlock.p_high PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp262),tmp263);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1953,7,1953,87,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.p_high >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp264 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1438
type: ALGORITHM

  assert(powerBlock.reCompressor.p_high_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.p_high_des, has value: " + String(powerBlock.reCompressor.p_high_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1438(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1438};
  modelica_boolean tmp265;
  static const MMC_DEFSTRINGLIT(tmp266,89,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.p_high_des, has value: ");
  modelica_string tmp267;
  static int tmp268 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp268)
  {
    tmp265 = GreaterEq(data->simulationInfo->realParameter[632] /* powerBlock.reCompressor.p_high_des PARAM */,0.0);
    if(!tmp265)
    {
      tmp267 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[632] /* powerBlock.reCompressor.p_high_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp266),tmp267);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",599,4,599,60,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.p_high_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp268 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1439
type: ALGORITHM

  assert(powerBlock.reCompressor.T_in_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.T_in_des, has value: " + String(powerBlock.reCompressor.T_in_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1439(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1439};
  modelica_boolean tmp269;
  static const MMC_DEFSTRINGLIT(tmp270,87,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.T_in_des, has value: ");
  modelica_string tmp271;
  static int tmp272 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp272)
  {
    tmp269 = GreaterEq(data->simulationInfo->realParameter[625] /* powerBlock.reCompressor.T_in_des PARAM */,0.0);
    if(!tmp269)
    {
      tmp271 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[625] /* powerBlock.reCompressor.T_in_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp270),tmp271);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",598,4,598,127,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.T_in_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp272 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1440
type: ALGORITHM

  assert(powerBlock.reCompressor.PR >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.PR, has value: " + String(powerBlock.reCompressor.PR, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1440(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1440};
  modelica_boolean tmp273;
  static const MMC_DEFSTRINGLIT(tmp274,81,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.PR, has value: ");
  modelica_string tmp275;
  static int tmp276 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp276)
  {
    tmp273 = GreaterEq(data->simulationInfo->realParameter[623] /* powerBlock.reCompressor.PR PARAM */,0.0);
    if(!tmp273)
    {
      tmp275 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[623] /* powerBlock.reCompressor.PR PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp274),tmp275);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",596,4,596,58,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.PR >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp276 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1441
type: ALGORITHM

  assert(powerBlock.reCompressor.eta_design >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.eta_design, has value: " + String(powerBlock.reCompressor.eta_design, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1441(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1441};
  modelica_boolean tmp277;
  static const MMC_DEFSTRINGLIT(tmp278,89,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.eta_design, has value: ");
  modelica_string tmp279;
  static int tmp280 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp280)
  {
    tmp277 = GreaterEq(data->simulationInfo->realParameter[628] /* powerBlock.reCompressor.eta_design PARAM */,0.0);
    if(!tmp277)
    {
      tmp279 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[628] /* powerBlock.reCompressor.eta_design PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp278),tmp279);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",594,4,594,95,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.eta_design >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp280 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1442
type: ALGORITHM

  assert(T_in_ref_blk >= 0.0, "Variable violating min constraint: 0.0 <= T_in_ref_blk, has value: " + String(T_in_ref_blk, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1442(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1442};
  modelica_boolean tmp281;
  static const MMC_DEFSTRINGLIT(tmp282,67,"Variable violating min constraint: 0.0 <= T_in_ref_blk, has value: ");
  modelica_string tmp283;
  static int tmp284 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp284)
  {
    tmp281 = GreaterEq(data->simulationInfo->realParameter[6] /* T_in_ref_blk PARAM */,0.0);
    if(!tmp281)
    {
      tmp283 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[6] /* T_in_ref_blk PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp282),tmp283);
      {
        FILE_INFO info = {"/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation/sCO2PBCalculator_Using_JPidea.mo",23,3,23,50,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nT_in_ref_blk >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp284 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1443
type: ALGORITHM

  assert(powerBlock.T_HTF_in_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.T_HTF_in_des, has value: " + String(powerBlock.T_HTF_in_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1443(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1443};
  modelica_boolean tmp285;
  static const MMC_DEFSTRINGLIT(tmp286,78,"Variable violating min constraint: 0.0 <= powerBlock.T_HTF_in_des, has value: ");
  modelica_string tmp287;
  static int tmp288 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp288)
  {
    tmp285 = GreaterEq(data->simulationInfo->realParameter[312] /* powerBlock.T_HTF_in_des PARAM */,0.0);
    if(!tmp285)
    {
      tmp287 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[312] /* powerBlock.T_HTF_in_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp286),tmp287);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1984,7,1984,72,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.T_HTF_in_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp288 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1444
type: ALGORITHM

  assert(powerBlock.exchanger.T_in_HTF_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_in_HTF_des, has value: " + String(powerBlock.exchanger.T_in_HTF_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1444(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1444};
  modelica_boolean tmp289;
  static const MMC_DEFSTRINGLIT(tmp290,88,"Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_in_HTF_des, has value: ");
  modelica_string tmp291;
  static int tmp292 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp292)
  {
    tmp289 = GreaterEq(data->simulationInfo->realParameter[464] /* powerBlock.exchanger.T_in_HTF_des PARAM */,0.0);
    if(!tmp289)
    {
      tmp291 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[464] /* powerBlock.exchanger.T_in_HTF_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp290),tmp291);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2268,7,2268,68,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.T_in_HTF_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp292 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1445
type: ALGORITHM

  assert(T_cold_set >= 0.0, "Variable violating min constraint: 0.0 <= T_cold_set, has value: " + String(T_cold_set, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1445(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1445};
  modelica_boolean tmp293;
  static const MMC_DEFSTRINGLIT(tmp294,65,"Variable violating min constraint: 0.0 <= T_cold_set, has value: ");
  modelica_string tmp295;
  static int tmp296 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp296)
  {
    tmp293 = GreaterEq(data->simulationInfo->realParameter[5] /* T_cold_set PARAM */,0.0);
    if(!tmp293)
    {
      tmp295 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[5] /* T_cold_set PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp294),tmp295);
      {
        FILE_INFO info = {"/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation/sCO2PBCalculator_Using_JPidea.mo",28,3,28,69,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nT_cold_set >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp296 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1446
type: ALGORITHM

  assert(powerBlock.T_HTF_out >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.T_HTF_out, has value: " + String(powerBlock.T_HTF_out, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1446(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1446};
  modelica_boolean tmp297;
  static const MMC_DEFSTRINGLIT(tmp298,75,"Variable violating min constraint: 0.0 <= powerBlock.T_HTF_out, has value: ");
  modelica_string tmp299;
  static int tmp300 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp300)
  {
    tmp297 = GreaterEq(data->simulationInfo->realParameter[313] /* powerBlock.T_HTF_out PARAM */,0.0);
    if(!tmp297)
    {
      tmp299 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[313] /* powerBlock.T_HTF_out PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp298),tmp299);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1950,7,1950,50,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.T_HTF_out >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp300 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1447
type: ALGORITHM

  assert(powerBlock.exchanger.T_out_HTF_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_out_HTF_des, has value: " + String(powerBlock.exchanger.T_out_HTF_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1447(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1447};
  modelica_boolean tmp301;
  static const MMC_DEFSTRINGLIT(tmp302,89,"Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_out_HTF_des, has value: ");
  modelica_string tmp303;
  static int tmp304 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp304)
  {
    tmp301 = GreaterEq(data->simulationInfo->realParameter[466] /* powerBlock.exchanger.T_out_HTF_des PARAM */,0.0);
    if(!tmp301)
    {
      tmp303 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[466] /* powerBlock.exchanger.T_out_HTF_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp302),tmp303);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2269,7,2269,68,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.T_out_HTF_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp304 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1448
type: ALGORITHM

  assert(powerBlock.exchanger.T_out_CO2_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_out_CO2_des, has value: " + String(powerBlock.exchanger.T_out_CO2_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1448(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1448};
  modelica_boolean tmp305;
  static const MMC_DEFSTRINGLIT(tmp306,89,"Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_out_CO2_des, has value: ");
  modelica_string tmp307;
  static int tmp308 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp308)
  {
    tmp305 = GreaterEq(data->simulationInfo->realParameter[465] /* powerBlock.exchanger.T_out_CO2_des PARAM */,0.0);
    if(!tmp305)
    {
      tmp307 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[465] /* powerBlock.exchanger.T_out_CO2_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp306),tmp307);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2271,4,2271,73,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.T_out_CO2_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp308 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1449
type: ALGORITHM

  assert(blk_T_amb_des >= 0.0, "Variable violating min constraint: 0.0 <= blk_T_amb_des, has value: " + String(blk_T_amb_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1449(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1449};
  modelica_boolean tmp309;
  static const MMC_DEFSTRINGLIT(tmp310,68,"Variable violating min constraint: 0.0 <= blk_T_amb_des, has value: ");
  modelica_string tmp311;
  static int tmp312 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp312)
  {
    tmp309 = GreaterEq(data->simulationInfo->realParameter[8] /* blk_T_amb_des PARAM */,0.0);
    if(!tmp309)
    {
      tmp311 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[8] /* blk_T_amb_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp310),tmp311);
      {
        FILE_INFO info = {"/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation/sCO2PBCalculator_Using_JPidea.mo",35,3,35,57,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nblk_T_amb_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp312 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1450
type: ALGORITHM

  assert(powerBlock.T_amb_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.T_amb_des, has value: " + String(powerBlock.T_amb_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1450(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1450};
  modelica_boolean tmp313;
  static const MMC_DEFSTRINGLIT(tmp314,75,"Variable violating min constraint: 0.0 <= powerBlock.T_amb_des, has value: ");
  modelica_string tmp315;
  static int tmp316 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp316)
  {
    tmp313 = GreaterEq(data->simulationInfo->realParameter[315] /* powerBlock.T_amb_des PARAM */,0.0);
    if(!tmp313)
    {
      tmp315 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[315] /* powerBlock.T_amb_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp314),tmp315);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1955,7,1955,90,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.T_amb_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp316 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1451
type: ALGORITHM

  assert(powerBlock.turbine.T_amb >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.turbine.T_amb, has value: " + String(powerBlock.turbine.T_amb, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1451(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1451};
  modelica_boolean tmp317;
  static const MMC_DEFSTRINGLIT(tmp318,79,"Variable violating min constraint: 0.0 <= powerBlock.turbine.T_amb, has value: ");
  modelica_string tmp319;
  static int tmp320 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp320)
  {
    tmp317 = GreaterEq(data->simulationInfo->realParameter[650] /* powerBlock.turbine.T_amb PARAM */,0.0);
    if(!tmp317)
    {
      tmp319 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[650] /* powerBlock.turbine.T_amb PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp318),tmp319);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",140,4,140,85,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.turbine.T_amb >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp320 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1452
type: ALGORITHM

  assert(powerBlock.turbine.PR >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.turbine.PR, has value: " + String(powerBlock.turbine.PR, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1452(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1452};
  modelica_boolean tmp321;
  static const MMC_DEFSTRINGLIT(tmp322,76,"Variable violating min constraint: 0.0 <= powerBlock.turbine.PR, has value: ");
  modelica_string tmp323;
  static int tmp324 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp324)
  {
    tmp321 = GreaterEq(data->simulationInfo->realParameter[649] /* powerBlock.turbine.PR PARAM */,0.0);
    if(!tmp321)
    {
      tmp323 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[649] /* powerBlock.turbine.PR PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp322),tmp323);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",139,4,139,65,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.turbine.PR >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp324 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1453
type: ALGORITHM

  assert(powerBlock.eta_turb >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.eta_turb, has value: " + String(powerBlock.eta_turb, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1453(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1453};
  modelica_boolean tmp325;
  static const MMC_DEFSTRINGLIT(tmp326,74,"Variable violating min constraint: 0.0 <= powerBlock.eta_turb, has value: ");
  modelica_string tmp327;
  static int tmp328 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp328)
  {
    tmp325 = GreaterEq(data->simulationInfo->realParameter[429] /* powerBlock.eta_turb PARAM */,0.0);
    if(!tmp325)
    {
      tmp327 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[429] /* powerBlock.eta_turb PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp326),tmp327);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1972,7,1972,93,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.eta_turb >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp328 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1454
type: ALGORITHM

  assert(powerBlock.turbine.eta_design >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.turbine.eta_design, has value: " + String(powerBlock.turbine.eta_design, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1454(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1454};
  modelica_boolean tmp329;
  static const MMC_DEFSTRINGLIT(tmp330,84,"Variable violating min constraint: 0.0 <= powerBlock.turbine.eta_design, has value: ");
  modelica_string tmp331;
  static int tmp332 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp332)
  {
    tmp329 = GreaterEq(data->simulationInfo->realParameter[653] /* powerBlock.turbine.eta_design PARAM */,0.0);
    if(!tmp329)
    {
      tmp331 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[653] /* powerBlock.turbine.eta_design PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp330),tmp331);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",138,4,138,97,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.turbine.eta_design >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp332 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1455
type: ALGORITHM

  assert(T_low >= 0.0, "Variable violating min constraint: 0.0 <= T_low, has value: " + String(T_low, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1455(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1455};
  modelica_boolean tmp333;
  static const MMC_DEFSTRINGLIT(tmp334,60,"Variable violating min constraint: 0.0 <= T_low, has value: ");
  modelica_string tmp335;
  static int tmp336 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp336)
  {
    tmp333 = GreaterEq(data->simulationInfo->realParameter[7] /* T_low PARAM */,0.0);
    if(!tmp333)
    {
      tmp335 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[7] /* T_low PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp334),tmp335);
      {
        FILE_INFO info = {"/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation/sCO2PBCalculator_Using_JPidea.mo",34,3,34,93,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\nT_low >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp336 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1456
type: ALGORITHM

  assert(powerBlock.T_low >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.T_low, has value: " + String(powerBlock.T_low, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1456(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1456};
  modelica_boolean tmp337;
  static const MMC_DEFSTRINGLIT(tmp338,71,"Variable violating min constraint: 0.0 <= powerBlock.T_low, has value: ");
  modelica_string tmp339;
  static int tmp340 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp340)
  {
    tmp337 = GreaterEq(data->simulationInfo->realParameter[316] /* powerBlock.T_low PARAM */,0.0);
    if(!tmp337)
    {
      tmp339 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[316] /* powerBlock.T_low PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp338),tmp339);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1982,7,1982,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.T_low >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp340 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1457
type: ALGORITHM

  assert(powerBlock.cooler.T_low >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.cooler.T_low, has value: " + String(powerBlock.cooler.T_low, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1457(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1457};
  modelica_boolean tmp341;
  static const MMC_DEFSTRINGLIT(tmp342,78,"Variable violating min constraint: 0.0 <= powerBlock.cooler.T_low, has value: ");
  modelica_string tmp343;
  static int tmp344 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp344)
  {
    tmp341 = GreaterEq(data->simulationInfo->realParameter[342] /* powerBlock.cooler.T_low PARAM */,0.0);
    if(!tmp341)
    {
      tmp343 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[342] /* powerBlock.cooler.T_low PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp342),tmp343);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",385,4,385,64,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.cooler.T_low >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp344 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1458
type: ALGORITHM

  assert(powerBlock.cooler.T_amb_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.cooler.T_amb_des, has value: " + String(powerBlock.cooler.T_amb_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1458(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1458};
  modelica_boolean tmp345;
  static const MMC_DEFSTRINGLIT(tmp346,82,"Variable violating min constraint: 0.0 <= powerBlock.cooler.T_amb_des, has value: ");
  modelica_string tmp347;
  static int tmp348 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp348)
  {
    tmp345 = GreaterEq(data->simulationInfo->realParameter[341] /* powerBlock.cooler.T_amb_des PARAM */,0.0);
    if(!tmp345)
    {
      tmp347 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[341] /* powerBlock.cooler.T_amb_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp346),tmp347);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",383,4,383,116,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.cooler.T_amb_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp348 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1459
type: ALGORITHM

  assert(powerBlock.mainCompressor.phi_opt >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.phi_opt, has value: " + String(powerBlock.mainCompressor.phi_opt, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1459(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1459};
  modelica_boolean tmp349;
  static const MMC_DEFSTRINGLIT(tmp350,88,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.phi_opt, has value: ");
  modelica_string tmp351;
  static int tmp352 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp352)
  {
    tmp349 = GreaterEq(data->simulationInfo->realParameter[602] /* powerBlock.mainCompressor.phi_opt PARAM */,0.0);
    if(!tmp349)
    {
      tmp351 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[602] /* powerBlock.mainCompressor.phi_opt PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp350),tmp351);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",600,4,600,81,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.phi_opt >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp352 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1460
type: ALGORITHM

  assert(powerBlock.mainCompressor.p_high_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.p_high_des, has value: " + String(powerBlock.mainCompressor.p_high_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1460(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1460};
  modelica_boolean tmp353;
  static const MMC_DEFSTRINGLIT(tmp354,91,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.p_high_des, has value: ");
  modelica_string tmp355;
  static int tmp356 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp356)
  {
    tmp353 = GreaterEq(data->simulationInfo->realParameter[599] /* powerBlock.mainCompressor.p_high_des PARAM */,0.0);
    if(!tmp353)
    {
      tmp355 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[599] /* powerBlock.mainCompressor.p_high_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp354),tmp355);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",599,4,599,60,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.p_high_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp356 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1461
type: ALGORITHM

  assert(powerBlock.mainCompressor.T_in_des >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.T_in_des, has value: " + String(powerBlock.mainCompressor.T_in_des, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1461(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1461};
  modelica_boolean tmp357;
  static const MMC_DEFSTRINGLIT(tmp358,89,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.T_in_des, has value: ");
  modelica_string tmp359;
  static int tmp360 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp360)
  {
    tmp357 = GreaterEq(data->simulationInfo->realParameter[592] /* powerBlock.mainCompressor.T_in_des PARAM */,0.0);
    if(!tmp357)
    {
      tmp359 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[592] /* powerBlock.mainCompressor.T_in_des PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp358),tmp359);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",598,4,598,127,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.T_in_des >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp360 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1462
type: ALGORITHM

  assert(powerBlock.mainCompressor.PR >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.PR, has value: " + String(powerBlock.mainCompressor.PR, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1462(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1462};
  modelica_boolean tmp361;
  static const MMC_DEFSTRINGLIT(tmp362,83,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.PR, has value: ");
  modelica_string tmp363;
  static int tmp364 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp364)
  {
    tmp361 = GreaterEq(data->simulationInfo->realParameter[590] /* powerBlock.mainCompressor.PR PARAM */,0.0);
    if(!tmp361)
    {
      tmp363 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[590] /* powerBlock.mainCompressor.PR PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp362),tmp363);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",596,4,596,58,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.PR >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp364 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1463
type: ALGORITHM

  assert(powerBlock.eta_comp_main >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.eta_comp_main, has value: " + String(powerBlock.eta_comp_main, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1463(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1463};
  modelica_boolean tmp365;
  static const MMC_DEFSTRINGLIT(tmp366,79,"Variable violating min constraint: 0.0 <= powerBlock.eta_comp_main, has value: ");
  modelica_string tmp367;
  static int tmp368 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp368)
  {
    tmp365 = GreaterEq(data->simulationInfo->realParameter[424] /* powerBlock.eta_comp_main PARAM */,0.0);
    if(!tmp365)
    {
      tmp367 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[424] /* powerBlock.eta_comp_main PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp366),tmp367);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1968,7,1968,101,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.eta_comp_main >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp368 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1464
type: ALGORITHM

  assert(powerBlock.mainCompressor.eta_design >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.eta_design, has value: " + String(powerBlock.mainCompressor.eta_design, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1464(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1464};
  modelica_boolean tmp369;
  static const MMC_DEFSTRINGLIT(tmp370,91,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.eta_design, has value: ");
  modelica_string tmp371;
  static int tmp372 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp372)
  {
    tmp369 = GreaterEq(data->simulationInfo->realParameter[595] /* powerBlock.mainCompressor.eta_design PARAM */,0.0);
    if(!tmp369)
    {
      tmp371 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[595] /* powerBlock.mainCompressor.eta_design PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp370),tmp371);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",594,4,594,95,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.eta_design >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp372 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1465
type: ALGORITHM

  assert(eta_motor >= 0.0, "Variable violating min constraint: 0.0 <= eta_motor, has value: " + String(eta_motor, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1465(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1465};
  modelica_boolean tmp373;
  static const MMC_DEFSTRINGLIT(tmp374,64,"Variable violating min constraint: 0.0 <= eta_motor, has value: ");
  modelica_string tmp375;
  static int tmp376 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp376)
  {
    tmp373 = GreaterEq(data->simulationInfo->realParameter[10] /* eta_motor PARAM */,0.0);
    if(!tmp373)
    {
      tmp375 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[10] /* eta_motor PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp374),tmp375);
      {
        FILE_INFO info = {"/home/philgun/solartherm-particle/SolarTherm/Resources/Include/simulation/sCO2PBCalculator_Using_JPidea.mo",41,3,41,77,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\neta_motor >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp376 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1466
type: ALGORITHM

  assert(powerBlock.eta_motor >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.eta_motor, has value: " + String(powerBlock.eta_motor, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1466(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1466};
  modelica_boolean tmp377;
  static const MMC_DEFSTRINGLIT(tmp378,75,"Variable violating min constraint: 0.0 <= powerBlock.eta_motor, has value: ");
  modelica_string tmp379;
  static int tmp380 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp380)
  {
    tmp377 = GreaterEq(data->simulationInfo->realParameter[427] /* powerBlock.eta_motor PARAM */,0.0);
    if(!tmp377)
    {
      tmp379 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[427] /* powerBlock.eta_motor PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp378),tmp379);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1974,7,1974,78,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.eta_motor >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp380 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1467
type: ALGORITHM

  assert(powerBlock.eta_comp_re >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.eta_comp_re, has value: " + String(powerBlock.eta_comp_re, "g"));
*/
OMC_DISABLE_OPT
static void sCO2PBCalculator_Using_JPidea_eqFunction_1467(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1467};
  modelica_boolean tmp381;
  static const MMC_DEFSTRINGLIT(tmp382,77,"Variable violating min constraint: 0.0 <= powerBlock.eta_comp_re, has value: ");
  modelica_string tmp383;
  static int tmp384 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp384)
  {
    tmp381 = GreaterEq(data->simulationInfo->realParameter[425] /* powerBlock.eta_comp_re PARAM */,0.0);
    if(!tmp381)
    {
      tmp383 = modelica_real_to_modelica_string_format(data->simulationInfo->realParameter[425] /* powerBlock.eta_comp_re PARAM */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp382),tmp383);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",1970,7,1970,100,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.eta_comp_re >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp384 = 1;
    }
  }
  TRACE_POP
}
OMC_DISABLE_OPT
void sCO2PBCalculator_Using_JPidea_updateBoundParameters_0(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  sCO2PBCalculator_Using_JPidea_eqFunction_1206(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1207(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1208(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1209(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1210(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1211(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1212(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1213(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1214(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1215(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1216(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1217(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1218(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1219(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1220(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1221(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1222(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1223(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1224(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1225(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1226(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1227(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1228(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1229(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1230(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1231(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1232(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1233(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1234(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1235(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1236(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1237(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1238(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1239(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1240(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1241(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1242(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1243(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1244(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1245(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1246(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1247(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_21(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_22(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_905(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_906(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_909(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_907(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_908(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1255(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1256(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1257(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1258(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1259(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1260(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1261(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1262(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1263(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1264(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1265(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1266(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1267(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1268(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1269(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1270(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1271(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1272(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1273(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1274(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1275(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1276(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1277(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1278(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1279(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1280(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1281(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1282(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1283(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1298(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1299(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1300(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1302(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1303(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1305(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1306(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1307(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1308(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1309(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1310(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1311(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1312(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1313(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1316(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1317(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1318(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1319(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1320(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1321(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1324(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1325(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1326(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1327(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1329(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1330(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1331(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1333(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1334(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1335(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1336(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1337(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1338(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1340(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1343(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1345(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1346(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1347(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1348(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_904(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_903(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_902(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_901(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_900(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_23(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_899(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_24(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_25(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_20(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_19(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_18(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_17(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_16(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_15(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_14(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_13(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_12(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_11(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_10(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_9(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_8(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_7(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_6(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_5(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_4(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_3(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_2(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1383(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1384(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1385(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1386(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1387(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1388(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1389(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1390(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1391(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1392(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1393(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1394(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1395(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1396(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1397(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1398(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1399(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1400(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1401(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1402(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1403(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1404(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1405(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1406(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1407(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1408(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1409(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1410(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1411(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1412(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1413(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1414(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1415(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1416(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1417(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1418(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1419(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1420(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1421(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1422(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1423(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1424(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1425(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1426(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1427(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1428(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1429(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1430(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1431(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1432(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1433(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1434(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1435(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1436(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1437(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1438(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1439(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1440(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1441(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1442(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1443(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1444(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1445(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1446(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1447(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1448(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1449(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1450(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1451(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1452(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1453(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1454(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1455(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1456(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1457(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1458(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1459(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1460(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1461(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1462(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1463(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1464(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1465(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1466(data, threadData);
  sCO2PBCalculator_Using_JPidea_eqFunction_1467(data, threadData);
  TRACE_POP
}
OMC_DISABLE_OPT
int sCO2PBCalculator_Using_JPidea_updateBoundParameters(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  data->simulationInfo->integerParameter[1] /* N_LTR_parameter PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[1].time_unvarying = 1;
  data->simulationInfo->integerParameter[2] /* N_exch_parameter PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[2].time_unvarying = 1;
  data->simulationInfo->integerParameter[3] /* powerBlock.HTR.N_q PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[3].time_unvarying = 1;
  data->simulationInfo->integerParameter[4] /* powerBlock.LTR.N_q PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[4].time_unvarying = 1;
  data->simulationInfo->integerParameter[5] /* powerBlock.N_HTR PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[5].time_unvarying = 1;
  data->simulationInfo->integerParameter[6] /* powerBlock.N_LTR PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[6].time_unvarying = 1;
  data->simulationInfo->integerParameter[7] /* powerBlock.N_exch PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[7].time_unvarying = 1;
  data->simulationInfo->integerParameter[8] /* powerBlock.cooler.N_cool PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[8].time_unvarying = 1;
  data->simulationInfo->integerParameter[9] /* powerBlock.exchanger.N_exch PARAM */ = ((modelica_integer) 15);
  data->modelData->integerParameterData[9].time_unvarying = 1;
  data->simulationInfo->integerParameter[11] /* sink.nPorts PARAM */ = ((modelica_integer) 1);
  data->modelData->integerParameterData[11].time_unvarying = 1;
  data->simulationInfo->integerParameter[13] /* source.nPorts PARAM */ = ((modelica_integer) 1);
  data->modelData->integerParameterData[13].time_unvarying = 1;
  data->simulationInfo->realParameter[1] /* P_net PARAM */ = 20000000.0;
  data->modelData->realParameterData[1].time_unvarying = 1;
  data->simulationInfo->realParameter[172] /* powerBlock.LTR.P_nom_des PARAM */ = 20000000.0;
  data->modelData->realParameterData[172].time_unvarying = 1;
  data->simulationInfo->realParameter[310] /* powerBlock.P_nom PARAM */ = 20000000.0;
  data->modelData->realParameterData[310].time_unvarying = 1;
  data->simulationInfo->realParameter[322] /* powerBlock.cooler.P_nom_des PARAM */ = 20000000.0;
  data->modelData->realParameterData[322].time_unvarying = 1;
  data->simulationInfo->realParameter[432] /* powerBlock.exchanger.P_nom_des PARAM */ = 20000000.0;
  data->modelData->realParameterData[432].time_unvarying = 1;
  data->simulationInfo->realParameter[591] /* powerBlock.mainCompressor.P_nom_des PARAM */ = 20000000.0;
  data->modelData->realParameterData[591].time_unvarying = 1;
  data->simulationInfo->realParameter[624] /* powerBlock.reCompressor.P_nom_des PARAM */ = 20000000.0;
  data->modelData->realParameterData[624].time_unvarying = 1;
  data->simulationInfo->booleanParameter[1] /* liftSimple.cont_m_flow PARAM */ = 1;
  data->modelData->booleanParameterData[1].time_unvarying = 1;
  data->simulationInfo->booleanParameter[4] /* powerBlock.test_mode PARAM */ = 1;
  data->modelData->booleanParameterData[4].time_unvarying = 1;
  data->simulationInfo->booleanParameter[5] /* sink.medium.preferredMediumStates PARAM */ = 0;
  data->modelData->booleanParameterData[5].time_unvarying = 1;
  data->simulationInfo->booleanParameter[6] /* sink.medium.standardOrderComponents PARAM */ = 1;
  data->modelData->booleanParameterData[6].time_unvarying = 1;
  data->simulationInfo->booleanParameter[7] /* sink.use_T PARAM */ = 1;
  data->modelData->booleanParameterData[7].time_unvarying = 1;
  data->simulationInfo->booleanParameter[8] /* sink.use_p PARAM */ = 1;
  data->modelData->booleanParameterData[8].time_unvarying = 1;
  data->simulationInfo->booleanParameter[9] /* source.medium.preferredMediumStates PARAM */ = 0;
  data->modelData->booleanParameterData[9].time_unvarying = 1;
  data->simulationInfo->booleanParameter[10] /* source.medium.standardOrderComponents PARAM */ = 1;
  data->modelData->booleanParameterData[10].time_unvarying = 1;
  data->simulationInfo->booleanParameter[11] /* source.use_T PARAM */ = 1;
  data->modelData->booleanParameterData[11].time_unvarying = 1;
  data->simulationInfo->booleanParameter[12] /* source.use_p PARAM */ = 0;
  data->modelData->booleanParameterData[12].time_unvarying = 1;
  data->simulationInfo->booleanParameter[13] /* test_mode PARAM */ = 1;
  data->modelData->booleanParameterData[13].time_unvarying = 1;
  data->simulationInfo->integerParameter[10] /* sink.flowDirection PARAM */ = 3;
  data->modelData->integerParameterData[10].time_unvarying = 1;
  data->simulationInfo->integerParameter[12] /* source.flowDirection PARAM */ = 3;
  data->modelData->integerParameterData[12].time_unvarying = 1;
  sCO2PBCalculator_Using_JPidea_updateBoundParameters_0(data, threadData);
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

