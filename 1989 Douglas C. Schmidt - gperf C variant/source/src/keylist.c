/* Routines for building, ordering, and printing the keyword list.
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

#include <assert.h>
#include <stdio.h>
#include "options.h"
#include "readline.h"
#include "keylist.h"
#include "hashtable.h"
#include "stderr.h"

/* Current release version. */
extern char *version_string;

/* See comments in perfect.cc. */
extern int occurrences[ALPHABET_SIZE]; 

/* Ditto. */
extern int asso_values[ALPHABET_SIZE];

/* Used in function reorder, below. */
static bool determined[ALPHABET_SIZE]; 

/* Default type for generated code. */
static char *default_array_type = "char *";

/* Generated function ``in_word_set'' default return type. */
static char *default_return_type = "char *";

/* Largest positive integer value. */
#define MAX_INT ((~(unsigned)0)>>1)

/* Most negative integer value. */
#define NEG_MAX_INT ((~(unsigned)0)^((~(unsigned)0)>>1))

/* How wide the printed field width must be to contain the maximum hash value. */
static int field_width = 2;

/* Globally visible KEY_LIST object. */

KEY_LIST key_list;

/* Gathers the input stream into a buffer until one of two things occur:

   1. We read a '%' followed by a '%'
   2. We read a '%' followed by a '}'

   The first symbolizes the beginning of the keyword list proper,
   The second symbolizes the end of the C source code to be generated
   verbatim in the output file.

   I assume that the keys are separated from the optional preceding struct
   declaration by a consecutive % followed by either % or } starting in 
   the first column. The code below uses an expandible buffer to scan off 
   and return a pointer to all the code (if any) appearing before the delimiter. */

static char *
get_special_input (delimiter)
     char delimiter;
{ 
  char *xmalloc ();
  int size  = 80;
  char *buf = xmalloc (size);
  int c, i;

  for (i = 0; (c = getchar ()) != EOF; i++)
    {
      if (c == '%')
        {
          if ((c = getchar ()) == delimiter)
            {
        
              while ((c = getchar ()) != '\n')
                ; /* Discard newline. */
              
              if (i == 0)
                return "";
              else
                {
                  buf[delimiter == '%' && buf[i - 2] == ';' ? i - 2 : i - 1] = '\0';
                  return buf;
                }
            }
          else
            ungetc (c, stdin);
        }
      else if (i >= size) /* Yikes, time to grow the buffer! */
        { 
          char *temp = xmalloc (size *= 2);
          int j;
          
          for (j = 0; j < i; j++)
            temp[j] = buf[j];
          
          free (buf);
          buf = temp;
        }
      buf[i] = c;
    }
  
  return NULL;        /* Problem here. */
}

/* Stores any C text that must be included verbatim into the 
   generated code output. */

static char *
save_include_src ()
{
  int c;
  
  if ((c = getchar ()) != '%')
    {
      ungetc (c, stdin);
      return "";
    }
  else if ((c = getchar ()) != '{')
    report_error ("internal error, %c != '{' on line %d in file %s%a", c, __LINE__, __FILE__);
    /*NOT REACHED*/
  else 
    return get_special_input ('}');
}

/* strcspn - find length of initial segment of s consisting entirely
   of characters not from reject (borrowed from Henry Spencer's
   ANSI string package). */

static int
strcspn (s, reject)
     char *s;
     char *reject;
{
  char *scan;
  char *rej_scan;
  int   count = 0;

  for (scan = s; *scan; scan++) 
    {

      for (rej_scan = reject; *rej_scan;) 
        if (*scan == *rej_scan++)
          return count;

      count++;
    }

  return count;
}

/* Determines from the input file whether the user wants to build a table
   from a user-defined struct, or whether the user is content to simply
   use the default array of keys. */

static char *
get_array_type ()
{
  return get_special_input ('%');
}  
  
/* Sets up the Return_Type, the Struct_Tag type and the Array_Type
   based upon various user Options. */

static void 
set_output_types ()
{
  char *xmalloc ();
  
  if (OPTION_ENABLED (option, TYPE) && !(key_list.array_type = get_array_type ()))
    return;                     /* Something's wrong, bug we'll catch it later on.... */
  else if (OPTION_ENABLED (option, TYPE))        /* Yow, we've got a user-defined type... */
    {    
      int struct_tag_length = strcspn (key_list.array_type, "{\n\0");
      
      if (OPTION_ENABLED (option, POINTER))      /* And it must return a pointer... */
        {    
          key_list.return_type = xmalloc (struct_tag_length + 2);
          strncpy (key_list.return_type, key_list.array_type, struct_tag_length);
          key_list.return_type[struct_tag_length] = '\0';
          strcat (key_list.return_type, "*");
        }
      
      key_list.struct_tag = (char *) xmalloc (struct_tag_length + 1);
      strncpy (key_list.struct_tag, key_list.array_type, struct_tag_length);
      key_list.struct_tag[struct_tag_length] = '\0';
    }  
  else if (OPTION_ENABLED (option, POINTER))     /* Return a char *. */
    key_list.return_type = default_array_type;
}

/* Reads in all keys from standard input and creates a linked list pointed
   to by Head.  This list is then quickly checked for ``links,'' i.e.,
   unhashable elements possessing identical key sets and lengths. */

void 
read_keys ()
{
  char     *ptr;
  
  key_list.include_src = save_include_src ();
  set_output_types ();

  /* Oops, problem with the input file. */  
  if (! (ptr = read_line ())) 
    report_error ("No words in input file, did you forget to prepend %s or use -t accidentally?\n%a", "%%");

  /* Read in all the keywords from the input file. */
  else 
    {                      
      LIST_NODE *temp, *trail;

      for (temp = key_list.head = make_list_node (ptr, strcspn (ptr, ",\n"));
           (ptr = read_line ()) && strcmp (ptr, "%%");
           key_list.total_keys++, temp = temp->next)
        temp->next = make_list_node (ptr, strcspn (ptr, ",\n"));
      
      /* See if any additional C code is included at end of this file. */
      if (ptr)
        key_list.additional_code = TRUE;
      {
        /* If this becomes TRUE we've got a link. */
        bool       link = FALSE;  

        /* Hash table this number of times larger than keyword number. */
        int table_multiple = 5; 

        /* Make large hash table for efficiency. */
        hash_table_init ((key_list.list_len = key_list.total_keys) * table_multiple); 

        /* Test whether there are any links and also set the maximum length of
          an identifier in the keyword list. */
      
        for (temp = key_list.head, trail = NULL; temp; temp = temp->next)
          {
            LIST_NODE *ptr = retrieve (temp, OPTION_ENABLED (option, NOLENGTH));
          
            /* Check for links.  We deal with these by building an equivalence class
              of all duplicate values (i.e., links) so that only 1 keyword is
                representative of the entire collection.  This *greatly* simplifies
                  processing during later stages of the program. */

            if (ptr)              
              {                   
                key_list.list_len--;
                trail->next = temp->next;
                temp->link  = ptr->link;
                ptr->link   = temp;
                link        = TRUE;

                /* Complain if user hasn't enabled the duplicate option. */
                if (!OPTION_ENABLED (option, DUP))
                  report_error ("Key link: \"%s\" = \"%s\", with key set \"%s\".\n", temp->key, ptr->key, temp->key_set);
                else if (OPTION_ENABLED (option, DEBUG))
                  report_error ("Key link: \"%s\" = \"%s\", with key set \"%s\".\n", temp->key, ptr->key, temp->key_set);                
              }
            else
              trail = temp;
            
            /* Update minimum and maximum keyword length, if needed. */
            if (temp->length > key_list.max_key_len) 
              key_list.max_key_len = temp->length;
            if (temp->length < key_list.min_key_len) 
              key_list.min_key_len = temp->length;
          }

        /* Exit program if links exists and option[DUP] not set, since we can't continue */
        if (link) 
          {
            if (OPTION_ENABLED (option, DUP))
              {
                if (!OPTION_ENABLED (option, SWITCH))
                  {
                    report_error ("turning on -S option.\n");
                    SET_OPTION (option, SWITCH);
                  }
                report_error ("Some input keys have identical hash values, examine output carefully...\n");
              }
            else
              report_error ("Some input keys have identical hash values,\ntry different key positions or use option -D.\n%a");
          }
        else if (OPTION_ENABLED (option, DUP))
          {
            /* If no links, clear the DUP option so we can use the length
              table, if output. */
            UNSET_OPTION (option, DUP);
          }
        
      }
    }
}

/* Recursively merges two sorted lists together to form one sorted list. The
   ordering criteria is by frequency of occurrence of elements in the key set
   or by the hash value.  This is a kludge, but permits nice sharing of
   almost identical code without incurring the overhead of a function
   call comparison. */
  
static 
LIST_NODE *merge (list1, list2)
     LIST_NODE *list1;
     LIST_NODE *list2;
{
  if (!list1)
    return list2;
  else if (!list2)
    return list1;
  else if (key_list.occurrence_sort && list1->occurrence < list2->occurrence
           || key_list.hash_sort && list1->hash_value > list2->hash_value)
    {
      list2->next = merge (list2->next, list1);
      return list2;
    }
  else
    {
      list1->next = merge (list1->next, list2);
      return list1;
    }
}

/* Applies the merge sort algorithm to recursively sort the key list by
   frequency of occurrence of elements in the key set. */
  
static 
LIST_NODE *merge_sort (head)
     LIST_NODE *head;
{ 
  if (!head || !head->next)
    return head;
  else
    {
      LIST_NODE *middle = head;
      LIST_NODE *temp   = head->next->next;
    
      while (temp)
        {
          temp   = temp->next;
          middle = middle->next;
          if (temp)
            temp = temp->next;
        } 
    
      temp         = middle->next;
      middle->next = NULL;
      return merge (merge_sort (head), merge_sort (temp));
    }   
}

/* Returns the frequency of occurrence of elements in the key set. */

static int 
get_occurrence (ptr)
     LIST_NODE *ptr;
{
  int   value = 0;
  char *temp;

  for (temp = ptr->key_set; *temp; temp++)
    value += occurrences[*temp];
  
  return value;
}

/* Enables the index location of all key set elements that are now 
   determined. */
  
static void 
set_determined (ptr)
     LIST_NODE *ptr;
{
  char *temp;
  
  for (temp = ptr->key_set; *temp; temp++)
    determined[*temp] = TRUE;
  
}

/* Returns TRUE if PTR's key set is already completely determined. */

static bool 
already_determined (ptr)
     LIST_NODE *ptr;
{
  bool  is_determined = TRUE;
  char *temp;

  for (temp = ptr->key_set; is_determined && *temp; temp++)
    is_determined = determined[*temp];
  
  return is_determined;
}

/* Reorders the table by first sorting the list so that frequently occuring 
   keys appear first, and then the list is reorded so that keys whose values 
   are already determined will be placed towards the front of the list.  This
   helps prune the search time by handling inevitable collisions early in the
   search process.  See Cichelli's paper from Jan 1980 JACM for details.... */

void 
reorder ()
{
  LIST_NODE *ptr;

  for (ptr = key_list.head; ptr; ptr = ptr->next)
    ptr->occurrence = get_occurrence (ptr);
  
  key_list.hash_sort       = FALSE;
  key_list.occurrence_sort = TRUE;
  
  for (ptr = key_list.head = merge_sort (key_list.head); ptr->next; ptr = ptr->next)
    {
      set_determined (ptr);
    
      if (already_determined (ptr->next))
        continue;
      else
        {
          LIST_NODE *trail_ptr = ptr->next;
          LIST_NODE *run_ptr   = trail_ptr->next;
      
          for (; run_ptr; run_ptr = trail_ptr->next)
            {
        
              if (already_determined (run_ptr))
                {
                  trail_ptr->next = run_ptr->next;
                  run_ptr->next   = ptr->next;
                  ptr = ptr->next = run_ptr;
                }
              else
                trail_ptr = run_ptr;
            }
        }
    }     
}

/* Determines the maximum and minimum hash values.  One notable feature is 
   Ira Pohl's optimal algorithm to calculate both the maximum and minimum
   items in a list in O(3n/2) time (faster than the O (2n) method). 
   Returns the maximum hash value encountered. */
  
static int 
print_min_max ()
{
  int          min_hash_value;
  int          max_hash_value;
  LIST_NODE   *temp;
  
  if (ODD (key_list.list_len)) /* Pre-process first item, list now has an even length. */
    {              
      min_hash_value  = max_hash_value = key_list.head->hash_value;
      temp            = key_list.head->next;
    }
  else /* List is already even length, no extra work necessary. */
    {                      
      min_hash_value = MAX_INT;
      max_hash_value = NEG_MAX_INT;
      temp           = key_list.head;
    }
  
  for ( ; temp; temp = temp->next) /* Find max and min in optimal o(3n/2) time. */
    { 
      static int i;
      int key_2, key_1 = temp->hash_value;
      temp  = temp->next;
      key_2 = temp->hash_value;
      i++;
      
      if (key_1 < key_2)
        {
          if (key_1 < min_hash_value)
            min_hash_value = key_1;
          if (key_2 > max_hash_value)
            max_hash_value = key_2;
        }
      else
        {
          if (key_2 < min_hash_value)
            min_hash_value = key_2;
          if (key_1 > max_hash_value)
            max_hash_value = key_1;
        }
  }
  
  printf ("\n#define MIN_WORD_LENGTH %d\n#define MAX_WORD_LENGTH %d\
\n#define MIN_HASH_VALUE %d\n#define MAX_HASH_VALUE %d\
\n/*\n%5d keywords\n%5d is the maximum key range\n*/\n\n",
          key_list.min_key_len == MAX_INT ? key_list.max_key_len : key_list.min_key_len,
          key_list.max_key_len, min_hash_value, max_hash_value,
          key_list.total_keys, (max_hash_value - min_hash_value + 1));
  return max_hash_value;
}

/* Generates the output using a C switch.  This trades increased search
   time for decreased table space (potentially *much* less space for
   sparse tables). It the user has specified their own struct in the
   keyword file *and* they enable the POINTER option we have extra work to
   do.  The solution here is to maintain a local static array of user
   defined struct's, as with the Print_Lookup_Function.  Then we use for
   switch statements to perform a strcmp or strncmp, returning 0 if the str 
   fails to match, and otherwise returning a pointer to appropriate index
   location in the local static array. */

#ifdef sparc
#include <alloca.h>
#endif

static void 
print_switch ()
{
  char *comp_buffer;
  int   pointer_and_type_enabled = OPTION_ENABLED (option, POINTER) && OPTION_ENABLED (option, TYPE);

  if (pointer_and_type_enabled)
    {
      comp_buffer = (char *) alloca (strlen ("*str == *resword->%s && !strncmp (str + 1, resword->%s + 1, len - 1)"
                                             + 2 * strlen (GET_KEY_NAME (option)) + 1));
      sprintf (comp_buffer, OPTION_ENABLED (option, COMP)
               ? "*str == *resword->%s && !strncmp (str + 1, resword->%s + 1, len - 1)"
               : "*str == *resword->%s && !strcmp (str + 1, resword->%s + 1)", GET_KEY_NAME (option), GET_KEY_NAME (option));
    }
  else
    comp_buffer = OPTION_ENABLED (option, COMP) 
      ? "*str == *resword && !strncmp (str + 1, resword + 1, len - 1)" 
        : "*str == *resword && !strcmp (str + 1, resword + 1)";

  printf ("  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)\n    {\n\
      register int key = %s (str, len);\n\n\
      if (key <= MAX_HASH_VALUE && key >= MIN_HASH_VALUE)\n        {\n",
          GET_HASH_NAME (option));
  
  /* Output each keyword as part of a switch statement indexed by hash value. */
  
  if (OPTION_ENABLED (option, POINTER) || OPTION_ENABLED (option, DUP))
    {
      LIST_NODE *temp;

      printf ("          %s%s *resword; %s\n\n          switch (key)\n            {\n",
              OPTION_ENABLED (option, CONST) ? "const " : "",
              pointer_and_type_enabled ? key_list.struct_tag : "char", 
              OPTION_ENABLED (option, LENTABLE) && !OPTION_ENABLED (option, DUP) ? "int key_len;" : "");

      for (temp = key_list.head; temp; temp = temp->next)
        {
          printf ("            case %*d:\n", field_width, temp->hash_value);

          if (temp->link)
            {
              LIST_NODE *links;

              for (links = temp; links; links = links->link)
                {
                  if (pointer_and_type_enabled)
                    printf ("              resword = &wordlist[%d];\n", links->index);
                  else
                    printf ("              resword = \"%s\";\n", links->key); 
                  printf ("              if (%s) return resword;\n", comp_buffer);
                }
              printf ("              return 0;\n");
            }
          else if (temp->next && temp->hash_value == temp->next->hash_value)
            {

              for ( ; temp->next && temp->hash_value == temp->next->hash_value;
                   temp = temp->next)
                {
                  if (pointer_and_type_enabled)
                    printf ("              resword = &wordlist[%d];\n", temp->index);
                  else
                    printf ("              resword = \"%s\";\n", temp->key);
                  printf ("              if (%s) return resword;\n", comp_buffer);
                }
              if (pointer_and_type_enabled)
                printf ("              resword = &wordlist[%d];\n", temp->index);
              else
                printf ("              resword = \"%s\";\n", temp->key);
              printf ("              return %s ? resword : 0;\n", comp_buffer);
            }
          else 
            {
              if (pointer_and_type_enabled)
                printf ("              resword = &wordlist[%d];", temp->index);
              else 
                printf ("              resword = \"%s\";", temp->key);
              if (OPTION_ENABLED (option, LENTABLE) && !OPTION_ENABLED (option, DUP))
                printf (" key_len = %d;", temp->length);
              printf (" break;\n");
            }
        }
      printf ("            default: return 0;\n            }\n");
      printf (OPTION_ENABLED (option, LENTABLE) && !OPTION_ENABLED (option, DUP)
              ? "          if (len == key_len && %s)\n            return resword;\n"
              : "          if (%s)\n            return resword;\n", comp_buffer);
      printf ("      }\n  }\n  return 0;\n}\n");
    }
  else                          /* Nothing special required here. */
    {                        
      LIST_NODE *temp;

      printf ("          char *s = \"\";\n\n          switch (key)\n            {\n");
      
      for (temp = key_list.head; temp; temp = temp->next)
        if (OPTION_ENABLED (option, LENTABLE))
          printf ("            case %*d: if (len == %d) s = \"%s\"; else return 0; break;\n", 
                  field_width, temp->hash_value, temp->length, temp->key);
        else
          printf ("            case %*d: s = \"%s\"; break;\n",
                  field_width, temp->hash_value, temp->key);
                      
      printf ("            default: return 0;\n            }\n          return *s == *str && !%s;\n        }\n    }\n  return 0;\n}\n", 
              OPTION_ENABLED (option, COMP) ? "strncmp (s + 1, str + 1, len - 1)" : "strcmp (s + 1, str + 1)");
    }
}

/* Prints out a table of keyword lengths, for use with the 
   comparison code in generated function ``in_word_set.'' */

static void 
print_keylength_table ()
{
  int        max_column = 15;
  int        index      = 0;
  int        column     = 0;
  char      *indent     = OPTION_ENABLED (option, GLOBAL) ? "" : "  ";
  LIST_NODE *temp;

  if (!OPTION_ENABLED (option, DUP) && !OPTION_ENABLED (option, SWITCH)) 
    {
      printf ("\n%sstatic %sunsigned %s lengthtable[] =\n%s%s{\n    ",
              indent, OPTION_ENABLED (option, CONST) ? "const " : "",
              key_list.max_key_len < 256 ? "char" :
              (key_list.max_key_len < 65536 ? "short" : "long"),
              indent, indent);
  
      for (temp = key_list.head; temp; temp = temp->next, index++)
        {
    
          if (index < temp->hash_value)
            {
      
              for ( ; index < temp->hash_value; index++)
                printf ("%3d%s", 0, ++column % (max_column - 1) ? "," : ",\n    ");
            }
    
          printf ("%3d%s", temp->length, ++column % (max_column - 1 ) ? "," : ",\n    ");
        }
  
      printf ("\n%s%s};\n\n", indent, indent);
    }
}

/* Prints out the array containing the key words for the Perfect
   hash function. */
  
static void 
print_keyword_table ()
{
  char      *l_brace      = *key_list.head->rest ? "{" : "";
  char      *r_brace      = *key_list.head->rest ? "}," : "";
  int        doing_switch = OPTION_ENABLED (option, SWITCH);
  char      *indent       = OPTION_ENABLED (option, GLOBAL) ? "" : "  ";
  int        index        = 0;
  LIST_NODE *temp;

  printf ("\n%sstatic %s%s wordlist[] =\n%s%s{\n", 
          indent, OPTION_ENABLED (option, CONST) ? "const " : "",
          key_list.struct_tag, indent, indent);
  
  /* Generate an array of reserved words at appropriate locations. */
  
	for (temp = key_list.head; temp; temp = temp->next, index++)
		{
			temp->index = index;

			if (!doing_switch && index < temp->hash_value)
				{
					int column;

					printf ("      ");
      
					for (column = 1; index < temp->hash_value; index++, column++)
						printf ("%s\"\",%s %s", l_brace, r_brace, column % 9 ? "" : "\n      ");
      
					if (column % 10)
						printf ("\n");
					else 
						{
							printf ("%s\"%s\", %s%s\n", l_brace, temp->key, temp->rest, r_brace);
							continue;
						}
				}

			printf ("      %s\"%s\", %s%s\n", l_brace, temp->key, temp->rest, r_brace);

			/* Deal with links specially. */
			if (temp->link)
				{
					LIST_NODE *links;

					for (links = temp->link; links; links = links->link)
						{
							links->index = ++index;
							printf ("      %s\"%s\", %s%s\n", l_brace, links->key, links->rest, r_brace);
						}
				}

		}

  printf ("%s%s};\n\n", indent, indent);
}

/* Generates C code for the hash function that returns the
   proper encoding for each key word. */

static void 
print_hash_function (max_hash_value)
     int max_hash_value;
{
  int max_column = 10;
  int count       = max_hash_value;

  /* Calculate maximum number of digits required for MAX_HASH_VALUE. */

  while ((count /= 10) > 0)
    field_width++;

  if (OPTION_ENABLED (option, GNU))
    printf ("#ifdef __GNUC__\ninline\n#endif\n");
  
  printf (OPTION_ENABLED (option, ANSI) 
          ? "static int\n%s (register const char *str, register int len)\n{\n  static %sunsigned %s hash_table[] =\n    {"
          : "static int\n%s (str, len)\n     register char *str;\n     register unsigned int  len;\n{\n  static %sunsigned %s hash_table[] =\n    {",
          GET_HASH_NAME (option), OPTION_ENABLED (option, CONST) ? "const " : "",
          max_hash_value < 256 ? "char" : (max_hash_value < 65536 ? "short" : "int"));
  
  for (count = 0; count < ALPHABET_SIZE; ++count)
    {
      if (!(count % max_column))
        printf ("\n    ");
      
      printf ("%*d,", field_width, occurrences[count] ? asso_values[count] : max_hash_value);
    }
  
  /* Optimize special case of ``-k 1,$'' */
  if (OPTION_ENABLED (option, DEFAULTCHARS)) 
    printf ("\n    };\n  return %s + hash_table[str[len - 1]] + hash_table[str[0]];\n}\n\n",
            OPTION_ENABLED (option, NOLENGTH) ? "0" : "len");
  else
    {
      int key_pos;

      RESET (option);

      /* Get first (also highest) key position. */
      key_pos = GET (option); 
      
      /* We can perform additional optimizations here. */
      if (!OPTION_ENABLED (option, ALLCHARS) && key_pos <= key_list.min_key_len) 
        { 
          printf ("\n  };\n  return %s", OPTION_ENABLED (option, NOLENGTH) ? "0" : "len");
          
          for ( ; key_pos != EOS && key_pos != WORD_END; key_pos = GET (option))
            printf (" + hash_table[str[%d]]", key_pos - 1);
           
          printf ("%s;\n}\n\n", key_pos == WORD_END ? " + hash_table[str[len - 1]]" : "");
        }

      /* We've got to use the correct, but brute force, technique. */
      else 
        {                    
          printf ("\n    };\n  register int hval = %s ;\n\n  switch (%s)\n    {\n      default:\n",
                  OPTION_ENABLED (option, NOLENGTH) ? "0" : "len", OPTION_ENABLED (option, NOLENGTH) ? "len" : "hval");
          
          /* User wants *all* characters considered in hash. */
          if (OPTION_ENABLED (option, ALLCHARS)) 
            { 
              int i;

              for (i = key_list.max_key_len; i > 0; i--)
                printf ("      case %d:\n        hval += hash_table[str[%d]];\n", i, i - 1);
              
              printf ("    }\n  return hval;\n}\n\n");
            }
          else /* do the hard part... */
            {                
              count = key_pos + 1;
              
              do
                {
                  
                  while (--count > key_pos)
                    printf ("      case %d:\n", count);
                  
                  printf ("      case %d:\n        hval += hash_table[str[%d]];\n", key_pos, key_pos - 1);
                }
              while ((key_pos = GET (option)) != EOS && key_pos != WORD_END);
              
              printf ("    }\n  return hval%s ;\n}\n\n", key_pos == WORD_END ? " + hash_table[str[len - 1]]" : "");
          }
      }
  }
}

/* Generates C code to perform the keyword lookup. */

static void 
print_lookup_function ()
{ 
  printf ("  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)\n    {\n\
      register int key = %s (str, len);\n\n\
      if (key <= MAX_HASH_VALUE && key >= MIN_HASH_VALUE)\n        {\n\
          register %schar *s = wordlist[key]", 
          GET_HASH_NAME (option), OPTION_ENABLED (option, CONST) ? "const " : "");
  if (key_list.array_type != default_array_type)
    printf (".%s", GET_KEY_NAME (option));

  printf (";\n\n          if (%s*s == *str && !%s)\n            return %s",
          OPTION_ENABLED (option, LENTABLE) ? "len == lengthtable[key]\n              && " : "",
          OPTION_ENABLED (option, COMP) ? "strncmp (str + 1, s + 1, len - 1)" : "strcmp (str + 1, s + 1)",
          OPTION_ENABLED (option, TYPE) && OPTION_ENABLED (option, POINTER) ? "&wordlist[key]" : "s");
  printf (";\n        }\n    }\n  return 0;\n}\n");
}

/* Generates the hash function and the key word recognizer function
   based upon the user's Options. */

void 
print_output ()
{
  int global_table = OPTION_ENABLED (option, GLOBAL);

  printf ("/* C code produced by gperf version %s */\n", version_string);
  print_options ();
  
  printf ("%s\n", key_list.include_src);
  
  /* Potentially output type declaration now, reference it later on.... */
  if (OPTION_ENABLED (option, TYPE) && !OPTION_ENABLED (option, NOTYPE)) 
    printf ("%s;\n", key_list.array_type);
  
  print_hash_function (print_min_max ());
  
  if (global_table)
    if (OPTION_ENABLED (option, SWITCH))
      {
        if (OPTION_ENABLED (option, LENTABLE) && OPTION_ENABLED (option, DUP))
          print_keylength_table ();
        if (OPTION_ENABLED (option, POINTER) && OPTION_ENABLED (option, TYPE))
          print_keyword_table ();
      }
    else
      {
        if (OPTION_ENABLED (option, LENTABLE))
          print_keylength_table ();
        print_keyword_table ();
      }
  /* Use the inline keyword to remove function overhead. */
  if (OPTION_ENABLED (option, GNU)) 
    printf ("#ifdef __GNUC__\ninline\n#endif\n");
  
  /* Use ANSI function prototypes. */
  printf (OPTION_ENABLED (option, ANSI)
          ? "%s%s\n%s (register const char *str, register int len)\n{\n"
          : "%s%s\n%s (str, len)\n     register char *str;\n     register unsigned int len;\n{\n", 
            OPTION_ENABLED (option, CONST) ? "const " : "", 
            key_list.return_type, GET_FUNCTION_NAME (option));
  
  /* Use the switch in place of lookup table. */
  if (OPTION_ENABLED (option, SWITCH))
    {               
      if (!global_table)
        {
          if (OPTION_ENABLED (option, LENTABLE) && OPTION_ENABLED (option, DUP))
            print_keylength_table ();
          if (OPTION_ENABLED (option, POINTER) && OPTION_ENABLED (option, TYPE)) 
            print_keyword_table ();
        }
      print_switch ();
    }
  else                /* Use the lookup table, in place of switch. */
    {           
      if (!global_table)
        {
          if (OPTION_ENABLED (option, LENTABLE))
            print_keylength_table ();
          print_keyword_table ();
        }
      print_lookup_function ();
    }

  if (key_list.additional_code)
    {
      int c;

      while ((c = getchar ()) != EOF)
        putchar (c);
    }
}

/* Sorts the keys by hash value. */

void 
sort ()
{ 
  key_list.hash_sort       = TRUE;
  key_list.occurrence_sort = FALSE;
  
  key_list.head = merge_sort (key_list.head);
}

/* Dumps the key list to stderr stream. */

static void 
dump () 
{      
  LIST_NODE *ptr;

  report_error ("\nList contents are:\n(hash value, key length, index, key set, uniq set, key):\n");
  
  for (ptr = key_list.head; ptr; ptr = ptr->next)
    report_error ("      %d,      %d,     %d, %s, %s, %s\n",
                  ptr->hash_value, ptr->length, ptr->index,
                  ptr->key_set, ptr->uniq_set, ptr->key);
}

/* Simple-minded constructor action here... */

void
key_list_init ()
{   
  key_list.total_keys      = 1;
  key_list.max_key_len     = NEG_MAX_INT;
  key_list.min_key_len     = MAX_INT;
  key_list.return_type     = default_return_type;
  key_list.array_type      = key_list.struct_tag  = default_array_type;
  key_list.head            = NULL;
  key_list.additional_code = FALSE;
}

/* Returns the length of entire key list. */

int 
length () 
{ 
  return key_list.list_len;
}

/* Returns length of longest key read. */

int 
max_key_length ()
{ 
  return key_list.max_key_len;
}

/* DESTRUCTOR dumps diagnostics during debugging. */

void
key_list_destroy () 
{ 
  if (OPTION_ENABLED (option, DEBUG))
    {
      report_error ("\nDumping key list information:\ntotal unique keywords = %d\
\ntotal keywords = %d\nmaximum key length = %d.\n", 
                    key_list.list_len, key_list.total_keys, key_list.max_key_len);
      dump ();
      report_error ("End dumping list.\n\n");
    }
}

