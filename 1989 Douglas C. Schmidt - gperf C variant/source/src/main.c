/* Driver program for the Perfect hash function generator.
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

/* Simple driver program for the Perfect.hash function generator.
   Most of the hard work is done in class Perfect and its class methods. */

#include <stdio.h>
#include "stderr.h"
#include "options.h"
#include "perfect.h"

/* Calls the appropriate intialization routines for each
   ADT.  Note that certain initialization routines require
   initialization *after* certain values are computed.  Therefore,
   they cannot be called here. */
   
static void 
init_all (argc, argv)
     int argc;
     char *argv[];
{
  options_init (argc, argv);    
  key_list_init ();
  perfect_init ();              
}

/* Calls appropriate destruction routines for each ADT.  These
   routines print diagnostics if the debugging option is enabled. */

static void
destroy_all ()
{
  options_destroy ();
  bool_array_destroy ();
  hash_table_destroy ();
  key_list_destroy ();
  perfect_destroy ();
}

/* Driver for perfect hash function generation. */

int
main (argc, argv)
     int argc;
     char *argv[];
{
  int status;
  
  /* Sets the options. */
  init_all (argc, argv);

  /* Generates the perfect hash table.
     Also prints generated code neatly to the output. */
  status = perfect_generate ();
  destroy_all ();
  return status;
}
