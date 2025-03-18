#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of archive 3 (of 5)."
# Contents:  cperf/COPYING cperf/src/options.c
# Wrapped by schmidt@crimee.ics.uci.edu on Wed Oct 18 11:43:32 1989
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'cperf/COPYING' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/COPYING'\"
else
echo shar: Extracting \"'cperf/COPYING'\" \(12488 characters\)
sed "s/^X//" >'cperf/COPYING' <<'END_OF_FILE'
X
X		    GNU GENERAL PUBLIC LICENSE
X		     Version 1, February 1989
X
X Copyright (C) 1989 Free Software Foundation, Inc.
X                    675 Mass Ave, Cambridge, MA 02139, USA
X Everyone is permitted to copy and distribute verbatim copies
X of this license document, but changing it is not allowed.
X
X			    Preamble
X
X  The license agreements of most software companies try to keep users
Xat the mercy of those companies.  By contrast, our General Public
XLicense is intended to guarantee your freedom to share and change free
Xsoftware--to make sure the software is free for all its users.  The
XGeneral Public License applies to the Free Software Foundation's
Xsoftware and to any other program whose authors commit to using it.
XYou can use it for your programs, too.
X
X  When we speak of free software, we are referring to freedom, not
Xprice.  Specifically, the General Public License is designed to make
Xsure that you have the freedom to give away or sell copies of free
Xsoftware, that you receive source code or can get it if you want it,
Xthat you can change the software or use pieces of it in new free
Xprograms; and that you know you can do these things.
X
X  To protect your rights, we need to make restrictions that forbid
Xanyone to deny you these rights or to ask you to surrender the rights.
XThese restrictions translate to certain responsibilities for you if you
Xdistribute copies of the software, or if you modify it.
X
X  For example, if you distribute copies of a such a program, whether
Xgratis or for a fee, you must give the recipients all the rights that
Xyou have.  You must make sure that they, too, receive or can get the
Xsource code.  And you must tell them their rights.
X
X  We protect your rights with two steps: (1) copyright the software, and
X(2) offer you this license which gives you legal permission to copy,
Xdistribute and/or modify the software.
X
X  Also, for each author's protection and ours, we want to make certain
Xthat everyone understands that there is no warranty for this free
Xsoftware.  If the software is modified by someone else and passed on, we
Xwant its recipients to know that what they have is not the original, so
Xthat any problems introduced by others will not reflect on the original
Xauthors' reputations.
X
X  The precise terms and conditions for copying, distribution and
Xmodification follow.
X
X		    GNU GENERAL PUBLIC LICENSE
X   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
X
X  0. This License Agreement applies to any program or other work which
Xcontains a notice placed by the copyright holder saying it may be
Xdistributed under the terms of this General Public License.  The
X"Program", below, refers to any such program or work, and a "work based
Xon the Program" means either the Program or any work containing the
XProgram or a portion of it, either verbatim or with modifications.  Each
Xlicensee is addressed as "you".
X
X  1. You may copy and distribute verbatim copies of the Program's source
Xcode as you receive it, in any medium, provided that you conspicuously and
Xappropriately publish on each copy an appropriate copyright notice and
Xdisclaimer of warranty; keep intact all the notices that refer to this
XGeneral Public License and to the absence of any warranty; and give any
Xother recipients of the Program a copy of this General Public License
Xalong with the Program.  You may charge a fee for the physical act of
Xtransferring a copy.
X
X  2. You may modify your copy or copies of the Program or any portion of
Xit, and copy and distribute such modifications under the terms of Paragraph
X1 above, provided that you also do the following:
X
X    a) cause the modified files to carry prominent notices stating that
X    you changed the files and the date of any change; and
X
X    b) cause the whole of any work that you distribute or publish, that
X    in whole or in part contains the Program or any part thereof, either
X    with or without modifications, to be licensed at no charge to all
X    third parties under the terms of this General Public License (except
X    that you may choose to grant warranty protection to some or all
X    third parties, at your option).
X
X    c) If the modified program normally reads commands interactively when
X    run, you must cause it, when started running for such interactive use
X    in the simplest and most usual way, to print or display an
X    announcement including an appropriate copyright notice and a notice
X    that there is no warranty (or else, saying that you provide a
X    warranty) and that users may redistribute the program under these
X    conditions, and telling the user how to view a copy of this General
X    Public License.
X
X    d) You may charge a fee for the physical act of transferring a
X    copy, and you may at your option offer warranty protection in
X    exchange for a fee.
X
XMere aggregation of another independent work with the Program (or its
Xderivative) on a volume of a storage or distribution medium does not bring
Xthe other work under the scope of these terms.
X
X  3. You may copy and distribute the Program (or a portion or derivative of
Xit, under Paragraph 2) in object code or executable form under the terms of
XParagraphs 1 and 2 above provided that you also do one of the following:
X
X    a) accompany it with the complete corresponding machine-readable
X    source code, which must be distributed under the terms of
X    Paragraphs 1 and 2 above; or,
X
X    b) accompany it with a written offer, valid for at least three
X    years, to give any third party free (except for a nominal charge
X    for the cost of distribution) a complete machine-readable copy of the
X    corresponding source code, to be distributed under the terms of
X    Paragraphs 1 and 2 above; or,
X
X    c) accompany it with the information you received as to where the
X    corresponding source code may be obtained.  (This alternative is
X    allowed only for noncommercial distribution and only if you
X    received the program in object code or executable form alone.)
X
XSource code for a work means the preferred form of the work for making
Xmodifications to it.  For an executable file, complete source code means
Xall the source code for all modules it contains; but, as a special
Xexception, it need not include source code for modules which are standard
Xlibraries that accompany the operating system on which the executable
Xfile runs, or for standard header files or definitions files that
Xaccompany that operating system.
X
X  4. You may not copy, modify, sublicense, distribute or transfer the
XProgram except as expressly provided under this General Public License.
XAny attempt otherwise to copy, modify, sublicense, distribute or transfer
Xthe Program is void, and will automatically terminate your rights to use
Xthe Program under this License.  However, parties who have received
Xcopies, or rights to use copies, from you under this General Public
XLicense will not have their licenses terminated so long as such parties
Xremain in full compliance.
X
X  5. By copying, distributing or modifying the Program (or any work based
Xon the Program) you indicate your acceptance of this license to do so,
Xand all its terms and conditions.
X
X  6. Each time you redistribute the Program (or any work based on the
XProgram), the recipient automatically receives a license from the original
Xlicensor to copy, distribute or modify the Program subject to these
Xterms and conditions.  You may not impose any further restrictions on the
Xrecipients' exercise of the rights granted herein.
X
X  7. The Free Software Foundation may publish revised and/or new versions
Xof the General Public License from time to time.  Such new versions will
Xbe similar in spirit to the present version, but may differ in detail to
Xaddress new problems or concerns.
X
XEach version is given a distinguishing version number.  If the Program
Xspecifies a version number of the license which applies to it and "any
Xlater version", you have the option of following the terms and conditions
Xeither of that version or of any later version published by the Free
XSoftware Foundation.  If the Program does not specify a version number of
Xthe license, you may choose any version ever published by the Free Software
XFoundation.
X
X  8. If you wish to incorporate parts of the Program into other free
Xprograms whose distribution conditions are different, write to the author
Xto ask for permission.  For software which is copyrighted by the Free
XSoftware Foundation, write to the Free Software Foundation; we sometimes
Xmake exceptions for this.  Our decision will be guided by the two goals
Xof preserving the free status of all derivatives of our free software and
Xof promoting the sharing and reuse of software generally.
X
X			    NO WARRANTY
X
X  9. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
XFOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
XOTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
XPROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
XOR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
XMERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
XTO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
XPROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
XREPAIR OR CORRECTION.
X
X  10. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
XWILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
XREDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
XINCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
XOUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
XTO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
XYOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
XPROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
XPOSSIBILITY OF SUCH DAMAGES.
X
X		     END OF TERMS AND CONDITIONS
X
X	Appendix: How to Apply These Terms to Your New Programs
X
X  If you develop a new program, and you want it to be of the greatest
Xpossible use to humanity, the best way to achieve this is to make it
Xfree software which everyone can redistribute and change under these
Xterms.
X
X  To do so, attach the following notices to the program.  It is safest to
Xattach them to the start of each source file to most effectively convey
Xthe exclusion of warranty; and each file should have at least the
X"copyright" line and a pointer to where the full notice is found.
X
X    <one line to give the program's name and a brief idea of what it does.>
X    Copyright (C) 19yy  <name of author>
X
X    This program is free software; you can redistribute it and/or modify
X    it under the terms of the GNU General Public License as published by
X    the Free Software Foundation; either version 1, or (at your option)
X    any later version.
X
X    This program is distributed in the hope that it will be useful,
X    but WITHOUT ANY WARRANTY; without even the implied warranty of
X    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
X    GNU General Public License for more details.
X
X    You should have received a copy of the GNU General Public License
X    along with this program; if not, write to the Free Software
X    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
X
XAlso add information on how to contact you by electronic and paper mail.
X
XIf the program is interactive, make it output a short notice like this
Xwhen it starts in an interactive mode:
X
X    Gnomovision version 69, Copyright (C) 19xx name of author
X    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
X    This is free software, and you are welcome to redistribute it
X    under certain conditions; type `show c' for details.
X
XThe hypothetical commands `show w' and `show c' should show the
Xappropriate parts of the General Public License.  Of course, the
Xcommands you use may be called something other than `show w' and `show
Xc'; they could even be mouse-clicks or menu items--whatever suits your
Xprogram.
X
XYou should also get your employer (if you work as a programmer) or your
Xschool, if any, to sign a "copyright disclaimer" for the program, if
Xnecessary.  Here a sample; alter the names:
X
X  Yoyodyne, Inc., hereby disclaims all copyright interest in the
X  program `Gnomovision' (a program to direct compilers to make passes
X  at assemblers) written by James Hacker.
X
X  <signature of Ty Coon>, 1 April 1989
X  Ty Coon, President of Vice
X
XThat's all there is to it!
END_OF_FILE
if test 12488 -ne `wc -c <'cperf/COPYING'`; then
    echo shar: \"'cperf/COPYING'\" unpacked with wrong size!
fi
# end of 'cperf/COPYING'
fi
if test -f 'cperf/src/options.c' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/src/options.c'\"
else
echo shar: Extracting \"'cperf/src/options.c'\" \(16861 characters\)
sed "s/^X//" >'cperf/src/options.c' <<'END_OF_FILE'
X/* Handles parsing the Options provided to the user.
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
X#include "options.h"
X#include "iterator.h"
X#include "stderr.h"
X
X/* Current program version. */
Xextern char *version_string;
X
X/* Size to jump on a collision. */
X#define DEFAULT_JUMP_VALUE 5
X
X/* Default name for generated lookup function. */
X#define DEFAULT_NAME "in_word_set"
X
X/* Default name for the key component. */
X#define DEFAULT_KEY "name"
X
X/* Default name for generated hash function. */
X#define DEFAULT_HASH_NAME "hash"
X
X/* Globally visible OPTIONS object. */
XOPTIONS option;
X
X/* Prints program usage to standard error stream. */
X
Xvoid 
Xusage ()
X{ 
X  report_error ("usage: %n [-acCdDf[num]gGhH<hashname>i<init>jk<keys>K<keyname>lnN<name>oprs<size>StTv].\n(type %n -h for help)\n");
X}
X
X/* Sorts the key positions *IN REVERSE ORDER!!*
X   This makes further routines more efficient.  Especially when generating code.
X   Uses a simple Insertion Sort since the set is probably ordered.
X   Returns 1 if there are no duplicates, 0 otherwise. */
X
Xstatic int 
Xkey_sort (base, len)
X     char *base;
X     int   len;
X{
X  int i, j;
X
X  for (i = 0, j = len - 1; i < j; i++) 
X    {
X      int curr, tmp;
X      
X      for (curr = i + 1,tmp = base[curr]; curr > 0 && tmp >= base[curr - 1]; curr--) 
X        if ((base[curr] = base[curr - 1]) == tmp) /* oh no, a duplicate!!! */
X          return 0;
X
X      base[curr] = tmp;
X    }
X
X  return 1;
X}
X
X/* Dumps option status when debug is set. */
X
Xvoid
Xoptions_destroy ()
X{ 
X  if (OPTION_ENABLED (option, DEBUG))
X    {
X      fprintf (stderr, "\ndumping Options:\nDEBUG is.......: %s\nORDER is.......: %s\
X\nANSI is........: %s\nTYPE is........: %s\nGNU is.........: %s\nRANDOM is......: %s\
X\nDEFAULTCHARS is: %s\nSWITCH is......: %s\nPOINTER is.....: %s\nNOLENGTH is....: %s\
X\nLENTABLE is....: %s\nDUP is.........: %s\nCOMP is........: %s\nFAST is........: %s\
X\nNOTYPE is....: %s\nGLOBAL is.........: %s\nCONST is.........: %s\niterations = %d\
X\nlookup function name = %s\nhash function name = %s\nkey name = %s\
X\njump value = %d\nmax associcated value = %d\ninitial associated value = %d\n",
X               OPTION_ENABLED (option, DEBUG) ? "enabled" : "disabled", 
X               OPTION_ENABLED (option, ORDER) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, ANSI) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, TYPE) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, GNU) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, RANDOM) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, DEFAULTCHARS) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, SWITCH) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, POINTER) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, NOLENGTH) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, LENTABLE) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, DUP) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, COMP) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, FAST) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, NOTYPE) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, GLOBAL) ? "enabled" : "disabled",
X               OPTION_ENABLED (option, CONST) ? "enabled" : "disabled",
X               option.iterations, option.function_name, option.hash_name,
X               option.key_name, option.jump, option.size - 1, option.initial_asso_value);
X
X      if (OPTION_ENABLED (option, ALLCHARS)) 
X        fprintf (stderr, "all characters are used in the hash function\n");
X      else 
X        {       
X          char *ptr;
X
X          fprintf (stderr, "total key positions = %d\nkey positions are: \n", option.total_key_positions);
X
X          for (ptr = option.key_positions; *ptr != EOS; ptr++) 
X            if (*ptr == WORD_END) 
X              fprintf (stderr, "$\n");
X            else 
X              fprintf (stderr, "%d\n", *ptr);
X
X          fprintf (stderr, "finished dumping Options\n");
X        }
X    }
X}
X
X/* Parses the command line Options and sets appropriate flags in option.option_word. */
X
Xvoid
Xoptions_init (argc, argv)
X     int argc;
X     char *argv[];
X{ 
X  extern int   optind;
X  extern char *optarg;
X  int   option_char;
X  
X  option.key_positions[0]    = WORD_START;
X  option.key_positions[1]    = WORD_END;
X  option.key_positions[2]    = EOS;
X  option.total_key_positions = 2;
X  option.jump                = DEFAULT_JUMP_VALUE;
X  option.option_word         = (int) DEFAULTCHARS;
X  option.function_name       = DEFAULT_NAME;
X  option.hash_name           = DEFAULT_HASH_NAME;
X  option.key_name            = DEFAULT_KEY;
X  option.initial_asso_value  = option.size = option.iterations = 0;
X  set_program_name (argv[0]);
X  option.argument_count  = argc;
X  option.argument_vector = argv;
X  
X  while ((option_char = getopt (argc, argv, "adcCDf:gGhH:i:j:k:K:lnN:oprs:StTv")) != EOF) 
X    {
X      switch (option_char)
X        {
X        case 'a':               /* Generated coded uses the ANSI prototype format. */
X          { 
X            SET_OPTION (option, ANSI);
X            break;
X          }
X        case 'c':               /* Generate strncmp rather than strcmp. */
X          {
X            SET_OPTION (option, COMP);
X            break;
X          }
X        case 'C':               /* Make the generated tables readonly (const). */
X          {
X            SET_OPTION (option, CONST);
X            break;
X          }
X        case 'd':               /* Enable debugging option. */
X          { 
X            SET_OPTION (option, DEBUG);
X            report_error ("starting program %n, version %s, with debuggin on.\n",
X                          version_string);
X            break;
X          }   
X        case 'D':               /* Enable duplicate option. */
X          { 
X            SET_OPTION (option, DUP);
X            break;
X          }   
X        case 'f':               /* Generate the hash table ``fast.'' */
X          {
X            SET_OPTION (option, FAST);
X            if ((option.iterations = atoi (optarg)) < 0) 
X              {
X                report_error ("iterations value must not be negative, assuming 0\n");
X                option.iterations = 0;
X              }
X            break;
X          }
X        case 'g':               /* Use the ``inline'' keyword for generated sub-routines. */
X          { 
X            SET_OPTION (option, GNU);
X            break;
X          }
X        case 'G':               /* Make the keyword table a global variable. */
X          { 
X            SET_OPTION (option, GLOBAL);
X            break;
X          }
X        case 'h':               /* Displays a list of helpful Options to the user. */
X          { 
X            report_error (
X                          "-a\tGenerate ANSI standard C output code, i.e., function prototypes.\n\
X-c\tGenerate comparison code using strncmp rather than strcmp.\n\
X-C\tMake the contents of generated lookup tables constant, i.e., readonly.\n\
X-d\tEnables the debugging option (produces verbose output to Std_Err).\n\
X-D\tHandle keywords that hash to duplicate values.  This is useful\n\
X\tfor certain highly redundant keyword sets.  It enables the -S option.\n\
X-f\tGenerate the perfect hash function ``fast.''  This decreases GPERF's\n\
X\trunning time at the cost of minimizing generated table-size.\n\
X\tThe numeric argument represents the number of times to iterate when\n\
X\tresolving a collision.  `0' means ``iterate by the number of keywords''.\n\
X-g\tAssume a GNU compiler, e.g., g++ or gcc.  This makes all generated\n\
X\troutines use the ``inline'' keyword to remove cost of function calls.\n\
X-G\tGenerate the static table of keywords as a static global variable,\n\
X\trather than hiding it inside of the lookup function (which is the\n\
X\tdefault behavior).\n\
X-h\tPrints this mesage.\n\
X-H\tAllow user to specify name of generated hash function. Default\n\
X\tis `hash'.\n\
X-i\tProvide an initial value for the associate values array.  Default is 0.\n\
X\tSetting this value larger helps inflate the size of the final table.\n\
X-j\tAffects the ``jump value,'' i.e., how far to advance the associated\n\
X\tcharacter value upon collisions.  Must be an odd number, default is %d.\n\
X-k\tAllows selection of the key positions used in the hash function.\n\
X\tThe allowable choices range between 1-%d, inclusive.  The positions\n\
X\tare separated by commas, ranges may be used, and key positions may\n\
X\toccur in any order.  Also, the meta-character '*' causes the generated\n\
X\thash function to consider ALL key positions, and $ indicates the\n\
X\t``final character'' of a key, e.g., $,1,2,4,6-10.\n\
X-K\tAllow user to select name of the keyword component in the keyword structure.\n\
X-l\tCompare key lengths before trying a string comparison.  This helps\n\
X\tcut down on the number of string comparisons made during the lookup.\n\
X-n\tDo not include the length of the keyword when computing the hash function\n\
X-N\tAllow user to specify name of generated lookup function.  Default\n\
X\tname is `in_word_set.'\n\
X-o\tReorders input keys by frequency of occurrence of the key sets.\n\
X\tThis should decrease the search time dramatically.\n\
X-p\tChanges the return value of the generated function ``in_word_set''\n\
X\tfrom its default boolean value (i.e., 0 or 1), to type ``pointer\n\
X\tto wordlist array''  This is most useful when the -t option, allowing\n\
X\tuser-defined structs, is used.\n\
X-r\tUtilizes randomness to initialize the associated values table.\n\
X-s\tAffects the size of the generated hash table.  The numeric argument\n\
X\tfor this option indicates ``how many times larger'' the table range\n\
X\tshould be, in relationship to the number of keys, e.g. a value of 3\n\
X\tmeans ``make the table about 3 times larger than the number of input\n\
X\tkeys.''  A larger table should decrease the time required for an\n\
X\tunsuccessful search, at the expense of extra table space.  Default\n\
X\tvalue is 1.  This actual table size may vary somewhat.\n\
X-S\tCauses the generated C code to use a switch statement scheme, rather\n\
X\tthan an array lookup table.  This potentially saves *much* space, at\n\
X\tthe expense of longer time for each lookup.  Mostly important for\n\
X\t*large* input sets, i.e., greater than around 100 items or so.\n\
X-t\tAllows the user to include a structured type declaration for \n\
X\tgenerated code. Any text before %%%% is consider part of the type\n\
X\tdeclaration.  Key words and additional fields may follow this, one\n\
X\tgroup of fields per line.\n\
X-T\tPrevents the transfer of the type declaration to the output file.\n\
X\tUse this option if the type is already defined elsewhere.\n\
X-v\tPrints out the current version number\n%e%a\n",
X                          DEFAULT_JUMP_VALUE, (MAX_KEY_POS - 1), usage);
X          }
X        case 'H':               /* Sets the name for the hash function */
X          {
X            option.hash_name = optarg;
X            break;
X          }
X        case 'i':               /* Sets the initial value for the associated values array. */
X          { 
X            if ((option.initial_asso_value = atoi (optarg)) < 0) 
X              report_error ("initial value %d must be non-zero, ignoring and continuing\n", option.initial_asso_value);
X            break;
X          }
X        case 'j':               /* Sets the jump value, must be odd for later algorithms. */
X          { 
X            if ((option.jump = atoi (optarg)) <= 0) 
X              report_error ("jump value %d must be a positive number\n%e%a", option.jump, usage);
X            else if (EVEN (option.jump)) 
X              report_error ("jump value %d should be odd, adding 1 and continuing...\n", option.jump++);
X            break;
X          }
X        case 'k':               /* Sets key positions used for hash function. */
X          { 
X            int BAD_VALUE = -1;
X            int value;
X
X            iterator_init (optarg, 1, MAX_KEY_POS - 1, WORD_END, BAD_VALUE, EOS);
X            
X            if (*optarg == '*') /* Use all the characters for hashing!!!! */
X              {
X                UNSET_OPTION (option, DEFAULTCHARS);
X                SET_OPTION (option, ALLCHARS);
X              }
X            else 
X              {
X                char *key_pos;
X
X                for (key_pos = option.key_positions; (value = next ()) != EOS; key_pos++)
X                  if (value == BAD_VALUE) 
X                    report_error ("illegal key value or range, use 1,2,3-%d,'$' or '*'.\n%e%a", (MAX_KEY_POS - 1),usage);
X                  else 
X                    *key_pos = value;;
X
X                *key_pos = EOS;
X
X                if (! (option.total_key_positions = (key_pos - option.key_positions))) 
X                  report_error ("no keys selected\n%e%a", usage);
X                else if (! key_sort (option.key_positions, option.total_key_positions))
X                  report_error ("duplicate keys selected\n%e%a", usage);
X
X                if (option.total_key_positions != 2 
X                    || (option.key_positions[0] != 1 || option.key_positions[1] != WORD_END))
X                  UNSET_OPTION (option, DEFAULTCHARS);
X              }
X            break;
X          }
X        case 'K':               /* Make this the keyname for the keyword component field. */
X          {
X            option.key_name = optarg;
X            break;
X          }
X        case 'l':               /* Create length table to avoid extra string compares. */
X          { 
X            SET_OPTION (option, LENTABLE);
X            break;
X          }
X        case 'n':               /* Don't include the length when computing hash function. */
X          { 
X            SET_OPTION (option, NOLENGTH);
X            break; 
X          }
X        case 'N':               /* Make generated lookup function name be optarg */
X          { 
X            option.function_name = optarg;
X            break;
X          }
X        case 'o':               /* Order input by frequency of key set occurrence. */
X          { 
X            SET_OPTION (option, ORDER);
X            break;
X          }   
X        case 'p':               /* Generated lookup function now a pointer instead of int. */
X          { 
X            SET_OPTION (option, POINTER);
X            break;
X          }
X        case 'r':               /* Utilize randomness to initialize the associated values table. */
X          { 
X            SET_OPTION (option, RANDOM);
X            break;
X          }
X        case 's':               /* Range of associated values, determines size of final table. */
X          { 
X            if ((option.size = atoi (optarg)) <= 0) 
X              report_error ("improper range argument %s\n%e%a", optarg, usage);
X            else if (option.size > 50) 
X              report_error ("%d is excessive, did you really mean this?! (type %n -h for help)\n", option.size);
X            break; 
X          }       
X        case 'S':               /* Generate switch statement output, rather than lookup table. */
X          { 
X            SET_OPTION (option, SWITCH);
X            break;
X          }
X        case 't':               /* Enable the TYPE mode, allowing arbitrary user structures. */
X          { 
X            SET_OPTION (option, TYPE);
X            break;
X          }
X        case 'T':               /* Don't print structure definition. */
X          {
X            SET_OPTION (option, NOTYPE);
X            break;
X          }
X        case 'v':               /* Print out the version and quit. */
X          report_error ("%n: version %s\n%e%a\n", version_string, usage);
X        default: 
X          report_error ("%e%a", usage);
X        }
X    }
X
X  if (argv[optind] && ! freopen (argv[optind], "r", stdin))
X    report_error ("unable to read key word file %s\n%e%a", argv[optind], usage);
X  
X  if (++optind < argc) 
X    report_error ("extra trailing arguments to %n\n%e%a", usage);
X}
X
X/* Output command-line Options. */
Xvoid 
Xprint_options ()
X{ 
X  int i;
X
X  printf ("/* Command-line: ");
X
X  for (i = 0; i < option.argument_count; i++) 
X    printf ("%s ", option.argument_vector[i]);
X   
X  printf (" */\n\n");
X}
X
END_OF_FILE
if test 16861 -ne `wc -c <'cperf/src/options.c'`; then
    echo shar: \"'cperf/src/options.c'\" unpacked with wrong size!
fi
# end of 'cperf/src/options.c'
fi
echo shar: End of archive 3 \(of 5\).
cp /dev/null ark3isdone
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

