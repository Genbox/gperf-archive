/* Hash table for checking keyword links.  Implemented using double hashing.
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
#include <std.h>
#include "hashtable.h"
#include "options.h"

#define POW(X) ((!X)?1:(X-=1,X|=X>>1,X|=X>>2,X|=X>>4,X|=X>>8,X|=X>>16,(++X)))
#define NIL(TYPE) (TYPE *)0

static unsigned
Hash_Table::hash_pjw (char *str)
{
  char    *temp;
  unsigned g, h = 0;
   
  for (temp = str; *temp; temp++) 
    {
      h = (h << 4) + (*temp * 13);
      if (g = h & 0xf0000000) 
        {
          h ^= (g >> 24);
          h ^= g;
        }
    }

  return h;
}

/* The size of the hash table is always the smallest power of 2 >= the size
   indicated by the user.  this allows several optimizations, including
   the use of double hashing and elimination of the mod instruction.
   note that the size had better be larger than the number of items
   in the hash table, else there's trouble!!! */

Hash_Table::Hash_Table (int s)
{
  size  = POW (s);
  table = new List_Node *[size];
  bzero (table, size * sizeof *table);
}

/* Frees the dynamically allocated table. */

Hash_Table::~Hash_Table (void) 
{ 
  if (option[DEBUG])
    {
      int i;

      fprintf (stderr, "\ndumping the hash table\n");
    
      for (i = size - 1; i >= 0; i--)
        if (table[i])
          fprintf (stderr, "location[%d] = key set %s, key %s\n",
                   i, table[i]->key_set, table[i]->key);

      fprintf (stderr, "end dumping hash table\n\n");
    }
}

/* If the ITEM is already in the hash table return the item found
   in the table.  Otherwise inserts the ITEM, and returns FALSE.
   Uses double hashing. */

List_Node *
Hash_Table::operator () (List_Node *item, int ignore_length) 
{
  unsigned hash_val  = hash_pjw (item->key_set);
  int      probe     = hash_val & size - 1;
  int      increment = (hash_val ^ item->length | 1) & size - 1;
  
  while (table[probe]
         && (strcmp (table[probe]->key_set, item->key_set)
             || (!ignore_length && table[probe]->length != item->length)))
    probe = probe + increment & size - 1;
  
  return table[probe] ? : (table[probe] = item, NIL (List_Node));
}


