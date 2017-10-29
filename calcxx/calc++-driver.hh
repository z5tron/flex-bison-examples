/** Bison 3.0.4 10.1.6.2 
 *  To support a pure interface with the parser (and the scanner) the
 *  technique of the “parsing context” is convenient: a structure containing
 *  all the data to exchange. Since, in addition to simply launch the parsing,
 *  there are several auxiliary tasks to execute (open the file for parsing,
 *  instantiate the parser etc.), we recommend transforming the simple parsing
 *  context structure into a fully blown parsing driver class. */

#ifndef CALCXX_DRIVER_HH
# define CALCXX_DRIVER_HH
# include <string>
# include <map>
# include "calc++-parser.hh"

// Tell Flex the lexer's prototype ...
// Flex expects the signature of yylex to be defined in the macro YY_DECL, and the C++ parser expects it to be declared.
# define YY_DECL \
  yy::calcxx_parser::symbol_type yylex (calcxx_driver& driver)
// ... and declare it for the parser's sake.
YY_DECL;

/** The Driver class brings together all components. It creates an instance of
 * the Parser and Scanner classes and connects them. Then the input stream is
 * fed into the scanner object and the parser gets it's token
 * sequence. Furthermore the driver object is available in the grammar rules as
 * a parameter. Therefore the driver class contains a reference to the
 * structure into which the parsed data is saved. */

// Conducting the whole scanning and parsing of Calc++.    
class calcxx_driver
{
public:
  calcxx_driver ();
  virtual ~calcxx_driver ();

  std::map<std::string, int> variables;

  int result;

  // Handling the scanner.
  void scan_begin ();
  void scan_end ();
  bool trace_scanning;

    // Run the parser on file F.
  // Return 0 on success.
  int parse (const std::string& f);
  // The name of the file being parsed.
  // Used later to pass the file name to the location tracker.
  std::string file;
  // Whether parser traces should be generated.
  bool trace_parsing;

     // Error handling.
    // To demonstrate pure handling of parse errors, instead of simply dumping
    // them on the standard error output, we will pass them to the compiler
    // driver using the following two member functions. Finally, we close the
    // class declaration and CPP guard.
  void error (const yy::location& l, const std::string& m);
  void error (const std::string& m);
};
#endif // ! CALCXX_DRIVER_HH
