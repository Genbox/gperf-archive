
/*
 *			P e r f e c t   H a s h
 *
 *
 *	Program to search for Minimal Perfect Hash Functions for
 *	use in lexical analyzers. C.D. Havener Jan 26 1982
 *	GenRad Inc. 37 Great Road, Bolton Mass. 01740
 *	Based on paper "Minimal Perfect Hash Functions Made Simple"
 *	by Richard J. Cichelli - Comm. of ACM Jan 1980 pp 17-19
 *
 *	Synopsis: The hash function is h = assoc value of 1st
 *	letter + length of keyword + assoc value of last letter
 *
 *	This program finds the associated values of the letters
 *	given a list of keywords, 1 per line. It works most of
 *	the time for up to about 40 keywords but certain
 *	pathological cases exist. A semi-perfect hash is usually
 *	found by the program. The user can then tighten the
 *	default limits for max associated char value or the
 *	table limit using the -v and -t options. Sometimes the
 *	presort heuristics actually make the search process
 *	much more difficult. The user can try his luck at manual
 *	sorting using the -n option. Since the hash function
 *	produces such a limited range of numbers it can only work
 *	for up to about 40 keywords. If a language needs say 80
 *	keywords just split them up into two tables and let the
 *	lexical analyzer look in first one then the other, this
 *	will still be much faster than any other keyword lookup.
 *
 *	This program has run sucessfully on a VAX 11/780 under
 *	4.1BSD and VMS (using Vax-11 C and Decus C).
 */

/*)BUILD
	$(MP) = 1			# uses macros with arguments
	$(STACK)	= 10000		# lots of recursion
	$(TKBOPTIONS)	= {
	    STACK	= 1024
	    TASK	= ...PRF
	}
*/

#ifdef	DOCUMENTATION
title	perfect		Find Perfect Hash Functions
index	perfect		Find perfect hash functions

synopsis

	perfect [-options]

description

	perfect reads a list of keywords from the standard input
	and computes a "perfect hash" function for the set.
	The following options are defined:
	.lm +8
	.s.i -8;-d######Enable debug code.
	.s.i -8;-n######Disable pre-sort of keywords.  (See below).
	.s.i -8;-t#<n>##Limit the maximum table size to <n> entries.
	.s.i -8;-v#<n>##Limit the maximum associated character value.
	.s.i -8;-k#<n>##Use only the first <n> keywords in the list.
	.s.i -8;-a#<n>##Give a status report every <n> seconds.
	(Unix and Vax-11C/VMS only).
	.s.i -8;-o#file#Write a sample keyword lookup routine to the
	indicated file.
	.s.lm -8
	The program prints a running commentary on the standard
	output.

Author

	Charlie Havener, GenRad Inc.  Bolton Mass.

	(Modified by Martin Minow, Dec, Maynard Mass.)

Discussion

	This technical note describes an implementation of a
	pragmatic algorithm for finding perfect or semi-perfect hash
	functions for lists of keywords. The resulting hash function can
	be used to speed up lexical analyzers used in translators and
	compilers. The algorithm was described by R.J. Cichelli in The
	January 1980 issue of Communications of the ACM under the title
	"Minimal Perfect Hash Functions made Simple." The article did not
	include a computer language description of the algorithm and some
	important implementation details were unclear. It is assumed that
	the user will know what to do with the output of this program.
	The -o option may be used to produce a lexical analyser kernel
	from the tables built by this program. Another reference for
	those wishing to pursue the topic further is "More On Minimal
	Perfect Hash tables" by Curtis Cook and R. Oldehoeft, a Colorado
	State University Technical Report.

	The program takes a list of keywords and sorts them in such
	a way that the search time for a hash function will be
	reasonable. Once sorted a recursive trial and error procedure
	hunts for a hash function satisfying user supplied bounds
	of table size and associated character value limits.  The
	built-in hash function is

	    hash = assoc value of first character
		+ keyword length
		+ assoc value of last character

	It is critically important to select a good ordering of the
	keywords before searching begins. I ran up 100 hours of VAX time
	searching for a hash function with an unordered list, and gave
	up. Once the sort heuristics were debugged it found the hash
	function in minutes. Typically it will find the function in
	minutes or you may as well give up. A status reporting feature is
	built into the program on the UNIX system that lets you follow
	the progress of the search depth. If it has trouble, you can
	tell just which word it can't get past, and take appropriate
	action. If it has trouble you can attempt to alter its choice of
	pre-ordering by moving troublesome words to the front of the
	list. In a sequel to his paper, Cichelli stated that sometimes
	the sort heuristics makes the search longer. There is also no
	guarantee that a hash function can be found. The program does the
	obvious precheck that no two keywords have the same first and
	last letter and length in common (e.g. BAK KAB). Nonetheless,
	as pointed out by Jaeschke and Osterberg in an overly harsh
	criticism, there are many pathological sets of keywords that fail.
	(On Cichelli's minimal perfect hash functions method. Comm. ACM
	Dec. 1980, pp 728-729) The algorithm also only works for up to
	about 40 keywords due to the limited range of numbers the formula
	can generate. If you have, say 80 keywords, just make two hash
	tables and look in each one. Here are some examples of the
	program's output:
	.s.nf
	Perfect hash function finder, CDH Ver. 2.9
	Start time = Mon Oct 17 20:40:40 1983
	28 keywords, 19 distinct letters.
	The associated char value limit is 19
	The table size limit is 100
	The search ordering is
	 else double continue case float struct sizeof
	 static short extern typedef default register for
	 char while entry int if return do unsigned switch
	 union goto auto long break
	.s
	Success! Associated Char Values Follow:
	 a =19, b = 4, c = 1, d = 0, e = 0, f = 3, g =17,
	 h =14, i =17, k =19, l = 6, n = 8, o = 0, r =11,
	 s = 6, t = 0, u =16, w =13, y =14,
	Hash min = 2, max = 30, spread = 29
	 do 2, else 4, case 5, double 6, default 7,
	 float 8, continue 9, typedef 10, short 11, struct 12,
	 static 13, extern 14, sizeof 15, char 16, for 17,
	 while 18, entry 19, int 20, goto 21, if 22, auto 23,
	 unsigned 24, return 25, switch 26, long 27, break 28,
	 union 29, register 30,
	.s
	Total search() invocations = 15913
	 Started Mon Oct 17 20:40:40 1983
	Finished Mon Oct 17 20:40:42 1983
	.s.nf
	Perfect hash function finder, CDH Ver. 2.9
	Start time = Mon Oct 17 20:41:11 1983
	39 keywords, 19 distinct letters.
	The associated char value limit is 19
	The table size limit is 100
	The search ordering is
	 TEXT RESET TRUE REWRITE READLN SQRT SQR EOLN TRUNC
	 PUT EXP PAGE CHR CHAR COS SUCC READ ROUND DISPOSE
	 PRED SIN OUTPUT ORD INPUT INTEGER GET MAXINT REAL
	 WRITE EOF FALSE NEW WRITELN LN ARCTAN ABS BOOLEAN
	 PACK UNPACK
	.s
	Success! Associated Char Values Follow:
	 A =18, B =11, C =16, D =18, E = 3, F = 3, G = 0,
	 I = 1, K =19, L = 9, M =18, N =19, O = 8, P = 9,
	 R = 0, S =14, T = 0, U =13, W =19,
	Hash min = 3, max = 45, spread = 43
	 GET 3, TEXT 4, RESET 5, INPUT 6, TRUE 7,
	 INTEGER 8, EOF 9, REWRITE 10, FALSE 11, PUT 12,
	 REAL 13, OUTPUT 14, EXP 15, PAGE 16, SQR 17, SQRT 18,
	 CHR 19, CHAR 20, TRUNC 21, READ 22, ROUND 23,
	 MAXINT 24, READLN 25, EOLN 26, WRITE 27, DISPOSE 28,
	 ORD 29, LN 30, PRED 31, PACK 32, COS 33, SUCC 34,
	 ABS 35, SIN 36, BOOLEAN 37, UNPACK 38, NEW 41,
	 ARCTAN 43, WRITELN 45,
	.s
	Total search() invocations = 149292
	 Started Mon Oct 17 20:41:11 1983
	Finished Mon Oct 17 20:41:35 1983
	.s 2.f
	Usually, the first time you run perf, just let everything
	default. The second time,
	use the -t option to limit the table size to the first hash
	value plus the number of keywords.

	On Unix and Vax/VMS (Vax-11 C), The program will accept
	SIGTERM signals (CTRL/C on VMS) for an update status report
	since it may take quite a while to find the hash function values.

Sample keyword tables

	The following tables are known to work correctly.
	The first defines the keywords for the C programming
	language; the second for a toy computer language.

	int char float double struct union long short
	unsigned auto extern register typedef static
	goto return sizeof break continue if else for
	do while switch case default entry

	GET TEXT RESET OUTPUT MAXINT INPUT TRUE
	INTEGER EOF REWRITE FALSE CHR CHAR TRUNC REAL
	SQR SQRT WRITE PUT ORD READ ROUND READLN EXP
	PAGE EOLN COS SUCC DISPOSE NEW ABS LN BOOLEAN
	WRITELN SIN PACK UNPACK ARCTAN PRED

#endif
#include	<stdio.h>
#include	<ctype.h>

#define	EOS	'\0'
#define	FALSE	0
#define	TRUE	1
#define	VOID	int

#ifdef	unix
#define	UNIX	1
#define	DOALARM	1
#endif

#ifndef	vms
#define	VMS	0
#else
#define	VMS	1
#define	DOALARM	1
#endif

#ifndef	UNIX
#define	UNIX	0
#endif

#ifndef	DOALARM
#define	DOALARM	0
#endif

#if	UNIX
#define	IO_ERROR	1
#endif

#if	VMS
#include	<ssdef.h>
#define	IO_ERROR	SS$_ABORT
/*
 * This creates text files in vanilla RMS on VMS
 */
extern FILE	*fdopen();
#define	CREATE(f, m) fdopen(creat(f, 0, "rat=cr", "rfm=var"), m)
#else
#define	CREATE	fopen
#endif

#if	DOALARM
#include	<signal.h>
extern int	status();
#endif

#define	MAXKEYS		100		/* Maximum number of keys	*/
#define MAXCHARS	0377		/* Maximum number of char's	*/
#define UNDEF		-1		/* the undefined value		*/

typedef struct keyword {
    int		len;		/* Keyword length			*/
    char	last;		/* Last byte of keyword			*/
    char	word[1];	/* Keyword text				*/
} KEYWORD;

/*
 * Define some frequently used operations as macros:
 *	hash(p)		returns the hash value for this keyword
 *	used(n)		TRUE if this hash value is in use or illegal
 *	defined(c)	TRUE if this character is defined
 */

#define hash(p)		(value[p->word[0]] + p->len + value[p->last])
#define	used(n)		((n > tablesize || n < 0) ? TRUE : mapped[n])
#define	defined(c)	(c != UNDEF)

char	cval[MAXCHARS];		/* All possible characters		*/
short	cused[MAXCHARS];	/* count of often char used		*/
short	order[MAXKEYS];		/* ordering of key words by subscript	*/
short	neworder[MAXKEYS];	/* the new supposedly improved ordering	*/
short	hashval[MAXKEYS];	/* current hashvalue of the key word	*/
short	value[MAXCHARS];	/* associated value of the character	*/
int	mapped[MAXKEYS];	/* track which table entries are in use	*/
char	name[50];		/* bigger than any keyword should be	*/


KEYWORD		*keywds[MAXKEYS];

extern long	time();
extern char	*ctime();
extern char	*malloc();
extern int	aredefined();
extern char	*strchr();

int	debug		= 0;
int	nkeys		= sizeof(keywds) / (sizeof (KEYWORD));
int	tablesize	= sizeof(keywds) / (sizeof (KEYWORD));
short	trys		= 0;
int	nletters	= 0;
short	kilotrys	= 0;
int	atime		= 10 * 60;	/* default alarm status 10 min.	*/
char	*klimit		= NULL;
char	*textp		= NULL;
long	bigcount	= 0;
short	depth		= 0;
short	k_now		= 0;		/* value of k for status report	*/
int	nosort		= FALSE;	/* -n sets nosort TRUE		*/
long	start, stop;			/* the start and finish times	*/
short	vlimit		= 0;
short	keylimit	= 0;
short	tlimit		= 0;
char	*output		= NULL;		/* Output file if set		*/

char	letters[37];			/* string of defined chars	*/
char	*letend = letters;		/* -> free space in letters[]	*/
main(argc,argv)
int		argc;
char		*argv[];
{
	getoptions(argc, argv);
	start = time(NULL);
#if	DOALARM
	signal(SIGALRM,status);
	signal(SIGTERM,status);		/* status on kill -TERM pid	*/
	alarm(atime);			/* status every N secs		*/
#endif
	setup();
	dosort();
	printf("The search ordering is\n");
	prntorder();
	if (search(0)) {
#if	DOALARM
	    alarm(0);
#endif
	    printf("\nSuccess! Associated Char Values Follow:\n");
	    prntvals();
	    prnthash();
	    printf("\n");
	    if (output != NULL)
		dooutput();
	}
	else {
#if	DOALARM
	    alarm(0);
#endif
	    printf("\nFailed to find char values for hash function\n");
	}
	printf("Total search invocations = %ld, max depth = %d\n",
	    bigcount, depth);
	stop = time(NULL);
	printf(" Started %s", ctime(&start));
	printf("Finished %s", ctime(&stop));
}
setup()
{
	register KEYWORD	*kp;
	register int		c;
	register int		i;
	int			len;

	for (i = 0; (scanf("%s", name)) != EOF; i++) {
	    if (i >= MAXKEYS) {
		printf("Too many keys, %d max.\n", MAXKEYS);
		exit(IO_ERROR);
	    }
	    len = strlen(name);
	    kp = (KEYWORD *) malloc(sizeof (KEYWORD) + len);
	    if (kp == NULL) {
		printf("Out of room allocating keywords\n");
		exit(IO_ERROR);
	    }
	    keywds[i] = kp;
	    kp->len = len;
	    kp->last = name[len - 1];
	    strcpy(&kp->word[0], name);
	}
	nkeys = (keylimit == 0) ? i : keylimit;

	for (i = 0; i < MAXKEYS; i++) {
	    hashval[i] = UNDEF;
	    order[i] = i;
	    mapped[i] = FALSE;
	}

	for (i = 0; i < MAXCHARS; i++) {
	    cval[i] = 0;
	    value[i] = UNDEF;
	}

	if (!precheck()) {
	    printf("Perfect hash search terminated\n");
	    exit(IO_ERROR);
	}

	for (i = 0; i < nkeys; i++) {
	    c = keywds[i]->word[0];	/* Get first char of keyword	*/
	    cval[c] = c;		/* Remember this one used	*/
	    if (cused[c] == 0)		/* If it's the first time,	*/
		++nletters;		/* Count unique letters		*/
	    ++cused[c];			/* count how often letter used	*/
	    c = keywds[i]->last;	/* Get last char of keyword	*/
	    cval[c] = c;		/* And do the same for it	*/
	    if (cused[c] == 0)
		++nletters;
	    ++cused[c];
	}

	tablesize = (tlimit == 0 ? MAXKEYS : tlimit);
	printf("Perfect hash function finder, CDH Ver. 2.9\n");
	printf("Start time = %s", ctime(&start));
	printf("%d keywords, %d distinct letters.\n",
	    nkeys, nletters);
	nletters = (vlimit > 0) ? vlimit : nletters;
	printf("The associated char value limit is %d\n", nletters);
	printf("The table size limit is %d\n", tablesize);

	/*
	 * You should make tablesize at least nkeys + 1 since the
	 * first value is usually 1 or 2 even if both assoc char
	 * values are zero since the keyword length is included!
	 */
}
dosort()
{
	register KEYWORD	*kp;
	register int		i, j;
	int			k, m;
	int			newvalues;

	if (nosort) {
	    printf("No presorting of keywords.\n");
	    return;
	}

	/*
	 * first order by sum of frequencies of occurrences of each
	 * keys 1st and last letter
	 */

	for (i = 0; i < nkeys; i++) {
	    kp = keywds[i];
	    order[i] = cused[kp->word[0]] + cused[kp->last];
	}
	for (m = 0; m < nkeys; m++) {
	    for (k = -1, i = 0; i < nkeys; i++) {
		if (order[i] > k) {
		    k = order[i];
		    j = i;		/* remember keywd subscript	*/
		}
	    }
	    order[j] = 0;
	    neworder[m] = j;
	}
	for (i=0; i < nkeys; i++)
	    order[i] = neworder[i];
	if (debug > 2) {
	    printf("After first ordering\n");
	    prntorder();
	}

	/*
	 * The second ordering follows, keywds whose values are
	 * defined by keywds earlier in the order are placed
	 * immediately after they are defined. This causes hash
	 * value conflicts to occur as early during the search
	 * as possible.
	 */

	letend = letters;
	letters[0] = EOS;
	merge(order[0]);			/* prime the pump	*/
	neworder[0] = order[0];
	order[0] = UNDEF;
	for (i = 1; i < nkeys;) {
	    for (newvalues = TRUE; newvalues;) {
		newvalues = FALSE;
		for (k = 0; k < nkeys; k++) {
		    if (order[k] == UNDEF)
			continue;
		    if (aredefined(order[k])) {
			neworder[i++] = order[k];
			order[k] = UNDEF;
			continue;
		    }
		}
		for (k = 0; k < nkeys; k++) {
		    if (order[k] != UNDEF) {
			neworder[i++] = order[k];
			merge(order[k]);
			order[k] = UNDEF;
			newvalues = TRUE;
			break;
		    }
		}
	    }
	}
	for (i = 0; i < nkeys; i++)
	    order[i] = neworder[i];
	if (precheck() == FALSE) {
	    printf("OOPS - call a Guru, the presort botched it\n");
	    prntorder();
	    exit(IO_ERROR);
	}
}
/*
 * merge - adds keywd letters to the string of those defined.
 * This could be speeded up, but it's not a critical-path function.
 */

VOID
merge(n)
int		n;
{
	register KEYWORD	*kp;

	kp = keywds[n];
	if (debug > 2)
	    printf("merging in %s\n", kp->word);
	if (strchr(letters, kp->word[0]) == NULL) {
	    *letend++ = kp->word[0];
	    *letend = EOS;
	}
	if (strchr(letters, kp->last) != NULL) {
	    *letend++ = kp->last;
	    *letend = EOS;
	}
}

/*
 * aredefined - see if 1st & last char of keywd are defined
 */

int
aredefined(n)
int		n;
{
	register KEYWORD	*kp;

	kp = keywds[n];
	if (strchr(letters, kp->word[0]) != NULL
	 && strchr(letters, kp->last) != NULL)
	    return (TRUE);
	else return (FALSE);
}
/*
 * precheck - all keywds length,1st and last char disjoint
 */

int
precheck()
{
	int			pretest;
	register KEYWORD	*ip, *jp;
	short			i, j;
	short			m, k;
	char			a, b;

	pretest = TRUE;
	for (m = 0; m < nkeys; m++) {
	    i = order[m];
	    ip = keywds[i];
	    a = ip->word[0];
	    b = ip->last;
	    for (k = m + 1; k < nkeys-1; k++) {
		j = order[k];
		jp = keywds[j];
		if (ip->len == jp->len
		 && ((a == jp->word[0] && b == jp->last)
		  || (a == jp->last && b == jp->word[0]))) {
		    pretest = FALSE;
		    printf("Precheck fails on %s and %s\n",
			ip->word, jp->word);
		}
	    }
	}
	return (pretest);
}
/*
 * prntorder - printout the current order of the keywords
 */

VOID
prntorder()
{
	register int	i, j;

	for (i = 0, j = 0; i < nkeys; i++) {
	    if ((j + keywds[order[i]]->len) >= 60) {
		printf("\n");
		j = 0;
	    }
	    printf(" %s", keywds[order[i]]->word);
	    j += keywds[order[i]]->len + 1;
	}
	printf("\n");
}
/*
 * prntvals - prints out the letter associated values
 */

prntvals()
{
	register int	i, j;

	for (i = 0, j = 0; i < MAXCHARS; i++) {
	    if (cval[i]) {
		printf("%s %c =%2d,",
		    ((++j % 10) == 0) ? "\n" : "",
		    cval[i], value[i]);
	    }
	}
	printf("\n");
}
/*
 * prnthash - prints out the hash values for the keywds
 */

VOID
prnthash()
{
	register int		i, j;
	register KEYWORD	*kp;
	int			swap;
	int			hmin;
	int			hmax;
	int			spread;


	swap = TRUE;
	hmin = MAXKEYS;
	hmax = 0;
	spread = 0;
	for (i = 0; i < nkeys; i++) {
	    j = hashval[i] = hash(keywds[i]);
	    hmin = (hmin < j) ? hmin : j;
	    hmax = (hmax > j) ? hmax : j;
	    order[i] = i;
	}
	while (swap) {		/* plain vanilla bubble sort */
	    swap = FALSE;
	    for (i = 0; i < nkeys-1; i++) {
		if (hashval[order[i+1]] < hashval[order[i]]) {
		    swap = TRUE;
		    j = order[i];
		    order[i] = order[i+1];
		    order[i+1] = j;
		}
	    }
	}
	printf("Hash min = %d, max = %d, spread = %d\n",
	    hmin, hmax, hmax - hmin + 1);
	for (i=0, j=0; i < nkeys; i++, j++) {
	    kp = keywds[order[i]];
	    if (j  + (kp->len + 5) > 60) {
		printf("\n");
		j = 0;
	    }
	    printf(" %s %d,", kp->word,
		hash(keywds[order[i]]));
	    j += (kp->len + 5);
	}
	printf("\n");
}
/*
 * search - calls itself recursively to find char values
 */

int
search(k)
register int	k;
{
	register KEYWORD	*p;
	register int		j;
	int			m;
	short			v1, v2, num;
	short			sub1, sub2, subn;
	int			thesame;

	thesame = FALSE;
	bigcount++;
	k_now = k;			/* global for status reporting	*/
	if (k >= nkeys)			/* hey - we may be all done	*/
	    return (TRUE);
	if (k > depth)			/* global for status reporting	*/
	    depth = k;			/* keep track of search depth	*/
	m = order[k];
	p = keywds[m];
	sub1 = p->word[0];		/* sub1 = first letter in word	*/
	sub2 = p->last;			/* sub2 = last letter in word	*/
	if (sub1 == sub2)
	    thesame = TRUE;
	v1 = value[sub1];
	v2 = value[sub2];
	if (defined(v1) && defined(v2)) {
	    num = hash(p);		/* Both letters defined		*/
	    if (used(num))
		return (FALSE);		/* this hash value is in use	*/
	    else {
		hashval[m] = num;	/* install it			*/
		mapped[num] = TRUE;
		if (search(k + 1))
		    return (TRUE);
		else {
		    hashval[m] = UNDEF;
		    mapped[num] = FALSE;
		    return (FALSE);
		}
	    }
	}
	else if (defined(v1)) {
	    for (j = 0; j <= nletters; j++) {
		v2 = j;
		num = v1 + p->len + v2;
		if (!used(num)) {
		    hashval[m] = num;
		    mapped[num] = TRUE;
		    value[sub2] = v2;
		    subn = sub2;
		    if (search(k + 1))
			return (TRUE);
		    else
			remove(m, sub2);
		}
	    }
	    return (FALSE);
	}
	else if (defined(v2)) {
	    for (j = 0; j <= nletters; j++) {
		v1 = j;
		num = v1 + p->len + v2;
		if (!used(num)) {
		    hashval[m] = num;
		    mapped[num] =TRUE;
		    value[sub1] = v1;
		    subn = sub1;
		    if (search(k + 1))
			return (TRUE);
		    else
			remove(m, sub1);
		}
	    }
	    return (FALSE);
	}
	else {				/* neither defined		*/
	    for (j = 0; j <= nletters; j++) {
		if (thesame) {
		    v1 = v2 = j;
		    num = v1 + p->len + v2;
		    if (!used(num)) {
			hashval[m] = num;
			mapped[num] = TRUE;
			value[sub1] = v1;	/* same as value[sub2]	*/
			subn = sub1;
			if (search(k + 1))
			    return (TRUE);
			else
			    remove(m, subn);
		    }
		}
		else {
		    value[sub1] = j;
		    if (search(k))		/* if never TRUE thru	*/
			return (TRUE);		/* for loop, then FALSE */
		    else
			value[sub1] = UNDEF;
		}
	    }
	    return (FALSE);
	}
}
/*
 * remove - backup by deleting keywds hash value etc
 */

VOID
remove(m, subn)
register short	m;
register short	subn;
{
	if (debug > 6)
	    printf("removing %s, subn = %d\n", keywds[m]->word, subn);
	mapped[hashval[m]] = FALSE;
	hashval[m] = UNDEF;
	value[subn] = UNDEF;
}
/*
 * dooutput writes parser tables to the indicated output file.
 */

char	*function[] = {
	"",
	"int",
	"keyword(text)",
	"register char\t*text;",
	"/*",
	" * Look for keyword (string of alpha) in the perfect hash table",
	" * Return the index (L_xxx value) or 0 if not found",
	" */",
	"{",
	"\tregister char\t*tp;",
	"\tregister int\thash;",
	"",
	"\tif (*text < FIRST || *text > LAST)",
	"\t    return (0);",
	"\tfor (tp = text; isalpha(*tp); tp++)",
	"\t    ;",
	"\thash = (tp - text);",
	"\tif (*--tp < FIRST || *tp > LAST)",
	"\t    return (0);",
	"\thash += (px_assoc - FIRST)[*text] + (px_assoc - FIRST)[*tp];",
	"\tif (px_table[hash] == NULL)",
	"\t    return (0);",
	"\tif (strncmp(text, px_table[hash], (tp - text + 1)) != 0)",
	"\t    return (0);",
	"\treturn(hash);",
	"}",
	"",
	NULL,
};
dooutput()
{
	FILE		*fd;
	register char	**funp;
	register int	i;
	int		first, last, hval;

	if ((fd = CREATE(output, "w")) == NULL) {
	    perror(output);
	    return;
	}
	fprintf(fd, "#include <stdio.h>\n");
	fprintf(fd, "#include <ctype.h>\n");
	for (i = 0; i < nkeys; i++) {
	    fprintf(fd, "#define\tL_%s\t", keywds[order[i]]->word);
	    if (keywds[order[i]]->len < 14)
		putc('\t', fd);
	    if (keywds[order[i]]->len <  6)
		putc('\t', fd);
	    fprintf(fd, "%d\n",	hash(keywds[order[i]]));
	}
	for (i = MAXCHARS; --i >= 0 && cval[i] == 0;)
	    ;
	last = i;
	for (i = 0; i <= last && cval[i] == 0;)
	    i++;
	first = i;
	fprintf(fd, "#define FIRST\t'%c'\n", first);
	fprintf(fd, "#define LAST\t'%c'\n", last);
	fprintf(fd, "static char px_assoc[] = {\n");
	while (i <= last) {
	    fprintf(fd, "\t%d,\t/* '%c' */\n", value[i], i);
	    i++;
	}
	fprintf(fd, "};\n");
	fprintf(fd, "static char *px_table[] = {\n");
	last = 0;
	for (i = 0; i < nkeys; i++) {
	    hval = hash(keywds[order[i]]);
	    while (last < hval) {
		fprintf(fd, "\tNULL,\t\t\t/*%3d\t*/\n", last);
		last++;
	    }
	    fprintf(fd, "\t\"%s\",\t", keywds[order[i]]->word);
	    if (keywds[order[i]]->len < 13)
		putc('\t', fd);
	    if (keywds[order[i]]->len <  5)
		putc('\t', fd);
	    fprintf(fd, "/*%3d\t*/\n", hval);
	    last = hval + 1;
	}
	fprintf(fd, "};\n");
	for (funp = function; *funp != NULL; funp++)
	    fprintf(fd, "%s\n", *funp);
	fclose(fd);
}
#if	DOALARM
/*
 * status - on signal this reports the current statistics
 */

VOID
status()
{
	fprintf(stderr,
	    "\nSTATUS:  key \"%s\" (%d), search calls = %ld, max depth = %d\n",
	    keywds[k_now]->word, k_now, bigcount, depth);
	fflush(stderr);
	signal(SIGTERM,status);
	signal(SIGALRM,status);
	alarm(atime);
}
#endif
/*
 *			G E T O P T I O N S
 *
 * Generalized command line argument processor.  The following
 * types of arguments are parsed:
 *	flags		The associated int global is incremented:
 *			-f	f-flag set to 1
 *			-f123	f-flag set to 123 (no separator)
 *			-fg	f-flag and g-flag incremented.
 *	values		A value must be present.  The associated
 *			int global receives the value:
 *			-v123	value set to 123
 *			-v 123	value set to 123
 *	arguments	The associated global (a char *) is
 *			set to the next argument:
 *			-f foo	argument set to "foo"
 */

#define	FLAG	0
#define	VALUE	1
#define	ARG	2
#define	ERROR	3

typedef struct argstruct {
	char	opt;		/* Option byte			*/
	char	type;		/* FLAG/VALUE/ARG		*/
	char	*name;		/* What to set if option seen	*/
	char	*what;		/* String for error message	*/
} ARGSTRUCT;

static ARGSTRUCT arginfo[] = {
{ 'd',	FLAG,	(char *)&debug,		"debug" },
{ 'a',	VALUE,	(char *)&atime,		"alarm time for status" },
{ 't',	VALUE,	(char *)&tlimit,	"table size limit" },
{ 'v',	VALUE,	(char *)&vlimit,	"associated value limit" },
{ 'k',	VALUE,	(char *)&keylimit,	"keyword limit" },
{ 'n',	FLAG,	(char *)&nosort,	"no sort wanted" },
{ 'o',	ARG,	(char *)&output,	"parser output file" },
{ EOS,	ERROR,	NULL,			NULL },
};

static char *argtype[] = {
	"flag", "takes value", "takes argument"
};
static
getoptions(argc, argv)
int		argc;
char		**argv;
/*
 * Process arg's
 */
{
	register char		*ap;
	register int		c;
	register ARGSTRUCT	*sp;
	int			i;
	int			helpneeded;

	getredirection(argc, argv);
	helpneeded = FALSE;
	for (i = 1; i < argc; i++) {
	    if ((ap = argv[i]) != NULL && *ap == '-') {
		argv[i] = NULL;
		for (ap++; (c = *ap++) != EOS;) {
		    if (isupper(c))
			c = tolower(c);
		    sp = arginfo;
		    while (sp->opt != EOS && sp->opt != c)
			sp++;
		    switch (sp->type) {
		    case FLAG:			/* Set the flag	*/
			if (!isdigit(*ap)) {
			    (*((int *)sp->name))++;
			    break;
			}
		    case VALUE:			/* -x123	*/
		        if (isdigit(*ap)) {
			    *((int *)sp->name) = atoi(ap);
			    *ap = EOS;
			}
			else if (*ap == EOS && ++i < argc) {
			    *((int *)sp->name) = atoi(argv[i]);
			    argv[i] = NULL;
			}
			else {
			    fprintf(stderr,
				"Bad option '%c%s' (%s)",
				c, ap, sp->what);
			    fprintf(stderr, ", ignored\n");
			    helpneeded++;
			}
			break;

		    case ARG:			/* -x foo	*/
			if (++i < argc) {
			    *((char **) sp->name) = argv[i];
			    argv[i] = NULL;
			}
			else {
			    fprintf(stderr,
				"Argument needed for '%c' (%s)",
				c, sp->what);
			    fprintf(stderr, ", ignored\n");
			    helpneeded++;
			}
			break;

		    case ERROR:
			fprintf(stderr,
			    "Unknown option '%c', ignored\n", c);
			helpneeded++;
			break;
		    }
		}
	    }
	}
	if (helpneeded > 0) {
	    for (sp = arginfo; sp->opt != EOS; sp++) {
		fprintf(stderr, "'%c' -- %s (%s)\n",
		    sp->opt, sp->what, argtype[sp->type]);
	    }
	}
}
/*
 * getredirection() is intended to aid in porting C programs
 * to VMS (Vax-11 C) which does not support '>' and '<'
 * I/O redirection.  With suitable modification, it may
 * useful for other portability problems as well.
 */

#include	<stdio.h>

getredirection(argc, argv)
int		argc;
char		**argv;
/*
 * Process vms redirection arg's.  Exit if any error is seen.
 * If getredirection() processes an argument, argv[i], it is changed
 * to NULL.
 *
 * Warning: do not try to simplify the code for vms.  The code
 * presupposes that getredirection() is called before any data is
 * read from stdin or written to stdout.
 *
 * Normal usage is as follows:
 *
 *	main(argc, argv)
 *	int		argc;
 *	char		*argv[];
 *	{
 *		register int		i;
 *		int			nargs;
 *
 *		getredirection(argc, argv);	** setup redirection
 *		for (nargs = 0, i = 1; i < argc, i++) {
 *		    if (argv[i] == NULL)	** skip if processed
 *			continue;		** by getredirection()
 *		    nargs++;			** here is an argument
 *		    ...				** process argv[i]
 *		}
 *		if (nargs == 0) {		** no arguments given
 *		    ...
 *		}
 *	}
 */
{
#ifdef	vms
	register char		*ap;	/* Argument pointer	*/
	int			i;	/* argv[] index		*/
	int			file;	/* File_descriptor 	*/
	extern int		errno;	/* Last vms i/o error 	*/

	for (i = 1; i < argc; i++) {	/* Do all arguments	*/
	    if (*(ap = argv[i]) == '<') {  /* <file		*/
		if (freopen(++ap, "r", stdin) == NULL) {
		    perror(ap);		/* Can't find file	*/
		    exit(errno);	/* Is a fatal error	*/
		}
		goto erase_arg;		/* Ok, erase argument	*/
	    }
	    else if (*ap++ == '>') {	/* >file or >>file	*/
		if (*ap == '>') {	/* >>file		*/
		    /*
		     * If the file exists, and is writable by us,
		     * call freopen to append to the file (using the
		     * file's current attributes).  Otherwise, create
		     * a new file with "vanilla" attributes as if
		     * the argument was given as ">filename".
		     * access(name, 2) is TRUE if we can write on
		     * the specified file.
		     */
		    if (access(++ap, 2) == 0) {
			if (freopen(ap, "a", stdout) == NULL) {
			    perror(ap);
			    exit(errno);
			}
			else goto erase_arg;
		    }			/* If file accessable	*/
		    else ;		/* Else it's just >file	*/
		}
		/*
		 * On vms, we want to create the file using "standard"
		 * record attributes.  create(...) creates the file
		 * using the caller's default protection mask and
		 * "variable length, implied carriage return"
		 * attributes. dup2() associates the file with stdout.
		 */
		if ((file = creat(ap, 0, "rat=cr", "rfm=var")) == -1
		 || dup2(file, fileno(stdout)) == -1) {
		    perror(ap);		/* Can't create file	*/
		    exit(errno);	/* is a fatal error	*/
		}			/* If '>' creation	*/
erase_arg:	argv[i] = NULL;		/* red. erases argument	*/
	    }				/* If redirection	*/
	}				/* For all arguments	*/
#endif
#ifdef	decus
	argc = argv[0];			/* Supress warning msg.	*/
#endif
}

#if	UNIX
/*
 * The following is missing on some Unix systems
 */

char *
strchr(string, c)
register char	*string;
register char	c;
/*
 * If 'c' is in string, return a pointer to it.
 * Else, return NULL.
 */
{
	do {
	    if (*string == c)
		return (string);
	} while (*string++ != EOS);
	return (NULL);
}
#endif
