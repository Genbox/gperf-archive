/* Handles parsing the Options provided to the user.
   Copyright (C) 1989 Free Software Foundation, Inc.
   written by Douglas C. Schmidt (schmidt@ics.uci.edu)

This file is part of GNU GPERF.

GNU GPERF is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 1, or (at your option)
any later version.

GNU GPERF is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU GPERF; see the file COPYING.  If not, write to
the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */

#include <stdio.h>
#include <assert.h>
#include <builtin.h>
#include "getopt.h"
#include "options.h"
#include "iterator.h"

/* Global option coordinator for the entire program. */
Options option;       

/* Current program version. */
extern char *version_string;

/* Size to jump on a collision. */
static const int Options::DEFAULT_JUMP_VALUE = 5;   

/* Default name for generated lookup function. */
static char *Options::DEFAULT_NAME = "in_word_set"; 

/* Default name for generated hash function. */
static char *Options::DEFAULT_HASH_NAME = "hash";

/* Default name for the key component. */
static char *Options::DEFAULT_KEY = "name";         

/* Prints program usage to standard error stream. */

static inline void 
Options::usage (void) 
{ 
  report_error ("Usage: %n [-acdDf[num]gGhH<hashname>i<init>jk<keys>K<keyname>lnN<name>oprs<size>StTv].\n"
                "(type %n -h for help)\n");
}

/* Output command-line Options. */
void 
Options::print_options (void)
{ 
  int i;

  printf ("/* Command-line: ");

  for (i = 0; i < argument_count; i++) 
    printf ("%s ", argument_vector[i]);
   
  printf (" */\n\n");
}

/* Sets the default Options. */

Options::Options (void) 
{ 
  key_positions[0]    = WORD_START;
  key_positions[1]    = WORD_END;
  key_positions[2]    = EOS;
  total_key_positions = 2;
  jump                = DEFAULT_JUMP_VALUE;
  option_word         = DEFAULTCHARS;
  function_name       = DEFAULT_NAME;
  key_name            = DEFAULT_KEY;
	hash_name	          = DEFAULT_HASH_NAME;
  initial_asso_value  = size = iterations = 0;
}

/* Sorts the key positions *IN REVERSE ORDER!!*
   This makes further routines more efficient.  Especially when generating code.
   Uses a simple Insertion Sort since the set is probably ordered.
   Returns 1 if there are no duplicates, 0 otherwise. */

static inline int 
Options::key_sort (char *base, int len) 
{
  int i, j;

  for (i = 0, j = len - 1; i < j; i++) 
    {
      int curr, tmp;
      
      for (curr = i + 1,tmp = base[curr]; curr > 0 && tmp >= base[curr - 1]; curr--) 
        if ((base[curr] = base[curr - 1]) == tmp) /* oh no, a duplicate!!! */
          return 0;

      base[curr] = tmp;
    }

  return 1;
}

/* Dumps option status when debug is set. */

Options::~Options (void) 
{ 
  if (option_word & DEBUG)
    {
      fprintf (stderr, "\ndumping Options:\nDEBUG is.......: %s\nORDER is.......: %s"
               "\nANSI is........: %s\nTYPE is........: %s\nGNU is.........: %s"
               "\nRANDOM is......: %s\nDEFAULTCHARS is: %s\nSWITCH is......: %s"
               "\nPOINTER is.....: %s\nNOLENGTH is....: %s\nLENTABLE is....: %s"
               "\nDUP is.........: %s\nFAST is........: %s\nCOMP is.....: %s"
							 "\nNOTYPE is......: %s\nGLOBAL is......: %s\n"
               "\niterations = %d\nlookup function name = %s\nhash function name = %s"
							 "\nkey name = %s\njump value = %d"
               "\nmax associcated value = %d\ninitial associated value = %d\n",
               option_word & DEBUG ? "enabled" : "disabled", 
               option_word & ORDER ? "enabled" : "disabled",
               option_word & ANSI ? "enabled" : "disabled",
               option_word & TYPE ? "enabled" : "disabled",
               option_word & GNU ? "enabled" : "disabled",
               option_word & RANDOM ? "enabled" : "disabled",
               option_word & DEFAULTCHARS ? "enabled" : "disabled",
               option_word & SWITCH ? "enabled" : "disabled",
               option_word & POINTER ? "enabled" : "disabled",
               option_word & NOLENGTH ? "enabled" : "disabled",
               option_word & LENTABLE ? "enabled" : "disabled",
               option_word & DUP ? "enabled" : "disabled",
               option_word & FAST ? "enabled" : "disabled",
               option_word & COMP ? "enabled" : "disabled",
							 option_word & NOTYPE ? "enabled" : "disabled",
							 option_word & GLOBAL ? "enabled" : "disabled",
               iterations, function_name, hash_name, key_name, jump, size - 1, initial_asso_value);

      if (option_word & ALLCHARS) 
        printf ("all characters are used in the hash function\n");
      else 
        {       
          char *ptr;

          fprintf (stderr, "total key positions = %d\nkey positions are: \n", total_key_positions);

          for (ptr = key_positions; *ptr != EOS; ptr++) 
            if (*ptr == WORD_END) 
              fprintf (stderr, "$\n");
            else 
              fprintf (stderr, "%d\n", *ptr);

          fprintf (stderr, "finished dumping Options\n");
        }
    }
}

/* Parses the command line Options and sets appropriate flags in option_word. */

void 
Options::operator () (int argc, char *argv[])
{ 
  Get_Opt getopt (argc, argv, "adcDf:gGhH:i:j:k:K:lnN:oprs:StTv");
                               
  int     option_char;

  set_program_name (argv[0]);
  argument_count  = argc;
  argument_vector = argv;
  
  while ((option_char = getopt ()) != EOF)
    {
      switch (option_char)
        {
        case 'a':               /* Generated coded uses the ANSI prototype format. */
          { 
            option_word |= ANSI;
            break;
          }
        case 'c':               /* Generate strncmp rather than strcmp. */
          {
            option_word |= COMP;
            break;
          }
        case 'd':               /* Enable debugging option. */
          { 
            option_word |= DEBUG;
            report_error ("Starting program %n, version %s, with debuggin on.\n",
                          version_string);
            break;
          }   
        case 'D':               /* Enable duplicate option. */
          { 
            option_word |= DUP;
            break;
          }   
        case 'f':               /* Generate the hash table ``fast.'' */
          {
            option_word |= FAST;
            if ((iterations = atoi (getopt.optarg)) < 0) 
              {
                report_error ("iterations value must not be negative, assuming 0\n");
                iterations = 0;
              }
            break;
          }
        case 'g':               /* Use the ``inline'' keyword for generated sub-routines. */
          { 
            option_word |= GNU;
            break;
          }
        case 'G':               /* Make the keyword table a global variable. */
          { 
						option_word |= GLOBAL;
            break;
          }
        case 'h':               /* Displays a list of helpful Options to the user. */
          { 
            report_error (
               "-a\tGenerate ANSI standard C output code, i.e., function prototypes.\n"
               "-c\tGenerate comparison code using strncmp rather than strcmp.\n"
               "-d\tEnables the debugging option (produces verbose output to Std_Err).\n"
               "-D\tHandle keywords that hash to duplicate values.  This is useful\n"
               "\tfor certain highly redundant keyword sets.  It enables the -S option.\n"
               "-f\tGenerate the perfect hash function ``fast.''  This decreases GPERF's\n"
               "\trunning time at the cost of minimizing generated table-size.\n"
               "\tThe numeric argument represents the number of times to iterate when\n"
               "\tresolving a collision.  `0' means ``iterate by the number of keywords.''\n"
               "-g\tAssume a GNU compiler, e.g., g++ or gcc.  This makes all generated\n"
               "\troutines use the ``inline'' keyword to remove cost of function calls.\n"
							 "-G\tGenerate the static table of keywords as a static global variable,\n"
							 "\trather than hiding it inside of the lookup function (which is the\n"
							 "\tdefault behavior).\n"
               "-h\tPrints this mesage.\n"
							 "-H\tAllow user to specify name of generated hash function. Default\n"
							 "\tis `hash'.\n"
               "-i\tProvide an initial value for the associate values array.  Default is 0.\n"
               "\tSetting this value larger helps inflate the size of the final table.\n"
               "-j\tAffects the ``jump value,'' i.e., how far to advance the associated\n"
               "\tcharacter value upon collisions.  Must be an odd number, default is %d.\n"
               "-k\tAllows selection of the key positions used in the hash function.\n"
               "\tThe allowable choices range between 1-%d, inclusive.  The positions\n"
               "\tare separated by commas, ranges may be used, and key positions may\n"
               "\toccur in any order.  Also, the meta-character '*' causes the generated\n"
               "\thash function to consider ALL key positions, and $ indicates the\n"
               "\t``final character'' of a key, e.g., $,1,2,4,6-10.\n"
               "-K\tAllow use to select name of the keyword component in the keyword structure.\n"
               "-l\tCompare key lengths before trying a string comparison.  This helps\n"
               "\tcut down on the number of string comparisons made during the lookup.\n"
               "-n\tDo not include the length of the keyword when computing the hash function\n"
               "-N\tAllow user to specify name of generated lookup function.  Default\n"
               "\tname is `in_word_set.'\n"
               "-o\tReorders input keys by frequency of occurrence of the key sets.\n"
               "\tThis should decrease the search time dramatically.\n"
               "-p\tChanges the return value of the generated function ``in_word_set''\n"
               "\tfrom its default boolean value (i.e., 0 or 1), to type ``pointer\n"
               "\tto wordlist array''  This is most useful when the -t option, allowing\n"
               "\tuser-defined structs, is used.\n"
               "-r\tUtilizes randomness to initialize the associated values table.\n"
               "-s\tAffects the size of the generated hash table.  The numeric argument\n"
               "\tfor this option indicates ``how many times larger'' the table range\n"
               "\tshould be, in relationship to the number of keys, e.g. a value of 3\n"
               "\tmeans ``make the table about 3 times larger than the number of input\n"
               "\tkeys.''  A larger table should decrease the time required for an\n"
               "\tunsuccessful search, at the expense of extra table space.  Default\n"
               "\tvalue is 1.  This actual table size may vary somewhat.\n"
               "-S\tCauses the generated C code to use a switch statement scheme, rather\n"
               "\tthan an array lookup table.  This potentially saves *much* space, at\n"
               "\tthe expense of longer time for each lookup.  Mostly important for\n"
               "\t*large* input sets, i.e., greater than around 100 items or so.\n"
               "-t\tAllows the user to include a structured type declaration for \n"
               "\tgenerated code. Any text before %%%% is consider part of the type\n"
               "\tdeclaration.  Key words and additional fields may follow this, one\n"
               "\tgroup of fields per line.\n"
							 "-T\tPrevents the transfer of the type declaration to the output file.\n"
							 "\tUse this option if the type is already defined elsewhere.\n"
               "-v\tPrints out the current version number\n%e%a\n",
               DEFAULT_JUMP_VALUE, (MAX_KEY_POS - 1), usage);
          }
				case 'H':   /* Sets the name for the hash function */
					{
						hash_name = getopt.optarg;
						break;
					}
        case 'i':               /* Sets the initial value for the associated values array. */
          { 
            if ((initial_asso_value = atoi (getopt.optarg)) < 0) 
              report_error ("Initial value %d should be non-zero, ignoring and continuing.\n", initial_asso_value);
            break;
          }
        case 'j':               /* Sets the jump value, must be odd for later algorithms. */
          { 
            if ((jump = atoi (getopt.optarg)) <= 0) 
              report_error ("Jump value %d must be a positive number.\n%e%a", jump, usage);
            else if (even (jump)) 
              report_error ("Jump value %d should be odd, adding 1 and continuing...\n", jump++);
            break;
          }
        case 'k':               /* Sets key positions used for hash function. */
          { 
            const int BAD_VALUE = -1;
            int       value;
            Iterator  expand (getopt.optarg, 1, MAX_KEY_POS - 1, WORD_END, BAD_VALUE, EOS);
            
            if (*getopt.optarg == '*') /* Use all the characters for hashing!!!! */
              option_word = (option_word & ~DEFAULTCHARS) | ALLCHARS;
            else 
              {
                char *key_pos;

                for (key_pos = key_positions; (value = expand ()) != EOS; key_pos++) 
                  if (value == BAD_VALUE) 
                    report_error ("Illegal key value or range, use 1,2,3-%d,'$' or '*'.\n%e%a", (MAX_KEY_POS - 1),usage);
                  else 
                    *key_pos = value;;

                *key_pos = EOS;

                if (! (total_key_positions = (key_pos - key_positions))) 
                  report_error ("No keys selected.\n%e%a", usage);
                else if (! key_sort (key_positions, total_key_positions))
                  report_error ("Duplicate keys selected\n%e%a", usage);

                if (total_key_positions != 2 
                    || (key_positions[0] != 1 || key_positions[1] != WORD_END))
                  option_word &= ~DEFAULTCHARS;
              }
            break;
          }
        case 'K':               /* Make this the keyname for the keyword component field. */
          {
            key_name = getopt.optarg;
            break;
          }
        case 'l':               /* Create length table to avoid extra string compares. */
          { 
            option_word |= LENTABLE;
            break;
          }
        case 'n':               /* Don't include the length when computing hash function. */
          { 
            option_word |= NOLENGTH;
            break; 
          }
        case 'N':               /* Make generated lookup function name be optarg */
          { 
            function_name = getopt.optarg;
            break;
          }
        case 'o':               /* Order input by frequency of key set occurrence. */
          { 
            option_word |= ORDER;
            break;
          }   
        case 'p':               /* Generated lookup function now a pointer instead of int. */
          { 
            option_word |= POINTER;
            break;
          }
        case 'r':               /* Utilize randomness to initialize the associated values table. */
          { 
            option_word |= RANDOM;
            break;
          }
        case 's':               /* Range of associated values, determines size of final table. */
          { 
            if ((size = atoi (getopt.optarg)) <= 0) 
              report_error ("Improper range argument %s.\n%e%a", getopt.optarg, usage);
            else if (size > 50) 
              report_error ("%d is excessive, did you really mean this?! (type %n -h for help)\n", size);
            break; 
          }       
        case 'S':               /* Generate switch statement output, rather than lookup table. */
          { 
            option_word |= SWITCH;
            break;
          }
        case 't':               /* Enable the TYPE mode, allowing arbitrary user structures. */
          { 
            option_word |= TYPE;
            break;
          }
				case 'T':   /* Don't print structure definition. */
					{
						option_word |= NOTYPE;
						break;
					}
        case 'v':               /* Print out the version and quit. */
          report_error ("%n: version %s\n%e%a\n", version_string, usage);
        default: 
          report_error ("%e%a", usage);
        }
    }

  if (argv[getopt.optind] && ! freopen (argv[getopt.optind], "r", stdin))
    report_error ("Unable to read key word file %s.\n%e%a", argv[getopt.optind], usage);
  
  if (++getopt.optind < argc) 
    report_error ("Extra trailing arguments to %n.\n%e%a", usage);
}

#ifndef __OPTIMIZE__

/* TRUE if option enable, else FALSE. */
bool 
Options::operator[] (Option_Type option) 
{ 
  return option_word & option;
}

/* Enables option OPT. */
void
Options::operator= (enum Option_Type opt) 
{
	option_word |= opt;
}

/* Disables option OPT. */
void
Option::operator! (enum Option_Type opt) 
{
	option_word &= ~opt;
}

/* Initializes the key Iterator. */
void 
Options::reset (void) 
{ 
  key_pos = 0;
}

/* Returns current key_position and advances index. */
int 
Options::get (void) 
{
  return key_positions[key_pos++];
}

/* Sets the size of the table size. */
void 
Options::set_asso_max (int r) 
{
  size = r;
}

/* Returns the size of the table size. */
int 
Options::get_asso_max (void) 
{
  return size;
}

/* Returns total distinct key positions. */
int 
Options::total_positions (void) 
{
  return total_key_positions;
}

/* Returns the jump value. */
int 
Options::get_jump (void) 
{
  return jump;
}

/* Returns the lookup function name. */
char *
Options::get_function_name (void) 
{
  return function_name;
}

/* Returns the keyword key name. */
char *
Options::get_key_name (void) 
{
  return key_name;
}

/* Returns the hash function name. */
inline char *
Options::get_hash_name (void) 
{
	return hash_name;
}

/* Returns the initial associated character value. */
int 
Options::initial_value (void) 
{
  return initial_asso_value;
}

/* Returns the iterations value. */
int 
Options::get_iterations (void) 
{ 
  return iterations;
}

#endif /* not defined __OPTIMIZE__ */
