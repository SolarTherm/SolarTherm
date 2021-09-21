#ifndef ST_MOTAB_H
#define ST_MOTAB_H

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

/* we're looking for header data of the following kind, as documented
https://doc.modelica.org/Modelica%203.2.3/Resources/helpMapleSim/Blocks/Tables/index.html

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

This class supersedes the linprog.c routines for loading specific files used
in the optimal dispatch routines.

The internal data structure is simpler than the one in st_tables, because it 
makes use of the .motab file header to allocate memory using a single malloc.
On the other hand, it's more complex because provides access to the metadata
fields.

In principle, it should be possible to link these routines with the 
'userdata' feature of ExternalCombiTable1D from the Modelica Standard Library
to implement interpolation.

st_motab is not going to be a good choice with very large data sets -- our 
typical use is with files having 8,760 rows and ~10 cols (hourly data for one
year), but up to larger is probably fine too OK (1 minute data), up to some 
limit where a memory-mapped file may become preferable.
*/

#define MOTAB_VAL(TABLE,ROW,COL) (TABLE)->vals[(COL) + (ROW)*(TABLE->ncols)]

/**
	Data structure for storing metadata rows from the start of the file
	(except for the first two lines, which define the format version and
	table name, type and number of rows and columns.
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
	char *name;
	double *vals;
	unsigned nrows;
	unsigned ncols;
	MotabMetaData *meta;
} MotabData;

/**
	Load the motab file, return NULL if anything is wrong. File-reading error \
	messages are output to stderr.
*/
ST_EXPORT MotabData *motab_load(const char *filepath);

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
	Check that the file has regular timesteps, and return the value 
	of that step. Return non-zero if there is any error in the timesteps, or
	else zero if everything is fine. If `step` is not NULL, the step size 
	will be returned there.
	
	This function checks the metadata to make sure the step column is labelled
	to be in seconds, and the timestep is returned in units of seconds.
*/
ST_EXPORT int motab_check_timestep(MotabData *tab, double *step);

/**
	Look up the units of measurement specified for a column in the file.
	Return NULL if not found.
	
	You must free the string returned by this function.

*/
ST_EXPORT char *motab_get_col_units(MotabData *tab, const char *label);

#endif
/* vim: ts=4:sw=4:noet:tw=80 */
