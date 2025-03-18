#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of archive 1 (of 5)."
# Contents:  cperf cperf/Makefile cperf/README cperf/gperf.1 cperf/src
#   cperf/src/boolarray.c cperf/src/boolarray.h cperf/src/hashtable.h
#   cperf/src/iterator.c cperf/src/iterator.h cperf/src/keylist.h
#   cperf/src/listnode.h cperf/src/main.c cperf/src/perfect.h
#   cperf/src/prototype.h cperf/src/readline.c cperf/src/readline.h
#   cperf/src/stderr.c cperf/src/stderr.h cperf/src/version.c
#   cperf/src/xmalloc.c cperf/tests cperf/tests/Makefile
#   cperf/tests/ada.gperf cperf/tests/adapredefined.gperf
#   cperf/tests/c-parse.gperf cperf/tests/c.gperf
#   cperf/tests/gpc.gperf cperf/tests/gplus.gperf
#   cperf/tests/modula2.gperf cperf/tests/modula3.gperf
#   cperf/tests/pascal.gperf cperf/tests/test.c
# Wrapped by schmidt@crimee.ics.uci.edu on Wed Oct 18 11:43:31 1989
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test ! -d 'cperf' ; then
    echo shar: Creating directory \"'cperf'\"
    mkdir 'cperf'
fi
if test -f 'cperf/Makefile' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/Makefile'\"
else
echo shar: Extracting \"'cperf/Makefile'\" \(1304 characters\)
sed "s/^X//" >'cperf/Makefile' <<'END_OF_FILE'
X# Copyright (C) 1989 Free Software Foundation, Inc.
X# written by Douglas C. Schmidt (schmidt@ics.uci.edu)
X# 
X# This file is part of GNU GPERF.
X# 
X# GNU GPERF is free software; you can redistribute it and/or modify
X# it under the terms of the GNU General Public License as published by
X# the Free Software Foundation; either version 1, or (at your option)
X# any later version.
X# 
X# GNU GPERF is distributed in the hope that it will be useful,
X# but WITHOUT ANY WARRANTY; without even the implied warranty of
X# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
X# GNU General Public License for more details.
X# 
X# You should have received a copy of the GNU General Public License
X# along with GNU GPERF; see the file COPYING.  If not, write to
X# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
X
XGPERF = ../src/gperf
X
Xall: gperf tests
X
Xgperf: 
X	(cd src; $(MAKE))
X
Xtests: gperf
X	(cd tests; $(MAKE) GPERF=$(GPERF))
X
Xdistrib: 
X	(cd ..; rm -f cperf.tar.Z; tar cvf cperf.tar cperf; compress cperf.tar; uuencode cperf.tar.Z < cperf.tar.Z > CSHAR)
X
Xclean: 
X	(cd src; $(MAKE) clean)
X	(cd tests; $(MAKE) clean)
X
Xrealclean: 
X	(cd src; $(MAKE) realclean)
X	(cd tests; $(MAKE) clean)
X	-rm -f gperf.info* gperf.?? gperf.??s gperf.log gperf.toc \
X          gperf.*aux *inset.c *out gperf
END_OF_FILE
if test 1304 -ne `wc -c <'cperf/Makefile'`; then
    echo shar: \"'cperf/Makefile'\" unpacked with wrong size!
fi
# end of 'cperf/Makefile'
fi
if test -f 'cperf/README' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/README'\"
else
echo shar: Extracting \"'cperf/README'\" \(1174 characters\)
sed "s/^X//" >'cperf/README' <<'END_OF_FILE'
XWhile teaching a data structures course at University of California,
XIrvine, I developed a program called GPERF that generates perfect hash
Xfunctions for sets of key words.  A perfect hash function is simply:
X 
X          A hash function and a data structure that allows
X          recognition of a key word in a set of words using
X          exactly 1 probe into the data structure.
X 
XThe gperf.texinfo file explains how the program works, the form of the
Xinput, what options are available, and hints on choosing the best
Xoptions for particular key word sets.  The texinfo file is readable
Xboth via the GNU emacs `info' command, and is also suitable for
Xtypesetting with TeX.  The texinfo.tex macros needed to run 
Xgperf.texinfo through TeX are available in the GNU GCC release.  If 
Xyou don't have access to these please email me and I'll send them to
Xyou (about 75k).
X 
XThe enclosed Makefile creates the executable program ``gperf'' and
Xalso runs some tests.
X 
XOutput from the GPERF program is used to recognize reserved words in
Xthe GNU C, GNU C++, and GNU Pascal compilers, as well as with the GNU
Xindent program.
X 
XHappy hacking!
X 
XDouglas C. Schmidt
Xschmidt@ics.uci.edu
END_OF_FILE
if test 1174 -ne `wc -c <'cperf/README'`; then
    echo shar: \"'cperf/README'\" unpacked with wrong size!
fi
# end of 'cperf/README'
fi
if test -f 'cperf/gperf.1' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/gperf.1'\"
else
echo shar: Extracting \"'cperf/gperf.1'\" \(722 characters\)
sed "s/^X//" >'cperf/gperf.1' <<'END_OF_FILE'
X.TH GPERF 1 "December 16, 1988
X.UC 4
X.SH NAME
Xgperf \- generate a perfect hash function from a key set
X.SH SYNOPSIS
X.B gperf 
X[ 
X.B \-adghijklnoprsStv
X] [ 
X.I keyfile
X]
X.SH DESCRIPTION
X
X\fIgperf\fP reads a set of ``keys'' from \fIkeyfile\fP (or, by
Xdefault, from the standard input) and attempts to find a non-minimal
Xperfect hashing function that recognizes a member of the key set in
Xconstant, i.e., O(1), time.  If such a function is found the program
Xgenerates a pair of \fIC\fP source code routines that perform the
Xhashing and table lookup.  All generated code is directed to the
Xstandard output.
X
XPlease refer to the \fIgperf.texinfo\fP file for more information.
XThis file is distributed with \fIgperf\fP release.
END_OF_FILE
if test 722 -ne `wc -c <'cperf/gperf.1'`; then
    echo shar: \"'cperf/gperf.1'\" unpacked with wrong size!
fi
# end of 'cperf/gperf.1'
fi
if test ! -d 'cperf/src' ; then
    echo shar: Creating directory \"'cperf/src'\"
    mkdir 'cperf/src'
fi
if test -f 'cperf/src/boolarray.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/boolarray.c'\"
else
echo shar: Extracting \"'cperf/src/boolarray.c'\" \(2133 characters\)
sed "s/^X//" >'cperf/src/boolarray.c' <<'END_OF_FILE'
X/* Fast lookup table abstraction implemented as a Guilmette Array
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
X#include <stdio.h>
X#include "boolarray.h"
X#include "options.h"
X
X/* Locally visible BOOL_ARRAY object. */
X
Xstatic BOOL_ARRAY bool_array;
X
X/* Prints out debugging diagnostics. */
X
Xvoid
Xbool_array_destroy ()
X{
X  if (OPTION_ENABLED (option, DEBUG))
X    fprintf (stderr, "\ndumping boolean array information\nsize = %d\nend of array dump\n", 
X             bool_array.size);
X}
X
Xvoid
Xbool_array_init (size)
X     int size;
X{
X	int *xmalloc ();
X  bool_array.iteration_number = 1;
X  bool_array.size = size;
X  bool_array.storage_array = xmalloc (size * sizeof *bool_array.storage_array);
X  bzero (bool_array.storage_array, size * sizeof *bool_array.storage_array);
X}
X
Xbool 
Xlookup (index)
X     int index;
X{
X  if (bool_array.storage_array[index] == bool_array.iteration_number)
X    return 1;
X  else
X    {
X      bool_array.storage_array[index] = bool_array.iteration_number;
X      return 0;
X    }
X}
X
X/* Simple enough to reset, eh?! */
X
Xvoid 
Xbool_array_reset ()  
X{
X  /* If we wrap around it's time to zero things out again!
X     However, this only occurs once about every 2^31 iterations,
X     so it should probably never happen! */
X            
X  if (bool_array.iteration_number++ == 0)
X    bzero (bool_array.storage_array, bool_array.size * sizeof *bool_array.storage_array);
X}
END_OF_FILE
if test 2133 -ne `wc -c <'cperf/src/boolarray.c'`; then
    echo shar: \"'cperf/src/boolarray.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/boolarray.c'
fi
if test -f 'cperf/src/boolarray.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/boolarray.h'\"
else
echo shar: Extracting \"'cperf/src/boolarray.h'\" \(1552 characters\)
sed "s/^X//" >'cperf/src/boolarray.h' <<'END_OF_FILE'
X/* Simple lookup table abstraction implemented as a Guilmette Array.
X
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
X/* Define and implement a simple boolean array abstraction,
X   uses a Guilmette array implementation to save on initialization time. */ 
X
X#ifndef _boolarray_h
X#define _boolarray_h
X#include "prototype.h"
X
Xtypedef struct bool_array 
X{
X  int *storage_array;           /* Initialization of the index space. */
X  int  iteration_number;        /* Keep track of the current iteration. */
X  int  size;                    /* Size of the entire array (dynamically initialized). */
X} BOOL_ARRAY;
X
Xextern void bool_array_init P ((int size));
Xextern void bool_array_destroy P ((void));
Xextern bool lookup P ((int hash_value));
Xextern void bool_array_reset P ((void));
X
X#endif /* _boolarray_h */
END_OF_FILE
if test 1552 -ne `wc -c <'cperf/src/boolarray.h'`; then
    echo shar: \"'cperf/src/boolarray.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/boolarray.h'
fi
if test -f 'cperf/src/hashtable.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/hashtable.h'\"
else
echo shar: Extracting \"'cperf/src/hashtable.h'\" \(1311 characters\)
sed "s/^X//" >'cperf/src/hashtable.h' <<'END_OF_FILE'
X/* Hash table used to check for duplicate keyword entries.
X
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
X#ifndef _hashtable_h
X#define _hashtable_h
X#include "keylist.h"
X#include "prototype.h"
X
Xtypedef struct hash_table 
X{
X  LIST_NODE **table; /* Vector of pointers to linked lists of List_Node's. */
X  int         size;  /* Size of the vector. */
X} HASH_TABLE;
X
Xextern void       hash_table_init P ((int size));
Xextern void       hash_table_destroy P ((void));
Xextern LIST_NODE *retrieve P ((LIST_NODE *item, int ignore_length));
X
X#endif /* _hashtable_h */
END_OF_FILE
if test 1311 -ne `wc -c <'cperf/src/hashtable.h'`; then
    echo shar: \"'cperf/src/hashtable.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/hashtable.h'
fi
if test -f 'cperf/src/iterator.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/iterator.c'\"
else
echo shar: Extracting \"'cperf/src/iterator.c'\" \(3043 characters\)
sed "s/^X//" >'cperf/src/iterator.c' <<'END_OF_FILE'
X/* Provides an Iterator for keyword characters.
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
X#include <stdio.h>
X#include <ctype.h>
X#include "iterator.h"
X
X/* Locally visible ITERATOR object. */
X
XITERATOR iterator;
X
X/* Constructor for ITERATOR. */
X
Xvoid
Xiterator_init (s, lo, hi, word_end, bad_val, key_end)
X     char *s;
X     int lo;
X     int hi;
X     int word_end;
X     int bad_val;
X     int key_end;
X{
X  iterator.end         = key_end;
X  iterator.error_value = bad_val;
X  iterator.end_word    = word_end;
X  iterator.str         = s;
X  iterator.hi_bound    = hi;
X  iterator.lo_bound    = lo;
X}
X
X/* Define several useful macros to clarify subsequent code. */
X#define ISPOSDIGIT(X) ((X)<='9'&&(X)>'0')
X#define TODIGIT(X) ((X)-'0')
X
X/* Provide an Iterator, returning the ``next'' value from 
X   the list of valid values given in the constructor. */
X
Xint 
Xnext ()
X{ 
X/* Variables to record the Iterator's status when handling ranges, e.g., 3-12. */
X
X  static int size;              
X  static int curr_value;           
X  static int upper_bound;
X
X  if (size) 
X    { 
X      if (++curr_value >= upper_bound) 
X        size = 0;    
X      return curr_value; 
X    }
X  else 
X    {
X      while (*iterator.str) 
X        {
X          if (*iterator.str == ',') 
X            iterator.str++;
X          else if (*iterator.str == '$') 
X            {
X              iterator.str++;
X              return iterator.end_word;
X            }
X          else if (ISPOSDIGIT (*iterator.str))
X            {
X
X              for (curr_value = 0; isdigit (*iterator.str); iterator.str++) 
X                curr_value = curr_value * 10 + *iterator.str - '0';
X
X              if (*iterator.str == '-') 
X                {
X
X                  for (size = 1, upper_bound = 0; 
X                       isdigit (*++iterator.str); 
X                       upper_bound = upper_bound * 10 + *iterator.str - '0');
X
X                  if (upper_bound <= curr_value || upper_bound > iterator.hi_bound) 
X                    return iterator.error_value;
X                }
X              return curr_value >= iterator.lo_bound && curr_value <= iterator.hi_bound 
X                ? curr_value : iterator.error_value;
X            }
X          else
X            return iterator.error_value;               
X        }
X
X      return iterator.end;
X    }
X}
END_OF_FILE
if test 3043 -ne `wc -c <'cperf/src/iterator.c'`; then
    echo shar: \"'cperf/src/iterator.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/iterator.c'
fi
if test -f 'cperf/src/iterator.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/iterator.h'\"
else
echo shar: Extracting \"'cperf/src/iterator.h'\" \(2165 characters\)
sed "s/^X//" >'cperf/src/iterator.h' <<'END_OF_FILE'
X/* Provides an Iterator for keyword characters.
X
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
X/* Provides an Iterator that expands and decodes a control string containing digits
X   and ranges, returning an integer every time the generator function is called.
X   This is used to decode the user's key position requests.  For example:
X   "-k 1,2,5-10,$"  will return 1, 2, 5, 6, 7, 8, 9, 10, and 0 ( representing
X   the abstract ``last character of the key'' on successive calls to the
X   member function operator ().
X   No errors are handled in these routines, they are passed back to the
X   calling routines via a user-supplied Error_Value */
X
X#ifndef _iterator_h
X#define _iterator_h
X#include "prototype.h"
X
Xtypedef struct iterator 
X{
X  char *str;                    /* A pointer to the string provided by the user. */
X  int   end;                    /* Value returned after last key is processed. */
X  int   end_word;               /* A value marking the abstract ``end of word'' ( usually '$'). */
X  int   error_value;            /* Error value returned when input is syntactically erroneous. */
X  int   hi_bound;               /* Greatest possible value, inclusive. */
X  int   lo_bound;               /* Smallest possible value, inclusive. */
X} ITERATOR;
X
Xextern void iterator_init P ((char *s, int lo, int hi, int word_end, int bad_val, int key_end));
Xextern int  next P ((void));
X#endif /* _iterator_h */
END_OF_FILE
if test 2165 -ne `wc -c <'cperf/src/iterator.h'`; then
    echo shar: \"'cperf/src/iterator.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/iterator.h'
fi
if test -f 'cperf/src/keylist.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/keylist.h'\"
else
echo shar: Extracting \"'cperf/src/keylist.h'\" \(2381 characters\)
sed "s/^X//" >'cperf/src/keylist.h' <<'END_OF_FILE'
X/* Data and function member declarations for the keyword list class.
X
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
X/* The key word list is a useful abstraction that keeps track of
X   various pieces of information that enable that fast generation
X   of the Perfect.hash function.  A Key_List is a singly-linked
X   list of List_Nodes. */
X
X#ifndef _keylist_h
X#define _keylist_h
X#include <stdio.h>
X#include "listnode.h"
X
Xtypedef struct key_list
X{
X  LIST_NODE *head;                  /* Points to the head of the linked list. */
X  char      *array_type;            /* Pointer to the type for word list. */
X  char      *return_type;           /* Pointer to return type for lookup function. */
X  char      *struct_tag;            /* Shorthand for user-defined struct tag type. */
X  char      *include_src;           /* C source code to be included verbatim. */
X  int        list_len;              /* Length of head's Key_List, not counting duplicates. */
X  int        total_keys;            /* Total number of keys, counting duplicates. */
X  int        max_key_len;           /* Maximum length of the longest keyword. */
X  int        min_key_len;           /* Minimum length of the shortest keyword. */
X  bool       occurrence_sort;       /* True if sorting by occurrence. */
X  bool       hash_sort;             /* True if sorting by hash value. */
X  bool       additional_code;       /* True if any additional C code is included. */
X} KEY_LIST;
X
Xextern void       key_list_init P ((void));
Xextern void       key_list_destroy P ((void));
Xextern void       print_output P ((void));
Xextern KEY_LIST   key_list;
X#endif /* _keylist_h */
END_OF_FILE
if test 2381 -ne `wc -c <'cperf/src/keylist.h'`; then
    echo shar: \"'cperf/src/keylist.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/keylist.h'
fi
if test -f 'cperf/src/listnode.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/listnode.h'\"
else
echo shar: Extracting \"'cperf/src/listnode.h'\" \(1852 characters\)
sed "s/^X//" >'cperf/src/listnode.h' <<'END_OF_FILE'
X/* Data and function members for defining values and operations of a list node.
X
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
X#ifndef _listnode_h
X#define _listnode_h
X#include "prototype.h"
X
X#define ALPHABET_SIZE 128
X
Xtypedef struct list_node 
X{ 
X  char      *key;               /* Key string. */
X  char      *rest;              /* Additional information for building hash function. */
X  char      *key_set;           /* Set of characters to hash, specified by user. */
X  char      *uniq_set;          /* The unique set of the previous characters. */
X  int        length;            /* Length of the key. */
X  int        hash_value;        /* Hash value for the key. */
X  int        occurrence;        /* A metric for frequency of key set occurrences. */
X  int        index;             /* Position of this node relative to other nodes. */
X  struct list_node *link;       /* TRUE if key has an identical KEY_SET as another key. */
X  struct list_node *next;       /* Points to next element on the list. */  
X} LIST_NODE;
X
Xextern LIST_NODE *make_list_node P ((char *k, int len));
X
X#endif _listnode_h
END_OF_FILE
if test 1852 -ne `wc -c <'cperf/src/listnode.h'`; then
    echo shar: \"'cperf/src/listnode.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/listnode.h'
fi
if test -f 'cperf/src/main.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/main.c'\"
else
echo shar: Extracting \"'cperf/src/main.c'\" \(2091 characters\)
sed "s/^X//" >'cperf/src/main.c' <<'END_OF_FILE'
X/* Driver program for the Perfect hash function generator.
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
X/* Simple driver program for the Perfect.hash function generator.
X   Most of the hard work is done in class Perfect and its class methods. */
X
X#include <stdio.h>
X#include "stderr.h"
X#include "options.h"
X#include "perfect.h"
X
X/* Calls the appropriate intialization routines for each
X   ADT.  Note that certain initialization routines require
X   initialization *after* certain values are computed.  Therefore,
X   they cannot be called here. */
X   
Xstatic void 
Xinit_all (argc, argv)
X     int argc;
X     char *argv[];
X{
X  options_init (argc, argv);    
X  key_list_init ();
X  perfect_init ();              
X}
X
X/* Calls appropriate destruction routines for each ADT.  These
X   routines print diagnostics if the debugging option is enabled. */
X
Xstatic void
Xdestroy_all ()
X{
X  options_destroy ();
X  bool_array_destroy ();
X  hash_table_destroy ();
X  key_list_destroy ();
X  perfect_destroy ();
X}
X
X/* Driver for perfect hash function generation. */
X
Xint
Xmain (argc, argv)
X     int argc;
X     char *argv[];
X{
X  int status;
X  
X  /* Sets the options. */
X  init_all (argc, argv);
X
X  /* Generates the perfect hash table.
X     Also prints generated code neatly to the output. */
X  status = perfect_generate ();
X  destroy_all ();
X  return status;
X}
END_OF_FILE
if test 2091 -ne `wc -c <'cperf/src/main.c'`; then
    echo shar: \"'cperf/src/main.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/main.c'
fi
if test -f 'cperf/src/perfect.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/perfect.h'\"
else
echo shar: Extracting \"'cperf/src/perfect.h'\" \(1717 characters\)
sed "s/^X//" >'cperf/src/perfect.h' <<'END_OF_FILE'
X/* Provides high-level routines to manipulate the keywork list 
X   structures the code generation output. 
X
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
X#ifndef _perfect_h
X#define _perfect_h
X
X#include "prototype.h"
X#include "keylist.h"
X#include "boolarray.h"
X
Xtypedef struct perfect
X{
X  KEY_LIST   list;              /* List of key words provided by the user. */
X  BOOL_ARRAY duplicate;         /* Speeds up check for redundant hash values. */
X  int        max_hash_value;    /* Maximum possible hash value. */
X  int        fewest_hits;       /* Records fewest # of collisions for asso value. */
X  int        best_char_choice;  /* Best (but not optimal) char index found so far. */
X  int        best_asso_value;   /* Best (but not optimal) asso value found so far. */
X} PERFECT;
X
Xextern void perfect_init P ((void));
Xextern void perfect_destroy P ((void));
Xextern int  perfect_generate P ((void));
Xextern void perfect_print P ((void));
X#endif /* _perfect_h */
X
X
END_OF_FILE
if test 1717 -ne `wc -c <'cperf/src/perfect.h'`; then
    echo shar: \"'cperf/src/perfect.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/perfect.h'
fi
if test -f 'cperf/src/prototype.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/prototype.h'\"
else
echo shar: Extracting \"'cperf/src/prototype.h'\" \(234 characters\)
sed "s/^X//" >'cperf/src/prototype.h' <<'END_OF_FILE'
X#ifndef _prototype_h
X#define _prototype_h
X#ifdef __STDC__
X#define P(X) X
X#else
X#define P(X) ()
X#endif
X
Xtypedef char bool;
X#define FALSE 0
X#define TRUE 1
X
X#define ODD(X) ((X) & 1)
X#define EVEN(X) (!((X) & 1))
X#endif /* _prototype_h */
END_OF_FILE
if test 234 -ne `wc -c <'cperf/src/prototype.h'`; then
    echo shar: \"'cperf/src/prototype.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/prototype.h'
fi
if test -f 'cperf/src/readline.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/readline.c'\"
else
echo shar: Extracting \"'cperf/src/readline.c'\" \(2060 characters\)
sed "s/^X//" >'cperf/src/readline.c' <<'END_OF_FILE'
X/* Correctly reads an arbitrarily size string.
X
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
X#include <stdio.h>
X#include "readline.h"
X
X/* Size of each chunk. */
X#define CHUNK_SIZE BUFSIZ
X
X/* Recursively fills up the buffer. */
X
Xstatic char *
Xreadln_aux (chunks) 
X     int chunks;
X{
X  char buf[CHUNK_SIZE];
X  register char *bufptr = buf;
X  register char *ptr;
X  int c;
X
X  while ((c = getchar ()) != EOF && c != '\n') /* fill the current buffer */
X    {
X      *bufptr++ = c;
X      if (bufptr - buf >= CHUNK_SIZE) /* prepend remainder to ptr buffer */
X        {
X          if (ptr = readln_aux (chunks + 1))
X
X            for (; bufptr != buf; *--ptr = *--bufptr);
X
X          return ptr;
X        }
X    }
X
X  if (c == EOF && bufptr == buf)
X    return NULL;
X
X  c = (chunks * CHUNK_SIZE + bufptr - buf) + 1;
X
X  if (ptr = (char *) xmalloc (c))
X    {
X
X      for (*(ptr += (c - 1)) = '\0'; bufptr != buf; *--ptr = *--bufptr)
X        ;
X
X      return ptr;
X    } 
X  else 
X    return NULL;
X}
X
X/* Returns the ``next'' line, ignoring comments beginning with '#'. */
X
Xchar *read_line () 
X{
X  int c;
X  if ((c = getchar ()) == '#')
X    {
X      while ((c = getchar ()) != '\n' && c != EOF)
X        ;
X
X      return c != EOF ? read_line () : NULL;
X    }
X  else
X    {
X      ungetc (c, stdin);
X      return readln_aux (0);
X    }
X}
END_OF_FILE
if test 2060 -ne `wc -c <'cperf/src/readline.c'`; then
    echo shar: \"'cperf/src/readline.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/readline.c'
fi
if test -f 'cperf/src/readline.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/readline.h'\"
else
echo shar: Extracting \"'cperf/src/readline.h'\" \(1160 characters\)
sed "s/^X//" >'cperf/src/readline.h' <<'END_OF_FILE'
X/* Reads arbitrarily long string from input file, returning it as a dynamic buffer. 
X
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
X/* Returns a pointer to an arbitrary length string.  Returns NULL on error or EOF
X   The storage for the string is dynamically allocated by new. */
X
X#ifndef _readline_h
X#define _readline_h
X#include "prototype.h"
X
Xextern char *read_line P ((void));
X#endif /* _readline_h */
X
END_OF_FILE
if test 1160 -ne `wc -c <'cperf/src/readline.h'`; then
    echo shar: \"'cperf/src/readline.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/readline.h'
fi
if test -f 'cperf/src/stderr.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/stderr.c'\"
else
echo shar: Extracting \"'cperf/src/stderr.c'\" \(2831 characters\)
sed "s/^X//" >'cperf/src/stderr.c' <<'END_OF_FILE'
X/* Provides a useful variable-length argument error handling abstraction.
X
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
X#include <stdio.h>
X#include "stderr.h"
X
X/* Holds the name of the currently active program. */
Xstatic char *program_name;
X
X/* Sets name of program. */
X
Xvoid 
Xset_program_name (prog_name)
X     char *prog_name;
X{ 
X  program_name = prog_name;
X}
X
X/* Valid Options (prefixed by '%', as in printf format strings) include:
X   'a': exit the program at this point
X   'c': print a character
X   'd': print a decimal number
X   'e': call the function pointed to by the corresponding argument
X   'f','g': print a double
X   'n': print the name of the program (NULL if not set in constructor or elsewhere)
X   'p': print out the appropriate errno value from sys_errlist
X   's': print out a character string
X   '%': print out a single percent sign, '%' */
X
Xvoid 
Xreport_error (va_alist) 
X     va_dcl
X{
X  extern int errno, sys_nerr;
X  extern char *sys_errlist[];
X  typedef void (*PTF)();
X	typedef char *CHARP;
X  va_list argp;
X  int     abort = 0;
X  char   *format;
X
X  va_start (argp);
X
X  for (format = va_arg (argp, char *); *format; format++) 
X    {
X      if (*format != '%') 
X        putc (*format, stderr);
X      else 
X        {
X          switch(*++format) 
X            {
X            case 'a' : abort = 1; break;
X            case 'c' : putc (va_arg (argp, int), stderr); break;
X            case 'd' : fprintf (stderr, "%d", va_arg (argp, int)); break;
X            case 'e' : (*va_arg (argp, PTF))(); break;
X            case 'f' : fprintf (stderr, "%g", va_arg (argp, double)); break;
X            case 'n' : fputs (program_name ? program_name : "error", stderr); break;
X            case 'p' : 
X              if (errno < sys_nerr) 
X                fprintf (stderr, "%s: %s", va_arg (argp, CHARP), sys_errlist[errno]);
X              else 
X                fprintf (stderr, "<unknown error> %d", errno);
X              break;
X            case 's' : fputs (va_arg (argp, CHARP), stderr); break;
X            }
X        }
X      if (abort) 
X        exit (1);
X    }
X  va_end (argp);
X}
END_OF_FILE
if test 2831 -ne `wc -c <'cperf/src/stderr.c'`; then
    echo shar: \"'cperf/src/stderr.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/stderr.c'
fi
if test -f 'cperf/src/stderr.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/stderr.h'\"
else
echo shar: Extracting \"'cperf/src/stderr.h'\" \(1060 characters\)
sed "s/^X//" >'cperf/src/stderr.h' <<'END_OF_FILE'
X/* Provides a useful variable-length argument error handling abstraction.
X
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
X#ifndef _stderr_h
X#define _stderr_h
X#include "prototype.h"
X#include <varargs.h>
X
Xextern void set_program_name P ((char *prog_name));
Xextern void report_error ();
X#endif /* _stderr_h */
END_OF_FILE
if test 1060 -ne `wc -c <'cperf/src/stderr.h'`; then
    echo shar: \"'cperf/src/stderr.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/stderr.h'
fi
if test -f 'cperf/src/version.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/version.c'\"
else
echo shar: Extracting \"'cperf/src/version.c'\" \(884 characters\)
sed "s/^X//" >'cperf/src/version.c' <<'END_OF_FILE'
X/* Current program version number.
X
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
Xchar *version_string = "1.9.1 (K&R C version)";
END_OF_FILE
if test 884 -ne `wc -c <'cperf/src/version.c'`; then
    echo shar: \"'cperf/src/version.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/version.c'
fi
if test -f 'cperf/src/xmalloc.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/xmalloc.c'\"
else
echo shar: Extracting \"'cperf/src/xmalloc.c'\" \(1071 characters\)
sed "s/^X//" >'cperf/src/xmalloc.c' <<'END_OF_FILE'
X/* Provide a useful malloc sanity checker....
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
X#include <stdio.h>
X
Xchar *
Xxmalloc (size)
X     int size;
X{
X  char *malloc ();
X  char *temp = malloc (size);
X  
X  if (temp == 0)
X    {
X      fprintf (stderr, "out of virtual memory\n");
X      exit (1);
X    }
X  return temp;
X}
X
END_OF_FILE
if test 1071 -ne `wc -c <'cperf/src/xmalloc.c'`; then
    echo shar: \"'cperf/src/xmalloc.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/xmalloc.c'
fi
if test ! -d 'cperf/tests' ; then
    echo shar: Creating directory \"'cperf/tests'\"
    mkdir 'cperf/tests'
fi
if test -f 'cperf/tests/Makefile' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/Makefile'\"
else
echo shar: Extracting \"'cperf/tests/Makefile'\" \(2485 characters\)
sed "s/^X//" >'cperf/tests/Makefile' <<'END_OF_FILE'
X# Copyright (C) 1989 Free Software Foundation, Inc.
X# written by Douglas C. Schmidt (schmidt@ics.uci.edu)
X# 
X# This file is part of GNU GPERF.
X# 
X# GNU GPERF is free software; you can redistribute it and/or modify
X# it under the terms of the GNU General Public License as published by
X# the Free Software Foundation; either version 1, or (at your option)
X# any later version.
X# 
X# GNU GPERF is distributed in the hope that it will be useful,
X# but WITHOUT ANY WARRANTY; without even the implied warranty of
X# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
X# GNU General Public License for more details.
X# 
X# You should have received a copy of the GNU General Public License
X# along with GNU GPERF; see the file COPYING.  If not, write to
X# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
X
XGPERF = gperf
XCC = gcc
X
Xall: test
X
Xtest:
X	@echo "performing some tests of the perfect hash generator"   
X	$(CC) -c -O test.c
X	$(GPERF) -p -c -l -S -C -o c.gperf > cinset.c
X	$(CC) -O -o cout cinset.c test.o
X	@echo "testing ANSI C reserved words, all items should be found in the set"
X	./cout -v < c.gperf 
X	$(GPERF) -k1,4,'$$' ada.gperf > adainset.c
X# double '$$' is only there since make gets confused; program wants only 1 '$'
X	$(CC) -O -o aout adainset.c test.o
X	@echo "testing Ada reserved words,all items should be found in the set"
X	./aout -v < ada.gperf 
X	$(GPERF) -p -D -k1,'$$' -s 2 -o adapredefined.gperf > preinset.c
X	$(CC) -O -o preout preinset.c test.o
X	@echo "testing Ada predefined words, all items should be found in the set"
X	./preout -v < adapredefined.gperf 
X	$(GPERF) -k1,2,'$$' -o modula3.gperf > m3inset.c
X	$(CC) -O -o m3out m3inset.c test.o
X	@echo "testing Modula3 reserved words, all items should be found in the set"
X	./m3out -v < modula3.gperf 
X	$(GPERF) -o -S -p < pascal.gperf > pinset.c
X	$(CC) -O -o pout pinset.c test.o
X	@echo "testing Pascal reserved words, all items should be found in the set"
X	./pout -v < pascal.gperf 	
X# these next 5 are demos that show off the generated code
X	$(GPERF) -p -j1 -g -o -t -N is_reserved_word -k1,3,'$$' c-parse.gperf
X	$(GPERF) -n -k1-8 -l modula2.gperf 
X	$(GPERF) -p -j 1 -o -a -g -t -k1,4,$$ gplus.gperf 
X	$(GPERF) -D -p -t < c-parse.gperf 
X	$(GPERF) -g -o -j1 -t -p -N is_reserved_word gpc.gperf
X# prints out the help message
X	-$(GPERF) -h 
X	@echo "only if, do, for, case, goto, else, while, and return should be found "
X	./aout -v < c.gperf 
X
Xclean: 
X	-rm -f *.o core *~ *inset.c *out #*#
END_OF_FILE
if test 2485 -ne `wc -c <'cperf/tests/Makefile'`; then
    echo shar: \"'cperf/tests/Makefile'\" unpacked with wrong size!
fi
# end of 'cperf/tests/Makefile'
fi
if test -f 'cperf/tests/ada.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/ada.gperf'\"
else
echo shar: Extracting \"'cperf/tests/ada.gperf'\" \(366 characters\)
sed "s/^X//" >'cperf/tests/ada.gperf' <<'END_OF_FILE'
Xelse
Xexit
Xterminate
Xtype
Xraise
Xrange
Xreverse
Xdeclare
Xend
Xrecord
Xexception
Xnot
Xthen
Xreturn
Xseparate
Xselect
Xdigits
Xrenames
Xsubtype
Xelsif
Xfunction
Xfor
Xpackage
Xprocedure
Xprivate
Xwhile
Xwhen
Xnew
Xentry
Xdelay
Xcase
Xconstant
Xat
Xabort
Xaccept
Xand
Xdelta
Xaccess
Xabs
Xpragma
Xarray
Xuse
Xout
Xdo
Xothers
Xof
Xor
Xall
Xlimited
Xloop
Xnull
Xtask
Xin
Xis
Xif
Xrem
Xmod
Xbegin
Xbody
Xxor
Xgoto
Xgeneric
Xwith
END_OF_FILE
if test 366 -ne `wc -c <'cperf/tests/ada.gperf'`; then
    echo shar: \"'cperf/tests/ada.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/ada.gperf'
fi
if test -f 'cperf/tests/adapredefined.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/adapredefined.gperf'\"
else
echo shar: Extracting \"'cperf/tests/adapredefined.gperf'\" \(473 characters\)
sed "s/^X//" >'cperf/tests/adapredefined.gperf' <<'END_OF_FILE'
Xboolean
Xcharacter
Xconstraint_error
Xfalse
Xfloat
Xinteger
Xnatural
Xnumeric_error
Xpositive
Xprogram_error
Xstorage_error
Xstring
Xtasking_error
Xtrue
Xaddress
Xaft
Xbase
Xcallable
Xconstrained
Xcount
Xdelta
Xdigits
Xemax
Xepsilon
Xfirst
Xfirstbit
Xfore
Ximage
Xlarge
Xlast
Xlastbit
Xlength
Xmachine_emax
Xmachine_emin
Xmachine_mantissa
Xmachine_overflows
Xmachine_radix
Xmachine_rounds
Xmantissa
Xpos
Xposition
Xpred
Xrange
Xsafe_emax
Xsafe_large
Xsafe_small
Xsize
Xsmall
Xstorage_size
Xsucc
Xterminated
Xval
Xvalue
Xwidth
END_OF_FILE
if test 473 -ne `wc -c <'cperf/tests/adapredefined.gperf'`; then
    echo shar: \"'cperf/tests/adapredefined.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/adapredefined.gperf'
fi
if test -f 'cperf/tests/c-parse.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/c-parse.gperf'\"
else
echo shar: Extracting \"'cperf/tests/c-parse.gperf'\" \(1438 characters\)
sed "s/^X//" >'cperf/tests/c-parse.gperf' <<'END_OF_FILE'
X%{
X/* Command-line: gperf -p -j1 -g -o -t -N is_reserved_word -k1,3,$ c-parse.gperf  */
X%}
Xstruct resword { char *name; short token; enum rid rid; };
X%%
X__alignof, ALIGNOF, NORID
X__alignof__, ALIGNOF, NORID
X__asm, ASM, NORID
X__asm__, ASM, NORID
X__attribute, ATTRIBUTE, NORID
X__attribute__, ATTRIBUTE, NORID
X__const, TYPE_QUAL, RID_CONST
X__const__, TYPE_QUAL, RID_CONST
X__inline, SCSPEC, RID_INLINE
X__inline__, SCSPEC, RID_INLINE
X__signed, TYPESPEC, RID_SIGNED
X__signed__, TYPESPEC, RID_SIGNED
X__typeof, TYPEOF, NORID
X__typeof__, TYPEOF, NORID
X__volatile, TYPE_QUAL, RID_VOLATILE
X__volatile__, TYPE_QUAL, RID_VOLATILE
Xasm, ASM, NORID
Xauto, SCSPEC, RID_AUTO
Xbreak, BREAK, NORID
Xcase, CASE, NORID
Xchar, TYPESPEC, RID_CHAR
Xconst, TYPE_QUAL, RID_CONST
Xcontinue, CONTINUE, NORID
Xdefault, DEFAULT, NORID
Xdo, DO, NORID
Xdouble, TYPESPEC, RID_DOUBLE
Xelse, ELSE, NORID
Xenum, ENUM, NORID
Xextern, SCSPEC, RID_EXTERN
Xfloat, TYPESPEC, RID_FLOAT
Xfor, FOR, NORID
Xgoto, GOTO, NORID
Xif, IF, NORID
Xinline, SCSPEC, RID_INLINE
Xint, TYPESPEC, RID_INT
Xlong, TYPESPEC, RID_LONG
Xregister, SCSPEC, RID_REGISTER
Xreturn, RETURN, NORID
Xshort, TYPESPEC, RID_SHORT
Xsigned, TYPESPEC, RID_SIGNED
Xsizeof, SIZEOF, NORID
Xstatic, SCSPEC, RID_STATIC
Xstruct, STRUCT, NORID
Xswitch, SWITCH, NORID
Xtypedef, SCSPEC, RID_TYPEDEF
Xtypeof, TYPEOF, NORID
Xunion, UNION, NORID
Xunsigned, TYPESPEC, RID_UNSIGNED
Xvoid, TYPESPEC, RID_VOID
Xvolatile, TYPE_QUAL, RID_VOLATILE
Xwhile, WHILE, NORID
END_OF_FILE
if test 1438 -ne `wc -c <'cperf/tests/c-parse.gperf'`; then
    echo shar: \"'cperf/tests/c-parse.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/c-parse.gperf'
fi
if test -f 'cperf/tests/c.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/c.gperf'\"
else
echo shar: Extracting \"'cperf/tests/c.gperf'\" \(198 characters\)
sed "s/^X//" >'cperf/tests/c.gperf' <<'END_OF_FILE'
Xif
Xdo
Xint
Xfor
Xcase
Xchar
Xauto
Xgoto
Xelse
Xlong
Xvoid
Xenum
Xfloat
Xshort
Xunion
Xbreak
Xwhile
Xconst
Xdouble
Xstatic
Xextern
Xstruct
Xreturn
Xsizeof
Xswitch
Xsigned
Xtypedef
Xdefault
Xunsigned
Xcontinue
Xregister
Xvolatile
END_OF_FILE
if test 198 -ne `wc -c <'cperf/tests/c.gperf'`; then
    echo shar: \"'cperf/tests/c.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/c.gperf'
fi
if test -f 'cperf/tests/gpc.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/gpc.gperf'\"
else
echo shar: Extracting \"'cperf/tests/gpc.gperf'\" \(1122 characters\)
sed "s/^X//" >'cperf/tests/gpc.gperf' <<'END_OF_FILE'
X%{
X/* ISO Pascal 7185 reserved words.
X *
X * For GNU Pascal compiler (GPC) by jtv@hut.fi
X *
X * run this through the Doug Schmidt's gperf program
X * with command
X * gperf  -g -o -j1 -t -p -N is_reserved_word
X *
X */
X%}
Xstruct resword { char *name; short token; short iclass;};
X%%
XAnd,  AND,  PASCAL_ISO
XArray,  ARRAY,  PASCAL_ISO
XBegin,  BEGIN_, PASCAL_ISO
XCase, CASE, PASCAL_ISO
XConst,  CONST,  PASCAL_ISO
XDiv,  DIV,  PASCAL_ISO
XDo, DO, PASCAL_ISO
XDownto, DOWNTO, PASCAL_ISO
XElse, ELSE, PASCAL_ISO
XEnd,  END,  PASCAL_ISO
XFile, FILE_,  PASCAL_ISO
XFor,  FOR,  PASCAL_ISO
XFunction, FUNCTION, PASCAL_ISO
XGoto, GOTO, PASCAL_ISO
XIf, IF, PASCAL_ISO
XIn, IN, PASCAL_ISO
XLabel,  LABEL,  PASCAL_ISO
XMod,  MOD,  PASCAL_ISO
XNil,  NIL,  PASCAL_ISO
XNot,  NOT,  PASCAL_ISO
XOf, OF, PASCAL_ISO
XOr, OR, PASCAL_ISO
XPacked, PACKED, PASCAL_ISO
XProcedure, PROCEDURE, PASCAL_ISO
XProgram,PROGRAM,PASCAL_ISO
XRecord, RECORD, PASCAL_ISO
XRepeat, REPEAT, PASCAL_ISO
XSet,  SET,  PASCAL_ISO
XThen, THEN, PASCAL_ISO
XTo, TO, PASCAL_ISO
XType, TYPE, PASCAL_ISO
XUntil,  UNTIL,  PASCAL_ISO
XVar,  VAR,  PASCAL_ISO
XWhile,  WHILE,  PASCAL_ISO
XWith, WITH, PASCAL_ISO
END_OF_FILE
if test 1122 -ne `wc -c <'cperf/tests/gpc.gperf'`; then
    echo shar: \"'cperf/tests/gpc.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/gpc.gperf'
fi
if test -f 'cperf/tests/gplus.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/gplus.gperf'\"
else
echo shar: Extracting \"'cperf/tests/gplus.gperf'\" \(1386 characters\)
sed "s/^X//" >'cperf/tests/gplus.gperf' <<'END_OF_FILE'
Xstruct resword { char *name; short token; enum rid rid;};
X%%
Xwhile, WHILE, NORID,
Xvolatile, TYPE_QUAL, RID_VOLATILE,
Xvoid, TYPESPEC, RID_VOID,
Xvirtual, SCSPEC, RID_VIRTUAL,
Xunsigned, TYPESPEC, RID_UNSIGNED,
Xunion, AGGR, RID_UNION,
Xtypeof, TYPEOF, NORID,
Xtypedef, SCSPEC, RID_TYPEDEF,
Xthis, THIS, NORID,
Xswitch, SWITCH, NORID,
Xstruct, AGGR, RID_RECORD,
Xstatic, SCSPEC, RID_STATIC,
Xsizeof, SIZEOF, NORID,
Xsigned, TYPESPEC, RID_SIGNED,
Xshort, TYPESPEC, RID_SHORT,
Xreturn, RETURN, NORID,
Xregister, SCSPEC, RID_REGISTER,
Xpublic, PUBLIC, NORID,
Xprotected, PROTECTED, NORID,
Xprivate, PRIVATE, NORID,
Xoverload, OVERLOAD, NORID,
Xoperator, OPERATOR, NORID,
Xnew, NEW, NORID,
Xlong, TYPESPEC, RID_LONG,
Xint, TYPESPEC, RID_INT,
Xinline, SCSPEC, RID_INLINE,
Xif, IF, NORID,
Xgoto, GOTO, NORID,
Xfriend, TYPE_QUAL, RID_FRIEND,
Xfor, FOR, NORID,
Xfloat, TYPESPEC, RID_FLOAT,
Xextern, SCSPEC, RID_EXTERN,
Xenum, ENUM, NORID,
Xelse, ELSE, NORID,
Xdynamic, DYNAMIC, NORID,
Xdouble, TYPESPEC, RID_DOUBLE,
Xdo, DO, NORID,
Xdelete, DELETE, NORID,
Xdefault, DEFAULT, NORID,
Xcontinue, CONTINUE, NORID,
Xconst, TYPE_QUAL, RID_CONST,
Xclass, AGGR, RID_CLASS,
Xchar, TYPESPEC, RID_CHAR,
Xcase, CASE, NORID,
Xbreak, BREAK, NORID,
Xauto, SCSPEC, RID_AUTO,
Xasm, ASM, NORID,
X__volatile, TYPE_QUAL, RID_VOLATILE
X__typeof, TYPEOF, NORID
X__inline, SCSPEC, RID_INLINE
X__const, TYPE_QUAL, RID_CONST
X__asm, ASM, NORID
X__alignof, ALIGNOF, NORID
END_OF_FILE
if test 1386 -ne `wc -c <'cperf/tests/gplus.gperf'`; then
    echo shar: \"'cperf/tests/gplus.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/gplus.gperf'
fi
if test -f 'cperf/tests/modula2.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/modula2.gperf'\"
else
echo shar: Extracting \"'cperf/tests/modula2.gperf'\" \(225 characters\)
sed "s/^X//" >'cperf/tests/modula2.gperf' <<'END_OF_FILE'
XAND
XARRAY
XBEGIN
XBY
XCASE
XCONST
XDEFINITION
XDIV
XDO
XELSE
XELSIF
XEND
XEXIT
XEXPORT
XFOR
XFROM
XIF
XIMPLEMENTATION
XIMPORT
XIN
XLOOP
XMOD
XMODULE
XNOT
XOF
XOR
XPOINTER
XPROCEDURE
XQUALIFIED
XRECORD
XREPEAT
XRETURN
XSET
XTHEN
XTO
XTYPE
XUNTIL
XVAR
XWHILE
XWITH
END_OF_FILE
if test 225 -ne `wc -c <'cperf/tests/modula2.gperf'`; then
    echo shar: \"'cperf/tests/modula2.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/modula2.gperf'
fi
if test -f 'cperf/tests/modula3.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/modula3.gperf'\"
else
echo shar: Extracting \"'cperf/tests/modula3.gperf'\" \(608 characters\)
sed "s/^X//" >'cperf/tests/modula3.gperf' <<'END_OF_FILE'
XAND
XARRAY
XBEGIN
XBITS
XBY
XCASE
XCONST
XDIV
XDO
XELSE
XELSIF
XEND
XEVAL
XEXCEPT
XEXCEPTION
XEXIT
XEXPORTS
XFINALLY
XFOR
XFROM
XIF
XIMPORT
XINTERFACE
XIN
XINLINE
XLOCK
XMETHODS
XMOD
XMODULE
XNOT
XOBJECT
XOF
XOR
XPROCEDURE
XRAISES
XREADONLY
XRECORD
XREF
XREPEAT
XRETURN
XSET
XTHEN
XTO
XTRY
XTYPE
XTYPECASE
XUNSAFE
XUNTIL
XUNTRACED
XVALUE
XVAR
XWHILE
XWITH
Xand
Xarray
Xbegin
Xbits
Xby
Xcase
Xconst
Xdiv
Xdo
Xelse
Xelsif
Xend
Xeval
Xexcept
Xexception
Xexit
Xexports
Xfinally
Xfor
Xfrom
Xif
Ximport
Xinterface
Xin
Xinline
Xlock
Xmethods
Xmod
Xmodule
Xnot
Xobject
Xof
Xor
Xprocedure
Xraises
Xreadonly
Xrecord
Xref
Xrepeat
Xreturn
Xset
Xthen
Xto
Xtry
Xtype
Xtypecase
Xunsafe
Xuntil
Xuntraced
Xvalue
Xvar
Xwhile
Xwith
END_OF_FILE
if test 608 -ne `wc -c <'cperf/tests/modula3.gperf'`; then
    echo shar: \"'cperf/tests/modula3.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/modula3.gperf'
fi
if test -f 'cperf/tests/pascal.gperf' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/pascal.gperf'\"
else
echo shar: Extracting \"'cperf/tests/pascal.gperf'\" \(188 characters\)
sed "s/^X//" >'cperf/tests/pascal.gperf' <<'END_OF_FILE'
Xwith
Xarray
Xand
Xfunction
Xcase
Xvar
Xconst
Xuntil
Xthen
Xset
Xrecord
Xprogram
Xprocedure
Xor
Xpacked
Xnot
Xnil
Xlabel
Xin
Xrepeat
Xof
Xgoto
Xforward
Xfor
Xwhile
Xfile
Xelse
Xdownto
Xdo
Xdiv
Xto
Xtype
Xend
Xmod
Xbegin
Xif
END_OF_FILE
if test 188 -ne `wc -c <'cperf/tests/pascal.gperf'`; then
    echo shar: \"'cperf/tests/pascal.gperf'\" unpacked with wrong size!
fi
# end of 'cperf/tests/pascal.gperf'
fi
if test -f 'cperf/tests/test.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/tests/test.c'\"
else
echo shar: Extracting \"'cperf/tests/test.c'\" \(540 characters\)
sed "s/^X//" >'cperf/tests/test.c' <<'END_OF_FILE'
X/*
X   Tests the generated perfect has function.
X   The -v option prints diagnostics as to whether a word is in 
X   the set or not.  Without -v the program is useful for timing.
X*/ 
X  
X#include <stdio.h>
X
X#define MAX_LEN 80
X
Xint 
Xmain (argc, argv) 
X     int   argc;
X     char *argv[];
X{
X  int  verbose = argc > 1 ? 1 : 0;
X  char buf[MAX_LEN];
X
X  while (gets (buf)) 
X    if (in_word_set (buf, strlen (buf)) && verbose) 
X      printf ("in word set %s\n", buf);
X    else if (verbose) 
X      printf ("NOT in word set %s\n", buf);
X
X  return 0;
X}
END_OF_FILE
if test 540 -ne `wc -c <'cperf/tests/test.c'`; then
    echo shar: \"'cperf/tests/test.c'\" unpacked with wrong size!
fi
# end of 'cperf/tests/test.c'
fi
echo shar: End of archive 1 \(of 5\).
cp /dev/null ark1isdone
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

