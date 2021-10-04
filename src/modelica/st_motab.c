#include "parse.h"

#define ST_MOTAB_DLL
#include "st_motab.h"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

//#define MOTAB_DEBUG
#ifdef MOTAB_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

#define ERR(FMT,...) fprintf(stderr,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)

#define NEW(TYPE) (TYPE *)malloc(sizeof(TYPE))
#define NEW_ARRAY(TYPE,N) (assert(N!=0), (TYPE *)malloc(N*sizeof(TYPE)))

#define MAXCHARS 4192

extern void ModelicaFormatError(const char* string, ...);

static char *newcopy(const char *s){
	MSG("Copying s = '%s', len = %lu",s,strlen(s));
	size_t l = (1+strlen(s))*sizeof(char);
	char *c = malloc(l);
	memcpy(c,s,l);
	return c;
}

static cbool parseMotabHeader(Parser *P,char *name,unsigned maxl,unsigned *nrows,unsigned *ncols);

static cbool parseMetaDataHeaders(Parser *P,MotabData *tab);

static unsigned motab_get_nmeta(MotabData *tab);

/**
	Selectively read just the time and DNI from a weather data file.
	
	FIXME transition to using Modelica's external functions for loading data and interpolating.
*/
MotabData *motab_load(const char *filepath){
	char line[MAXCHARS];
	unsigned i = 0;

	FILE* fp;
	fp = fopen(filepath,"r");  
	MSG("Reading motab file '%s'",filepath);   
	if (fp == NULL){
		ERR("Unable open motab file '%s'. Please check the file name",filepath);
		return NULL;
	}

	/* read the metadata line */
	MotabData *tab = NEW(MotabData);if(!tab)return NULL;
	tab->meta = NULL;
	tab->vals = NULL;
	tab->timecol = MOTAB_NO_COL;
	tab->timestep = 0;

	Parser *P = parseCreateFile(fp);
	
	MSG("Reading header...");
	char tablename[MAXCHARS];
	if(parseMotabHeader(P,tablename,MAXCHARS,&(tab->nrows),&(tab->ncols))){
		tab->name = newcopy(tablename);
		parseMetaDataHeaders(P,tab);
		MSG("Got %u metadata rows",motab_get_nmeta(tab));
		MSG("Reading %u rows and %u cols...",tab->nrows,tab->ncols);
	}else{
		motab_free(tab);
		parseDispose(P);
		return NULL;
	}
	
	tab->vals = NEW_ARRAY(double,tab->nrows*tab->ncols);
	assert(tab->vals);
	
	double val;
	for(int r=0; r<tab->nrows; ++r){
		for(int c=0; c<tab->ncols; ++c){
			if(
				((c == 0) || parseThisString(P,","))
				&& maybe(parseWS(P))
				&& parseDouble(P,&val) 
				&& maybe(parseWS(P))
				&& (c < tab->ncols - 1 || parseEOL(P))
				&& assign(MOTAB_VAL(tab,r,c)=val)
			){
				//MSG("(%d,%d) = %lf",r,c,MOTAB_VAL(tab,r,c));
			}else{
				ERR("Unexpected characters at row %d, col %d",r,c);
				char ctx[MAXCHARS];
				parseStrExcept(P,"\n\r",ctx,MAXCHARS);
				ERR("Current context: %s",ctx);
				parseDispose(P);
				motab_free(tab);
				return NULL;
			}
		}
		//MSG("Finished row %d",r);
	}
	
	// at this point, we KNOW we have successfully read all of the require rows and columns of data
	// although it's possible there is still more data in the file that we haven't read.
	
	// TODO we haven't done anything smart yet with the MotabMetaData.
	
	MSG("Finished reading file.");
	parseDispose(P);
	fclose(fp);
	return tab;
}


cbool parseMotabHeader(Parser *P,char *name,unsigned maxl,unsigned *nrows,unsigned *ncols){
	return
		((
			parseThisString(P,"#1")
			&& parseEOL(P)
			) || parseError(P,"Unrecognised first line in table file.")
		) && ((
			parseThisString(P,"double ")
			&& parseStrExcept(P," (\n\t",name,maxl)
			&& maybe(parseWS(P)) && parseThisString(P,"(")
			&& maybe(parseWS(P)) && parseNumber(P,nrows)
			&& maybe(parseWS(P)) && parseThisString(P,",")
			&& maybe(parseWS(P)) && parseNumber(P,ncols)
			&& maybe(parseWS(P)) && parseThisString(P,")")
			&& parseEOL(P)
			) || parseError(P,"Unable to parse second line in table file.")
		);
}

/**
	Store a metadata row in the linked list tab->meta.
	Note that we take a copy of the string `row` which must later be freed.
*/
static void motab_add_meta(MotabData *tab,char *row){
	MotabMetaData *M = NEW(MotabMetaData);
	assert(row != NULL);
	M->row = newcopy(row);
	assert(M->row != NULL);
	if(tab->meta){
		// insert this row at the start of the linked list
		M->next = tab->meta;
		tab->meta = M;
	}else{
		// this is the first row
		tab->meta = M;
		M->next= NULL;
	}
}

/**
	Parse a metadata row -- nothing smart, just read to the EOL and store the text.
*/
static cbool parseMetaRow(Parser *P,MotabData *tab){
	char row[MAXCHARS];
	return (
		parseThisString(P,"#")
		&& parseStrExcept(P,"\n\r",row,MAXCHARS)
		&& parseEOL(P)
#ifdef MOTAB_DEBUG
		&& assign(MSG("Metadata row '%s'",row))
#endif
		&& assign(motab_add_meta(tab,row))
	);
}

/**
	Store as many lines starting with # as we need, no limit applied.
*/
cbool parseMetaDataHeaders(Parser *P,MotabData *tab){
	return many(parseMetaRow(P,tab));
}


void motab_free(MotabData *tab){
	if(tab){
		if(tab->vals){
			free(tab->vals);
		}
		if(tab->meta){
			MotabMetaData *M = tab->meta;
			MotabMetaData *N;
			while(M){
				if(M->row)free(M->row);
				N = M->next;
				free(M);
				M = N;
			}
		}
		if(tab->name){
			free(tab->name);
		}
		free(tab);
	}
}

unsigned motab_get_nmeta(MotabData *tab){
	unsigned nmeta = 0;
	MotabMetaData *M = tab->meta;
	while(M){
		nmeta++;
		M = M->next;
	}
	return nmeta;
}

static const char motab_empty[] = "";


const char *motab_find_meta_row(MotabData *tab, const char *tag){
	assert(tab);
	char s[MAXCHARS] = "";
	if(tab->meta){
		MotabMetaData *M = tab->meta;
		while(M){
			// get the tag for this row:
			assert(M->row);
			char *c = &(M->row[0]);
			char *d = &(s[0]);
			while(*c!='\0' && *c != ','){
				*d++ = *c++;
			}
			*d = '\0';
			MSG("Found tag '%s'",s);
			if(0==strcmp(s,tag)){
				if(*c == '\0')return motab_empty;
				else{
					++c;
					MSG("For tag '%s', row = '%s'",tag,c);
					return c;
				}
			}
			M = M->next;
		}
	}
	return NULL;
}

/*
	For comma-separated string of items `row`, parse and return the item in position
	`ind`, counting from zero. Return NULL if not found. If a string returned, you
	own it and must free it when you're done.
*/
static char *get_item_in_commastring(const char *row,int ind){
	assert(ind >= 0);
	assert(row);
	char s[MAXCHARS] = "";
	const char *c = &(row[0]);
	char *d = &(s[0]);
	int i = 0;
	while(*c != '\0'){
		//MSG("Copying '%c'",*c);
		*d++ = *c++;
		if(*c == ',' || *c == '\0'){
			*d = '\0';
			MSG("Got '%s'",s);
			if(i == ind){
				MSG("Got match '%s' for field %d",s,i);
				return newcopy(s);
			}
			MSG("Moving to next field");
			i++;
			d = &(s[0]);
			if(*c != '\0')c++;
		}
	}
	MSG("Not found");
	return NULL;
}


char *motab_get_col_units(MotabData *tab, const char *label){
	assert(tab);
	MSG("Searching for units of col '%s'",label);
	const char tag[] = "TABLEUNITS";
	const char *row = motab_find_meta_row(tab,tag);
	if(!row){
		ERR("Invalid tag '%s'",tag);
		return NULL;
	}
	int col = motab_find_col_by_label(tab,label);
	if(-1==col){
		ERR("Invalid column label '%s'",label);
		return NULL;
	}
	MSG("Getting field %d in row '%s'",col,row);
	char *field = get_item_in_commastring(row,col);
	MSG("Field is '%s'",field);
	if(NULL == field){
		ERR("Field %d not found in '%s'",col,row);
		free(field);
		return NULL;
	}
	return field;
}

/*
	Search `metarow` as a comma-separated list, looking for string `label`.
	If found, return its position in the list, counting from 0. If it is not
	found, return -1.
*/
static int find_item_in_commastring(const char *metarow,const char *label){
	MSG("Got row '%s', looking for '%s'",metarow,label);
	char s[MAXCHARS] = "";
	const char *c = &(metarow[0]);
	char *d = &(s[0]);
	int i = 0;
	while(*c != '\0'){
		//MSG("copying char '%c'",*c);
		*d++ = *c++;
		if(*c == ',' || *c == '\0'){
			*d = '\0';
			MSG("Found label %d '%s'",i,s);
			if(0==strcmp(s,label)){
				MSG("Match!");
				return i;
			}
			d = &(s[0]);
			if(*c != '\0'){
				MSG("Moving past '%c'",*c);
				while(*(++c) == ' '){
					MSG("Moving past '%c'",*c);
				}
			}
			i++;
		}
	}
	MSG("No match");
	return -1;
}


int motab_find_col_by_label(MotabData *tab, const char *label){
	const char *row;
	row = motab_find_meta_row(tab,"TABLELABELS");
	if(row == NULL){
		return -1;
	}
	return find_item_in_commastring(row,label);
}


int motab_check_timestep(MotabData *tab, double *step_return){
	assert(tab);
	int time_col = motab_find_col_by_label(tab,"time");
	if(time_col == -1){
		ERR("No 'time' column found in Motab");
		tab->timecol = MOTAB_NO_COL;
		return 1;
	}
	tab->timecol = time_col;
	char *units = motab_get_col_units(tab,"time");
	if(0 != strcmp(units,"s")){
		ERR("Units for column 'time' are not 's' as expected. Got '%s' instead.",units);
		free(units);
		return 2;
	}
	free(units);
	if(tab->nrows < 2){
		ERR("Table does not have two or more rows");
		return 3;
	}
	double delta = MOTAB_VAL(tab,1,time_col) - MOTAB_VAL(tab,0,time_col);
	double t;
	for(int r=2;r < tab->nrows; ++r){
		t = MOTAB_VAL(tab,r,time_col);
		//MSG("t = %lf",t);
		if(delta != t - MOTAB_VAL(tab,r-1,time_col)){
			ERR("Incorrect time increment at t = %lf",t);
			return 4;
		}
	}
	tab->timestep = delta;
	if(step_return)*step_return = delta;
	return 0;
}


double motab_get_value(MotabData *tab, double time, int col){
	assert(tab);
	int err;
	MSG("Evaluating at t=%f, col=%d",time,col);
	if(tab->timecol == MOTAB_NO_COL){
		if(err = motab_check_timestep(tab,NULL)){
			ERR("Error %d in motab timestep.",err);
			return -9999.;
		}
	}
	MSG("Timestep = %f",tab->timestep);
	double rowrat = time/tab->timestep;
	int row = (int)rowrat;
	double frac = rowrat - row;
	if(row < 0){
			ERR("Time is below range of Motab");
			return -9999.;
	}
	if(row >= tab->nrows){
			ERR("Time is above range of Motab");
			return -9999.;
	}
	if(col < 0 || col >= tab->ncols){
			ERR("Column is out of range of Motab");
			return -9999.;
	}
	
	MSG("row = %d, col = %d", row, col);
	double val = MOTAB_VAL(tab,row,col);
	if(frac > 0){
		if(row == tab->nrows - 1){
			ERR("Value %f is beyond the last row.",time);
			return -9999.;
		}
		val = val * (1-frac) + MOTAB_VAL(tab,row + 1,col) * frac;
	}
		
	MSG("val = %f",val);
	return val;
}


MotabMetaItem *get_meta_item(MotabData *tab, const char *name,int *err){
	MotabMetaItem *item = NEW(MotabMetaItem);
	item->name = name;
	item->units = NULL;
	if(err)*err=0;
#define RETERR(ERRN){if(err)*err=ERRN;motab_meta_free(item);return NULL;};
	if(!tab)RETERR(1);
	const char *metalabels = motab_find_meta_row(tab,"METALABELS");
	if(NULL == metalabels)RETERR(2);
	int pos = find_item_in_commastring(metalabels,name);
	if(-1 == pos)RETERR(3);
	const char *metaunits = motab_find_meta_row(tab,"METAUNITS");
	if(NULL == metaunits)RETERR(4);
	const char *metadata = motab_find_meta_row(tab,"METADATA");
	if(NULL == metadata)RETERR(5);
	
	char *units = get_item_in_commastring(metaunits,pos);
	if(NULL == units)RETERR(6);
	MSG("units = '%s'",units);

	char *val = get_item_in_commastring(metadata,pos);
	if(NULL == val){
		free(units);
		RETERR(7);
	}
	MSG("raw val = '%s'",val);

	if(0==strcmp(units,"str")){
		item->type = MOTAB_STR;
		item->u.str = val;
		MSG("Got meta str '%s', value '%s'",name,val);
		if(err)*err=0;
		free(units);
		return item;
	}
	
	Parser *P = parseCreateString(val);	
	if(0==strcmp(units,"int")){
		item->type = MOTAB_INT;
		if(parseSignedNumber(P,&(item->u.ival))){
			parseDispose(P);
			free(val);
			free(units);
			MSG("Got meta int '%s', value '%d'",name,item->u.ival);
			return item;
		}
		parseDispose(P);
		free(val);
		free(units);
		RETERR(8);
	}else{
		item->type = MOTAB_REAL;
		item->units = units; // not a copy, it's owned by `item` now.
		if(parseDouble(P,&(item->u.dval))){
			parseDispose(P);
			free(val);
			MSG("Got meta value '%s', value '%f'",name,item->u.dval);
			return item;
		}
		item->units = NULL; // to avoid double free in RETERR below.
	}
	parseDispose(P);
	free(val);
	free(units);
	RETERR(9);
#undef RETERR
}

void motab_meta_free(MotabMetaItem *item){
	if(!item)return;
	if(item->type == MOTAB_STR){
		assert(item->units == NULL);
		if(item->u.str)free(item->u.str);
	}else if(item->type == MOTAB_REAL){
		if(item->units)free(item->units);
	}else if(item->type == MOTAB_INT){
		assert(item->units == NULL);
	}
	free(item);
}

double motab_get_meta_real(MotabData *tab, const char *name, char **units, int *err){
	int myerr = 0;
	MotabMetaItem *item = get_meta_item(tab, name, &myerr);
	if(item == NULL){
		ERR("Error %d when loading meta item '%s'",myerr,name);
		if(err)*err = 1;
		return MOTAB_NO_REAL;
	}
	if(item->type != MOTAB_REAL){
		ERR("Error %d when loading meta item '%s'",myerr,name);
		motab_meta_free(item);
		if(err)*err = 2;
		return MOTAB_NO_REAL;
	}
	if(units){
		assert(item->units); // has to be something, can't be empty.
		*units = newcopy(item->units);
	}
	if(err)*err = 0;
	double val = item->u.dval;
	motab_meta_free(item);
	return val;
}


char *motab_get_meta_str(MotabData *tab, const char *name, int *err){
	int myerr = 0;
	MotabMetaItem *item = get_meta_item(tab, name, &myerr);
	if(item == NULL){
		ERR("Error %d when loading meta item '%s'",myerr,name);
		if(err)*err = 1;
		return NULL;
	}
	if(item->type != MOTAB_STR){
		ERR("Metadata item '%s' is not of type 'str'",name);
		motab_meta_free(item);
		if(err)*err = 2;
		return NULL;
	}
	if(err)*err = 0;
	char *str = item->u.str;
	assert(item->units == NULL);
	free(item);
	return str;
}



int motab_get_meta_int(MotabData *tab, const char *name, int *err){
	int myerr = 0;
	MotabMetaItem *item = get_meta_item(tab, name, &myerr);
	if(item == NULL){
		ERR("Error %d when loading meta item '%s'",myerr,name);
		if(err)*err = 1;
		return MOTAB_NO_INT;
	}
	if(item->type != MOTAB_INT){
		ERR("Metadata item '%s' is not of type 'int'",name);
		motab_meta_free(item);
		if(err)*err = 2;
		return MOTAB_NO_INT;
	}
	if(err)*err = 0;
	int val = item->u.ival;
	motab_meta_free(item);
	return val;
}

double motab_get_meta_lat(MotabData *tab){
	int err;
	char *units;
	double val = motab_get_meta_real(tab, "lat", &units, &err);
	assert(units);
	int cmp = strcmp(units,"deg");
	free(units);
	if(err || cmp)return MOTAB_NO_REAL;
	return val;
}

double motab_get_meta_lon(MotabData *tab){
	int err;
	char *units;
	double val = motab_get_meta_real(tab, "lon", &units, &err);
	assert(units);
	int cmp = strcmp(units,"deg");
	free(units);
	if(err || cmp)return MOTAB_NO_REAL;
	return val;
}


double motab_get_meta_tzone(MotabData *tab){
	int err;
	char *units;
	double val = motab_get_meta_real(tab, "tzone", &units, &err);
	assert(units);
	int cmp = strcmp(units,"h");
	free(units);
	if(err || cmp)return MOTAB_NO_REAL;
	return val;
}


double motab_get_meta_elev(MotabData *tab){
	int err;
	char *units;
	double val = motab_get_meta_real(tab, "elev", &units, &err);
	assert(units);
	int cmp = strcmp(units,"m");
	free(units);
	if(err || cmp)return MOTAB_NO_REAL;
	return val;
}


char *motab_get_meta_loc(MotabData *tab){
	int err;
	char *loc = motab_get_meta_str(tab, "name", &err);
	if(err){
		if(loc)free(loc);
		return NULL;
	}
	return loc;
}

#ifdef ST_EXPORT_USERTAB
int motab_set_usertab(MotabData *tab){

}
#endif





// vim: ts=4:sw=4:noet:tw=80

