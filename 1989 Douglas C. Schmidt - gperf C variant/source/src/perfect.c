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
#include <assert.h>
#include <ctype.h>
#include "options.h"
#include "perfect.h"
#include "stderr.h"

int occurrences[ALPHABET_SIZE]; /* Counts occurrences of each key set character. */
int asso_values[ALPHABET_SIZE]; /* Value associated with each character. */

/* Locally visible PERFECT object. */

PERFECT perfect;

/* Efficiently returns the least power of two greater than or equal to X! */
#define POW(X) ((!X)?1:(X-=1,X|=X>>1,X|=X>>2,X|=X>>4,X|=X>>8,X|=X>>16,(++X)))

/* Reads input keys, possibly applies the reordering heuristic, sets the
   maximum associated value size (rounded up to the nearest power of 2),
   may initialize the associated values array, and determines the maximum
   hash table size.  Note: using the random numbers is often helpful,
   though not as deterministic, of course! */

void
perfect_init ()
{
  int asso_value_max;
  int len;

  perfect.best_char_choice = 0;
  perfect.best_asso_value = 0;
  read_keys ();
  if (OPTION_ENABLED (option, ORDER))
    reorder ();

  asso_value_max = GET_ASSO_MAX (option);
  len            = length ();
  
  asso_value_max = (asso_value_max ? asso_value_max * len : len);
  SET_ASSO_MAX (option, POW (asso_value_max));
  
  if (OPTION_ENABLED (option, RANDOM))
    {
      int i;

      srandom (time (0));
      
      for (i = 0; i < ALPHABET_SIZE; i++)
        asso_values[i] = (random () & asso_value_max - 1);
      
    }
  else
    {
      int asso_value = INITIAL_VALUE (option);
      
      if (asso_value)           /* Initialize array if user requests non-zero default. */
        {
          int i;

          for (i = ALPHABET_SIZE - 1; i >= 0; i--)
            asso_values[i] = asso_value & GET_ASSO_MAX (option) - 1;

        }
    }
  perfect.max_hash_value = max_key_length () + GET_ASSO_MAX (option) * 
    (OPTION_ENABLED (option, ALLCHARS) ? max_key_length () : TOTAL_POSITIONS (option));
  
  if (OPTION_ENABLED (option, DEBUG))
    fprintf (stderr, "number of keys = %d\nmaximum associated value is %d\
\nmaximum size of hash table is %d\n", len, asso_value_max, perfect.max_hash_value);
}

/* Merge two disjoint hash key sets to form the ordered union of the sets.
   Precondition: both set_1 and set_2 must be ordered. Returns the length
   of the combined set. */

static int 
merge_sets (set_1, set_2, set_3)
     char *set_1;
     char *set_2;
     char *set_3;
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
  
static void 
sort_set (union_set, len)
     char *union_set;
     int   len;
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

static int 
hash (key_node)
     LIST_NODE *key_node;
{                             
  int   sum = OPTION_ENABLED (option, NOLENGTH) ? 0 : key_node->length;
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

static bool 
affects_prev (c, curr)
     char c;
     LIST_NODE *curr;
{
  int original_char = asso_values[c];
  int i = !OPTION_ENABLED (option, FAST) ? GET_ASSO_MAX (option) :
    GET_ITERATIONS (option) == 0 ? key_list.list_len : GET_ITERATIONS (option);

  /* Try all legal asso_values. */

  while (--i >= 0)
    { 
      int        number_of_hits = 0;
      LIST_NODE *ptr;

      asso_values[c] = asso_values[c] + (OPTION_ENABLED (option, FAST) ? random () : GET_JUMP (option))
        & GET_ASSO_MAX (option) - 1;
      bool_array_reset ();       /* Ullman's array is a win, O(1) intialization time! */
      
      for (ptr = key_list.head; ; ptr = ptr->next)
        {
          if (lookup (hash (ptr)) && ++number_of_hits >= perfect.fewest_hits)
            goto bottom_of_main_loop;
          if (ptr == curr)
            break;
        }    
      
      perfect.best_asso_value  = asso_values[perfect.best_char_choice = c];
      if ((perfect.fewest_hits = number_of_hits) == 0) /* Use if 0 hits for this value. */
        return FALSE;        
      
    bottom_of_main_loop: ;
    }
  
  asso_values[c] = original_char; /* Restore original values, no more tries. */
  return TRUE; /* If we're this far it's time to try the next character.... */
}

#ifdef sparc
#include <alloca.h>
#endif

/* Change a character value, try least-used characters first. */

static void 
change (prior, curr)
     LIST_NODE *prior;
     LIST_NODE *curr;
{
  char      *union_set = (char *) alloca (2 * TOTAL_POSITIONS (option) + 1);
  int        i = 1;
  char      *temp;
  LIST_NODE *ptr;

  if (OPTION_ENABLED (option, DEBUG))        /* Very useful for debugging. */
    fprintf (stderr, "collision, prior->key = %s, curr->key = %s, hash_value = %d\n",
             prior->key, curr->key, curr->hash_value);
  sort_set (union_set, merge_sets (prior->uniq_set, curr->uniq_set, union_set));
  
  /* Try changing some values, if change doesn't alter other values continue normal action. */
  
  perfect.fewest_hits = length ();
  
  for (temp = union_set; *temp; temp++)
    if (!affects_prev (*temp, curr))
      return; /* Good, doesn't affect previous hash values, we'll take it. */
  
  asso_values[perfect.best_char_choice] = perfect.best_asso_value; /* If none work take best value. */
  
  for (ptr = key_list.head; ; ptr = ptr->next, i++)
    {
      hash (ptr);
      if (ptr == curr)
        break;
    }           
  
  if (OPTION_ENABLED (option, DEBUG))
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
perfect_generate ()
{
  LIST_NODE *curr;
  bool_array_init (perfect.max_hash_value);
  hash (key_list.head);
  
  for (curr = key_list.head->next; curr; curr = curr->next)
    {
      LIST_NODE *ptr;
      hash (curr);
      
      for (ptr = key_list.head; ptr != curr; ptr = ptr->next)
        if (ptr->hash_value == curr->hash_value)
          {
            change (ptr, curr);
            break;
          }
    } 
  
  /* Make one final check, just to make sure nothing weird happened.... */
  
  for (bool_array_reset (), curr = key_list.head; curr; curr = curr->next)
    if (lookup (hash (curr)))
      if (OPTION_ENABLED (option, DUP)) /* We'll try to deal with this later..... */
        break;
      else /* Yow, big problems.  we're outta here! */
        { 
          report_error ("\nInternal error, duplicate value %d:\ntry options -D or -r, or use new key positions.\n\n", 
                        hash (curr));
          return 1;
        }

  /* First sorts the key word list by hash value, and the outputs the
     list to the proper ostream. The generated hash table code is only 
     output if the early stage of processing turned out O.K. */

  sort ();
  print_output ();
  return 0;
}

/* Prints out some diagnostics upon completion. */

void 
perfect_destroy ()
{                             
  if (OPTION_ENABLED (option, DEBUG))
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

