#include "omc_simulation_settings.h"
#include "sCO2PBCalculator_Using_JPidea_functions.h"
#ifdef __cplusplus
extern "C" {
#endif

#include "sCO2PBCalculator_Using_JPidea_includes.h"


modelica_complex omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData_t *threadData, modelica_string _tableName, modelica_string _fileName, real_array _table, modelica_integer _smoothness)
{
  int _smoothness_ext;
  void *_table_c89;
  void * _externalCombiTable2D_ext;
  modelica_complex _externalCombiTable2D;
  // _externalCombiTable2D has no default value.
  _smoothness_ext = (int)_smoothness;
  _table_c89 = (void*) data_of_real_c89_array(&(_table));
  _externalCombiTable2D_ext = ModelicaStandardTables_CombiTable2D_init(MMC_STRINGDATA(_tableName), MMC_STRINGDATA(_fileName), (const double*) _table_c89, size_of_dimension_base_array(_table, ((modelica_integer) 1)), size_of_dimension_base_array(_table, ((modelica_integer) 2)), _smoothness_ext);
  _externalCombiTable2D = (modelica_complex)_externalCombiTable2D_ext;
  return _externalCombiTable2D;
}
modelica_metatype boxptr_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData_t *threadData, modelica_metatype _tableName, modelica_metatype _fileName, modelica_metatype _table, modelica_metatype _smoothness)
{
  modelica_integer tmp1;
  modelica_complex _externalCombiTable2D;
  tmp1 = mmc_unbox_integer(_smoothness);
  _externalCombiTable2D = omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _tableName, _fileName, *((base_array_t*)_table), tmp1);
  /* skip box _externalCombiTable2D; ExternalObject Modelica.Blocks.Types.ExternalCombiTable2D */
  return _externalCombiTable2D;
}

void omc_Modelica_Blocks_Types_ExternalCombiTable2D_destructor(threadData_t *threadData, modelica_complex _externalCombiTable2D)
{
  void * _externalCombiTable2D_ext;
  _externalCombiTable2D_ext = (void *)_externalCombiTable2D;
  ModelicaStandardTables_CombiTable2D_close(_externalCombiTable2D_ext);
  return;
}
void boxptr_Modelica_Blocks_Types_ExternalCombiTable2D_destructor(threadData_t *threadData, modelica_metatype _externalCombiTable2D)
{
  omc_Modelica_Blocks_Types_ExternalCombiTable2D_destructor(threadData, _externalCombiTable2D);
  return;
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61246C69667453696D706C6524666C7569645F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61246C69667453696D706C6524666C7569645F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61246C69667453696D706C6524666C7569645F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61246C69667453696D706C6524666C7569645F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61246C69667453696D706C6524666C7569645F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24636F6F6C657224706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24636F6F6C657224706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24636F6F6C657224706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24636F6F6C657224706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24636F6F6C657224706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24666C7569645F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24666C7569645F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24666C7569645F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24666C7569645F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B24666C7569645F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D697865722466697273745F5F706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D697865722466697273745F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D697865722466697273745F5F706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D697865722466697273745F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D697865722466697273745F5F706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D69786572247365636F6E645F5F706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D69786572247365636F6E645F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D69786572247365636F6E645F5F706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D69786572247365636F6E645F5F706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B246D69786572247365636F6E645F5F706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2473706C697474657224706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2473706C697474657224706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2473706C697474657224706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2473706C697474657224706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2473706C697474657224706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2474757262696E6524706F72745F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2474757262696E6524706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2474757262696E6524706F72745F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2474757262696E6524706F72745F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6124706F776572426C6F636B2474757262696E6524706F72745F5F61_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62246C69667453696D706C6524666C7569645F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62246C69667453696D706C6524666C7569645F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62246C69667453696D706C6524666C7569645F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62246C69667453696D706C6524666C7569645F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62246C69667453696D706C6524666C7569645F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244854522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F636F6D705F5F706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B244C54522466726F6D5F5F747572625F5F706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24636F6F6C657224706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24636F6F6C657224706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24636F6F6C657224706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24636F6F6C657224706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24636F6F6C657224706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E67657224434F325F5F706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2465786368616E676572244854465F5F706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24666C7569645F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24666C7569645F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24666C7569645F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24666C7569645F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B24666C7569645F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D61696E436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D6978657224706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D6978657224706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D6978657224706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D6978657224706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B246D6978657224706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B247265436F6D70726573736F7224706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C69747465722467616D6D615F5F706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C69747465722467616D6D615F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C69747465722467616D6D615F5F706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C69747465722467616D6D615F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C69747465722467616D6D615F5F706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C6974746572246F6E655F5F67616D6D615F5F706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C6974746572246F6E655F5F67616D6D615F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C6974746572246F6E655F5F67616D6D615F5F706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C6974746572246F6E655F5F67616D6D615F5F706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2473706C6974746572246F6E655F5F67616D6D615F5F706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2474757262696E6524706F72745F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2474757262696E6524706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2474757262696E6524706F72745F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2474757262696E6524706F72745F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F6224706F776572426C6F636B2474757262696E6524706F72745F5F62_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F622473696E6B24706F727473_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F622473696E6B24706F727473_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F622473696E6B24706F727473_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F622473696E6B24706F727473_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F622473696E6B24706F727473_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F6224736F7572636524706F727473_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F6224736F7572636524706F727473_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F6224736F7572636524706F727473_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F6224736F7572636524706F727473_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F7274735F5F6224736F7572636524706F727473_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Sources__omcQuot_4669786564426F756E646172792473696E6B_Medium_ThermodynamicState omc_Modelica_Fluid_Sources__omcQuot_4669786564426F756E646172792473696E6B_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Sources__omcQuot_4669786564426F756E646172792473696E6B_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Sources__omcQuot_4669786564426F756E646172792473696E6B_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Sources__omcQuot_4669786564426F756E646172792473696E6B_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Sources__omcQuot_4669786564426F756E6461727924736F75726365_Medium_ThermodynamicState omc_Modelica_Fluid_Sources__omcQuot_4669786564426F756E6461727924736F75726365_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Sources__omcQuot_4669786564426F756E6461727924736F75726365_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Sources__omcQuot_4669786564426F756E6461727924736F75726365_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Sources__omcQuot_4669786564426F756E6461727924736F75726365_Medium_ThermodynamicState__desc, _p, _h);
}

DLLExport
void omc_Modelica_Fluid_Utilities_checkBoundary(threadData_t *threadData, modelica_string _mediumName, string_array _substanceNames, modelica_boolean _singleState, modelica_boolean _define_p, real_array _X_boundary, modelica_string _modelName)
{
  modelica_string _X_str = NULL;
  modelica_integer _nX;
  modelica_integer tmp1;
  static int tmp2 = 0;
  modelica_string tmp3;
  modelica_string tmp4;
  static int tmp5 = 0;
  modelica_integer tmp6;
  modelica_integer tmp7;
  modelica_integer tmp8;
  modelica_string tmp9;
  modelica_string tmp10;
  modelica_integer tmp11;
  modelica_integer tmp12;
  modelica_integer tmp13;
  modelica_string tmp14;
  modelica_metatype tmpMeta[8] __attribute__((unused)) = {0};
  _tailrecursive: OMC_LABEL_UNUSED
  // _X_str has no default value.
  tmp1 = size_of_dimension_base_array(_X_boundary, ((modelica_integer) 1));
  _nX = tmp1;
  {
    if(!((!_singleState) || (_singleState && _define_p)))
    {
      tmpMeta[0] = stringAppend(_OMC_LIT5,_modelName);
      tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT6);
      tmpMeta[2] = stringAppend(tmpMeta[1],_mediumName);
      tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT7);
      {
        FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Utilities.mo",18,5,23,3,1};
        omc_assert(threadData, info, MMC_STRINGDATA(tmpMeta[3]));
      }
    }
  }

  tmp6 = ((modelica_integer) 1); tmp7 = 1; tmp8 = _nX;
  if(!(((tmp7 > 0) && (tmp6 > tmp8)) || ((tmp7 < 0) && (tmp6 < tmp8))))
  {
    modelica_integer _i;
    for(_i = ((modelica_integer) 1); in_range_integer(_i, tmp6, tmp8); _i += tmp7)
    {
      {
        if(!((*real_array_element_addr1(&_X_boundary, 1, _i)) >= 0.0))
        {
          tmpMeta[0] = stringAppend(_OMC_LIT8,_mediumName);
          tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT9);
          tmpMeta[2] = stringAppend(tmpMeta[1],_modelName);
          tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT10);
          tmp3 = modelica_integer_to_modelica_string(_i, ((modelica_integer) 0), 1);
          tmpMeta[4] = stringAppend(tmpMeta[3],tmp3);
          tmpMeta[5] = stringAppend(tmpMeta[4],_OMC_LIT11);
          tmp4 = modelica_real_to_modelica_string((*real_array_element_addr1(&_X_boundary, 1, _i)), ((modelica_integer) 6), ((modelica_integer) 0), 1);
          tmpMeta[6] = stringAppend(tmpMeta[5],tmp4);
          tmpMeta[7] = stringAppend(tmpMeta[6],_OMC_LIT12);
          {
            FILE_INFO info = {"/usr/lib/omlibrary/Modelica 3.2.2/Fluid/Utilities.mo",26,7,33,3,1};
            omc_assert(threadData, info, MMC_STRINGDATA(tmpMeta[7]));
          }
        }
      }
    }
  }

  if(((_nX > ((modelica_integer) 0)) && (fabs(-1.0 + sum_real_array(_X_boundary)) > 1e-10)))
  {
    _X_str = _OMC_LIT13;

    tmp11 = ((modelica_integer) 1); tmp12 = 1; tmp13 = _nX;
    if(!(((tmp12 > 0) && (tmp11 > tmp13)) || ((tmp12 < 0) && (tmp11 < tmp13))))
    {
      modelica_integer _i;
      for(_i = ((modelica_integer) 1); in_range_integer(_i, tmp11, tmp13); _i += tmp12)
      {
        tmpMeta[0] = stringAppend(_X_str,_OMC_LIT14);
        tmp9 = modelica_integer_to_modelica_string(_i, ((modelica_integer) 0), 1);
        tmpMeta[1] = stringAppend(tmpMeta[0],tmp9);
        tmpMeta[2] = stringAppend(tmpMeta[1],_OMC_LIT15);
        tmp10 = modelica_real_to_modelica_string((*real_array_element_addr1(&_X_boundary, 1, _i)), ((modelica_integer) 6), ((modelica_integer) 0), 1);
        tmpMeta[3] = stringAppend(tmpMeta[2],tmp10);
        tmpMeta[4] = stringAppend(tmpMeta[3],_OMC_LIT16);
        tmpMeta[5] = stringAppend(tmpMeta[4],(*string_array_element_addr1(&_substanceNames, 1, _i)));
        tmpMeta[6] = stringAppend(tmpMeta[5],_OMC_LIT17);
        _X_str = tmpMeta[6];
      }
    }

    tmpMeta[0] = stringAppend(_OMC_LIT18,_mediumName);
    tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT9);
    tmpMeta[2] = stringAppend(tmpMeta[1],_modelName);
    tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT17);
    tmpMeta[4] = stringAppend(tmpMeta[3],_OMC_LIT19);
    tmp14 = modelica_real_to_modelica_string(sum_real_array(_X_boundary), ((modelica_integer) 6), ((modelica_integer) 0), 1);
    tmpMeta[5] = stringAppend(tmpMeta[4],tmp14);
    tmpMeta[6] = stringAppend(tmpMeta[5],_OMC_LIT20);
    tmpMeta[7] = stringAppend(tmpMeta[6],_X_str);
    omc_Modelica_Utilities_Streams_error(threadData, tmpMeta[7]);
  }
  _return: OMC_LABEL_UNUSED
  return;
}
void boxptr_Modelica_Fluid_Utilities_checkBoundary(threadData_t *threadData, modelica_metatype _mediumName, modelica_metatype _substanceNames, modelica_metatype _singleState, modelica_metatype _define_p, modelica_metatype _X_boundary, modelica_metatype _modelName)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  tmp1 = mmc_unbox_integer(_singleState);
  tmp2 = mmc_unbox_integer(_define_p);
  omc_Modelica_Fluid_Utilities_checkBoundary(threadData, _mediumName, *((base_array_t*)_substanceNames), tmp1, tmp2, *((base_array_t*)_X_boundary), _modelName);
  return;
}

void omc_Modelica_Utilities_Streams_error(threadData_t *threadData, modelica_string _string)
{
  ModelicaError(MMC_STRINGDATA(_string));
  return;
}

modelica_real omc_SolarTherm_Media_CO2_CO2__utilities_T__p__h(threadData_t *threadData, modelica_real _p, modelica_real _h, modelica_complex _tableID)
{
  void * _tableID_ext;
  double _h_ext;
  double _p_ext;
  double _T_ext;
  modelica_real _T;
  // _T has no default value.
  _tableID_ext = (void *)_tableID;

  _h_ext = (double)_h;

  _p_ext = (double)_p;
  _T_ext = ModelicaStandardTables_CombiTable2D_getValue(_tableID_ext, _h_ext, _p_ext);
  _T = (modelica_real)_T_ext;
  return _T;
}
modelica_metatype boxptr_SolarTherm_Media_CO2_CO2__utilities_T__p__h(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h, modelica_metatype _tableID)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real _T;
  modelica_metatype out_T;
  tmp1 = mmc_unbox_real(_p);
  tmp2 = mmc_unbox_real(_h);
  _T = omc_SolarTherm_Media_CO2_CO2__utilities_T__p__h(threadData, tmp1, tmp2, _tableID);
  out_T = mmc_mk_rcon(_T);
  return out_T;
}

modelica_real omc_SolarTherm_Media_CO2_CO2__utilities_h__p__T(threadData_t *threadData, modelica_real _p, modelica_real _T, modelica_complex _tableID)
{
  void * _tableID_ext;
  double _T_ext;
  double _p_ext;
  double _h_ext;
  modelica_real _h;
  // _h has no default value.
  _tableID_ext = (void *)_tableID;

  _T_ext = (double)_T;

  _p_ext = (double)_p;
  _h_ext = ModelicaStandardTables_CombiTable2D_getValue(_tableID_ext, _T_ext, _p_ext);
  _h = (modelica_real)_h_ext;
  return _h;
}
modelica_metatype boxptr_SolarTherm_Media_CO2_CO2__utilities_h__p__T(threadData_t *threadData, modelica_metatype _p, modelica_metatype _T, modelica_metatype _tableID)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real _h;
  modelica_metatype out_h;
  tmp1 = mmc_unbox_real(_p);
  tmp2 = mmc_unbox_real(_T);
  _h = omc_SolarTherm_Media_CO2_CO2__utilities_h__p__T(threadData, tmp1, tmp2, _tableID);
  out_h = mmc_mk_rcon(_h);
  return out_h;
}

modelica_real omc_SolarTherm_Media_CO2_CO2__utilities_h__p__s(threadData_t *threadData, modelica_real _p, modelica_real _s, modelica_complex _tableID)
{
  void * _tableID_ext;
  double _s_ext;
  double _p_ext;
  double _h_ext;
  modelica_real _h;
  // _h has no default value.
  _tableID_ext = (void *)_tableID;

  _s_ext = (double)_s;

  _p_ext = (double)_p;
  _h_ext = ModelicaStandardTables_CombiTable2D_getValue(_tableID_ext, _s_ext, _p_ext);
  _h = (modelica_real)_h_ext;
  return _h;
}
modelica_metatype boxptr_SolarTherm_Media_CO2_CO2__utilities_h__p__s(threadData_t *threadData, modelica_metatype _p, modelica_metatype _s, modelica_metatype _tableID)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real _h;
  modelica_metatype out_h;
  tmp1 = mmc_unbox_real(_p);
  tmp2 = mmc_unbox_real(_s);
  _h = omc_SolarTherm_Media_CO2_CO2__utilities_h__p__s(threadData, tmp1, tmp2, _tableID);
  out_h = mmc_mk_rcon(_h);
  return out_h;
}

modelica_real omc_SolarTherm_Media_CO2_CO2__utilities_rho__p__h(threadData_t *threadData, modelica_real _p, modelica_real _h, modelica_complex _tableID)
{
  void * _tableID_ext;
  double _h_ext;
  double _p_ext;
  double _rho_ext;
  modelica_real _rho;
  // _rho has no default value.
  _tableID_ext = (void *)_tableID;

  _h_ext = (double)_h;

  _p_ext = (double)_p;
  _rho_ext = ModelicaStandardTables_CombiTable2D_getValue(_tableID_ext, _h_ext, _p_ext);
  _rho = (modelica_real)_rho_ext;
  return _rho;
}
modelica_metatype boxptr_SolarTherm_Media_CO2_CO2__utilities_rho__p__h(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h, modelica_metatype _tableID)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real _rho;
  modelica_metatype out_rho;
  tmp1 = mmc_unbox_real(_p);
  tmp2 = mmc_unbox_real(_h);
  _rho = omc_SolarTherm_Media_CO2_CO2__utilities_rho__p__h(threadData, tmp1, tmp2, _tableID);
  out_rho = mmc_mk_rcon(_rho);
  return out_rho;
}

modelica_real omc_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData_t *threadData, modelica_real _p, modelica_real _h, modelica_complex _tableID)
{
  void * _tableID_ext;
  double _h_ext;
  double _p_ext;
  double _s_ext;
  modelica_real _s;
  // _s has no default value.
  _tableID_ext = (void *)_tableID;

  _h_ext = (double)_h;

  _p_ext = (double)_p;
  _s_ext = ModelicaStandardTables_CombiTable2D_getValue(_tableID_ext, _h_ext, _p_ext);
  _s = (modelica_real)_s_ext;
  return _s;
}
modelica_metatype boxptr_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h, modelica_metatype _tableID)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real _s;
  modelica_metatype out_s;
  tmp1 = mmc_unbox_real(_p);
  tmp2 = mmc_unbox_real(_h);
  _s = omc_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData, tmp1, tmp2, _tableID);
  out_s = mmc_mk_rcon(_s);
  return out_s;
}

DLLExport
modelica_real omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData_t *threadData, modelica_real _h)
{
  modelica_real _T;
  modelica_real _a;
  modelica_real _b;
  modelica_real _c;
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_real tmp5;
  modelica_real tmp6;
  modelica_real tmp7;
  _tailrecursive: OMC_LABEL_UNUSED
  // _T has no default value.
  _a = 148.2;
  _b = 0.3093;
  _c = -196601.368854;
  if((_h < -196601.368854))
  {
    _T = 0.0;
  }
  else
  {
    tmp1 = (0.008834682860998651) * (196601.368854 + _h);
    tmp2 = 0.7637668983426259;
    if(tmp1 < 0.0 && tmp2 != 0.0)
    {
      tmp4 = modf(tmp2, &tmp5);
      
      if(tmp4 > 0.5)
      {
        tmp4 -= 1.0;
        tmp5 += 1.0;
      }
      else if(tmp4 < -0.5)
      {
        tmp4 += 1.0;
        tmp5 -= 1.0;
      }
      
      if(fabs(tmp4) < 1e-10)
        tmp3 = pow(tmp1, tmp5);
      else
      {
        tmp7 = modf(1.0/tmp2, &tmp6);
        if(tmp7 > 0.5)
        {
          tmp7 -= 1.0;
          tmp6 += 1.0;
        }
        else if(tmp7 < -0.5)
        {
          tmp7 += 1.0;
          tmp6 -= 1.0;
        }
        if(fabs(tmp7) < 1e-10 && ((unsigned long)tmp6 & 1))
        {
          tmp3 = -pow(-tmp1, tmp4)*pow(tmp1, tmp5);
        }
        else
        {
          throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp1, tmp2);
        }
      }
    }
    else
    {
      tmp3 = pow(tmp1, tmp2);
    }
    if(isnan(tmp3) || isinf(tmp3))
    {
      throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp1, tmp2);
    }
    _T = tmp3;
  }
  _return: OMC_LABEL_UNUSED
  return _T;
}
modelica_metatype boxptr_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData_t *threadData, modelica_metatype _h)
{
  modelica_real tmp1;
  modelica_real _T;
  modelica_metatype out_T;
  tmp1 = mmc_unbox_real(_h);
  _T = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_T__h(threadData, tmp1);
  out_T = mmc_mk_rcon(_T);
  return out_T;
}

DLLExport
modelica_real omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData_t *threadData, modelica_real _T)
{
  modelica_real _h;
  modelica_real _a;
  modelica_real _b;
  modelica_real _c;
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_real tmp5;
  modelica_real tmp6;
  modelica_real tmp7;
  _tailrecursive: OMC_LABEL_UNUSED
  // _h has no default value.
  _a = 148.2;
  _b = 0.3093;
  _c = -196601.368854;
  if((_T < 0.0))
  {
    _h = 0.0;
  }
  else
  {
    tmp1 = _T;
    tmp2 = 1.3093;
    if(tmp1 < 0.0 && tmp2 != 0.0)
    {
      tmp4 = modf(tmp2, &tmp5);
      
      if(tmp4 > 0.5)
      {
        tmp4 -= 1.0;
        tmp5 += 1.0;
      }
      else if(tmp4 < -0.5)
      {
        tmp4 += 1.0;
        tmp5 -= 1.0;
      }
      
      if(fabs(tmp4) < 1e-10)
        tmp3 = pow(tmp1, tmp5);
      else
      {
        tmp7 = modf(1.0/tmp2, &tmp6);
        if(tmp7 > 0.5)
        {
          tmp7 -= 1.0;
          tmp6 += 1.0;
        }
        else if(tmp7 < -0.5)
        {
          tmp7 += 1.0;
          tmp6 -= 1.0;
        }
        if(fabs(tmp7) < 1e-10 && ((unsigned long)tmp6 & 1))
        {
          tmp3 = -pow(-tmp1, tmp4)*pow(tmp1, tmp5);
        }
        else
        {
          throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp1, tmp2);
        }
      }
    }
    else
    {
      tmp3 = pow(tmp1, tmp2);
    }
    if(isnan(tmp3) || isinf(tmp3))
    {
      throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp1, tmp2);
    }
    _h = -196601.368854 + (113.1902543343771) * (tmp3);
  }
  _return: OMC_LABEL_UNUSED
  return _h;
}
modelica_metatype boxptr_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData_t *threadData, modelica_metatype _T)
{
  modelica_real tmp1;
  modelica_real _h;
  modelica_metatype out_h;
  tmp1 = mmc_unbox_real(_T);
  _h = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_h__T(threadData, tmp1);
  out_h = mmc_mk_rcon(_h);
  return out_h;
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F696E5F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F696E5F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F696E5F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F696E5F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F696E5F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F6973656E5F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F6973656E5F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F6973656E5F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F6973656E5F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B246D61696E436F6D70726573736F722473746174655F5F6973656E5F5F646573__desc, _p, _h);
}

DLLExport
modelica_real omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_specificEntropy(threadData_t *threadData, SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_ThermodynamicState _state)
{
  modelica_real _s;
  _tailrecursive: OMC_LABEL_UNUSED
  // _s has no default value.
  _s = omc_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData, _state._p, _state._h, omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT34, _OMC_LIT35, _OMC_LIT36, 1));
  _return: OMC_LABEL_UNUSED
  return _s;
}
modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_specificEntropy(threadData_t *threadData, modelica_metatype _state)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_ThermodynamicState tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _s;
  modelica_metatype out_s;
  modelica_metatype tmpMeta[2] __attribute__((unused)) = {0};
  tmpMeta[0] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 2)));
  tmp2 = mmc_unbox_real(tmpMeta[0]);
  tmp1._p = tmp2;
  tmpMeta[1] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 3)));
  tmp3 = mmc_unbox_real(tmpMeta[1]);
  tmp1._h = tmp3;
  _s = omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B246D61696E436F6D70726573736F72_Medium_specificEntropy(threadData, tmp1);
  out_s = mmc_mk_rcon(_s);
  return out_s;
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F696E5F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F696E5F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F696E5F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F696E5F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F696E5F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F6973656E5F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F6973656E5F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F6973656E5F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F6973656E5F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B247265436F6D70726573736F722473746174655F5F6973656E5F5F646573__desc, _p, _h);
}

DLLExport
modelica_real omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_specificEntropy(threadData_t *threadData, SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_ThermodynamicState _state)
{
  modelica_real _s;
  _tailrecursive: OMC_LABEL_UNUSED
  // _s has no default value.
  _s = omc_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData, _state._p, _state._h, omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT34, _OMC_LIT35, _OMC_LIT36, 1));
  _return: OMC_LABEL_UNUSED
  return _s;
}
modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_specificEntropy(threadData_t *threadData, modelica_metatype _state)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_ThermodynamicState tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _s;
  modelica_metatype out_s;
  modelica_metatype tmpMeta[2] __attribute__((unused)) = {0};
  tmpMeta[0] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 2)));
  tmp2 = mmc_unbox_real(tmpMeta[0]);
  tmp1._p = tmp2;
  tmpMeta[1] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 3)));
  tmp3 = mmc_unbox_real(tmpMeta[1]);
  tmp1._h = tmp3;
  _s = omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6D70726573736F724F6E536861667424706F776572426C6F636B247265436F6D70726573736F72_Medium_specificEntropy(threadData, tmp1);
  out_s = mmc_mk_rcon(_s);
  return out_s;
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B24636F6F6C65722473746174655F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B24636F6F6C65722473746174655F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B24636F6F6C65722473746174655F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B24636F6F6C65722473746174655F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_436F6F6C657224706F776572426C6F636B24636F6F6C6572_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B24636F6F6C65722473746174655F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F434F325F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F434F325F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F434F325F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F434F325F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F434F325F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F4854465F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F4854465F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F4854465F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F4854465F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedPB__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2465786368616E6765722473746174655F5F4854465F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedRec_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedRec_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedRec_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedRec_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_45786368616E6765725F5F4A506964656124706F776572426C6F636B2465786368616E676572_MedRec_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F636F6D705F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F636F6D705F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F636F6D705F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F636F6D705F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F636F6D705F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F747572625F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F747572625F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F747572625F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F747572625F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B24485452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244854522473746174655F5F747572625F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F636F6D705F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F636F6D705F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F636F6D705F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F636F6D705F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F636F6D705F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F747572625F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F747572625F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F747572625F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F747572625F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_486561745265637570657261746F72445441766524706F776572426C6F636B244C5452_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B244C54522473746174655F5F747572625F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F61 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F61(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F61 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F61(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F61__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F696E5F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F696E5F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F696E5F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F696E5F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F696E5F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6973656E5F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6973656E5F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6973656E5F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6973656E5F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6973656E5F5F646573__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6F75745F5F646573 omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6F75745F5F646573(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6F75745F5F646573 tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6F75745F5F646573(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium__omcQuot_546865726D6F64796E616D6963537461746524706F776572426C6F636B2474757262696E652473746174655F5F6F75745F5F646573__desc, _p, _h);
}

DLLExport
modelica_real omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_specificEntropy(threadData_t *threadData, SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_ThermodynamicState _state)
{
  modelica_real _s;
  _tailrecursive: OMC_LABEL_UNUSED
  // _s has no default value.
  _s = omc_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData, _state._p, _state._h, omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT34, _OMC_LIT35, _OMC_LIT36, 1));
  _return: OMC_LABEL_UNUSED
  return _s;
}
modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_specificEntropy(threadData_t *threadData, modelica_metatype _state)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_ThermodynamicState tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _s;
  modelica_metatype out_s;
  modelica_metatype tmpMeta[2] __attribute__((unused)) = {0};
  tmpMeta[0] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 2)));
  tmp2 = mmc_unbox_real(tmpMeta[0]);
  tmp1._p = tmp2;
  tmpMeta[1] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 3)));
  tmp3 = mmc_unbox_real(tmpMeta[1]);
  tmp1._h = tmp3;
  _s = omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_54757262696E6524706F776572426C6F636B2474757262696E65_Medium_specificEntropy(threadData, tmp1);
  out_s = mmc_mk_rcon(_s);
  return out_s;
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_7265636F6D7050425F5F4D6F6469666965645F5F4A506964656124706F776572426C6F636B_MedRec_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_7265636F6D7050425F5F4D6F6469666965645F5F4A506964656124706F776572426C6F636B_MedRec_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_7265636F6D7050425F5F4D6F6469666965645F5F4A506964656124706F776572426C6F636B_MedRec_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_7265636F6D7050425F5F4D6F6469666965645F5F4A506964656124706F776572426C6F636B_MedRec_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign__omcQuot_7265636F6D7050425F5F4D6F6469666965645F5F4A506964656124706F776572426C6F636B_MedRec_ThermodynamicState__desc, _p, _h);
}

#ifdef __cplusplus
}
#endif
