# Copyright (C) 1989 Free Software Foundation, Inc.
# written by Douglas C. Schmidt (schmidt@ics.uci.edu)
# 
# This file is part of GNU GPERF.
# 
# GNU GPERF is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 1, or (at your option)
# any later version.
# 
# GNU GPERF is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with GNU GPERF; see the file COPYING.  If not, write to
# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 

GXX = g++
GFLAGS= -g -O -fmemoize-lookups -fsave-memoized -fchar-charconst -finline-functions -fstrength-reduce
OBJS = options.o iterator.o main.o perfect.o keylist.o listnode.o \
       hashtable.o boolarray.o readline.o stderr.o version.o getopt.o
.SUFFIXES: .cc
.cc.o:
	$(GXX) $(GFLAGS) -c  $<

all: gperf

gperf: $(OBJS) 
	$(GXX) $(GFLAGS) -o gperf $(OBJS) $(LIBS)

clean: 
	-rm -f *.o core *~ #*#

# dependencies
# DO NOT DELETE THIS LINE -- mkdep uses it.
# DO NOT PUT ANYTHING AFTER THIS LINE, IT WILL GO AWAY.

boolarray.o : boolarray.cc boolarray.h options.h 
getopt.o : getopt.cc getopt.h 
hashtable.o : hashtable.cc hashtable.h keylist.h listnode.h options.h 
iterator.o : iterator.cc iterator.h 
keylist.o : keylist.cc options.h readline.h keylist.h listnode.h \
  hashtable.h stderr.h 
listnode.o : listnode.cc options.h listnode.h stderr.h 
main.o : main.cc stderr.h options.h perfect.h keylist.h listnode.h \
  boolarray.h 
options.o : options.cc getopt.h options.h iterator.h stderr.h 
perfect.o : perfect.cc options.h perfect.h keylist.h listnode.h boolarray.h \
  stderr.h 
readline.o : readline.cc readline.h 
stderr.o : stderr.cc stderr.h 
version.o : version.cc 

# IF YOU PUT ANYTHING HERE IT WILL GO AWAY
