/* parse.c */

#include "parse.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define PARSER_DEBUG
#ifdef PARSER_DEBUG
# define MSG(FMT,...) fprintf(stdout,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)
#else
# define MSG(...) ((void)0)
#endif

#define ERR(FMT,...) fprintf(stderr,"%s:%d: " FMT "\n",__FILE__,__LINE__,##__VA_ARGS__)

#define NEW(TYPE) (TYPE *)malloc(sizeof(TYPE))
#define NEW_ARRAY(TYPE,N) (TYPE *)malloc(N*sizeof(TYPE))

/* macros */

#define BUFSIZE 300

static int CharactersInDouble(const char *p);

/* functions */


static void parseInitJudgement( judgement judge )
{
  const char *oper    = "!@#$%^&*+-=|\\~:<>./";
  const char *bracket = "[]{}()";
  const char *quote   = "\"'`";
  short c;
  int i;
  
  for ( i = 0; i < 256; i++ )
    judge[i] = 0;
  
  for ( c = 'a'; c <= 'z'; c++ )
    judge[c] = judge[c] | catAlpha;
  
  for ( c = 'A'; c <= 'Z'; c++ )
    judge[c] = judge[c] | catAlpha;
  
  for ( c = '0'; c <= '9'; c++ )
    judge[c] = judge[c] | catDigit;
  
  for ( i = 0; c = oper[i], c != '\0'; i++ )
    judge[c] = judge[c] | catOper;
  
  for ( i = 0; c = bracket[i], c != '\0'; i++ )
    judge[c] = judge[c] | catBracket;
  
  for ( i = 0; c = quote[i], c != '\0'; i++ )
    judge[c] = judge[c] | catQuote;
  
  judge['_'] = judge['_'] | catUnderscore;
  judge['-'] = judge['-'] | catMinus;
}

static void parseStandardDisposeFunction( Parser *p )
{
  free( p->buf );
  free( p->judge );
  free( p );
}

static cbool parseStandardUnGetCharFunction( Parser *p, char c )
{
  p->buf[p->bufptr] = c;
  
  if ( ++p->bufptr >= BUFSIZE )
  {
    p->bufptr--;
    return FALSE;
  }
  
  if ( c == '\n' )
    p->line--;
  
  return TRUE;
}

static void parseFileDisposeFunction( Parser *p )
{
  free( p->buf );
  free( p->judge );
  fclose( p->file );
  free( p );
}

static cbool parseFileGetCharFunction( Parser *p, char *c )
{
  if ( p->bufptr )
    *c = p->buf[--p->bufptr];
  else
    *c = getc( p->file );
  
  if ( *c == '\n' )
    p->line++;
  
  return ( *c != EOF );
}

static cbool parseStringGetCharFunction( Parser *p, char *c )
{
  if ( p->bufptr )
    *c = p->buf[--p->bufptr];
  else if ( p->contents[p->ptr] != '\0' )
    *c = p->contents[p->ptr++];
  else
    return FALSE;
  
  if ( *c == '\n' )
    p->line++;
  
  return TRUE;
}

Parser *parseCreateFile( FILE *file )
{
  Parser *p     = NEW(Parser);

  p->file      = file;
  p->buf       = NEW_ARRAY( char, BUFSIZE );
  p->bufptr    = 0;
  p->judge     = NEW_ARRAY( category, 256 );
  parseInitJudgement( p->judge );
  p->line      = 1;
  
  p->getChar   = parseFileGetCharFunction;
  p->unGetChar = parseStandardUnGetCharFunction;
  p->dispose   = parseStandardDisposeFunction;
  
  return p;
}

Parser *parseCreateString( char *contents )
{
  Parser *p     = NEW( Parser );

  p->contents  = contents;
  p->ptr       = 0;
  p->buf       = NEW_ARRAY( char, BUFSIZE );
  p->bufptr    = 0;
  p->judge     = NEW_ARRAY( category, 256 );
  parseInitJudgement( p->judge );
  p->line      = 1;
  
  p->getChar   = parseStringGetCharFunction;
  p->unGetChar = parseStandardUnGetCharFunction;
  p->dispose   = parseStandardDisposeFunction;
  
  return p;
}

void parseSetJudgement( Parser *p, short c, category cat )
{
  p->judge[c] = cat;
}

void parseAddJudgement( Parser *p, short c, category cat ){
  p->judge[c] = p->judge[c] | cat;
}

category parseGetJudgement( Parser *p, short c ){
  return p->judge[c];
}

cbool parseError( Parser *p, char *s ){
  char rest[300];
  int i;
  
  for ( i = 0
      ; parseAChar( p, rest+i ) && rest[i] != '\n' && i < 50
      ; i++
      );
  
  rest[i]   = '\n';
  rest[i+1] = '\0';
  
  ERR("Parser error, line %d: %s\n... %s", p->line, s, rest);
  return TRUE;
}

cbool parseEnd( Parser *p ){
  char c;
  return ( !parseAChar( p, &c )
        || !parseUnParseChar( p, c )
         );
}

cbool parseAChar( Parser *p, char *c ){
  return p->getChar( p, c );
}

cbool parseAnyChar( Parser *p ){
  char c;
  return parseAChar( p, &c );
}

cbool parseThisChar( Parser *p, char c ){
  char d;
  if ( !p->getChar( p, &d ) )
    return FALSE;
  
  if ( d == c )
    return TRUE;
  
  parseUnParseChar( p, d );
  return FALSE;
}

cbool parseUnParseChar( Parser *p, char c ){
  return p->unGetChar( p, c );
}

cbool parseThisString( Parser *p, const char *s ){
  int i;
  //char c;
  
  for ( i = 0
      ; s[i] != '\0' && parseThisChar( p, s[i] )
      ; i++
      );
  
  if ( s[i] == '\0' )
    return TRUE;
  
  for ( i-- ; i >= 0; i-- )
    parseUnParseChar( p, s[i] );
  
  return FALSE;
}

cbool parseUnParseString( Parser *p, char *s ){
  int i;
  
  for ( i = strlen(s)-1; i >= 0; i-- )
    parseUnParseChar( p, s[i] );
  
  return TRUE;
}

cbool parseDigit( Parser *p, char *c ){
  return ( parseAChar( p, c )
        && ( ('0' <= *c && *c <= '9')
          || (parseUnParseChar( p, *c )
	          && FALSE)
           )
         );
}

cbool parseNumber( Parser *p, unsigned *n ){
  unsigned i = 0;
  char s[300];
  
  while ( parseDigit( p, &(s[i]) )
       && assign ( i++ )
        );
  
  return ( i > 0
        && assign( s[i] = '\0' )
        && assign( *n = atoi( s ) )
         );
}

cbool parseSignedNumber( Parser *p, int *n ){
	unsigned un;
	return (
		(parseThisChar( p, '-' )
			&& parseNumber( p, &un )
			&& assign( *n = -(*n) )
		) || (parseThisChar( p, '+' )
			&& parseNumber( p, &un )
		) || (
			parseNumber( p, &un )
		)
	) && assign(*n = un);
}

cbool parseCharCategory( Parser *p, category cat, char *c ){
	return (
		parseAChar( p, c )
		&& (
			(cat & p->judge[(short)*c])
			|| !parseUnParseChar( p, *c )
		)
	);
}

cbool parseLexThisCategory( Parser *p, category cat, char *s )
{
  int i;
  char c;
    
  for ( i = 0
      ; s[i] != '\0' && parseThisChar( p, s[i] )
      ; i++
      );
  
  if ( s[i] == '\0' )
	if(
		!parseAChar( p, &c )
      	|| (
			parseUnParseChar( p, c )
			&& !( cat & p->judge[(short)c])
		)
    ){
		return TRUE;
	}
  
  for ( i-- ; i >= 0; i-- )
    parseUnParseChar( p, s[i] );
  
  return FALSE;
}

cbool parseLexCategory( Parser *p, category cat, char *s )
{
  int i = 0;

  while ( parseCharCategory( p, cat, s+i )
       && assign ( i++ )
        );
  
  return ( i > 0
        && assign( s[i] = '\0' )
         );
}

#if 0
cbool parseQuoted( Parser *p, char *name ){
  char c;
  int i = 0;
  
  if ( parseLexThisChar( p, '"' ) )
  {
    while ( parseAChar( p, &c )
         && c != '"'
         && c != '\n'
         && assign ( name[i++] = c )
          );
    if ( c == '"' )
    {
      name[i] = '\0';
      return TRUE;
    }
    else
      parseError( p, "Could not parse quoted string" );
  }
  
  return FALSE;
}

cbool parseLexQuoted( Parser *p, char *s ){
  return ( parseWS( p )
        && parseQuoted( p, s )
         );
}
#endif

void parseDispose( Parser *p ){
  p->dispose( p );
}

/*------- john's useful routines --------------*/


cbool parseEOL(Parser *p){
	return (
		parseThisChar(p,'\n')
		|| (parseThisChar(p,'\r') && maybe(parseThisChar(p,'\n')))
	);
}

cbool parseWhiteChar(Parser *p){
	return (
		parseThisChar(p,' ')
		|| parseThisChar(p,'\t')	
	);
}

cbool parseWS(Parser *p){
	return parseWhiteChar(p) && many(parseWhiteChar(p));
}

cbool parseCharIn(Parser *p, const char *incl, char *c){
	const char *i;
	if(parseAChar(p,c)){
		for(i=incl; *i!='\0'; ++i){
			if(*c==*i){
				return TRUE;
			}
		}
		parseUnParseChar(p,*c);
		return FALSE;
	}
	return FALSE;
}

cbool parseCharExcept( Parser *p, const char *except, char *c ){
	const char *e;
	if(parseAChar( p, c )){
		for(e=except; *e!='\0'; ++e){
			if(*c==*e){
				//fprintf(stderr,"UNPARSING %c (%d)\n",*c,*c);
				parseUnParseChar(p,*c);
				return FALSE;
			}
		}
		return TRUE;
	}
	return FALSE;
}

cbool parseStrExcept(Parser *p, const char *except, char *str, int maxl){
	char *c=str;
	int i = 0;
	while(i+1<maxl && parseCharExcept(p,except,c)){
		//fprintf(stderr,"GOT CHAR %c\n",*c);
		i++,c++;
	}
	*c = '\0'; ++i;
	if(i>maxl){
		//fprintf(stderr,"I > MAXL\n");		
		while(--i>0){
			//fprintf(stderr,"unparse '%s'\n",*c);
			parseUnParseChar(p,*(--c));
		}
		//fprintf(stderr,"FAIL\n",*c);
		return fail;
	}
	//fprintf(stderr,"GOT SOME? i=%d\n",i);
	return (i>0);
}

cbool parseNonWS(Parser *p, char *str, int maxl){
	return parseStrExcept(p," \t\n\r\f",str,maxl);
}

cbool parseEOLplus(Parser *p){
	return (
		maybe(parseWS(p))
		&& parseEOL(p)
		&& many(maybe(parseWS(p)) && parseEOL(p))
	);
}

cbool parseDouble(Parser *p, double *d){
	char word[150];
	int l;
	if(parseNonWS(p,word,150)){
		l = CharactersInDouble(word);
		if(l < strlen(word)){
			parseUnParseString(p,word+l);
		}
		if(l==0){
			return 0;
		}
		word[l] = '\0';
		*d = atof(word);
		return 1;
	}else{
		return 0;
	}
}

//
// CharactersInDouble
// This code is not protected by copyright and is in the public domain.
// Author: Meritt Reynolds

//	Parse a string and return the number of characters making up the representation 
//	of a floating point number.  No conversion is done here, the goal is to identify 
//	the existence and length of the number.  The conversion is best done by system
//	routines like atof, sscanf, etc.
//
//	Returns 0 if there is no valid number present.
//
//	Does not skip white space so first character must be part of the number.  If you
//	don't care about white space then skip it before calling CharactersInDouble.
//
//	Example:
//
//		while (isspace(p)) p++;
//		n = CharactersInDouble(p);
//		if (n)
//		{
//			x = atof(p);
//			p += n;		// move to unparsed part of string
//		}
//
//	HOW IT WORKS
//
//	A finite state machine with eight states is used to parse numbers that might 
//	be in scientific notation.  Exponent can be indicated by 'e' or 'E'.
//	Might want to generalize to 'd' and 'D' as well so old FORTRAN output
//	doesn't cause problems.
//
//	Valid numbers:
//		1			integer is a double
//		-1			negative numbers OK
//		+1			explicit + sign OK
//		1.			trailing . OK
//		.1			leading . OK
//		1e2			exponent without . before
//		1e+2		exponent with explicit +
//		1e-2		exponent with -
//		1.e2		exponent with . before
//		1.1e1		full mantissa
//		1.34e+4		general test
//
//	There is no "looking forward".  For example, this subroutine does 
//	not forgive trailing 'e'.  If it gets an 'e' it insists on a valid exponent.
//
//	Invalid numbers:
//		" 1"		leading white space
//		-a			no digit after the -
//		a			not a digit
//		1e			e assumed to be part of number, but exponent is missing
//
//	Validly terminated numbers:
//
//		1.7a		a clearly not part of the number  (returns 3)
//		1.e-7e		2nd e clearly not part of the number  (returns 5)

int CharactersInDouble(const char *p){
	int len = strlen(p);	// in C# we will use something different
	int bytes = 0;
	int state = 0;
	
	while (1)
	{
		int c, digit;
		
		// Get next character from string.  Treat terminating 0 as
		// a character and let the finite state machine process it.
		
		if (bytes < len)
		{
			c = (int)p[bytes];
		}
		else
		{
			c = 0;
		}
		
		digit = isdigit(c);
		
		if (state == 0)			// start here
		{
			if (c == '+' || c == '-')	state = 1;
			else if (digit)				state = 2;
			else if (c == '.')			state = 3;
			else 						return 0;
		}
		else if (state == 1)	// we had a sign, cannot have another
		{		
			if (c == '.')				state = 4;
			else if (digit)				state = 2;
			else						return 0;
		}
		else if (state == 2)	// had a digit, working on integer part
		{
			if (c == 'e' || c == 'E')	state = 5;
			else if (digit)				state = 2;
			else if (c == '.')			state = 4; 
			else						break;
		}
		else if (state == 3)	// had a leading ., need fractional part
		{
			if (digit)					state = 4;
			else						return 0;
		}
		else if (state == 4)	// working on fractional part
		{
			if (c == 'e' || c == 'E')	state = 5;
			else if (digit)				state = 4;
			else						break;
		}
		else if (state == 5)	// had an 'e', need sign or a digit
		{
			if (c == '+' || c == '-')	state = 6;
			else if (digit)				state = 7;
			else						return 0;
		}
		else if (state == 6)	// had a sign, need a digit
		{
			if (digit)					state = 7;
			else						return 0;
		}
		else if (state == 7)	// working on the exponent
		{
			if (digit)					state = 7;
			else						break;
		}
		
		// Here the character has been accepted.

		bytes++;
	}
	
	return bytes;
}


