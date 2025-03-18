#! /bin/sh
# This is a shell archive.  Remove anything before this line, then unpack
# it by saving it into a file and typing "sh file".  To overwrite existing
# files, type "sh file -c".  You can also feed this as standard input via
# unshar, or by typing "sh <file", e.g..  If this archive is complete, you
# will see the following message at the end:
#		"End of archive 5 (of 5)."
# Contents:  cperf/gperf.texinfo
# Wrapped by schmidt@crimee.ics.uci.edu on Wed Oct 18 11:43:33 1989
PATH=/bin:/usr/bin:/usr/ucb ; export PATH
if test -f 'cperf/gperf.texinfo' -a "${1}" != "-c" ; then 
  echo shar: Will not clobber existing file \"'cperf/gperf.texinfo'\"
else
echo shar: Extracting \"'cperf/gperf.texinfo'\" \(45171 characters\)
sed "s/^X//" >'cperf/gperf.texinfo' <<'END_OF_FILE'
X\input texinfo  @c -*-texinfo-*-
X
X@settitle User's Guide to GPERF
X@setfilename gperf-info
X
X@ifinfo
XThis file documents the features of the GNU Perfect Hash Function Generator
X
XCopyright (C) 1989 Free Software Foundation, Inc.
X
XPermission is granted to make and distribute verbatim copies of
Xthis manual provided the copyright notice and this permission notice
Xare preserved on all copies.
X
X@ignore
XPermission is granted to process this file through @TeX{} and print the
Xresults, provided the printed document carries copying permission
Xnotice identical to this one except for the removal of this paragraph
X(this paragraph not being relevant to the printed manual).
X
X@end ignore
X
XPermission is granted to copy and distribute modified versions of this
Xmanual under the conditions for verbatim copying, provided also that the
Xsection entitled ``GNU General Public License'' is included exactly as
Xin the original, and provided that the entire resulting derived work is
Xdistributed under the terms of a permission notice identical to this one.
X
XPermission is granted to copy and distribute translations of this manual
Xinto another language, under the above conditions for modified versions,
Xexcept that the section entitled ``GNU GPERF General Public License'' and
Xthis permission notice may be included in translations approved by the
XFree Software Foundation instead of in the original English.
X@end ifinfo
X
X@setchapternewpage odd
X
X@titlepage
X@center @titlefont{User's Guide}
X@sp 2
X@center @titlefont{for the}
X@sp 2
X@center @titlefont{GNU GPERF Utility}
X@sp 4
X@center Douglas C. Schmidt
X@sp 3
X@center last updated 23 May 1989
X@sp 1
X@center for version 1.7
X@page
X@vskip 0pt plus 1filll
XCopyright @copyright{} 1989 Free Software Foundation, Inc.
X
X
XPermission is granted to make and distribute verbatim copies of
Xthis manual provided the copyright notice and this permission notice
Xare preserved on all copies.
X
XPermission is granted to copy and distribute modified versions of this
Xmanual under the conditions for verbatim copying, provided also that the
Xsection entitled ``GNU GPERF General Public License'' is included exactly as
Xin the original, and provided that the entire resulting derived work is
Xdistributed under the terms of a permission notice identical to this one.
X
XPermission is granted to copy and distribute translations of this manual
Xinto another language, under the above conditions for modified versions,
Xexcept that the section entitled ``GNU GPERF General Public License'' may be
Xincluded in a translation approved by the author instead of in the original
XEnglish.
X@end titlepage
X
X@ifinfo
X@node Top, Copying, , (DIR)
X@ichapter Introduction
X
XThis manual documents the GNU GPERF perfect hash function generator
Xutility, focusing on its features and how to use them, and how to report
Xbugs.
X
X@end ifinfo
X@menu
X* Copying::         GNU GPERF General Public License says
X                    how you can copy and share GPERF.
X* Contributors::    People who have contributed to GPERF.
X* Motivation::      Static search structures and GNU GPERF.
X* Description::     High-level discussion of how GPERF functions.
X* Options::         A description of options to the program.
X* Bugs::            Known bugs and limitations with GPERF.
X* Projects::        Things still left to do.
X* Implementation::  Implementation Details for GNU GPERF.
X* Bibliography::    Material Referenced in this Report.
X@end menu
X
X@node Copying, Contributors, Top, Top
X@unnumbered GNU GENERAL PUBLIC LICENSE
X@center Version 1, February 1989
X
X@display
XCopyright @copyright{} 1989 Free Software Foundation, Inc.
X675 Mass Ave, Cambridge, MA 02139, USA
X
XEveryone is permitted to copy and distribute verbatim copies
Xof this license document, but changing it is not allowed.
X@end display
X
X@unnumberedsec Preamble
X
X  The license agreements of most software companies try to keep users
Xat the mercy of those companies.  By contrast, our General Public
XLicense is intended to guarantee your freedom to share and change free
Xsoftware---to make sure the software is free for all its users.  The
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
X@iftex
X@unnumberedsec TERMS AND CONDITIONS
X@end iftex
X@ifinfo
X@center TERMS AND CONDITIONS
X@end ifinfo
X
X@enumerate
X@item
XThis License Agreement applies to any program or other work which
Xcontains a notice placed by the copyright holder saying it may be
Xdistributed under the terms of this General Public License.  The
X``Program'', below, refers to any such program or work, and a ``work based
Xon the Program'' means either the Program or any work containing the
XProgram or a portion of it, either verbatim or with modifications.  Each
Xlicensee is addressed as ``you''.
X
X@item
XYou may copy and distribute verbatim copies of the Program's source
Xcode as you receive it, in any medium, provided that you conspicuously and
Xappropriately publish on each copy an appropriate copyright notice and
Xdisclaimer of warranty; keep intact all the notices that refer to this
XGeneral Public License and to the absence of any warranty; and give any
Xother recipients of the Program a copy of this General Public License
Xalong with the Program.  You may charge a fee for the physical act of
Xtransferring a copy.
X
X@item
XYou may modify your copy or copies of the Program or any portion of
Xit, and copy and distribute such modifications under the terms of Paragraph
X1 above, provided that you also do the following:
X
X@itemize @bullet
X@item
Xcause the modified files to carry prominent notices stating that
Xyou changed the files and the date of any change; and
X
X@item
Xcause the whole of any work that you distribute or publish, that
Xin whole or in part contains the Program or any part thereof, either
Xwith or without modifications, to be licensed at no charge to all
Xthird parties under the terms of this General Public License (except
Xthat you may choose to grant warranty protection to some or all
Xthird parties, at your option).
X
X@item
XIf the modified program normally reads commands interactively when
Xrun, you must cause it, when started running for such interactive use
Xin the simplest and most usual way, to print or display an
Xannouncement including an appropriate copyright notice and a notice
Xthat there is no warranty (or else, saying that you provide a
Xwarranty) and that users may redistribute the program under these
Xconditions, and telling the user how to view a copy of this General
XPublic License.
X
X@item
XYou may charge a fee for the physical act of transferring a
Xcopy, and you may at your option offer warranty protection in
Xexchange for a fee.
X@end itemize
X
XMere aggregation of another independent work with the Program (or its
Xderivative) on a volume of a storage or distribution medium does not bring
Xthe other work under the scope of these terms.
X
X@item
XYou may copy and distribute the Program (or a portion or derivative of
Xit, under Paragraph 2) in object code or executable form under the terms of
XParagraphs 1 and 2 above provided that you also do one of the following:
X
X@itemize @bullet
X@item
Xaccompany it with the complete corresponding machine-readable
Xsource code, which must be distributed under the terms of
XParagraphs 1 and 2 above; or,
X
X@item
Xaccompany it with a written offer, valid for at least three
Xyears, to give any third party free (except for a nominal charge
Xfor the cost of distribution) a complete machine-readable copy of the
Xcorresponding source code, to be distributed under the terms of
XParagraphs 1 and 2 above; or,
X
X@item
Xaccompany it with the information you received as to where the
Xcorresponding source code may be obtained.  (This alternative is
Xallowed only for noncommercial distribution and only if you
Xreceived the program in object code or executable form alone.)
X@end itemize
X
XSource code for a work means the preferred form of the work for making
Xmodifications to it.  For an executable file, complete source code means
Xall the source code for all modules it contains; but, as a special
Xexception, it need not include source code for modules which are standard
Xlibraries that accompany the operating system on which the executable
Xfile runs, or for standard header files or definitions files that
Xaccompany that operating system.
X
X@item
XYou may not copy, modify, sublicense, distribute or transfer the
XProgram except as expressly provided under this General Public License.
XAny attempt otherwise to copy, modify, sublicense, distribute or transfer
Xthe Program is void, and will automatically terminate your rights to use
Xthe Program under this License.  However, parties who have received
Xcopies, or rights to use copies, from you under this General Public
XLicense will not have their licenses terminated so long as such parties
Xremain in full compliance.
X
X@item
XBy copying, distributing or modifying the Program (or any work based
Xon the Program) you indicate your acceptance of this license to do so,
Xand all its terms and conditions.
X
X@item
XEach time you redistribute the Program (or any work based on the
XProgram), the recipient automatically receives a license from the original
Xlicensor to copy, distribute or modify the Program subject to these
Xterms and conditions.  You may not impose any further restrictions on the
Xrecipients' exercise of the rights granted herein.
X
X@item
XThe Free Software Foundation may publish revised and/or new versions
Xof the General Public License from time to time.  Such new versions will
Xbe similar in spirit to the present version, but may differ in detail to
Xaddress new problems or concerns.
X
XEach version is given a distinguishing version number.  If the Program
Xspecifies a version number of the license which applies to it and ``any
Xlater version'', you have the option of following the terms and conditions
Xeither of that version or of any later version published by the Free
XSoftware Foundation.  If the Program does not specify a version number of
Xthe license, you may choose any version ever published by the Free Software
XFoundation.
X
X@item
XIf you wish to incorporate parts of the Program into other free
Xprograms whose distribution conditions are different, write to the author
Xto ask for permission.  For software which is copyrighted by the Free
XSoftware Foundation, write to the Free Software Foundation; we sometimes
Xmake exceptions for this.  Our decision will be guided by the two goals
Xof preserving the free status of all derivatives of our free software and
Xof promoting the sharing and reuse of software generally.
X
X@iftex
X@heading NO WARRANTY
X@end iftex
X@ifinfo
X@center NO WARRANTY
X@end ifinfo
X
X@item
XBECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
XFOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
XOTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
XPROVIDE THE PROGRAM ``AS IS'' WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
XOR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
XMERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
XTO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
XPROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
XREPAIR OR CORRECTION.
X
X@item
XIN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL
XANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
XREDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
XINCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES
XARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT
XLIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES
XSUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE
XWITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN
XADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
X@end enumerate
X
X@iftex
X@heading END OF TERMS AND CONDITIONS
X@end iftex
X@ifinfo
X@center END OF TERMS AND CONDITIONS
X@end ifinfo
X
X@page
X@unnumberedsec Appendix: How to Apply These Terms to Your New Programs
X
X  If you develop a new program, and you want it to be of the greatest
Xpossible use to humanity, the best way to achieve this is to make it
Xfree software which everyone can redistribute and change under these
Xterms.
X
X  To do so, attach the following notices to the program.  It is safest to
Xattach them to the start of each source file to most effectively convey
Xthe exclusion of warranty; and each file should have at least the
X``copyright'' line and a pointer to where the full notice is found.
X
X@smallexample
X@var{one line to give the program's name and a brief idea of what it does.}
XCopyright (C) 19@var{yy}  @var{name of author}
X
XThis program is free software; you can redistribute it and/or modify
Xit under the terms of the GNU General Public License as published by
Xthe Free Software Foundation; either version 1, or (at your option)
Xany later version.
X
XThis program is distributed in the hope that it will be useful,
Xbut WITHOUT ANY WARRANTY; without even the implied warranty of
XMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
XGNU General Public License for more details.
X
XYou should have received a copy of the GNU General Public License
Xalong with this program; if not, write to the Free Software
XFoundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
X@end smallexample
X
XAlso add information on how to contact you by electronic and paper mail.
X
XIf the program is interactive, make it output a short notice like this
Xwhen it starts in an interactive mode:
X
X@smallexample
XGnomovision version 69, Copyright (C) 19@var{yy} @var{name of author}
XGnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
XThis is free software, and you are welcome to redistribute it
Xunder certain conditions; type `show c' for details.
X@end smallexample
X
XThe hypothetical commands `show w' and `show c' should show the
Xappropriate parts of the General Public License.  Of course, the
Xcommands you use may be called something other than `show w' and `show
Xc'; they could even be mouse-clicks or menu items---whatever suits your
Xprogram.
X
XYou should also get your employer (if you work as a programmer) or your
Xschool, if any, to sign a ``copyright disclaimer'' for the program, if
Xnecessary.  Here a sample; alter the names:
X
X@example
XYoyodyne, Inc., hereby disclaims all copyright interest in the
Xprogram `Gnomovision' (a program to direct compilers to make passes
Xat assemblers) written by James Hacker.
X
X@var{signature of Ty Coon}, 1 April 1989
XTy Coon, President of Vice
X@end example
X
XThat's all there is to it!
X
X@node Contributors, Motivation, Copying, Top
X@unnumbered Contributors to GNU GPERF Utility
X
X@itemize @bullet
X@item
XThe GNU GPERF perfect hash function generator utility was originally
Xwritten in GNU C++ by Douglas C. Schmidt.  It is now also available in a
Xhighly-portable ``old-style'' C version.  The general idea for the
Xperfect hash function generator was inspired by Keith Bostic's algorithm
Xwritten in C, and distributed to net.sources around 1984.  The current
Xprogram is a heavily modified, enhanced, and extended implementation of
XKeith's basic idea, created at the University of California, Irvine.
XBugs, patches, and suggestions should be reported to schmidt at
Xics.uci.edu.
X
X@item
XSpecial thanks is extended to Michael Tiemann and Doug Lea, for
Xproviding a useful compiler, and for giving me a forum to exhibit my
Xcreation.
X@end itemize
X
X@node Motivation, Description, Contributors, Top
X@chapter Static search structures and GNU GPERF
X
XA @dfn{static search structure} is an abstract data type with certain
Xfundamental operations like @emph{initialize}, @emph{insert}, and
X@emph{retrieve}.  All insertions conceptually occur before any
Xretrievals.  It is a useful data structure for representing @dfn{static
Xsearch sets}.  Static search sets occur frequently in software system
Xapplications.  Common examples of static search sets include compiler
Xreserved words, assembler instruction opcodes, and built-in shell
Xinterpreter commands.  Search set members, called @dfn{keywords}, are
Xinserted into the structure only once, typically during program
Xinitialization, and are not modified at run-time.
X
XMany data structures exist for managing static search sets, @emph{e.g.},
Xarrays, linked lists, binary search trees, and hash tables.  Different
Xsearch structure implementations offer trade-offs between space
Xutilization and search time efficiency.  For example, a linked list is
Xspace efficient, but its average-case time complexity for performing
Xretrieval operations is proportional to the list's length.  Conversely,
Xhash table implementations often locate an table entry in constant time,
Xbut typically require extra memory overhead.
X
X@dfn{Minimal perfect hash functions} provide an optimal solution for a
Xcertain class of static search sets.  A minimal perfect hash function is
Xdefined by two properties:
X
X@itemize @bullet
X@item
XIt allows keyword recognition in a static search set using exactly one
Xprobe into the hash table.  This represents the ``perfect'' property.
X
X@item 
XThe data structure holding the keywords is precisely large enough for
Xthe set of words, and no larger.  This is the ``minimal'' part.
X@end itemize
X
XFor most ``practical'' applications it is far easier to generate
X@emph{perfect} hash functions than @emph{minimal perfect} hash
Xfunctions.  For this reason, GNU GPERF is designed to generate
X``near-minimal'' perfect hash functions for sets of keyword strings.
XGPERF also supplies many options, however, allowing you to control the
Xdegree of minimality and perfection.  Moreover, non-minimal perfect hash
Xfunctions frequently operate faster than minimal ones in practice.  This
Xoccurs since searching a sparse table increases the probability of
Xlocating a ``null'' entry, thus reducing string comparison costs.
X
XStatic search set members are often relatively stable over time.
XConsider the set of 63 Ada reserved words, for example; they have
Xremained constant for over a decade.  It is often worthwhile, therefore,
Xto work hard building an optimal search structure once, if it is heavily
Xused multiple times.  GPERF relieves you from having to construct time
Xand space efficient search structures by hand.  It is a useful and
Xpractical tool for serious programming projects.  Both the GNU C and GNU
XC++ compilers utilize automatically generated static search structures
Xproduced by GPERF for recognizing their respective reserved keywords.
X
X@node Description, Options, Motivation, Top
X@chapter High-Level Description of GNU GPERF
X
X@menu
X* Input Format:: Input Format to GPERF
X* Output Format:: Output Format for Generated C Code with GPERF
X@end menu
X
XThe perfect hash function generator GPERF reads a set of ``keywords''
Xfrom a @dfn{keyfile} (or from the standard input by default).  It
Xattempts to derive a perfect hashing function that recognizes a member
Xof the @dfn{static keyword set} in constant, @emph{i.e.}, O(1), time.
XIf GPERF succeeds in generating such a function it produces a pair of C
Xsource code routines that perform hashing and table lookup recognition.
XAll generated C code is directed to the standard output.  Command-line
Xoptions described below allow you to modify the input and output format
Xto GPERF.
X
XBy default, GPERF attempts to produce time-efficient code, with less
Xemphasis on efficient space utilization.  However, several options exist
Xthat permit trading-off execution time for storage space and vice versa.
XIn particular, expanding the generated table size produces a sparse
Xsearch structure, generally yielding faster searches.  Conversely, you
Xcan direct GPERF to utilize a C @code{switch} statement scheme that
Xminimizes data space storage size.  Using a C @code{switch} potentially
Xslows down the keyword retrieval time somewhat, however.  Actual results
Xdepend on your C compiler, of course.  
X
XIn general, GPERF assigns values to the characters it is using for
Xhashing until some set of values gives each keyword a unique value.  A
Xhelpful heuristic is that the larger the hash value range, the easier it
Xis for GPERF to find and generate a perfect hash function.
XExperimentation is the key to getting the most from GPERF.
X
X@node Input Format, Declarations, Description, Description
X@section Input Format to GPERF
X
XYou can control the input keyfile format by varying certain command-line
Xarguments, in particular the @samp{-t} option.  The input's appearance
Xis similar to GNU utilities @code{flex} and @code{bison} (or UNIX
Xutilities @code{lex} and @code{yacc}).  Here's an outline of the general
Xformat:
X
X@group
X@example
Xdeclarations
X%%
Xkeywords
X%%
Xfunctions
X@end example
X@end group
X
X@emph{Unlike} @code{flex} or @code{bison}, all sections of GPERF's input
Xare optional.  The following sections describe the input format for each
Xsection.
X
X@menu
X* Declarations:: @code{struct} Declarations and C Code Inclusion.
X* Keywords::      Format for Keyword Entries.
X* Functions::     Including Additional C Functions.
X@end menu
X
X@node Declarations, Keywords, Input Format, Input Format
X@subsection @code{struct} Declarations and C Code Inclusion
X
XThe keyword input file optionally contains a section for including
Xarbitrary C declarations and definitions, as well as provisions for
Xproviding a user-supplied @code{struct}.  If the @samp{-t} option
X@emph{is} enabled, you @emph{must} provide a C @code{struct} as the last
Xcomponent in the declaration section from the keyfile file.  The first
Xfield in this struct must be a @code{char *} identifier called ``name,''
Xalthough it is possible to modify this field's name with the @samp{-K}
Xoption described below.
X
XHere is simple example, using months of the year and their attributes as
Xinput:
X
X@group
X@example
Xstruct months @{ char *name; int number; int days; int leap_days; @};
X%%
Xjanuary,   1, 31, 31
Xfebruary,  2, 28, 29
Xmarch,     3, 31, 31
Xapril,     4, 30, 30
Xmay,       5, 31, 31
Xjune,      6, 30, 30
Xjuly,      7, 31, 31
Xaugust,    8, 31, 31
Xseptember, 9, 30, 30
Xoctober,  10, 31, 31
Xnovember, 11, 30, 30
Xdecember, 12, 31, 31
X@end example
X@end group
X
XSeparating the @code{struct} declaration from the list of key words and
Xother fields are a pair of consecutive percent signs, @code{%%},
Xappearing left justified in the first column, as in the UNIX utility
X@code{lex}.
X
XUsing a syntax similar to GNU utilities @code{flex} and @code{bison}, it
Xis possible to directly include C source text and comments verbatim into
Xthe generated output file.  This is accomplished by enclosing the region
Xinside left-justified surrounding @code{%@{}, @code{%@}} pairs.  Here is
Xan input fragment based on the previous example that illustrates this
Xfeature:
X
X@group
X@example
X%@{
X#include <assert.h>
X/* This section of code is inserted directly into the output. */
Xint return_month_days (struct months *months, int is_leap_year);
X%@}
Xstruct months @{ char *name; int number; int days; int leap_days; @};
X%%
Xjanuary,   1, 31, 31
Xfebruary,  2, 28, 29
Xmarch,     3, 31, 31
X...
X@end example
X@end group
X
XIt is possible to omit the declaration section entirely.  In this case
Xthe keyfile begins directly with the first keyword line, @emph{e.g.}:
X
X@group
X@example
Xjanuary,   1, 31, 31
Xfebruary,  2, 28, 29
Xmarch,     3, 31, 31
Xapril,     4, 30, 30
X...
X@end example
X@end group
X
X@node Keywords, Functions, Declarations, Input Format
X@subsection Format for Keyword Entries
X
XThe second keyfile format section contains lines of keywords and any
Xassociated attributes you might supply.  A line beginning with @samp{#}
Xin the first column is considered a comment.  Everything following the
X@samp{#} is ignored, up to and including the following newline.
X
XThe first field of each non-comment line is always the key itself.  It
Xshould be given as a simple name, @emph{i.e.}, without surrounding
Xstring quotation marks, and be left-justified flush against the first
Xcolumn.  In this context, a ``field'' is considered to extend up to, but
Xnot include, the first blank, comma, or newline.  Here is a simple
Xexample taken from a partial list of C reserved words:
X
X@group
X@example
X# These are a few C reserved words, see the c.gperf file 
X# for a complete list of ANSI C reserved words.
Xunsigned
Xsizeof
Xswitch
Xsigned
Xif
Xdefault
Xfor
Xwhile
Xreturn
X@end example
X@end group
X
XNote that unlike @code{flex} or @code{bison} the first @code{%%} marker
Xmay be elided if the declaration section is empty.
X
XAdditional fields may optionally follow the leading keyword.  Fields
Xshould be separated by commas, and terminate at the end of line.  What
Xthese fields mean is entirely up to you; they are used to initialize the
Xelements of the user-defined @code{struct} provided by you in the
Xdeclaration section.  If the @samp{-t} option is @emph{not} enabled
Xthese fields are simply ignored.  All previous examples except the last
Xone contain keyword attributes.
X
X@node Functions, Output Format, Keywords, Input Format
X@subsection Including Additional C Functions
X
XThe optional third section also corresponds closely with conventions
Xfound in @code{flex} and @code{bison}.  All text in this section,
Xstarting at the final @code{%%} and extending to the end of the input
Xfile, is included verbatim into the generated output file.  Naturally,
Xit is your responsibility to ensure that the code contained in this
Xsection is valid C.
X
X@node Output Format, , Functions, Description
X@section Output Format for Generated C Code with GPERF
X
XSeveral options control how the generated C code appears on the standard
Xoutput.  Two C function are generated.  They are called @code{hash} and
X@code{in_word_set}, although you may modify the name for
X@code{in_word_set} with a command-line option.  Both functions require
Xtwo arguments, a string, @code{char *} @var{str}, and a length
Xparameter, @code{int} @var{len}.  Their default function prototypes are
Xas follows:
X
X@group
X@example
Xstatic int hash (char *str, int len);
Xint in_word_set (char *str, int len);
X@end example
X@end group
X
XBy default, the generated @code{hash} function returns an integer value
Xcreated by adding @var{len} to several user-specified @var{str} key
Xpositions indexed into an @dfn{associated values} table stored in a
Xlocal static array.  The associated values table is constructed
Xinternally by GPERF and later output as a static local C array called
X@var{hash_table}; its meaning and properties are described below.
X@xref{Implementation}. The relevant key positions are specified via the
X@samp{-k} option when running GPERF, as detailed in the @emph{Options}
Xsection below. @xref{Options}.
X
XTwo options, @samp{-g} (assume you are compiling with GNU C and its
X@code{inline} feature) and @samp{-a} (assume ANSI C-style function
Xprototypes), alter the content of both the generated @code{hash} and
X@code{in_word_set} routines.  However, function @code{in_word_set} may
Xbe modified more extensively, in response to your option settings.  The
Xoptions that affect the @code{in_word_set} structure are:
X
X@itemize @bullet
X@table @samp
X@item -p
XHave function @code{in_word_set} return a pointer rather than a boolean.
X
X@item -t
XMake use of the user-defined @code{struct}.
X
X@item -S
XGenerate a C @code{switch} statement rather than use a large,
X(and potentially sparse) static array.
X@end table
X@end itemize
X
XIf the @samp{-t}, @samp{-S}, and @samp{-p} options are omitted the
Xdefault action is to generate a @code{char *} array containing the keys,
Xtogether with additional null strings used for padding the array.  By
Xexperimenting with the various input and output options, and timing the
Xresulting C code, you can determine the best option choices for
Xdifferent keyword set characteristics.
X
X@node Options, Bugs, Description, Top
X@chapter Options to the GPERF Utility
X
XThere are @emph{many} options to GPERF.  They were added to make
Xthe program more convenient for use with real applications.  ``On-line''
Xhelp is readily available via the @samp{-h} option.  Other options
Xinclude:
X
X@itemize @bullet
X@table @samp
X@item -a
XGenerate ANSI Standard C code using function prototypes.  The default is
Xto use ``classic'' K&R C function declaration syntax.
X
X@item -c
XGenerates C code that uses the @code{strncmp} function to perform
Xstring comparisons.  The default action is to use @code{strcmp}.
X
X@item -C
XMakes the contents of all generated lookup tables constant, @emph{i.e.},
X``readonly.''  Many compilers can generate more efficient code for this
Xby putting the tables in readonly memory.
X
X@item -d
XEnables the debugging option.  This produces verbose diagnostics to
X``standard error'' when GPERF is executing.  It is useful both for
Xmaintaining the program and for determining whether a given set of
Xoptions is actually speeding up the search for a solution.  Some useful
Xinformation is dumped at the end of the program when the @samp{-d}
Xoption is enabled.
X
X@item -D
XHandle keywords whose key position sets hash to duplicate values.
XDuplicate hash values occur for two reasons:
X
X@itemize @bullet
X@item
XSince GPERF does not backtrack it is possible for it to process
Xall your input keywords without finding a unique mapping for each word.
XHowever, frequently only a very small number of duplicates occur, and 
Xthe majority of keys still require one probe into the table.
X@item
XSometimes a set of keys may have the same names, but possess different
Xattributes.  With the -D option GPERF treats all these keys as part of
Xan equivalence class and generates a perfect hash function with multiple
Xcomparisons for duplicate keys.  It is up to you to completely
Xdisambiguate the keywords by modifying the generated C code.  However,
XGPERF helps you out by organizing the output.
X@end itemize
X
XOption @samp{-D} is extremely useful for certain large or highly
Xredundant keyword sets, @emph{i.e.}, assembler instruction opcodes.  If
Xthe input file contains duplicates then selecting @samp{-D} enables the
X@samp{-S} option, otherwise the @samp{-D} is ignored.  Using this option
Xusually means that the generated hash function is no longer perfect.  On
Xthe other hand, it permits GPERF to work on keyword sets that it
Xotherwise could not handle.
X
X@item -f @var{iteration amount}
XGenerate the perfect hash function ``fast.''  This decreases GPERF's
Xrunning time at the cost of minimizing generated table-size.  The
Xiteration amount represents the number of times to iterate when
Xresolving a collision.  `0' means `iterate by the number of keywords.
XThis option is probably most useful when used in conjunction with options
X@samp{-D} and/or @samp{-S} for @emph{large} keyword sets.
X
X@item -g
XAssume a GNU compiler, @emph{e.g.}, @code{g++} or @code{gcc}.  This
Xmakes all generated routines use the ``inline'' keyword to remove the
Xcost of function calls.  Note that @samp{-g} does @emph{not} imply
X@samp{-a}, since other non-ANSI C compilers may have provisions for a
Xfunction @code{inline} feature.
X
X@item -G
XGenerate the static table of keywords as a static global variable,
Xrather than hiding it inside of the lookup function (which is the
Xdefault behavior).
X
X@item -h
XPrints a short summary on the meaning of each program option.  Aborts
Xfurther program execution.
X
X@item -H @var{hash function name}
XAllows you to specify the name for the generated hash function.  Default
Xname is `hash.'  This option permits the use of two hash tables in the
Xsame file.
X
X@item -i @var{initial value}
XProvides an initial @var{value} for the associate values array.  Default
Xis 0.  Increasing the initial value helps inflate the final table size,
Xpossibly leading to more time efficient keyword lookups.  Note that this
Xoption is not particularly useful when @samp{-S} is used.
X
X@item -j @var{jump value}
XAffects the ``jump value,'' @emph{i.e.}, how far to advance the
Xassociated character value upon collisions.  @var{Jump value} is rounded
Xup to an odd number, the default is 5.  Frequently, increasing the jump
Xvalue speeds up the search for a perfect hash function.
X
X@item -k @var{keys}
XAllows selection of the character key positions used in the keywords'
Xhash function. The allowable choices range between 1-126, inclusive.
XThe positions are separated by commas, @emph{e.g.}, @samp{-k 9,4,13,14}; ranges
Xmay be used, @emph{e.g.}, @samp{-k 2-7}; and positions may occur in any order.
XFurthermore, the meta-character '*' causes the generated hash function
Xto consider @strong{all} character positions in each key, whereas '$'
Xinstructs the hash function to use the ``final character'' of a key
X(this is the only way to use a character position greater than 126,
Xincidentally).
X
XFor instance, the option @samp{-k 1,2,4,6-10,'$'} generates a hash
Xfunction that considers positions 1,2,4,6,7,8,9,10, plus the last
Xcharacter in each key (which may differ for each key, obviously).  Keys
Xwith length less than the indicated key positions work properly, since
Xselected key positions exceeding the key length are simply not
Xreferenced in the hash function.
X
X@item -K @var{key name}
XBy default, the program assumes the structure component identifier for
Xthe keyword is ``name.''  This option allows an arbitrary choice of
Xidentifier for this component, although it still must occur as the first
Xfield in your supplied @code{struct}.
X
X@item -l
XCompare key lengths before trying a string comparison.  This might cut
Xdown on the number of string comparisons made during the lookup, since
Xkeys with different lengths are never compared via @code{strcmp}.
X
X@item -n
XInstructs the generator not to include the length of a keyword when
Xcomputing its hash value.  This may save a few assembly instructions in
Xthe generated lookup table.
X
X@item -N @var{lookup function name}
XAllows you to specify the name for the generated lookup function.
XDefault name is `in_word_set.'  This option permits completely automatic
Xgeneration of perfect hash functions, especially when multiple generated
Xhash functions are used in the same application.
X
X@item -o
XReorders the keywords by first sorting the list so that frequently
Xoccuring key position set components appear first.  A reordering process
Xfollows this so that keys with already determined values are placed
Xtowards the front of the keylist.  This often dramatically decreases the
Xtime required to generate a perfect hash function for many keyword sets.
XThe reason for this is that the reordering helps prune the search time
Xby handling inevitable collisions early in the search process.  See
XCichelli's paper from the January 1980 JACM for details.
X
X@item -p
XChanges the return value of the generated function @code{in_word_set}
Xfrom boolean (@emph{i.e.}, 0 or 1), to either type ``pointer to user-defined
Xstruct,'' (if the @samp{-t} option is enabled), or simply to @code{char
X*}, if @samp{-t} is not enabled.  This option is most useful when the
X@samp{-t} option (allowing user-defined structs) is used.  For example,
Xit is possible to automatically generate the GNU C reserved word lookup
Xroutine with the options @samp{-p} and @samp{-t}.
X
X@item -r
XUtilizes randomness to initialize the associated values table.  This
Xfrequently generates solutions faster than using deterministic
Xinitialization (which starts all associated values at 0).  Furthermore,
Xusing the randomization option generally increases the size of the
Xtable.  If GPERF has difficultly with a certain keyword set try using
X@samp{-r} or @samp{-D}.
X
X@item -s @var{size-multiple}
XAffects the size of the generated hash table.  The numeric argument for
Xthis option indicates ``how many times larger'' the maximum associated
Xvalue range should be, in relationship to the number of keys.  For
Xexample, a value of 3 means ``allow the maximum associated value to be
Xabout 3 times larger than the number of input keys.''  If option
X@samp{-S} is @emph{not} enabled, the maximum associated value influences
Xthe static array table size, and a larger table should decrease the time
Xrequired for an unsuccessful search, at the expense of extra table
Xspace.  
X
XThe default value is 1, thus the default maximum associated value about
Xthe same size as the number of keys ( for efficiency, the maximum
Xassociated value is always rounded up to a power of 2).  The actual
Xtable size may vary somewhat, since this technique is essentially a
Xheuristic.  In particular, setting this value too high slows down
XGPERF's runtime, since it must search through a much larger range of
Xvalues.  Judicious use of the @samp{-f} option helps alleviate this
Xoverhead, however.
X
X@item -S
XCauses the generated C code to use a @code{switch} statement scheme,
Xrather than an array lookup table.  This potentially saves @emph{much}
Xdata space, at the expense of a slightly longer time for each lookup
X(this depends on how intelligently your compiler implements the
X@code{switch} statement, of course).  It is mostly important for large
Xinput sets, @emph{i.e.}, greater than around 100 items or so.  This
Xoption was inspired in part by Keith Bostic's original program.
X
X@item -t
XAllows you to include a @code{struct} type declaration for generated
Xcode.  Any text before a pair of consecutive %% is consider part of the
Xtype declaration.  Key words and additional fields may follow this, one
Xgroup of fields per line.  A set of examples for generating perfect hash
Xtables and functions for Ada, C, and G++, Pascal, and Modula 2 and 3
Xreserved words are distributed with this release.
X
X@item -T
XPrevents the transfer of the type declaration to the output file.  Use
Xthis option if the type is already defined elsewhere.
X
X@item -v
XPrints out the current version number.
X@end table
X@end itemize
X
X@node Bugs, Projects, Options, Top
X@chapter Known Bugs and Limitations with GPERF
X
XThe following are some limitations with the current release of
XGPERF:
X
X@itemize @bullet
X@item
XThe GPERF utility is tuned to execute quickly, and works quickly for
Xsmall to medium size data sets (around 1000 keys).  It is extremely
Xuseful for maintaining perfect hash functions for compiler keyword sets.
XHowever, since it does not backtrack no guaranteed solution occurs on
Xevery run.  On the other hand, it is usually easy to obtain a solution
Xby varying the option parameters.  In particular, try the @samp{-r}
Xoption, and also try changing the default arguments to the @samp{-s} and
X@samp{-j} options.  To @emph{guarantee} a solution, use the @samp{-D}
Xoption, although the final results are not likely to be a @emph{perfect}
Xhash function anymore!  Finally, use the @samp{-f} option if you want
XGPERF to generate the perfect hash function @emph{fast}, with less
Xemphasis on making it minimal.
X
X@item 
XThe size of the generate static keyword array can get @emph{extremely}
Xlarge if the input keyword file is large or if the keywords are quite
Xsimilar.  This tends to slow down the compilation of the generated C
Xcode, and @emph{greatly} inflates the object code size.  If this
Xsituation occurs, consider using the @samp{-S} option to reduce data
Xsize, potentially increasing keyword recognition time a negligible
Xamount.
X
X@item
XThe input file specifications are rather restrictive.  
X
X@item 
XThe maximum number of key positions selected for a given key has an
Xarbitrary limit of 126.  This restriction should be removed, and if
Xanyone considers this a problem write me and let me know so I can remove
Xthe constraint.
X
X@item
XThe source code only compiles correctly with GNU G++, version 1.35 ( and
Xhopefully later versions).  Porting to AT&T cfront would be tedious, but
Xpossible (and desirable).  There is also a K&R C version available now.
XSend mail to schmidt at ics.uci.edu for information.
X@end itemize
X
X@node Projects, Implementation, Bugs, Top
X@chapter Things Still Left to Do
X
XIt should be ``relatively'' easy to replace the current perfect hash
Xfunction algorithm with a more exhaustive approach; the perfect hash
Xmodule is essential independent from other program modules.  Additional
Xworthwhile improvements include:
X
X@itemize @bullet
X@item 
XMake the program generate hash functions more quickly (although the
Xcurrent version uses clever data structures and is @emph{very} fast for
Xmany useful input sets, when given the appropriate options).
X
X@item 
XMake the algorithm more robust.  At present, the program halts with an
Xerror diagnostic if it can't find a direct solution and the @samp{-D}
Xoption is not enabled.  A more comprehensive, albeit computationally
Xexpensive, approach would employ backtracking or enable alternative
Xoptions and retry.  It's not clear how helpful this would be, in
Xgeneral, since most search sets are rather small in practice.
X
X@item 
XAnother useful extension involves modifying the program to generate
X``minimal'' perfect hash functions (under certain circumstances, the
Xcurrent version can be rather extravagant in the generated table size).
XAgain, this is mostly of theoretical interest, since a sparse table
Xoften produces faster lookups, and use of the @samp{-S} @code{switch}
Xoption can minimize the data size, at the expense of slightly longer
Xlookups (note that the gcc compiler generally produces good code for
X@code{switch} statements, reducing the need for more complex schemes).
X
X@item
XIn addition to improving the algorithm, it would also be useful to
Xgenerate a C++ class or Ada package as the code output, in addition to
Xthe current C routines.
X@end itemize
X
X@node Implementation, Bibliography, Projects, Top
X@chapter Implementation Details of GNU GPERF
X
XAt some point the documentation will include a high-level description of
Xthe data structures and algorithms used to implement GPERF.  These are
Xuseful not only from a maintenance and enhancement perspective, but also
Xbecause they demonstrate several clever and useful programming
Xtechniques, @emph{e.g.}, Ullman arrays, double hashing, a ``safe'' and
Xefficient method for reading arbitrarily long input from a file, and a
Xprovably optimal algorithm for simultaneously determining both the
Xminimum and maximum elements in a list.
X
X@page
X
X@node Bibliography, , Implementation, Top
X@chapter Bibliography
X
X[1] Chang, C.C.: @i{A Scheme for Constructing Ordered Minimal Perfect
XHashing Functions} Information Sciences 39(1986), 187-195.
X       
X[2] Cichelli, Richard J. @i{Author's Response to ``On Cichelli's Minimal Perfect Hash
XFunctions Method''} Communications of the ACM, 23, 12(December 1980), 729.
X    
X[3] Cichelli, Richard J. @i{Minimal Perfect Hash Functions Made Simple}
XCommunications of the ACM, 23, 1(January 1980), 17-19.
X           
X[4] Cook, C. R. and Oldehoeft, R.R. @i{A Letter Oriented Minimal
XPerfect Hashing Function} SIGPLAN Notices, 17, 9(September 1982), 18-27.
X
X[5] Cormack, G. V. and Horspool, R. N. S. and Kaiserwerth, M.
X@i{Practical Perfect Hashing} Computer Journal, 28, 1(January 1985), 54-58.
X    
X[6] Jaeschke, G. @i{Reciprocal Hashing: A Method for Generating Minimal
XPerfect Hashing Functions} Communications of the ACM, 24, 12(December
X1981), 829-833.
X
X[7] Jaeschke, G. and Osterburg, G. @i{On Cichelli's Minimal Perfect
XHash Functions Method} Communications of the ACM, 23, 12(December 1980),
X728-729.
X
X[8] Sager, Thomas J. @i{A Polynomial Time Generator for Minimal Perfect
XHash Functions} Communications of the ACM, 28, 5(December 1985), 523-532
X
X[9] Sebesta, R.W. and Taylor, M.A. @i{Minimal Perfect Hash Functions
Xfor Reserved Word Lists}  SIGPLAN Notices, 20, 12(September 1985), 47-53.
X@contents
X
X[10] Sprugnoli, R. @i{Perfect Hashing Functions: A Single Probe
XRetrieving Method for Static Sets} Communications of the ACM, 20
X11(November 1977), 841-850.
X
X[11] Stallman, Richard M. @i{Using and Porting GNU CC} Free Software Foundation,
X1988.
X
X[12] Stroustrup, Bjarne @i{The C++ Programming Language.} Addison-Wesley, 1986.
X
X[13] Tiemann, Michael D. @i{User's Guide to GNU C++} Free Software
XFoundation, 1989.
X@bye
END_OF_FILE
if test 45171 -ne `wc -c <'cperf/gperf.texinfo'`; then
    echo shar: \"'cperf/gperf.texinfo'\" unpacked with wrong size!
fi
# end of 'cperf/gperf.texinfo'
fi
echo shar: End of archive 5 \(of 5\).
cp /dev/null ark5isdone
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

