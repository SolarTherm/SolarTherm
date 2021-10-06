#ifndef ST_MOTAB_H
#define ST_MOTAB_H

/**
	Define the following macro to enable the feature of 'exporting' a loaded
	table to the 'usertab' function, so that it can be interpolated
	using ExternalCombiTable1D.
*/
//#define ST_EXPORT_USERTAB

#ifdef __linux__
# define ST_EXPORT
#elif defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__) || defined(_WIN64)
# ifdef ST_MOTAB_DLL
#  define ST_EXPORT __declspec(dllexport)
# else
#  define ST_EXPORT __declspec(dllimport)
# endif
#endif

/* generic motab reader in C */

/* the starting point is MSL 'Tables' data files as described in the
MSL documentation, for example at
https://doc.modelica.org/Modelica%203.2.3/Resources/helpMapleSim/Blocks/Tables/index.html

Our motab format includes extra structured comment rows that are also parsed and
accessible through functions below. This allows column labels and measurement
units to be accessible, as well as metadata relation to the each table. We use
this in SolarTherm to store weather file metadata, for example the location
and latitude and longitude for a weather file. Our .motab weather files are
generated on-the-fly from standard TMY3 files using the tool st_wea_to_mo but
that can also be done manually the user. This approach allow support for other
on-the-fly data file translation to be implemented.

#1
double weather(8760,9)
#METALABELS,name,lat,lon,elev,tzone,tstart
#METAUNITS,str,deg,deg,m,h,s
#TABLELABELS,time,ghi,dni,dry,dew,rhum,p,wdir,wspd
#TABLEUNITS,s,W/m2,W/m2,degC,degC,%,mbar,deg,m/s
#METADATA,722950-"LOS ANGELES INTL ARPT",33.933,-118.400,30,-8.0,3600.0
0,0,0,12.2,11.1,93,1008,60,1.5
3600,0,0,12.2,10.0,86,1009,70,4.1
7200,0,0,11.7,9.4,86,1008,70,2.1

(This class supersedes the linprog.c routines for loading specific files used
in the earlier optimal dispatch routines.)

The internal data structure is simpler than the one in st_tables, because it 
makes use of the .motab file header to allocate memory using a single malloc.
On the other hand, this new code is more complex because provides access to the
metadata fields.

In principle, it should be possible to link these routines with the 
'userdata' feature of ExternalCombiTable1D from the Modelica Standard Library
to implement interpolation.

st_motab is not going to be a good choice with very large data sets -- our 
typical use is with files having 8,760 rows and ~10 cols (hourly data for one
year), but up to larger is probably fine too OK (1 minute data), up to some 
limit where a memory-mapped file may become preferable.

FIXME: st_motab doesn't yet handle multiple tables in a single text file, although
that feature is in fact supported by Modelica.
*/

/**
	Macro to directly access data in the stored table, either for reading or
	writing. `TABLE` is a MotabData pointer, `ROW` and `COL` are row and column
	indices starting from zero.
	
	NOTE: if you want interpolation, see `motab_get_value`.
	
	TODO Possibly we should avoid using this macro outside st_motab.c...?
*/
#define MOTAB_VAL(TABLE,ROW,COL) (TABLE)->vals[(COL) + (ROW)*(TABLE->ncols)]

#include <limits.h>
#include <float.h>
/**
	Special value that indicates the column number is not yet known.
*/
#define MOTAB_NO_COL (UINT_MAX-17)
#define MOTAB_NO_REAL (DBL_MAX*0.17)
#define MOTAB_NO_INT (INT_MAX-17)

//typedef void MotabErrorCallback(const char *fmt,...);

typedef enum{
	MOTAB_STR
	, MOTAB_INT
	, MOTAB_REAL
} MotabMetaType;

typedef struct MotabMetaItem_struct {
	const char *name; // don't own this string, don't free it at the end.
	char *units; // we do own this string, and must free if if needed.
	MotabMetaType type;
	union{
		char *str; // we do own this string.
		int ival;
		double dval;
	} u;
	//MotabErrorCallback *err_callback;
} MotabMetaItem;

void motab_meta_free(MotabMetaItem *item);

/**
	Data structure for storing metadata rows from the start of the file
	(except for the first two lines, which define the format version and
	table name, type and number of rows and columns.
	
	NOTE: although we have a data structure for MotabMetaItem, we don't yet
	store parsed metadata in the MotabData object. We just store the comments
	that fulfil the criteria of being a metadata row -- namely as many 
	rows starting with '#' as desired, after the '#1' and table description
	row.
*/
typedef struct MotabMetaData_struct {
	char *row;
	struct MotabMetaData_struct *next;
} MotabMetaData;


/**
	Data structure for storing everything from a loaded .motab file.
	Note that this version only supports tables with data of type `double`.
*/
typedef struct{
	char *name; ///< owned by us, must be freed using motab_free(tab)
	double *vals; ///< owned by us
	unsigned nrows;
	unsigned ncols;
	MotabMetaData *meta; ///< owned by us
	unsigned timecol;  ///< will be initialised to MOTAB_NO_COL
	double timestep; ///< will be intitialise to zero (0)
} MotabData;

/**
	Load the motab file, return NULL if anything is wrong. File-reading error \
	messages are output to stderr.
*/
ST_EXPORT MotabData *motab_load(const char *filepath);

/**
	Create a new empty table (used for example with synthetic datasets used for
	testing the code).
	
	`nrows` and `ncols` are the number of required rows and columns in the table.
	`name` is the label that will be stored (copied) with the table, and hopefully
	used later for accessing the table by name via the Modelica 'usertab' feature.
	`collabels` and `colunits` are the column labels and units of measurement,
	comma-separated (see `motab_find_meta_row`).
*/
ST_EXPORT MotabData *motab_new(unsigned nrows, unsigned ncols, const char *name, const char *collabels, const char *colunits);

/**
	Get the metadata row corresponding to `tag`, eg TABLEUNITS below.
	The string returned everything after the first comma, so "s,W/m2,..."
	Return NULL if not found.
	
	#TABLEUNITS,s,W/m2,W/m2,degC,degC,%,mbar,deg,m/s
	
	The returned string is NOT a copy, so you don't need to (and must not!) 
	free it.
*/
ST_EXPORT const char *motab_find_meta_row(MotabData *tab, const char *tag);

/**
	Look up a column by label, and return its index. 
	Return -1 if label is not found.
	Labels are case sensitive.
*/
ST_EXPORT int motab_find_col_by_label(MotabData *tab, const char *label);

/**
	Free memory allocated for this MotabData. It is assumed
	that all strings are owned here, and are all freed.
*/
ST_EXPORT void motab_free(MotabData *tab);

/**
	Check that the loaded MotabData has (1) a column named 'time', (2) with
	units of seconds ('s'), (3) has at least two rows of data, and (4) that
	the timestep between all subsequent rows is equal to that between the first
	and second row. The timestep is returned as `step` (assuming a non-NULL
	pointer is provided by the user).
	
	The function returns an error value if any of the conditions are not met.
	The error code equals the number of the failing condition as above.
	
	This function doesn't check that the 'time' column is the first column. That
	shouldn't matter, hopefully. Actually it might, because motab_get_value
	will have to interpolate on a first column.
*/
ST_EXPORT int motab_check_timestep(MotabData *tab, double *step);

/**
	Look up the units of measurement specified for a column in the file.
	Return NULL if not found.
	
	You must free the string returned by this function.

*/
ST_EXPORT char *motab_get_col_units(MotabData *tab, const char *label);


/**
	Get value, with linear interpolation. First scratch test function, not
	for serious use.
	
	TODO For more serious use, we propose to integrate st_motab with the MSL
	ModelicaStandardTables, namely ExternalCombiTable1D, via the 'usertab'
	feature. More to come on that...
*/
ST_EXPORT double motab_get_value(MotabData *tab, double t, int col);


/**
	Get value, with wraparound. The table is assumed to be circular, such that
	the last value in the table comes one timestep before the first value in the
	table. See `motab_get_value`.
	
	This function is useful in st_linprog, when attempting to run forecasts
	for the last nsteps time-periods of the year.
*/
ST_EXPORT double motab_get_value_wraparound(MotabData *tab, double t, int col);


/**
	Get the double value of a metadata item `name`. If any error occurs then 
	the value returned will be MOTAB_NO_REAL, and, providing a pointer `err`
	has been provided, an error code will be returned in `err`. You should
	better check the value of `err`, rather than checking for MOTAB_NO_REAL.
	
	Possible errors are that there is no `tab`, no metadata fields, a value 
	could not be parsed, or the value is flagged (in METAUNITS) 
	as being a string rather than a double.
	
	If `units` is supplied, then *units will be set to a pointer to a new copy 
	of the units of measurement for this value. You must free `units` when
	you're done.
*/
ST_EXPORT double motab_get_meta_real(MotabData *tab, const char *name, char **units, int *err);

/**
	Get the integer value of metadata item `name`. It should be tagged in 
	METAUNITS as 'int', or else an error will be returned. In case of any error,
	the returned value will be MOTAB_NO_INT. See `motab_get_meta_double`.
*/
ST_EXPORT int motab_get_meta_int(MotabData *tab, const char *name, int *err);

/**
	Get the string value of metadata item `name`. It should be tagged in 
	METAUNITS as 'str', or else an error will be returned. In case of any error,
	the returned value will be MOTAB_NO_INT. See `motab_get_meta_double`.
	
	Note that you will 'own' the returned string, and should `free` it when
	you don't need it any more.
*/
ST_EXPORT char *motab_get_meta_str(MotabData *tab, const char *name, int *err);

/*------------------------------------------------------------------------------
  functions relating to the metadata for weather files
*/

/**
	Read the latitude (in degrees North) from st_motab metadata. If there is a
	real-valued metadata field called 'lat', with units of 'deg', then return 
	its value. If not, return the value MOTAB_NO_REAL instead.
*/
ST_EXPORT double motab_get_meta_lat(MotabData *tab);

/**
	Read the longitude (in degrees East) from st_motab metadata. See
	`motab_get_meta_lat`.
*/
ST_EXPORT double motab_get_meta_lon(MotabData *tab);

/**
	Read the elevation (in metres) from st_motab metadata. See
	`motab_get_meta_lat`.
*/
ST_EXPORT double motab_get_meta_elev(MotabData *tab);

/**
	Read the timezone (in hours ahead of GMT/UTC) from st_motab metadata. See
	`motab_get_meta_lat`.
*/
ST_EXPORT double motab_get_meta_tzone(MotabData *tab);


/**
	Read the location from st_motab metadata. Return NULL if not such
	metadata is found. Note that the returned string must be freed.
	
	FIXME when returning a string to Modelica, we are supposed to have
	allocated it using ModelicaAllocateString.
*/
ST_EXPORT char *motab_get_meta_loc(MotabData *tab);

#ifdef ST_EXPORT_USERTAB
ST_EXPORT int motab_set_usertab(MotabData *tab);
#endif

#endif
/* vim: ts=4:sw=4:noet:tw=80 */
