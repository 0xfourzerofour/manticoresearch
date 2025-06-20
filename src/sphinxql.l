%{

#if _WIN32
#define YY_NO_UNISTD_H 1
#endif

#include "bissphinxql.h"

#ifdef __GNUC__
	#pragma GCC diagnostic push
	#pragma GCC diagnostic ignored "-Wsign-compare"
	#pragma GCC diagnostic ignored "-Wpragmas"
	#pragma GCC diagnostic ignored "-Wunneeded-internal-declaration"
#endif

#if _WIN32
#pragma warning(push,1)
#endif

// warning, lexer generator dependent!
// this macro relies on that in flex yytext points to the actual location in the buffer
#define YYSTOREBOUNDS \
	{ \
		lvalp->m_iStart = yytext - pParser->m_pBuf; \
		lvalp->m_iEnd = lvalp->m_iStart + yyleng; \
		pParser->m_pLastTokenStart = yytext; \
	}

#define BLOCK_START \
	{ \
		pParser->m_pLastTokenStart = yytext; \
	    lvalp->m_iStart = yytext + yyleng - pParser->m_pBuf; \
	}

#define BLOCK_END \
	{ \
		lvalp->m_iEnd = yytext + yyleng - pParser->m_pBuf; \
	}

%}

DIGIT				[0-9]
ALPHA				[a-zA-Z_@]
ALNUM				[a-zA-Z_0-9]
ID					{ALPHA}{ALNUM}*
ID_SYS				{ALNUM}({ALNUM}|\.)*
SPACE				[ \t\n\r]
SIGN                [+-]?
INT                 {DIGIT}+
EXP     			[eE]{SIGN}{INT}

FLOAT_CONSTANT      {INT}\.{INT}?{EXP}?|{INT}?\.{INT}{EXP}|{INT}{EXP}

%option noyywrap
%option nounput
%option reentrant
%option case-insensitive
%option batch
%option align

%x ccomment
%x BACKTICK

%%

"/*"         		{ BLOCK_START; BEGIN(ccomment); }
<ccomment>"*/"		{ BLOCK_END; BEGIN(INITIAL); lvalp->m_iEnd-=2; pParser->AddComment(lvalp); }
<ccomment>[^*\n]+
<ccomment>"*"[^/]
<ccomment>"\n"


\.{SPACE}*`	           	{ BLOCK_START; BEGIN (BACKTICK); }
<BACKTICK>[^\n\\`]+		/* eat everything except \n, \, ` */
<BACKTICK>\\[^\n]		/* eat one symbol after \ (aka escaping) except \n  */
<BACKTICK>`				{
							BLOCK_END;
							BEGIN(INITIAL);
							return TOK_BACKTICKED_SUBKEY;
						}

<BACKTICK>\n			|	/* terminate on \n or EOF inside unclosed backtick */
<BACKTICK><<EOF>>		{
							BEGIN(INITIAL);
							return -1;
						}


"AGENT"				{ YYSTOREBOUNDS; return TOK_AGENT; }
"ALL"				{ YYSTOREBOUNDS; return TOK_ALL; }
"AND"				{ YYSTOREBOUNDS; return TOK_AND; }
"ANY"				{ YYSTOREBOUNDS; return TOK_ANY; }
"AS"				{ YYSTOREBOUNDS; return TOK_AS; }
"ASC"				{ YYSTOREBOUNDS; return TOK_ASC; }
"AVG"				{ YYSTOREBOUNDS; return TOK_AVG; }
"BEGIN"				{ YYSTOREBOUNDS; return TOK_BEGIN; }
"BETWEEN"			{ YYSTOREBOUNDS; return TOK_BETWEEN; }
"BIGINT"			{ YYSTOREBOUNDS; return TOK_BIGINT; }
"BY"				{ YYSTOREBOUNDS; return TOK_BY; }
"CALL"				{ YYSTOREBOUNDS; return TOK_CALL; }
"CHARACTER"			{ YYSTOREBOUNDS; return TOK_CHARACTER; }
"CHUNK"				{ YYSTOREBOUNDS; return TOK_CHUNK; }
"CLUSTER"			{ YYSTOREBOUNDS; return TOK_CLUSTER; }
"COLLATE"			{ YYSTOREBOUNDS; return TOK_COLLATE; }
"COLLATION"			{ YYSTOREBOUNDS; return TOK_COLLATION; }
"COLUMN"			{ YYSTOREBOUNDS; return TOK_COLUMN; }
"COLUMNARSCAN"		{ YYSTOREBOUNDS; return TOK_HINT_COLUMNAR; }
"COMMIT"			{ YYSTOREBOUNDS; return TOK_COMMIT; }
"COUNT"				{ YYSTOREBOUNDS; return TOK_COUNT; }
"CREATE"			{ YYSTOREBOUNDS; return TOK_CREATE; }
"DATABASES"			{ YYSTOREBOUNDS; return TOK_DATABASES; }
"DATE_ADD"			{ YYSTOREBOUNDS; return TOK_DATE_ADD; }
"DATE_SUB"			{ YYSTOREBOUNDS; return TOK_DATE_SUB; }
"DAY"				{ YYSTOREBOUNDS; return TOK_DAY; }
"DEALLOCATE"		{ YYSTOREBOUNDS; return TOK_DEALLOCATE; }
"DELETE"			{ YYSTOREBOUNDS; return TOK_DELETE; }
"DESC"				{ YYSTOREBOUNDS; return TOK_DESC; }
"DESCRIBE"			{ YYSTOREBOUNDS; return TOK_DESCRIBE; }
"DISTINCT"			{ YYSTOREBOUNDS; return TOK_DISTINCT; }
"DIV"				{ YYSTOREBOUNDS; return TOK_DIV; }
"DOCIDINDEX"		{ YYSTOREBOUNDS; return TOK_HINT_DOCID; }
"DOUBLE"			{ YYSTOREBOUNDS; return TOK_DOUBLE; }
"EXECUTE"			{ YYSTOREBOUNDS; return TOK_EXECUTE; }
"EXPLAIN"			{ YYSTOREBOUNDS; return TOK_EXPLAIN; }
"FACET"				{ YYSTOREBOUNDS; return TOK_FACET; }
"FALSE"				{ YYSTOREBOUNDS; return TOK_FALSE; }
"FLOAT"				{ YYSTOREBOUNDS; return TOK_FLOAT; }
"FOR"				{ YYSTOREBOUNDS; return TOK_FOR; }
"FORCE"				{ YYSTOREBOUNDS; return TOK_FORCE; }
"FROM"				{ YYSTOREBOUNDS; return TOK_FROM; }
"GLOBAL"			{ YYSTOREBOUNDS; return TOK_GLOBAL; }
"GROUP"				{ YYSTOREBOUNDS; return TOK_GROUP; }
"GROUPBY"			{ YYSTOREBOUNDS; return TOK_GROUPBY; }
"GROUP_CONCAT"		{ YYSTOREBOUNDS; return TOK_GROUP_CONCAT; }
"HAVING"			{ YYSTOREBOUNDS; return TOK_HAVING; }
"HOSTNAMES"			{ YYSTOREBOUNDS; return TOK_HOSTNAMES; }
"HOUR"				{ YYSTOREBOUNDS; return TOK_HOUR; }
"IGNORE"			{ YYSTOREBOUNDS; return TOK_IGNORE; }
"IN"				{ YYSTOREBOUNDS; return TOK_IN; }
"INDEX"				{ YYSTOREBOUNDS; return TOK_INDEX; }
"INDEXES"			{ YYSTOREBOUNDS; return TOK_INDEXES; }
"INDEXOF"			{ YYSTOREBOUNDS; return TOK_INDEXOF; }
"INNER"				{ YYSTOREBOUNDS; return TOK_INNER; }
"INSERT"			{ YYSTOREBOUNDS; return TOK_INSERT; }
"INTEGER"			{ YYSTOREBOUNDS; return TOK_INTEGER; }
"INT"				{ YYSTOREBOUNDS; return TOK_INT; }
"INTERVAL"			{ YYSTOREBOUNDS; return TOK_INTERVAL; }
"INTO"				{ YYSTOREBOUNDS; return TOK_INTO; }
"IS"				{ YYSTOREBOUNDS; return TOK_IS; }
"JOIN"				{ YYSTOREBOUNDS; return TOK_JOIN; }
"KILL"	    		{ YYSTOREBOUNDS; return TOK_KILL; }
"KNN"	    		{ YYSTOREBOUNDS; return TOK_KNN; }
"LEFT"	    		{ YYSTOREBOUNDS; return TOK_LEFT; }
"LIKE"				{ YYSTOREBOUNDS; return TOK_LIKE; }
"LOGS"				{ YYSTOREBOUNDS; return TOK_LOGS; }
"LOCKS"				{ YYSTOREBOUNDS; return TOK_LOCKS; }
"FREEZE"			{ YYSTOREBOUNDS; return TOK_FREEZE; }
"LIMIT"				{ YYSTOREBOUNDS; return TOK_LIMIT; }
"MATCH"				{ YYSTOREBOUNDS; return TOK_MATCH; }
"MAX"				{ YYSTOREBOUNDS; return TOK_MAX; }
"META"				{ YYSTOREBOUNDS; return TOK_META; }
"MIN"				{ YYSTOREBOUNDS; return TOK_MIN; }
"MINUTE"			{ YYSTOREBOUNDS; return TOK_MINUTE; }
"MOD"				{ YYSTOREBOUNDS; return TOK_MOD; }
"MONTH"				{ YYSTOREBOUNDS; return TOK_MONTH; }
"MULTI"				{ YYSTOREBOUNDS; return TOK_MULTI; }
"MULTI64"			{ YYSTOREBOUNDS; return TOK_MULTI64; }
"NAMES"				{ YYSTOREBOUNDS; return TOK_NAMES; }
"NO_COLUMNARSCAN"	{ YYSTOREBOUNDS; return TOK_HINT_NO_COLUMNAR; }
"NO_DOCIDINDEX"		{ YYSTOREBOUNDS; return TOK_HINT_NO_DOCID; }
"NO_SECONDARYINDEX"	{ YYSTOREBOUNDS; return TOK_HINT_NO_SECONDARY; }
"NOT"				{ YYSTOREBOUNDS; return TOK_NOT; }
"NULL"				{ YYSTOREBOUNDS; return TOK_NULL; }
"ON"				{ YYSTOREBOUNDS; return TOK_ON; }
"OFFSET"			{ YYSTOREBOUNDS; return TOK_OFFSET; }
"OPTION"			{ YYSTOREBOUNDS; return TOK_OPTION; }
"OPTIMIZE"			{ YYSTOREBOUNDS; return TOK_OPTIMIZE; }
"OR"				{ YYSTOREBOUNDS; return TOK_OR; }
"ORDER"				{ YYSTOREBOUNDS; return TOK_ORDER; }
"PLAN"				{ YYSTOREBOUNDS; return TOK_PLAN; }
"PLUGINS"			{ YYSTOREBOUNDS; return TOK_PLUGINS; }
"PREPARE"			{ YYSTOREBOUNDS; return TOK_PREPARE; }
"PROFILE"			{ YYSTOREBOUNDS; return TOK_PROFILE; }
"QUARTER"	    	{ YYSTOREBOUNDS; return TOK_QUARTER; }
"QUERY"	    		{ YYSTOREBOUNDS; return TOK_QUERY; }
"RAND"				{ YYSTOREBOUNDS; return TOK_RAND; }
"REGEX"				{ YYSTOREBOUNDS; return TOK_REGEX; }
"RELOAD"			{ YYSTOREBOUNDS; return TOK_RELOAD; }
"REPLACE"			{ YYSTOREBOUNDS; return TOK_REPLACE; }
"REMAP"				{ YYSTOREBOUNDS; return TOK_REMAP; }
"ROLLBACK"			{ YYSTOREBOUNDS; return TOK_ROLLBACK; }
"SCROLL"			{ YYSTOREBOUNDS; return TOK_SCROLL; }
"SECOND"			{ YYSTOREBOUNDS; return TOK_SECOND; }
"SECONDARYINDEX"	{ YYSTOREBOUNDS; return TOK_HINT_SECONDARY; }
"SELECT"			{ YYSTOREBOUNDS; return TOK_SELECT; }
"SET"				{ YYSTOREBOUNDS; return TOK_SET; }
"SETTINGS"			{ YYSTOREBOUNDS; return TOK_SETTINGS; }
"SESSION"			{ YYSTOREBOUNDS; return TOK_SESSION; }
"SHOW"				{ YYSTOREBOUNDS; return TOK_SHOW; }
"SONAME"			{ YYSTOREBOUNDS; return TOK_SONAME; }
"START"				{ YYSTOREBOUNDS; return TOK_START; }
"STATUS"			{ YYSTOREBOUNDS; return TOK_STATUS; }
"STRING"			{ YYSTOREBOUNDS; return TOK_STRING; }
"SUM"				{ YYSTOREBOUNDS; return TOK_SUM; }
"SYSFILTERS"		{ YYSTOREBOUNDS; return TOK_SYSFILTERS; }
"TABLE"				{ YYSTOREBOUNDS; return TOK_TABLE; }
"TABLES"			{ YYSTOREBOUNDS; return TOK_TABLES; }
"THREADS"			{ YYSTOREBOUNDS; return TOK_THREADS; }
"TO"				{ YYSTOREBOUNDS; return TOK_TO; }
"TRANSACTION"		{ YYSTOREBOUNDS; return TOK_TRANSACTION; }
"TRUE"				{ YYSTOREBOUNDS; return TOK_TRUE; }
"UNFREEZE"    		{ YYSTOREBOUNDS; return TOK_UNFREEZE; }
"UPDATE"			{ YYSTOREBOUNDS; return TOK_UPDATE; }
"USING"				{ YYSTOREBOUNDS; return TOK_USING; }
"VALUES"			{ YYSTOREBOUNDS; return TOK_VALUES; }
"VARIABLES"			{ YYSTOREBOUNDS; return TOK_VARIABLES; }
"WARNINGS"			{ YYSTOREBOUNDS; return TOK_WARNINGS; }
"WEEK"				{ YYSTOREBOUNDS; return TOK_WEEK; }
"WEIGHT"			{ YYSTOREBOUNDS; return TOK_WEIGHT; }
"WHERE"				{ YYSTOREBOUNDS; return TOK_WHERE; }
"WITHIN"			{ YYSTOREBOUNDS; return TOK_WITHIN; }
"YEAR"				{ YYSTOREBOUNDS; return TOK_YEAR; }

"MANTICORE."        |
"`MANTICORE`."      { YYSTOREBOUNDS; return TOK_MANTICORE_DOT; }
 "SYSTEM"            { YYSTOREBOUNDS; return TOK_SYSTEM; } /* leading space excludes token from list of reserved words */

"!="				{ YYSTOREBOUNDS; return TOK_NE; }
"<>"				{ YYSTOREBOUNDS; return TOK_NE; }
"<="				{ YYSTOREBOUNDS; return TOK_LTE; }
">="				{ YYSTOREBOUNDS; return TOK_GTE; }
":="				{ YYSTOREBOUNDS; return '='; }

"/*+"				{ YYSTOREBOUNDS; return TOK_HINT_OPEN; }
"*/"				{ YYSTOREBOUNDS; return TOK_HINT_CLOSE; }

'([^'\\]|\\.|\\\\)*'			{ YYSTOREBOUNDS; pParser->m_pLastTokenStart = yytext; lvalp->SetValueInt ( ( (SphAttr_t)lvalp->m_iStart<<32 ) | ( lvalp->m_iEnd-lvalp->m_iStart ) ); return TOK_QUOTED_STRING; }

{FLOAT_CONSTANT}	{ YYSTOREBOUNDS; lvalp->m_fValue = (float)strtod ( yytext, NULL ); return TOK_CONST_FLOAT; }
\.{INT}{ID}			{ YYSTOREBOUNDS; return TOK_SUBKEY; }
\.{INT}			    { YYSTOREBOUNDS; return TOK_DOT_NUMBER; }
{INT}               { YYSTOREBOUNDS; lvalp->SetValueInt ( strtoull ( yytext, NULL, 10 ), false ); return TOK_CONST_INT; }

"@id"				{ YYSTOREBOUNDS; return TOK_ATIDENT; }
"@weight"			{ YYSTOREBOUNDS; return TOK_ATIDENT; }
"@count"			{ YYSTOREBOUNDS; return TOK_ATIDENT; }
@@{ID_SYS}			{ YYSTOREBOUNDS; return TOK_SYSVAR; }
@@`{ID_SYS}`		{ YYSTOREBOUNDS; return TOK_SYSVAR; }
{ID}				{ YYSTOREBOUNDS; return TOK_IDENT; }
{ALNUM}+    		{ YYSTOREBOUNDS; return TOK_BAD_NUMERIC; }
`{ID}`				{ YYSTOREBOUNDS; ++lvalp->m_iStart; --lvalp->m_iEnd; return TOK_IDENT; }
`{ID}:{ID}`			{ YYSTOREBOUNDS; ++lvalp->m_iStart; --lvalp->m_iEnd; return TOK_IDENT; }
`{INT}{ID}`		    { YYSTOREBOUNDS; return TOK_BACKIDENT; } // allow `123xyz` column names

{SPACE}+
\.{SPACE}*{ID}		{ YYSTOREBOUNDS; return TOK_SUBKEY; }
.					{ YYSTOREBOUNDS; return yytext[0]; }

%%

// warning, lexer generator dependent!
// flex inserts trailing zero as needed into the buffer when lexing
// but we need that rolled back when doing error reporting from yyerror
void yylex_unhold ( yyscan_t yyscanner )
{
	struct yyguts_t * yyg = (struct yyguts_t*)yyscanner;
	if ( YY_CURRENT_BUFFER )
	{
		*yyg->yy_c_buf_p = yyg->yy_hold_char;
		YY_CURRENT_BUFFER_LVALUE->yy_buf_pos = yyg->yy_c_buf_p;
		YY_CURRENT_BUFFER_LVALUE->yy_n_chars = yyg->yy_n_chars;
	}
}

#if _WIN32
#pragma warning(pop)
#endif

#ifdef __GNUC__
	#pragma GCC diagnostic pop
#endif
