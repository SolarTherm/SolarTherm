#include "omc_simulation_settings.h"
#include "ParticleReceiver1DCalculator_functions.h"
#ifdef __cplusplus
extern "C" {
#endif

#include "ParticleReceiver1DCalculator_includes.h"


modelica_real omc_Modelica_Blocks_Tables__omcQuot_436F6D62695461626C65314473247061727469636C655265636569766572314424546162_getTableValue(threadData_t *threadData, modelica_complex _tableID, modelica_integer _icol, modelica_real _u, modelica_real _tableAvailable)
{
  void * _tableID_ext;
  int _icol_ext;
  double _u_ext;
  double _y_ext;
  modelica_real _y;
  // _y has no default value.
  _tableID_ext = (void *)_tableID;

  _icol_ext = (int)_icol;

  _u_ext = (double)_u;
  _y_ext = ModelicaStandardTables_CombiTable1D_getValue(_tableID_ext, _icol_ext, _u_ext);
  _y = (modelica_real)_y_ext;
  return _y;
}
modelica_metatype boxptr_Modelica_Blocks_Tables__omcQuot_436F6D62695461626C65314473247061727469636C655265636569766572314424546162_getTableValue(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _icol, modelica_metatype _u, modelica_metatype _tableAvailable)
{
  modelica_integer tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_integer(_icol);
  tmp2 = mmc_unbox_real(_u);
  tmp3 = mmc_unbox_real(_tableAvailable);
  _y = omc_Modelica_Blocks_Tables__omcQuot_436F6D62695461626C65314473247061727469636C655265636569766572314424546162_getTableValue(threadData, _tableID, tmp1, tmp2, tmp3);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

modelica_real omc_Modelica_Blocks_Tables__omcQuot_436F6D62695461626C65314473247061727469636C655265636569766572314424546162_readTableData(threadData_t *threadData, modelica_complex _tableID, modelica_boolean _forceRead, modelica_boolean _verboseRead)
{
  void * _tableID_ext;
  int _forceRead_ext;
  int _verboseRead_ext;
  double _readSuccess_ext;
  modelica_real _readSuccess;
  // _readSuccess has no default value.
  _tableID_ext = (void *)_tableID;

  _forceRead_ext = (int)_forceRead;

  _verboseRead_ext = (int)_verboseRead;
  _readSuccess_ext = ModelicaStandardTables_CombiTable1D_read(_tableID_ext, _forceRead_ext, _verboseRead_ext);
  _readSuccess = (modelica_real)_readSuccess_ext;
  return _readSuccess;
}
modelica_metatype boxptr_Modelica_Blocks_Tables__omcQuot_436F6D62695461626C65314473247061727469636C655265636569766572314424546162_readTableData(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _forceRead, modelica_metatype _verboseRead)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_real _readSuccess;
  modelica_metatype out_readSuccess;
  tmp1 = mmc_unbox_integer(_forceRead);
  tmp2 = mmc_unbox_integer(_verboseRead);
  _readSuccess = omc_Modelica_Blocks_Tables__omcQuot_436F6D62695461626C65314473247061727469636C655265636569766572314424546162_readTableData(threadData, _tableID, tmp1, tmp2);
  out_readSuccess = mmc_mk_rcon(_readSuccess);
  return out_readSuccess;
}

modelica_complex omc_Modelica_Blocks_Types_ExternalCombiTable1D_constructor(threadData_t *threadData, modelica_string _tableName, modelica_string _fileName, real_array _table, integer_array _columns, modelica_integer _smoothness)
{
  integer_array _columns_packed;
  int _smoothness_ext;
  void *_table_c89;
  void *_columns_c89;
  void * _externalCombiTable1D_ext;
  modelica_complex _externalCombiTable1D;
  // _externalCombiTable1D has no default value.
  pack_alloc_integer_array(&_columns, &_columns_packed);

  _smoothness_ext = (int)_smoothness;
  _table_c89 = (void*) data_of_real_c89_array(&(_table));
  _columns_c89 = (void*) data_of_integer_c89_array(&(_columns_packed));
  _externalCombiTable1D_ext = ModelicaStandardTables_CombiTable1D_init(MMC_STRINGDATA(_tableName), MMC_STRINGDATA(_fileName), (const double*) _table_c89, size_of_dimension_base_array(_table, ((modelica_integer) 1)), size_of_dimension_base_array(_table, ((modelica_integer) 2)), (const int*) _columns_c89, size_of_dimension_base_array(_columns, ((modelica_integer) 1)), _smoothness_ext);
  _externalCombiTable1D = (modelica_complex)_externalCombiTable1D_ext;
  return _externalCombiTable1D;
}
modelica_metatype boxptr_Modelica_Blocks_Types_ExternalCombiTable1D_constructor(threadData_t *threadData, modelica_metatype _tableName, modelica_metatype _fileName, modelica_metatype _table, modelica_metatype _columns, modelica_metatype _smoothness)
{
  modelica_integer tmp1;
  modelica_complex _externalCombiTable1D;
  tmp1 = mmc_unbox_integer(_smoothness);
  _externalCombiTable1D = omc_Modelica_Blocks_Types_ExternalCombiTable1D_constructor(threadData, _tableName, _fileName, *((base_array_t*)_table), *((base_array_t*)_columns), tmp1);
  /* skip box _externalCombiTable1D; ExternalObject Modelica.Blocks.Types.ExternalCombiTable1D */
  return _externalCombiTable1D;
}

void omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData_t *threadData, modelica_complex _externalCombiTable1D)
{
  void * _externalCombiTable1D_ext;
  _externalCombiTable1D_ext = (void *)_externalCombiTable1D;
  ModelicaStandardTables_CombiTable1D_close(_externalCombiTable1D_ext);
  return;
}
void boxptr_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData_t *threadData, modelica_metatype _externalCombiTable1D)
{
  omc_Modelica_Blocks_Types_ExternalCombiTable1D_destructor(threadData, _externalCombiTable1D);
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

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61247061727469636C655265636569766572314424666C7569645F5F61_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61247061727469636C655265636569766572314424666C7569645F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61247061727469636C655265636569766572314424666C7569645F5F61_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61247061727469636C655265636569766572314424666C7569645F5F61_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F61247061727469636C655265636569766572314424666C7569645F5F61_Medium_ThermodynamicState__desc, _p, _h);
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

Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62247061727469636C655265636569766572314424666C7569645F5F62_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62247061727469636C655265636569766572314424666C7569645F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62247061727469636C655265636569766572314424666C7569645F5F62_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62247061727469636C655265636569766572314424666C7569645F5F62_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces__omcQuot_466C756964506F72745F5F62247061727469636C655265636569766572314424666C7569645F5F62_Medium_ThermodynamicState__desc, _p, _h);
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
      tmpMeta[0] = stringAppend(_OMC_LIT4,_modelName);
      tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT5);
      tmpMeta[2] = stringAppend(tmpMeta[1],_mediumName);
      tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT6);
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
          tmpMeta[0] = stringAppend(_OMC_LIT7,_mediumName);
          tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT8);
          tmpMeta[2] = stringAppend(tmpMeta[1],_modelName);
          tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT9);
          tmp3 = modelica_integer_to_modelica_string(_i, ((modelica_integer) 0), 1);
          tmpMeta[4] = stringAppend(tmpMeta[3],tmp3);
          tmpMeta[5] = stringAppend(tmpMeta[4],_OMC_LIT10);
          tmp4 = modelica_real_to_modelica_string((*real_array_element_addr1(&_X_boundary, 1, _i)), ((modelica_integer) 6), ((modelica_integer) 0), 1);
          tmpMeta[6] = stringAppend(tmpMeta[5],tmp4);
          tmpMeta[7] = stringAppend(tmpMeta[6],_OMC_LIT11);
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
    _X_str = _OMC_LIT12;

    tmp11 = ((modelica_integer) 1); tmp12 = 1; tmp13 = _nX;
    if(!(((tmp12 > 0) && (tmp11 > tmp13)) || ((tmp12 < 0) && (tmp11 < tmp13))))
    {
      modelica_integer _i;
      for(_i = ((modelica_integer) 1); in_range_integer(_i, tmp11, tmp13); _i += tmp12)
      {
        tmpMeta[0] = stringAppend(_X_str,_OMC_LIT13);
        tmp9 = modelica_integer_to_modelica_string(_i, ((modelica_integer) 0), 1);
        tmpMeta[1] = stringAppend(tmpMeta[0],tmp9);
        tmpMeta[2] = stringAppend(tmpMeta[1],_OMC_LIT14);
        tmp10 = modelica_real_to_modelica_string((*real_array_element_addr1(&_X_boundary, 1, _i)), ((modelica_integer) 6), ((modelica_integer) 0), 1);
        tmpMeta[3] = stringAppend(tmpMeta[2],tmp10);
        tmpMeta[4] = stringAppend(tmpMeta[3],_OMC_LIT15);
        tmpMeta[5] = stringAppend(tmpMeta[4],(*string_array_element_addr1(&_substanceNames, 1, _i)));
        tmpMeta[6] = stringAppend(tmpMeta[5],_OMC_LIT16);
        _X_str = tmpMeta[6];
      }
    }

    tmpMeta[0] = stringAppend(_OMC_LIT17,_mediumName);
    tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT8);
    tmpMeta[2] = stringAppend(tmpMeta[1],_modelName);
    tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT16);
    tmpMeta[4] = stringAppend(tmpMeta[3],_OMC_LIT18);
    tmp14 = modelica_real_to_modelica_string(sum_real_array(_X_boundary), ((modelica_integer) 6), ((modelica_integer) 0), 1);
    tmpMeta[5] = stringAppend(tmpMeta[4],tmp14);
    tmpMeta[6] = stringAppend(tmpMeta[5],_OMC_LIT19);
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

Modelica_Media_IdealGases_Common_DataRecord omc_Modelica_Media_IdealGases_Common_DataRecord(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common_DataRecord tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common_DataRecord(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common_DataRecord__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424416972 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424416972(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424416972 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424416972(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424416972__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244172 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244172(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244172 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244172(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244172__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248325F5F76696E796C6964656E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248325F5F76696E796C6964656E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248325F5F76696E796C6964656E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248325F5F76696E796C6964656E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248325F5F76696E796C6964656E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324834 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324834(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324834 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324834(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324834__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248354F48 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248354F48(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248354F48 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248354F48(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433248354F48__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324836 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324836(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324836 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324836(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443324836__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433348365F5F70726F70796C656E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433348365F5F70726F70796C656E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433348365F5F70726F70796C656E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433348365F5F70726F70796C656E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433348365F5F70726F70796C656E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443334838 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443334838(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443334838 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443334838(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443334838__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443344831305F5F6E5F5F627574616E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443344831305F5F6E5F5F627574616E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443344831305F5F6E5F5F627574616E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443344831305F5F6E5F5F627574616E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443344831305F5F6E5F5F627574616E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433448385F5F315F5F627574656E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433448385F5F315F5F627574656E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433448385F5F315F5F627574656E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433448385F5F315F5F627574656E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424433448385F5F315F5F627574656E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831305F5F315F5F70656E74656E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831305F5F315F5F70656E74656E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831305F5F315F5F70656E74656E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831305F5F315F5F70656E74656E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831305F5F315F5F70656E74656E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831325F5F6E5F5F70656E74616E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831325F5F6E5F5F70656E74616E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831325F5F6E5F5F70656E74616E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831325F5F6E5F5F70656E74616E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443354831325F5F6E5F5F70656E74616E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831325F5F315F5F686578656E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831325F5F315F5F686578656E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831325F5F315F5F686578656E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831325F5F315F5F686578656E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831325F5F315F5F686578656E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831345F5F6E5F5F686578616E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831345F5F6E5F5F686578616E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831345F5F6E5F5F686578616E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831345F5F6E5F5F686578616E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364831345F5F6E5F5F686578616E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364836 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364836(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364836 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364836(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443364836__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831345F5F315F5F68657074656E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831345F5F315F5F68657074656E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831345F5F315F5F68657074656E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831345F5F315F5F68657074656E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831345F5F315F5F68657074656E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831365F5F6E5F5F68657074616E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831365F5F6E5F5F68657074616E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831365F5F6E5F5F68657074616E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831365F5F6E5F5F68657074616E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443374831365F5F6E5F5F68657074616E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831305F5F657468796C62656E7A omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831305F5F657468796C62656E7A(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831305F5F657468796C62656E7A tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831305F5F657468796C62656E7A(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831305F5F657468796C62656E7A__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831385F5F6E5F5F6F6374616E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831385F5F6E5F5F6F6374616E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831385F5F6E5F5F6F6374616E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831385F5F6E5F5F6F6374616E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642443384831385F5F6E5F5F6F6374616E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244348334F48 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244348334F48(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244348334F48 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244348334F48(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244348334F48__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434834 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434834(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434834 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434834(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434834__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434C32 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434C32(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434C32 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434C32(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434C32__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F32 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F32(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F32 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F32(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424434F32__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244632 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244632(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244632 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244632(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244632__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244832 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244832(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244832 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244832(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244832__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642448324F omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642448324F(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642448324F tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642448324F(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F72642448324F__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244865 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244865(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244865 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244865(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244865__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E32 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E32(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E32 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E32(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E32__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E324F omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E324F(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E324F tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E324F(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E324F__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4833 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4833(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4833 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4833(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4833__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F32 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F32(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F32 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F32(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E4F32__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E65 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E65(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E65 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E65(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244E65__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244F32 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244F32(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244F32 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244F32(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F7264244F32__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F32 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F32(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F32 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F32(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F32__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F33 omc_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F33(threadData_t *threadData, modelica_string omc_name, modelica_real omc_MM, modelica_real omc_Hf, modelica_real omc_H0, modelica_real omc_Tlimit, real_array omc_alow, real_array omc_blow, real_array omc_ahigh, real_array omc_bhigh, modelica_real omc_R)
{
  Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F33 tmp1;
  tmp1._name = omc_name;
  tmp1._MM = omc_MM;
  tmp1._Hf = omc_Hf;
  tmp1._H0 = omc_H0;
  tmp1._Tlimit = omc_Tlimit;
  tmp1._alow = omc_alow;
  tmp1._blow = omc_blow;
  tmp1._ahigh = omc_ahigh;
  tmp1._bhigh = omc_bhigh;
  tmp1._R = omc_R;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F33(threadData_t *threadData, modelica_metatype _name, modelica_metatype _MM, modelica_metatype _Hf, modelica_metatype _H0, modelica_metatype _Tlimit, modelica_metatype _alow, modelica_metatype _blow, modelica_metatype _ahigh, modelica_metatype _bhigh, modelica_metatype _R)
{
  return mmc_mk_box11(3, &Modelica_Media_IdealGases_Common__omcQuot_446174615265636F726424534F33__desc, _name, _MM, _Hf, _H0, _Tlimit, _alow, _blow, _ahigh, _bhigh, _R);
}

Modelica_Media_Incompressible_TableBased_ThermodynamicState omc_Modelica_Media_Incompressible_TableBased_ThermodynamicState(threadData_t *threadData, modelica_real omc_T, modelica_real omc_p)
{
  Modelica_Media_Incompressible_TableBased_ThermodynamicState tmp1;
  tmp1._T = omc_T;
  tmp1._p = omc_p;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_Incompressible_TableBased_ThermodynamicState(threadData_t *threadData, modelica_metatype _T, modelica_metatype _p)
{
  return mmc_mk_box3(3, &Modelica_Media_Incompressible_TableBased_ThermodynamicState__desc, _T, _p);
}

DLLExport
modelica_real omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate(threadData_t *threadData, real_array _p, modelica_real _u)
{
  modelica_real _y;
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_integer tmp3;
  modelica_integer tmp4;
  _tailrecursive: OMC_LABEL_UNUSED
  // _y has no default value.
  _y = (*real_array_element_addr1(&_p, 1, ((modelica_integer) 1)));

  tmp4 = size_of_dimension_base_array(_p, ((modelica_integer) 1));
  tmp1 = ((modelica_integer) 2); tmp2 = 1; tmp3 = tmp4;
  if(!(((tmp2 > 0) && (tmp1 > tmp3)) || ((tmp2 < 0) && (tmp1 < tmp3))))
  {
    modelica_integer _j;
    for(_j = ((modelica_integer) 2); in_range_integer(_j, tmp1, tmp3); _j += tmp2)
    {
      _y = (*real_array_element_addr1(&_p, 1, _j)) + (_u) * (_y);
    }
  }
  _return: OMC_LABEL_UNUSED
  return _y;
}
modelica_metatype boxptr_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate(threadData_t *threadData, modelica_metatype _p, modelica_metatype _u)
{
  modelica_real tmp1;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_real(_u);
  _y = omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate(threadData, *((base_array_t*)_p), tmp1);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

DLLExport
modelica_real omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluateWithRange(threadData_t *threadData, real_array _p, modelica_real _uMin, modelica_real _uMax, modelica_real _u)
{
  modelica_real _y;
  _tailrecursive: OMC_LABEL_UNUSED
  // _y has no default value.
  if((_u < _uMin))
  {
    _y = omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate(threadData, _p, _uMin) - omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate__der(threadData, _p, _uMin, _uMin - _u);
  }
  else
  {
    if((_u > _uMax))
    {
      _y = omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate(threadData, _p, _uMax) + omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate__der(threadData, _p, _uMax, _u - _uMax);
    }
    else
    {
      _y = omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate(threadData, _p, _u);
    }
  }
  _return: OMC_LABEL_UNUSED
  return _y;
}
modelica_metatype boxptr_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluateWithRange(threadData_t *threadData, modelica_metatype _p, modelica_metatype _uMin, modelica_metatype _uMax, modelica_metatype _u)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_real(_uMin);
  tmp2 = mmc_unbox_real(_uMax);
  tmp3 = mmc_unbox_real(_u);
  _y = omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluateWithRange(threadData, *((base_array_t*)_p), tmp1, tmp2, tmp3);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

DLLExport
modelica_real omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate__der(threadData_t *threadData, real_array _p, modelica_real _u, modelica_real _du)
{
  modelica_real _dy;
  modelica_integer _n;
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_integer tmp3;
  modelica_integer tmp4;
  modelica_integer tmp5;
  _tailrecursive: OMC_LABEL_UNUSED
  // _dy has no default value.
  tmp1 = size_of_dimension_base_array(_p, ((modelica_integer) 1));
  _n = tmp1;
  _dy = ((*real_array_element_addr1(&_p, 1, ((modelica_integer) 1)))) * (((modelica_real)((modelica_integer) -1) + _n));

  tmp5 = size_of_dimension_base_array(_p, ((modelica_integer) 1));
  tmp2 = ((modelica_integer) 2); tmp3 = 1; tmp4 = ((modelica_integer) -1) + tmp5;
  if(!(((tmp3 > 0) && (tmp2 > tmp4)) || ((tmp3 < 0) && (tmp2 < tmp4))))
  {
    modelica_integer _j;
    for(_j = ((modelica_integer) 2); in_range_integer(_j, tmp2, tmp4); _j += tmp3)
    {
      _dy = ((*real_array_element_addr1(&_p, 1, _j))) * (((modelica_real)_n - _j)) + (_u) * (_dy);
    }
  }

  _dy = (_dy) * (_du);
  _return: OMC_LABEL_UNUSED
  return _dy;
}
modelica_metatype boxptr_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate__der(threadData_t *threadData, modelica_metatype _p, modelica_metatype _u, modelica_metatype _du)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real _dy;
  modelica_metatype out_dy;
  tmp1 = mmc_unbox_real(_u);
  tmp2 = mmc_unbox_real(_du);
  _dy = omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluate__der(threadData, *((base_array_t*)_p), tmp1, tmp2);
  out_dy = mmc_mk_rcon(_dy);
  return out_dy;
}

Modelica_Media_Interfaces_Types_IdealGas_FluidConstants omc_Modelica_Media_Interfaces_Types_IdealGas_FluidConstants(threadData_t *threadData, modelica_string omc_iupacName, modelica_string omc_casRegistryNumber, modelica_string omc_chemicalFormula, modelica_string omc_structureFormula, modelica_real omc_molarMass, modelica_real omc_criticalTemperature, modelica_real omc_criticalPressure, modelica_real omc_criticalMolarVolume, modelica_real omc_acentricFactor, modelica_real omc_meltingPoint, modelica_real omc_normalBoilingPoint, modelica_real omc_dipoleMoment, modelica_boolean omc_hasIdealGasHeatCapacity, modelica_boolean omc_hasCriticalData, modelica_boolean omc_hasDipoleMoment, modelica_boolean omc_hasFundamentalEquation, modelica_boolean omc_hasLiquidHeatCapacity, modelica_boolean omc_hasSolidHeatCapacity, modelica_boolean omc_hasAccurateViscosityData, modelica_boolean omc_hasAccurateConductivityData, modelica_boolean omc_hasVapourPressureCurve, modelica_boolean omc_hasAcentricFactor, modelica_real omc_HCRIT0, modelica_real omc_SCRIT0, modelica_real omc_deltah, modelica_real omc_deltas)
{
  Modelica_Media_Interfaces_Types_IdealGas_FluidConstants tmp1;
  tmp1._iupacName = omc_iupacName;
  tmp1._casRegistryNumber = omc_casRegistryNumber;
  tmp1._chemicalFormula = omc_chemicalFormula;
  tmp1._structureFormula = omc_structureFormula;
  tmp1._molarMass = omc_molarMass;
  tmp1._criticalTemperature = omc_criticalTemperature;
  tmp1._criticalPressure = omc_criticalPressure;
  tmp1._criticalMolarVolume = omc_criticalMolarVolume;
  tmp1._acentricFactor = omc_acentricFactor;
  tmp1._meltingPoint = omc_meltingPoint;
  tmp1._normalBoilingPoint = omc_normalBoilingPoint;
  tmp1._dipoleMoment = omc_dipoleMoment;
  tmp1._hasIdealGasHeatCapacity = omc_hasIdealGasHeatCapacity;
  tmp1._hasCriticalData = omc_hasCriticalData;
  tmp1._hasDipoleMoment = omc_hasDipoleMoment;
  tmp1._hasFundamentalEquation = omc_hasFundamentalEquation;
  tmp1._hasLiquidHeatCapacity = omc_hasLiquidHeatCapacity;
  tmp1._hasSolidHeatCapacity = omc_hasSolidHeatCapacity;
  tmp1._hasAccurateViscosityData = omc_hasAccurateViscosityData;
  tmp1._hasAccurateConductivityData = omc_hasAccurateConductivityData;
  tmp1._hasVapourPressureCurve = omc_hasVapourPressureCurve;
  tmp1._hasAcentricFactor = omc_hasAcentricFactor;
  tmp1._HCRIT0 = omc_HCRIT0;
  tmp1._SCRIT0 = omc_SCRIT0;
  tmp1._deltah = omc_deltah;
  tmp1._deltas = omc_deltas;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_Interfaces_Types_IdealGas_FluidConstants(threadData_t *threadData, modelica_metatype _iupacName, modelica_metatype _casRegistryNumber, modelica_metatype _chemicalFormula, modelica_metatype _structureFormula, modelica_metatype _molarMass, modelica_metatype _criticalTemperature, modelica_metatype _criticalPressure, modelica_metatype _criticalMolarVolume, modelica_metatype _acentricFactor, modelica_metatype _meltingPoint, modelica_metatype _normalBoilingPoint, modelica_metatype _dipoleMoment, modelica_metatype _hasIdealGasHeatCapacity, modelica_metatype _hasCriticalData, modelica_metatype _hasDipoleMoment, modelica_metatype _hasFundamentalEquation, modelica_metatype _hasLiquidHeatCapacity, modelica_metatype _hasSolidHeatCapacity, modelica_metatype _hasAccurateViscosityData, modelica_metatype _hasAccurateConductivityData, modelica_metatype _hasVapourPressureCurve, modelica_metatype _hasAcentricFactor, modelica_metatype _HCRIT0, modelica_metatype _SCRIT0, modelica_metatype _deltah, modelica_metatype _deltas)
{
  return mmc_mk_box(27, 3, &Modelica_Media_Interfaces_Types_IdealGas_FluidConstants__desc, _iupacName, _casRegistryNumber, _chemicalFormula, _structureFormula, _molarMass, _criticalTemperature, _criticalPressure, _criticalMolarVolume, _acentricFactor, _meltingPoint, _normalBoilingPoint, _dipoleMoment, _hasIdealGasHeatCapacity, _hasCriticalData, _hasDipoleMoment, _hasFundamentalEquation, _hasLiquidHeatCapacity, _hasSolidHeatCapacity, _hasAccurateViscosityData, _hasAccurateConductivityData, _hasVapourPressureCurve, _hasAcentricFactor, _HCRIT0, _SCRIT0, _deltah, _deltas);
}

Modelica_Media_Interfaces_Types_IdealGas__omcQuot_466C756964436F6E7374616E7473244E32 omc_Modelica_Media_Interfaces_Types_IdealGas__omcQuot_466C756964436F6E7374616E7473244E32(threadData_t *threadData, modelica_string omc_iupacName, modelica_string omc_casRegistryNumber, modelica_string omc_chemicalFormula, modelica_string omc_structureFormula, modelica_real omc_molarMass, modelica_real omc_criticalTemperature, modelica_real omc_criticalPressure, modelica_real omc_criticalMolarVolume, modelica_real omc_acentricFactor, modelica_real omc_meltingPoint, modelica_real omc_normalBoilingPoint, modelica_real omc_dipoleMoment, modelica_boolean omc_hasIdealGasHeatCapacity, modelica_boolean omc_hasCriticalData, modelica_boolean omc_hasDipoleMoment, modelica_boolean omc_hasFundamentalEquation, modelica_boolean omc_hasLiquidHeatCapacity, modelica_boolean omc_hasSolidHeatCapacity, modelica_boolean omc_hasAccurateViscosityData, modelica_boolean omc_hasAccurateConductivityData, modelica_boolean omc_hasVapourPressureCurve, modelica_boolean omc_hasAcentricFactor, modelica_real omc_HCRIT0, modelica_real omc_SCRIT0, modelica_real omc_deltah, modelica_real omc_deltas)
{
  Modelica_Media_Interfaces_Types_IdealGas__omcQuot_466C756964436F6E7374616E7473244E32 tmp1;
  tmp1._iupacName = omc_iupacName;
  tmp1._casRegistryNumber = omc_casRegistryNumber;
  tmp1._chemicalFormula = omc_chemicalFormula;
  tmp1._structureFormula = omc_structureFormula;
  tmp1._molarMass = omc_molarMass;
  tmp1._criticalTemperature = omc_criticalTemperature;
  tmp1._criticalPressure = omc_criticalPressure;
  tmp1._criticalMolarVolume = omc_criticalMolarVolume;
  tmp1._acentricFactor = omc_acentricFactor;
  tmp1._meltingPoint = omc_meltingPoint;
  tmp1._normalBoilingPoint = omc_normalBoilingPoint;
  tmp1._dipoleMoment = omc_dipoleMoment;
  tmp1._hasIdealGasHeatCapacity = omc_hasIdealGasHeatCapacity;
  tmp1._hasCriticalData = omc_hasCriticalData;
  tmp1._hasDipoleMoment = omc_hasDipoleMoment;
  tmp1._hasFundamentalEquation = omc_hasFundamentalEquation;
  tmp1._hasLiquidHeatCapacity = omc_hasLiquidHeatCapacity;
  tmp1._hasSolidHeatCapacity = omc_hasSolidHeatCapacity;
  tmp1._hasAccurateViscosityData = omc_hasAccurateViscosityData;
  tmp1._hasAccurateConductivityData = omc_hasAccurateConductivityData;
  tmp1._hasVapourPressureCurve = omc_hasVapourPressureCurve;
  tmp1._hasAcentricFactor = omc_hasAcentricFactor;
  tmp1._HCRIT0 = omc_HCRIT0;
  tmp1._SCRIT0 = omc_SCRIT0;
  tmp1._deltah = omc_deltah;
  tmp1._deltas = omc_deltas;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Media_Interfaces_Types_IdealGas__omcQuot_466C756964436F6E7374616E7473244E32(threadData_t *threadData, modelica_metatype _iupacName, modelica_metatype _casRegistryNumber, modelica_metatype _chemicalFormula, modelica_metatype _structureFormula, modelica_metatype _molarMass, modelica_metatype _criticalTemperature, modelica_metatype _criticalPressure, modelica_metatype _criticalMolarVolume, modelica_metatype _acentricFactor, modelica_metatype _meltingPoint, modelica_metatype _normalBoilingPoint, modelica_metatype _dipoleMoment, modelica_metatype _hasIdealGasHeatCapacity, modelica_metatype _hasCriticalData, modelica_metatype _hasDipoleMoment, modelica_metatype _hasFundamentalEquation, modelica_metatype _hasLiquidHeatCapacity, modelica_metatype _hasSolidHeatCapacity, modelica_metatype _hasAccurateViscosityData, modelica_metatype _hasAccurateConductivityData, modelica_metatype _hasVapourPressureCurve, modelica_metatype _hasAcentricFactor, modelica_metatype _HCRIT0, modelica_metatype _SCRIT0, modelica_metatype _deltah, modelica_metatype _deltas)
{
  return mmc_mk_box(27, 3, &Modelica_Media_Interfaces_Types_IdealGas__omcQuot_466C756964436F6E7374616E7473244E32__desc, _iupacName, _casRegistryNumber, _chemicalFormula, _structureFormula, _molarMass, _criticalTemperature, _criticalPressure, _criticalMolarVolume, _acentricFactor, _meltingPoint, _normalBoilingPoint, _dipoleMoment, _hasIdealGasHeatCapacity, _hasCriticalData, _hasDipoleMoment, _hasFundamentalEquation, _hasLiquidHeatCapacity, _hasSolidHeatCapacity, _hasAccurateViscosityData, _hasAccurateConductivityData, _hasVapourPressureCurve, _hasAcentricFactor, _HCRIT0, _SCRIT0, _deltah, _deltas);
}

DLLExport
modelica_real omc_Modelica_SIunits_Conversions_to__degC(threadData_t *threadData, modelica_real _Kelvin)
{
  modelica_real _Celsius;
  _tailrecursive: OMC_LABEL_UNUSED
  // _Celsius has no default value.
  _Celsius = -273.15 + _Kelvin;
  _return: OMC_LABEL_UNUSED
  return _Celsius;
}
modelica_metatype boxptr_Modelica_SIunits_Conversions_to__degC(threadData_t *threadData, modelica_metatype _Kelvin)
{
  modelica_real tmp1;
  modelica_real _Celsius;
  modelica_metatype out_Celsius;
  tmp1 = mmc_unbox_real(_Kelvin);
  _Celsius = omc_Modelica_SIunits_Conversions_to__degC(threadData, tmp1);
  out_Celsius = mmc_mk_rcon(_Celsius);
  return out_Celsius;
}

void omc_Modelica_Utilities_Streams_error(threadData_t *threadData, modelica_string _string)
{
  ModelicaError(MMC_STRINGDATA(_string));
  return;
}

DLLExport
modelica_boolean omc_Modelica_Utilities_Strings_isEmpty(threadData_t *threadData, modelica_string _string)
{
  modelica_boolean _result;
  modelica_integer _nextIndex;
  modelica_integer _len;
  _tailrecursive: OMC_LABEL_UNUSED
  // _result has no default value.
  // _nextIndex has no default value.
  // _len has no default value.
  _nextIndex = omc_Modelica_Utilities_Strings_Advanced_skipWhiteSpace(threadData, _string, ((modelica_integer) 1));

  _len = omc_Modelica_Utilities_Strings_length(threadData, _string);

  if(((_len < ((modelica_integer) 1)) || (_nextIndex > _len)))
  {
    _result = 1;
  }
  else
  {
    _result = 0;
  }
  _return: OMC_LABEL_UNUSED
  return _result;
}
modelica_metatype boxptr_Modelica_Utilities_Strings_isEmpty(threadData_t *threadData, modelica_metatype _string)
{
  modelica_boolean _result;
  modelica_metatype out_result;
  _result = omc_Modelica_Utilities_Strings_isEmpty(threadData, _string);
  out_result = mmc_mk_icon(_result);
  return out_result;
}

modelica_integer omc_Modelica_Utilities_Strings_length(threadData_t *threadData, modelica_string _string)
{
  int _result_ext;
  modelica_integer _result;
  // _result has no default value.
  _result_ext = ModelicaStrings_length(MMC_STRINGDATA(_string));
  _result = (modelica_integer)_result_ext;
  return _result;
}
modelica_metatype boxptr_Modelica_Utilities_Strings_length(threadData_t *threadData, modelica_metatype _string)
{
  modelica_integer _result;
  modelica_metatype out_result;
  _result = omc_Modelica_Utilities_Strings_length(threadData, _string);
  out_result = mmc_mk_icon(_result);
  return out_result;
}

modelica_integer omc_Modelica_Utilities_Strings_Advanced_skipWhiteSpace(threadData_t *threadData, modelica_string _string, modelica_integer _startIndex)
{
  int _startIndex_ext;
  int _nextIndex_ext;
  modelica_integer _nextIndex;
  // _nextIndex has no default value.
  _startIndex_ext = (int)_startIndex;
  _nextIndex_ext = ModelicaStrings_skipWhiteSpace(MMC_STRINGDATA(_string), _startIndex_ext);
  _nextIndex = (modelica_integer)_nextIndex_ext;
  return _nextIndex;
}
modelica_metatype boxptr_Modelica_Utilities_Strings_Advanced_skipWhiteSpace(threadData_t *threadData, modelica_metatype _string, modelica_metatype _startIndex)
{
  modelica_integer tmp1;
  modelica_integer _nextIndex;
  modelica_metatype out_nextIndex;
  tmp1 = mmc_unbox_integer(_startIndex);
  _nextIndex = omc_Modelica_Utilities_Strings_Advanced_skipWhiteSpace(threadData, _string, tmp1);
  out_nextIndex = mmc_mk_icon(_nextIndex);
  return out_nextIndex;
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

DLLExport
modelica_real omc_SolarTherm_Models_CSP_CRS_function__1(threadData_t *threadData, modelica_real _eCta)
{
  modelica_real _result;
  _tailrecursive: OMC_LABEL_UNUSED
  // _result has no default value.
  _result = 1.0 + (1.0 + _eCta) * ((real_int_pow(threadData, _eCta, -2)) * (exp((-_eCta)))) - (real_int_pow(threadData, _eCta, -2));
  _return: OMC_LABEL_UNUSED
  return _result;
}
modelica_metatype boxptr_SolarTherm_Models_CSP_CRS_function__1(threadData_t *threadData, modelica_metatype _eCta)
{
  modelica_real tmp1;
  modelica_real _result;
  modelica_metatype out_result;
  tmp1 = mmc_unbox_real(_eCta);
  _result = omc_SolarTherm_Models_CSP_CRS_function__1(threadData, tmp1);
  out_result = mmc_mk_rcon(_result);
  return out_result;
}

SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_FluidConstants omc_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_FluidConstants(threadData_t *threadData, modelica_string omc_iupacName, modelica_string omc_casRegistryNumber, modelica_string omc_chemicalFormula, modelica_string omc_structureFormula, modelica_real omc_molarMass, modelica_real omc_criticalTemperature, modelica_real omc_criticalPressure, modelica_real omc_criticalMolarVolume, modelica_real omc_acentricFactor, modelica_real omc_meltingPoint, modelica_real omc_normalBoilingPoint, modelica_real omc_dipoleMoment, modelica_boolean omc_hasIdealGasHeatCapacity, modelica_boolean omc_hasCriticalData, modelica_boolean omc_hasDipoleMoment, modelica_boolean omc_hasFundamentalEquation, modelica_boolean omc_hasLiquidHeatCapacity, modelica_boolean omc_hasSolidHeatCapacity, modelica_boolean omc_hasAccurateViscosityData, modelica_boolean omc_hasAccurateConductivityData, modelica_boolean omc_hasVapourPressureCurve, modelica_boolean omc_hasAcentricFactor, modelica_real omc_HCRIT0, modelica_real omc_SCRIT0, modelica_real omc_deltah, modelica_real omc_deltas)
{
  SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_FluidConstants tmp1;
  tmp1._iupacName = omc_iupacName;
  tmp1._casRegistryNumber = omc_casRegistryNumber;
  tmp1._chemicalFormula = omc_chemicalFormula;
  tmp1._structureFormula = omc_structureFormula;
  tmp1._molarMass = omc_molarMass;
  tmp1._criticalTemperature = omc_criticalTemperature;
  tmp1._criticalPressure = omc_criticalPressure;
  tmp1._criticalMolarVolume = omc_criticalMolarVolume;
  tmp1._acentricFactor = omc_acentricFactor;
  tmp1._meltingPoint = omc_meltingPoint;
  tmp1._normalBoilingPoint = omc_normalBoilingPoint;
  tmp1._dipoleMoment = omc_dipoleMoment;
  tmp1._hasIdealGasHeatCapacity = omc_hasIdealGasHeatCapacity;
  tmp1._hasCriticalData = omc_hasCriticalData;
  tmp1._hasDipoleMoment = omc_hasDipoleMoment;
  tmp1._hasFundamentalEquation = omc_hasFundamentalEquation;
  tmp1._hasLiquidHeatCapacity = omc_hasLiquidHeatCapacity;
  tmp1._hasSolidHeatCapacity = omc_hasSolidHeatCapacity;
  tmp1._hasAccurateViscosityData = omc_hasAccurateViscosityData;
  tmp1._hasAccurateConductivityData = omc_hasAccurateConductivityData;
  tmp1._hasVapourPressureCurve = omc_hasVapourPressureCurve;
  tmp1._hasAcentricFactor = omc_hasAcentricFactor;
  tmp1._HCRIT0 = omc_HCRIT0;
  tmp1._SCRIT0 = omc_SCRIT0;
  tmp1._deltah = omc_deltah;
  tmp1._deltas = omc_deltas;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_FluidConstants(threadData_t *threadData, modelica_metatype _iupacName, modelica_metatype _casRegistryNumber, modelica_metatype _chemicalFormula, modelica_metatype _structureFormula, modelica_metatype _molarMass, modelica_metatype _criticalTemperature, modelica_metatype _criticalPressure, modelica_metatype _criticalMolarVolume, modelica_metatype _acentricFactor, modelica_metatype _meltingPoint, modelica_metatype _normalBoilingPoint, modelica_metatype _dipoleMoment, modelica_metatype _hasIdealGasHeatCapacity, modelica_metatype _hasCriticalData, modelica_metatype _hasDipoleMoment, modelica_metatype _hasFundamentalEquation, modelica_metatype _hasLiquidHeatCapacity, modelica_metatype _hasSolidHeatCapacity, modelica_metatype _hasAccurateViscosityData, modelica_metatype _hasAccurateConductivityData, modelica_metatype _hasVapourPressureCurve, modelica_metatype _hasAcentricFactor, modelica_metatype _HCRIT0, modelica_metatype _SCRIT0, modelica_metatype _deltah, modelica_metatype _deltas)
{
  return mmc_mk_box(27, 3, &SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_FluidConstants__desc, _iupacName, _casRegistryNumber, _chemicalFormula, _structureFormula, _molarMass, _criticalTemperature, _criticalPressure, _criticalMolarVolume, _acentricFactor, _meltingPoint, _normalBoilingPoint, _dipoleMoment, _hasIdealGasHeatCapacity, _hasCriticalData, _hasDipoleMoment, _hasFundamentalEquation, _hasLiquidHeatCapacity, _hasSolidHeatCapacity, _hasAccurateViscosityData, _hasAccurateConductivityData, _hasVapourPressureCurve, _hasAcentricFactor, _HCRIT0, _SCRIT0, _deltah, _deltas);
}

SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState omc_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_T)
{
  SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._T = omc_T;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _T)
{
  return mmc_mk_box3(3, &SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState__desc, _p, _T);
}

DLLExport
modelica_real omc_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_dynamicViscosity(threadData_t *threadData, SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState _state)
{
  modelica_real _eta;
  _tailrecursive: OMC_LABEL_UNUSED
  // _eta has no default value.
  _eta = (1e-06) * (omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluateWithRange(threadData, _OMC_LIT27, -150.0, 1000.0, omc_Modelica_SIunits_Conversions_to__degC(threadData, _state._T)));
  _return: OMC_LABEL_UNUSED
  return _eta;
}
modelica_metatype boxptr_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_dynamicViscosity(threadData_t *threadData, modelica_metatype _state)
{
  SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _eta;
  modelica_metatype out_eta;
  modelica_metatype tmpMeta[2] __attribute__((unused)) = {0};
  tmpMeta[0] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 2)));
  tmp2 = mmc_unbox_real(tmpMeta[0]);
  tmp1._p = tmp2;
  tmpMeta[1] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 3)));
  tmp3 = mmc_unbox_real(tmpMeta[1]);
  tmp1._T = tmp3;
  _eta = omc_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_dynamicViscosity(threadData, tmp1);
  out_eta = mmc_mk_rcon(_eta);
  return out_eta;
}

DLLExport
modelica_real omc_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_thermalConductivity(threadData_t *threadData, SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState _state, modelica_integer _method)
{
  modelica_real _lambda;
  _tailrecursive: OMC_LABEL_UNUSED
  // _lambda has no default value.
  _lambda = (0.001) * (omc_Modelica_Media_Incompressible_TableBased_Polynomials__Temp_evaluateWithRange(threadData, _OMC_LIT30, -150.0, 1000.0, omc_Modelica_SIunits_Conversions_to__degC(threadData, _state._T)));
  _return: OMC_LABEL_UNUSED
  return _lambda;
}
modelica_metatype boxptr_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_thermalConductivity(threadData_t *threadData, modelica_metatype _state, modelica_metatype _method)
{
  SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_ThermodynamicState tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_integer tmp4;
  modelica_real _lambda;
  modelica_metatype out_lambda;
  modelica_metatype tmpMeta[2] __attribute__((unused)) = {0};
  tmpMeta[0] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 2)));
  tmp2 = mmc_unbox_real(tmpMeta[0]);
  tmp1._p = tmp2;
  tmpMeta[1] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_state), 3)));
  tmp3 = mmc_unbox_real(tmpMeta[1]);
  tmp1._T = tmp3;tmp4 = mmc_unbox_integer(_method);
  _lambda = omc_SolarTherm_Models_CSP_CRS_Receivers__omcQuot_5061727469636C6552656365697665723144247061727469636C6552656365697665723144_MedAir_DryAirNasa_thermalConductivity(threadData, tmp1, tmp4);
  out_lambda = mmc_mk_rcon(_lambda);
  return out_lambda;
}

#ifdef __cplusplus
}
#endif
