#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of archive 4 (of 5)."
# Contents:  cperf/src/keylist.c
# Wrapped by schmidt@crimee.ics.uci.edu on Wed Oct 18 18:27:27 1989
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'cperf/src/keylist.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/keylist.c'\"
else
echo shar: Extracting \"'cperf/src/keylist.c'\" \(31979 characters\)
sed "s/^X//" >'cperf/src/keylist.c' <<'END_OF_FILE'
X/* Routines for building, ordering, and printing the keyword list.
X   Copyright (C) 1989 Free Software Foundation, Inc.
X   written by Douglas C. Schmidt (schmidt@ics.uci.edu)
X
XThis file is part of GNU GPERF.
X
XGNU GPERF is free software; you can redistribute it and/or modify
Xit under the terms of the GNU General Public License as published by
Xthe Free Software Foundation; either version 1, or (at your option)
Xany later version.
X
XGNU GPERF is distributed in the hope that it will be useful,
Xbut WITHOUT ANY WARRANTY; without even the implied warranty of
XMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
XGNU General Public License for more details.
X
XYou should have received a copy of the GNU General Public License
Xalong with GNU GPERF; see the file COPYING.  If not, write to
Xthe Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.  */
X
X#include <assert.h>
X#include <stdio.h>
X#include "options.h"
X#include "readline.h"
X#include "keylist.h"
X#include "hashtable.h"
X#include "stderr.h"
X
X/* Current release version. */
Xextern char *version_string;
X
X/* See comments in perfect.cc. */
Xextern int occurrences[ALPHABET_SIZE]; 
X
X/* Ditto. */
Xextern int asso_values[ALPHABET_SIZE];
X
X/* Used in function reorder, below. */
Xstatic bool determined[ALPHABET_SIZE]; 
X
X/* Default type for generated code. */
Xstatic char *default_array_type = "char *";
X
X/* Generated function ``in_word_set'' default return type. */
Xstatic char *default_return_type = "char *";
X
X/* Largest positive integer value. */
X#define MAX_INT ((~(unsigned)0)>>1)
X
X/* Most negative integer value. */
X#define NEG_MAX_INT ((~(unsigned)0)^((~(unsigned)0)>>1))
X
X/* How wide the printed field width must be to contain the maximum hash value. */
Xstatic int field_width = 2;
X
X/* Globally visible KEY_LIST object. */
X
XKEY_LIST key_list;
X
X/* Gathers the input stream into a buffer until one of two things occur:
X
X   1. We read a '%' followed by a '%'
X   2. We read a '%' followed by a '}'
X
X   The first symbolizes the beginning of the keyword list proper,
X   The second symbolizes the end of the C source code to be generated
X   verbatim in the output file.
X
X   I assume that the keys are separated from the optional preceding struct
X   declaration by a consecutive % followed by either % or } starting in 
X   the first column. The code below uses an expandible buffer to scan off 
X   and return a pointer to all the code (if any) appearing before the delimiter. */
X
Xstatic char *
Xget_special_input (delimiter)
X     char delimiter;
X{ 
X  char *xmalloc ();
X  int size  = 80;
X  char *buf = xmalloc (size);
X  int c, i;
X
X  for (i = 0; (c = getchar ()) != EOF; i++)
X    {
X      if (c == '%')
X        {
X          if ((c = getchar ()) == delimiter)
X            {
X        
X              while ((c = getchar ()) != '\n')
X                ; /* Discard newline. */
X              
X              if (i == 0)
X                return "";
X              else
X                {
X                  buf[delimiter == '%' && buf[i - 2] == ';' ? i - 2 : i - 1] = '\0';
X                  return buf;
X                }
X            }
X          else
X            ungetc (c, stdin);
X        }
X      else if (i >= size) /* Yikes, time to grow the buffer! */
X        { 
X          char *temp = xmalloc (size *= 2);
X          int j;
X          
X          for (j = 0; j < i; j++)
X            temp[j] = buf[j];
X          
X          free (buf);
X          buf = temp;
X        }
X      buf[i] = c;
X    }
X  
X  return NULL;        /* Problem here. */
X}
X
X/* Stores any C text that must be included verbatim into the 
X   generated code output. */
X
Xstatic char *
Xsave_include_src ()
X{
X  int c;
X  
X  if ((c = getchar ()) != '%')
X    {
X      ungetc (c, stdin);
X      return "";
X    }
X  else if ((c = getchar ()) != '{')
X    report_error ("internal error, %c != '{' on line %d in file %s%a", c, __LINE__, __FILE__);
X    /*NOT REACHED*/
X  else 
X    return get_special_input ('}');
X}
X
X/* strcspn - find length of initial segment of s consisting entirely
X   of characters not from reject (borrowed from Henry Spencer's
X   ANSI string package). */
X
Xstatic int
Xstrcspn (s, reject)
X     char *s;
X     char *reject;
X{
X  char *scan;
X  char *rej_scan;
X  int   count = 0;
X
X  for (scan = s; *scan; scan++) 
X    {
X
X      for (rej_scan = reject; *rej_scan;) 
X        if (*scan == *rej_scan++)
X          return count;
X
X      count++;
X    }
X
X  return count;
X}
X
X/* Determines from the input file whether the user wants to build a table
X   from a user-defined struct, or whether the user is content to simply
X   use the default array of keys. */
X
Xstatic char *
Xget_array_type ()
X{
X  return get_special_input ('%');
X}  
X  
X/* Sets up the Return_Type, the Struct_Tag type and the Array_Type
X   based upon various user Options. */
X
Xstatic void 
Xset_output_types ()
X{
X  char *xmalloc ();
X  
X  if (OPTION_ENABLED (option, TYPE) && !(key_list.array_type = get_array_type ()))
X    return;                     /* Something's wrong, bug we'll catch it later on.... */
X  else if (OPTION_ENABLED (option, TYPE))        /* Yow, we've got a user-defined type... */
X    {    
X      int struct_tag_length = strcspn (key_list.array_type, "{\n\0");
X      
X      if (OPTION_ENABLED (option, POINTER))      /* And it must return a pointer... */
X        {    
X          key_list.return_type = xmalloc (struct_tag_length + 2);
X          strncpy (key_list.return_type, key_list.array_type, struct_tag_length);
X          key_list.return_type[struct_tag_length] = '\0';
X          strcat (key_list.return_type, "*");
X        }
X      
X      key_list.struct_tag = (char *) xmalloc (struct_tag_length + 1);
X      strncpy (key_list.struct_tag, key_list.array_type, struct_tag_length);
X      key_list.struct_tag[struct_tag_length] = '\0';
X    }  
X  else if (OPTION_ENABLED (option, POINTER))     /* Return a char *. */
X    key_list.return_type = default_array_type;
X}
X
X/* Reads in all keys from standard input and creates a linked list pointed
X   to by Head.  This list is then quickly checked for ``links,'' i.e.,
X   unhashable elements possessing identical key sets and lengths. */
X
Xvoid 
Xread_keys ()
X{
X  char     *ptr;
X  
X  key_list.include_src = save_include_src ();
X  set_output_types ();
X
X  /* Oops, problem with the input file. */  
X  if (! (ptr = read_line ())) 
X    report_error ("No words in input file, did you forget to prepend %s or use -t accidentally?\n%a", "%%");
X
X  /* Read in all the keywords from the input file. */
X  else 
X    {                      
X      LIST_NODE *temp, *trail;
X
X      for (temp = key_list.head = make_list_node (ptr, strcspn (ptr, ",\n"));
X           (ptr = read_line ()) && strcmp (ptr, "%%");
X           key_list.total_keys++, temp = temp->next)
X        temp->next = make_list_node (ptr, strcspn (ptr, ",\n"));
X      
X      /* See if any additional C code is included at end of this file. */
X      if (ptr)
X        key_list.additional_code = TRUE;
X      {
X        /* If this becomes TRUE we've got a link. */
X        bool       link = FALSE;  
X
X        /* Hash table this number of times larger than keyword number. */
X        int table_multiple = 5; 
X
X        /* Make large hash table for efficiency. */
X        hash_table_init ((key_list.list_len = key_list.total_keys) * table_multiple); 
X
X        /* Test whether there are any links and also set the maximum length of
X          an identifier in the keyword list. */
X      
X        for (temp = key_list.head, trail = NULL; temp; temp = temp->next)
X          {
X            LIST_NODE *ptr = retrieve (temp, OPTION_ENABLED (option, NOLENGTH));
X          
X            /* Check for links.  We deal with these by building an equivalence class
X              of all duplicate values (i.e., links) so that only 1 keyword is
X                representative of the entire collection.  This *greatly* simplifies
X                  processing during later stages of the program. */
X
X            if (ptr)              
X              {                   
X                key_list.list_len--;
X                trail->next = temp->next;
X                temp->link  = ptr->link;
X                ptr->link   = temp;
X                link        = TRUE;
X
X                /* Complain if user hasn't enabled the duplicate option. */
X                if (!OPTION_ENABLED (option, DUP))
X                  report_error ("Key link: \"%s\" = \"%s\", with key set \"%s\".\n", temp->key, ptr->key, temp->key_set);
X                else if (OPTION_ENABLED (option, DEBUG))
X                  report_error ("Key link: \"%s\" = \"%s\", with key set \"%s\".\n", temp->key, ptr->key, temp->key_set);                
X              }
X            else
X              trail = temp;
X            
X            /* Update minimum and maximum keyword length, if needed. */
X            if (temp->length > key_list.max_key_len) 
X              key_list.max_key_len = temp->length;
X            if (temp->length < key_list.min_key_len) 
X              key_list.min_key_len = temp->length;
X          }
X
X        /* Exit program if links exists and option[DUP] not set, since we can't continue */
X        if (link) 
X          {
X            if (OPTION_ENABLED (option, DUP))
X              {
X                if (!OPTION_ENABLED (option, SWITCH))
X                  {
X                    report_error ("turning on -S option.\n");
X                    SET_OPTION (option, SWITCH);
X                  }
X                report_error ("Some input keys have identical hash values, examine output carefully...\n");
X              }
X            else
X              report_error ("Some input keys have identical hash values,\ntry different key positions or use option -D.\n%a");
X          }
X        else if (OPTION_ENABLED (option, DUP))
X          {
X            /* If no links, clear the DUP option so we can use the length
X              table, if output. */
X            UNSET_OPTION (option, DUP);
X          }
X        
X      }
X    }
X}
X
X/* Recursively merges two sorted lists together to form one sorted list. The
X   ordering criteria is by frequency of occurrence of elements in the key set
X   or by the hash value.  This is a kludge, but permits nice sharing of
X   almost identical code without incurring the overhead of a function
X   call comparison. */
X  
Xstatic 
XLIST_NODE *merge (list1, list2)
X     LIST_NODE *list1;
X     LIST_NODE *list2;
X{
X  if (!list1)
X    return list2;
X  else if (!list2)
X    return list1;
X  else if (key_list.occurrence_sort && list1->occurrence < list2->occurrence
X           || key_list.hash_sort && list1->hash_value > list2->hash_value)
X    {
X      list2->next = merge (list2->next, list1);
X      return list2;
X    }
X  else
X    {
X      list1->next = merge (list1->next, list2);
X      return list1;
X    }
X}
X
X/* Applies the merge sort algorithm to recursively sort the key list by
X   frequency of occurrence of elements in the key set. */
X  
Xstatic 
XLIST_NODE *merge_sort (head)
X     LIST_NODE *head;
X{ 
X  if (!head || !head->next)
X    return head;
X  else
X    {
X      LIST_NODE *middle = head;
X      LIST_NODE *temp   = head->next->next;
X    
X      while (temp)
X        {
X          temp   = temp->next;
X          middle = middle->next;
X          if (temp)
X            temp = temp->next;
X        } 
X    
X      temp         = middle->next;
X      middle->next = NULL;
X      return merge (merge_sort (head), merge_sort (temp));
X    }   
X}
X
X/* Returns the frequency of occurrence of elements in the key set. */
X
Xstatic int 
Xget_occurrence (ptr)
X     LIST_NODE *ptr;
X{
X  int   value = 0;
X  char *temp;
X
X  for (temp = ptr->key_set; *temp; temp++)
X    value += occurrences[*temp];
X  
X  return value;
X}
X
X/* Enables the index location of all key set elements that are now 
X   determined. */
X  
Xstatic void 
Xset_determined (ptr)
X     LIST_NODE *ptr;
X{
X  char *temp;
X  
X  for (temp = ptr->key_set; *temp; temp++)
X    determined[*temp] = TRUE;
X  
X}
X
X/* Returns TRUE if PTR's key set is already completely determined. */
X
Xstatic bool 
Xalready_determined (ptr)
X     LIST_NODE *ptr;
X{
X  bool  is_determined = TRUE;
X  char *temp;
X
X  for (temp = ptr->key_set; is_determined && *temp; temp++)
X    is_determined = determined[*temp];
X  
X  return is_determined;
X}
X
X/* Reorders the table by first sorting the list so that frequently occuring 
X   keys appear first, and then the list is reorded so that keys whose values 
X   are already determined will be placed towards the front of the list.  This
X   helps prune the search time by handling inevitable collisions early in the
X   search process.  See Cichelli's paper from Jan 1980 JACM for details.... */
X
Xvoid 
Xreorder ()
X{
X  LIST_NODE *ptr;
X
X  for (ptr = key_list.head; ptr; ptr = ptr->next)
X    ptr->occurrence = get_occurrence (ptr);
X  
X  key_list.hash_sort       = FALSE;
X  key_list.occurrence_sort = TRUE;
X  
X  for (ptr = key_list.head = merge_sort (key_list.head); ptr->next; ptr = ptr->next)
X    {
X      set_determined (ptr);
X    
X      if (already_determined (ptr->next))
X        continue;
X      else
X        {
X          LIST_NODE *trail_ptr = ptr->next;
X          LIST_NODE *run_ptr   = trail_ptr->next;
X      
X          for (; run_ptr; run_ptr = trail_ptr->next)
X            {
X        
X              if (already_determined (run_ptr))
X                {
X                  trail_ptr->next = run_ptr->next;
X                  run_ptr->next   = ptr->next;
X                  ptr = ptr->next = run_ptr;
X                }
X              else
X                trail_ptr = run_ptr;
X            }
X        }
X    }     
X}
X
X/* Determines the maximum and minimum hash values.  One notable feature is 
X   Ira Pohl's optimal algorithm to calculate both the maximum and minimum
X   items in a list in O(3n/2) time (faster than the O (2n) method). 
X   Returns the maximum hash value encountered. */
X  
Xstatic int 
Xprint_min_max ()
X{
X  int          min_hash_value;
X  int          max_hash_value;
X  LIST_NODE   *temp;
X  
X  if (ODD (key_list.list_len)) /* Pre-process first item, list now has an even length. */
X    {              
X      min_hash_value  = max_hash_value = key_list.head->hash_value;
X      temp            = key_list.head->next;
X    }
X  else /* List is already even length, no extra work necessary. */
X    {                      
X      min_hash_value = MAX_INT;
X      max_hash_value = NEG_MAX_INT;
X      temp           = key_list.head;
X    }
X  
X  for ( ; temp; temp = temp->next) /* Find max and min in optimal o(3n/2) time. */
X    { 
X      static int i;
X      int key_2, key_1 = temp->hash_value;
X      temp  = temp->next;
X      key_2 = temp->hash_value;
X      i++;
X      
X      if (key_1 < key_2)
X        {
X          if (key_1 < min_hash_value)
X            min_hash_value = key_1;
X          if (key_2 > max_hash_value)
X            max_hash_value = key_2;
X        }
X      else
X        {
X          if (key_2 < min_hash_value)
X            min_hash_value = key_2;
X          if (key_1 > max_hash_value)
X            max_hash_value = key_1;
X        }
X  }
X  
X  printf ("\n#define MIN_WORD_LENGTH %d\n#define MAX_WORD_LENGTH %d\
X\n#define MIN_HASH_VALUE %d\n#define MAX_HASH_VALUE %d\
X\n/*\n%5d keywords\n%5d is the maximum key range\n*/\n\n",
X          key_list.min_key_len == MAX_INT ? key_list.max_key_len : key_list.min_key_len,
X          key_list.max_key_len, min_hash_value, max_hash_value,
X          key_list.total_keys, (max_hash_value - min_hash_value + 1));
X  return max_hash_value;
X}
X
X/* Generates the output using a C switch.  This trades increased search
X   time for decreased table space (potentially *much* less space for
X   sparse tables). It the user has specified their own struct in the
X   keyword file *and* they enable the POINTER option we have extra work to
X   do.  The solution here is to maintain a local static array of user
X   defined struct's, as with the Print_Lookup_Function.  Then we use for
X   switch statements to perform a strcmp or strncmp, returning 0 if the str 
X   fails to match, and otherwise returning a pointer to appropriate index
X   location in the local static array. */
X
X#ifdef sparc
X#include <alloca.h>
X#endif
X
Xstatic void 
Xprint_switch ()
X{
X  char *comp_buffer;
X  int   pointer_and_type_enabled = OPTION_ENABLED (option, POINTER) && OPTION_ENABLED (option, TYPE);
X
X  if (pointer_and_type_enabled)
X    {
X      comp_buffer = (char *) alloca (strlen ("*str == *resword->%s && !strncmp (str + 1, resword->%s + 1, len - 1)"
X                                             + 2 * strlen (GET_KEY_NAME (option)) + 1));
X      sprintf (comp_buffer, OPTION_ENABLED (option, COMP)
X               ? "*str == *resword->%s && !strncmp (str + 1, resword->%s + 1, len - 1)"
X               : "*str == *resword->%s && !strcmp (str + 1, resword->%s + 1)", GET_KEY_NAME (option), GET_KEY_NAME (option));
X    }
X  else
X    comp_buffer = OPTION_ENABLED (option, COMP) 
X      ? "*str == *resword && !strncmp (str + 1, resword + 1, len - 1)" 
X        : "*str == *resword && !strcmp (str + 1, resword + 1)";
X
X  printf ("  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)\n    {\n\
X      register int key = %s (str, len);\n\n\
X      if (key <= MAX_HASH_VALUE && key >= MIN_HASH_VALUE)\n        {\n",
X          GET_HASH_NAME (option));
X  
X  /* Output each keyword as part of a switch statement indexed by hash value. */
X  
X  if (OPTION_ENABLED (option, POINTER) || OPTION_ENABLED (option, DUP))
X    {
X      LIST_NODE *temp;
X
X      printf ("          %s%s *resword; %s\n\n          switch (key)\n            {\n",
X              OPTION_ENABLED (option, CONST) ? "const " : "",
X              pointer_and_type_enabled ? key_list.struct_tag : "char", 
X              OPTION_ENABLED (option, LENTABLE) && !OPTION_ENABLED (option, DUP) ? "int key_len;" : "");
X
X      for (temp = key_list.head; temp; temp = temp->next)
X        {
X          printf ("            case %*d:\n", field_width, temp->hash_value);
X
X          if (temp->link)
X            {
X              LIST_NODE *links;
X
X              for (links = temp; links; links = links->link)
X                {
X                  if (pointer_and_type_enabled)
X                    printf ("              resword = &wordlist[%d];\n", links->index);
X                  else
X                    printf ("              resword = \"%s\";\n", links->key); 
X                  printf ("              if (%s) return resword;\n", comp_buffer);
X                }
X              printf ("              return 0;\n");
X            }
X          else if (temp->next && temp->hash_value == temp->next->hash_value)
X            {
X
X              for ( ; temp->next && temp->hash_value == temp->next->hash_value;
X                   temp = temp->next)
X                {
X                  if (pointer_and_type_enabled)
X                    printf ("              resword = &wordlist[%d];\n", temp->index);
X                  else
X                    printf ("              resword = \"%s\";\n", temp->key);
X                  printf ("              if (%s) return resword;\n", comp_buffer);
X                }
X              if (pointer_and_type_enabled)
X                printf ("              resword = &wordlist[%d];\n", temp->index);
X              else
X                printf ("              resword = \"%s\";\n", temp->key);
X              printf ("              return %s ? resword : 0;\n", comp_buffer);
X            }
X          else 
X            {
X              if (pointer_and_type_enabled)
X                printf ("              resword = &wordlist[%d];", temp->index);
X              else 
X                printf ("              resword = \"%s\";", temp->key);
X              if (OPTION_ENABLED (option, LENTABLE) && !OPTION_ENABLED (option, DUP))
X                printf (" key_len = %d;", temp->length);
X              printf (" break;\n");
X            }
X        }
X      printf ("            default: return 0;\n            }\n");
X      printf (OPTION_ENABLED (option, LENTABLE) && !OPTION_ENABLED (option, DUP)
X              ? "          if (len == key_len && %s)\n            return resword;\n"
X              : "          if (%s)\n            return resword;\n", comp_buffer);
X      printf ("      }\n  }\n  return 0;\n}\n");
X    }
X  else                          /* Nothing special required here. */
X    {                        
X      LIST_NODE *temp;
X
X      printf ("          char *s = \"\";\n\n          switch (key)\n            {\n");
X      
X      for (temp = key_list.head; temp; temp = temp->next)
X        if (OPTION_ENABLED (option, LENTABLE))
X          printf ("            case %*d: if (len == %d) s = \"%s\"; else return 0; break;\n", 
X                  field_width, temp->hash_value, temp->length, temp->key);
X        else
X          printf ("            case %*d: s = \"%s\"; break;\n",
X                  field_width, temp->hash_value, temp->key);
X                      
X      printf ("            default: return 0;\n            }\n          return *s == *str && !%s;\n        }\n    }\n  return 0;\n}\n", 
X              OPTION_ENABLED (option, COMP) ? "strncmp (s + 1, str + 1, len - 1)" : "strcmp (s + 1, str + 1)");
X    }
X}
X
X/* Prints out a table of keyword lengths, for use with the 
X   comparison code in generated function ``in_word_set.'' */
X
Xstatic void 
Xprint_keylength_table ()
X{
X  int        max_column = 15;
X  int        index      = 0;
X  int        column     = 0;
X  char      *indent     = OPTION_ENABLED (option, GLOBAL) ? "" : "  ";
X  LIST_NODE *temp;
X
X  if (!OPTION_ENABLED (option, DUP) && !OPTION_ENABLED (option, SWITCH)) 
X    {
X      printf ("\n%sstatic %sunsigned %s lengthtable[] =\n%s%s{\n    ",
X              indent, OPTION_ENABLED (option, CONST) ? "const " : "",
X              key_list.max_key_len < 256 ? "char" :
X              (key_list.max_key_len < 65536 ? "short" : "long"),
X              indent, indent);
X  
X      for (temp = key_list.head; temp; temp = temp->next, index++)
X        {
X    
X          if (index < temp->hash_value)
X            {
X      
X              for ( ; index < temp->hash_value; index++)
X                printf ("%3d%s", 0, ++column % (max_column - 1) ? "," : ",\n    ");
X            }
X    
X          printf ("%3d%s", temp->length, ++column % (max_column - 1 ) ? "," : ",\n    ");
X        }
X  
X      printf ("\n%s%s};\n\n", indent, indent);
X    }
X}
X
X/* Prints out the array containing the key words for the Perfect
X   hash function. */
X  
Xstatic void 
Xprint_keyword_table ()
X{
X  char      *l_brace      = *key_list.head->rest ? "{" : "";
X  char      *r_brace      = *key_list.head->rest ? "}," : "";
X  int        doing_switch = OPTION_ENABLED (option, SWITCH);
X  char      *indent       = OPTION_ENABLED (option, GLOBAL) ? "" : "  ";
X  int        index        = 0;
X  LIST_NODE *temp;
X
X  printf ("\n%sstatic %s%s wordlist[] =\n%s%s{\n", 
X          indent, OPTION_ENABLED (option, CONST) ? "const " : "",
X          key_list.struct_tag, indent, indent);
X  
X  /* Generate an array of reserved words at appropriate locations. */
X  
X	for (temp = key_list.head; temp; temp = temp->next, index++)
X		{
X			temp->index = index;
X
X			if (!doing_switch && index < temp->hash_value)
X				{
X					int column;
X
X					printf ("      ");
X      
X					for (column = 1; index < temp->hash_value; index++, column++)
X						printf ("%s\"\",%s %s", l_brace, r_brace, column % 9 ? "" : "\n      ");
X      
X					if (column % 10)
X						printf ("\n");
X					else 
X						{
X							printf ("%s\"%s\", %s%s\n", l_brace, temp->key, temp->rest, r_brace);
X							continue;
X						}
X				}
X
X			printf ("      %s\"%s\", %s%s\n", l_brace, temp->key, temp->rest, r_brace);
X
X			/* Deal with links specially. */
X			if (temp->link)
X				{
X					LIST_NODE *links;
X
X					for (links = temp->link; links; links = links->link)
X						{
X							links->index = ++index;
X							printf ("      %s\"%s\", %s%s\n", l_brace, links->key, links->rest, r_brace);
X						}
X				}
X
X		}
X
X  printf ("%s%s};\n\n", indent, indent);
X}
X
X/* Generates C code for the hash function that returns the
X   proper encoding for each key word. */
X
Xstatic void 
Xprint_hash_function (max_hash_value)
X     int max_hash_value;
X{
X  int max_column = 10;
X  int count       = max_hash_value;
X
X  /* Calculate maximum number of digits required for MAX_HASH_VALUE. */
X
X  while ((count /= 10) > 0)
X    field_width++;
X
X  if (OPTION_ENABLED (option, GNU))
X    printf ("#ifdef __GNUC__\ninline\n#endif\n");
X  
X  printf (OPTION_ENABLED (option, ANSI) 
X          ? "static int\n%s (register const char *str, register int len)\n{\n  static %sunsigned %s hash_table[] =\n    {"
X          : "static int\n%s (str, len)\n     register char *str;\n     register unsigned int  len;\n{\n  static %sunsigned %s hash_table[] =\n    {",
X          GET_HASH_NAME (option), OPTION_ENABLED (option, CONST) ? "const " : "",
X          max_hash_value < 256 ? "char" : (max_hash_value < 65536 ? "short" : "int"));
X  
X  for (count = 0; count < ALPHABET_SIZE; ++count)
X    {
X      if (!(count % max_column))
X        printf ("\n    ");
X      
X      printf ("%*d,", field_width, occurrences[count] ? asso_values[count] : max_hash_value);
X    }
X  
X  /* Optimize special case of ``-k 1,$'' */
X  if (OPTION_ENABLED (option, DEFAULTCHARS)) 
X    printf ("\n    };\n  return %s + hash_table[str[len - 1]] + hash_table[str[0]];\n}\n\n",
X            OPTION_ENABLED (option, NOLENGTH) ? "0" : "len");
X  else
X    {
X      int key_pos;
X
X      RESET (option);
X
X      /* Get first (also highest) key position. */
X      key_pos = GET (option); 
X      
X      /* We can perform additional optimizations here. */
X      if (!OPTION_ENABLED (option, ALLCHARS) && key_pos <= key_list.min_key_len) 
X        { 
X          printf ("\n  };\n  return %s", OPTION_ENABLED (option, NOLENGTH) ? "0" : "len");
X          
X          for ( ; key_pos != EOS && key_pos != WORD_END; key_pos = GET (option))
X            printf (" + hash_table[str[%d]]", key_pos - 1);
X           
X          printf ("%s;\n}\n\n", key_pos == WORD_END ? " + hash_table[str[len - 1]]" : "");
X        }
X
X      /* We've got to use the correct, but brute force, technique. */
X      else 
X        {                    
X          printf ("\n    };\n  register int hval = %s ;\n\n  switch (%s)\n    {\n      default:\n",
X                  OPTION_ENABLED (option, NOLENGTH) ? "0" : "len", OPTION_ENABLED (option, NOLENGTH) ? "len" : "hval");
X          
X          /* User wants *all* characters considered in hash. */
X          if (OPTION_ENABLED (option, ALLCHARS)) 
X            { 
X              int i;
X
X              for (i = key_list.max_key_len; i > 0; i--)
X                printf ("      case %d:\n        hval += hash_table[str[%d]];\n", i, i - 1);
X              
X              printf ("    }\n  return hval;\n}\n\n");
X            }
X          else /* do the hard part... */
X            {                
X              count = key_pos + 1;
X              
X              do
X                {
X                  
X                  while (--count > key_pos)
X                    printf ("      case %d:\n", count);
X                  
X                  printf ("      case %d:\n        hval += hash_table[str[%d]];\n", key_pos, key_pos - 1);
X                }
X              while ((key_pos = GET (option)) != EOS && key_pos != WORD_END);
X              
X              printf ("    }\n  return hval%s ;\n}\n\n", key_pos == WORD_END ? " + hash_table[str[len - 1]]" : "");
X          }
X      }
X  }
X}
X
X/* Generates C code to perform the keyword lookup. */
X
Xstatic void 
Xprint_lookup_function ()
X{ 
X  printf ("  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)\n    {\n\
X      register int key = %s (str, len);\n\n\
X      if (key <= MAX_HASH_VALUE && key >= MIN_HASH_VALUE)\n        {\n\
X          register %schar *s = wordlist[key]", 
X          GET_HASH_NAME (option), OPTION_ENABLED (option, CONST) ? "const " : "");
X  if (key_list.array_type != default_array_type)
X    printf (".%s", GET_KEY_NAME (option));
X
X  printf (";\n\n          if (%s*s == *str && !%s)\n            return %s",
X          OPTION_ENABLED (option, LENTABLE) ? "len == lengthtable[key]\n              && " : "",
X          OPTION_ENABLED (option, COMP) ? "strncmp (str + 1, s + 1, len - 1)" : "strcmp (str + 1, s + 1)",
X          OPTION_ENABLED (option, TYPE) && OPTION_ENABLED (option, POINTER) ? "&wordlist[key]" : "s");
X  printf (";\n        }\n    }\n  return 0;\n}\n");
X}
X
X/* Generates the hash function and the key word recognizer function
X   based upon the user's Options. */
X
Xvoid 
Xprint_output ()
X{
X  int global_table = OPTION_ENABLED (option, GLOBAL);
X
X  printf ("/* C code produced by gperf version %s */\n", version_string);
X  print_options ();
X  
X  printf ("%s\n", key_list.include_src);
X  
X  /* Potentially output type declaration now, reference it later on.... */
X  if (OPTION_ENABLED (option, TYPE) && !OPTION_ENABLED (option, NOTYPE)) 
X    printf ("%s;\n", key_list.array_type);
X  
X  print_hash_function (print_min_max ());
X  
X  if (global_table)
X    if (OPTION_ENABLED (option, SWITCH))
X      {
X        if (OPTION_ENABLED (option, LENTABLE) && OPTION_ENABLED (option, DUP))
X          print_keylength_table ();
X        if (OPTION_ENABLED (option, POINTER) && OPTION_ENABLED (option, TYPE))
X          print_keyword_table ();
X      }
X    else
X      {
X        if (OPTION_ENABLED (option, LENTABLE))
X          print_keylength_table ();
X        print_keyword_table ();
X      }
X  /* Use the inline keyword to remove function overhead. */
X  if (OPTION_ENABLED (option, GNU)) 
X    printf ("#ifdef __GNUC__\ninline\n#endif\n");
X  
X  /* Use ANSI function prototypes. */
X  printf (OPTION_ENABLED (option, ANSI)
X          ? "%s%s\n%s (register const char *str, register int len)\n{\n"
X          : "%s%s\n%s (str, len)\n     register char *str;\n     register unsigned int len;\n{\n", 
X            OPTION_ENABLED (option, CONST) ? "const " : "", 
X            key_list.return_type, GET_FUNCTION_NAME (option));
X  
X  /* Use the switch in place of lookup table. */
X  if (OPTION_ENABLED (option, SWITCH))
X    {               
X      if (!global_table)
X        {
X          if (OPTION_ENABLED (option, LENTABLE) && OPTION_ENABLED (option, DUP))
X            print_keylength_table ();
X          if (OPTION_ENABLED (option, POINTER) && OPTION_ENABLED (option, TYPE)) 
X            print_keyword_table ();
X        }
X      print_switch ();
X    }
X  else                /* Use the lookup table, in place of switch. */
X    {           
X      if (!global_table)
X        {
X          if (OPTION_ENABLED (option, LENTABLE))
X            print_keylength_table ();
X          print_keyword_table ();
X        }
X      print_lookup_function ();
X    }
X
X  if (key_list.additional_code)
X    {
X      int c;
X
X      while ((c = getchar ()) != EOF)
X        putchar (c);
X    }
X}
X
X/* Sorts the keys by hash value. */
X
Xvoid 
Xsort ()
X{ 
X  key_list.hash_sort       = TRUE;
X  key_list.occurrence_sort = FALSE;
X  
X  key_list.head = merge_sort (key_list.head);
X}
X
X/* Dumps the key list to stderr stream. */
X
Xstatic void 
Xdump () 
X{      
X  LIST_NODE *ptr;
X
X  report_error ("\nList contents are:\n(hash value, key length, index, key set, uniq set, key):\n");
X  
X  for (ptr = key_list.head; ptr; ptr = ptr->next)
X    report_error ("      %d,      %d,     %d, %s, %s, %s\n",
X                  ptr->hash_value, ptr->length, ptr->index,
X                  ptr->key_set, ptr->uniq_set, ptr->key);
X}
X
X/* Simple-minded constructor action here... */
X
Xvoid
Xkey_list_init ()
X{   
X  key_list.total_keys      = 1;
X  key_list.max_key_len     = NEG_MAX_INT;
X  key_list.min_key_len     = MAX_INT;
X  key_list.return_type     = default_return_type;
X  key_list.array_type      = key_list.struct_tag  = default_array_type;
X  key_list.head            = NULL;
X  key_list.additional_code = FALSE;
X}
X
X/* Returns the length of entire key list. */
X
Xint 
Xlength () 
X{ 
X  return key_list.list_len;
X}
X
X/* Returns length of longest key read. */
X
Xint 
Xmax_key_length ()
X{ 
X  return key_list.max_key_len;
X}
X
X/* DESTRUCTOR dumps diagnostics during debugging. */
X
Xvoid
Xkey_list_destroy () 
X{ 
X  if (OPTION_ENABLED (option, DEBUG))
X    {
X      report_error ("\nDumping key list information:\ntotal unique keywords = %d\
X\ntotal keywords = %d\nmaximum key length = %d.\n", 
X                    key_list.list_len, key_list.total_keys, key_list.max_key_len);
X      dump ();
X      report_error ("End dumping list.\n\n");
X    }
X}
X
END_OF_FILE
if test 31979 -ne `wc -c <'cperf/src/keylist.c'`; then
    echo shar: \"'cperf/src/keylist.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/keylist.c'
fi
echo shar: End of archive 4 \(of 5\).
cp /dev/null ark4isdone
MISSING=""
for I in 1 2 3 4 5 ; do
    if test ! -f ark${I}isdone ; then
	MISSING="${MISSING} ${I}"
    fi
done
if test "${MISSING}" = "" ; then
    echo You have unpacked all 5 archives.
    rm -f ark[1-9]isdone
else
    echo You still need to unpack the following archives:
    echo "        " ${MISSING}
fi
##  End of shell archive.
exit 0

