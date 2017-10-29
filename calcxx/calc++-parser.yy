%skeleton "lalr1.cc" /* -*- C++ -*- */
%require "3.0.4" /* Because the C++ skeleton changed several times, it is safer to require the version you designed the grammar for. */
%defines
%define parser_class_name {calcxx_parser}

%define api.token.constructor /* type-safe and natural def of "symbol" */
%define api.value.type variant
%define parse.assert  /* make sure properly use variant-based */


%code requires
{
 #include <string>
 class calcxx_driver;
}


// The driver is passed by reference to the parser and to the scanner. This
// provides a simple but effective pure interface, not relying on global
// variables.

// The parsing context.
%param { calcxx_driver& driver }



// Then we request location tracking, and initialize the first location’s file
// name. Afterward new locations are computed relatively to the previous
// locations: the file name will be propagated.
%locations
%initial-action
{
  // Initialize the initial location.
  @$.begin.filename = @$.end.filename = &driver.file;
};




%define parse.trace
%define parse.error verbose



// output in the *.cc file
%code
{
  # include "calc++-driver.hh"
}

// To avoid name clashes in the generated files (see Calc++ Scanner), prefix
// tokens with TOK_ (see api.token.prefix).
%define api.token.prefix {TOK_}
%token
  END  0  "end of file"
  ASSIGN  ":="
  MINUS   "-"
  PLUS    "+"
  STAR    "*"
  SLASH   "/"
  LPAREN  "("
  RPAREN  ")"
;


%token <std::string> IDENTIFIER "identifier"
%token <int> NUMBER "number"
%type  <int> exp


%printer { yyoutput << $$; } <*>;




%%
%start unit;
unit: assignments exp  { driver.result = $2; };

assignments:
  %empty                 {}
| assignments assignment {};

assignment:
  "identifier" ":=" exp { driver.variables[$1] = $3; };

%left "+" "-";
%left "*" "/";
exp:
  exp "+" exp   { $$ = $1 + $3; }
| exp "-" exp   { $$ = $1 - $3; }
| exp "*" exp   { $$ = $1 * $3; }
| exp "/" exp   { $$ = $1 / $3; }
| "(" exp ")"   { std::swap ($$, $2); }
| "identifier"  { $$ = driver.variables[$1]; }
| "number"      { std::swap ($$, $1); };
%%



void
yy::calcxx_parser::error (const location_type& l,
                          const std::string& m)
{
  driver.error (l, m);
}

