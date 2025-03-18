/* Correctly reads an arbitrarily size string.

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

#include "readline.h"
#include <std.h>

#ifdef COMPILER_FIXED
#define ALLOC(BYTES) new char[BYTES]

/* Provide an abstraction that cuts down on the number of
   calls to NEW by buffering the memory pool from which
   strings are allocated. */

static inline void *
operator new (long size)
{
  char *temp;

  /* If we are about to overflow our buffer we'll just grab another
     chunk of memory.  Since we never free the original memory it
     doesn't matter that no one points to the beginning of that
     chunk. */
  
  if (Read_Line::buf_start + size >= Read_Line::buf_end)
    {
      Read_Line::buf_start = malloc (Read_Line::buf_size);
      Read_Line::buf_end   = Read_Line::buf_start + Read_Line::buf_size;
    }

  temp = Read_Line::buf_start;
  Read_Line::buf_start += size;
  return temp;
}
#else
#define ALLOC(BYTES) new_string (BYTES)
static inline void *
new_string (long size)
{
  char *temp;

  /* If we are about to overflow our buffer we'll just grab another
     chunk of memory.  Since we never free the original memory it
     doesn't matter that no one points to the beginning of that
     chunk. */
  
  if (Read_Line::buf_start + size >= Read_Line::buf_end)
    {
      Read_Line::buf_start = malloc (Read_Line::buf_size);
      Read_Line::buf_end   = Read_Line::buf_start + Read_Line::buf_size;
    }

  temp = Read_Line::buf_start;
  Read_Line::buf_start += size;
  return temp;
}
#endif

Read_Line::Read_Line (FILE *stream, int size)
{
  fp         = stream;
  chunk_size = size;
  buf_size   = chunk_size * 4;
  buf_start  = malloc (buf_size);
  buf_end    = buf_start + buf_size;
}

/* Recursively fills up the buffer. */

char *
Read_Line::readln_aux(int chunks) 
{
  char buf[chunk_size];
  register char *bufptr = buf;
  register char *ptr;
  int c;

  while ((c = getc (fp)) != EOF && c != '\n') /* fill the current buffer */
    {
      *bufptr++ = c;
      if (bufptr - buf >= chunk_size) /* prepend remainder to ptr buffer */
        {
          if (ptr = readln_aux (chunks + 1))

            for (; bufptr != buf; *--ptr = *--bufptr);

          return ptr;
        }
    }
  if (c == EOF && bufptr == buf)
    return NULL;

  c = (chunks * chunk_size + bufptr - buf) + 1;

  if (ptr = ALLOC (c))
    {

      for (*(ptr += (c - 1)) = '\0'; bufptr != buf; *--ptr = *--bufptr)
        ;

      return ptr;
    } 
  else 
    return NULL;
}

#ifndef __OPTIMIZE__

/* Returns the ``next'' line, ignoring comments beginning with '#'. */

char *
Read_Line::operator () (void) 
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

/* Returns length of ``current'' line. */
#endif
