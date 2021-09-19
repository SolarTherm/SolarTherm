#ifndef PARSE_H
#define PARSE_H

#include <stdio.h>

typedef char cbool;
#define TRUE ((cbool)1)
#define FALSE ((cbool)0)

/* macros */

#define catVariable (catAlpha | catDigit | catUnderscore)
#define catKeyword  (catAlpha | catDigit | catMinus)

#define parseLexThisVariable(p,s) parseLexThisCategory(p,catVariable,s)
#define parseLexVariable(p,s)     parseLexCategory(p,catVariable,s)

#define parseLexThisKeyword(p,s)  parseLexThisCategory(p,catKeyword,s)
#define parseLexKeyword(p,s)      parseLexCategory(p,catKeyword,s)

#define parseLexThisOper(p,s)     parseLexThisCategory(p,catOper,s)
#define parseLexOper(p,s)         parseLexCategory(p,catOper,s)

#define assign(ass)               (ass,1)
#define done                      (1)
#define fail                      (0)

#ifdef __GNUC__

#define many(p)                   ({while(p);1;})
#define maybe(p)                  (p,1)
#define one_or_more(p)            (p && many(p))

#endif

/* types */

typedef enum
{
  catAlpha      = 1,
  catDigit      = 2,
  catOper       = 4,
  catBracket    = 8,
  catQuote      = 16,

  catMinus      = 32,
  catUnderscore = 64
} category;

typedef
  category
  *judgement;

struct _parse;

typedef
  cbool
  (parseGetCharFunction)( struct _parse *, char * );

typedef
  cbool
  (parseUnGetCharFunction)( struct _parse *, char );

typedef
  void
  (parseDisposeFunction)( struct _parse * );

/**
	Parser data structure, keeps track of the data stream being parsed,
	and permits characters to be returned to the stream in the case where
	a particular pattern is not matched.
*/
typedef struct _parse{
  char      *buf;
  int       bufptr;
  judgement judge;
  int       line;

  /* for FILE implementations */
  FILE      *file;

  /* for string implementations */
  char      *contents;
  int       ptr;

  parseGetCharFunction   *getChar;
  parseUnGetCharFunction *unGetChar;
  parseDisposeFunction   *dispose;
} Parser;

/* functions */

Parser *parseCreateFile( FILE *file );
Parser *parseCreateString( char *s );
void parseDispose( Parser *p );

void parseSetJudgement( Parser *p, short c, category );
void parseAddJudgement( Parser *p, short c, category );
category parseGetJudgement( Parser *p, short c );

cbool parseError( Parser *p, char *s );
cbool parseEnd( Parser *p );

cbool parseAChar( Parser *p, char *c );
cbool parseAnyChar( Parser *p );
cbool parseThisChar( Parser *p, char c );
cbool parseUnParseChar( Parser *p, char c );

cbool parseThisString( Parser *p, const char *s );
cbool parseUnParseString( Parser *p, char *s );

cbool parseDigit( Parser *p, char *c );
cbool parseNumber( Parser *p, unsigned *n );
cbool parseSignedNumber( Parser *p, int *n );

cbool parseCharCategory( Parser *p, category cat, char *c );

cbool parseLexThisCategory( Parser *p, category cat, char *s );
cbool parseLexCategory( Parser *p, category cat, char *s );
cbool parseLexNumber( Parser *p, unsigned *n );
cbool parseLexSignedNumber( Parser *p, int *n );
cbool parseLexThisString( Parser *p, char *s );
//cbool parseLexThisChar( Parser *p, char c );
cbool parseLexEnd( Parser *p );

//cbool parseQuoted( Parser *p, char *s );
//cbool parseLexQuoted( Parser *p, char *s );

/* john's useful stuff */
cbool parseEOL(Parser *p);
cbool parseWhiteChar(Parser *p);
cbool parseWS(Parser *p);
cbool parseCharIn(Parser *p, const char *incl, char *c);
cbool parseCharExcept( Parser *p, const char *except, char *c );
cbool parseStrExcept(Parser *p, const char *except, char *str, int maxl);
cbool parseNonWS(Parser *p, char *str, int maxl);
cbool parseEOLplus(Parser *p);
cbool parseDouble(Parser *p, double *d);

#endif /* PARSE_H */
