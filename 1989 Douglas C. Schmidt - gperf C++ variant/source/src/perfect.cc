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

#include <stdio.h>
#include <std.h>
#include <assert.h>
#include <ctype.h>
#include "options.h"
#include "perfect.h"

int occurrences[ALPHABET_SIZE]; /* Counts occurrences of each key set character. */
int asso_values[ALPHABET_SIZE]; /* Value associated with each character. */

/* Efficiently returns the least power of two greater than or equal to X! */
#define POW(X) ((!X)?1:(X-=1,X|=X>>1,X|=X>>2,X|=X>>4,X|=X>>8,X|=X>>16,(++X)))

/* Reads input keys, possibly applies the reordering heuristic, sets the
   maximum associated value size (rounded up to the nearest power of 2),
   may initialize the associated values array, and determines the maximum
   hash table size.  Note: using the random numbers is often helpful,
   though not as deterministic, of course! */

Perfect::Perfect (void): best_char_choice (0), best_asso_value (0)
{
  int asso_value_max;
  int len;

  list.read_keys ();
  if (option[ORDER])
    list.reorder ();

  asso_value_max = option.get_asso_max ();
  len            = list.length ();
  
  asso_value_max = (asso_value_max ? asso_value_max * len : len);
  option.set_asso_max (POW (asso_value_max));
  
  if (option[RANDOM])
    {
      int i;

      srandom (time (0));
      
      for (i = 0; i < ALPHABET_SIZE; i++)
        asso_values[i] = (random () & asso_value_max - 1);
      
    }
  else
    {
      int asso_value = option.initial_value ();
      
      if (asso_value)           /* Initialize array if user requests non-zero default. */
        {
          int i;

          for (i = ALPHABET_SIZE - 1; i >= 0; i--)
            asso_values[i] = asso_value & option.get_asso_max () - 1;

        }
    }
  max_hash_value = list.max_key_length () + option.get_asso_max () * 
    (option[ALLCHARS] ? list.max_key_length () : option.total_positions ());
  
  if (option[DEBUG])
    fprintf (stderr, "number of keys = %d\nmaximum associated value is %d"
             "\nmaximum size of hash table is %d\n", len, asso_value_max, max_hash_value);
}

/* Merge two disjoint hash key sets to form the ordered union of the sets.
   Precondition: both set_1 and set_2 must be ordered. Returns the length
   of the combined set. */

static inline int 
Perfect::merge_sets (char *set_1, char *set_2, char *set_3)
{
  char *base = set_3;
  
  while (*set_1 && *set_2)
    if (*set_1 == *set_2)
      *set_3++ = *set_1++, set_2++; 
    else
      *set_3++ = *set_1 < *set_2 ? *set_1++ : *set_2++;
  
  while (*set_1)
    *set_3++ = *set_1++; 
  
  while (*set_2)
    *set_3++ = *set_2++; 
  
  *set_3 = '\0';
  return set_3 - base;
}

/* Sort the UNION_SET in increasing frequency of occurrence.
   This speeds up later processing since we may assume the resulting
   set (Set_3, in this case), is ordered. Uses insertion sort, since
   the UNION_SET is typically short. */
  
static inline void 
Perfect::sort_set (char *union_set, int len)
{
  int i, j;
  
  for (i = 0, j = len - 1; i < j; i++)
    {
      char curr, tmp;

      for (curr = i+1, tmp = union_set[curr]; 
           curr>0 && occurrences[tmp] < occurrences[union_set[curr-1]]; 
           curr--)
        union_set[curr] = union_set[curr - 1];
      
      union_set[curr] = tmp;
    }
}

/* Generate a key set's hash value. */

static inline int 
Perfect::hash (List_Node *key_node) 
{                             
  int   sum = option[NOLENGTH] ? 0 : key_node->length;
  char *ptr;

  for (ptr = key_node->key_set; *ptr; ptr++)
      sum += asso_values[*ptr];
  
  return key_node->hash_value = sum;
}

/* Find out how character value change affects successfully hashed items.
   Returns FALSE if no other hash values are affected, else returns TRUE.
   Note that because Option.Get_Asso_Max is a power of two we can guarantee
   that all legal Asso_Values are visited without repetition since
   Option.Get_Jump was forced to be an odd value! */

bool 
Perfect::affects_prev (char c, List_Node *curr)
{
  int original_char = asso_values[c];
  int i = !option[FAST] ? option.get_asso_max () :
           option.get_iterations () ? /* Elided! */ : list.length ();
  
  /* Try all legal associated values. */
  while (--i >= 0)
    { 
      int        number_of_hits = 0;
      List_Node *ptr;

      asso_values[c] = asso_values[c] + (option[FAST] ? random () : option.get_jump ())
        & option.get_asso_max () - 1;

      /* Ullman's array is a win, O(1) intialization time! */
      duplicate.reset ();     
      
      for (ptr = list.head; ; ptr = ptr->next)
        {
          if (duplicate[hash (ptr)] && ++number_of_hits >= fewest_hits)
            goto bottom_of_main_loop;
          if (ptr == curr)
            break;
        }    
      
      best_asso_value  = asso_values[best_char_choice = c];

      /* Use if 0 hits for this value. */
      if ((fewest_hits = number_of_hits) == 0) 
        return FALSE;        
      
    bottom_of_main_loop: ;
    }
  
  /* Restore original values, no more tries. */
  asso_values[c] = original_char; 
  /* If we're this far it's time to try the next character.... */
  return TRUE; 
}

/* Change a character value, try least-used characters first. */

void 
Perfect::change (List_Node *prior, List_Node *curr)
{
  char       union_set[2 * option.total_positions () + 1]; /* Love that GNU C++! */
  int        i = 1;
  char      *temp;
  List_Node *ptr;

  if (option[DEBUG])        /* Very useful for debugging. */
    fprintf (stderr, "collision, prior->key = %s, curr->key = %s, hash_value = %d\n",
             prior->key, curr->key, curr->hash_value);
  sort_set (union_set, merge_sets (prior->uniq_set, curr->uniq_set, union_set));
  
  /* Try changing some values, if change doesn't alter other values continue normal action. */
  
  fewest_hits = list.length ();
  
  for (temp = union_set; *temp; temp++)
    if (!affects_prev (*temp, curr))
      return; /* Good, doesn't affect previous hash values, we'll take it. */
  
  asso_values[best_char_choice] = best_asso_value; /* If none work take best value. */
  
  for (ptr = list.head; ; ptr = ptr->next, i++)
    {
      hash (ptr);
      if (ptr == curr)
        break;
    }           
  
  if (option[DEBUG])
    fprintf (stderr, "changes on %d hash values still produce duplicates, continuing...\n", i);
}

/* Does the hard stuff....
   Initializes the Ullman_Array, and then attempts to find a Perfect
   function that will hash all the key words without getting any
   duplications.  This is made much easier since we aren't attempting
   to generate *minimum* functions, only Perfect ones.
   If we can't generate a Perfect function in one pass *and* the user
   hasn't enabled the DUP option, we'll inform the user to try the
   randomization option, use -D, or choose alternative key positions.  
   The alternatives (e.g., back-tracking) are too time-consuming, i.e,
   exponential in the number of keys. */

int
Perfect::operator () (void)
{
  List_Node *curr;
  duplicate (max_hash_value);
  hash (list.head);
  
  for (curr = list.head->next; curr; curr = curr->next)
    {
      List_Node *ptr;
      hash (curr);
      
      for (ptr = list.head; ptr != curr; ptr = ptr->next)
        if (ptr->hash_value == curr->hash_value)
          {
            change (ptr, curr);
            break;
          }
    } 
  
  /* Make one final check, just to make sure nothing weird happened.... */
  
  for (duplicate.reset (), curr = list.head; curr; curr = curr->next)
    if (duplicate[hash (curr)])
      if (option[DUP]) /* We'll try to deal with this later..... */
        break;
      else /* Yow, big problems.  we're outta here! */
        { 
          report_error ("\nInternal error, duplicate value %d:\n"
                        "try options -D or -r, or use new key positions.\n\n", hash (curr));
          return 1;
        }

  /* First sorts the key word list by hash value, and the outputs the
     list to the proper ostream. The generated hash table code is only 
     output if the early stage of processing turned out O.K. */

  list.sort ();
  list.output ();
  return 0;
}

/* Prints out some diagnostics upon completion. */

void 
Perfect::~Perfect (void)
{                             
  if (option[DEBUG])
    {
      int i;

      fprintf (stderr, "\ndumping occurrence and associated values tables\n");
      
      for (i = 0; i < ALPHABET_SIZE; i++)
        if (occurrences[i])
          fprintf (stderr, "asso_values[%c] = %3d, occurrences[%c] = %3d\n",
                   i, asso_values[i], i, occurrences[i]);
      
      fprintf (stderr, "end table dumping\n");
      
    }
}

