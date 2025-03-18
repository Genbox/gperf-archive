/* This may look like C code, but it is really -*- C++ -*- */

/* Simple lookup table abstraction implemented as an Ullman Array.

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

/* Define and implement a simple boolean array abstraction,
   uses an Ullman implementation to save on initialization time. */

#pragma once
#include <stddef.h>

class Bool_Array 
{
private:
  int *index_array;             /* All these extra buffers are used to. */
  int *hand_shake_array;        /* Eliminate the need to do explicit. */
  int *storage_array;           /* Initialization of the index space. */
  int  current_max;             /* Each time a fresh array is needed. */
  int  size;                    /* Size of the entire array (dynamically initialized). */

public:
       Bool_Array (void);
       Bool_Array (int size);
      ~Bool_Array (void);
  void operator () (int size);
  bool operator [] (int hash_value);
  void reset (void);
};

#ifdef __OPTIMIZE__  /* efficiency hack! */

inline 
Bool_Array::Bool_Array (void)
{
  index_array      = 0;
  hand_shake_array = 0;
  storage_array    = 0;
  current_max      = -1;
  size             = 0;
}

inline 
Bool_Array::Bool_Array (int s)
{
  current_max      = -1;
  size             = s;
  index_array      = new int[s];
  hand_shake_array = new int[s];
  storage_array    = new int[s];
}

inline void 
Bool_Array::operator () (int s)
{
  current_max      = -1;
  size             = s;
  index_array      = new int[s];
  hand_shake_array = new int[s];
  storage_array    = new int[s];
}

inline bool 
Bool_Array::operator [] (int index) return original_value (0)
{
  int hand_shake_i = index_array [index];

  if (hand_shake_i < 0 || hand_shake_i > current_max
			|| index != hand_shake_array[hand_shake_i])
    {
      hand_shake_i                   = ++current_max;
      hand_shake_array[hand_shake_i] = index;
      index_array[index]             = hand_shake_i;
    }
  else 
    original_value = 1;
  storage_array[hand_shake_i] = 1;
}

inline void 
Bool_Array::reset (void) 
{ 
  current_max = -1;
}

#endif
