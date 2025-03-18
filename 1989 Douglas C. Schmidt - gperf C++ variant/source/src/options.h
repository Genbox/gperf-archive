/* This may look like C code, but it is really -*- C++ -*- */

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

/* This module provides a uniform interface to the various Options available
   to a user of the Perfect.hash function generator.  In addition to the
   run-time Options, found in the Option_Type below, there is also the
   hash table Size and the Keys to be used in the hashing.
   The overall design of this module was an experiment in using C++
   classes as a mechanism to enhance centralization of option and
   and error handling, which tend to get out of hand in a C program. */

#pragma once
#include <stddef.h>
#include "stderr.h"

/* Enumerate the potential debugging Options. */

enum Option_Type
{
  DEBUG        = 01,            /* Enable debugging (prints diagnostics to Std_Err). */
  ORDER        = 02,            /* Apply ordering heuristic to speed-up search time. */
  ANSI         = 04,            /* Generate ANSI prototypes. */
  ALLCHARS     = 010,           /* Use all characters in hash function. */
  GNU          = 020,           /* Assume GNU extensions (primarily function inline). */
  TYPE         = 040,           /* Handle user-defined type structured keyword input. */
  RANDOM       = 0100,          /* Randomly initialize the associated values table. */
  DEFAULTCHARS = 0200,          /* Make default char positions be 1,$ (end of keyword). */
  SWITCH       = 0400,          /* Generate switch output to save space. */
  POINTER      = 01000,         /* Have in_word_set function return pointer, not boolean. */
  NOLENGTH     = 02000,         /* Don't include keyword length in hash computations. */
  LENTABLE     = 04000,         /* Generate a length table for string comparison. */
  DUP          = 010000,        /* Handle duplicate hash values for keywords. */
  FAST         = 020000,        /* Generate the hash function ``fast.'' */
  NOTYPE       = 040000,  			/* Don't include user-defined type definition
																 * in output -- it's already defined elsewhere. */
  COMP         = 0100000,       /* Generate strncmp rather than strcmp. */
	GLOBAL       = 0200000,       /* Make the keyword table a global variable. */
};

/* Define some useful constants. */

static const int MAX_KEY_POS = 128 - 1;    /* Max size of each word's key set. */
static const int WORD_START = 1;           /* Signals the start of a word. */
static const int WORD_END = 0;             /* Signals the end of a word. */
static const int EOS = MAX_KEY_POS;        /* Signals end of the key list. */

/* Class manager for gperf program Options. */

class Options  : Std_Err
{
public:
          Options (void);
         ~Options (void);
  bool    operator[] (Option_Type option);
  void    operator() (int argc, char *argv[]);
	void    operator= (enum Option_Type);
	void    operator!= (enum Option_Type);
  static void    reset (void);
  static void    set_asso_max (int r);
  static void    print_options (void);
  static int     get (void);
  static int     get_asso_max (void);
  static int     get_iterations (void);
  static int     total_positions (void);
  static int     get_jump (void);
  static int     initial_value (void);
  static char   *get_function_name (void);
  static char   *get_key_name (void);
  static char   *get_hash_name (void);

private:
  static const int DEFAULT_JUMP_VALUE;    /* Size to jump on a collision. */
  static char  *DEFAULT_NAME;             /* Default name for generated lookup function. */
  static char  *DEFAULT_KEY;              /* Default name for the key component. */
	static char  *DEFAULT_HASH_NAME;        /* Default name for generated hash function. */
  static int    option_word;                    /* Holds the user-specified Options. */
  static int    total_key_positions;            /* Total number of distinct key_positions. */
  static int    size;                           /* Range of the hash table. */
  static int    key_pos;                        /* Tracks current key position for Iterator. */
  static int    jump;                           /* Jump length when trying alternative values. */
  static int    initial_asso_value;             /* Initial value for asso_values table. */
  static int    argument_count;                 /* Records count of command-line arguments. */
  static int    iterations;                     /* Amount to iterate when a collision occurs. */
  static char **argument_vector;                /* Stores a pointer to command-line vector. */
  static char  *function_name;                  /* Names used for generated lookup function. */
  static char  *key_name;                       /* Name used for keyword key. */
  static char  *hash_name;     								  /* Name used for generated hash function. */
  static char   key_positions[MAX_KEY_POS];     /* Contains user-specified key choices. */
  static int    key_sort (char *base, int len); /* Sorts key positions in REVERSE order. */
  static void   usage (void);                   /* Prints proper program usage. */
};

/* Global option coordinator for the entire program. */
extern Options option;       

#ifdef __OPTIMIZE__

inline bool 
Options::operator[] (Option_Type option) /* True if option enable, else false. */
{ 
  return option_word & option;
}

inline void
Options::operator = (enum Option_Type opt) /* Enables option OPT. */
{
	option_word |= opt;
}

inline void
Options::operator != (enum Option_Type opt) /* Disables option OPT. */
{
	option_word &= ~opt;
}

inline void 
Options::reset (void) /* Initializes the key Iterator. */
{ 
  key_pos = 0;
}

inline int 
Options::get (void) /* Returns current key_position and advanced index. */
{ 
  return key_positions[key_pos++];
}

inline void 
Options::set_asso_max (int r) /* Sets the size of the table size. */
{ 
  size = r;
}

inline int 
Options::get_asso_max (void) /* Returns the size of the table size. */
{ 
  return size;
}

inline int 
Options::total_positions (void) /* Returns total distinct key positions. */
{ 
  return total_key_positions;
}

inline int 
Options::get_jump (void) /* Returns the jump value. */
{ 
  return jump;
}

inline char *
Options::get_function_name (void) /* Returns the jump value. */
{ 
  return function_name;
}

inline char *
Options::get_key_name (void) /* Returns the keyword key name. */
{
  return key_name;
}

inline char *
Options::get_hash_name (void) /* Returns the hash function name. */
{
	return hash_name;
}

inline int 
Options::initial_value (void) /* Returns the initial associated character value. */
{ 
  return initial_asso_value;
}

inline int 
Options::get_iterations (void) /* Returns the iterations value. */
{ 
  return iterations;
}

#endif
