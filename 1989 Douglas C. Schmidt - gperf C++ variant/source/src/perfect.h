/* This may look like C code, but it is really -*- C++ -*- */

/* Provides high-level routines to manipulate the keywork list 
   structures the code generation output. 

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
#include "stderr.h"
#include "keylist.h"
#include "boolarray.h"

class Perfect : Std_Err
{
private:
  Key_List    list;              /* List of key words provided by the user. */
  Bool_Array  duplicate;         /* Speeds up check for redundant hash values. */
  int         max_hash_value;    /* Maximum possible hash value. */
  int         fewest_hits;       /* Records fewest # of collisions for asso value. */
  int         best_char_choice;  /* Best (but not optimal) char index found so far. */
  int         best_asso_value;   /* Best (but not optimal) asso value found so far. */
  
  static int  hash (List_Node *key_node);
  void        change (List_Node *prior, List_Node *curr);
  bool        affects_prev (char c, List_Node *curr);
  static int  merge_sets (char *set_1, char *set_2, char *set_3);
  static void sort_set (char *union_set, int len);
  
public:
             Perfect (void);
            ~Perfect (void);
  int        operator () (void);
};



