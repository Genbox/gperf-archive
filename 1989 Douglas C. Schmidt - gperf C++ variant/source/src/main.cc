/* Driver program for the Perfect hash function generator
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

#include "stderr.h"
#include "options.h"
#include "perfect.h"

int
main (int argc, char *argv[])
{
  /* Sets the Options. */
  option (argc, argv);          

  /* Initializes the key word list. */
  Perfect generate_table;       

  /* Generates and prints the Perfect hash table.
     Don't use exit here, it skips the destructors. */
  return generate_table ();     
}
