/* This may look like C code, but it is really -*- C++ -*- */

/* Data and function member declarations for the keyword list class.

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

/* The key word list is a useful abstraction that keeps track of
   various pieces of information that enable that fast generation
   of the Perfect.hash function.  A Key_List is a singly-linked
   list of List_Nodes. */

#pragma once
#include "listnode.h"
#include "stderr.h"

struct Key_List : Std_Err
{
  List_Node *head;                  /* Points to the head of the linked list. */
  char      *array_type;            /* Pointer to the type for word list. */
  char      *return_type;           /* Pointer to return type for lookup function. */
  char      *struct_tag;            /* Shorthand for user-defined struct tag type. */
  char      *include_src;           /* C source code to be included verbatim. */
  int        list_len;              /* Length of head's Key_List, not counting duplicates. */
  int        total_keys;            /* Total number of keys, counting duplicates. */
  int        max_key_len;           /* Maximum length of the longest keyword. */
  int        min_key_len;           /* Minimum length of the shortest keyword. */
  bool       occurrence_sort;       /* True if sorting by occurrence. */
  bool       hash_sort;             /* True if sorting by hash value. */
  bool       additional_code;       /* True if any additional C code is included. */
  static char *default_array_type;  /* Default type for generated code. */
  static char *default_return_type; /* in_word_set return type, by default. */
  static const int MAX_INT     = ((~(unsigned)0)>>1);
  static const int NEG_MAX_INT = ((~(unsigned)0)^((~(unsigned)0)>>1));
  
              Key_List   (void);
             ~Key_List  (void);
  int         length (void);
  int         max_key_length (void);
  static int  get_occurrence (List_Node *ptr);
  int         print_min_max (void);
  static int  strcspn (char *s, char *reject);
  void        read_keys (void);
  void        reorder (void);
  static void set_determined (List_Node *ptr);
  void        sort (void);
  void        print_switch (void);
  void        print_keyword_table (void);
  void        print_keylength_table (void);
  void        set_output_types (void);
  void        dump (void);
  void        print_hash_function (int max_hash_value);
  void        print_lookup_function (void);
  void        output (void);
  char       *get_array_type (void);
  char       *save_include_src (void);
  char       *get_special_input (char delimiter);
  List_Node  *merge (List_Node *list1, List_Node *list2);
  List_Node  *merge_sort (List_Node *head);
  static bool already_determined (List_Node *ptr);
};
