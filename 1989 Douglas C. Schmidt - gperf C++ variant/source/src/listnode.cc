/* Creates and initializes a new list node.
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

#include "options.h"
#include "listnode.h"

/* See comments in perfect.cc. */
extern int occurrences[ALPHABET_SIZE]; 

/* Sorts the key set alphabetically to speed up subsequent operations.
   Uses insertion sort since the set is probably quite small. */

static inline void 
List_Node::set_sort (char *base, int len)
{
  int i, j;

  for (i = 0, j = len - 1; i < j; i++)
    {
      char curr, tmp;
      
      for (curr = i + 1, tmp = base[curr]; curr > 0 && tmp < base[curr-1]; curr--)
        base[curr] = base[curr - 1];

      base[curr] = tmp;

    }
}

/* Initializes a List_Node.  This requires obtaining memory for the KEY_SET
   and UNIQ_SET, initializing them using the information stored in the
   KEY_POSITIONS array in Options, and checking for simple errors.
   It's important to note that KEY and REST are both pointers to
   the different offsets into the same block of dynamic memory pointed to
   by parameter K. The data member REST is used to store any additional fields 
   of the input file (it is set to the "" string if Option[TYPE] is not enabled).
   This is useful if the user wishes to incorporate a lookup structure,
   rather than just an array of keys. */

List_Node::List_Node (char *k, int len):
  key (k), next (0), index (0), length (len), link (0), rest (option[TYPE] ? k + len + 1 : "")
{
  int positions = 1 + (option[ALLCHARS] ? len : option.total_positions () + 1);
  key_set       = new char[positions + positions]; /* Save 1 call to new. */
  uniq_set      = key_set + positions;
  char *ptr     = key_set;
  k[len]        = '\0';         /* Null terminate KEY to separate it from REST. */
  char *ptr1, *ptr2;

  if (option[ALLCHARS])         /* Use all the character position in the KEY. */

    for (; *k; k++, ptr++)
      ++occurrences[*ptr = *k];

  else                          /* Only use those character positions specified by the user. */
    {                           
      int i;

      /* Iterate thru the list of key_positions, initializing occurrences table
        and key_set (via char * pointer ptr). */

      for(option.reset (); (i = option.get ()) != EOS; )
        {
          if (i == WORD_END)    /* Special notation for last KEY position, i.e. '$'. */
            *ptr = key[len - 1];
          else if (i <= len)    /* Within range of KEY length, so we'll keep it. */
            *ptr = key[i - 1];
          else                  /* Out of range of KEY length, so we'll just skip it. */
            continue;
          ++occurrences[*ptr++];
        }

      if (ptr == key_set)       /* Didn't get any hits, i.e., no usable positions. */
        report_error ("Can't hash keyword %s with chosen key positions.\n%a", key);
    }

  *ptr = '\0'; /* Terminate this bastard.... */
  set_sort (key_set, ptr - key_set); /* Sort the KEY_SET items alphabetically. */

  /* Eliminate UNIQ_SET duplicates, this saves time later on.... */

  for (ptr1 = key_set, ptr2 = uniq_set; *ptr1; ptr1++)
    if (*ptr1 != ptr1[1])
      *ptr2++ = *ptr1;

  *ptr2 = '\0';                 /* NULL terminate the UNIQ_SET. */
}
