/* This may look like C code, but it is really -*- C++ -*- */

/* Reads arbitrarily long string from input file, returning it as a dynamic buffer. 

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

/* Returns a pointer to an arbitrary length string.  Returns NULL on error or EOF
   The storage for the string is dynamically allocated by new. */

#pragma once
#include <stdio.h>

class Read_Line 
{
#ifdef COMPILER_FIXED
 friend void *operator new (long size); 
#else
 friend void *new_string (long size); 
#endif
private:
  char *readln_aux (int chunks);
  FILE *fp;                       /* FILE pointer to the input stream. */
  int   chunk_size;               /* Size of each chunk. */
  static char *buf_start;         /* Large array used to reduce calls to NEW. */
  static char *buf_end;           /* Indicates end of BUF_START. */
  static int   buf_size;          /* Size of buffer pointed to by BUF_START. */

public:
        Read_Line (FILE *stream = stdin, int size = BUFSIZ);
  char *operator () (void);
};

#ifdef __OPTIMIZE__

inline char *Read_Line::operator () (void) 
{
	int c;

	if ((c = getc (fp)) == '#')
		{
			while (getc (fp) != '\n')
				;

			return operator () ();
		}
	else
		{
			ungetc (c, stdin);
			return readln_aux (0);
		}
}
#endif

