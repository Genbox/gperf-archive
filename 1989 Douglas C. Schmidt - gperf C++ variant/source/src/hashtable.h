/* This may look like C code, but it is really -*- C++ -*- */

/* Hash table used to check for duplicate keyword entries.

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

#pragma once
#include <stddef.h>
#include "keylist.h"

class Hash_Table 
{
private:
  List_Node     **table; /* Vector of pointers to linked lists of List_Node's. */
  int             size;  /* Size of the vector. */
  static unsigned hash_pjw (char *str);

public:
             Hash_Table (int s);
            ~Hash_Table (void);
  List_Node *operator () (List_Node *item, int ignore_length);
};
