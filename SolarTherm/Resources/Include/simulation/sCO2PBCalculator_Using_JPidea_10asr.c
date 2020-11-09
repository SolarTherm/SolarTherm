/* Asserts */
#include "sCO2PBCalculator_Using_JPidea_model.h"
#if defined(__cplusplus)
extern "C" {
#endif


/*
equation index: 1468
type: ALGORITHM

  assert(powerBlock.HTR.from_comp_port_b.m_flow >= -100000.0 and powerBlock.HTR.from_comp_port_b.m_flow <= 100000.0, "Variable violating min/max constraint: -100000.0 <= powerBlock.HTR.from_comp_port_b.m_flow <= 100000.0, has value: " + String(powerBlock.HTR.from_comp_port_b.m_flow, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1468(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1468};
  modelica_boolean tmp0;
  modelica_boolean tmp1;
  static const MMC_DEFSTRINGLIT(tmp2,115,"Variable violating min/max constraint: -100000.0 <= powerBlock.HTR.from_comp_port_b.m_flow <= 100000.0, has value: ");
  modelica_string tmp3;
  static int tmp4 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp4)
  {
    tmp0 = GreaterEq(data->localData[0]->realVars[80] /* powerBlock.HTR.from_comp_port_b.m_flow variable */,-100000.0);
    tmp1 = LessEq(data->localData[0]->realVars[80] /* powerBlock.HTR.from_comp_port_b.m_flow variable */,100000.0);
    if(!(tmp0 && tmp1))
    {
      tmp3 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[80] /* powerBlock.HTR.from_comp_port_b.m_flow variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp2),tmp3);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",13,5,14,68,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.from_comp_port_b.m_flow >= -100000.0 and powerBlock.HTR.from_comp_port_b.m_flow <= 100000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp4 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1469
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[2] >= -10000000000.0 and powerBlock.HTR.h_from_turb[2] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[2] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1469(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1469};
  modelica_boolean tmp5;
  modelica_boolean tmp6;
  static const MMC_DEFSTRINGLIT(tmp7,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[2] <= 10000000000.0, has value: ");
  modelica_string tmp8;
  static int tmp9 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp9)
  {
    tmp5 = GreaterEq(data->localData[0]->realVars[95] /* powerBlock.HTR.h_from_turb[2] variable */,-10000000000.0);
    tmp6 = LessEq(data->localData[0]->realVars[95] /* powerBlock.HTR.h_from_turb[2] variable */,10000000000.0);
    if(!(tmp5 && tmp6))
    {
      tmp8 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[95] /* powerBlock.HTR.h_from_turb[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp7),tmp8);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[2] >= -10000000000.0 and powerBlock.HTR.h_from_turb[2] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp9 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1470
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[3] >= -10000000000.0 and powerBlock.HTR.h_from_turb[3] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[3] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1470(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1470};
  modelica_boolean tmp10;
  modelica_boolean tmp11;
  static const MMC_DEFSTRINGLIT(tmp12,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[3] <= 10000000000.0, has value: ");
  modelica_string tmp13;
  static int tmp14 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp14)
  {
    tmp10 = GreaterEq(data->localData[0]->realVars[96] /* powerBlock.HTR.h_from_turb[3] variable */,-10000000000.0);
    tmp11 = LessEq(data->localData[0]->realVars[96] /* powerBlock.HTR.h_from_turb[3] variable */,10000000000.0);
    if(!(tmp10 && tmp11))
    {
      tmp13 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[96] /* powerBlock.HTR.h_from_turb[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp12),tmp13);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[3] >= -10000000000.0 and powerBlock.HTR.h_from_turb[3] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp14 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1471
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[4] >= -10000000000.0 and powerBlock.HTR.h_from_turb[4] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[4] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1471(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1471};
  modelica_boolean tmp15;
  modelica_boolean tmp16;
  static const MMC_DEFSTRINGLIT(tmp17,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[4] <= 10000000000.0, has value: ");
  modelica_string tmp18;
  static int tmp19 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp19)
  {
    tmp15 = GreaterEq(data->localData[0]->realVars[97] /* powerBlock.HTR.h_from_turb[4] variable */,-10000000000.0);
    tmp16 = LessEq(data->localData[0]->realVars[97] /* powerBlock.HTR.h_from_turb[4] variable */,10000000000.0);
    if(!(tmp15 && tmp16))
    {
      tmp18 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[97] /* powerBlock.HTR.h_from_turb[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp17),tmp18);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[4] >= -10000000000.0 and powerBlock.HTR.h_from_turb[4] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp19 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1472
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[5] >= -10000000000.0 and powerBlock.HTR.h_from_turb[5] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[5] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1472(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1472};
  modelica_boolean tmp20;
  modelica_boolean tmp21;
  static const MMC_DEFSTRINGLIT(tmp22,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[5] <= 10000000000.0, has value: ");
  modelica_string tmp23;
  static int tmp24 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp24)
  {
    tmp20 = GreaterEq(data->localData[0]->realVars[98] /* powerBlock.HTR.h_from_turb[5] variable */,-10000000000.0);
    tmp21 = LessEq(data->localData[0]->realVars[98] /* powerBlock.HTR.h_from_turb[5] variable */,10000000000.0);
    if(!(tmp20 && tmp21))
    {
      tmp23 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[98] /* powerBlock.HTR.h_from_turb[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp22),tmp23);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[5] >= -10000000000.0 and powerBlock.HTR.h_from_turb[5] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp24 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1473
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[6] >= -10000000000.0 and powerBlock.HTR.h_from_turb[6] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[6] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1473(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1473};
  modelica_boolean tmp25;
  modelica_boolean tmp26;
  static const MMC_DEFSTRINGLIT(tmp27,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[6] <= 10000000000.0, has value: ");
  modelica_string tmp28;
  static int tmp29 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp29)
  {
    tmp25 = GreaterEq(data->localData[0]->realVars[99] /* powerBlock.HTR.h_from_turb[6] variable */,-10000000000.0);
    tmp26 = LessEq(data->localData[0]->realVars[99] /* powerBlock.HTR.h_from_turb[6] variable */,10000000000.0);
    if(!(tmp25 && tmp26))
    {
      tmp28 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[99] /* powerBlock.HTR.h_from_turb[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp27),tmp28);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[6] >= -10000000000.0 and powerBlock.HTR.h_from_turb[6] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp29 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1474
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[7] >= -10000000000.0 and powerBlock.HTR.h_from_turb[7] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[7] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1474(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1474};
  modelica_boolean tmp30;
  modelica_boolean tmp31;
  static const MMC_DEFSTRINGLIT(tmp32,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[7] <= 10000000000.0, has value: ");
  modelica_string tmp33;
  static int tmp34 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp34)
  {
    tmp30 = GreaterEq(data->localData[0]->realVars[100] /* powerBlock.HTR.h_from_turb[7] variable */,-10000000000.0);
    tmp31 = LessEq(data->localData[0]->realVars[100] /* powerBlock.HTR.h_from_turb[7] variable */,10000000000.0);
    if(!(tmp30 && tmp31))
    {
      tmp33 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[100] /* powerBlock.HTR.h_from_turb[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp32),tmp33);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[7] >= -10000000000.0 and powerBlock.HTR.h_from_turb[7] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp34 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1475
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[8] >= -10000000000.0 and powerBlock.HTR.h_from_turb[8] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[8] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1475(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1475};
  modelica_boolean tmp35;
  modelica_boolean tmp36;
  static const MMC_DEFSTRINGLIT(tmp37,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[8] <= 10000000000.0, has value: ");
  modelica_string tmp38;
  static int tmp39 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp39)
  {
    tmp35 = GreaterEq(data->localData[0]->realVars[101] /* powerBlock.HTR.h_from_turb[8] variable */,-10000000000.0);
    tmp36 = LessEq(data->localData[0]->realVars[101] /* powerBlock.HTR.h_from_turb[8] variable */,10000000000.0);
    if(!(tmp35 && tmp36))
    {
      tmp38 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[101] /* powerBlock.HTR.h_from_turb[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp37),tmp38);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[8] >= -10000000000.0 and powerBlock.HTR.h_from_turb[8] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp39 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1476
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[9] >= -10000000000.0 and powerBlock.HTR.h_from_turb[9] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[9] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1476(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1476};
  modelica_boolean tmp40;
  modelica_boolean tmp41;
  static const MMC_DEFSTRINGLIT(tmp42,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[9] <= 10000000000.0, has value: ");
  modelica_string tmp43;
  static int tmp44 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp44)
  {
    tmp40 = GreaterEq(data->localData[0]->realVars[102] /* powerBlock.HTR.h_from_turb[9] variable */,-10000000000.0);
    tmp41 = LessEq(data->localData[0]->realVars[102] /* powerBlock.HTR.h_from_turb[9] variable */,10000000000.0);
    if(!(tmp40 && tmp41))
    {
      tmp43 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[102] /* powerBlock.HTR.h_from_turb[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp42),tmp43);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[9] >= -10000000000.0 and powerBlock.HTR.h_from_turb[9] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp44 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1477
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[10] >= -10000000000.0 and powerBlock.HTR.h_from_turb[10] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[10] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1477(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1477};
  modelica_boolean tmp45;
  modelica_boolean tmp46;
  static const MMC_DEFSTRINGLIT(tmp47,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[10] <= 10000000000.0, has value: ");
  modelica_string tmp48;
  static int tmp49 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp49)
  {
    tmp45 = GreaterEq(data->localData[0]->realVars[103] /* powerBlock.HTR.h_from_turb[10] variable */,-10000000000.0);
    tmp46 = LessEq(data->localData[0]->realVars[103] /* powerBlock.HTR.h_from_turb[10] variable */,10000000000.0);
    if(!(tmp45 && tmp46))
    {
      tmp48 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[103] /* powerBlock.HTR.h_from_turb[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp47),tmp48);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[10] >= -10000000000.0 and powerBlock.HTR.h_from_turb[10] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp49 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1478
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[11] >= -10000000000.0 and powerBlock.HTR.h_from_turb[11] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[11] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1478(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1478};
  modelica_boolean tmp50;
  modelica_boolean tmp51;
  static const MMC_DEFSTRINGLIT(tmp52,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[11] <= 10000000000.0, has value: ");
  modelica_string tmp53;
  static int tmp54 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp54)
  {
    tmp50 = GreaterEq(data->localData[0]->realVars[104] /* powerBlock.HTR.h_from_turb[11] variable */,-10000000000.0);
    tmp51 = LessEq(data->localData[0]->realVars[104] /* powerBlock.HTR.h_from_turb[11] variable */,10000000000.0);
    if(!(tmp50 && tmp51))
    {
      tmp53 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[104] /* powerBlock.HTR.h_from_turb[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp52),tmp53);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[11] >= -10000000000.0 and powerBlock.HTR.h_from_turb[11] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp54 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1479
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[12] >= -10000000000.0 and powerBlock.HTR.h_from_turb[12] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[12] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1479(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1479};
  modelica_boolean tmp55;
  modelica_boolean tmp56;
  static const MMC_DEFSTRINGLIT(tmp57,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[12] <= 10000000000.0, has value: ");
  modelica_string tmp58;
  static int tmp59 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp59)
  {
    tmp55 = GreaterEq(data->localData[0]->realVars[105] /* powerBlock.HTR.h_from_turb[12] variable */,-10000000000.0);
    tmp56 = LessEq(data->localData[0]->realVars[105] /* powerBlock.HTR.h_from_turb[12] variable */,10000000000.0);
    if(!(tmp55 && tmp56))
    {
      tmp58 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[105] /* powerBlock.HTR.h_from_turb[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp57),tmp58);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[12] >= -10000000000.0 and powerBlock.HTR.h_from_turb[12] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp59 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1480
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[13] >= -10000000000.0 and powerBlock.HTR.h_from_turb[13] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[13] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1480(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1480};
  modelica_boolean tmp60;
  modelica_boolean tmp61;
  static const MMC_DEFSTRINGLIT(tmp62,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[13] <= 10000000000.0, has value: ");
  modelica_string tmp63;
  static int tmp64 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp64)
  {
    tmp60 = GreaterEq(data->localData[0]->realVars[106] /* powerBlock.HTR.h_from_turb[13] variable */,-10000000000.0);
    tmp61 = LessEq(data->localData[0]->realVars[106] /* powerBlock.HTR.h_from_turb[13] variable */,10000000000.0);
    if(!(tmp60 && tmp61))
    {
      tmp63 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[106] /* powerBlock.HTR.h_from_turb[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp62),tmp63);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[13] >= -10000000000.0 and powerBlock.HTR.h_from_turb[13] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp64 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1481
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[14] >= -10000000000.0 and powerBlock.HTR.h_from_turb[14] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[14] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1481(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1481};
  modelica_boolean tmp65;
  modelica_boolean tmp66;
  static const MMC_DEFSTRINGLIT(tmp67,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[14] <= 10000000000.0, has value: ");
  modelica_string tmp68;
  static int tmp69 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp69)
  {
    tmp65 = GreaterEq(data->localData[0]->realVars[107] /* powerBlock.HTR.h_from_turb[14] variable */,-10000000000.0);
    tmp66 = LessEq(data->localData[0]->realVars[107] /* powerBlock.HTR.h_from_turb[14] variable */,10000000000.0);
    if(!(tmp65 && tmp66))
    {
      tmp68 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[107] /* powerBlock.HTR.h_from_turb[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp67),tmp68);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[14] >= -10000000000.0 and powerBlock.HTR.h_from_turb[14] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp69 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1482
type: ALGORITHM

  assert(powerBlock.HTR.h_from_turb[15] >= -10000000000.0 and powerBlock.HTR.h_from_turb[15] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[15] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_turb[15], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1482(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1482};
  modelica_boolean tmp70;
  modelica_boolean tmp71;
  static const MMC_DEFSTRINGLIT(tmp72,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_turb[15] <= 10000000000.0, has value: ");
  modelica_string tmp73;
  static int tmp74 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp74)
  {
    tmp70 = GreaterEq(data->localData[0]->realVars[108] /* powerBlock.HTR.h_from_turb[15] variable */,-10000000000.0);
    tmp71 = LessEq(data->localData[0]->realVars[108] /* powerBlock.HTR.h_from_turb[15] variable */,10000000000.0);
    if(!(tmp70 && tmp71))
    {
      tmp73 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[108] /* powerBlock.HTR.h_from_turb[15] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp72),tmp73);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_turb[15] >= -10000000000.0 and powerBlock.HTR.h_from_turb[15] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp74 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1483
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[2] >= 20.0 and powerBlock.HTR.T_from_turb[2] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[2] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1483(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1483};
  modelica_boolean tmp75;
  modelica_boolean tmp76;
  static const MMC_DEFSTRINGLIT(tmp77,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[2] <= 873.15, has value: ");
  modelica_string tmp78;
  static int tmp79 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp79)
  {
    tmp75 = GreaterEq(data->localData[0]->realVars[51] /* powerBlock.HTR.T_from_turb[2] variable */,20.0);
    tmp76 = LessEq(data->localData[0]->realVars[51] /* powerBlock.HTR.T_from_turb[2] variable */,873.15);
    if(!(tmp75 && tmp76))
    {
      tmp78 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[51] /* powerBlock.HTR.T_from_turb[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp77),tmp78);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[2] >= 20.0 and powerBlock.HTR.T_from_turb[2] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp79 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1484
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[3] >= 20.0 and powerBlock.HTR.T_from_turb[3] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[3] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1484(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1484};
  modelica_boolean tmp80;
  modelica_boolean tmp81;
  static const MMC_DEFSTRINGLIT(tmp82,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[3] <= 873.15, has value: ");
  modelica_string tmp83;
  static int tmp84 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp84)
  {
    tmp80 = GreaterEq(data->localData[0]->realVars[52] /* powerBlock.HTR.T_from_turb[3] variable */,20.0);
    tmp81 = LessEq(data->localData[0]->realVars[52] /* powerBlock.HTR.T_from_turb[3] variable */,873.15);
    if(!(tmp80 && tmp81))
    {
      tmp83 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[52] /* powerBlock.HTR.T_from_turb[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp82),tmp83);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[3] >= 20.0 and powerBlock.HTR.T_from_turb[3] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp84 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1485
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[4] >= 20.0 and powerBlock.HTR.T_from_turb[4] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[4] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1485(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1485};
  modelica_boolean tmp85;
  modelica_boolean tmp86;
  static const MMC_DEFSTRINGLIT(tmp87,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[4] <= 873.15, has value: ");
  modelica_string tmp88;
  static int tmp89 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp89)
  {
    tmp85 = GreaterEq(data->localData[0]->realVars[53] /* powerBlock.HTR.T_from_turb[4] variable */,20.0);
    tmp86 = LessEq(data->localData[0]->realVars[53] /* powerBlock.HTR.T_from_turb[4] variable */,873.15);
    if(!(tmp85 && tmp86))
    {
      tmp88 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[53] /* powerBlock.HTR.T_from_turb[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp87),tmp88);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[4] >= 20.0 and powerBlock.HTR.T_from_turb[4] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp89 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1486
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[5] >= 20.0 and powerBlock.HTR.T_from_turb[5] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[5] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1486(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1486};
  modelica_boolean tmp90;
  modelica_boolean tmp91;
  static const MMC_DEFSTRINGLIT(tmp92,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[5] <= 873.15, has value: ");
  modelica_string tmp93;
  static int tmp94 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp94)
  {
    tmp90 = GreaterEq(data->localData[0]->realVars[54] /* powerBlock.HTR.T_from_turb[5] variable */,20.0);
    tmp91 = LessEq(data->localData[0]->realVars[54] /* powerBlock.HTR.T_from_turb[5] variable */,873.15);
    if(!(tmp90 && tmp91))
    {
      tmp93 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[54] /* powerBlock.HTR.T_from_turb[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp92),tmp93);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[5] >= 20.0 and powerBlock.HTR.T_from_turb[5] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp94 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1487
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[6] >= 20.0 and powerBlock.HTR.T_from_turb[6] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[6] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1487(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1487};
  modelica_boolean tmp95;
  modelica_boolean tmp96;
  static const MMC_DEFSTRINGLIT(tmp97,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[6] <= 873.15, has value: ");
  modelica_string tmp98;
  static int tmp99 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp99)
  {
    tmp95 = GreaterEq(data->localData[0]->realVars[55] /* powerBlock.HTR.T_from_turb[6] variable */,20.0);
    tmp96 = LessEq(data->localData[0]->realVars[55] /* powerBlock.HTR.T_from_turb[6] variable */,873.15);
    if(!(tmp95 && tmp96))
    {
      tmp98 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[55] /* powerBlock.HTR.T_from_turb[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp97),tmp98);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[6] >= 20.0 and powerBlock.HTR.T_from_turb[6] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp99 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1488
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[7] >= 20.0 and powerBlock.HTR.T_from_turb[7] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[7] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1488(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1488};
  modelica_boolean tmp100;
  modelica_boolean tmp101;
  static const MMC_DEFSTRINGLIT(tmp102,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[7] <= 873.15, has value: ");
  modelica_string tmp103;
  static int tmp104 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp104)
  {
    tmp100 = GreaterEq(data->localData[0]->realVars[56] /* powerBlock.HTR.T_from_turb[7] variable */,20.0);
    tmp101 = LessEq(data->localData[0]->realVars[56] /* powerBlock.HTR.T_from_turb[7] variable */,873.15);
    if(!(tmp100 && tmp101))
    {
      tmp103 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[56] /* powerBlock.HTR.T_from_turb[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp102),tmp103);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[7] >= 20.0 and powerBlock.HTR.T_from_turb[7] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp104 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1489
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[8] >= 20.0 and powerBlock.HTR.T_from_turb[8] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[8] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1489(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1489};
  modelica_boolean tmp105;
  modelica_boolean tmp106;
  static const MMC_DEFSTRINGLIT(tmp107,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[8] <= 873.15, has value: ");
  modelica_string tmp108;
  static int tmp109 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp109)
  {
    tmp105 = GreaterEq(data->localData[0]->realVars[57] /* powerBlock.HTR.T_from_turb[8] variable */,20.0);
    tmp106 = LessEq(data->localData[0]->realVars[57] /* powerBlock.HTR.T_from_turb[8] variable */,873.15);
    if(!(tmp105 && tmp106))
    {
      tmp108 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[57] /* powerBlock.HTR.T_from_turb[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp107),tmp108);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[8] >= 20.0 and powerBlock.HTR.T_from_turb[8] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp109 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1490
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[9] >= 20.0 and powerBlock.HTR.T_from_turb[9] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[9] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1490(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1490};
  modelica_boolean tmp110;
  modelica_boolean tmp111;
  static const MMC_DEFSTRINGLIT(tmp112,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[9] <= 873.15, has value: ");
  modelica_string tmp113;
  static int tmp114 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp114)
  {
    tmp110 = GreaterEq(data->localData[0]->realVars[58] /* powerBlock.HTR.T_from_turb[9] variable */,20.0);
    tmp111 = LessEq(data->localData[0]->realVars[58] /* powerBlock.HTR.T_from_turb[9] variable */,873.15);
    if(!(tmp110 && tmp111))
    {
      tmp113 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[58] /* powerBlock.HTR.T_from_turb[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp112),tmp113);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[9] >= 20.0 and powerBlock.HTR.T_from_turb[9] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp114 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1491
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[10] >= 20.0 and powerBlock.HTR.T_from_turb[10] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[10] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1491(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1491};
  modelica_boolean tmp115;
  modelica_boolean tmp116;
  static const MMC_DEFSTRINGLIT(tmp117,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[10] <= 873.15, has value: ");
  modelica_string tmp118;
  static int tmp119 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp119)
  {
    tmp115 = GreaterEq(data->localData[0]->realVars[59] /* powerBlock.HTR.T_from_turb[10] variable */,20.0);
    tmp116 = LessEq(data->localData[0]->realVars[59] /* powerBlock.HTR.T_from_turb[10] variable */,873.15);
    if(!(tmp115 && tmp116))
    {
      tmp118 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[59] /* powerBlock.HTR.T_from_turb[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp117),tmp118);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[10] >= 20.0 and powerBlock.HTR.T_from_turb[10] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp119 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1492
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[11] >= 20.0 and powerBlock.HTR.T_from_turb[11] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[11] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1492(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1492};
  modelica_boolean tmp120;
  modelica_boolean tmp121;
  static const MMC_DEFSTRINGLIT(tmp122,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[11] <= 873.15, has value: ");
  modelica_string tmp123;
  static int tmp124 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp124)
  {
    tmp120 = GreaterEq(data->localData[0]->realVars[60] /* powerBlock.HTR.T_from_turb[11] variable */,20.0);
    tmp121 = LessEq(data->localData[0]->realVars[60] /* powerBlock.HTR.T_from_turb[11] variable */,873.15);
    if(!(tmp120 && tmp121))
    {
      tmp123 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[60] /* powerBlock.HTR.T_from_turb[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp122),tmp123);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[11] >= 20.0 and powerBlock.HTR.T_from_turb[11] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp124 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1493
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[12] >= 20.0 and powerBlock.HTR.T_from_turb[12] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[12] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1493(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1493};
  modelica_boolean tmp125;
  modelica_boolean tmp126;
  static const MMC_DEFSTRINGLIT(tmp127,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[12] <= 873.15, has value: ");
  modelica_string tmp128;
  static int tmp129 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp129)
  {
    tmp125 = GreaterEq(data->localData[0]->realVars[61] /* powerBlock.HTR.T_from_turb[12] variable */,20.0);
    tmp126 = LessEq(data->localData[0]->realVars[61] /* powerBlock.HTR.T_from_turb[12] variable */,873.15);
    if(!(tmp125 && tmp126))
    {
      tmp128 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[61] /* powerBlock.HTR.T_from_turb[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp127),tmp128);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[12] >= 20.0 and powerBlock.HTR.T_from_turb[12] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp129 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1494
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[13] >= 20.0 and powerBlock.HTR.T_from_turb[13] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[13] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1494(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1494};
  modelica_boolean tmp130;
  modelica_boolean tmp131;
  static const MMC_DEFSTRINGLIT(tmp132,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[13] <= 873.15, has value: ");
  modelica_string tmp133;
  static int tmp134 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp134)
  {
    tmp130 = GreaterEq(data->localData[0]->realVars[62] /* powerBlock.HTR.T_from_turb[13] variable */,20.0);
    tmp131 = LessEq(data->localData[0]->realVars[62] /* powerBlock.HTR.T_from_turb[13] variable */,873.15);
    if(!(tmp130 && tmp131))
    {
      tmp133 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[62] /* powerBlock.HTR.T_from_turb[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp132),tmp133);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[13] >= 20.0 and powerBlock.HTR.T_from_turb[13] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp134 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1495
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[14] >= 20.0 and powerBlock.HTR.T_from_turb[14] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[14] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1495(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1495};
  modelica_boolean tmp135;
  modelica_boolean tmp136;
  static const MMC_DEFSTRINGLIT(tmp137,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[14] <= 873.15, has value: ");
  modelica_string tmp138;
  static int tmp139 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp139)
  {
    tmp135 = GreaterEq(data->localData[0]->realVars[63] /* powerBlock.HTR.T_from_turb[14] variable */,20.0);
    tmp136 = LessEq(data->localData[0]->realVars[63] /* powerBlock.HTR.T_from_turb[14] variable */,873.15);
    if(!(tmp135 && tmp136))
    {
      tmp138 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[63] /* powerBlock.HTR.T_from_turb[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp137),tmp138);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[14] >= 20.0 and powerBlock.HTR.T_from_turb[14] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp139 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1496
type: ALGORITHM

  assert(powerBlock.HTR.T_from_turb[15] >= 20.0 and powerBlock.HTR.T_from_turb[15] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[15] <= 873.15, has value: " + String(powerBlock.HTR.T_from_turb[15], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1496(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1496};
  modelica_boolean tmp140;
  modelica_boolean tmp141;
  static const MMC_DEFSTRINGLIT(tmp142,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_turb[15] <= 873.15, has value: ");
  modelica_string tmp143;
  static int tmp144 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp144)
  {
    tmp140 = GreaterEq(data->localData[0]->realVars[64] /* powerBlock.HTR.T_from_turb[15] variable */,20.0);
    tmp141 = LessEq(data->localData[0]->realVars[64] /* powerBlock.HTR.T_from_turb[15] variable */,873.15);
    if(!(tmp140 && tmp141))
    {
      tmp143 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[64] /* powerBlock.HTR.T_from_turb[15] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp142),tmp143);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_turb[15] >= 20.0 and powerBlock.HTR.T_from_turb[15] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp144 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1497
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[1] >= 20.0 and powerBlock.HTR.T_from_comp[1] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[1] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[1], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1497(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1497};
  modelica_boolean tmp145;
  modelica_boolean tmp146;
  static const MMC_DEFSTRINGLIT(tmp147,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[1] <= 873.15, has value: ");
  modelica_string tmp148;
  static int tmp149 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp149)
  {
    tmp145 = GreaterEq(data->localData[0]->realVars[36] /* powerBlock.HTR.T_from_comp[1] variable */,20.0);
    tmp146 = LessEq(data->localData[0]->realVars[36] /* powerBlock.HTR.T_from_comp[1] variable */,873.15);
    if(!(tmp145 && tmp146))
    {
      tmp148 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[36] /* powerBlock.HTR.T_from_comp[1] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp147),tmp148);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[1] >= 20.0 and powerBlock.HTR.T_from_comp[1] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp149 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1498
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[2] >= 20.0 and powerBlock.HTR.T_from_comp[2] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[2] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1498(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1498};
  modelica_boolean tmp150;
  modelica_boolean tmp151;
  static const MMC_DEFSTRINGLIT(tmp152,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[2] <= 873.15, has value: ");
  modelica_string tmp153;
  static int tmp154 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp154)
  {
    tmp150 = GreaterEq(data->localData[0]->realVars[37] /* powerBlock.HTR.T_from_comp[2] variable */,20.0);
    tmp151 = LessEq(data->localData[0]->realVars[37] /* powerBlock.HTR.T_from_comp[2] variable */,873.15);
    if(!(tmp150 && tmp151))
    {
      tmp153 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[37] /* powerBlock.HTR.T_from_comp[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp152),tmp153);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[2] >= 20.0 and powerBlock.HTR.T_from_comp[2] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp154 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1499
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[3] >= 20.0 and powerBlock.HTR.T_from_comp[3] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[3] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1499(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1499};
  modelica_boolean tmp155;
  modelica_boolean tmp156;
  static const MMC_DEFSTRINGLIT(tmp157,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[3] <= 873.15, has value: ");
  modelica_string tmp158;
  static int tmp159 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp159)
  {
    tmp155 = GreaterEq(data->localData[0]->realVars[38] /* powerBlock.HTR.T_from_comp[3] variable */,20.0);
    tmp156 = LessEq(data->localData[0]->realVars[38] /* powerBlock.HTR.T_from_comp[3] variable */,873.15);
    if(!(tmp155 && tmp156))
    {
      tmp158 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[38] /* powerBlock.HTR.T_from_comp[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp157),tmp158);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[3] >= 20.0 and powerBlock.HTR.T_from_comp[3] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp159 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1500
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[4] >= 20.0 and powerBlock.HTR.T_from_comp[4] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[4] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1500(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1500};
  modelica_boolean tmp160;
  modelica_boolean tmp161;
  static const MMC_DEFSTRINGLIT(tmp162,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[4] <= 873.15, has value: ");
  modelica_string tmp163;
  static int tmp164 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp164)
  {
    tmp160 = GreaterEq(data->localData[0]->realVars[39] /* powerBlock.HTR.T_from_comp[4] variable */,20.0);
    tmp161 = LessEq(data->localData[0]->realVars[39] /* powerBlock.HTR.T_from_comp[4] variable */,873.15);
    if(!(tmp160 && tmp161))
    {
      tmp163 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[39] /* powerBlock.HTR.T_from_comp[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp162),tmp163);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[4] >= 20.0 and powerBlock.HTR.T_from_comp[4] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp164 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1501
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[5] >= 20.0 and powerBlock.HTR.T_from_comp[5] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[5] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1501(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1501};
  modelica_boolean tmp165;
  modelica_boolean tmp166;
  static const MMC_DEFSTRINGLIT(tmp167,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[5] <= 873.15, has value: ");
  modelica_string tmp168;
  static int tmp169 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp169)
  {
    tmp165 = GreaterEq(data->localData[0]->realVars[40] /* powerBlock.HTR.T_from_comp[5] variable */,20.0);
    tmp166 = LessEq(data->localData[0]->realVars[40] /* powerBlock.HTR.T_from_comp[5] variable */,873.15);
    if(!(tmp165 && tmp166))
    {
      tmp168 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[40] /* powerBlock.HTR.T_from_comp[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp167),tmp168);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[5] >= 20.0 and powerBlock.HTR.T_from_comp[5] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp169 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1502
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[6] >= 20.0 and powerBlock.HTR.T_from_comp[6] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[6] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1502(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1502};
  modelica_boolean tmp170;
  modelica_boolean tmp171;
  static const MMC_DEFSTRINGLIT(tmp172,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[6] <= 873.15, has value: ");
  modelica_string tmp173;
  static int tmp174 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp174)
  {
    tmp170 = GreaterEq(data->localData[0]->realVars[41] /* powerBlock.HTR.T_from_comp[6] variable */,20.0);
    tmp171 = LessEq(data->localData[0]->realVars[41] /* powerBlock.HTR.T_from_comp[6] variable */,873.15);
    if(!(tmp170 && tmp171))
    {
      tmp173 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[41] /* powerBlock.HTR.T_from_comp[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp172),tmp173);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[6] >= 20.0 and powerBlock.HTR.T_from_comp[6] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp174 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1503
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[7] >= 20.0 and powerBlock.HTR.T_from_comp[7] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[7] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1503(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1503};
  modelica_boolean tmp175;
  modelica_boolean tmp176;
  static const MMC_DEFSTRINGLIT(tmp177,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[7] <= 873.15, has value: ");
  modelica_string tmp178;
  static int tmp179 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp179)
  {
    tmp175 = GreaterEq(data->localData[0]->realVars[42] /* powerBlock.HTR.T_from_comp[7] variable */,20.0);
    tmp176 = LessEq(data->localData[0]->realVars[42] /* powerBlock.HTR.T_from_comp[7] variable */,873.15);
    if(!(tmp175 && tmp176))
    {
      tmp178 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[42] /* powerBlock.HTR.T_from_comp[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp177),tmp178);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[7] >= 20.0 and powerBlock.HTR.T_from_comp[7] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp179 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1504
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[8] >= 20.0 and powerBlock.HTR.T_from_comp[8] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[8] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1504(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1504};
  modelica_boolean tmp180;
  modelica_boolean tmp181;
  static const MMC_DEFSTRINGLIT(tmp182,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[8] <= 873.15, has value: ");
  modelica_string tmp183;
  static int tmp184 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp184)
  {
    tmp180 = GreaterEq(data->localData[0]->realVars[43] /* powerBlock.HTR.T_from_comp[8] variable */,20.0);
    tmp181 = LessEq(data->localData[0]->realVars[43] /* powerBlock.HTR.T_from_comp[8] variable */,873.15);
    if(!(tmp180 && tmp181))
    {
      tmp183 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[43] /* powerBlock.HTR.T_from_comp[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp182),tmp183);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[8] >= 20.0 and powerBlock.HTR.T_from_comp[8] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp184 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1505
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[9] >= 20.0 and powerBlock.HTR.T_from_comp[9] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[9] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1505(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1505};
  modelica_boolean tmp185;
  modelica_boolean tmp186;
  static const MMC_DEFSTRINGLIT(tmp187,99,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[9] <= 873.15, has value: ");
  modelica_string tmp188;
  static int tmp189 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp189)
  {
    tmp185 = GreaterEq(data->localData[0]->realVars[44] /* powerBlock.HTR.T_from_comp[9] variable */,20.0);
    tmp186 = LessEq(data->localData[0]->realVars[44] /* powerBlock.HTR.T_from_comp[9] variable */,873.15);
    if(!(tmp185 && tmp186))
    {
      tmp188 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[44] /* powerBlock.HTR.T_from_comp[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp187),tmp188);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[9] >= 20.0 and powerBlock.HTR.T_from_comp[9] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp189 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1506
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[10] >= 20.0 and powerBlock.HTR.T_from_comp[10] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[10] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1506(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1506};
  modelica_boolean tmp190;
  modelica_boolean tmp191;
  static const MMC_DEFSTRINGLIT(tmp192,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[10] <= 873.15, has value: ");
  modelica_string tmp193;
  static int tmp194 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp194)
  {
    tmp190 = GreaterEq(data->localData[0]->realVars[45] /* powerBlock.HTR.T_from_comp[10] variable */,20.0);
    tmp191 = LessEq(data->localData[0]->realVars[45] /* powerBlock.HTR.T_from_comp[10] variable */,873.15);
    if(!(tmp190 && tmp191))
    {
      tmp193 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[45] /* powerBlock.HTR.T_from_comp[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp192),tmp193);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[10] >= 20.0 and powerBlock.HTR.T_from_comp[10] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp194 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1507
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[11] >= 20.0 and powerBlock.HTR.T_from_comp[11] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[11] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1507(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1507};
  modelica_boolean tmp195;
  modelica_boolean tmp196;
  static const MMC_DEFSTRINGLIT(tmp197,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[11] <= 873.15, has value: ");
  modelica_string tmp198;
  static int tmp199 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp199)
  {
    tmp195 = GreaterEq(data->localData[0]->realVars[46] /* powerBlock.HTR.T_from_comp[11] variable */,20.0);
    tmp196 = LessEq(data->localData[0]->realVars[46] /* powerBlock.HTR.T_from_comp[11] variable */,873.15);
    if(!(tmp195 && tmp196))
    {
      tmp198 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[46] /* powerBlock.HTR.T_from_comp[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp197),tmp198);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[11] >= 20.0 and powerBlock.HTR.T_from_comp[11] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp199 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1508
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[12] >= 20.0 and powerBlock.HTR.T_from_comp[12] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[12] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1508(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1508};
  modelica_boolean tmp200;
  modelica_boolean tmp201;
  static const MMC_DEFSTRINGLIT(tmp202,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[12] <= 873.15, has value: ");
  modelica_string tmp203;
  static int tmp204 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp204)
  {
    tmp200 = GreaterEq(data->localData[0]->realVars[47] /* powerBlock.HTR.T_from_comp[12] variable */,20.0);
    tmp201 = LessEq(data->localData[0]->realVars[47] /* powerBlock.HTR.T_from_comp[12] variable */,873.15);
    if(!(tmp200 && tmp201))
    {
      tmp203 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[47] /* powerBlock.HTR.T_from_comp[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp202),tmp203);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[12] >= 20.0 and powerBlock.HTR.T_from_comp[12] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp204 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1509
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[13] >= 20.0 and powerBlock.HTR.T_from_comp[13] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[13] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1509(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1509};
  modelica_boolean tmp205;
  modelica_boolean tmp206;
  static const MMC_DEFSTRINGLIT(tmp207,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[13] <= 873.15, has value: ");
  modelica_string tmp208;
  static int tmp209 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp209)
  {
    tmp205 = GreaterEq(data->localData[0]->realVars[48] /* powerBlock.HTR.T_from_comp[13] variable */,20.0);
    tmp206 = LessEq(data->localData[0]->realVars[48] /* powerBlock.HTR.T_from_comp[13] variable */,873.15);
    if(!(tmp205 && tmp206))
    {
      tmp208 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[48] /* powerBlock.HTR.T_from_comp[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp207),tmp208);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[13] >= 20.0 and powerBlock.HTR.T_from_comp[13] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp209 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1510
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[14] >= 20.0 and powerBlock.HTR.T_from_comp[14] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[14] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1510(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1510};
  modelica_boolean tmp210;
  modelica_boolean tmp211;
  static const MMC_DEFSTRINGLIT(tmp212,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[14] <= 873.15, has value: ");
  modelica_string tmp213;
  static int tmp214 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp214)
  {
    tmp210 = GreaterEq(data->localData[0]->realVars[49] /* powerBlock.HTR.T_from_comp[14] variable */,20.0);
    tmp211 = LessEq(data->localData[0]->realVars[49] /* powerBlock.HTR.T_from_comp[14] variable */,873.15);
    if(!(tmp210 && tmp211))
    {
      tmp213 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[49] /* powerBlock.HTR.T_from_comp[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp212),tmp213);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[14] >= 20.0 and powerBlock.HTR.T_from_comp[14] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp214 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1511
type: ALGORITHM

  assert(powerBlock.HTR.T_from_comp[15] >= 20.0 and powerBlock.HTR.T_from_comp[15] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[15] <= 873.15, has value: " + String(powerBlock.HTR.T_from_comp[15], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1511(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1511};
  modelica_boolean tmp215;
  modelica_boolean tmp216;
  static const MMC_DEFSTRINGLIT(tmp217,100,"Variable violating min/max constraint: 20.0 <= powerBlock.HTR.T_from_comp[15] <= 873.15, has value: ");
  modelica_string tmp218;
  static int tmp219 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp219)
  {
    tmp215 = GreaterEq(data->localData[0]->realVars[50] /* powerBlock.HTR.T_from_comp[15] variable */,20.0);
    tmp216 = LessEq(data->localData[0]->realVars[50] /* powerBlock.HTR.T_from_comp[15] variable */,873.15);
    if(!(tmp215 && tmp216))
    {
      tmp218 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[50] /* powerBlock.HTR.T_from_comp[15] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp217),tmp218);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.T_from_comp[15] >= 20.0 and powerBlock.HTR.T_from_comp[15] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp219 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1512
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[1] >= -10000000000.0 and powerBlock.HTR.h_from_comp[1] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[1] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[1], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1512(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1512};
  modelica_boolean tmp220;
  modelica_boolean tmp221;
  static const MMC_DEFSTRINGLIT(tmp222,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[1] <= 10000000000.0, has value: ");
  modelica_string tmp223;
  static int tmp224 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp224)
  {
    tmp220 = GreaterEq(data->localData[0]->realVars[81] /* powerBlock.HTR.h_from_comp[1] variable */,-10000000000.0);
    tmp221 = LessEq(data->localData[0]->realVars[81] /* powerBlock.HTR.h_from_comp[1] variable */,10000000000.0);
    if(!(tmp220 && tmp221))
    {
      tmp223 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[81] /* powerBlock.HTR.h_from_comp[1] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp222),tmp223);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[1] >= -10000000000.0 and powerBlock.HTR.h_from_comp[1] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp224 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1513
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[2] >= -10000000000.0 and powerBlock.HTR.h_from_comp[2] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[2] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1513(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1513};
  modelica_boolean tmp225;
  modelica_boolean tmp226;
  static const MMC_DEFSTRINGLIT(tmp227,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[2] <= 10000000000.0, has value: ");
  modelica_string tmp228;
  static int tmp229 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp229)
  {
    tmp225 = GreaterEq(data->localData[0]->realVars[82] /* powerBlock.HTR.h_from_comp[2] variable */,-10000000000.0);
    tmp226 = LessEq(data->localData[0]->realVars[82] /* powerBlock.HTR.h_from_comp[2] variable */,10000000000.0);
    if(!(tmp225 && tmp226))
    {
      tmp228 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[82] /* powerBlock.HTR.h_from_comp[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp227),tmp228);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[2] >= -10000000000.0 and powerBlock.HTR.h_from_comp[2] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp229 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1514
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[3] >= -10000000000.0 and powerBlock.HTR.h_from_comp[3] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[3] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1514(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1514};
  modelica_boolean tmp230;
  modelica_boolean tmp231;
  static const MMC_DEFSTRINGLIT(tmp232,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[3] <= 10000000000.0, has value: ");
  modelica_string tmp233;
  static int tmp234 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp234)
  {
    tmp230 = GreaterEq(data->localData[0]->realVars[83] /* powerBlock.HTR.h_from_comp[3] variable */,-10000000000.0);
    tmp231 = LessEq(data->localData[0]->realVars[83] /* powerBlock.HTR.h_from_comp[3] variable */,10000000000.0);
    if(!(tmp230 && tmp231))
    {
      tmp233 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[83] /* powerBlock.HTR.h_from_comp[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp232),tmp233);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[3] >= -10000000000.0 and powerBlock.HTR.h_from_comp[3] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp234 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1515
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[4] >= -10000000000.0 and powerBlock.HTR.h_from_comp[4] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[4] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1515(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1515};
  modelica_boolean tmp235;
  modelica_boolean tmp236;
  static const MMC_DEFSTRINGLIT(tmp237,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[4] <= 10000000000.0, has value: ");
  modelica_string tmp238;
  static int tmp239 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp239)
  {
    tmp235 = GreaterEq(data->localData[0]->realVars[84] /* powerBlock.HTR.h_from_comp[4] variable */,-10000000000.0);
    tmp236 = LessEq(data->localData[0]->realVars[84] /* powerBlock.HTR.h_from_comp[4] variable */,10000000000.0);
    if(!(tmp235 && tmp236))
    {
      tmp238 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[84] /* powerBlock.HTR.h_from_comp[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp237),tmp238);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[4] >= -10000000000.0 and powerBlock.HTR.h_from_comp[4] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp239 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1516
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[5] >= -10000000000.0 and powerBlock.HTR.h_from_comp[5] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[5] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1516(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1516};
  modelica_boolean tmp240;
  modelica_boolean tmp241;
  static const MMC_DEFSTRINGLIT(tmp242,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[5] <= 10000000000.0, has value: ");
  modelica_string tmp243;
  static int tmp244 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp244)
  {
    tmp240 = GreaterEq(data->localData[0]->realVars[85] /* powerBlock.HTR.h_from_comp[5] variable */,-10000000000.0);
    tmp241 = LessEq(data->localData[0]->realVars[85] /* powerBlock.HTR.h_from_comp[5] variable */,10000000000.0);
    if(!(tmp240 && tmp241))
    {
      tmp243 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[85] /* powerBlock.HTR.h_from_comp[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp242),tmp243);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[5] >= -10000000000.0 and powerBlock.HTR.h_from_comp[5] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp244 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1517
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[6] >= -10000000000.0 and powerBlock.HTR.h_from_comp[6] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[6] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1517(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1517};
  modelica_boolean tmp245;
  modelica_boolean tmp246;
  static const MMC_DEFSTRINGLIT(tmp247,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[6] <= 10000000000.0, has value: ");
  modelica_string tmp248;
  static int tmp249 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp249)
  {
    tmp245 = GreaterEq(data->localData[0]->realVars[86] /* powerBlock.HTR.h_from_comp[6] variable */,-10000000000.0);
    tmp246 = LessEq(data->localData[0]->realVars[86] /* powerBlock.HTR.h_from_comp[6] variable */,10000000000.0);
    if(!(tmp245 && tmp246))
    {
      tmp248 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[86] /* powerBlock.HTR.h_from_comp[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp247),tmp248);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[6] >= -10000000000.0 and powerBlock.HTR.h_from_comp[6] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp249 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1518
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[7] >= -10000000000.0 and powerBlock.HTR.h_from_comp[7] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[7] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1518(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1518};
  modelica_boolean tmp250;
  modelica_boolean tmp251;
  static const MMC_DEFSTRINGLIT(tmp252,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[7] <= 10000000000.0, has value: ");
  modelica_string tmp253;
  static int tmp254 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp254)
  {
    tmp250 = GreaterEq(data->localData[0]->realVars[87] /* powerBlock.HTR.h_from_comp[7] variable */,-10000000000.0);
    tmp251 = LessEq(data->localData[0]->realVars[87] /* powerBlock.HTR.h_from_comp[7] variable */,10000000000.0);
    if(!(tmp250 && tmp251))
    {
      tmp253 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[87] /* powerBlock.HTR.h_from_comp[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp252),tmp253);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[7] >= -10000000000.0 and powerBlock.HTR.h_from_comp[7] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp254 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1519
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[8] >= -10000000000.0 and powerBlock.HTR.h_from_comp[8] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[8] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1519(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1519};
  modelica_boolean tmp255;
  modelica_boolean tmp256;
  static const MMC_DEFSTRINGLIT(tmp257,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[8] <= 10000000000.0, has value: ");
  modelica_string tmp258;
  static int tmp259 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp259)
  {
    tmp255 = GreaterEq(data->localData[0]->realVars[88] /* powerBlock.HTR.h_from_comp[8] variable */,-10000000000.0);
    tmp256 = LessEq(data->localData[0]->realVars[88] /* powerBlock.HTR.h_from_comp[8] variable */,10000000000.0);
    if(!(tmp255 && tmp256))
    {
      tmp258 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[88] /* powerBlock.HTR.h_from_comp[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp257),tmp258);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[8] >= -10000000000.0 and powerBlock.HTR.h_from_comp[8] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp259 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1520
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[9] >= -10000000000.0 and powerBlock.HTR.h_from_comp[9] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[9] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1520(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1520};
  modelica_boolean tmp260;
  modelica_boolean tmp261;
  static const MMC_DEFSTRINGLIT(tmp262,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[9] <= 10000000000.0, has value: ");
  modelica_string tmp263;
  static int tmp264 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp264)
  {
    tmp260 = GreaterEq(data->localData[0]->realVars[89] /* powerBlock.HTR.h_from_comp[9] variable */,-10000000000.0);
    tmp261 = LessEq(data->localData[0]->realVars[89] /* powerBlock.HTR.h_from_comp[9] variable */,10000000000.0);
    if(!(tmp260 && tmp261))
    {
      tmp263 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[89] /* powerBlock.HTR.h_from_comp[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp262),tmp263);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[9] >= -10000000000.0 and powerBlock.HTR.h_from_comp[9] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp264 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1521
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[10] >= -10000000000.0 and powerBlock.HTR.h_from_comp[10] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[10] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1521(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1521};
  modelica_boolean tmp265;
  modelica_boolean tmp266;
  static const MMC_DEFSTRINGLIT(tmp267,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[10] <= 10000000000.0, has value: ");
  modelica_string tmp268;
  static int tmp269 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp269)
  {
    tmp265 = GreaterEq(data->localData[0]->realVars[90] /* powerBlock.HTR.h_from_comp[10] variable */,-10000000000.0);
    tmp266 = LessEq(data->localData[0]->realVars[90] /* powerBlock.HTR.h_from_comp[10] variable */,10000000000.0);
    if(!(tmp265 && tmp266))
    {
      tmp268 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[90] /* powerBlock.HTR.h_from_comp[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp267),tmp268);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[10] >= -10000000000.0 and powerBlock.HTR.h_from_comp[10] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp269 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1522
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[11] >= -10000000000.0 and powerBlock.HTR.h_from_comp[11] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[11] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1522(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1522};
  modelica_boolean tmp270;
  modelica_boolean tmp271;
  static const MMC_DEFSTRINGLIT(tmp272,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[11] <= 10000000000.0, has value: ");
  modelica_string tmp273;
  static int tmp274 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp274)
  {
    tmp270 = GreaterEq(data->localData[0]->realVars[91] /* powerBlock.HTR.h_from_comp[11] variable */,-10000000000.0);
    tmp271 = LessEq(data->localData[0]->realVars[91] /* powerBlock.HTR.h_from_comp[11] variable */,10000000000.0);
    if(!(tmp270 && tmp271))
    {
      tmp273 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[91] /* powerBlock.HTR.h_from_comp[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp272),tmp273);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[11] >= -10000000000.0 and powerBlock.HTR.h_from_comp[11] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp274 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1523
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[12] >= -10000000000.0 and powerBlock.HTR.h_from_comp[12] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[12] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1523(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1523};
  modelica_boolean tmp275;
  modelica_boolean tmp276;
  static const MMC_DEFSTRINGLIT(tmp277,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[12] <= 10000000000.0, has value: ");
  modelica_string tmp278;
  static int tmp279 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp279)
  {
    tmp275 = GreaterEq(data->localData[0]->realVars[92] /* powerBlock.HTR.h_from_comp[12] variable */,-10000000000.0);
    tmp276 = LessEq(data->localData[0]->realVars[92] /* powerBlock.HTR.h_from_comp[12] variable */,10000000000.0);
    if(!(tmp275 && tmp276))
    {
      tmp278 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[92] /* powerBlock.HTR.h_from_comp[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp277),tmp278);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[12] >= -10000000000.0 and powerBlock.HTR.h_from_comp[12] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp279 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1524
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[13] >= -10000000000.0 and powerBlock.HTR.h_from_comp[13] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[13] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1524(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1524};
  modelica_boolean tmp280;
  modelica_boolean tmp281;
  static const MMC_DEFSTRINGLIT(tmp282,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[13] <= 10000000000.0, has value: ");
  modelica_string tmp283;
  static int tmp284 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp284)
  {
    tmp280 = GreaterEq(data->localData[0]->realVars[93] /* powerBlock.HTR.h_from_comp[13] variable */,-10000000000.0);
    tmp281 = LessEq(data->localData[0]->realVars[93] /* powerBlock.HTR.h_from_comp[13] variable */,10000000000.0);
    if(!(tmp280 && tmp281))
    {
      tmp283 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[93] /* powerBlock.HTR.h_from_comp[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp282),tmp283);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[13] >= -10000000000.0 and powerBlock.HTR.h_from_comp[13] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp284 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1525
type: ALGORITHM

  assert(powerBlock.HTR.h_from_comp[14] >= -10000000000.0 and powerBlock.HTR.h_from_comp[14] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[14] <= 10000000000.0, has value: " + String(powerBlock.HTR.h_from_comp[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1525(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1525};
  modelica_boolean tmp285;
  modelica_boolean tmp286;
  static const MMC_DEFSTRINGLIT(tmp287,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.HTR.h_from_comp[14] <= 10000000000.0, has value: ");
  modelica_string tmp288;
  static int tmp289 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp289)
  {
    tmp285 = GreaterEq(data->localData[0]->realVars[94] /* powerBlock.HTR.h_from_comp[14] variable */,-10000000000.0);
    tmp286 = LessEq(data->localData[0]->realVars[94] /* powerBlock.HTR.h_from_comp[14] variable */,10000000000.0);
    if(!(tmp285 && tmp286))
    {
      tmp288 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[94] /* powerBlock.HTR.h_from_comp[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp287),tmp288);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.h_from_comp[14] >= -10000000000.0 and powerBlock.HTR.h_from_comp[14] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp289 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1526
type: ALGORITHM

  assert(powerBlock.HTR.state_from_comp[15].p >= 0.0 and powerBlock.HTR.state_from_comp[15].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.HTR.state_from_comp[15].p <= 100000000.0, has value: " + String(powerBlock.HTR.state_from_comp[15].p, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1526(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1526};
  modelica_boolean tmp290;
  modelica_boolean tmp291;
  static const MMC_DEFSTRINGLIT(tmp292,110,"Variable violating min/max constraint: 0.0 <= powerBlock.HTR.state_from_comp[15].p <= 100000000.0, has value: ");
  modelica_string tmp293;
  static int tmp294 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp294)
  {
    tmp290 = GreaterEq(data->localData[0]->realVars[109] /* powerBlock.HTR.state_from_comp[15].p variable */,0.0);
    tmp291 = LessEq(data->localData[0]->realVars[109] /* powerBlock.HTR.state_from_comp[15].p variable */,100000000.0);
    if(!(tmp290 && tmp291))
    {
      tmp293 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[109] /* powerBlock.HTR.state_from_comp[15].p variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp292),tmp293);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.HTR.state_from_comp[15].p >= 0.0 and powerBlock.HTR.state_from_comp[15].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp294 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1527
type: ALGORITHM

  assert(powerBlock.mainCompressor.state_a.h >= -10000000000.0 and powerBlock.mainCompressor.state_a.h <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.mainCompressor.state_a.h <= 10000000000.0, has value: " + String(powerBlock.mainCompressor.state_a.h, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1527(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1527};
  modelica_boolean tmp295;
  modelica_boolean tmp296;
  static const MMC_DEFSTRINGLIT(tmp297,122,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.mainCompressor.state_a.h <= 10000000000.0, has value: ");
  modelica_string tmp298;
  static int tmp299 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp299)
  {
    tmp295 = GreaterEq(data->localData[0]->realVars[260] /* powerBlock.mainCompressor.state_a.h variable */,-10000000000.0);
    tmp296 = LessEq(data->localData[0]->realVars[260] /* powerBlock.mainCompressor.state_a.h variable */,10000000000.0);
    if(!(tmp295 && tmp296))
    {
      tmp298 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[260] /* powerBlock.mainCompressor.state_a.h variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp297),tmp298);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",90,7,90,45,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.state_a.h >= -10000000000.0 and powerBlock.mainCompressor.state_a.h <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp299 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1528
type: ALGORITHM

  assert(powerBlock.mainCompressor.state_isen.h >= -10000000000.0 and powerBlock.mainCompressor.state_isen.h <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.mainCompressor.state_isen.h <= 10000000000.0, has value: " + String(powerBlock.mainCompressor.state_isen.h, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1528(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1528};
  modelica_boolean tmp300;
  modelica_boolean tmp301;
  static const MMC_DEFSTRINGLIT(tmp302,125,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.mainCompressor.state_isen.h <= 10000000000.0, has value: ");
  modelica_string tmp303;
  static int tmp304 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp304)
  {
    tmp300 = GreaterEq(data->localData[0]->realVars[261] /* powerBlock.mainCompressor.state_isen.h variable */,-10000000000.0);
    tmp301 = LessEq(data->localData[0]->realVars[261] /* powerBlock.mainCompressor.state_isen.h variable */,10000000000.0);
    if(!(tmp300 && tmp301))
    {
      tmp303 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[261] /* powerBlock.mainCompressor.state_isen.h variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp302),tmp303);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",90,7,90,45,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.state_isen.h >= -10000000000.0 and powerBlock.mainCompressor.state_isen.h <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp304 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1529
type: ALGORITHM

  assert(powerBlock.mainCompressor.d_entrance >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.d_entrance, has value: " + String(powerBlock.mainCompressor.d_entrance, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1529(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1529};
  modelica_boolean tmp305;
  static const MMC_DEFSTRINGLIT(tmp306,91,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.d_entrance, has value: ");
  modelica_string tmp307;
  static int tmp308 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp308)
  {
    tmp305 = GreaterEq(data->localData[0]->realVars[254] /* powerBlock.mainCompressor.d_entrance variable */,0.0);
    if(!tmp305)
    {
      tmp307 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[254] /* powerBlock.mainCompressor.d_entrance variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp306),tmp307);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",619,4,619,61,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.d_entrance >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp308 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1530
type: ALGORITHM

  assert(powerBlock.mainCompressor.eta_comp >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.eta_comp, has value: " + String(powerBlock.mainCompressor.eta_comp, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1530(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1530};
  modelica_boolean tmp309;
  static const MMC_DEFSTRINGLIT(tmp310,89,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.eta_comp, has value: ");
  modelica_string tmp311;
  static int tmp312 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp312)
  {
    tmp309 = GreaterEq(data->localData[0]->realVars[255] /* powerBlock.mainCompressor.eta_comp variable */,0.0);
    if(!tmp309)
    {
      tmp311 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[255] /* powerBlock.mainCompressor.eta_comp variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp310),tmp311);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",620,4,620,88,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.eta_comp >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp312 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1531
type: ALGORITHM

  assert(powerBlock.mainCompressor.phi >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.phi, has value: " + String(powerBlock.mainCompressor.phi, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1531(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1531};
  modelica_boolean tmp313;
  static const MMC_DEFSTRINGLIT(tmp314,84,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.phi, has value: ");
  modelica_string tmp315;
  static int tmp316 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp316)
  {
    tmp313 = GreaterEq(data->localData[0]->realVars[256] /* powerBlock.mainCompressor.phi variable */,0.0);
    if(!tmp313)
    {
      tmp315 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[256] /* powerBlock.mainCompressor.phi variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp314),tmp315);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",621,4,621,52,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.phi >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp316 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1532
type: ALGORITHM

  assert(powerBlock.mainCompressor.psi >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.psi, has value: " + String(powerBlock.mainCompressor.psi, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1532(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1532};
  modelica_boolean tmp317;
  static const MMC_DEFSTRINGLIT(tmp318,84,"Variable violating min constraint: 0.0 <= powerBlock.mainCompressor.psi, has value: ");
  modelica_string tmp319;
  static int tmp320 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp320)
  {
    tmp317 = GreaterEq(data->localData[0]->realVars[258] /* powerBlock.mainCompressor.psi variable */,0.0);
    if(!tmp317)
    {
      tmp319 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[258] /* powerBlock.mainCompressor.psi variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp318),tmp319);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",622,4,622,42,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.mainCompressor.psi >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp320 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1533
type: ALGORITHM

  assert(powerBlock.cooler.port_b.m_flow >= -100000.0 and powerBlock.cooler.port_b.m_flow <= 100000.0, "Variable violating min/max constraint: -100000.0 <= powerBlock.cooler.port_b.m_flow <= 100000.0, has value: " + String(powerBlock.cooler.port_b.m_flow, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1533(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1533};
  modelica_boolean tmp321;
  modelica_boolean tmp322;
  static const MMC_DEFSTRINGLIT(tmp323,108,"Variable violating min/max constraint: -100000.0 <= powerBlock.cooler.port_b.m_flow <= 100000.0, has value: ");
  modelica_string tmp324;
  static int tmp325 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp325)
  {
    tmp321 = GreaterEq(data->localData[0]->realVars[197] /* powerBlock.cooler.port_b.m_flow variable */,-100000.0);
    tmp322 = LessEq(data->localData[0]->realVars[197] /* powerBlock.cooler.port_b.m_flow variable */,100000.0);
    if(!(tmp321 && tmp322))
    {
      tmp324 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[197] /* powerBlock.cooler.port_b.m_flow variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp323),tmp324);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",13,5,14,68,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.cooler.port_b.m_flow >= -100000.0 and powerBlock.cooler.port_b.m_flow <= 100000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp325 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1534
type: ALGORITHM

  assert(powerBlock.cooler.T_out >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.cooler.T_out, has value: " + String(powerBlock.cooler.T_out, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1534(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1534};
  modelica_boolean tmp326;
  static const MMC_DEFSTRINGLIT(tmp327,78,"Variable violating min constraint: 0.0 <= powerBlock.cooler.T_out, has value: ");
  modelica_string tmp328;
  static int tmp329 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp329)
  {
    tmp326 = GreaterEq(data->localData[0]->realVars[194] /* powerBlock.cooler.T_out variable */,0.0);
    if(!tmp326)
    {
      tmp328 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[194] /* powerBlock.cooler.T_out variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp327),tmp328);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",412,4,412,24,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.cooler.T_out >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp329 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1535
type: ALGORITHM

  assert(powerBlock.turbine.eta_turb >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.turbine.eta_turb, has value: " + String(powerBlock.turbine.eta_turb, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1535(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1535};
  modelica_boolean tmp330;
  static const MMC_DEFSTRINGLIT(tmp331,82,"Variable violating min constraint: 0.0 <= powerBlock.turbine.eta_turb, has value: ");
  modelica_string tmp332;
  static int tmp333 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp333)
  {
    tmp330 = GreaterEq(data->localData[0]->realVars[277] /* powerBlock.turbine.eta_turb variable */,0.0);
    if(!tmp330)
    {
      tmp332 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[277] /* powerBlock.turbine.eta_turb variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp331),tmp332);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",146,4,146,68,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.turbine.eta_turb >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp333 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1536
type: ALGORITHM

  assert(powerBlock.turbine.d_outlet >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.turbine.d_outlet, has value: " + String(powerBlock.turbine.d_outlet, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1536(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1536};
  modelica_boolean tmp334;
  static const MMC_DEFSTRINGLIT(tmp335,82,"Variable violating min constraint: 0.0 <= powerBlock.turbine.d_outlet, has value: ");
  modelica_string tmp336;
  static int tmp337 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp337)
  {
    tmp334 = GreaterEq(data->localData[0]->realVars[276] /* powerBlock.turbine.d_outlet variable */,0.0);
    if(!tmp334)
    {
      tmp336 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[276] /* powerBlock.turbine.d_outlet variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp335),tmp336);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",147,4,147,37,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.turbine.d_outlet >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp337 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1537
type: ALGORITHM

  assert(powerBlock.turbine.state_isen.h >= -10000000000.0 and powerBlock.turbine.state_isen.h <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.turbine.state_isen.h <= 10000000000.0, has value: " + String(powerBlock.turbine.state_isen.h, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1537(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1537};
  modelica_boolean tmp338;
  modelica_boolean tmp339;
  static const MMC_DEFSTRINGLIT(tmp340,118,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.turbine.state_isen.h <= 10000000000.0, has value: ");
  modelica_string tmp341;
  static int tmp342 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp342)
  {
    tmp338 = GreaterEq(data->localData[0]->realVars[279] /* powerBlock.turbine.state_isen.h variable */,-10000000000.0);
    tmp339 = LessEq(data->localData[0]->realVars[279] /* powerBlock.turbine.state_isen.h variable */,10000000000.0);
    if(!(tmp338 && tmp339))
    {
      tmp341 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[279] /* powerBlock.turbine.state_isen.h variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp340),tmp341);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",90,7,90,45,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.turbine.state_isen.h >= -10000000000.0 and powerBlock.turbine.state_isen.h <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp342 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1538
type: ALGORITHM

  assert(powerBlock.exchanger.CO2_port_b.m_flow >= -100000.0 and powerBlock.exchanger.CO2_port_b.m_flow <= 100000.0, "Variable violating min/max constraint: -100000.0 <= powerBlock.exchanger.CO2_port_b.m_flow <= 100000.0, has value: " + String(powerBlock.exchanger.CO2_port_b.m_flow, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1538(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1538};
  modelica_boolean tmp343;
  modelica_boolean tmp344;
  static const MMC_DEFSTRINGLIT(tmp345,115,"Variable violating min/max constraint: -100000.0 <= powerBlock.exchanger.CO2_port_b.m_flow <= 100000.0, has value: ");
  modelica_string tmp346;
  static int tmp347 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp347)
  {
    tmp343 = GreaterEq(data->localData[0]->realVars[201] /* powerBlock.exchanger.CO2_port_b.m_flow variable */,-100000.0);
    tmp344 = LessEq(data->localData[0]->realVars[201] /* powerBlock.exchanger.CO2_port_b.m_flow variable */,100000.0);
    if(!(tmp343 && tmp344))
    {
      tmp346 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[201] /* powerBlock.exchanger.CO2_port_b.m_flow variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp345),tmp346);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",13,5,14,68,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.CO2_port_b.m_flow >= -100000.0 and powerBlock.exchanger.CO2_port_b.m_flow <= 100000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp347 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1539
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[1] >= -10000000000.0 and powerBlock.exchanger.h_CO2[1] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[1] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[1], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1539(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1539};
  modelica_boolean tmp348;
  modelica_boolean tmp349;
  static const MMC_DEFSTRINGLIT(tmp350,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[1] <= 10000000000.0, has value: ");
  modelica_string tmp351;
  static int tmp352 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp352)
  {
    tmp348 = GreaterEq(data->localData[0]->realVars[223] /* powerBlock.exchanger.h_CO2[1] variable */,-10000000000.0);
    tmp349 = LessEq(data->localData[0]->realVars[223] /* powerBlock.exchanger.h_CO2[1] variable */,10000000000.0);
    if(!(tmp348 && tmp349))
    {
      tmp351 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[223] /* powerBlock.exchanger.h_CO2[1] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp350),tmp351);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[1] >= -10000000000.0 and powerBlock.exchanger.h_CO2[1] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp352 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1540
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[2] >= -10000000000.0 and powerBlock.exchanger.h_CO2[2] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[2] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1540(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1540};
  modelica_boolean tmp353;
  modelica_boolean tmp354;
  static const MMC_DEFSTRINGLIT(tmp355,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[2] <= 10000000000.0, has value: ");
  modelica_string tmp356;
  static int tmp357 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp357)
  {
    tmp353 = GreaterEq(data->localData[0]->realVars[224] /* powerBlock.exchanger.h_CO2[2] variable */,-10000000000.0);
    tmp354 = LessEq(data->localData[0]->realVars[224] /* powerBlock.exchanger.h_CO2[2] variable */,10000000000.0);
    if(!(tmp353 && tmp354))
    {
      tmp356 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[224] /* powerBlock.exchanger.h_CO2[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp355),tmp356);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[2] >= -10000000000.0 and powerBlock.exchanger.h_CO2[2] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp357 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1541
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[3] >= -10000000000.0 and powerBlock.exchanger.h_CO2[3] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[3] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1541(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1541};
  modelica_boolean tmp358;
  modelica_boolean tmp359;
  static const MMC_DEFSTRINGLIT(tmp360,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[3] <= 10000000000.0, has value: ");
  modelica_string tmp361;
  static int tmp362 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp362)
  {
    tmp358 = GreaterEq(data->localData[0]->realVars[225] /* powerBlock.exchanger.h_CO2[3] variable */,-10000000000.0);
    tmp359 = LessEq(data->localData[0]->realVars[225] /* powerBlock.exchanger.h_CO2[3] variable */,10000000000.0);
    if(!(tmp358 && tmp359))
    {
      tmp361 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[225] /* powerBlock.exchanger.h_CO2[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp360),tmp361);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[3] >= -10000000000.0 and powerBlock.exchanger.h_CO2[3] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp362 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1542
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[4] >= -10000000000.0 and powerBlock.exchanger.h_CO2[4] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[4] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1542(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1542};
  modelica_boolean tmp363;
  modelica_boolean tmp364;
  static const MMC_DEFSTRINGLIT(tmp365,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[4] <= 10000000000.0, has value: ");
  modelica_string tmp366;
  static int tmp367 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp367)
  {
    tmp363 = GreaterEq(data->localData[0]->realVars[226] /* powerBlock.exchanger.h_CO2[4] variable */,-10000000000.0);
    tmp364 = LessEq(data->localData[0]->realVars[226] /* powerBlock.exchanger.h_CO2[4] variable */,10000000000.0);
    if(!(tmp363 && tmp364))
    {
      tmp366 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[226] /* powerBlock.exchanger.h_CO2[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp365),tmp366);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[4] >= -10000000000.0 and powerBlock.exchanger.h_CO2[4] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp367 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1543
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[5] >= -10000000000.0 and powerBlock.exchanger.h_CO2[5] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[5] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1543(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1543};
  modelica_boolean tmp368;
  modelica_boolean tmp369;
  static const MMC_DEFSTRINGLIT(tmp370,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[5] <= 10000000000.0, has value: ");
  modelica_string tmp371;
  static int tmp372 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp372)
  {
    tmp368 = GreaterEq(data->localData[0]->realVars[227] /* powerBlock.exchanger.h_CO2[5] variable */,-10000000000.0);
    tmp369 = LessEq(data->localData[0]->realVars[227] /* powerBlock.exchanger.h_CO2[5] variable */,10000000000.0);
    if(!(tmp368 && tmp369))
    {
      tmp371 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[227] /* powerBlock.exchanger.h_CO2[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp370),tmp371);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[5] >= -10000000000.0 and powerBlock.exchanger.h_CO2[5] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp372 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1544
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[6] >= -10000000000.0 and powerBlock.exchanger.h_CO2[6] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[6] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1544(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1544};
  modelica_boolean tmp373;
  modelica_boolean tmp374;
  static const MMC_DEFSTRINGLIT(tmp375,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[6] <= 10000000000.0, has value: ");
  modelica_string tmp376;
  static int tmp377 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp377)
  {
    tmp373 = GreaterEq(data->localData[0]->realVars[228] /* powerBlock.exchanger.h_CO2[6] variable */,-10000000000.0);
    tmp374 = LessEq(data->localData[0]->realVars[228] /* powerBlock.exchanger.h_CO2[6] variable */,10000000000.0);
    if(!(tmp373 && tmp374))
    {
      tmp376 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[228] /* powerBlock.exchanger.h_CO2[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp375),tmp376);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[6] >= -10000000000.0 and powerBlock.exchanger.h_CO2[6] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp377 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1545
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[7] >= -10000000000.0 and powerBlock.exchanger.h_CO2[7] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[7] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1545(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1545};
  modelica_boolean tmp378;
  modelica_boolean tmp379;
  static const MMC_DEFSTRINGLIT(tmp380,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[7] <= 10000000000.0, has value: ");
  modelica_string tmp381;
  static int tmp382 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp382)
  {
    tmp378 = GreaterEq(data->localData[0]->realVars[229] /* powerBlock.exchanger.h_CO2[7] variable */,-10000000000.0);
    tmp379 = LessEq(data->localData[0]->realVars[229] /* powerBlock.exchanger.h_CO2[7] variable */,10000000000.0);
    if(!(tmp378 && tmp379))
    {
      tmp381 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[229] /* powerBlock.exchanger.h_CO2[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp380),tmp381);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[7] >= -10000000000.0 and powerBlock.exchanger.h_CO2[7] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp382 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1546
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[8] >= -10000000000.0 and powerBlock.exchanger.h_CO2[8] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[8] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1546(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1546};
  modelica_boolean tmp383;
  modelica_boolean tmp384;
  static const MMC_DEFSTRINGLIT(tmp385,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[8] <= 10000000000.0, has value: ");
  modelica_string tmp386;
  static int tmp387 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp387)
  {
    tmp383 = GreaterEq(data->localData[0]->realVars[230] /* powerBlock.exchanger.h_CO2[8] variable */,-10000000000.0);
    tmp384 = LessEq(data->localData[0]->realVars[230] /* powerBlock.exchanger.h_CO2[8] variable */,10000000000.0);
    if(!(tmp383 && tmp384))
    {
      tmp386 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[230] /* powerBlock.exchanger.h_CO2[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp385),tmp386);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[8] >= -10000000000.0 and powerBlock.exchanger.h_CO2[8] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp387 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1547
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[9] >= -10000000000.0 and powerBlock.exchanger.h_CO2[9] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[9] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1547(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1547};
  modelica_boolean tmp388;
  modelica_boolean tmp389;
  static const MMC_DEFSTRINGLIT(tmp390,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[9] <= 10000000000.0, has value: ");
  modelica_string tmp391;
  static int tmp392 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp392)
  {
    tmp388 = GreaterEq(data->localData[0]->realVars[231] /* powerBlock.exchanger.h_CO2[9] variable */,-10000000000.0);
    tmp389 = LessEq(data->localData[0]->realVars[231] /* powerBlock.exchanger.h_CO2[9] variable */,10000000000.0);
    if(!(tmp388 && tmp389))
    {
      tmp391 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[231] /* powerBlock.exchanger.h_CO2[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp390),tmp391);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[9] >= -10000000000.0 and powerBlock.exchanger.h_CO2[9] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp392 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1548
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[10] >= -10000000000.0 and powerBlock.exchanger.h_CO2[10] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[10] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1548(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1548};
  modelica_boolean tmp393;
  modelica_boolean tmp394;
  static const MMC_DEFSTRINGLIT(tmp395,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[10] <= 10000000000.0, has value: ");
  modelica_string tmp396;
  static int tmp397 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp397)
  {
    tmp393 = GreaterEq(data->localData[0]->realVars[232] /* powerBlock.exchanger.h_CO2[10] variable */,-10000000000.0);
    tmp394 = LessEq(data->localData[0]->realVars[232] /* powerBlock.exchanger.h_CO2[10] variable */,10000000000.0);
    if(!(tmp393 && tmp394))
    {
      tmp396 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[232] /* powerBlock.exchanger.h_CO2[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp395),tmp396);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[10] >= -10000000000.0 and powerBlock.exchanger.h_CO2[10] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp397 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1549
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[11] >= -10000000000.0 and powerBlock.exchanger.h_CO2[11] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[11] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1549(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1549};
  modelica_boolean tmp398;
  modelica_boolean tmp399;
  static const MMC_DEFSTRINGLIT(tmp400,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[11] <= 10000000000.0, has value: ");
  modelica_string tmp401;
  static int tmp402 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp402)
  {
    tmp398 = GreaterEq(data->localData[0]->realVars[233] /* powerBlock.exchanger.h_CO2[11] variable */,-10000000000.0);
    tmp399 = LessEq(data->localData[0]->realVars[233] /* powerBlock.exchanger.h_CO2[11] variable */,10000000000.0);
    if(!(tmp398 && tmp399))
    {
      tmp401 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[233] /* powerBlock.exchanger.h_CO2[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp400),tmp401);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[11] >= -10000000000.0 and powerBlock.exchanger.h_CO2[11] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp402 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1550
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[12] >= -10000000000.0 and powerBlock.exchanger.h_CO2[12] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[12] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1550(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1550};
  modelica_boolean tmp403;
  modelica_boolean tmp404;
  static const MMC_DEFSTRINGLIT(tmp405,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[12] <= 10000000000.0, has value: ");
  modelica_string tmp406;
  static int tmp407 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp407)
  {
    tmp403 = GreaterEq(data->localData[0]->realVars[234] /* powerBlock.exchanger.h_CO2[12] variable */,-10000000000.0);
    tmp404 = LessEq(data->localData[0]->realVars[234] /* powerBlock.exchanger.h_CO2[12] variable */,10000000000.0);
    if(!(tmp403 && tmp404))
    {
      tmp406 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[234] /* powerBlock.exchanger.h_CO2[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp405),tmp406);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[12] >= -10000000000.0 and powerBlock.exchanger.h_CO2[12] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp407 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1551
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[13] >= -10000000000.0 and powerBlock.exchanger.h_CO2[13] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[13] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1551(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1551};
  modelica_boolean tmp408;
  modelica_boolean tmp409;
  static const MMC_DEFSTRINGLIT(tmp410,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[13] <= 10000000000.0, has value: ");
  modelica_string tmp411;
  static int tmp412 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp412)
  {
    tmp408 = GreaterEq(data->localData[0]->realVars[235] /* powerBlock.exchanger.h_CO2[13] variable */,-10000000000.0);
    tmp409 = LessEq(data->localData[0]->realVars[235] /* powerBlock.exchanger.h_CO2[13] variable */,10000000000.0);
    if(!(tmp408 && tmp409))
    {
      tmp411 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[235] /* powerBlock.exchanger.h_CO2[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp410),tmp411);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[13] >= -10000000000.0 and powerBlock.exchanger.h_CO2[13] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp412 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1552
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[14] >= -10000000000.0 and powerBlock.exchanger.h_CO2[14] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[14] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1552(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1552};
  modelica_boolean tmp413;
  modelica_boolean tmp414;
  static const MMC_DEFSTRINGLIT(tmp415,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[14] <= 10000000000.0, has value: ");
  modelica_string tmp416;
  static int tmp417 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp417)
  {
    tmp413 = GreaterEq(data->localData[0]->realVars[236] /* powerBlock.exchanger.h_CO2[14] variable */,-10000000000.0);
    tmp414 = LessEq(data->localData[0]->realVars[236] /* powerBlock.exchanger.h_CO2[14] variable */,10000000000.0);
    if(!(tmp413 && tmp414))
    {
      tmp416 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[236] /* powerBlock.exchanger.h_CO2[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp415),tmp416);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[14] >= -10000000000.0 and powerBlock.exchanger.h_CO2[14] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp417 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1553
type: ALGORITHM

  assert(powerBlock.exchanger.h_CO2[15] >= -10000000000.0 and powerBlock.exchanger.h_CO2[15] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[15] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_CO2[15], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1553(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1553};
  modelica_boolean tmp418;
  modelica_boolean tmp419;
  static const MMC_DEFSTRINGLIT(tmp420,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_CO2[15] <= 10000000000.0, has value: ");
  modelica_string tmp421;
  static int tmp422 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp422)
  {
    tmp418 = GreaterEq(data->localData[0]->realVars[237] /* powerBlock.exchanger.h_CO2[15] variable */,-10000000000.0);
    tmp419 = LessEq(data->localData[0]->realVars[237] /* powerBlock.exchanger.h_CO2[15] variable */,10000000000.0);
    if(!(tmp418 && tmp419))
    {
      tmp421 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[237] /* powerBlock.exchanger.h_CO2[15] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp420),tmp421);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2311,4,2311,103,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_CO2[15] >= -10000000000.0 and powerBlock.exchanger.h_CO2[15] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp422 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1554
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[1] >= -10000000000.0 and powerBlock.exchanger.h_HTF[1] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[1] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[1], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1554(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1554};
  modelica_boolean tmp423;
  modelica_boolean tmp424;
  static const MMC_DEFSTRINGLIT(tmp425,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[1] <= 10000000000.0, has value: ");
  modelica_string tmp426;
  static int tmp427 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp427)
  {
    tmp423 = GreaterEq(data->localData[0]->realVars[238] /* powerBlock.exchanger.h_HTF[1] variable */,-10000000000.0);
    tmp424 = LessEq(data->localData[0]->realVars[238] /* powerBlock.exchanger.h_HTF[1] variable */,10000000000.0);
    if(!(tmp423 && tmp424))
    {
      tmp426 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[238] /* powerBlock.exchanger.h_HTF[1] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp425),tmp426);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[1] >= -10000000000.0 and powerBlock.exchanger.h_HTF[1] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp427 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1555
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[2] >= -10000000000.0 and powerBlock.exchanger.h_HTF[2] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[2] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1555(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1555};
  modelica_boolean tmp428;
  modelica_boolean tmp429;
  static const MMC_DEFSTRINGLIT(tmp430,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[2] <= 10000000000.0, has value: ");
  modelica_string tmp431;
  static int tmp432 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp432)
  {
    tmp428 = GreaterEq(data->localData[0]->realVars[239] /* powerBlock.exchanger.h_HTF[2] variable */,-10000000000.0);
    tmp429 = LessEq(data->localData[0]->realVars[239] /* powerBlock.exchanger.h_HTF[2] variable */,10000000000.0);
    if(!(tmp428 && tmp429))
    {
      tmp431 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[239] /* powerBlock.exchanger.h_HTF[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp430),tmp431);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[2] >= -10000000000.0 and powerBlock.exchanger.h_HTF[2] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp432 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1556
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[3] >= -10000000000.0 and powerBlock.exchanger.h_HTF[3] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[3] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1556(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1556};
  modelica_boolean tmp433;
  modelica_boolean tmp434;
  static const MMC_DEFSTRINGLIT(tmp435,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[3] <= 10000000000.0, has value: ");
  modelica_string tmp436;
  static int tmp437 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp437)
  {
    tmp433 = GreaterEq(data->localData[0]->realVars[240] /* powerBlock.exchanger.h_HTF[3] variable */,-10000000000.0);
    tmp434 = LessEq(data->localData[0]->realVars[240] /* powerBlock.exchanger.h_HTF[3] variable */,10000000000.0);
    if(!(tmp433 && tmp434))
    {
      tmp436 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[240] /* powerBlock.exchanger.h_HTF[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp435),tmp436);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[3] >= -10000000000.0 and powerBlock.exchanger.h_HTF[3] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp437 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1557
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[4] >= -10000000000.0 and powerBlock.exchanger.h_HTF[4] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[4] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1557(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1557};
  modelica_boolean tmp438;
  modelica_boolean tmp439;
  static const MMC_DEFSTRINGLIT(tmp440,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[4] <= 10000000000.0, has value: ");
  modelica_string tmp441;
  static int tmp442 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp442)
  {
    tmp438 = GreaterEq(data->localData[0]->realVars[241] /* powerBlock.exchanger.h_HTF[4] variable */,-10000000000.0);
    tmp439 = LessEq(data->localData[0]->realVars[241] /* powerBlock.exchanger.h_HTF[4] variable */,10000000000.0);
    if(!(tmp438 && tmp439))
    {
      tmp441 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[241] /* powerBlock.exchanger.h_HTF[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp440),tmp441);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[4] >= -10000000000.0 and powerBlock.exchanger.h_HTF[4] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp442 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1558
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[5] >= -10000000000.0 and powerBlock.exchanger.h_HTF[5] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[5] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1558(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1558};
  modelica_boolean tmp443;
  modelica_boolean tmp444;
  static const MMC_DEFSTRINGLIT(tmp445,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[5] <= 10000000000.0, has value: ");
  modelica_string tmp446;
  static int tmp447 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp447)
  {
    tmp443 = GreaterEq(data->localData[0]->realVars[242] /* powerBlock.exchanger.h_HTF[5] variable */,-10000000000.0);
    tmp444 = LessEq(data->localData[0]->realVars[242] /* powerBlock.exchanger.h_HTF[5] variable */,10000000000.0);
    if(!(tmp443 && tmp444))
    {
      tmp446 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[242] /* powerBlock.exchanger.h_HTF[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp445),tmp446);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[5] >= -10000000000.0 and powerBlock.exchanger.h_HTF[5] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp447 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1559
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[6] >= -10000000000.0 and powerBlock.exchanger.h_HTF[6] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[6] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1559(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1559};
  modelica_boolean tmp448;
  modelica_boolean tmp449;
  static const MMC_DEFSTRINGLIT(tmp450,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[6] <= 10000000000.0, has value: ");
  modelica_string tmp451;
  static int tmp452 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp452)
  {
    tmp448 = GreaterEq(data->localData[0]->realVars[243] /* powerBlock.exchanger.h_HTF[6] variable */,-10000000000.0);
    tmp449 = LessEq(data->localData[0]->realVars[243] /* powerBlock.exchanger.h_HTF[6] variable */,10000000000.0);
    if(!(tmp448 && tmp449))
    {
      tmp451 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[243] /* powerBlock.exchanger.h_HTF[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp450),tmp451);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[6] >= -10000000000.0 and powerBlock.exchanger.h_HTF[6] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp452 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1560
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[7] >= -10000000000.0 and powerBlock.exchanger.h_HTF[7] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[7] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1560(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1560};
  modelica_boolean tmp453;
  modelica_boolean tmp454;
  static const MMC_DEFSTRINGLIT(tmp455,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[7] <= 10000000000.0, has value: ");
  modelica_string tmp456;
  static int tmp457 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp457)
  {
    tmp453 = GreaterEq(data->localData[0]->realVars[244] /* powerBlock.exchanger.h_HTF[7] variable */,-10000000000.0);
    tmp454 = LessEq(data->localData[0]->realVars[244] /* powerBlock.exchanger.h_HTF[7] variable */,10000000000.0);
    if(!(tmp453 && tmp454))
    {
      tmp456 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[244] /* powerBlock.exchanger.h_HTF[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp455),tmp456);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[7] >= -10000000000.0 and powerBlock.exchanger.h_HTF[7] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp457 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1561
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[8] >= -10000000000.0 and powerBlock.exchanger.h_HTF[8] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[8] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1561(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1561};
  modelica_boolean tmp458;
  modelica_boolean tmp459;
  static const MMC_DEFSTRINGLIT(tmp460,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[8] <= 10000000000.0, has value: ");
  modelica_string tmp461;
  static int tmp462 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp462)
  {
    tmp458 = GreaterEq(data->localData[0]->realVars[245] /* powerBlock.exchanger.h_HTF[8] variable */,-10000000000.0);
    tmp459 = LessEq(data->localData[0]->realVars[245] /* powerBlock.exchanger.h_HTF[8] variable */,10000000000.0);
    if(!(tmp458 && tmp459))
    {
      tmp461 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[245] /* powerBlock.exchanger.h_HTF[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp460),tmp461);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[8] >= -10000000000.0 and powerBlock.exchanger.h_HTF[8] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp462 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1562
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[9] >= -10000000000.0 and powerBlock.exchanger.h_HTF[9] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[9] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1562(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1562};
  modelica_boolean tmp463;
  modelica_boolean tmp464;
  static const MMC_DEFSTRINGLIT(tmp465,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[9] <= 10000000000.0, has value: ");
  modelica_string tmp466;
  static int tmp467 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp467)
  {
    tmp463 = GreaterEq(data->localData[0]->realVars[246] /* powerBlock.exchanger.h_HTF[9] variable */,-10000000000.0);
    tmp464 = LessEq(data->localData[0]->realVars[246] /* powerBlock.exchanger.h_HTF[9] variable */,10000000000.0);
    if(!(tmp463 && tmp464))
    {
      tmp466 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[246] /* powerBlock.exchanger.h_HTF[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp465),tmp466);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[9] >= -10000000000.0 and powerBlock.exchanger.h_HTF[9] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp467 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1563
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[10] >= -10000000000.0 and powerBlock.exchanger.h_HTF[10] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[10] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1563(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1563};
  modelica_boolean tmp468;
  modelica_boolean tmp469;
  static const MMC_DEFSTRINGLIT(tmp470,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[10] <= 10000000000.0, has value: ");
  modelica_string tmp471;
  static int tmp472 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp472)
  {
    tmp468 = GreaterEq(data->localData[0]->realVars[247] /* powerBlock.exchanger.h_HTF[10] variable */,-10000000000.0);
    tmp469 = LessEq(data->localData[0]->realVars[247] /* powerBlock.exchanger.h_HTF[10] variable */,10000000000.0);
    if(!(tmp468 && tmp469))
    {
      tmp471 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[247] /* powerBlock.exchanger.h_HTF[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp470),tmp471);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[10] >= -10000000000.0 and powerBlock.exchanger.h_HTF[10] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp472 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1564
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[11] >= -10000000000.0 and powerBlock.exchanger.h_HTF[11] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[11] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1564(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1564};
  modelica_boolean tmp473;
  modelica_boolean tmp474;
  static const MMC_DEFSTRINGLIT(tmp475,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[11] <= 10000000000.0, has value: ");
  modelica_string tmp476;
  static int tmp477 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp477)
  {
    tmp473 = GreaterEq(data->localData[0]->realVars[248] /* powerBlock.exchanger.h_HTF[11] variable */,-10000000000.0);
    tmp474 = LessEq(data->localData[0]->realVars[248] /* powerBlock.exchanger.h_HTF[11] variable */,10000000000.0);
    if(!(tmp473 && tmp474))
    {
      tmp476 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[248] /* powerBlock.exchanger.h_HTF[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp475),tmp476);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[11] >= -10000000000.0 and powerBlock.exchanger.h_HTF[11] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp477 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1565
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[12] >= -10000000000.0 and powerBlock.exchanger.h_HTF[12] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[12] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1565(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1565};
  modelica_boolean tmp478;
  modelica_boolean tmp479;
  static const MMC_DEFSTRINGLIT(tmp480,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[12] <= 10000000000.0, has value: ");
  modelica_string tmp481;
  static int tmp482 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp482)
  {
    tmp478 = GreaterEq(data->localData[0]->realVars[249] /* powerBlock.exchanger.h_HTF[12] variable */,-10000000000.0);
    tmp479 = LessEq(data->localData[0]->realVars[249] /* powerBlock.exchanger.h_HTF[12] variable */,10000000000.0);
    if(!(tmp478 && tmp479))
    {
      tmp481 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[249] /* powerBlock.exchanger.h_HTF[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp480),tmp481);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[12] >= -10000000000.0 and powerBlock.exchanger.h_HTF[12] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp482 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1566
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[13] >= -10000000000.0 and powerBlock.exchanger.h_HTF[13] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[13] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1566(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1566};
  modelica_boolean tmp483;
  modelica_boolean tmp484;
  static const MMC_DEFSTRINGLIT(tmp485,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[13] <= 10000000000.0, has value: ");
  modelica_string tmp486;
  static int tmp487 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp487)
  {
    tmp483 = GreaterEq(data->localData[0]->realVars[250] /* powerBlock.exchanger.h_HTF[13] variable */,-10000000000.0);
    tmp484 = LessEq(data->localData[0]->realVars[250] /* powerBlock.exchanger.h_HTF[13] variable */,10000000000.0);
    if(!(tmp483 && tmp484))
    {
      tmp486 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[250] /* powerBlock.exchanger.h_HTF[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp485),tmp486);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[13] >= -10000000000.0 and powerBlock.exchanger.h_HTF[13] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp487 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1567
type: ALGORITHM

  assert(powerBlock.exchanger.h_HTF[14] >= -10000000000.0 and powerBlock.exchanger.h_HTF[14] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[14] <= 10000000000.0, has value: " + String(powerBlock.exchanger.h_HTF[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1567(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1567};
  modelica_boolean tmp488;
  modelica_boolean tmp489;
  static const MMC_DEFSTRINGLIT(tmp490,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.exchanger.h_HTF[14] <= 10000000000.0, has value: ");
  modelica_string tmp491;
  static int tmp492 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp492)
  {
    tmp488 = GreaterEq(data->localData[0]->realVars[251] /* powerBlock.exchanger.h_HTF[14] variable */,-10000000000.0);
    tmp489 = LessEq(data->localData[0]->realVars[251] /* powerBlock.exchanger.h_HTF[14] variable */,10000000000.0);
    if(!(tmp488 && tmp489))
    {
      tmp491 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[251] /* powerBlock.exchanger.h_HTF[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp490),tmp491);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2312,4,2312,99,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.h_HTF[14] >= -10000000000.0 and powerBlock.exchanger.h_HTF[14] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp492 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1568
type: ALGORITHM

  assert(powerBlock.exchanger.T_CO2_out >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_CO2_out, has value: " + String(powerBlock.exchanger.T_CO2_out, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1568(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1568};
  modelica_boolean tmp493;
  static const MMC_DEFSTRINGLIT(tmp494,85,"Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_CO2_out, has value: ");
  modelica_string tmp495;
  static int tmp496 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp496)
  {
    tmp493 = GreaterEq(data->localData[0]->realVars[204] /* powerBlock.exchanger.T_CO2_out variable */,0.0);
    if(!tmp493)
    {
      tmp495 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[204] /* powerBlock.exchanger.T_CO2_out variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp494),tmp495);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2316,4,2316,42,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.T_CO2_out >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp496 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1569
type: ALGORITHM

  assert(powerBlock.exchanger.T_HTF_out >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_HTF_out, has value: " + String(powerBlock.exchanger.T_HTF_out, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1569(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1569};
  modelica_boolean tmp497;
  static const MMC_DEFSTRINGLIT(tmp498,85,"Variable violating min constraint: 0.0 <= powerBlock.exchanger.T_HTF_out, has value: ");
  modelica_string tmp499;
  static int tmp500 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp500)
  {
    tmp497 = GreaterEq(data->localData[0]->realVars[206] /* powerBlock.exchanger.T_HTF_out variable */,0.0);
    if(!tmp497)
    {
      tmp499 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[206] /* powerBlock.exchanger.T_HTF_out variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp498),tmp499);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2317,4,2317,42,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.exchanger.T_HTF_out >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp500 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1570
type: ALGORITHM

  assert(powerBlock.reCompressor.p_out >= 0.0 and powerBlock.reCompressor.p_out <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.reCompressor.p_out <= 100000000.0, has value: " + String(powerBlock.reCompressor.p_out, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1570(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1570};
  modelica_boolean tmp501;
  modelica_boolean tmp502;
  static const MMC_DEFSTRINGLIT(tmp503,103,"Variable violating min/max constraint: 0.0 <= powerBlock.reCompressor.p_out <= 100000000.0, has value: ");
  modelica_string tmp504;
  static int tmp505 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp505)
  {
    tmp501 = GreaterEq(data->localData[0]->realVars[266] /* powerBlock.reCompressor.p_out variable */,0.0);
    tmp502 = LessEq(data->localData[0]->realVars[266] /* powerBlock.reCompressor.p_out variable */,100000000.0);
    if(!(tmp501 && tmp502))
    {
      tmp504 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[266] /* powerBlock.reCompressor.p_out variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp503),tmp504);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",613,4,613,66,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.p_out >= 0.0 and powerBlock.reCompressor.p_out <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp505 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1571
type: ALGORITHM

  assert(powerBlock.reCompressor.state_isen.h >= -10000000000.0 and powerBlock.reCompressor.state_isen.h <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.reCompressor.state_isen.h <= 10000000000.0, has value: " + String(powerBlock.reCompressor.state_isen.h, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1571(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1571};
  modelica_boolean tmp506;
  modelica_boolean tmp507;
  static const MMC_DEFSTRINGLIT(tmp508,123,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.reCompressor.state_isen.h <= 10000000000.0, has value: ");
  modelica_string tmp509;
  static int tmp510 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp510)
  {
    tmp506 = GreaterEq(data->localData[0]->realVars[272] /* powerBlock.reCompressor.state_isen.h variable */,-10000000000.0);
    tmp507 = LessEq(data->localData[0]->realVars[272] /* powerBlock.reCompressor.state_isen.h variable */,10000000000.0);
    if(!(tmp506 && tmp507))
    {
      tmp509 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[272] /* powerBlock.reCompressor.state_isen.h variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp508),tmp509);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",90,7,90,45,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.state_isen.h >= -10000000000.0 and powerBlock.reCompressor.state_isen.h <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp510 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1572
type: ALGORITHM

  assert(powerBlock.reCompressor.state_b.h >= -10000000000.0 and powerBlock.reCompressor.state_b.h <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.reCompressor.state_b.h <= 10000000000.0, has value: " + String(powerBlock.reCompressor.state_b.h, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1572(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1572};
  modelica_boolean tmp511;
  modelica_boolean tmp512;
  static const MMC_DEFSTRINGLIT(tmp513,120,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.reCompressor.state_b.h <= 10000000000.0, has value: ");
  modelica_string tmp514;
  static int tmp515 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp515)
  {
    tmp511 = GreaterEq(data->localData[0]->realVars[271] /* powerBlock.reCompressor.state_b.h variable */,-10000000000.0);
    tmp512 = LessEq(data->localData[0]->realVars[271] /* powerBlock.reCompressor.state_b.h variable */,10000000000.0);
    if(!(tmp511 && tmp512))
    {
      tmp514 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[271] /* powerBlock.reCompressor.state_b.h variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp513),tmp514);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",90,7,90,45,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.state_b.h >= -10000000000.0 and powerBlock.reCompressor.state_b.h <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp515 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1573
type: ALGORITHM

  assert(powerBlock.reCompressor.d_entrance >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.d_entrance, has value: " + String(powerBlock.reCompressor.d_entrance, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1573(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1573};
  modelica_boolean tmp516;
  static const MMC_DEFSTRINGLIT(tmp517,89,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.d_entrance, has value: ");
  modelica_string tmp518;
  static int tmp519 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp519)
  {
    tmp516 = GreaterEq(data->localData[0]->realVars[264] /* powerBlock.reCompressor.d_entrance variable */,0.0);
    if(!tmp516)
    {
      tmp518 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[264] /* powerBlock.reCompressor.d_entrance variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp517),tmp518);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",619,4,619,61,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.d_entrance >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp519 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1574
type: ALGORITHM

  assert(powerBlock.reCompressor.eta_comp >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.eta_comp, has value: " + String(powerBlock.reCompressor.eta_comp, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1574(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1574};
  modelica_boolean tmp520;
  static const MMC_DEFSTRINGLIT(tmp521,87,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.eta_comp, has value: ");
  modelica_string tmp522;
  static int tmp523 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp523)
  {
    tmp520 = GreaterEq(data->localData[0]->realVars[265] /* powerBlock.reCompressor.eta_comp variable */,0.0);
    if(!tmp520)
    {
      tmp522 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[265] /* powerBlock.reCompressor.eta_comp variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp521),tmp522);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",620,4,620,88,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.eta_comp >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp523 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1575
type: ALGORITHM

  assert(powerBlock.reCompressor.phi >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.phi, has value: " + String(powerBlock.reCompressor.phi, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1575(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1575};
  modelica_boolean tmp524;
  static const MMC_DEFSTRINGLIT(tmp525,82,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.phi, has value: ");
  modelica_string tmp526;
  static int tmp527 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp527)
  {
    tmp524 = GreaterEq(data->localData[0]->realVars[267] /* powerBlock.reCompressor.phi variable */,0.0);
    if(!tmp524)
    {
      tmp526 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[267] /* powerBlock.reCompressor.phi variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp525),tmp526);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",621,4,621,52,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.phi >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp527 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1576
type: ALGORITHM

  assert(powerBlock.reCompressor.psi >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.reCompressor.psi, has value: " + String(powerBlock.reCompressor.psi, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1576(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1576};
  modelica_boolean tmp528;
  static const MMC_DEFSTRINGLIT(tmp529,82,"Variable violating min constraint: 0.0 <= powerBlock.reCompressor.psi, has value: ");
  modelica_string tmp530;
  static int tmp531 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp531)
  {
    tmp528 = GreaterEq(data->localData[0]->realVars[269] /* powerBlock.reCompressor.psi variable */,0.0);
    if(!tmp528)
    {
      tmp530 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[269] /* powerBlock.reCompressor.psi variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp529),tmp530);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",622,4,622,42,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.reCompressor.psi >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp531 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1577
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[1] >= -10000000000.0 and powerBlock.LTR.h_from_turb[1] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[1] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[1], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1577(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1577};
  modelica_boolean tmp532;
  modelica_boolean tmp533;
  static const MMC_DEFSTRINGLIT(tmp534,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[1] <= 10000000000.0, has value: ");
  modelica_string tmp535;
  static int tmp536 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp536)
  {
    tmp532 = GreaterEq(data->localData[0]->realVars[171] /* powerBlock.LTR.h_from_turb[1] variable */,-10000000000.0);
    tmp533 = LessEq(data->localData[0]->realVars[171] /* powerBlock.LTR.h_from_turb[1] variable */,10000000000.0);
    if(!(tmp532 && tmp533))
    {
      tmp535 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[171] /* powerBlock.LTR.h_from_turb[1] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp534),tmp535);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[1] >= -10000000000.0 and powerBlock.LTR.h_from_turb[1] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp536 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1578
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[2] >= -10000000000.0 and powerBlock.LTR.h_from_turb[2] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[2] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1578(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1578};
  modelica_boolean tmp537;
  modelica_boolean tmp538;
  static const MMC_DEFSTRINGLIT(tmp539,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[2] <= 10000000000.0, has value: ");
  modelica_string tmp540;
  static int tmp541 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp541)
  {
    tmp537 = GreaterEq(data->localData[0]->realVars[172] /* powerBlock.LTR.h_from_turb[2] variable */,-10000000000.0);
    tmp538 = LessEq(data->localData[0]->realVars[172] /* powerBlock.LTR.h_from_turb[2] variable */,10000000000.0);
    if(!(tmp537 && tmp538))
    {
      tmp540 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[172] /* powerBlock.LTR.h_from_turb[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp539),tmp540);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[2] >= -10000000000.0 and powerBlock.LTR.h_from_turb[2] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp541 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1579
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[3] >= -10000000000.0 and powerBlock.LTR.h_from_turb[3] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[3] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1579(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1579};
  modelica_boolean tmp542;
  modelica_boolean tmp543;
  static const MMC_DEFSTRINGLIT(tmp544,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[3] <= 10000000000.0, has value: ");
  modelica_string tmp545;
  static int tmp546 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp546)
  {
    tmp542 = GreaterEq(data->localData[0]->realVars[173] /* powerBlock.LTR.h_from_turb[3] variable */,-10000000000.0);
    tmp543 = LessEq(data->localData[0]->realVars[173] /* powerBlock.LTR.h_from_turb[3] variable */,10000000000.0);
    if(!(tmp542 && tmp543))
    {
      tmp545 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[173] /* powerBlock.LTR.h_from_turb[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp544),tmp545);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[3] >= -10000000000.0 and powerBlock.LTR.h_from_turb[3] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp546 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1580
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[4] >= -10000000000.0 and powerBlock.LTR.h_from_turb[4] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[4] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1580(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1580};
  modelica_boolean tmp547;
  modelica_boolean tmp548;
  static const MMC_DEFSTRINGLIT(tmp549,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[4] <= 10000000000.0, has value: ");
  modelica_string tmp550;
  static int tmp551 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp551)
  {
    tmp547 = GreaterEq(data->localData[0]->realVars[174] /* powerBlock.LTR.h_from_turb[4] variable */,-10000000000.0);
    tmp548 = LessEq(data->localData[0]->realVars[174] /* powerBlock.LTR.h_from_turb[4] variable */,10000000000.0);
    if(!(tmp547 && tmp548))
    {
      tmp550 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[174] /* powerBlock.LTR.h_from_turb[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp549),tmp550);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[4] >= -10000000000.0 and powerBlock.LTR.h_from_turb[4] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp551 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1581
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[5] >= -10000000000.0 and powerBlock.LTR.h_from_turb[5] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[5] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1581(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1581};
  modelica_boolean tmp552;
  modelica_boolean tmp553;
  static const MMC_DEFSTRINGLIT(tmp554,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[5] <= 10000000000.0, has value: ");
  modelica_string tmp555;
  static int tmp556 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp556)
  {
    tmp552 = GreaterEq(data->localData[0]->realVars[175] /* powerBlock.LTR.h_from_turb[5] variable */,-10000000000.0);
    tmp553 = LessEq(data->localData[0]->realVars[175] /* powerBlock.LTR.h_from_turb[5] variable */,10000000000.0);
    if(!(tmp552 && tmp553))
    {
      tmp555 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[175] /* powerBlock.LTR.h_from_turb[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp554),tmp555);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[5] >= -10000000000.0 and powerBlock.LTR.h_from_turb[5] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp556 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1582
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[6] >= -10000000000.0 and powerBlock.LTR.h_from_turb[6] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[6] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1582(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1582};
  modelica_boolean tmp557;
  modelica_boolean tmp558;
  static const MMC_DEFSTRINGLIT(tmp559,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[6] <= 10000000000.0, has value: ");
  modelica_string tmp560;
  static int tmp561 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp561)
  {
    tmp557 = GreaterEq(data->localData[0]->realVars[176] /* powerBlock.LTR.h_from_turb[6] variable */,-10000000000.0);
    tmp558 = LessEq(data->localData[0]->realVars[176] /* powerBlock.LTR.h_from_turb[6] variable */,10000000000.0);
    if(!(tmp557 && tmp558))
    {
      tmp560 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[176] /* powerBlock.LTR.h_from_turb[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp559),tmp560);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[6] >= -10000000000.0 and powerBlock.LTR.h_from_turb[6] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp561 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1583
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[7] >= -10000000000.0 and powerBlock.LTR.h_from_turb[7] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[7] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1583(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1583};
  modelica_boolean tmp562;
  modelica_boolean tmp563;
  static const MMC_DEFSTRINGLIT(tmp564,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[7] <= 10000000000.0, has value: ");
  modelica_string tmp565;
  static int tmp566 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp566)
  {
    tmp562 = GreaterEq(data->localData[0]->realVars[177] /* powerBlock.LTR.h_from_turb[7] variable */,-10000000000.0);
    tmp563 = LessEq(data->localData[0]->realVars[177] /* powerBlock.LTR.h_from_turb[7] variable */,10000000000.0);
    if(!(tmp562 && tmp563))
    {
      tmp565 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[177] /* powerBlock.LTR.h_from_turb[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp564),tmp565);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[7] >= -10000000000.0 and powerBlock.LTR.h_from_turb[7] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp566 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1584
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[8] >= -10000000000.0 and powerBlock.LTR.h_from_turb[8] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[8] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1584(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1584};
  modelica_boolean tmp567;
  modelica_boolean tmp568;
  static const MMC_DEFSTRINGLIT(tmp569,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[8] <= 10000000000.0, has value: ");
  modelica_string tmp570;
  static int tmp571 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp571)
  {
    tmp567 = GreaterEq(data->localData[0]->realVars[178] /* powerBlock.LTR.h_from_turb[8] variable */,-10000000000.0);
    tmp568 = LessEq(data->localData[0]->realVars[178] /* powerBlock.LTR.h_from_turb[8] variable */,10000000000.0);
    if(!(tmp567 && tmp568))
    {
      tmp570 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[178] /* powerBlock.LTR.h_from_turb[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp569),tmp570);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[8] >= -10000000000.0 and powerBlock.LTR.h_from_turb[8] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp571 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1585
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[9] >= -10000000000.0 and powerBlock.LTR.h_from_turb[9] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[9] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1585(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1585};
  modelica_boolean tmp572;
  modelica_boolean tmp573;
  static const MMC_DEFSTRINGLIT(tmp574,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[9] <= 10000000000.0, has value: ");
  modelica_string tmp575;
  static int tmp576 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp576)
  {
    tmp572 = GreaterEq(data->localData[0]->realVars[179] /* powerBlock.LTR.h_from_turb[9] variable */,-10000000000.0);
    tmp573 = LessEq(data->localData[0]->realVars[179] /* powerBlock.LTR.h_from_turb[9] variable */,10000000000.0);
    if(!(tmp572 && tmp573))
    {
      tmp575 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[179] /* powerBlock.LTR.h_from_turb[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp574),tmp575);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[9] >= -10000000000.0 and powerBlock.LTR.h_from_turb[9] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp576 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1586
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[10] >= -10000000000.0 and powerBlock.LTR.h_from_turb[10] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[10] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1586(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1586};
  modelica_boolean tmp577;
  modelica_boolean tmp578;
  static const MMC_DEFSTRINGLIT(tmp579,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[10] <= 10000000000.0, has value: ");
  modelica_string tmp580;
  static int tmp581 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp581)
  {
    tmp577 = GreaterEq(data->localData[0]->realVars[180] /* powerBlock.LTR.h_from_turb[10] variable */,-10000000000.0);
    tmp578 = LessEq(data->localData[0]->realVars[180] /* powerBlock.LTR.h_from_turb[10] variable */,10000000000.0);
    if(!(tmp577 && tmp578))
    {
      tmp580 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[180] /* powerBlock.LTR.h_from_turb[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp579),tmp580);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[10] >= -10000000000.0 and powerBlock.LTR.h_from_turb[10] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp581 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1587
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[11] >= -10000000000.0 and powerBlock.LTR.h_from_turb[11] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[11] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1587(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1587};
  modelica_boolean tmp582;
  modelica_boolean tmp583;
  static const MMC_DEFSTRINGLIT(tmp584,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[11] <= 10000000000.0, has value: ");
  modelica_string tmp585;
  static int tmp586 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp586)
  {
    tmp582 = GreaterEq(data->localData[0]->realVars[181] /* powerBlock.LTR.h_from_turb[11] variable */,-10000000000.0);
    tmp583 = LessEq(data->localData[0]->realVars[181] /* powerBlock.LTR.h_from_turb[11] variable */,10000000000.0);
    if(!(tmp582 && tmp583))
    {
      tmp585 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[181] /* powerBlock.LTR.h_from_turb[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp584),tmp585);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[11] >= -10000000000.0 and powerBlock.LTR.h_from_turb[11] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp586 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1588
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[12] >= -10000000000.0 and powerBlock.LTR.h_from_turb[12] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[12] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1588(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1588};
  modelica_boolean tmp587;
  modelica_boolean tmp588;
  static const MMC_DEFSTRINGLIT(tmp589,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[12] <= 10000000000.0, has value: ");
  modelica_string tmp590;
  static int tmp591 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp591)
  {
    tmp587 = GreaterEq(data->localData[0]->realVars[182] /* powerBlock.LTR.h_from_turb[12] variable */,-10000000000.0);
    tmp588 = LessEq(data->localData[0]->realVars[182] /* powerBlock.LTR.h_from_turb[12] variable */,10000000000.0);
    if(!(tmp587 && tmp588))
    {
      tmp590 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[182] /* powerBlock.LTR.h_from_turb[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp589),tmp590);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[12] >= -10000000000.0 and powerBlock.LTR.h_from_turb[12] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp591 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1589
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[13] >= -10000000000.0 and powerBlock.LTR.h_from_turb[13] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[13] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1589(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1589};
  modelica_boolean tmp592;
  modelica_boolean tmp593;
  static const MMC_DEFSTRINGLIT(tmp594,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[13] <= 10000000000.0, has value: ");
  modelica_string tmp595;
  static int tmp596 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp596)
  {
    tmp592 = GreaterEq(data->localData[0]->realVars[183] /* powerBlock.LTR.h_from_turb[13] variable */,-10000000000.0);
    tmp593 = LessEq(data->localData[0]->realVars[183] /* powerBlock.LTR.h_from_turb[13] variable */,10000000000.0);
    if(!(tmp592 && tmp593))
    {
      tmp595 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[183] /* powerBlock.LTR.h_from_turb[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp594),tmp595);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[13] >= -10000000000.0 and powerBlock.LTR.h_from_turb[13] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp596 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1590
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[14] >= -10000000000.0 and powerBlock.LTR.h_from_turb[14] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[14] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1590(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1590};
  modelica_boolean tmp597;
  modelica_boolean tmp598;
  static const MMC_DEFSTRINGLIT(tmp599,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[14] <= 10000000000.0, has value: ");
  modelica_string tmp600;
  static int tmp601 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp601)
  {
    tmp597 = GreaterEq(data->localData[0]->realVars[184] /* powerBlock.LTR.h_from_turb[14] variable */,-10000000000.0);
    tmp598 = LessEq(data->localData[0]->realVars[184] /* powerBlock.LTR.h_from_turb[14] variable */,10000000000.0);
    if(!(tmp597 && tmp598))
    {
      tmp600 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[184] /* powerBlock.LTR.h_from_turb[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp599),tmp600);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[14] >= -10000000000.0 and powerBlock.LTR.h_from_turb[14] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp601 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1591
type: ALGORITHM

  assert(powerBlock.LTR.h_from_turb[15] >= -10000000000.0 and powerBlock.LTR.h_from_turb[15] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[15] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_turb[15], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1591(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1591};
  modelica_boolean tmp602;
  modelica_boolean tmp603;
  static const MMC_DEFSTRINGLIT(tmp604,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_turb[15] <= 10000000000.0, has value: ");
  modelica_string tmp605;
  static int tmp606 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp606)
  {
    tmp602 = GreaterEq(data->localData[0]->realVars[185] /* powerBlock.LTR.h_from_turb[15] variable */,-10000000000.0);
    tmp603 = LessEq(data->localData[0]->realVars[185] /* powerBlock.LTR.h_from_turb[15] variable */,10000000000.0);
    if(!(tmp602 && tmp603))
    {
      tmp605 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[185] /* powerBlock.LTR.h_from_turb[15] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp604),tmp605);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",501,4,501,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_turb[15] >= -10000000000.0 and powerBlock.LTR.h_from_turb[15] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp606 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1592
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[1] >= 20.0 and powerBlock.LTR.T_from_turb[1] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[1] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[1], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1592(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1592};
  modelica_boolean tmp607;
  modelica_boolean tmp608;
  static const MMC_DEFSTRINGLIT(tmp609,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[1] <= 873.15, has value: ");
  modelica_string tmp610;
  static int tmp611 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp611)
  {
    tmp607 = GreaterEq(data->localData[0]->realVars[126] /* powerBlock.LTR.T_from_turb[1] variable */,20.0);
    tmp608 = LessEq(data->localData[0]->realVars[126] /* powerBlock.LTR.T_from_turb[1] variable */,873.15);
    if(!(tmp607 && tmp608))
    {
      tmp610 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[126] /* powerBlock.LTR.T_from_turb[1] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp609),tmp610);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[1] >= 20.0 and powerBlock.LTR.T_from_turb[1] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp611 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1593
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[2] >= 20.0 and powerBlock.LTR.T_from_turb[2] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[2] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1593(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1593};
  modelica_boolean tmp612;
  modelica_boolean tmp613;
  static const MMC_DEFSTRINGLIT(tmp614,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[2] <= 873.15, has value: ");
  modelica_string tmp615;
  static int tmp616 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp616)
  {
    tmp612 = GreaterEq(data->localData[0]->realVars[127] /* powerBlock.LTR.T_from_turb[2] variable */,20.0);
    tmp613 = LessEq(data->localData[0]->realVars[127] /* powerBlock.LTR.T_from_turb[2] variable */,873.15);
    if(!(tmp612 && tmp613))
    {
      tmp615 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[127] /* powerBlock.LTR.T_from_turb[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp614),tmp615);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[2] >= 20.0 and powerBlock.LTR.T_from_turb[2] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp616 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1594
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[3] >= 20.0 and powerBlock.LTR.T_from_turb[3] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[3] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1594(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1594};
  modelica_boolean tmp617;
  modelica_boolean tmp618;
  static const MMC_DEFSTRINGLIT(tmp619,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[3] <= 873.15, has value: ");
  modelica_string tmp620;
  static int tmp621 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp621)
  {
    tmp617 = GreaterEq(data->localData[0]->realVars[128] /* powerBlock.LTR.T_from_turb[3] variable */,20.0);
    tmp618 = LessEq(data->localData[0]->realVars[128] /* powerBlock.LTR.T_from_turb[3] variable */,873.15);
    if(!(tmp617 && tmp618))
    {
      tmp620 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[128] /* powerBlock.LTR.T_from_turb[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp619),tmp620);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[3] >= 20.0 and powerBlock.LTR.T_from_turb[3] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp621 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1595
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[4] >= 20.0 and powerBlock.LTR.T_from_turb[4] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[4] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1595(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1595};
  modelica_boolean tmp622;
  modelica_boolean tmp623;
  static const MMC_DEFSTRINGLIT(tmp624,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[4] <= 873.15, has value: ");
  modelica_string tmp625;
  static int tmp626 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp626)
  {
    tmp622 = GreaterEq(data->localData[0]->realVars[129] /* powerBlock.LTR.T_from_turb[4] variable */,20.0);
    tmp623 = LessEq(data->localData[0]->realVars[129] /* powerBlock.LTR.T_from_turb[4] variable */,873.15);
    if(!(tmp622 && tmp623))
    {
      tmp625 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[129] /* powerBlock.LTR.T_from_turb[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp624),tmp625);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[4] >= 20.0 and powerBlock.LTR.T_from_turb[4] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp626 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1596
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[5] >= 20.0 and powerBlock.LTR.T_from_turb[5] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[5] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1596(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1596};
  modelica_boolean tmp627;
  modelica_boolean tmp628;
  static const MMC_DEFSTRINGLIT(tmp629,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[5] <= 873.15, has value: ");
  modelica_string tmp630;
  static int tmp631 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp631)
  {
    tmp627 = GreaterEq(data->localData[0]->realVars[130] /* powerBlock.LTR.T_from_turb[5] variable */,20.0);
    tmp628 = LessEq(data->localData[0]->realVars[130] /* powerBlock.LTR.T_from_turb[5] variable */,873.15);
    if(!(tmp627 && tmp628))
    {
      tmp630 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[130] /* powerBlock.LTR.T_from_turb[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp629),tmp630);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[5] >= 20.0 and powerBlock.LTR.T_from_turb[5] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp631 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1597
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[6] >= 20.0 and powerBlock.LTR.T_from_turb[6] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[6] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1597(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1597};
  modelica_boolean tmp632;
  modelica_boolean tmp633;
  static const MMC_DEFSTRINGLIT(tmp634,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[6] <= 873.15, has value: ");
  modelica_string tmp635;
  static int tmp636 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp636)
  {
    tmp632 = GreaterEq(data->localData[0]->realVars[131] /* powerBlock.LTR.T_from_turb[6] variable */,20.0);
    tmp633 = LessEq(data->localData[0]->realVars[131] /* powerBlock.LTR.T_from_turb[6] variable */,873.15);
    if(!(tmp632 && tmp633))
    {
      tmp635 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[131] /* powerBlock.LTR.T_from_turb[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp634),tmp635);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[6] >= 20.0 and powerBlock.LTR.T_from_turb[6] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp636 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1598
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[7] >= 20.0 and powerBlock.LTR.T_from_turb[7] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[7] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1598(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1598};
  modelica_boolean tmp637;
  modelica_boolean tmp638;
  static const MMC_DEFSTRINGLIT(tmp639,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[7] <= 873.15, has value: ");
  modelica_string tmp640;
  static int tmp641 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp641)
  {
    tmp637 = GreaterEq(data->localData[0]->realVars[132] /* powerBlock.LTR.T_from_turb[7] variable */,20.0);
    tmp638 = LessEq(data->localData[0]->realVars[132] /* powerBlock.LTR.T_from_turb[7] variable */,873.15);
    if(!(tmp637 && tmp638))
    {
      tmp640 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[132] /* powerBlock.LTR.T_from_turb[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp639),tmp640);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[7] >= 20.0 and powerBlock.LTR.T_from_turb[7] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp641 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1599
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[8] >= 20.0 and powerBlock.LTR.T_from_turb[8] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[8] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1599(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1599};
  modelica_boolean tmp642;
  modelica_boolean tmp643;
  static const MMC_DEFSTRINGLIT(tmp644,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[8] <= 873.15, has value: ");
  modelica_string tmp645;
  static int tmp646 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp646)
  {
    tmp642 = GreaterEq(data->localData[0]->realVars[133] /* powerBlock.LTR.T_from_turb[8] variable */,20.0);
    tmp643 = LessEq(data->localData[0]->realVars[133] /* powerBlock.LTR.T_from_turb[8] variable */,873.15);
    if(!(tmp642 && tmp643))
    {
      tmp645 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[133] /* powerBlock.LTR.T_from_turb[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp644),tmp645);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[8] >= 20.0 and powerBlock.LTR.T_from_turb[8] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp646 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1600
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[9] >= 20.0 and powerBlock.LTR.T_from_turb[9] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[9] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1600(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1600};
  modelica_boolean tmp647;
  modelica_boolean tmp648;
  static const MMC_DEFSTRINGLIT(tmp649,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[9] <= 873.15, has value: ");
  modelica_string tmp650;
  static int tmp651 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp651)
  {
    tmp647 = GreaterEq(data->localData[0]->realVars[134] /* powerBlock.LTR.T_from_turb[9] variable */,20.0);
    tmp648 = LessEq(data->localData[0]->realVars[134] /* powerBlock.LTR.T_from_turb[9] variable */,873.15);
    if(!(tmp647 && tmp648))
    {
      tmp650 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[134] /* powerBlock.LTR.T_from_turb[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp649),tmp650);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[9] >= 20.0 and powerBlock.LTR.T_from_turb[9] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp651 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1601
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[10] >= 20.0 and powerBlock.LTR.T_from_turb[10] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[10] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1601(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1601};
  modelica_boolean tmp652;
  modelica_boolean tmp653;
  static const MMC_DEFSTRINGLIT(tmp654,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[10] <= 873.15, has value: ");
  modelica_string tmp655;
  static int tmp656 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp656)
  {
    tmp652 = GreaterEq(data->localData[0]->realVars[135] /* powerBlock.LTR.T_from_turb[10] variable */,20.0);
    tmp653 = LessEq(data->localData[0]->realVars[135] /* powerBlock.LTR.T_from_turb[10] variable */,873.15);
    if(!(tmp652 && tmp653))
    {
      tmp655 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[135] /* powerBlock.LTR.T_from_turb[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp654),tmp655);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[10] >= 20.0 and powerBlock.LTR.T_from_turb[10] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp656 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1602
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[11] >= 20.0 and powerBlock.LTR.T_from_turb[11] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[11] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1602(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1602};
  modelica_boolean tmp657;
  modelica_boolean tmp658;
  static const MMC_DEFSTRINGLIT(tmp659,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[11] <= 873.15, has value: ");
  modelica_string tmp660;
  static int tmp661 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp661)
  {
    tmp657 = GreaterEq(data->localData[0]->realVars[136] /* powerBlock.LTR.T_from_turb[11] variable */,20.0);
    tmp658 = LessEq(data->localData[0]->realVars[136] /* powerBlock.LTR.T_from_turb[11] variable */,873.15);
    if(!(tmp657 && tmp658))
    {
      tmp660 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[136] /* powerBlock.LTR.T_from_turb[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp659),tmp660);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[11] >= 20.0 and powerBlock.LTR.T_from_turb[11] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp661 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1603
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[12] >= 20.0 and powerBlock.LTR.T_from_turb[12] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[12] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1603(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1603};
  modelica_boolean tmp662;
  modelica_boolean tmp663;
  static const MMC_DEFSTRINGLIT(tmp664,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[12] <= 873.15, has value: ");
  modelica_string tmp665;
  static int tmp666 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp666)
  {
    tmp662 = GreaterEq(data->localData[0]->realVars[137] /* powerBlock.LTR.T_from_turb[12] variable */,20.0);
    tmp663 = LessEq(data->localData[0]->realVars[137] /* powerBlock.LTR.T_from_turb[12] variable */,873.15);
    if(!(tmp662 && tmp663))
    {
      tmp665 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[137] /* powerBlock.LTR.T_from_turb[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp664),tmp665);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[12] >= 20.0 and powerBlock.LTR.T_from_turb[12] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp666 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1604
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[13] >= 20.0 and powerBlock.LTR.T_from_turb[13] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[13] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1604(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1604};
  modelica_boolean tmp667;
  modelica_boolean tmp668;
  static const MMC_DEFSTRINGLIT(tmp669,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[13] <= 873.15, has value: ");
  modelica_string tmp670;
  static int tmp671 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp671)
  {
    tmp667 = GreaterEq(data->localData[0]->realVars[138] /* powerBlock.LTR.T_from_turb[13] variable */,20.0);
    tmp668 = LessEq(data->localData[0]->realVars[138] /* powerBlock.LTR.T_from_turb[13] variable */,873.15);
    if(!(tmp667 && tmp668))
    {
      tmp670 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[138] /* powerBlock.LTR.T_from_turb[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp669),tmp670);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[13] >= 20.0 and powerBlock.LTR.T_from_turb[13] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp671 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1605
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[14] >= 20.0 and powerBlock.LTR.T_from_turb[14] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[14] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1605(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1605};
  modelica_boolean tmp672;
  modelica_boolean tmp673;
  static const MMC_DEFSTRINGLIT(tmp674,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[14] <= 873.15, has value: ");
  modelica_string tmp675;
  static int tmp676 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp676)
  {
    tmp672 = GreaterEq(data->localData[0]->realVars[139] /* powerBlock.LTR.T_from_turb[14] variable */,20.0);
    tmp673 = LessEq(data->localData[0]->realVars[139] /* powerBlock.LTR.T_from_turb[14] variable */,873.15);
    if(!(tmp672 && tmp673))
    {
      tmp675 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[139] /* powerBlock.LTR.T_from_turb[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp674),tmp675);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[14] >= 20.0 and powerBlock.LTR.T_from_turb[14] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp676 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1606
type: ALGORITHM

  assert(powerBlock.LTR.T_from_turb[15] >= 20.0 and powerBlock.LTR.T_from_turb[15] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[15] <= 873.15, has value: " + String(powerBlock.LTR.T_from_turb[15], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1606(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1606};
  modelica_boolean tmp677;
  modelica_boolean tmp678;
  static const MMC_DEFSTRINGLIT(tmp679,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_turb[15] <= 873.15, has value: ");
  modelica_string tmp680;
  static int tmp681 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp681)
  {
    tmp677 = GreaterEq(data->localData[0]->realVars[140] /* powerBlock.LTR.T_from_turb[15] variable */,20.0);
    tmp678 = LessEq(data->localData[0]->realVars[140] /* powerBlock.LTR.T_from_turb[15] variable */,873.15);
    if(!(tmp677 && tmp678))
    {
      tmp680 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[140] /* powerBlock.LTR.T_from_turb[15] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp679),tmp680);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",503,4,503,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_turb[15] >= 20.0 and powerBlock.LTR.T_from_turb[15] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp681 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1607
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[1] >= 20.0 and powerBlock.LTR.T_from_comp[1] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[1] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[1], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1607(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1607};
  modelica_boolean tmp682;
  modelica_boolean tmp683;
  static const MMC_DEFSTRINGLIT(tmp684,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[1] <= 873.15, has value: ");
  modelica_string tmp685;
  static int tmp686 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp686)
  {
    tmp682 = GreaterEq(data->localData[0]->realVars[111] /* powerBlock.LTR.T_from_comp[1] variable */,20.0);
    tmp683 = LessEq(data->localData[0]->realVars[111] /* powerBlock.LTR.T_from_comp[1] variable */,873.15);
    if(!(tmp682 && tmp683))
    {
      tmp685 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[111] /* powerBlock.LTR.T_from_comp[1] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp684),tmp685);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[1] >= 20.0 and powerBlock.LTR.T_from_comp[1] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp686 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1608
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[2] >= 20.0 and powerBlock.LTR.T_from_comp[2] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[2] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1608(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1608};
  modelica_boolean tmp687;
  modelica_boolean tmp688;
  static const MMC_DEFSTRINGLIT(tmp689,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[2] <= 873.15, has value: ");
  modelica_string tmp690;
  static int tmp691 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp691)
  {
    tmp687 = GreaterEq(data->localData[0]->realVars[112] /* powerBlock.LTR.T_from_comp[2] variable */,20.0);
    tmp688 = LessEq(data->localData[0]->realVars[112] /* powerBlock.LTR.T_from_comp[2] variable */,873.15);
    if(!(tmp687 && tmp688))
    {
      tmp690 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[112] /* powerBlock.LTR.T_from_comp[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp689),tmp690);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[2] >= 20.0 and powerBlock.LTR.T_from_comp[2] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp691 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1609
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[3] >= 20.0 and powerBlock.LTR.T_from_comp[3] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[3] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1609(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1609};
  modelica_boolean tmp692;
  modelica_boolean tmp693;
  static const MMC_DEFSTRINGLIT(tmp694,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[3] <= 873.15, has value: ");
  modelica_string tmp695;
  static int tmp696 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp696)
  {
    tmp692 = GreaterEq(data->localData[0]->realVars[113] /* powerBlock.LTR.T_from_comp[3] variable */,20.0);
    tmp693 = LessEq(data->localData[0]->realVars[113] /* powerBlock.LTR.T_from_comp[3] variable */,873.15);
    if(!(tmp692 && tmp693))
    {
      tmp695 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[113] /* powerBlock.LTR.T_from_comp[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp694),tmp695);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[3] >= 20.0 and powerBlock.LTR.T_from_comp[3] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp696 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1610
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[4] >= 20.0 and powerBlock.LTR.T_from_comp[4] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[4] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1610(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1610};
  modelica_boolean tmp697;
  modelica_boolean tmp698;
  static const MMC_DEFSTRINGLIT(tmp699,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[4] <= 873.15, has value: ");
  modelica_string tmp700;
  static int tmp701 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp701)
  {
    tmp697 = GreaterEq(data->localData[0]->realVars[114] /* powerBlock.LTR.T_from_comp[4] variable */,20.0);
    tmp698 = LessEq(data->localData[0]->realVars[114] /* powerBlock.LTR.T_from_comp[4] variable */,873.15);
    if(!(tmp697 && tmp698))
    {
      tmp700 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[114] /* powerBlock.LTR.T_from_comp[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp699),tmp700);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[4] >= 20.0 and powerBlock.LTR.T_from_comp[4] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp701 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1611
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[5] >= 20.0 and powerBlock.LTR.T_from_comp[5] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[5] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1611(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1611};
  modelica_boolean tmp702;
  modelica_boolean tmp703;
  static const MMC_DEFSTRINGLIT(tmp704,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[5] <= 873.15, has value: ");
  modelica_string tmp705;
  static int tmp706 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp706)
  {
    tmp702 = GreaterEq(data->localData[0]->realVars[115] /* powerBlock.LTR.T_from_comp[5] variable */,20.0);
    tmp703 = LessEq(data->localData[0]->realVars[115] /* powerBlock.LTR.T_from_comp[5] variable */,873.15);
    if(!(tmp702 && tmp703))
    {
      tmp705 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[115] /* powerBlock.LTR.T_from_comp[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp704),tmp705);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[5] >= 20.0 and powerBlock.LTR.T_from_comp[5] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp706 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1612
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[6] >= 20.0 and powerBlock.LTR.T_from_comp[6] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[6] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1612(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1612};
  modelica_boolean tmp707;
  modelica_boolean tmp708;
  static const MMC_DEFSTRINGLIT(tmp709,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[6] <= 873.15, has value: ");
  modelica_string tmp710;
  static int tmp711 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp711)
  {
    tmp707 = GreaterEq(data->localData[0]->realVars[116] /* powerBlock.LTR.T_from_comp[6] variable */,20.0);
    tmp708 = LessEq(data->localData[0]->realVars[116] /* powerBlock.LTR.T_from_comp[6] variable */,873.15);
    if(!(tmp707 && tmp708))
    {
      tmp710 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[116] /* powerBlock.LTR.T_from_comp[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp709),tmp710);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[6] >= 20.0 and powerBlock.LTR.T_from_comp[6] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp711 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1613
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[7] >= 20.0 and powerBlock.LTR.T_from_comp[7] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[7] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1613(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1613};
  modelica_boolean tmp712;
  modelica_boolean tmp713;
  static const MMC_DEFSTRINGLIT(tmp714,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[7] <= 873.15, has value: ");
  modelica_string tmp715;
  static int tmp716 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp716)
  {
    tmp712 = GreaterEq(data->localData[0]->realVars[117] /* powerBlock.LTR.T_from_comp[7] variable */,20.0);
    tmp713 = LessEq(data->localData[0]->realVars[117] /* powerBlock.LTR.T_from_comp[7] variable */,873.15);
    if(!(tmp712 && tmp713))
    {
      tmp715 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[117] /* powerBlock.LTR.T_from_comp[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp714),tmp715);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[7] >= 20.0 and powerBlock.LTR.T_from_comp[7] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp716 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1614
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[8] >= 20.0 and powerBlock.LTR.T_from_comp[8] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[8] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1614(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1614};
  modelica_boolean tmp717;
  modelica_boolean tmp718;
  static const MMC_DEFSTRINGLIT(tmp719,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[8] <= 873.15, has value: ");
  modelica_string tmp720;
  static int tmp721 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp721)
  {
    tmp717 = GreaterEq(data->localData[0]->realVars[118] /* powerBlock.LTR.T_from_comp[8] variable */,20.0);
    tmp718 = LessEq(data->localData[0]->realVars[118] /* powerBlock.LTR.T_from_comp[8] variable */,873.15);
    if(!(tmp717 && tmp718))
    {
      tmp720 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[118] /* powerBlock.LTR.T_from_comp[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp719),tmp720);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[8] >= 20.0 and powerBlock.LTR.T_from_comp[8] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp721 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1615
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[9] >= 20.0 and powerBlock.LTR.T_from_comp[9] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[9] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1615(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1615};
  modelica_boolean tmp722;
  modelica_boolean tmp723;
  static const MMC_DEFSTRINGLIT(tmp724,99,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[9] <= 873.15, has value: ");
  modelica_string tmp725;
  static int tmp726 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp726)
  {
    tmp722 = GreaterEq(data->localData[0]->realVars[119] /* powerBlock.LTR.T_from_comp[9] variable */,20.0);
    tmp723 = LessEq(data->localData[0]->realVars[119] /* powerBlock.LTR.T_from_comp[9] variable */,873.15);
    if(!(tmp722 && tmp723))
    {
      tmp725 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[119] /* powerBlock.LTR.T_from_comp[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp724),tmp725);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[9] >= 20.0 and powerBlock.LTR.T_from_comp[9] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp726 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1616
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[10] >= 20.0 and powerBlock.LTR.T_from_comp[10] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[10] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1616(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1616};
  modelica_boolean tmp727;
  modelica_boolean tmp728;
  static const MMC_DEFSTRINGLIT(tmp729,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[10] <= 873.15, has value: ");
  modelica_string tmp730;
  static int tmp731 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp731)
  {
    tmp727 = GreaterEq(data->localData[0]->realVars[120] /* powerBlock.LTR.T_from_comp[10] variable */,20.0);
    tmp728 = LessEq(data->localData[0]->realVars[120] /* powerBlock.LTR.T_from_comp[10] variable */,873.15);
    if(!(tmp727 && tmp728))
    {
      tmp730 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[120] /* powerBlock.LTR.T_from_comp[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp729),tmp730);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[10] >= 20.0 and powerBlock.LTR.T_from_comp[10] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp731 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1617
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[11] >= 20.0 and powerBlock.LTR.T_from_comp[11] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[11] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1617(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1617};
  modelica_boolean tmp732;
  modelica_boolean tmp733;
  static const MMC_DEFSTRINGLIT(tmp734,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[11] <= 873.15, has value: ");
  modelica_string tmp735;
  static int tmp736 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp736)
  {
    tmp732 = GreaterEq(data->localData[0]->realVars[121] /* powerBlock.LTR.T_from_comp[11] variable */,20.0);
    tmp733 = LessEq(data->localData[0]->realVars[121] /* powerBlock.LTR.T_from_comp[11] variable */,873.15);
    if(!(tmp732 && tmp733))
    {
      tmp735 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[121] /* powerBlock.LTR.T_from_comp[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp734),tmp735);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[11] >= 20.0 and powerBlock.LTR.T_from_comp[11] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp736 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1618
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[12] >= 20.0 and powerBlock.LTR.T_from_comp[12] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[12] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1618(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1618};
  modelica_boolean tmp737;
  modelica_boolean tmp738;
  static const MMC_DEFSTRINGLIT(tmp739,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[12] <= 873.15, has value: ");
  modelica_string tmp740;
  static int tmp741 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp741)
  {
    tmp737 = GreaterEq(data->localData[0]->realVars[122] /* powerBlock.LTR.T_from_comp[12] variable */,20.0);
    tmp738 = LessEq(data->localData[0]->realVars[122] /* powerBlock.LTR.T_from_comp[12] variable */,873.15);
    if(!(tmp737 && tmp738))
    {
      tmp740 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[122] /* powerBlock.LTR.T_from_comp[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp739),tmp740);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[12] >= 20.0 and powerBlock.LTR.T_from_comp[12] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp741 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1619
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[13] >= 20.0 and powerBlock.LTR.T_from_comp[13] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[13] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1619(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1619};
  modelica_boolean tmp742;
  modelica_boolean tmp743;
  static const MMC_DEFSTRINGLIT(tmp744,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[13] <= 873.15, has value: ");
  modelica_string tmp745;
  static int tmp746 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp746)
  {
    tmp742 = GreaterEq(data->localData[0]->realVars[123] /* powerBlock.LTR.T_from_comp[13] variable */,20.0);
    tmp743 = LessEq(data->localData[0]->realVars[123] /* powerBlock.LTR.T_from_comp[13] variable */,873.15);
    if(!(tmp742 && tmp743))
    {
      tmp745 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[123] /* powerBlock.LTR.T_from_comp[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp744),tmp745);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[13] >= 20.0 and powerBlock.LTR.T_from_comp[13] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp746 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1620
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[14] >= 20.0 and powerBlock.LTR.T_from_comp[14] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[14] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1620(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1620};
  modelica_boolean tmp747;
  modelica_boolean tmp748;
  static const MMC_DEFSTRINGLIT(tmp749,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[14] <= 873.15, has value: ");
  modelica_string tmp750;
  static int tmp751 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp751)
  {
    tmp747 = GreaterEq(data->localData[0]->realVars[124] /* powerBlock.LTR.T_from_comp[14] variable */,20.0);
    tmp748 = LessEq(data->localData[0]->realVars[124] /* powerBlock.LTR.T_from_comp[14] variable */,873.15);
    if(!(tmp747 && tmp748))
    {
      tmp750 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[124] /* powerBlock.LTR.T_from_comp[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp749),tmp750);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[14] >= 20.0 and powerBlock.LTR.T_from_comp[14] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp751 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1621
type: ALGORITHM

  assert(powerBlock.LTR.T_from_comp[15] >= 20.0 and powerBlock.LTR.T_from_comp[15] <= 873.15, "Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[15] <= 873.15, has value: " + String(powerBlock.LTR.T_from_comp[15], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1621(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1621};
  modelica_boolean tmp752;
  modelica_boolean tmp753;
  static const MMC_DEFSTRINGLIT(tmp754,100,"Variable violating min/max constraint: 20.0 <= powerBlock.LTR.T_from_comp[15] <= 873.15, has value: ");
  modelica_string tmp755;
  static int tmp756 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp756)
  {
    tmp752 = GreaterEq(data->localData[0]->realVars[125] /* powerBlock.LTR.T_from_comp[15] variable */,20.0);
    tmp753 = LessEq(data->localData[0]->realVars[125] /* powerBlock.LTR.T_from_comp[15] variable */,873.15);
    if(!(tmp752 && tmp753))
    {
      tmp755 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[125] /* powerBlock.LTR.T_from_comp[15] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp754),tmp755);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",504,4,504,91,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.T_from_comp[15] >= 20.0 and powerBlock.LTR.T_from_comp[15] <= 873.15", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp756 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1622
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[1] >= -10000000000.0 and powerBlock.LTR.h_from_comp[1] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[1] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[1], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1622(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1622};
  modelica_boolean tmp757;
  modelica_boolean tmp758;
  static const MMC_DEFSTRINGLIT(tmp759,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[1] <= 10000000000.0, has value: ");
  modelica_string tmp760;
  static int tmp761 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp761)
  {
    tmp757 = GreaterEq(data->localData[0]->realVars[156] /* powerBlock.LTR.h_from_comp[1] variable */,-10000000000.0);
    tmp758 = LessEq(data->localData[0]->realVars[156] /* powerBlock.LTR.h_from_comp[1] variable */,10000000000.0);
    if(!(tmp757 && tmp758))
    {
      tmp760 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[156] /* powerBlock.LTR.h_from_comp[1] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp759),tmp760);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[1] >= -10000000000.0 and powerBlock.LTR.h_from_comp[1] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp761 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1623
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[2] >= -10000000000.0 and powerBlock.LTR.h_from_comp[2] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[2] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[2], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1623(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1623};
  modelica_boolean tmp762;
  modelica_boolean tmp763;
  static const MMC_DEFSTRINGLIT(tmp764,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[2] <= 10000000000.0, has value: ");
  modelica_string tmp765;
  static int tmp766 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp766)
  {
    tmp762 = GreaterEq(data->localData[0]->realVars[157] /* powerBlock.LTR.h_from_comp[2] variable */,-10000000000.0);
    tmp763 = LessEq(data->localData[0]->realVars[157] /* powerBlock.LTR.h_from_comp[2] variable */,10000000000.0);
    if(!(tmp762 && tmp763))
    {
      tmp765 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[157] /* powerBlock.LTR.h_from_comp[2] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp764),tmp765);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[2] >= -10000000000.0 and powerBlock.LTR.h_from_comp[2] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp766 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1624
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[3] >= -10000000000.0 and powerBlock.LTR.h_from_comp[3] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[3] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[3], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1624(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1624};
  modelica_boolean tmp767;
  modelica_boolean tmp768;
  static const MMC_DEFSTRINGLIT(tmp769,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[3] <= 10000000000.0, has value: ");
  modelica_string tmp770;
  static int tmp771 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp771)
  {
    tmp767 = GreaterEq(data->localData[0]->realVars[158] /* powerBlock.LTR.h_from_comp[3] variable */,-10000000000.0);
    tmp768 = LessEq(data->localData[0]->realVars[158] /* powerBlock.LTR.h_from_comp[3] variable */,10000000000.0);
    if(!(tmp767 && tmp768))
    {
      tmp770 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[158] /* powerBlock.LTR.h_from_comp[3] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp769),tmp770);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[3] >= -10000000000.0 and powerBlock.LTR.h_from_comp[3] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp771 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1625
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[4] >= -10000000000.0 and powerBlock.LTR.h_from_comp[4] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[4] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[4], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1625(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1625};
  modelica_boolean tmp772;
  modelica_boolean tmp773;
  static const MMC_DEFSTRINGLIT(tmp774,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[4] <= 10000000000.0, has value: ");
  modelica_string tmp775;
  static int tmp776 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp776)
  {
    tmp772 = GreaterEq(data->localData[0]->realVars[159] /* powerBlock.LTR.h_from_comp[4] variable */,-10000000000.0);
    tmp773 = LessEq(data->localData[0]->realVars[159] /* powerBlock.LTR.h_from_comp[4] variable */,10000000000.0);
    if(!(tmp772 && tmp773))
    {
      tmp775 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[159] /* powerBlock.LTR.h_from_comp[4] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp774),tmp775);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[4] >= -10000000000.0 and powerBlock.LTR.h_from_comp[4] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp776 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1626
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[5] >= -10000000000.0 and powerBlock.LTR.h_from_comp[5] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[5] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[5], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1626(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1626};
  modelica_boolean tmp777;
  modelica_boolean tmp778;
  static const MMC_DEFSTRINGLIT(tmp779,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[5] <= 10000000000.0, has value: ");
  modelica_string tmp780;
  static int tmp781 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp781)
  {
    tmp777 = GreaterEq(data->localData[0]->realVars[160] /* powerBlock.LTR.h_from_comp[5] variable */,-10000000000.0);
    tmp778 = LessEq(data->localData[0]->realVars[160] /* powerBlock.LTR.h_from_comp[5] variable */,10000000000.0);
    if(!(tmp777 && tmp778))
    {
      tmp780 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[160] /* powerBlock.LTR.h_from_comp[5] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp779),tmp780);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[5] >= -10000000000.0 and powerBlock.LTR.h_from_comp[5] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp781 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1627
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[6] >= -10000000000.0 and powerBlock.LTR.h_from_comp[6] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[6] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[6], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1627(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1627};
  modelica_boolean tmp782;
  modelica_boolean tmp783;
  static const MMC_DEFSTRINGLIT(tmp784,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[6] <= 10000000000.0, has value: ");
  modelica_string tmp785;
  static int tmp786 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp786)
  {
    tmp782 = GreaterEq(data->localData[0]->realVars[161] /* powerBlock.LTR.h_from_comp[6] variable */,-10000000000.0);
    tmp783 = LessEq(data->localData[0]->realVars[161] /* powerBlock.LTR.h_from_comp[6] variable */,10000000000.0);
    if(!(tmp782 && tmp783))
    {
      tmp785 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[161] /* powerBlock.LTR.h_from_comp[6] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp784),tmp785);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[6] >= -10000000000.0 and powerBlock.LTR.h_from_comp[6] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp786 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1628
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[7] >= -10000000000.0 and powerBlock.LTR.h_from_comp[7] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[7] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[7], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1628(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1628};
  modelica_boolean tmp787;
  modelica_boolean tmp788;
  static const MMC_DEFSTRINGLIT(tmp789,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[7] <= 10000000000.0, has value: ");
  modelica_string tmp790;
  static int tmp791 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp791)
  {
    tmp787 = GreaterEq(data->localData[0]->realVars[162] /* powerBlock.LTR.h_from_comp[7] variable */,-10000000000.0);
    tmp788 = LessEq(data->localData[0]->realVars[162] /* powerBlock.LTR.h_from_comp[7] variable */,10000000000.0);
    if(!(tmp787 && tmp788))
    {
      tmp790 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[162] /* powerBlock.LTR.h_from_comp[7] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp789),tmp790);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[7] >= -10000000000.0 and powerBlock.LTR.h_from_comp[7] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp791 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1629
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[8] >= -10000000000.0 and powerBlock.LTR.h_from_comp[8] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[8] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[8], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1629(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1629};
  modelica_boolean tmp792;
  modelica_boolean tmp793;
  static const MMC_DEFSTRINGLIT(tmp794,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[8] <= 10000000000.0, has value: ");
  modelica_string tmp795;
  static int tmp796 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp796)
  {
    tmp792 = GreaterEq(data->localData[0]->realVars[163] /* powerBlock.LTR.h_from_comp[8] variable */,-10000000000.0);
    tmp793 = LessEq(data->localData[0]->realVars[163] /* powerBlock.LTR.h_from_comp[8] variable */,10000000000.0);
    if(!(tmp792 && tmp793))
    {
      tmp795 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[163] /* powerBlock.LTR.h_from_comp[8] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp794),tmp795);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[8] >= -10000000000.0 and powerBlock.LTR.h_from_comp[8] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp796 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1630
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[9] >= -10000000000.0 and powerBlock.LTR.h_from_comp[9] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[9] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[9], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1630(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1630};
  modelica_boolean tmp797;
  modelica_boolean tmp798;
  static const MMC_DEFSTRINGLIT(tmp799,116,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[9] <= 10000000000.0, has value: ");
  modelica_string tmp800;
  static int tmp801 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp801)
  {
    tmp797 = GreaterEq(data->localData[0]->realVars[164] /* powerBlock.LTR.h_from_comp[9] variable */,-10000000000.0);
    tmp798 = LessEq(data->localData[0]->realVars[164] /* powerBlock.LTR.h_from_comp[9] variable */,10000000000.0);
    if(!(tmp797 && tmp798))
    {
      tmp800 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[164] /* powerBlock.LTR.h_from_comp[9] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp799),tmp800);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[9] >= -10000000000.0 and powerBlock.LTR.h_from_comp[9] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp801 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1631
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[10] >= -10000000000.0 and powerBlock.LTR.h_from_comp[10] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[10] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[10], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1631(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1631};
  modelica_boolean tmp802;
  modelica_boolean tmp803;
  static const MMC_DEFSTRINGLIT(tmp804,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[10] <= 10000000000.0, has value: ");
  modelica_string tmp805;
  static int tmp806 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp806)
  {
    tmp802 = GreaterEq(data->localData[0]->realVars[165] /* powerBlock.LTR.h_from_comp[10] variable */,-10000000000.0);
    tmp803 = LessEq(data->localData[0]->realVars[165] /* powerBlock.LTR.h_from_comp[10] variable */,10000000000.0);
    if(!(tmp802 && tmp803))
    {
      tmp805 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[165] /* powerBlock.LTR.h_from_comp[10] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp804),tmp805);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[10] >= -10000000000.0 and powerBlock.LTR.h_from_comp[10] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp806 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1632
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[11] >= -10000000000.0 and powerBlock.LTR.h_from_comp[11] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[11] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[11], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1632(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1632};
  modelica_boolean tmp807;
  modelica_boolean tmp808;
  static const MMC_DEFSTRINGLIT(tmp809,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[11] <= 10000000000.0, has value: ");
  modelica_string tmp810;
  static int tmp811 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp811)
  {
    tmp807 = GreaterEq(data->localData[0]->realVars[166] /* powerBlock.LTR.h_from_comp[11] variable */,-10000000000.0);
    tmp808 = LessEq(data->localData[0]->realVars[166] /* powerBlock.LTR.h_from_comp[11] variable */,10000000000.0);
    if(!(tmp807 && tmp808))
    {
      tmp810 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[166] /* powerBlock.LTR.h_from_comp[11] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp809),tmp810);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[11] >= -10000000000.0 and powerBlock.LTR.h_from_comp[11] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp811 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1633
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[12] >= -10000000000.0 and powerBlock.LTR.h_from_comp[12] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[12] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[12], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1633(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1633};
  modelica_boolean tmp812;
  modelica_boolean tmp813;
  static const MMC_DEFSTRINGLIT(tmp814,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[12] <= 10000000000.0, has value: ");
  modelica_string tmp815;
  static int tmp816 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp816)
  {
    tmp812 = GreaterEq(data->localData[0]->realVars[167] /* powerBlock.LTR.h_from_comp[12] variable */,-10000000000.0);
    tmp813 = LessEq(data->localData[0]->realVars[167] /* powerBlock.LTR.h_from_comp[12] variable */,10000000000.0);
    if(!(tmp812 && tmp813))
    {
      tmp815 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[167] /* powerBlock.LTR.h_from_comp[12] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp814),tmp815);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[12] >= -10000000000.0 and powerBlock.LTR.h_from_comp[12] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp816 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1634
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[13] >= -10000000000.0 and powerBlock.LTR.h_from_comp[13] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[13] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[13], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1634(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1634};
  modelica_boolean tmp817;
  modelica_boolean tmp818;
  static const MMC_DEFSTRINGLIT(tmp819,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[13] <= 10000000000.0, has value: ");
  modelica_string tmp820;
  static int tmp821 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp821)
  {
    tmp817 = GreaterEq(data->localData[0]->realVars[168] /* powerBlock.LTR.h_from_comp[13] variable */,-10000000000.0);
    tmp818 = LessEq(data->localData[0]->realVars[168] /* powerBlock.LTR.h_from_comp[13] variable */,10000000000.0);
    if(!(tmp817 && tmp818))
    {
      tmp820 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[168] /* powerBlock.LTR.h_from_comp[13] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp819),tmp820);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[13] >= -10000000000.0 and powerBlock.LTR.h_from_comp[13] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp821 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1635
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[14] >= -10000000000.0 and powerBlock.LTR.h_from_comp[14] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[14] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[14], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1635(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1635};
  modelica_boolean tmp822;
  modelica_boolean tmp823;
  static const MMC_DEFSTRINGLIT(tmp824,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[14] <= 10000000000.0, has value: ");
  modelica_string tmp825;
  static int tmp826 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp826)
  {
    tmp822 = GreaterEq(data->localData[0]->realVars[169] /* powerBlock.LTR.h_from_comp[14] variable */,-10000000000.0);
    tmp823 = LessEq(data->localData[0]->realVars[169] /* powerBlock.LTR.h_from_comp[14] variable */,10000000000.0);
    if(!(tmp822 && tmp823))
    {
      tmp825 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[169] /* powerBlock.LTR.h_from_comp[14] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp824),tmp825);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[14] >= -10000000000.0 and powerBlock.LTR.h_from_comp[14] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp826 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1636
type: ALGORITHM

  assert(powerBlock.LTR.h_from_comp[15] >= -10000000000.0 and powerBlock.LTR.h_from_comp[15] <= 10000000000.0, "Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[15] <= 10000000000.0, has value: " + String(powerBlock.LTR.h_from_comp[15], "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1636(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1636};
  modelica_boolean tmp827;
  modelica_boolean tmp828;
  static const MMC_DEFSTRINGLIT(tmp829,117,"Variable violating min/max constraint: -10000000000.0 <= powerBlock.LTR.h_from_comp[15] <= 10000000000.0, has value: ");
  modelica_string tmp830;
  static int tmp831 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp831)
  {
    tmp827 = GreaterEq(data->localData[0]->realVars[170] /* powerBlock.LTR.h_from_comp[15] variable */,-10000000000.0);
    tmp828 = LessEq(data->localData[0]->realVars[170] /* powerBlock.LTR.h_from_comp[15] variable */,10000000000.0);
    if(!(tmp827 && tmp828))
    {
      tmp830 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[170] /* powerBlock.LTR.h_from_comp[15] variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp829),tmp830);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",506,4,506,112,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.h_from_comp[15] >= -10000000000.0 and powerBlock.LTR.h_from_comp[15] <= 10000000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp831 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1637
type: ALGORITHM

  assert(powerBlock.LTR.state_from_turb[15].p >= 0.0 and powerBlock.LTR.state_from_turb[15].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.LTR.state_from_turb[15].p <= 100000000.0, has value: " + String(powerBlock.LTR.state_from_turb[15].p, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1637(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1637};
  modelica_boolean tmp832;
  modelica_boolean tmp833;
  static const MMC_DEFSTRINGLIT(tmp834,110,"Variable violating min/max constraint: 0.0 <= powerBlock.LTR.state_from_turb[15].p <= 100000000.0, has value: ");
  modelica_string tmp835;
  static int tmp836 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp836)
  {
    tmp832 = GreaterEq(data->localData[0]->realVars[187] /* powerBlock.LTR.state_from_turb[15].p variable */,0.0);
    tmp833 = LessEq(data->localData[0]->realVars[187] /* powerBlock.LTR.state_from_turb[15].p variable */,100000000.0);
    if(!(tmp832 && tmp833))
    {
      tmp835 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[187] /* powerBlock.LTR.state_from_turb[15].p variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp834),tmp835);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.state_from_turb[15].p >= 0.0 and powerBlock.LTR.state_from_turb[15].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp836 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1638
type: ALGORITHM

  assert(powerBlock.LTR.state_from_comp[15].p >= 0.0 and powerBlock.LTR.state_from_comp[15].p <= 100000000.0, "Variable violating min/max constraint: 0.0 <= powerBlock.LTR.state_from_comp[15].p <= 100000000.0, has value: " + String(powerBlock.LTR.state_from_comp[15].p, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1638(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1638};
  modelica_boolean tmp837;
  modelica_boolean tmp838;
  static const MMC_DEFSTRINGLIT(tmp839,110,"Variable violating min/max constraint: 0.0 <= powerBlock.LTR.state_from_comp[15].p <= 100000000.0, has value: ");
  modelica_string tmp840;
  static int tmp841 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp841)
  {
    tmp837 = GreaterEq(data->localData[0]->realVars[186] /* powerBlock.LTR.state_from_comp[15].p variable */,0.0);
    tmp838 = LessEq(data->localData[0]->realVars[186] /* powerBlock.LTR.state_from_comp[15].p variable */,100000000.0);
    if(!(tmp837 && tmp838))
    {
      tmp840 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[186] /* powerBlock.LTR.state_from_comp[15].p variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp839),tmp840);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Media/CO2/CO2_ph.mo",89,7,89,55,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.LTR.state_from_comp[15].p >= 0.0 and powerBlock.LTR.state_from_comp[15].p <= 100000000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp841 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1639
type: ALGORITHM

  assert(powerBlock.splitter.gamma_port_b.m_flow >= -100000.0 and powerBlock.splitter.gamma_port_b.m_flow <= 100000.0, "Variable violating min/max constraint: -100000.0 <= powerBlock.splitter.gamma_port_b.m_flow <= 100000.0, has value: " + String(powerBlock.splitter.gamma_port_b.m_flow, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1639(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1639};
  modelica_boolean tmp842;
  modelica_boolean tmp843;
  static const MMC_DEFSTRINGLIT(tmp844,116,"Variable violating min/max constraint: -100000.0 <= powerBlock.splitter.gamma_port_b.m_flow <= 100000.0, has value: ");
  modelica_string tmp845;
  static int tmp846 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp846)
  {
    tmp842 = GreaterEq(data->localData[0]->realVars[273] /* powerBlock.splitter.gamma_port_b.m_flow variable */,-100000.0);
    tmp843 = LessEq(data->localData[0]->realVars[273] /* powerBlock.splitter.gamma_port_b.m_flow variable */,100000.0);
    if(!(tmp842 && tmp843))
    {
      tmp845 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[273] /* powerBlock.splitter.gamma_port_b.m_flow variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp844),tmp845);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Interfaces.mo",13,5,14,68,1};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.splitter.gamma_port_b.m_flow >= -100000.0 and powerBlock.splitter.gamma_port_b.m_flow <= 100000.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp846 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1640
type: ALGORITHM

  assert(powerBlock.eta_cycle >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.eta_cycle, has value: " + String(powerBlock.eta_cycle, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1640(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1640};
  modelica_boolean tmp847;
  static const MMC_DEFSTRINGLIT(tmp848,75,"Variable violating min constraint: 0.0 <= powerBlock.eta_cycle, has value: ");
  modelica_string tmp849;
  static int tmp850 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp850)
  {
    tmp847 = GreaterEq(data->localData[0]->realVars[198] /* powerBlock.eta_cycle variable */,0.0);
    if(!tmp847)
    {
      tmp849 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[198] /* powerBlock.eta_cycle variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp848),tmp849);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2080,7,2080,30,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.eta_cycle >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp850 = 1;
    }
  }
  TRACE_POP
}

/*
equation index: 1641
type: ALGORITHM

  assert(powerBlock.eta_cycle_net >= 0.0, "Variable violating min constraint: 0.0 <= powerBlock.eta_cycle_net, has value: " + String(powerBlock.eta_cycle_net, "g"));
*/
void sCO2PBCalculator_Using_JPidea_eqFunction_1641(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,1641};
  modelica_boolean tmp851;
  static const MMC_DEFSTRINGLIT(tmp852,79,"Variable violating min constraint: 0.0 <= powerBlock.eta_cycle_net, has value: ");
  modelica_string tmp853;
  static int tmp854 = 0;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  if(!tmp854)
  {
    tmp851 = GreaterEq(data->localData[0]->realVars[199] /* powerBlock.eta_cycle_net variable */,0.0);
    if(!tmp851)
    {
      tmp853 = modelica_real_to_modelica_string_format(data->localData[0]->realVars[199] /* powerBlock.eta_cycle_net variable */, (modelica_string) mmc_strings_len1[103]);
      tmpMeta[0] = stringAppend(MMC_REFSTRINGLIT(tmp852),tmp853);
      {
        FILE_INFO info = {"/home/philgun/.local/lib/omlibrary/SolarTherm/Models/PowerBlocks/sCO2Cycle/DirectDesign.mo",2081,7,2081,34,0};
        omc_assert_warning(info, "The following assertion has been violated %sat time %f\npowerBlock.eta_cycle_net >= 0.0", initial() ? "during initialization " : "", data->localData[0]->timeValue);
        omc_assert_warning_withEquationIndexes(info, equationIndexes, MMC_STRINGDATA(tmpMeta[0]));
      }
      tmp854 = 1;
    }
  }
  TRACE_POP
}
/* function to check assert after a step is done */
OMC_DISABLE_OPT
int sCO2PBCalculator_Using_JPidea_checkForAsserts(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  sCO2PBCalculator_Using_JPidea_eqFunction_1468(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1469(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1470(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1471(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1472(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1473(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1474(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1475(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1476(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1477(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1478(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1479(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1480(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1481(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1482(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1483(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1484(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1485(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1486(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1487(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1488(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1489(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1490(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1491(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1492(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1493(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1494(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1495(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1496(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1497(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1498(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1499(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1500(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1501(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1502(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1503(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1504(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1505(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1506(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1507(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1508(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1509(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1510(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1511(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1512(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1513(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1514(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1515(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1516(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1517(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1518(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1519(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1520(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1521(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1522(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1523(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1524(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1525(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1526(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1527(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1528(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1529(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1530(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1531(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1532(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1533(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1534(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1535(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1536(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1537(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1538(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1539(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1540(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1541(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1542(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1543(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1544(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1545(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1546(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1547(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1548(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1549(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1550(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1551(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1552(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1553(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1554(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1555(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1556(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1557(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1558(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1559(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1560(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1561(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1562(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1563(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1564(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1565(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1566(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1567(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1568(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1569(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1570(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1571(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1572(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1573(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1574(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1575(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1576(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1577(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1578(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1579(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1580(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1581(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1582(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1583(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1584(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1585(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1586(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1587(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1588(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1589(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1590(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1591(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1592(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1593(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1594(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1595(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1596(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1597(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1598(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1599(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1600(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1601(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1602(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1603(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1604(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1605(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1606(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1607(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1608(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1609(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1610(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1611(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1612(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1613(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1614(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1615(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1616(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1617(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1618(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1619(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1620(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1621(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1622(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1623(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1624(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1625(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1626(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1627(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1628(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1629(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1630(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1631(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1632(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1633(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1634(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1635(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1636(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1637(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1638(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1639(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1640(data, threadData);

  sCO2PBCalculator_Using_JPidea_eqFunction_1641(data, threadData);
  
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

