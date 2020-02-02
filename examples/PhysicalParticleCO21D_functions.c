#include "omc_simulation_settings.h"
#include "PhysicalParticleCO21D_functions.h"
#ifdef __cplusplus
extern "C" {
#endif

#include "PhysicalParticleCO21D_includes.h"


modelica_real omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getNextTimeEvent(threadData_t *threadData, modelica_complex _tableID, modelica_real _timeIn, modelica_real _tableAvailable)
{
  void * _tableID_ext;
  double _timeIn_ext;
  double _nextTimeEvent_ext;
  modelica_real _nextTimeEvent;
  // _nextTimeEvent has no default value.
  _tableID_ext = (void *)_tableID;

  _timeIn_ext = (double)_timeIn;
  _nextTimeEvent_ext = ModelicaStandardTables_CombiTimeTable_nextTimeEvent(_tableID_ext, _timeIn_ext);
  _nextTimeEvent = (modelica_real)_nextTimeEvent_ext;
  return _nextTimeEvent;
}
modelica_metatype boxptr_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getNextTimeEvent(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _timeIn, modelica_metatype _tableAvailable)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real _nextTimeEvent;
  modelica_metatype out_nextTimeEvent;
  tmp1 = mmc_unbox_real(_timeIn);
  tmp2 = mmc_unbox_real(_tableAvailable);
  _nextTimeEvent = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getNextTimeEvent(threadData, _tableID, tmp1, tmp2);
  out_nextTimeEvent = mmc_mk_rcon(_nextTimeEvent);
  return out_nextTimeEvent;
}

modelica_real omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableTimeTmax(threadData_t *threadData, modelica_complex _tableID, modelica_real _tableAvailable)
{
  void * _tableID_ext;
  double _timeMax_ext;
  modelica_real _timeMax;
  // _timeMax has no default value.
  _tableID_ext = (void *)_tableID;
  _timeMax_ext = ModelicaStandardTables_CombiTimeTable_maximumTime(_tableID_ext);
  _timeMax = (modelica_real)_timeMax_ext;
  return _timeMax;
}
modelica_metatype boxptr_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableTimeTmax(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _tableAvailable)
{
  modelica_real tmp1;
  modelica_real _timeMax;
  modelica_metatype out_timeMax;
  tmp1 = mmc_unbox_real(_tableAvailable);
  _timeMax = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableTimeTmax(threadData, _tableID, tmp1);
  out_timeMax = mmc_mk_rcon(_timeMax);
  return out_timeMax;
}

modelica_real omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableTimeTmin(threadData_t *threadData, modelica_complex _tableID, modelica_real _tableAvailable)
{
  void * _tableID_ext;
  double _timeMin_ext;
  modelica_real _timeMin;
  // _timeMin has no default value.
  _tableID_ext = (void *)_tableID;
  _timeMin_ext = ModelicaStandardTables_CombiTimeTable_minimumTime(_tableID_ext);
  _timeMin = (modelica_real)_timeMin_ext;
  return _timeMin;
}
modelica_metatype boxptr_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableTimeTmin(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _tableAvailable)
{
  modelica_real tmp1;
  modelica_real _timeMin;
  modelica_metatype out_timeMin;
  tmp1 = mmc_unbox_real(_tableAvailable);
  _timeMin = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableTimeTmin(threadData, _tableID, tmp1);
  out_timeMin = mmc_mk_rcon(_timeMin);
  return out_timeMin;
}

modelica_real omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData_t *threadData, modelica_complex _tableID, modelica_integer _icol, modelica_real _timeIn, modelica_real _nextTimeEvent, modelica_real _pre_nextTimeEvent, modelica_real _tableAvailable)
{
  void * _tableID_ext;
  int _icol_ext;
  double _timeIn_ext;
  double _nextTimeEvent_ext;
  double _pre_nextTimeEvent_ext;
  double _y_ext;
  modelica_real _y;
  // _y has no default value.
  _tableID_ext = (void *)_tableID;

  _icol_ext = (int)_icol;

  _timeIn_ext = (double)_timeIn;

  _nextTimeEvent_ext = (double)_nextTimeEvent;

  _pre_nextTimeEvent_ext = (double)_pre_nextTimeEvent;
  _y_ext = ModelicaStandardTables_CombiTimeTable_getValue(_tableID_ext, _icol_ext, _timeIn_ext, _nextTimeEvent_ext, _pre_nextTimeEvent_ext);
  _y = (modelica_real)_y_ext;
  return _y;
}
modelica_metatype boxptr_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _icol, modelica_metatype _timeIn, modelica_metatype _nextTimeEvent, modelica_metatype _pre_nextTimeEvent, modelica_metatype _tableAvailable)
{
  modelica_integer tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_real tmp5;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_integer(_icol);
  tmp2 = mmc_unbox_real(_timeIn);
  tmp3 = mmc_unbox_real(_nextTimeEvent);
  tmp4 = mmc_unbox_real(_pre_nextTimeEvent);
  tmp5 = mmc_unbox_real(_tableAvailable);
  _y = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_getTableValue(threadData, _tableID, tmp1, tmp2, tmp3, tmp4, tmp5);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

modelica_real omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_readTableData(threadData_t *threadData, modelica_complex _tableID, modelica_boolean _forceRead, modelica_boolean _verboseRead)
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
  _readSuccess_ext = ModelicaStandardTables_CombiTimeTable_read(_tableID_ext, _forceRead_ext, _verboseRead_ext);
  _readSuccess = (modelica_real)_readSuccess_ext;
  return _readSuccess;
}
modelica_metatype boxptr_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_readTableData(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _forceRead, modelica_metatype _verboseRead)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_real _readSuccess;
  modelica_metatype out_readSuccess;
  tmp1 = mmc_unbox_integer(_forceRead);
  tmp2 = mmc_unbox_integer(_verboseRead);
  _readSuccess = omc_Modelica_Blocks_Sources_D_CombiTimeTable24data24table_readTableData(threadData, _tableID, tmp1, tmp2);
  out_readSuccess = mmc_mk_rcon(_readSuccess);
  return out_readSuccess;
}

modelica_real omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1D24Tab_getTableValue(threadData_t *threadData, modelica_complex _tableID, modelica_integer _icol, modelica_real _u, modelica_real _tableAvailable)
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
modelica_metatype boxptr_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1D24Tab_getTableValue(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _icol, modelica_metatype _u, modelica_metatype _tableAvailable)
{
  modelica_integer tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_integer(_icol);
  tmp2 = mmc_unbox_real(_u);
  tmp3 = mmc_unbox_real(_tableAvailable);
  _y = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1D24Tab_getTableValue(threadData, _tableID, tmp1, tmp2, tmp3);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

modelica_real omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1D24Tab_readTableData(threadData_t *threadData, modelica_complex _tableID, modelica_boolean _forceRead, modelica_boolean _verboseRead)
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
modelica_metatype boxptr_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1D24Tab_readTableData(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _forceRead, modelica_metatype _verboseRead)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_real _readSuccess;
  modelica_metatype out_readSuccess;
  tmp1 = mmc_unbox_integer(_forceRead);
  tmp2 = mmc_unbox_integer(_verboseRead);
  _readSuccess = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1D24Tab_readTableData(threadData, _tableID, tmp1, tmp2);
  out_readSuccess = mmc_mk_rcon(_readSuccess);
  return out_readSuccess;
}

modelica_real omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_getTableValue(threadData_t *threadData, modelica_complex _tableID, modelica_integer _icol, modelica_real _u, modelica_real _tableAvailable)
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
modelica_metatype boxptr_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_getTableValue(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _icol, modelica_metatype _u, modelica_metatype _tableAvailable)
{
  modelica_integer tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_integer(_icol);
  tmp2 = mmc_unbox_real(_u);
  tmp3 = mmc_unbox_real(_tableAvailable);
  _y = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_getTableValue(threadData, _tableID, tmp1, tmp2, tmp3);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

modelica_real omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_readTableData(threadData_t *threadData, modelica_complex _tableID, modelica_boolean _forceRead, modelica_boolean _verboseRead)
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
modelica_metatype boxptr_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_readTableData(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _forceRead, modelica_metatype _verboseRead)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_real _readSuccess;
  modelica_metatype out_readSuccess;
  tmp1 = mmc_unbox_integer(_forceRead);
  tmp2 = mmc_unbox_integer(_verboseRead);
  _readSuccess = omc_Modelica_Blocks_Tables_D_CombiTable1Ds24particleReceiver1DCalculator24particleReceiver1D__v1124Tab_readTableData(threadData, _tableID, tmp1, tmp2);
  out_readSuccess = mmc_mk_rcon(_readSuccess);
  return out_readSuccess;
}

modelica_real omc_Modelica_Blocks_Tables_D_CombiTable2D24heliostatsField24optical24nu__table_getTableValue(threadData_t *threadData, modelica_complex _tableID, modelica_real _u1, modelica_real _u2, modelica_real _tableAvailable)
{
  void * _tableID_ext;
  double _u1_ext;
  double _u2_ext;
  double _y_ext;
  modelica_real _y;
  // _y has no default value.
  _tableID_ext = (void *)_tableID;

  _u1_ext = (double)_u1;

  _u2_ext = (double)_u2;
  _y_ext = ModelicaStandardTables_CombiTable2D_getValue(_tableID_ext, _u1_ext, _u2_ext);
  _y = (modelica_real)_y_ext;
  return _y;
}
modelica_metatype boxptr_Modelica_Blocks_Tables_D_CombiTable2D24heliostatsField24optical24nu__table_getTableValue(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _u1, modelica_metatype _u2, modelica_metatype _tableAvailable)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_real(_u1);
  tmp2 = mmc_unbox_real(_u2);
  tmp3 = mmc_unbox_real(_tableAvailable);
  _y = omc_Modelica_Blocks_Tables_D_CombiTable2D24heliostatsField24optical24nu__table_getTableValue(threadData, _tableID, tmp1, tmp2, tmp3);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

modelica_real omc_Modelica_Blocks_Tables_D_CombiTable2D24heliostatsField24optical24nu__table_readTableData(threadData_t *threadData, modelica_complex _tableID, modelica_boolean _forceRead, modelica_boolean _verboseRead)
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
  _readSuccess_ext = ModelicaStandardTables_CombiTable2D_read(_tableID_ext, _forceRead_ext, _verboseRead_ext);
  _readSuccess = (modelica_real)_readSuccess_ext;
  return _readSuccess;
}
modelica_metatype boxptr_Modelica_Blocks_Tables_D_CombiTable2D24heliostatsField24optical24nu__table_readTableData(threadData_t *threadData, modelica_metatype _tableID, modelica_metatype _forceRead, modelica_metatype _verboseRead)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_real _readSuccess;
  modelica_metatype out_readSuccess;
  tmp1 = mmc_unbox_integer(_forceRead);
  tmp2 = mmc_unbox_integer(_verboseRead);
  _readSuccess = omc_Modelica_Blocks_Tables_D_CombiTable2D24heliostatsField24optical24nu__table_readTableData(threadData, _tableID, tmp1, tmp2);
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

modelica_complex omc_Modelica_Blocks_Types_ExternalCombiTimeTable_constructor(threadData_t *threadData, modelica_string _tableName, modelica_string _fileName, real_array _table, modelica_real _startTime, integer_array _columns, modelica_integer _smoothness, modelica_integer _extrapolation)
{
  double _startTime_ext;
  integer_array _columns_packed;
  int _smoothness_ext;
  int _extrapolation_ext;
  void *_table_c89;
  void *_columns_c89;
  void * _externalCombiTimeTable_ext;
  modelica_complex _externalCombiTimeTable;
  // _externalCombiTimeTable has no default value.
  _startTime_ext = (double)_startTime;

  pack_alloc_integer_array(&_columns, &_columns_packed);

  _smoothness_ext = (int)_smoothness;

  _extrapolation_ext = (int)_extrapolation;
  _table_c89 = (void*) data_of_real_c89_array(&(_table));
  _columns_c89 = (void*) data_of_integer_c89_array(&(_columns_packed));
  _externalCombiTimeTable_ext = ModelicaStandardTables_CombiTimeTable_init(MMC_STRINGDATA(_tableName), MMC_STRINGDATA(_fileName), (const double*) _table_c89, size_of_dimension_base_array(_table, ((modelica_integer) 1)), size_of_dimension_base_array(_table, ((modelica_integer) 2)), _startTime_ext, (const int*) _columns_c89, size_of_dimension_base_array(_columns, ((modelica_integer) 1)), _smoothness_ext, _extrapolation_ext);
  _externalCombiTimeTable = (modelica_complex)_externalCombiTimeTable_ext;
  return _externalCombiTimeTable;
}
modelica_metatype boxptr_Modelica_Blocks_Types_ExternalCombiTimeTable_constructor(threadData_t *threadData, modelica_metatype _tableName, modelica_metatype _fileName, modelica_metatype _table, modelica_metatype _startTime, modelica_metatype _columns, modelica_metatype _smoothness, modelica_metatype _extrapolation)
{
  modelica_real tmp1;
  modelica_integer tmp2;
  modelica_integer tmp3;
  modelica_complex _externalCombiTimeTable;
  tmp1 = mmc_unbox_real(_startTime);
  tmp2 = mmc_unbox_integer(_smoothness);
  tmp3 = mmc_unbox_integer(_extrapolation);
  _externalCombiTimeTable = omc_Modelica_Blocks_Types_ExternalCombiTimeTable_constructor(threadData, _tableName, _fileName, *((base_array_t*)_table), tmp1, *((base_array_t*)_columns), tmp2, tmp3);
  /* skip box _externalCombiTimeTable; ExternalObject Modelica.Blocks.Types.ExternalCombiTimeTable */
  return _externalCombiTimeTable;
}

void omc_Modelica_Blocks_Types_ExternalCombiTimeTable_destructor(threadData_t *threadData, modelica_complex _externalCombiTimeTable)
{
  void * _externalCombiTimeTable_ext;
  _externalCombiTimeTable_ext = (void *)_externalCombiTimeTable;
  ModelicaStandardTables_CombiTimeTable_close(_externalCombiTimeTable_ext);
  return;
}
void boxptr_Modelica_Blocks_Types_ExternalCombiTimeTable_destructor(threadData_t *threadData, modelica_metatype _externalCombiTimeTable)
{
  omc_Modelica_Blocks_Types_ExternalCombiTimeTable_destructor(threadData, _externalCombiTimeTable);
  return;
}

Modelica_Fluid_Interfaces_D_FluidPort__a24LiftCold24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24LiftCold24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24LiftCold24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24LiftCold24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24LiftCold24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24liftHX24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24liftHX24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24liftHX24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24liftHX24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24liftHX24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24liftRC24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24liftRC24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24liftRC24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24liftRC24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24liftRC24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1D24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1D24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1D24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1D24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1D24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24liftSimple24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24liftSimple24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24liftSimple24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24liftSimple24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24liftSimple24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__comp__port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__comp__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__comp__port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__comp__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__comp__port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__turb__port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__turb__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__turb__port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__turb__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24HTR24from__turb__port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__comp__port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__comp__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__comp__port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__comp__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__comp__port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__turb__port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__turb__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__turb__port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__turb__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24LTR24from__turb__port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24cooler24port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24cooler24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24cooler24port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24cooler24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24cooler24port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24CO2__port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24CO2__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24CO2__port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24CO2__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24CO2__port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24HTF__port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24HTF__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24HTF__port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24HTF__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24exchanger24HTF__port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mainCompressor24port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mainCompressor24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mainCompressor24port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mainCompressor24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mainCompressor24port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24first__port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24first__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24first__port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24first__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24first__port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24second__port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24second__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24second__port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24second__port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24mixer24second__port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24reCompressor24port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24reCompressor24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24reCompressor24port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24reCompressor24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24reCompressor24port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24splitter24port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24splitter24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24splitter24port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24splitter24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24splitter24port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24turbine24port__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24turbine24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24turbine24port__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24turbine24port__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24powerBlock24turbine24port__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24tankCold24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24tankCold24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24tankCold24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24tankCold24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24tankCold24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24tankHot24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24tankHot24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24tankHot24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24tankHot24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24tankHot24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__a24temperature24fluid__a_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__a24temperature24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__a24temperature24fluid__a_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__a24temperature24fluid__a_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__a24temperature24fluid__a_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24LiftCold24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24LiftCold24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24LiftCold24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24LiftCold24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24LiftCold24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24liftHX24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24liftHX24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24liftHX24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24liftHX24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24liftHX24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24liftRC24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24liftRC24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24liftRC24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24liftRC24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24liftRC24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1D24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1D24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1D24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1D24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1D24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24liftSimple24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24liftSimple24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24liftSimple24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24liftSimple24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24liftSimple24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24particleReceiver1DCalculator24particleReceiver1D__v1124fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__comp__port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__comp__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__comp__port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__comp__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__comp__port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__turb__port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__turb__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__turb__port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__turb__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24HTR24from__turb__port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__comp__port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__comp__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__comp__port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__comp__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__comp__port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__turb__port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__turb__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__turb__port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__turb__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24LTR24from__turb__port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24cooler24port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24cooler24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24cooler24port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24cooler24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24cooler24port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24CO2__port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24CO2__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24CO2__port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24CO2__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24CO2__port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24HTF__port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24HTF__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24HTF__port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24HTF__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24exchanger24HTF__port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mainCompressor24port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mainCompressor24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mainCompressor24port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mainCompressor24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mainCompressor24port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mixer24port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mixer24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mixer24port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mixer24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24mixer24port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24reCompressor24port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24reCompressor24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24reCompressor24port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24reCompressor24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24reCompressor24port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24gamma__port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24gamma__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24gamma__port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24gamma__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24gamma__port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24one__gamma__port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24one__gamma__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24one__gamma__port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24one__gamma__port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24splitter24one__gamma__port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24turbine24port__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24turbine24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24turbine24port__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24turbine24port__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24powerBlock24turbine24port__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24tankCold24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24tankCold24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24tankCold24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24tankCold24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24tankCold24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24tankHot24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24tankHot24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24tankHot24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24tankHot24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24tankHot24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPort__b24temperature24fluid__b_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPort__b24temperature24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPort__b24temperature24fluid__b_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPort__b24temperature24fluid__b_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPort__b24temperature24fluid__b_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24sink24ports_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24sink24ports_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24sink24ports_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24sink24ports_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24sink24ports_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24source24ports_Medium_ThermodynamicState omc_Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24source24ports_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24source24ports_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24source24ports_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Interfaces_D_FluidPorts__b24particleReceiver1DCalculator24source24ports_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24sink_Medium_ThermodynamicState omc_Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24sink_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24sink_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24sink_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24sink_Medium_ThermodynamicState__desc, _p, _h);
}

Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24source_Medium_ThermodynamicState omc_Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24source_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24source_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24source_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &Modelica_Fluid_Sources_D_FixedBoundary24particleReceiver1DCalculator24source_Medium_ThermodynamicState__desc, _p, _h);
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
      tmpMeta[0] = stringAppend(_OMC_LIT7,_modelName);
      tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT8);
      tmpMeta[2] = stringAppend(tmpMeta[1],_mediumName);
      tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT9);
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
          tmpMeta[0] = stringAppend(_OMC_LIT10,_mediumName);
          tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT11);
          tmpMeta[2] = stringAppend(tmpMeta[1],_modelName);
          tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT12);
          tmp3 = modelica_integer_to_modelica_string(_i, ((modelica_integer) 0), 1);
          tmpMeta[4] = stringAppend(tmpMeta[3],tmp3);
          tmpMeta[5] = stringAppend(tmpMeta[4],_OMC_LIT13);
          tmp4 = modelica_real_to_modelica_string((*real_array_element_addr1(&_X_boundary, 1, _i)), ((modelica_integer) 6), ((modelica_integer) 0), 1);
          tmpMeta[6] = stringAppend(tmpMeta[5],tmp4);
          tmpMeta[7] = stringAppend(tmpMeta[6],_OMC_LIT14);
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
    _X_str = _OMC_LIT15;

    tmp11 = ((modelica_integer) 1); tmp12 = 1; tmp13 = _nX;
    if(!(((tmp12 > 0) && (tmp11 > tmp13)) || ((tmp12 < 0) && (tmp11 < tmp13))))
    {
      modelica_integer _i;
      for(_i = ((modelica_integer) 1); in_range_integer(_i, tmp11, tmp13); _i += tmp12)
      {
        tmpMeta[0] = stringAppend(_X_str,_OMC_LIT16);
        tmp9 = modelica_integer_to_modelica_string(_i, ((modelica_integer) 0), 1);
        tmpMeta[1] = stringAppend(tmpMeta[0],tmp9);
        tmpMeta[2] = stringAppend(tmpMeta[1],_OMC_LIT17);
        tmp10 = modelica_real_to_modelica_string((*real_array_element_addr1(&_X_boundary, 1, _i)), ((modelica_integer) 6), ((modelica_integer) 0), 1);
        tmpMeta[3] = stringAppend(tmpMeta[2],tmp10);
        tmpMeta[4] = stringAppend(tmpMeta[3],_OMC_LIT18);
        tmpMeta[5] = stringAppend(tmpMeta[4],(*string_array_element_addr1(&_substanceNames, 1, _i)));
        tmpMeta[6] = stringAppend(tmpMeta[5],_OMC_LIT19);
        _X_str = tmpMeta[6];
      }
    }

    tmpMeta[0] = stringAppend(_OMC_LIT20,_mediumName);
    tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT11);
    tmpMeta[2] = stringAppend(tmpMeta[1],_modelName);
    tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT19);
    tmpMeta[4] = stringAppend(tmpMeta[3],_OMC_LIT21);
    tmp14 = modelica_real_to_modelica_string(sum_real_array(_X_boundary), ((modelica_integer) 6), ((modelica_integer) 0), 1);
    tmpMeta[5] = stringAppend(tmpMeta[4],tmp14);
    tmpMeta[6] = stringAppend(tmpMeta[5],_OMC_LIT22);
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

DLLExport
modelica_real omc_Modelica_SIunits_Conversions_from__deg(threadData_t *threadData, modelica_real _degree)
{
  modelica_real _radian;
  _tailrecursive: OMC_LABEL_UNUSED
  // _radian has no default value.
  _radian = (0.0174532925199433) * (_degree);
  _return: OMC_LABEL_UNUSED
  return _radian;
}
modelica_metatype boxptr_Modelica_SIunits_Conversions_from__deg(threadData_t *threadData, modelica_metatype _degree)
{
  modelica_real tmp1;
  modelica_real _radian;
  modelica_metatype out_radian;
  tmp1 = mmc_unbox_real(_degree);
  _radian = omc_Modelica_SIunits_Conversions_from__deg(threadData, tmp1);
  out_radian = mmc_mk_rcon(_radian);
  return out_radian;
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

void omc_Modelica_Utilities_Streams_close(threadData_t *threadData, modelica_string _fileName)
{
  ModelicaStreams_closeFile(MMC_STRINGDATA(_fileName));
  return;
}

void omc_Modelica_Utilities_Streams_error(threadData_t *threadData, modelica_string _string)
{
  ModelicaError(MMC_STRINGDATA(_string));
  return;
}

modelica_string omc_Modelica_Utilities_Streams_readLine(threadData_t *threadData, modelica_string _fileName, modelica_integer _lineNumber, modelica_boolean *out_endOfFile)
{
  int _lineNumber_ext;
  int _endOfFile_ext;
  const char* _string_ext;
  modelica_string _string = NULL;
  modelica_boolean _endOfFile;
  // _string has no default value.
  // _endOfFile has no default value.
  _lineNumber_ext = (int)_lineNumber;
  _string_ext = ModelicaInternal_readLine(MMC_STRINGDATA(_fileName), _lineNumber_ext, &_endOfFile_ext);
  _endOfFile = (modelica_boolean)_endOfFile_ext;
  _string = (modelica_string)mmc_mk_scon(_string_ext);
  if (out_endOfFile) { *out_endOfFile = _endOfFile; }
  return _string;
}
modelica_metatype boxptr_Modelica_Utilities_Streams_readLine(threadData_t *threadData, modelica_metatype _fileName, modelica_metatype _lineNumber, modelica_metatype *out_endOfFile)
{
  modelica_integer tmp1;
  modelica_boolean _endOfFile;
  modelica_string _string = NULL;
  tmp1 = mmc_unbox_integer(_lineNumber);
  _string = omc_Modelica_Utilities_Streams_readLine(threadData, _fileName, tmp1, &_endOfFile);
  /* skip box _string; String */
  if (out_endOfFile) { *out_endOfFile = mmc_mk_icon(_endOfFile); }
  return _string;
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

DLLExport
modelica_string omc_Modelica_Utilities_Strings_repeat(threadData_t *threadData, modelica_integer _n, modelica_string _string)
{
  modelica_string _repeatedString = NULL;
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_integer tmp3;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  _tailrecursive: OMC_LABEL_UNUSED
  // _repeatedString has no default value.
  _repeatedString = _OMC_LIT15;

  tmp1 = ((modelica_integer) 1); tmp2 = 1; tmp3 = _n;
  if(!(((tmp2 > 0) && (tmp1 > tmp3)) || ((tmp2 < 0) && (tmp1 < tmp3))))
  {
    modelica_integer _i;
    for(_i = ((modelica_integer) 1); in_range_integer(_i, tmp1, tmp3); _i += tmp2)
    {
      tmpMeta[0] = stringAppend(_repeatedString,_string);
      _repeatedString = tmpMeta[0];
    }
  }
  _return: OMC_LABEL_UNUSED
  return _repeatedString;
}
modelica_metatype boxptr_Modelica_Utilities_Strings_repeat(threadData_t *threadData, modelica_metatype _n, modelica_metatype _string)
{
  modelica_integer tmp1;
  modelica_string _repeatedString = NULL;
  tmp1 = mmc_unbox_integer(_n);
  _repeatedString = omc_Modelica_Utilities_Strings_repeat(threadData, tmp1, _string);
  /* skip box _repeatedString; String */
  return _repeatedString;
}

DLLExport
modelica_real omc_Modelica_Utilities_Strings_scanReal(threadData_t *threadData, modelica_string _string, modelica_integer _startIndex, modelica_boolean _unsigned, modelica_string _message, modelica_integer *out_nextIndex)
{
  modelica_real _number;
  modelica_integer _nextIndex;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  _tailrecursive: OMC_LABEL_UNUSED
  // _number has no default value.
  // _nextIndex has no default value.
  _nextIndex = omc_Modelica_Utilities_Strings_Advanced_scanReal(threadData, _string, _startIndex, _unsigned ,&_number);

  if((_nextIndex == _startIndex))
  {
    _nextIndex = omc_Modelica_Utilities_Strings_Advanced_skipWhiteSpace(threadData, _string, _startIndex);

    if(_unsigned)
    {
      tmpMeta[0] = stringAppend(_OMC_LIT31,_message);
      omc_Modelica_Utilities_Strings_syntaxError(threadData, _string, _nextIndex, tmpMeta[0]);
    }
    else
    {
      tmpMeta[0] = stringAppend(_OMC_LIT30,_message);
      omc_Modelica_Utilities_Strings_syntaxError(threadData, _string, _nextIndex, tmpMeta[0]);
    }
  }
  _return: OMC_LABEL_UNUSED
  if (out_nextIndex) { *out_nextIndex = _nextIndex; }
  return _number;
}
modelica_metatype boxptr_Modelica_Utilities_Strings_scanReal(threadData_t *threadData, modelica_metatype _string, modelica_metatype _startIndex, modelica_metatype _unsigned, modelica_metatype _message, modelica_metatype *out_nextIndex)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_integer _nextIndex;
  modelica_real _number;
  modelica_metatype out_number;
  tmp1 = mmc_unbox_integer(_startIndex);
  tmp2 = mmc_unbox_integer(_unsigned);
  _number = omc_Modelica_Utilities_Strings_scanReal(threadData, _string, tmp1, tmp2, _message, &_nextIndex);
  out_number = mmc_mk_rcon(_number);
  if (out_nextIndex) { *out_nextIndex = mmc_mk_icon(_nextIndex); }
  return out_number;
}

modelica_string omc_Modelica_Utilities_Strings_substring(threadData_t *threadData, modelica_string _string, modelica_integer _startIndex, modelica_integer _endIndex)
{
  int _startIndex_ext;
  int _endIndex_ext;
  const char* _result_ext;
  modelica_string _result = NULL;
  // _result has no default value.
  _startIndex_ext = (int)_startIndex;

  _endIndex_ext = (int)_endIndex;
  _result_ext = ModelicaStrings_substring(MMC_STRINGDATA(_string), _startIndex_ext, _endIndex_ext);
  _result = (modelica_string)mmc_mk_scon(_result_ext);
  return _result;
}
modelica_metatype boxptr_Modelica_Utilities_Strings_substring(threadData_t *threadData, modelica_metatype _string, modelica_metatype _startIndex, modelica_metatype _endIndex)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_string _result = NULL;
  tmp1 = mmc_unbox_integer(_startIndex);
  tmp2 = mmc_unbox_integer(_endIndex);
  _result = omc_Modelica_Utilities_Strings_substring(threadData, _string, tmp1, tmp2);
  /* skip box _result; String */
  return _result;
}

DLLExport
void omc_Modelica_Utilities_Strings_syntaxError(threadData_t *threadData, modelica_string _string, modelica_integer _index, modelica_string _message)
{
  modelica_integer _maxIndex;
  modelica_integer _maxLenString;
  modelica_string _errString = NULL;
  modelica_integer _lenString;
  modelica_integer _index2;
  modelica_string tmp1;
  modelica_metatype tmpMeta[8] __attribute__((unused)) = {0};
  _tailrecursive: OMC_LABEL_UNUSED
  _maxIndex = ((modelica_integer) 40);
  _maxLenString = ((modelica_integer) 60);
  // _errString has no default value.
  _lenString = omc_Modelica_Utilities_Strings_length(threadData, _string);
  _index2 = ((_index < ((modelica_integer) 1))?((modelica_integer) 1):((_index > _lenString)?_lenString:_index));
  if((_index2 <= _maxIndex))
  {
    _errString = _string;
  }
  else
  {
    tmpMeta[0] = stringAppend(_OMC_LIT32,omc_Modelica_Utilities_Strings_substring(threadData, _string, _index2 - _maxIndex, _lenString));
    _errString = tmpMeta[0];

    _index2 = ((modelica_integer) 5) + _maxIndex;
  }

  if((omc_Modelica_Utilities_Strings_length(threadData, _errString) > _maxLenString))
  {
    tmpMeta[0] = stringAppend(omc_Modelica_Utilities_Strings_substring(threadData, _errString, ((modelica_integer) 1), _maxLenString),_OMC_LIT33);
    _errString = tmpMeta[0];
  }

  tmp1 = modelica_integer_to_modelica_string(_index, ((modelica_integer) 0), 1);
  tmpMeta[0] = stringAppend(_OMC_LIT34,tmp1);
  tmpMeta[1] = stringAppend(tmpMeta[0],_OMC_LIT35);
  tmpMeta[2] = stringAppend(tmpMeta[1],_errString);
  tmpMeta[3] = stringAppend(tmpMeta[2],_OMC_LIT36);
  tmpMeta[4] = stringAppend(tmpMeta[3],omc_Modelica_Utilities_Strings_repeat(threadData, ((modelica_integer) -1) + _index2, _OMC_LIT29));
  tmpMeta[5] = stringAppend(tmpMeta[4],_OMC_LIT37);
  tmpMeta[6] = stringAppend(tmpMeta[5],_OMC_LIT36);
  tmpMeta[7] = stringAppend(tmpMeta[6],_message);
  omc_Modelica_Utilities_Streams_error(threadData, tmpMeta[7]);
  _return: OMC_LABEL_UNUSED
  return;
}
void boxptr_Modelica_Utilities_Strings_syntaxError(threadData_t *threadData, modelica_metatype _string, modelica_metatype _index, modelica_metatype _message)
{
  modelica_integer tmp1;
  tmp1 = mmc_unbox_integer(_index);
  omc_Modelica_Utilities_Strings_syntaxError(threadData, _string, tmp1, _message);
  return;
}

modelica_integer omc_Modelica_Utilities_Strings_Advanced_scanReal(threadData_t *threadData, modelica_string _string, modelica_integer _startIndex, modelica_boolean _unsigned, modelica_real *out_number)
{
  int _startIndex_ext;
  int _unsigned_ext;
  int _nextIndex_ext;
  double _number_ext;
  modelica_integer _nextIndex;
  modelica_real _number;
  // _nextIndex has no default value.
  // _number has no default value.
  _startIndex_ext = (int)_startIndex;

  _unsigned_ext = (int)_unsigned;
  ModelicaStrings_scanReal(MMC_STRINGDATA(_string), _startIndex_ext, _unsigned_ext, &_nextIndex_ext, &_number_ext);
  _nextIndex = (modelica_integer)_nextIndex_ext;
  _number = (modelica_real)_number_ext;
  if (out_number) { *out_number = _number; }
  return _nextIndex;
}
modelica_metatype boxptr_Modelica_Utilities_Strings_Advanced_scanReal(threadData_t *threadData, modelica_metatype _string, modelica_metatype _startIndex, modelica_metatype _unsigned, modelica_metatype *out_number)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_real _number;
  modelica_integer _nextIndex;
  modelica_metatype out_nextIndex;
  tmp1 = mmc_unbox_integer(_startIndex);
  tmp2 = mmc_unbox_integer(_unsigned);
  _nextIndex = omc_Modelica_Utilities_Strings_Advanced_scanReal(threadData, _string, tmp1, tmp2, &_number);
  out_nextIndex = mmc_mk_icon(_nextIndex);
  if (out_number) { *out_number = mmc_mk_rcon(_number); }
  return out_nextIndex;
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

PhysicalParticleCO21D_MedPB_ThermodynamicState omc_PhysicalParticleCO21D_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  PhysicalParticleCO21D_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_PhysicalParticleCO21D_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &PhysicalParticleCO21D_MedPB_ThermodynamicState__desc, _p, _h);
}

PhysicalParticleCO21D_Medium_ThermodynamicState omc_PhysicalParticleCO21D_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  PhysicalParticleCO21D_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_PhysicalParticleCO21D_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &PhysicalParticleCO21D_Medium_ThermodynamicState__desc, _p, _h);
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
modelica_real omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_rho__T(threadData_t *threadData, modelica_real _T)
{
  modelica_real _rho;
  modelica_real _T_C;
  _tailrecursive: OMC_LABEL_UNUSED
  // _rho has no default value.
  _T_C = omc_Modelica_SIunits_Conversions_to__degC(threadData, _T);
  _rho = 2000.0;
  _return: OMC_LABEL_UNUSED
  return _rho;
}
modelica_metatype boxptr_SolarTherm_Media_SolidParticles_CarboHSP__utilities_rho__T(threadData_t *threadData, modelica_metatype _T)
{
  modelica_real tmp1;
  modelica_real _rho;
  modelica_metatype out_rho;
  tmp1 = mmc_unbox_real(_T);
  _rho = omc_SolarTherm_Media_SolidParticles_CarboHSP__utilities_rho__T(threadData, tmp1);
  out_rho = mmc_mk_rcon(_rho);
  return out_rho;
}

DLLExport
modelica_real omc_SolarTherm_Models_Analysis_Finances_particleBinCost(threadData_t *threadData, modelica_real _T)
{
  modelica_real _C_cap;
  _tailrecursive: OMC_LABEL_UNUSED
  // _C_cap has no default value.
  _C_cap = (1.23) * (1000.0 + (0.00075) * (-600.0 + _T));
  _return: OMC_LABEL_UNUSED
  return _C_cap;
}
modelica_metatype boxptr_SolarTherm_Models_Analysis_Finances_particleBinCost(threadData_t *threadData, modelica_metatype _T)
{
  modelica_real tmp1;
  modelica_real _C_cap;
  modelica_metatype out_C_cap;
  tmp1 = mmc_unbox_real(_T);
  _C_cap = omc_SolarTherm_Models_Analysis_Finances_particleBinCost(threadData, tmp1);
  out_C_cap = mmc_mk_rcon(_C_cap);
  return out_C_cap;
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

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__in__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__in__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__in__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__in__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__in__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__isen__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__isen__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__isen__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__isen__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_D_ThermodynamicState24powerBlock24mainCompressor24state__isen__des__desc, _p, _h);
}

DLLExport
modelica_real omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_specificEntropy(threadData_t *threadData, SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_ThermodynamicState _state)
{
  modelica_real _s;
  _tailrecursive: OMC_LABEL_UNUSED
  // _s has no default value.
  _s = omc_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData, _state._p, _state._h, omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT49, _OMC_LIT50, _OMC_LIT51, 1));
  _return: OMC_LABEL_UNUSED
  return _s;
}
modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_specificEntropy(threadData_t *threadData, modelica_metatype _state)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_ThermodynamicState tmp1;
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
  _s = omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24mainCompressor_MedPB_specificEntropy(threadData, tmp1);
  out_s = mmc_mk_rcon(_s);
  return out_s;
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__in__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__in__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__in__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__in__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__in__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__isen__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__isen__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__isen__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__isen__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_D_ThermodynamicState24powerBlock24reCompressor24state__isen__des__desc, _p, _h);
}

DLLExport
modelica_real omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_specificEntropy(threadData_t *threadData, SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_ThermodynamicState _state)
{
  modelica_real _s;
  _tailrecursive: OMC_LABEL_UNUSED
  // _s has no default value.
  _s = omc_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData, _state._p, _state._h, omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT49, _OMC_LIT50, _OMC_LIT51, 1));
  _return: OMC_LABEL_UNUSED
  return _s;
}
modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_specificEntropy(threadData_t *threadData, modelica_metatype _state)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_ThermodynamicState tmp1;
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
  _s = omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_CompressorOnShaft24powerBlock24reCompressor_MedPB_specificEntropy(threadData, tmp1);
  out_s = mmc_mk_rcon(_s);
  return out_s;
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_D_ThermodynamicState24powerBlock24cooler24state__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_D_ThermodynamicState24powerBlock24cooler24state__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_D_ThermodynamicState24powerBlock24cooler24state__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_D_ThermodynamicState24powerBlock24cooler24state__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Cooler24powerBlock24cooler_MedPB_D_ThermodynamicState24powerBlock24cooler24state__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__CO2__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__CO2__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__CO2__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__CO2__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__CO2__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__HTF__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__HTF__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__HTF__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__HTF__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedPB_D_ThermodynamicState24powerBlock24exchanger24state__HTF__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedRec_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedRec_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedRec_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedRec_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Exchanger24powerBlock24exchanger_MedRec_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__comp__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__comp__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__comp__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__comp__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__comp__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__turb__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__turb__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__turb__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__turb__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24HTR_MedPB_D_ThermodynamicState24powerBlock24HTR24state__turb__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__comp__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__comp__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__comp__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__comp__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__comp__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__turb__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__turb__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__turb__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__turb__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_HeatRecuperatorDTAve24powerBlock24LTR_MedPB_D_ThermodynamicState24powerBlock24LTR24state__turb__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__a omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__a(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__a tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__a(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__a__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__in__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__in__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__in__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__in__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__in__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__isen__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__isen__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__isen__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__isen__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__isen__des__desc, _p, _h);
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__out__des omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__out__des(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__out__des tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__out__des(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_D_ThermodynamicState24powerBlock24turbine24state__out__des__desc, _p, _h);
}

DLLExport
modelica_real omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_specificEntropy(threadData_t *threadData, SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_ThermodynamicState _state)
{
  modelica_real _s;
  _tailrecursive: OMC_LABEL_UNUSED
  // _s has no default value.
  _s = omc_SolarTherm_Media_CO2_CO2__utilities_s__p__h(threadData, _state._p, _state._h, omc_Modelica_Blocks_Types_ExternalCombiTable2D_constructor(threadData, _OMC_LIT49, _OMC_LIT50, _OMC_LIT51, 1));
  _return: OMC_LABEL_UNUSED
  return _s;
}
modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_specificEntropy(threadData_t *threadData, modelica_metatype _state)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_ThermodynamicState tmp1;
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
  _s = omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_Turbine24powerBlock24turbine_MedPB_specificEntropy(threadData, tmp1);
  out_s = mmc_mk_rcon(_s);
  return out_s;
}

SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_recompPB24powerBlock_MedRec_ThermodynamicState omc_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_recompPB24powerBlock_MedRec_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_recompPB24powerBlock_MedRec_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_recompPB24powerBlock_MedRec_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_PowerBlocks_sCO2Cycle_DirectDesign_D_recompPB24powerBlock_MedRec_ThermodynamicState__desc, _p, _h);
}

DLLExport
modelica_real omc_SolarTherm_Models_Sources_SolarFunctions_aparentSolarZenith(threadData_t *threadData, modelica_real _dec, modelica_real _hra, modelica_real _lat)
{
  modelica_real _zen_ap;
  modelica_real _zen;
  modelica_real _A;
  modelica_real _B;
  modelica_real _C;
  modelica_real _D;
  modelica_real _E;
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_real tmp5;
  modelica_real tmp6;
  modelica_real tmp7;
  modelica_real tmp8;
  _tailrecursive: OMC_LABEL_UNUSED
  // _zen_ap has no default value.
  // _zen has no default value.
  _A = 0.004013327;
  _B = 0.06476916000000001;
  _C = -0.66956539;
  _D = 0.019276169;
  _E = -0.00051297;
  tmp1 = (cos(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) * ((cos(_dec)) * (cos(_hra))) + (sin(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) * (sin(_dec));
  if(!(tmp1 >= -1.0 && tmp1 <= 1.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert(threadData, info, "Model error: Argument of acos(cos(Modelica.SIunits.Conversions.from_deg(lat)) * cos(dec) * cos(hra) + sin(Modelica.SIunits.Conversions.from_deg(lat)) * sin(dec)) outside the domain -1.0 <= %g <= 1.0", tmp1);
  }
  _zen = acos(tmp1);

  tmp2 = (15.43944679844543) * (_zen);
  tmp3 = -0.66956539 + (0.019276169) * (_zen);
  if(tmp2 < 0.0 && tmp3 != 0.0)
  {
    tmp5 = modf(tmp3, &tmp6);
    
    if(tmp5 > 0.5)
    {
      tmp5 -= 1.0;
      tmp6 += 1.0;
    }
    else if(tmp5 < -0.5)
    {
      tmp5 += 1.0;
      tmp6 -= 1.0;
    }
    
    if(fabs(tmp5) < 1e-10)
      tmp4 = pow(tmp2, tmp6);
    else
    {
      tmp8 = modf(1.0/tmp3, &tmp7);
      if(tmp8 > 0.5)
      {
        tmp8 -= 1.0;
        tmp7 += 1.0;
      }
      else if(tmp8 < -0.5)
      {
        tmp8 += 1.0;
        tmp7 -= 1.0;
      }
      if(fabs(tmp8) < 1e-10 && ((unsigned long)tmp7 & 1))
      {
        tmp4 = -pow(-tmp2, tmp5)*pow(tmp2, tmp6);
      }
      else
      {
        throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp2, tmp3);
      }
    }
  }
  else
  {
    tmp4 = pow(tmp2, tmp3);
  }
  if(isnan(tmp4) || isinf(tmp4))
  {
    throwStreamPrint(threadData, "%s:%d: Invalid root: (%g)^(%g)", __FILE__, __LINE__, tmp2, tmp3);
  }
  _zen_ap = fmin(1.570796326794897,-0.00051297 + _zen + (-0.004013327) * (tmp4));
  _return: OMC_LABEL_UNUSED
  return _zen_ap;
}
modelica_metatype boxptr_SolarTherm_Models_Sources_SolarFunctions_aparentSolarZenith(threadData_t *threadData, modelica_metatype _dec, modelica_metatype _hra, modelica_metatype _lat)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _zen_ap;
  modelica_metatype out_zen_ap;
  tmp1 = mmc_unbox_real(_dec);
  tmp2 = mmc_unbox_real(_hra);
  tmp3 = mmc_unbox_real(_lat);
  _zen_ap = omc_SolarTherm_Models_Sources_SolarFunctions_aparentSolarZenith(threadData, tmp1, tmp2, tmp3);
  out_zen_ap = mmc_mk_rcon(_zen_ap);
  return out_zen_ap;
}

DLLExport
modelica_real omc_SolarTherm_Models_Sources_SolarFunctions_eclipticLongitude(threadData_t *threadData, modelica_real _dec)
{
  modelica_real _elo;
  modelica_real _axial_tilt;
  modelica_real tmp1;
  modelica_real tmp2;
  _tailrecursive: OMC_LABEL_UNUSED
  // _elo has no default value.
  _axial_tilt = 0.409377448030782;
  tmp1 = sin(_axial_tilt);
  tmp2 = (sin(_dec)) / tmp1;
  if(!(tmp2 >= -1.0 && tmp2 <= 1.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert(threadData, info, "Model error: Argument of asin(sin(dec) / sin(axial_tilt)) outside the domain -1.0 <= %g <= 1.0", tmp2);
  }
  _elo = asin(tmp2);
  _return: OMC_LABEL_UNUSED
  return _elo;
}
modelica_metatype boxptr_SolarTherm_Models_Sources_SolarFunctions_eclipticLongitude(threadData_t *threadData, modelica_metatype _dec)
{
  modelica_real tmp1;
  modelica_real _elo;
  modelica_metatype out_elo;
  tmp1 = mmc_unbox_real(_dec);
  _elo = omc_SolarTherm_Models_Sources_SolarFunctions_eclipticLongitude(threadData, tmp1);
  out_elo = mmc_mk_rcon(_elo);
  return out_elo;
}

DLLExport
modelica_real omc_SolarTherm_Models_Sources_SolarFunctions_elevationAngle(threadData_t *threadData, modelica_real _dec, modelica_real _hra, modelica_real _lat)
{
  modelica_real _ele;
  modelica_real tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  // _ele has no default value.
  tmp1 = (sin(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) * (sin(_dec)) + (cos(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) * ((cos(_dec)) * (cos(_hra)));
  if(!(tmp1 >= -1.0 && tmp1 <= 1.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert(threadData, info, "Model error: Argument of asin(sin(Modelica.SIunits.Conversions.from_deg(lat)) * sin(dec) + cos(Modelica.SIunits.Conversions.from_deg(lat)) * cos(dec) * cos(hra)) outside the domain -1.0 <= %g <= 1.0", tmp1);
  }
  _ele = fmax(0.0,asin(tmp1));
  _return: OMC_LABEL_UNUSED
  return _ele;
}
modelica_metatype boxptr_SolarTherm_Models_Sources_SolarFunctions_elevationAngle(threadData_t *threadData, modelica_metatype _dec, modelica_metatype _hra, modelica_metatype _lat)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _ele;
  modelica_metatype out_ele;
  tmp1 = mmc_unbox_real(_dec);
  tmp2 = mmc_unbox_real(_hra);
  tmp3 = mmc_unbox_real(_lat);
  _ele = omc_SolarTherm_Models_Sources_SolarFunctions_elevationAngle(threadData, tmp1, tmp2, tmp3);
  out_ele = mmc_mk_rcon(_ele);
  return out_ele;
}

DLLExport
modelica_real omc_SolarTherm_Models_Sources_SolarFunctions_julianDay(threadData_t *threadData, modelica_integer _year, modelica_integer _month, modelica_integer _day, modelica_real _hour)
{
  modelica_real _jday;
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_integer tmp3;
  modelica_integer tmp4;
  modelica_integer tmp5;
  modelica_integer tmp6;
  modelica_integer tmp7;
  _tailrecursive: OMC_LABEL_UNUSED
  // _jday has no default value.
  tmp1 = ((modelica_integer) 12);
  if (tmp1 == 0) {throwStreamPrint(threadData, "Division by zero %s", "div(-14 + month, 12)");}
  tmp2 = ((modelica_integer) 4);
  if (tmp2 == 0) {throwStreamPrint(threadData, "Division by zero %s", "div(1461 * (4800 + year + div(-14 + month, 12)), 4)");}
  tmp3 = ((modelica_integer) 12);
  if (tmp3 == 0) {throwStreamPrint(threadData, "Division by zero %s", "div(-14 + month, 12)");}
  tmp4 = ((modelica_integer) 12);
  if (tmp4 == 0) {throwStreamPrint(threadData, "Division by zero %s", "div(367 * (-2 + month + -12 * div(-14 + month, 12)), 12)");}
  tmp5 = ((modelica_integer) 12);
  if (tmp5 == 0) {throwStreamPrint(threadData, "Division by zero %s", "div(-14 + month, 12)");}
  tmp6 = ((modelica_integer) 100);
  if (tmp6 == 0) {throwStreamPrint(threadData, "Division by zero %s", "div(4900 + year + div(-14 + month, 12), 100)");}
  tmp7 = ((modelica_integer) 4);
  if (tmp7 == 0) {throwStreamPrint(threadData, "Division by zero %s", "div(3 * div(4900 + year + div(-14 + month, 12), 100), 4)");}
  _jday = -0.5 + ((modelica_real)((modelica_integer) -32075) + ldiv((((modelica_integer) 1461)) * (((modelica_integer) 4800) + _year + ldiv(((modelica_integer) -14) + _month,tmp1).quot),tmp2).quot + ldiv((((modelica_integer) 367)) * (((modelica_integer) -2) + _month + (((modelica_integer) -12)) * (ldiv(((modelica_integer) -14) + _month,tmp3).quot)),tmp4).quot + _day - ldiv((((modelica_integer) 3)) * (ldiv(((modelica_integer) 4900) + _year + ldiv(((modelica_integer) -14) + _month,tmp5).quot,tmp6).quot),tmp7).quot) + (0.04166666666666666) * (_hour);
  _return: OMC_LABEL_UNUSED
  return _jday;
}
modelica_metatype boxptr_SolarTherm_Models_Sources_SolarFunctions_julianDay(threadData_t *threadData, modelica_metatype _year, modelica_metatype _month, modelica_metatype _day, modelica_metatype _hour)
{
  modelica_integer tmp1;
  modelica_integer tmp2;
  modelica_integer tmp3;
  modelica_real tmp4;
  modelica_real _jday;
  modelica_metatype out_jday;
  tmp1 = mmc_unbox_integer(_year);
  tmp2 = mmc_unbox_integer(_month);
  tmp3 = mmc_unbox_integer(_day);
  tmp4 = mmc_unbox_real(_hour);
  _jday = omc_SolarTherm_Models_Sources_SolarFunctions_julianDay(threadData, tmp1, tmp2, tmp3, tmp4);
  out_jday = mmc_mk_rcon(_jday);
  return out_jday;
}

DLLExport
modelica_real omc_SolarTherm_Models_Sources_SolarFunctions_solarAzimuth(threadData_t *threadData, modelica_real _dec, modelica_real _hra, modelica_real _lat)
{
  modelica_real _azi;
  modelica_real _zen;
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  _tailrecursive: OMC_LABEL_UNUSED
  // _azi has no default value.
  // _zen has no default value.
  _zen = omc_SolarTherm_Models_Sources_SolarFunctions_solarZenith(threadData, _dec, _hra, _lat);

  if((_lat > 0.0))
  {
    tmp1 = (cos(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) * (sin(_zen));
    tmp2 = ((cos(_zen)) * (sin(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) - sin(_dec)) / tmp1;
    if(!(tmp2 >= -1.0 && tmp2 <= 1.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert(threadData, info, "Model error: Argument of acos((cos(zen) * sin(Modelica.SIunits.Conversions.from_deg(lat)) - sin(dec)) / (cos(Modelica.SIunits.Conversions.from_deg(lat)) * sin(zen))) outside the domain -1.0 <= %g <= 1.0", tmp2);
    }
    _azi = (((modelica_real)sign(_hra))) * (fabs(acos(tmp2)));
  }
  else
  {
    tmp3 = (cos(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) * (sin(_zen));
    tmp4 = ((cos(_zen)) * (sin(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) - sin(_dec)) / tmp3;
    if(!(tmp4 >= -1.0 && tmp4 <= 1.0))
    {
      FILE_INFO info = {"",0,0,0,0,0};
      omc_assert(threadData, info, "Model error: Argument of acos((cos(zen) * sin(Modelica.SIunits.Conversions.from_deg(lat)) - sin(dec)) / (cos(Modelica.SIunits.Conversions.from_deg(lat)) * sin(zen))) outside the domain -1.0 <= %g <= 1.0", tmp4);
    }
    _azi = (((modelica_real)sign(_hra))) * (fabs(-3.141592653589793 + acos(tmp4)));
  }
  _return: OMC_LABEL_UNUSED
  return _azi;
}
modelica_metatype boxptr_SolarTherm_Models_Sources_SolarFunctions_solarAzimuth(threadData_t *threadData, modelica_metatype _dec, modelica_metatype _hra, modelica_metatype _lat)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _azi;
  modelica_metatype out_azi;
  tmp1 = mmc_unbox_real(_dec);
  tmp2 = mmc_unbox_real(_hra);
  tmp3 = mmc_unbox_real(_lat);
  _azi = omc_SolarTherm_Models_Sources_SolarFunctions_solarAzimuth(threadData, tmp1, tmp2, tmp3);
  out_azi = mmc_mk_rcon(_azi);
  return out_azi;
}

DLLExport
modelica_real omc_SolarTherm_Models_Sources_SolarFunctions_solarZenith(threadData_t *threadData, modelica_real _dec, modelica_real _hra, modelica_real _lat)
{
  modelica_real _zen;
  modelica_real tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  // _zen has no default value.
  tmp1 = (cos(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) * ((cos(_dec)) * (cos(_hra))) + (sin(omc_Modelica_SIunits_Conversions_from__deg(threadData, _lat))) * (sin(_dec));
  if(!(tmp1 >= -1.0 && tmp1 <= 1.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert(threadData, info, "Model error: Argument of acos(cos(Modelica.SIunits.Conversions.from_deg(lat)) * cos(dec) * cos(hra) + sin(Modelica.SIunits.Conversions.from_deg(lat)) * sin(dec)) outside the domain -1.0 <= %g <= 1.0", tmp1);
  }
  _zen = acos(tmp1);
  _return: OMC_LABEL_UNUSED
  return _zen;
}
modelica_metatype boxptr_SolarTherm_Models_Sources_SolarFunctions_solarZenith(threadData_t *threadData, modelica_metatype _dec, modelica_metatype _hra, modelica_metatype _lat)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real _zen;
  modelica_metatype out_zen;
  tmp1 = mmc_unbox_real(_dec);
  tmp2 = mmc_unbox_real(_hra);
  tmp3 = mmc_unbox_real(_lat);
  _zen = omc_SolarTherm_Models_Sources_SolarFunctions_solarZenith(threadData, tmp1, tmp2, tmp3);
  out_zen = mmc_mk_rcon(_zen);
  return out_zen;
}

DLLExport
modelica_real omc_SolarTherm_Models_Sources_SolarModel_D_Sun24sun_solarPosition(threadData_t *threadData, modelica_real _t, modelica_real _lon, modelica_real _lat, modelica_real _t_zone, modelica_integer _year, modelica_real *out_hra)
{
  modelica_real _dec;
  modelica_real _hra;
  modelica_real _declination;
  modelica_real _hourangle;
  modelica_real _zenithangle;
  modelica_real _azimuth;
  modelica_real _twopi;
  modelica_real _rad;
  modelica_real _earthmeanradius;
  modelica_real _astronomicalunit;
  modelica_real _elapsedjuliandays;
  modelica_real _aux;
  modelica_real _eclipticlongitude;
  modelica_real _eclipticobliquity;
  modelica_real _sineclipticlongitude;
  modelica_real _y;
  modelica_real _x;
  modelica_real _rightascension;
  modelica_real _greenwichmeansiderealtime;
  modelica_real _localmeansiderealtime;
  modelica_real _latitudeinradians;
  modelica_real _coslatitude;
  modelica_real _sinlatitude;
  modelica_real _coshourangle;
  modelica_real _parallax;
  modelica_integer _intaux;
  modelica_real _longitude;
  modelica_real _latitude;
  modelica_real _t_zone_int;
  modelica_real _julianday;
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  _tailrecursive: OMC_LABEL_UNUSED
  // _dec has no default value.
  // _hra has no default value.
  // _declination has no default value.
  // _hourangle has no default value.
  // _zenithangle has no default value.
  // _azimuth has no default value.
  _twopi = 6.283185307179586;
  _rad = 0.0174532925199433;
  _earthmeanradius = 6371.01;
  _astronomicalunit = 149597890.0;
  // _elapsedjuliandays has no default value.
  // _aux has no default value.
  // _eclipticlongitude has no default value.
  // _eclipticobliquity has no default value.
  // _sineclipticlongitude has no default value.
  // _y has no default value.
  // _x has no default value.
  // _rightascension has no default value.
  // _greenwichmeansiderealtime has no default value.
  // _localmeansiderealtime has no default value.
  // _latitudeinradians has no default value.
  // _coslatitude has no default value.
  // _sinlatitude has no default value.
  // _coshourangle has no default value.
  // _parallax has no default value.
  // _intaux has no default value.
  _longitude = _lon;
  _latitude = _lat;
  _t_zone_int = ((modelica_real)(sign(_t_zone)) * (((modelica_integer)floor(fabs(_t_zone)))));
  _julianday = omc_SolarTherm_Models_Sources_SolarFunctions_julianDay(threadData, _year, ((modelica_integer) 1), ((modelica_integer) 1), (0.0002777777777777778) * (_t) - _t_zone_int);
  _elapsedjuliandays = -2451545.0 + _julianday;

  _aux = (0.0172021241615) * (_elapsedjuliandays);

  _eclipticlongitude = 4.894969024 + (_elapsedjuliandays) * (0.017202791697 + (5.78262765229295e-09) * (cos(2.67824 + _aux))) + (0.03341656) * (cos(4.6693 + _aux)) + (0.00034894) * (cos(4.6261 + (0.03440424832) * (_elapsedjuliandays))) + (-8.339e-05) * (sin(2.1824 + (-0.00092421755) * (_elapsedjuliandays))) + (3.934e-05) * (cos(2.7441 + (0.01575190938) * (_elapsedjuliandays))) + (3.461e-05) * (cos(2.8289 + (9.64572211e-06) * (_elapsedjuliandays))) + (3.136e-05) * (cos(3.6277 + (0.21276871047) * (_elapsedjuliandays))) + (2.676e-05) * (cos(4.4181 + (0.02152065544) * (_elapsedjuliandays))) + (3.046e-05) * (cos(6.1352 + (0.01076032772) * (_elapsedjuliandays)));

  _eclipticobliquity = 0.409092804039597 + (-6.21395528282155e-09) * (_elapsedjuliandays) + (4.4596737135516e-05) * (cos(2.18295428698789 + (-0.000924169576470094) * (_elapsedjuliandays))) + (-2.78266331083708e-06) * (cos(87.60120254057659 + (-0.0344055570784386) * (_elapsedjuliandays))) + (1.04358121667584e-07) * (cos(167.419645046537 + (-0.06987875019856921) * (_elapsedjuliandays)));

  _sineclipticlongitude = sin(_eclipticlongitude);

  _y = (cos(_eclipticobliquity)) * (_sineclipticlongitude);

  _x = cos(_eclipticlongitude);

  _rightascension = atan2(_y, _x);

  if((_rightascension < 0.0))
  {
    _rightascension = 6.283185307179586 + _rightascension;
  }

  tmp1 = (sin(_eclipticobliquity)) * (_sineclipticlongitude);
  if(!(tmp1 >= -1.0 && tmp1 <= 1.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert(threadData, info, "Model error: Argument of asin(sin(eclipticobliquity) * sineclipticlongitude) outside the domain -1.0 <= %g <= 1.0", tmp1);
  }
  _declination = asin(tmp1);

  _greenwichmeansiderealtime = -60053.302628 + (24.065709825) * (_elapsedjuliandays) + (-0.000292222) * (sin(0.9574 + (0.0009242) * (_elapsedjuliandays)));

  _localmeansiderealtime = (0.0174532925199433) * ((15.0) * (_greenwichmeansiderealtime) + _longitude);

  _hourangle = _localmeansiderealtime - _rightascension;

  _latitudeinradians = (0.0174532925199433) * (_latitude);

  _coslatitude = cos(_latitudeinradians);

  _sinlatitude = sin(_latitudeinradians);

  _coshourangle = cos(_hourangle);

  tmp2 = (_coslatitude) * ((_coshourangle) * (cos(_declination))) + (sin(_declination)) * (_sinlatitude);
  if(!(tmp2 >= -1.0 && tmp2 <= 1.0))
  {
    FILE_INFO info = {"",0,0,0,0,0};
    omc_assert(threadData, info, "Model error: Argument of acos(coslatitude * coshourangle * cos(declination) + sin(declination) * sinlatitude) outside the domain -1.0 <= %g <= 1.0", tmp2);
  }
  _zenithangle = acos(tmp2);

  _y = (-sin(_hourangle));

  _x = (tan(_declination)) * (_coslatitude) - ((_sinlatitude) * (_coshourangle));

  _azimuth = atan2(_y, _x);

  if((_azimuth < 0.0))
  {
    _azimuth = 6.283185307179586 + _azimuth;
  }

  _parallax = (4.258756590751381e-05) * (sin(_zenithangle));

  _zenithangle = _zenithangle + _parallax;

  tmp3 = 6.283185307179586;
  if (tmp3 == 0) {throwStreamPrint(threadData, "Division by zero %s", "mod(3.141592653589793 + hourangle, 6.283185307179586)");}
  _hourangle = -3.141592653589793 + modelica_real_mod(3.141592653589793 + _hourangle, tmp3);

  _dec = _declination;

  _hra = _hourangle;
  _return: OMC_LABEL_UNUSED
  if (out_hra) { *out_hra = _hra; }
  return _dec;
}
modelica_metatype boxptr_SolarTherm_Models_Sources_SolarModel_D_Sun24sun_solarPosition(threadData_t *threadData, modelica_metatype _t, modelica_metatype _lon, modelica_metatype _lat, modelica_metatype _t_zone, modelica_metatype _year, modelica_metatype *out_hra)
{
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  modelica_real tmp4;
  modelica_integer tmp5;
  modelica_real _hra;
  modelica_real _dec;
  modelica_metatype out_dec;
  tmp1 = mmc_unbox_real(_t);
  tmp2 = mmc_unbox_real(_lon);
  tmp3 = mmc_unbox_real(_lat);
  tmp4 = mmc_unbox_real(_t_zone);
  tmp5 = mmc_unbox_integer(_year);
  _dec = omc_SolarTherm_Models_Sources_SolarModel_D_Sun24sun_solarPosition(threadData, tmp1, tmp2, tmp3, tmp4, tmp5, &_hra);
  out_dec = mmc_mk_rcon(_dec);
  if (out_hra) { *out_hra = mmc_mk_rcon(_hra); }
  return out_dec;
}

SolarTherm_Models_Storage_Tank_D_Tank24tankCold_Medium_ThermodynamicState omc_SolarTherm_Models_Storage_Tank_D_Tank24tankCold_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_Storage_Tank_D_Tank24tankCold_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_Storage_Tank_D_Tank24tankCold_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_Storage_Tank_D_Tank24tankCold_Medium_ThermodynamicState__desc, _p, _h);
}

SolarTherm_Models_Storage_Tank_D_Tank24tankHot_Medium_ThermodynamicState omc_SolarTherm_Models_Storage_Tank_D_Tank24tankHot_Medium_ThermodynamicState(threadData_t *threadData, modelica_real omc_p, modelica_real omc_h)
{
  SolarTherm_Models_Storage_Tank_D_Tank24tankHot_Medium_ThermodynamicState tmp1;
  tmp1._p = omc_p;
  tmp1._h = omc_h;
  return tmp1;
}

modelica_metatype boxptr_SolarTherm_Models_Storage_Tank_D_Tank24tankHot_Medium_ThermodynamicState(threadData_t *threadData, modelica_metatype _p, modelica_metatype _h)
{
  return mmc_mk_box3(3, &SolarTherm_Models_Storage_Tank_D_Tank24tankHot_Medium_ThermodynamicState__desc, _p, _h);
}

DLLExport
real_array omc_SolarTherm_Utilities_Metadata__Optics(threadData_t *threadData, modelica_string _file)
{
  real_array _meta;
  modelica_string _line = NULL;
  modelica_integer _i;
  modelica_integer _j;
  modelica_metatype tmpMeta[1] __attribute__((unused)) = {0};
  _tailrecursive: OMC_LABEL_UNUSED
  alloc_real_array(&(_meta), 1, 8); // _meta has no default value.
  // _line has no default value.
  // _i has no default value.
  // _j has no default value.
  _line = omc_Modelica_Utilities_Streams_readLine(threadData, _file, ((modelica_integer) 5), NULL);

  omc_Modelica_Utilities_Streams_close(threadData, _file);

  _i = ((modelica_integer) 10);

  _j = ((modelica_integer) 10);

  tmpMeta[0] = stringAppend(_OMC_LIT53,_file);
  real_array_get(_meta, 1, ((modelica_integer) 1)) = omc_Modelica_Utilities_Strings_scanReal(threadData, _line, ((modelica_integer) 1) + _j, 0, tmpMeta[0] ,&_j);

  tmpMeta[0] = stringAppend(_OMC_LIT53,_file);
  real_array_get(_meta, 1, ((modelica_integer) 2)) = omc_Modelica_Utilities_Strings_scanReal(threadData, _line, ((modelica_integer) 1) + _j, 0, tmpMeta[0] ,&_j);

  tmpMeta[0] = stringAppend(_OMC_LIT53,_file);
  real_array_get(_meta, 1, ((modelica_integer) 3)) = omc_Modelica_Utilities_Strings_scanReal(threadData, _line, ((modelica_integer) 1) + _j, 0, tmpMeta[0] ,&_j);

  tmpMeta[0] = stringAppend(_OMC_LIT53,_file);
  real_array_get(_meta, 1, ((modelica_integer) 4)) = omc_Modelica_Utilities_Strings_scanReal(threadData, _line, ((modelica_integer) 1) + _j, 0, tmpMeta[0] ,&_j);

  tmpMeta[0] = stringAppend(_OMC_LIT53,_file);
  real_array_get(_meta, 1, ((modelica_integer) 5)) = omc_Modelica_Utilities_Strings_scanReal(threadData, _line, ((modelica_integer) 1) + _j, 0, tmpMeta[0] ,&_j);

  tmpMeta[0] = stringAppend(_OMC_LIT53,_file);
  real_array_get(_meta, 1, ((modelica_integer) 6)) = omc_Modelica_Utilities_Strings_scanReal(threadData, _line, ((modelica_integer) 1) + _j, 0, tmpMeta[0] ,&_j);

  tmpMeta[0] = stringAppend(_OMC_LIT53,_file);
  real_array_get(_meta, 1, ((modelica_integer) 7)) = omc_Modelica_Utilities_Strings_scanReal(threadData, _line, ((modelica_integer) 1) + _j, 0, tmpMeta[0] ,&_j);

  tmpMeta[0] = stringAppend(_OMC_LIT53,_file);
  real_array_get(_meta, 1, ((modelica_integer) 8)) = omc_Modelica_Utilities_Strings_scanReal(threadData, _line, ((modelica_integer) 1) + _j, 0, tmpMeta[0] ,&_j);
  _return: OMC_LABEL_UNUSED
  return _meta;
}
modelica_metatype boxptr_SolarTherm_Utilities_Metadata__Optics(threadData_t *threadData, modelica_metatype _file)
{
  real_array _meta;
  modelica_metatype out_meta;
  _meta = omc_SolarTherm_Utilities_Metadata__Optics(threadData, _file);
  out_meta = mmc_mk_modelica_array(_meta);
  return out_meta;
}

#ifdef __cplusplus
}
#endif
