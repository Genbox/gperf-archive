#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of archive 2 (of 5)."
# Contents:  cperf/ChangeLog cperf/src/Makefile cperf/src/getopt.c
#   cperf/src/hashtable.c cperf/src/listnode.c cperf/src/options.h
#   cperf/src/perfect.c
# Wrapped by schmidt@crimee.ics.uci.edu on Wed Oct 18 11:43:32 1989
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'cperf/ChangeLog' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/ChangeLog'\"
else
echo shar: Extracting \"'cperf/ChangeLog'\" \(8012 characters\)
sed "s/^X//" >'cperf/ChangeLog' <<'END_OF_FILE'
XMon Oct 16 19:58:08 1989  Doug Schmidt  (schmidt at glacier.ics.uci.edu)
X
X        * Fixed a number of small bugs kindly brought to my attention by
X          Adam de Boor (bsw!adam@uunet.UU.NET).  Thanks Adam!  In particular,
X          changed the behavior for the -a (ANSI) option so that the
X          generated prototypes use int rather than size_t for the LEN 
X          parameter.  It was too ugly having to #include <stddef.h> all
X          over the place...
X
X        * Added a majorly neat hack to Bool_Array, suggested by rfg.
X          The basic idea was to throw away the Ullman array technique.
X          The Ullman array was used to remove the need to reinitialize all 
X          the Bool_Array elements to zero everytime we needed to determine
X          whether there were duplicate hash values in the keyword list.  
X          The current trick uses an `iteration number' scheme, which takes
X          about 1/3 the space and reduces the overall program running a 
X          time by about 20 percent for large input!  The hack works as 
X          follows:
X          
X          1. Dynamically allocation 1 boolean array of size k.
X          2. Initialize the boolean array to zeros, and consider the first
X             iteration to be iteration 1.
X          2. Then on all subsequent iterations we `reset' the bool array by
X             kicking the iteration count by 1. 
X          3. When it comes time to check whether a hash value is currently
X             in the boolean array we simply check its index location.  If
X             the value stored there is *not* equal to the current iteration
X             number then the item is clearly *not* in the set.  In that
X             case we assign the iteration number to that array's index
X             location for future reference.  Otherwise, if the item at
X             the index location *is* equal to the iteration number we've
X             found a duplicate.  No muss, no fuss!
X
XThu Oct 12 18:08:43 1989  Doug Schmidt  (schmidt at zola.ics.uci.edu)
X
X        * Updated the version number to 1.9.
X
X        * Added support for the -C option.  This makes the contents of
X          all generated tables `readonly'.
X
X        * Changed the handling of generated switches so that there is
X          only one call to str[n]?cmp.  This *greatly* reduces the size of
X          the generated assembly code on all compilers I've seen.
X
X        * Fixed a subtle bug that occurred when the -l and -S option
X          was given.  Code produced looked something like:
X
X          if (len != key_len || !strcmp (s1, resword->name)) return resword;
X
X          which doesn't make any sense.  Clearly, this should be:
X
X          if (len == key_len && !strcmp (s1, resword->name)) return resword;
X
XSat Sep 30 12:55:24 1989  Doug Schmidt  (schmidt at glacier.ics.uci.edu)
X
X        * Fixed a stupid bug in Key_List::print_hash_function that manifested
X          itself if the `-k$' option was given (i.e., only use the key[length]
X          character in the hash function).
X
XMon Jul 24 17:09:46 1989  Doug Schmidt  (schmidt at glacier.ics.uci.edu)
X
X        * Fixed a bug in PRINT_MIN_MAX that resulted in MAX_INT being printed
X          for the MIN_KEY_LEN if there was only 1 keyword in the input file
X          (yeah, that's a pretty unlikely occurrence, I agree!).
X
X        * Fixed PRINT_HASH_FUNCTION and PRINT_LOOKUP_FUNCTION in keylist.c
X          so that the generated functions take an unsigned int length argument.
X          If -a is enabled the prototype is (const char *str, size_t len).
X
XFri Jul 21 13:06:15 1989  Doug Schmidt  (schmidt at zola.ics.uci.edu)
X
X        * Fixed a horrible typo in PRINT_KEYWORD_TABLE in keylist.cc
X          that prevented links from being printed correctly.
X
XSun Jul  9 17:53:28 1989  Doug Schmidt  (schmidt at glacier.ics.uci.edu)
X
X        * Changed the ./tests subdirectory Makefile so that it 
X          uses $(CC) instead of gcc.
X
XSun Jul  2 12:14:04 1989  Doug Schmidt  (schmidt at glacier.ics.uci.edu)
X
X        * Moved comment handling from keylist.c to readline.c.  This
X          simplifies the code and reduces the number of malloc calls.
X
X        * Fixed a number of subtle bugs that occurred when -S was
X          combined with various and sundry options.
X
X        * Added the -G option, that makes the generated keyword table
X          a global static variable, rather than hiding it inside
X          the lookup function.  This allows other functions to directly
X          access the contents in this table.
X
XSat Jul  1 10:12:21 1989  Doug Schmidt  (schmidt at crimee.ics.uci.edu)
X
X        * Added the "#" feature, that allows comments inside the keyword
X          list from the input file.
X          
X        * Also added the -H option (user can give the name of the hash
X          function) and the -T option (prevents the transfer of the type decl
X          to the output file, which is useful if the type is already defined
X          elsewhere).
X
XFri Jun 30 18:22:35 1989  Doug Schmidt  (schmidt at crimee.ics.uci.edu)
X
X        * Added Adam de Boor's changes.  Created an UNSET_OPTION macro.
X
XSat Jun 17 10:56:00 1989  Doug Schmidt  (schmidt at glacier.ics.uci.edu)
X
X        * Modified option.h and option.c so that all mixed operations
X          between integers and enumerals are cast correctly to int.
X          This prevents errors in some brain-damaged C compilers.
X
XFri Jun 16 14:13:15 1989  Doug Schmidt  (schmidt at crimee.ics.uci.edu)
X
X        * Modified the -f (FAST) option.  This now takes an argument.
X          The argument corresponds to the number of iterations used
X          to resolve collisions.  -f 0 uses the length of the
X          keyword list (which is what -f did before).  This makes
X          life much easier when dealing with large keyword files.
X
XWed Jun  7 23:07:13 1989  Doug Schmidt  (schmidt at zola.ics.uci.edu)
X
X        * Updated to version 1.8 in preparation to release to Doug Lea
X          and FSF.
X
X        * Added the -c (comparison) option.  Enabling this
X          will use the strncmp function for string comparisons.
X          The default is to use strcmp.
X
XTue Jun  6 16:32:09 1989  Doug Schmidt  (schmidt at zola.ics.uci.edu)
X
X        * Fixed another stupid typo in xmalloc.c (XMALLOC).  I accidentally
X          left the ANSI-fied prototype in place.  This obviously
X          fails on old-style C compilers.
X
X        * Fixed stupid typos in PRINT_SWITCH from the keylist.c.  This
X          caused the -D option to produce incorrect output when used
X          in conjunction with -p and -t.
X          
X        * Replaced the use of STRCMP with STRNCMP for the generated
X          C output code.          
X
XFri Jun  2 23:16:01 1989  Doug Schmidt  (schmidt at trinite.ics.uci.edu)
X
X        * Added a new function (XMALLOC) and file (xmalloc.c).  All
X          calls to MALLOC were replaced by calls to XMALLOC.  This 
X          will complain when virtual memory runs out (don't laugh, 
X          this has happened!)
X
XThu Jun  1 21:10:10 1989  Doug Schmidt  (schmidt at zola.ics.uci.edu)
X
X        * Fixed a typo in options.c that prevented the -f option
X          from being given on the command-line.
X
XWed May  3 17:48:02 1989  Doug Schmidt  (schmidt at zola.ics.uci.edu)
X
X        * Updated to version 1.7.  This reflects the recent major changes
X          and the new C port.
X
X        * Fixed a typo in perfect.c perfect_destroy that prevented the actual 
X          maximum hash table size from being printed.
X
X        * Added support for the -f option.  This generates the perfect
X          hash function ``fast.''  It reduces the execution time of
X          gperf, at the cost of minimizing the range of hash values.
X
XTue May  2 16:23:29 1989  Doug Schmidt  (schmidt at crimee.ics.uci.edu)
X
X        * Enabled the diagnostics dump if the debugging option is enabled.
X        
X        * Removed all calls to FREE (silly to do this at program termination).
X
X        * Ported gperf to C.  From now on both K&R C and GNU G++ versions
X          will be supported.
X
END_OF_FILE
if test 8012 -ne `wc -c <'cperf/ChangeLog'`; then
    echo shar: \"'cperf/ChangeLog'\" unpacked with wrong size!
fi
# end of 'cperf/ChangeLog'
fi
if test -f 'cperf/src/Makefile' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/Makefile'\"
else
echo shar: Extracting \"'cperf/src/Makefile'\" \(3414 characters\)
sed "s/^X//" >'cperf/src/Makefile' <<'END_OF_FILE'
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
XCC = cc
XCFLAGS= -O # -g -fstrength-reduce -finline-functions # gcc options 
XOBJS = options.o iterator.o main.o perfect.o keylist.o listnode.o xmalloc.o \
X       hashtable.o boolarray.o readline.o stderr.o version.o getopt.o
XSOURCES = options.c iterator.c main.c perfect.c keylist.c listnode.c xmalloc.c \
X       hashtable.c boolarray.c readline.c stderr.c version.c getopt.c
X
Xall: gperf
X
Xgperf: $(OBJS) 
X	$(CC) $(CFLAGS) -o gperf $(OBJS) $(LIBS)
X
Xclean: 
X	-rm -f *.o core *~ #*#
X
Xrealclean: clean
X	-rm -f gperf
X
X# dependencies
X# DO NOT DELETE THIS LINE -- mkdep uses it.
X# DO NOT PUT ANYTHING AFTER THIS LINE, IT WILL GO AWAY.
X
Xboolarray.o: boolarray.c /usr/include/stdio.h boolarray.h prototype.h options.h
Xboolarray.o: /usr/include/stdio.h prototype.h
Xgetopt.o: getopt.c /usr/include/stdio.h
Xhashtable.o: hashtable.c /usr/include/stdio.h hashtable.h keylist.h
Xhashtable.o: /usr/include/stdio.h listnode.h prototype.h prototype.h options.h
Xhashtable.o: /usr/include/stdio.h prototype.h
Xiterator.o: iterator.c /usr/include/stdio.h /usr/include/ctype.h iterator.h
Xiterator.o: prototype.h
Xkeylist.o: keylist.c /usr/include/assert.h /usr/include/stdio.h options.h
Xkeylist.o: /usr/include/stdio.h prototype.h readline.h prototype.h keylist.h
Xkeylist.o: /usr/include/stdio.h listnode.h prototype.h hashtable.h keylist.h
Xkeylist.o: prototype.h stderr.h prototype.h /usr/include/varargs.h
Xlistnode.o: listnode.c /usr/include/stdio.h options.h /usr/include/stdio.h
Xlistnode.o: prototype.h listnode.h prototype.h stderr.h prototype.h
Xlistnode.o: /usr/include/varargs.h
Xmain.o: main.c /usr/include/stdio.h stderr.h prototype.h /usr/include/varargs.h
Xmain.o: options.h /usr/include/stdio.h prototype.h perfect.h prototype.h
Xmain.o: keylist.h /usr/include/stdio.h listnode.h prototype.h boolarray.h
Xmain.o: prototype.h
Xoptions.o: options.c /usr/include/stdio.h /usr/include/assert.h options.h
Xoptions.o: /usr/include/stdio.h prototype.h iterator.h prototype.h stderr.h
Xoptions.o: prototype.h /usr/include/varargs.h
Xperfect.o: perfect.c /usr/include/stdio.h /usr/include/assert.h
Xperfect.o: /usr/include/ctype.h options.h /usr/include/stdio.h prototype.h
Xperfect.o: perfect.h prototype.h keylist.h /usr/include/stdio.h listnode.h
Xperfect.o: prototype.h boolarray.h prototype.h stderr.h prototype.h
Xperfect.o: /usr/include/varargs.h
Xreadline.o: readline.c /usr/include/stdio.h readline.h prototype.h
Xstderr.o: stderr.c /usr/include/stdio.h stderr.h prototype.h
Xstderr.o: /usr/include/varargs.h
Xversion.o: version.c
Xxmalloc.o: xmalloc.c /usr/include/stdio.h
X
X# IF YOU PUT ANYTHING HERE IT WILL GO AWAY
END_OF_FILE
if test 3414 -ne `wc -c <'cperf/src/Makefile'`; then
    echo shar: \"'cperf/src/Makefile'\" unpacked with wrong size!
fi
# end of 'cperf/src/Makefile'
fi
if test -f 'cperf/src/getopt.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/getopt.c'\"
else
echo shar: Extracting \"'cperf/src/getopt.c'\" \(12436 characters\)
sed "s/^X//" >'cperf/src/getopt.c' <<'END_OF_FILE'
X/* Getopt for GNU.
X   Copyright (C) 1987, 1989 Free Software Foundation, Inc.
X
X   This program is free software; you can redistribute it and/or modify
X   it under the terms of the GNU General Public License as published by
X   the Free Software Foundation; either version 1, or (at your option)
X   any later version.
X
X   This program is distributed in the hope that it will be useful,
X   but WITHOUT ANY WARRANTY; without even the implied warranty of
X   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
X   GNU General Public License for more details.
X
X   You should have received a copy of the GNU General Public License
X   along with this program; if not, write to the Free Software
X   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */
X
X
X
X/* This version of `getopt' appears to the caller like standard Unix `getopt'
X   but it behaves differently for the user, since it allows the user
X   to intersperse the options with the other arguments.
X
X   As `getopt' works, it permutes the elements of `argv' so that,
X   when it is done, all the options precede everything else.  Thus
X   all application programs are extended to handle flexible argument order.
X
X   Setting the environment variable _POSIX_OPTION_ORDER disables permutation.
X   Then the behavior is completely standard.
X
X   GNU application programs can use a third alternative mode in which
X   they can distinguish the relative order of options and other arguments.  */
X
X#include <stdio.h>
X
X#ifdef sparc
X#include <alloca.h>
X#endif
X#ifdef USG
X#define bcopy(s, d, l) memcpy((d), (s), (l))
X#endif
X
X/* For communication from `getopt' to the caller.
X   When `getopt' finds an option that takes an argument,
X   the argument value is returned here.
X   Also, when `ordering' is RETURN_IN_ORDER,
X   each non-option ARGV-element is returned here.  */
X
Xchar *optarg = 0;
X
X/* Index in ARGV of the next element to be scanned.
X   This is used for communication to and from the caller
X   and for communication between successive calls to `getopt'.
X
X   On entry to `getopt', zero means this is the first call; initialize.
X
X   When `getopt' returns EOF, this is the index of the first of the
X   non-option elements that the caller should itself scan.
X
X   Otherwise, `optind' communicates from one call to the next
X   how much of ARGV has been scanned so far.  */
X
Xint optind = 0;
X
X/* The next char to be scanned in the option-element
X   in which the last option character we returned was found.
X   This allows us to pick up the scan where we left off.
X
X   If this is zero, or a null string, it means resume the scan
X   by advancing to the next ARGV-element.  */
X
Xstatic char *nextchar;
X
X/* Callers store zero here to inhibit the error message
X   for unrecognized options.  */
X
Xint opterr = 1;
X
X/* Describe how to deal with options that follow non-option ARGV-elements.
X
X   UNSPECIFIED means the caller did not specify anything;
X   the default is then REQUIRE_ORDER if the environment variable
X   _OPTIONS_FIRST is defined, PERMUTE otherwise.
X
X   REQUIRE_ORDER means don't recognize them as options.
X   Stop option processing when the first non-option is seen.
X   This is what Unix does.
X
X   PERMUTE is the default.  We permute the contents of `argv' as we scan,
X   so that eventually all the options are at the end.  This allows options
X   to be given in any order, even with programs that were not written to
X   expect this.
X
X   RETURN_IN_ORDER is an option available to programs that were written
X   to expect options and other ARGV-elements in any order and that care about
X   the ordering of the two.  We describe each non-option ARGV-element
X   as if it were the argument of an option with character code zero.
X   Using `-' as the first character of the list of option characters
X   requests this mode of operation.
X
X   The special argument `--' forces an end of option-scanning regardless
X   of the value of `ordering'.  In the case of RETURN_IN_ORDER, only
X   `--' can cause `getopt' to return EOF with `optind' != ARGC.  */
X
Xstatic enum { REQUIRE_ORDER, PERMUTE, RETURN_IN_ORDER } ordering;
X
X/* Handle permutation of arguments.  */
X
X/* Describe the part of ARGV that contains non-options that have
X   been skipped.  `first_nonopt' is the index in ARGV of the first of them;
X   `last_nonopt' is the index after the last of them.  */
X
Xstatic int first_nonopt;
Xstatic int last_nonopt;
X
X/* Exchange two adjacent subsequences of ARGV.
X   One subsequence is elements [first_nonopt,last_nonopt)
X    which contains all the non-options that have been skipped so far.
X   The other is elements [last_nonopt,optind), which contains all
X    the options processed since those non-options were skipped.
X
X   `first_nonopt' and `last_nonopt' are relocated so that they describe
X    the new indices of the non-options in ARGV after they are moved.  */
X
Xstatic void
Xexchange (argv)
X     char **argv;
X{
X  int nonopts_size
X    = (last_nonopt - first_nonopt) * sizeof (char *);
X  char **temp = (char **) alloca (nonopts_size);
X
X  /* Interchange the two blocks of data in argv.  */
X
X  bcopy (&argv[first_nonopt], temp, nonopts_size);
X  bcopy (&argv[last_nonopt], &argv[first_nonopt],
X	 (optind - last_nonopt) * sizeof (char *));
X  bcopy (temp, &argv[first_nonopt + optind - last_nonopt],
X	 nonopts_size);
X
X  /* Update records for the slots the non-options now occupy.  */
X
X  first_nonopt += (optind - last_nonopt);
X  last_nonopt = optind;
X}
X
X/* Scan elements of ARGV (whose length is ARGC) for option characters
X   given in OPTSTRING.
X
X   If an element of ARGV starts with '-', and is not exactly "-" or "--",
X   then it is an option element.  The characters of this element
X   (aside from the initial '-') are option characters.  If `getopt'
X   is called repeatedly, it returns successively each of theoption characters
X   from each of the option elements.
X
X   If `getopt' finds another option character, it returns that character,
X   updating `optind' and `nextchar' so that the next call to `getopt' can
X   resume the scan with the following option character or ARGV-element.
X
X   If there are no more option characters, `getopt' returns `EOF'.
X   Then `optind' is the index in ARGV of the first ARGV-element
X   that is not an option.  (The ARGV-elements have been permuted
X   so that those that are not options now come last.)
X
X   OPTSTRING is a string containing the legitimate option characters.
X   A colon in OPTSTRING means that the previous character is an option
X   that wants an argument.  The argument is taken from the rest of the
X   current ARGV-element, or from the following ARGV-element,
X   and returned in `optarg'.
X
X   If an option character is seen that is not listed in OPTSTRING,
X   return '?' after printing an error message.  If you set `opterr' to
X   zero, the error message is suppressed but we still return '?'.
X
X   If a char in OPTSTRING is followed by a colon, that means it wants an arg,
X   so the following text in the same ARGV-element, or the text of the following
X   ARGV-element, is returned in `optarg.  Two colons mean an option that
X   wants an optional arg; if there is text in the current ARGV-element,
X   it is returned in `optarg'.
X
X   If OPTSTRING starts with `-', it requests a different method of handling the
X   non-option ARGV-elements.  See the comments about RETURN_IN_ORDER, above.  */
X
Xint
Xgetopt (argc, argv, optstring)
X     int argc;
X     char **argv;
X     char *optstring;
X{
X  /* Initialize the internal data when the first call is made.
X     Start processing options with ARGV-element 1 (since ARGV-element 0
X     is the program name); the sequence of previously skipped
X     non-option ARGV-elements is empty.  */
X
X  if (optind == 0)
X    {
X      first_nonopt = last_nonopt = optind = 1;
X
X      nextchar = 0;
X
X      /* Determine how to handle the ordering of options and nonoptions.  */
X
X      if (optstring[0] == '-')
X	ordering = RETURN_IN_ORDER;
X      else if (getenv ("_POSIX_OPTION_ORDER") != 0)
X	ordering = REQUIRE_ORDER;
X      else
X	ordering = PERMUTE;
X    }
X
X  if (nextchar == 0 || *nextchar == 0)
X    {
X      if (ordering == PERMUTE)
X	{
X	  /* If we have just processed some options following some non-options,
X	     exchange them so that the options come first.  */
X
X	  if (first_nonopt != last_nonopt && last_nonopt != optind)
X	    exchange (argv);
X	  else if (last_nonopt != optind)
X	    first_nonopt = optind;
X
X	  /* Now skip any additional non-options
X	     and extend the range of non-options previously skipped.  */
X
X	  while (optind < argc
X		 && (argv[optind][0] != '-'
X		     || argv[optind][1] == 0))
X	    optind++;
X	  last_nonopt = optind;
X	}
X
X      /* Special ARGV-element `--' means premature end of options.
X	 Skip it like a null option,
X	 then exchange with previous non-options as if it were an option,
X	 then skip everything else like a non-option.  */
X
X      if (optind != argc && !strcmp (argv[optind], "--"))
X	{
X	  optind++;
X
X	  if (first_nonopt != last_nonopt && last_nonopt != optind)
X	    exchange (argv);
X	  else if (first_nonopt == last_nonopt)
X	    first_nonopt = optind;
X	  last_nonopt = argc;
X
X	  optind = argc;
X	}
X
X      /* If we have done all the ARGV-elements, stop the scan
X	 and back over any non-options that we skipped and permuted.  */
X
X      if (optind == argc)
X	{
X	  /* Set the next-arg-index to point at the non-options
X	     that we previously skipped, so the caller will digest them.  */
X	  if (first_nonopt != last_nonopt)
X	    optind = first_nonopt;
X	  return EOF;
X	}
X	 
X      /* If we have come to a non-option and did not permute it,
X	 either stop the scan or describe it to the caller and pass it by.  */
X
X      if (argv[optind][0] != '-' || argv[optind][1] == 0)
X	{
X	  if (ordering == REQUIRE_ORDER)
X	    return EOF;
X	  optarg = argv[optind++];
X	  return 0;
X	}
X
X      /* We have found another option-ARGV-element.
X	 Start decoding its characters.  */
X
X      nextchar = argv[optind] + 1;
X    }
X
X  /* Look at and handle the next option-character.  */
X
X  {
X    char c = *nextchar++;
X    char *temp = (char *) index (optstring, c);
X
X    /* Increment `optind' when we start to process its last character.  */
X    if (*nextchar == 0)
X      optind++;
X
X    if (temp == 0 || c == ':')
X      {
X	if (opterr != 0)
X	  {
X	    if (c < 040 || c >= 0177)
X	      fprintf (stderr, "%s: unrecognized option, character code 0%o\n",
X		       argv[0], c);
X	    else
X	      fprintf (stderr, "%s: unrecognized option `-%c'\n",
X		       argv[0], c);
X	  }
X	return '?';
X      }
X    if (temp[1] == ':')
X      {
X	if (temp[2] == ':')
X	  {
X	    /* This is an option that accepts an argument optionally.  */
X	    if (*nextchar != 0)
X	      {
X	        optarg = nextchar;
X		optind++;
X	      }
X	    else
X	      optarg = 0;
X	    nextchar = 0;
X	  }
X	else
X	  {
X	    /* This is an option that requires an argument.  */
X	    if (*nextchar != 0)
X	      {
X		optarg = nextchar;
X		/* If we end this ARGV-element by taking the rest as an arg,
X		   we must advance to the next element now.  */
X		optind++;
X	      }
X	    else if (optind == argc)
X	      {
X		if (opterr != 0)
X		  fprintf (stderr, "%s: no argument for `-%c' option\n",
X			   argv[0], c);
X		c = '?';
X	      }
X	    else
X	      /* We already incremented `optind' once;
X		 increment it again when taking next ARGV-elt as argument.  */
X	      optarg = argv[optind++];
X	    nextchar = 0;
X	  }
X      }
X    return c;
X  }
X}
X
X#ifdef TEST
X
X/* Compile with -DTEST to make an executable for use in testing
X   the above definition of `getopt'.  */
X
Xint
Xmain (argc, argv)
X     int argc;
X     char **argv;
X{
X  char c;
X  int digit_optind = 0;
X
X  while (1)
X    {
X      int this_option_optind = optind;
X      if ((c = getopt (argc, argv, "abc:d:0123456789")) == EOF)
X	break;
X
X      switch (c)
X	{
X	case '0':
X	case '1':
X	case '2':
X	case '3':
X	case '4':
X	case '5':
X	case '6':
X	case '7':
X	case '8':
X	case '9':
X	  if (digit_optind != 0 && digit_optind != this_option_optind)
X	    printf ("digits occur in two different argv-elements.\n");
X	  digit_optind = this_option_optind;
X	  printf ("option %c\n", c);
X	  break;
X
X	case 'a':
X	  printf ("option a\n");
X	  break;
X
X	case 'b':
X	  printf ("option b\n");
X	  break;
X
X	case 'c':
X	  printf ("option c with value `%s'\n", optarg);
X	  break;
X
X	case '?':
X	  break;
X
X	default:
X	  printf ("?? getopt returned character code 0%o ??\n", c);
X	}
X    }
X
X  if (optind < argc)
X    {
X      printf ("non-option ARGV-elements: ");
X      while (optind < argc)
X	printf ("%s ", argv[optind++]);
X      printf ("\n");
X    }
X
X  return 0;
X}
X
X#endif /* TEST */
END_OF_FILE
if test 12436 -ne `wc -c <'cperf/src/getopt.c'`; then
    echo shar: \"'cperf/src/getopt.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/getopt.c'
fi
if test -f 'cperf/src/hashtable.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/hashtable.c'\"
else
echo shar: Extracting \"'cperf/src/hashtable.c'\" \(3281 characters\)
sed "s/^X//" >'cperf/src/hashtable.c' <<'END_OF_FILE'
X/* Hash table for checking keyword links.  Implemented using double hashing.
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
X#include "hashtable.h"
X#include "options.h"
X
X/* Locally visible hash table. */
Xstatic HASH_TABLE hash_table;
X
X#define POW(X) ((!X)?1:(X-=1,X|=X>>1,X|=X>>2,X|=X>>4,X|=X>>8,X|=X>>16,(++X)))
X
Xstatic unsigned
Xhash_pjw (str)
X     char *str;
X{
X  char    *temp;
X  unsigned g, h = 0;
X   
X  for (temp = str; *temp; temp++) 
X    {
X      h = (h << 4) + (*temp * 13);
X      if (g = h & 0xf0000000) 
X        {
X          h ^= (g >> 24);
X          h ^= g;
X        }
X    }
X
X  return h;
X}
X
X/* The size of the hash table is always the smallest power of 2 >= the size
X   indicated by the user.  this allows several optimizations, including
X   the use of double hashing and elimination of the mod instruction.
X   note that the size had better be larger than the number of items
X   in the hash table, else there's trouble!!! */
X
Xvoid
Xhash_table_init (s)
X     int s;
X{
X	char *xmalloc ();
X  hash_table.size  = POW (s);
X  hash_table.table = (LIST_NODE **) xmalloc (hash_table.size * sizeof (*hash_table.table));
X  bzero ((char *) hash_table.table, hash_table.size * sizeof *hash_table.table);
X}
X
X/* Frees the dynamically allocated table. */
X
Xvoid
Xhash_table_destroy ()
X{ 
X  if (OPTION_ENABLED (option, DEBUG))
X    {
X      int i;
X
X      fprintf (stderr, "\ndumping the hash table\n");
X    
X      for (i = hash_table.size - 1; i >= 0; i--)
X        if (hash_table.table[i])
X          fprintf (stderr, "location[%d] = key set %s, key %s\n",
X                   i, hash_table.table[i]->key_set, hash_table.table[i]->key);
X
X      fprintf (stderr, "end dumping hash table\n\n");
X    }
X}
X
X/* If the ITEM is already in the hash table return the item found
X   in the table.  Otherwise inserts the ITEM, and returns FALSE.
X   Uses double hashing. */
X
XLIST_NODE *
Xretrieve (item, ignore_length)
X     LIST_NODE *item;
X     int        ignore_length;
X{
X  unsigned hash_val  = hash_pjw (item->key_set);
X  int      probe     = hash_val & hash_table.size - 1;
X  int      increment = (hash_val ^ item->length | 1) & hash_table.size - 1;
X  
X  while (hash_table.table[probe]
X         && (strcmp (hash_table.table[probe]->key_set, item->key_set)
X             || (!ignore_length && hash_table.table[probe]->length != item->length)))
X    probe = probe + increment & hash_table.size - 1;
X  
X  if (hash_table.table[probe])
X    return hash_table.table[probe];
X  else
X    {
X      hash_table.table[probe] = item;
X      return 0;
X    }
X}
X
X
END_OF_FILE
if test 3281 -ne `wc -c <'cperf/src/hashtable.c'`; then
    echo shar: \"'cperf/src/hashtable.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/hashtable.c'
fi
if test -f 'cperf/src/listnode.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/listnode.c'\"
else
echo shar: Extracting \"'cperf/src/listnode.c'\" \(4294 characters\)
sed "s/^X//" >'cperf/src/listnode.c' <<'END_OF_FILE'
X/* Creates and initializes a new list node.
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
X#include "options.h"
X#include "listnode.h"
X#include "stderr.h"
X
X/* See comments in perfect.cc. */
Xextern int occurrences[ALPHABET_SIZE]; 
X
X/* Sorts the key set alphabetically to speed up subsequent operations.
X   Uses insertion sort since the set is probably quite small. */
X
Xstatic void 
Xset_sort (base, len)
X     char *base;
X     int len;
X{
X  int i, j;
X
X  for (i = 0, j = len - 1; i < j; i++)
X    {
X      char curr, tmp;
X      
X      for (curr = i + 1, tmp = base[curr]; curr > 0 && tmp < base[curr-1]; curr--)
X        base[curr] = base[curr - 1];
X
X      base[curr] = tmp;
X
X    }
X}
X
X/* Initializes a List_Node.  This requires obtaining memory for the KEY_SET
X   and UNIQ_SET, initializing them using the information stored in the
X   KEY_POSITIONS array in Options, and checking for simple errors.
X   It's important to note that KEY and REST are both pointers to
X   the different offsets into the same block of dynamic memory pointed to
X   by parameter K. The data member REST is used to store any additional fields 
X   of the input file (it is set to the "" string if Option[TYPE] is not enabled).
X   This is useful if the user wishes to incorporate a lookup structure,
X   rather than just an array of keys. */
X
XLIST_NODE *
Xmake_list_node (k, len)
X     char *k;
X     int len;
X{
X	char *xmalloc ();
X  LIST_NODE *temp = (LIST_NODE *) xmalloc (sizeof (LIST_NODE));
X  int positions  = 1 + (OPTION_ENABLED (option, ALLCHARS) ? len : TOTAL_POSITIONS (option) + 1);
X  char *ptr, *ptr1, *ptr2;
X
X  temp->key_set  = (char *) xmalloc (positions + positions); /* Save 1 call to new. */
X  temp->uniq_set = temp->key_set + positions;
X  ptr            = temp->key_set;
X  k[len]         = '\0';        /* Null terminate KEY to separate it from REST. */
X  temp->key      = k;
X  temp->next     = 0;
X  temp->index    = 0;
X  temp->length   = len;
X  temp->link     = 0;
X  temp->rest     = OPTION_ENABLED (option, TYPE) ? k + len + 1 : "";
X
X  if (OPTION_ENABLED (option, ALLCHARS)) /* Use all the character position in the KEY. */
X
X    for (; *k; k++, ptr++)
X      ++occurrences[*ptr = *k];
X
X  else                          /* Only use those character positions specified by the user. */
X    {                           
X      int i;
X
X      /* Iterate thru the list of key_positions, initializing occurrences table
X         and temp->key_set (via char * pointer ptr). */
X
X      for(RESET (option); (i = GET (option)) != EOS; )
X        {
X          if (i == WORD_END)    /* Special notation for last KEY position, i.e. '$'. */
X            *ptr = temp->key[len - 1];
X          else if (i <= len)    /* Within range of KEY length, so we'll keep it. */
X            *ptr = temp->key[i - 1];
X          else                  /* Out of range of KEY length, so we'll just skip it. */
X            continue;
X          ++occurrences[*ptr++];
X        }
X
X      if (ptr == temp->key_set) /* Didn't get any hits, i.e., no usable positions. */
X        report_error ("can't hash keyword %s with chosen key positions\n%a", temp->key);
X    }
X
X  *ptr = '\0';                  /* Terminate this bastard.... */
X  set_sort (temp->key_set, ptr - temp->key_set); /* Sort the KEY_SET items alphabetically. */
X
X  /* Eliminate UNIQ_SET duplicates, this saves time later on.... */
X
X  for (ptr1 = temp->key_set, ptr2 = temp->uniq_set; *ptr1; ptr1++)
X    if (*ptr1 != ptr1[1])
X      *ptr2++ = *ptr1;
X
X  *ptr2 = '\0';                 /* NULL terminate the UNIQ_SET. */
X  return temp;
X}
END_OF_FILE
if test 4294 -ne `wc -c <'cperf/src/listnode.c'`; then
    echo shar: \"'cperf/src/listnode.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/listnode.c'
fi
if test -f 'cperf/src/options.h' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/options.h'\"
else
echo shar: Extracting \"'cperf/src/options.h'\" \(5762 characters\)
sed "s/^X//" >'cperf/src/options.h' <<'END_OF_FILE'
X/* Handles parsing the Options provided to the user.
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
X/* This module provides a uniform interface to the various Options available
X   to a user of the Perfect.hash function generator.  In addition to the
X   run-time Options, found in the Option_Type below, there is also the
X   hash table Size and the Keys to be used in the hashing.
X   The overall design of this module was an experiment in using C++
X   classes as a mechanism to enhance centralization of option and
X   and error handling, which tend to get out of hand in a C program. */
X
X#ifndef _options_h
X#define _options_h
X
X#include <stdio.h>
X#include "prototype.h"
X
X/* Enumerate the potential debugging Options. */
X
Xenum option_type 
X{
X  DEBUG        = 01,            /* Enable debugging (prints diagnostics to Std_Err). */
X  ORDER        = 02,            /* Apply ordering heuristic to speed-up search time. */
X  ANSI         = 04,            /* Generate ANSI prototypes. */
X  ALLCHARS     = 010,           /* Use all characters in hash function. */
X  GNU          = 020,           /* Assume GNU extensions (primarily function inline). */
X  TYPE         = 040,           /* Handle user-defined type structured keyword input. */
X  RANDOM       = 0100,          /* Randomly initialize the associated values table. */
X  DEFAULTCHARS = 0200,          /* Make default char positions be 1,$ (end of keyword). */
X  SWITCH       = 0400,          /* Generate switch output to save space. */
X  POINTER      = 01000,         /* Have in_word_set function return pointer, not boolean. */
X  NOLENGTH     = 02000,         /* Don't include keyword length in hash computations. */
X  LENTABLE     = 04000,         /* Generate a length table for string comparison. */
X  DUP          = 010000,        /* Handle duplicate hash values for keywords. */
X  FAST         = 020000,        /* Generate the hash function ``fast.'' */
X  NOTYPE       = 040000,	/* Don't include user-defined type definition
X				 * in output -- it's already defined elsewhere. */
X  COMP         = 0100000,       /* Generate strncmp rather than strcmp. */
X  GLOBAL       = 0200000,       /* Make the keyword table a global variable. */
X  CONST        = 0400000,       /* Make the generated tables readonly (const). */
X};
X
X/* Define some useful constants. */
X
X/* Max size of each word's key set. */
X#define MAX_KEY_POS (128 - 1)
X
X/* Signals the start of a word. */
X#define WORD_START 1           
X
X/* Signals the end of a word. */
X#define WORD_END 0             
X
X/* Signals end of the key list. */
X#define EOS MAX_KEY_POS        
X
X/* Returns TRUE if option O is enabled. */
X#define OPTION_ENABLED(OW,O) (OW.option_word & (int)O)
X
X/* Enables option O in OPTION_WORD. */
X#define SET_OPTION(OW,O) (OW.option_word |= (int)O)
X
X/* Disable option O in OPTION_WORD. */
X#define UNSET_OPTION(OW,O) (OW.option_word &= ~(int)(O))
X
X/* Returns total distinct key positions. */
X#define TOTAL_POSITIONS(O) (O.total_key_positions)
X
X/* Initializes the key Iterator. */
X#define RESET(O) (O.key_pos = 0)
X
X/* Returns current key_position and advances index. */
X#define GET(O) (O.key_positions[O.key_pos++])
X
X/* Sets the size of the table size. */
X#define SET_ASSO_MAX(O,R) (O.size = (R))
X
X/* Returns the size of the table size. */
X#define GET_ASSO_MAX(O) (O.size)
X
X/* Returns the jump value. */
X#define GET_JUMP(O) (O.jump)
X
X/* Returns the iteration value. */
X#define GET_ITERATIONS(O) (O.iterations)
X
X/* Returns the lookup function name. */
X#define GET_FUNCTION_NAME(O) (O.function_name)
X
X/* Returns the keyword key name. */
X#define GET_KEY_NAME(O) (O.key_name)
X
X/* Returns the hash function name. */
X#define GET_HASH_NAME(O) (O.hash_name)
X
X/* Returns the initial associated character value. */
X#define INITIAL_VALUE(O) (O.initial_asso_value)
X
X/* Class manager for gperf program options. */
X
Xtypedef struct options
X{
X  int    option_word;           /* Holds the user-specified Options. */
X  int    total_key_positions;   /* Total number of distinct key_positions. */
X  int    size;                  /* Range of the hash table. */
X  int    key_pos;               /* Tracks current key position for Iterator. */
X  int    jump;                  /* Jump length when trying alternative values. */
X  int    initial_asso_value;    /* Initial value for asso_values table. */
X  int    argument_count;        /* Records count of command-line arguments. */
X  int    iterations;            /* Amount to iterate when a collision occurs. */
X  char **argument_vector;       /* Stores a pointer to command-line vector. */
X  char  *function_name;         /* Name used for generated lookup function. */
X  char  *key_name;              /* Name used for keyword key. */
X  char  *hash_name;             /* Name used for generated hash function. */
X  char   key_positions[MAX_KEY_POS]; /* Contains user-specified key choices. */
X} OPTIONS;
X
Xextern void    options_init P ((int argc, char *argv[]));
Xextern void    options_destroy P ((void));
Xextern OPTIONS option;       
X#endif /* _options_h */
END_OF_FILE
if test 5762 -ne `wc -c <'cperf/src/options.h'`; then
    echo shar: \"'cperf/src/options.h'\" unpacked with wrong size!
fi
# end of 'cperf/src/options.h'
fi
if test -f 'cperf/src/perfect.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/perfect.c'\"
else
echo shar: Extracting \"'cperf/src/perfect.c'\" \(9830 characters\)
sed "s/^X//" >'cperf/src/perfect.c' <<'END_OF_FILE'
X/* Provides high-level routines to manipulate the keywork list 
X   structures the code generation output.
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
X#include <assert.h>
X#include <ctype.h>
X#include "options.h"
X#include "perfect.h"
X#include "stderr.h"
X
Xint occurrences[ALPHABET_SIZE]; /* Counts occurrences of each key set character. */
Xint asso_values[ALPHABET_SIZE]; /* Value associated with each character. */
X
X/* Locally visible PERFECT object. */
X
XPERFECT perfect;
X
X/* Efficiently returns the least power of two greater than or equal to X! */
X#define POW(X) ((!X)?1:(X-=1,X|=X>>1,X|=X>>2,X|=X>>4,X|=X>>8,X|=X>>16,(++X)))
X
X/* Reads input keys, possibly applies the reordering heuristic, sets the
X   maximum associated value size (rounded up to the nearest power of 2),
X   may initialize the associated values array, and determines the maximum
X   hash table size.  Note: using the random numbers is often helpful,
X   though not as deterministic, of course! */
X
Xvoid
Xperfect_init ()
X{
X  int asso_value_max;
X  int len;
X
X  perfect.best_char_choice = 0;
X  perfect.best_asso_value = 0;
X  read_keys ();
X  if (OPTION_ENABLED (option, ORDER))
X    reorder ();
X
X  asso_value_max = GET_ASSO_MAX (option);
X  len            = length ();
X  
X  asso_value_max = (asso_value_max ? asso_value_max * len : len);
X  SET_ASSO_MAX (option, POW (asso_value_max));
X  
X  if (OPTION_ENABLED (option, RANDOM))
X    {
X      int i;
X
X      srandom (time (0));
X      
X      for (i = 0; i < ALPHABET_SIZE; i++)
X        asso_values[i] = (random () & asso_value_max - 1);
X      
X    }
X  else
X    {
X      int asso_value = INITIAL_VALUE (option);
X      
X      if (asso_value)           /* Initialize array if user requests non-zero default. */
X        {
X          int i;
X
X          for (i = ALPHABET_SIZE - 1; i >= 0; i--)
X            asso_values[i] = asso_value & GET_ASSO_MAX (option) - 1;
X
X        }
X    }
X  perfect.max_hash_value = max_key_length () + GET_ASSO_MAX (option) * 
X    (OPTION_ENABLED (option, ALLCHARS) ? max_key_length () : TOTAL_POSITIONS (option));
X  
X  if (OPTION_ENABLED (option, DEBUG))
X    fprintf (stderr, "number of keys = %d\nmaximum associated value is %d\
X\nmaximum size of hash table is %d\n", len, asso_value_max, perfect.max_hash_value);
X}
X
X/* Merge two disjoint hash key sets to form the ordered union of the sets.
X   Precondition: both set_1 and set_2 must be ordered. Returns the length
X   of the combined set. */
X
Xstatic int 
Xmerge_sets (set_1, set_2, set_3)
X     char *set_1;
X     char *set_2;
X     char *set_3;
X{
X  char *base = set_3;
X  
X  while (*set_1 && *set_2)
X    if (*set_1 == *set_2)
X      *set_3++ = *set_1++, set_2++; 
X    else
X      *set_3++ = *set_1 < *set_2 ? *set_1++ : *set_2++;
X  
X  while (*set_1)
X    *set_3++ = *set_1++; 
X  
X  while (*set_2)
X    *set_3++ = *set_2++; 
X  
X  *set_3 = '\0';
X  return set_3 - base;
X}
X
X/* Sort the UNION_SET in increasing frequency of occurrence.
X   This speeds up later processing since we may assume the resulting
X   set (Set_3, in this case), is ordered. Uses insertion sort, since
X   the UNION_SET is typically short. */
X  
Xstatic void 
Xsort_set (union_set, len)
X     char *union_set;
X     int   len;
X{
X  int i, j;
X  
X  for (i = 0, j = len - 1; i < j; i++)
X    {
X      char curr, tmp;
X
X      for (curr = i+1, tmp = union_set[curr]; 
X           curr>0 && occurrences[tmp] < occurrences[union_set[curr-1]]; 
X           curr--)
X        union_set[curr] = union_set[curr - 1];
X      
X      union_set[curr] = tmp;
X    }
X}
X
X/* Generate a key set's hash value. */
X
Xstatic int 
Xhash (key_node)
X     LIST_NODE *key_node;
X{                             
X  int   sum = OPTION_ENABLED (option, NOLENGTH) ? 0 : key_node->length;
X  char *ptr;
X
X  for (ptr = key_node->key_set; *ptr; ptr++)
X      sum += asso_values[*ptr];
X  
X  return key_node->hash_value = sum;
X}
X
X/* Find out how character value change affects successfully hashed items.
X   Returns FALSE if no other hash values are affected, else returns TRUE.
X   Note that because Option.Get_Asso_Max is a power of two we can guarantee
X   that all legal Asso_Values are visited without repetition since
X   Option.Get_Jump was forced to be an odd value! */
X
Xstatic bool 
Xaffects_prev (c, curr)
X     char c;
X     LIST_NODE *curr;
X{
X  int original_char = asso_values[c];
X  int i = !OPTION_ENABLED (option, FAST) ? GET_ASSO_MAX (option) :
X    GET_ITERATIONS (option) == 0 ? key_list.list_len : GET_ITERATIONS (option);
X
X  /* Try all legal asso_values. */
X
X  while (--i >= 0)
X    { 
X      int        number_of_hits = 0;
X      LIST_NODE *ptr;
X
X      asso_values[c] = asso_values[c] + (OPTION_ENABLED (option, FAST) ? random () : GET_JUMP (option))
X        & GET_ASSO_MAX (option) - 1;
X      bool_array_reset ();       /* Ullman's array is a win, O(1) intialization time! */
X      
X      for (ptr = key_list.head; ; ptr = ptr->next)
X        {
X          if (lookup (hash (ptr)) && ++number_of_hits >= perfect.fewest_hits)
X            goto bottom_of_main_loop;
X          if (ptr == curr)
X            break;
X        }    
X      
X      perfect.best_asso_value  = asso_values[perfect.best_char_choice = c];
X      if ((perfect.fewest_hits = number_of_hits) == 0) /* Use if 0 hits for this value. */
X        return FALSE;        
X      
X    bottom_of_main_loop: ;
X    }
X  
X  asso_values[c] = original_char; /* Restore original values, no more tries. */
X  return TRUE; /* If we're this far it's time to try the next character.... */
X}
X
X#ifdef sparc
X#include <alloca.h>
X#endif
X
X/* Change a character value, try least-used characters first. */
X
Xstatic void 
Xchange (prior, curr)
X     LIST_NODE *prior;
X     LIST_NODE *curr;
X{
X  char      *union_set = (char *) alloca (2 * TOTAL_POSITIONS (option) + 1);
X  int        i = 1;
X  char      *temp;
X  LIST_NODE *ptr;
X
X  if (OPTION_ENABLED (option, DEBUG))        /* Very useful for debugging. */
X    fprintf (stderr, "collision, prior->key = %s, curr->key = %s, hash_value = %d\n",
X             prior->key, curr->key, curr->hash_value);
X  sort_set (union_set, merge_sets (prior->uniq_set, curr->uniq_set, union_set));
X  
X  /* Try changing some values, if change doesn't alter other values continue normal action. */
X  
X  perfect.fewest_hits = length ();
X  
X  for (temp = union_set; *temp; temp++)
X    if (!affects_prev (*temp, curr))
X      return; /* Good, doesn't affect previous hash values, we'll take it. */
X  
X  asso_values[perfect.best_char_choice] = perfect.best_asso_value; /* If none work take best value. */
X  
X  for (ptr = key_list.head; ; ptr = ptr->next, i++)
X    {
X      hash (ptr);
X      if (ptr == curr)
X        break;
X    }           
X  
X  if (OPTION_ENABLED (option, DEBUG))
X    fprintf (stderr, "changes on %d hash values still produce duplicates, continuing...\n", i);
X}
X
X/* Does the hard stuff....
X   Initializes the Ullman_Array, and then attempts to find a Perfect
X   function that will hash all the key words without getting any
X   duplications.  This is made much easier since we aren't attempting
X   to generate *minimum* functions, only Perfect ones.
X   If we can't generate a Perfect function in one pass *and* the user
X   hasn't enabled the DUP option, we'll inform the user to try the
X   randomization option, use -D, or choose alternative key positions.  
X   The alternatives (e.g., back-tracking) are too time-consuming, i.e,
X   exponential in the number of keys. */
X
Xint
Xperfect_generate ()
X{
X  LIST_NODE *curr;
X  bool_array_init (perfect.max_hash_value);
X  hash (key_list.head);
X  
X  for (curr = key_list.head->next; curr; curr = curr->next)
X    {
X      LIST_NODE *ptr;
X      hash (curr);
X      
X      for (ptr = key_list.head; ptr != curr; ptr = ptr->next)
X        if (ptr->hash_value == curr->hash_value)
X          {
X            change (ptr, curr);
X            break;
X          }
X    } 
X  
X  /* Make one final check, just to make sure nothing weird happened.... */
X  
X  for (bool_array_reset (), curr = key_list.head; curr; curr = curr->next)
X    if (lookup (hash (curr)))
X      if (OPTION_ENABLED (option, DUP)) /* We'll try to deal with this later..... */
X        break;
X      else /* Yow, big problems.  we're outta here! */
X        { 
X          report_error ("\nInternal error, duplicate value %d:\ntry options -D or -r, or use new key positions.\n\n", 
X                        hash (curr));
X          return 1;
X        }
X
X  /* First sorts the key word list by hash value, and the outputs the
X     list to the proper ostream. The generated hash table code is only 
X     output if the early stage of processing turned out O.K. */
X
X  sort ();
X  print_output ();
X  return 0;
X}
X
X/* Prints out some diagnostics upon completion. */
X
Xvoid 
Xperfect_destroy ()
X{                             
X  if (OPTION_ENABLED (option, DEBUG))
X    {
X      int i;
X
X      fprintf (stderr, "\ndumping occurrence and associated values tables\n");
X      
X      for (i = 0; i < ALPHABET_SIZE; i++)
X        if (occurrences[i])
X          fprintf (stderr, "asso_values[%c] = %3d, occurrences[%c] = %3d\n",
X                   i, asso_values[i], i, occurrences[i]);
X      
X      fprintf (stderr, "end table dumping\n");
X      
X    }
X}
X
END_OF_FILE
if test 9830 -ne `wc -c <'cperf/src/perfect.c'`; then
    echo shar: \"'cperf/src/perfect.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/perfect.c'
fi
echo shar: End of archive 2 \(of 5\).
cp /dev/null ark2isdone
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

