# This is a shell archive.  Remove anything before this line, then
# unpack it by saving it in a file and typing "sh file".  (Files
# unpacked will be owned by you and have default permissions.)
#
# This archive contains:
# README Makefile getopt.c main.c foo perfect.hdr

echo x - README
cat > "README" << '//E*O*F README//'
History:
	On 10/7/83 C. Havener (charlie at genrad.UUCP) put a perfect hash
	function finding program on the net.  On 11/4/84 R. Dietrich
	(robertd at tektronix.UUCP) put a Pascal version of the same program
	on the net.  Both of these programs were based on "More on Minimal
	Perfect Hash Tables," Colorado State University Technical Report,
	April 1981, by Cook, Curtis R. and Oldehoeft, R. R., and "Minimal
	Perfect Hash Functions Made Simple" by Richard J. Cichelli - Comm.
	of ACM Jan 1980.

These programs had the following limitations, some of which they shared,
some of which they didn't:
	-- limited number of strings (40 or 110) per hash table.
	-- slow to extremely slow run-time (large amounts of both
		recursion and parallel array processing).
	-- a requirement that the hash strings be in a certain order.
	-- a fixed hashing algorithm.
	-- inability to handle strings that hashed to identical values.

In a recent program I was doing, I had to hash approximately 500 different
keywords, preferably in one access.  To do this, I ended up rewriting the
above programs.  The attached version has fixed some of the limitations.
	-- no keyword limit; I've used it to hash up to about 2400 entries.
	-- it's several orders of magnitude faster.
	-- it's fairly indifferent to the order the strings are presented in.
	-- you can specify the keys to be hashed.
	-- it handles strings that hash to identical values.

The basic algorithm is:

	hash = the length of the string plus the sum of all of the
		associated values of the key characters.

	The program assigns values to the characters it is using for
	hashing until a set of the values gives each keyword a unique
	value.

For example: If the string was "thekid" and the key characters were
't' and 'd', with 't' having a value of 5 and 'd' having a value of
8, the hash value of "thekid" would be 19; 8 + 5 + strlen("thekid");

It takes two arguments --
-d --	print out some interesting debugging information.
-k --	use the following characters of the string in the hashing algorithm.
	If the program was called as "perf -k137" and the string "abcdefgh"
	was entered, the characters 'a', 'c', and 'g' would be used by the
	hashing scheme.  To make this easier, the program prints out a routine
	at the end of its run that, when passed a string, will return the
	correct hash value.  Also, the special character '$' tells the program
	to use the last character of every string.  Default, if the k flag
	isn't specified, is "-k1$", i.e. the first and last character of every
	string.

followed by a filename containing the keywords.

Ex:	suppose there's a file "foo" containing the keywords:
======================================================================
//E*O*F README//

echo x - Makefile
cat > "Makefile" << '//E*O*F Makefile//'
perfect: main.c getopt.o
	cc -o perfect main.c getopt.o

getopt.o: getopt.c
//E*O*F Makefile//

echo x - getopt.c
cat > "getopt.c" << '//E*O*F getopt.c//'
/*
 * getopt - get option letter from argv
 */

#include <stdio.h>

char	*optarg;	/* Global argument pointer. */
int	optind = 0;	/* Global argv index. */

static char	*scan = NULL;	/* Private scan pointer. */

extern char	*index();

int
getopt(argc, argv, optstring)
int argc;
char *argv[];
char *optstring;
{
	register char c;
	register char *place;

	optarg = NULL;

	if (scan == NULL || *scan == '\0') {
		if (optind == 0)
			optind++;
	
		if (optind >= argc || argv[optind][0] != '-' || argv[optind][1] == '\0')
			return(EOF);
		if (strcmp(argv[optind], "--")==0) {
			optind++;
			return(EOF);
		}
	
		scan = argv[optind]+1;
		optind++;
	}

	c = *scan++;
	place = index(optstring, c);

	if (place == NULL || c == ':') {
		fprintf(stderr, "%s: unknown option -%c\n", argv[0], c);
		return('?');
	}

	place++;
	if (*place == ':') {
		if (*scan != '\0') {
			optarg = scan;
			scan = NULL;
		} else if (optind < argc) {
			optarg = argv[optind];
			optind++;
		} else {
			fprintf( stderr, "%s: -%c argument missing\n", 
					argv[0], c);
			return( '?' );
		}
	}

	return(c);
}
//E*O*F getopt.c//

echo x - main.c
cat > "main.c" << '//E*O*F main.c//'
#include <stdio.h>
#include <ctype.h>

/*
 * Find a "perfect" hashing function.
 * Args:
 *	d: turn on debugging.
 *	k: specify chars to use; '$' means use last character.
 * Tuneable defines:
 *	TRYLIM:	how many guesses each character change gets
 *	TRYNUM:	how many characters to try per conflict
 *	RANGE:	how big a range to distribute numbers over
 * Bugs, fixes, etc:
 *	Keith Bostic	keith at seismo.ARPA
 *			seismo!keith.UUCP
 */

#define CSIZE		127	/* hold all possible characters */
#define JVAL		3	/* how much to jump when trying values */
#define MAXKEY		15	/* maximum length of key word */
#define NO		0	/* general no, not okay */
#define RANGE		3	/* range to scatter keys over */
#define TRYLIM		10	/* how many attempts to forecast */
#define TRYNUM		5	/* how many chars to attempt */
#define YES		1	/* general yes, okay */

#define KEY	struct key	/* structure to hold hash strings */
KEY {
    char   *word;		/* hash string itself */
    long    hval;		/* hash value itself */
    short   set[MAXKEY + 1],	/* set of chars to hash */
            len,		/* length of hash string */
            link;		/* if hard linked to another key */
} *begkey,			/* start of hash strings */
*endkey,			/* end of hash strings */
*b_first,			/* best, first key hit */
*cur;				/* current hash string */

static int  b_hit,		/* best hit value so far */
            nkeys,		/* number of keys given */
            split,		/* how wide a spread for key values */
            cval[CSIZE],	/* associated character values */
            use[CSIZE];		/* number of times character used */
static char *myname;		/* name program called with */
static short    b_new,		/* best increment value so far */
                b_val,		/* char best stuff found for */
                debug,		/* if debugging wanted */
                pk[11] = {
    1, -1, 0
};				/* keys to look at, default 1,$ */

main (argc, argv)
int     argc;
char  **argv;
{
    register    KEY * K;

    myname = *argv;
    parse (argc, argv);
    keyread ();
    setlink ();
    setuse ();
    srand (1);
    hash (begkey);
    for (cur = begkey + 1; cur < endkey; ++cur)
	if (!cur -> link) {
	    if (debug)
		printf ("current key: <%s>\n", cur -> word);
	    hash (cur);
	    for (K = begkey; K < cur; ++K)
		if (!K -> link && K -> hval == cur -> hval) {
		    if (debug)
			printf ("\t<%s> <%s> hashed to <%D>\n", 
				K -> word, cur -> word, K -> hval);
		    change (K);
		    break;
		}
	}
    pvals ();
    pcode ();
}

static				/* change a character value */
        change (arg)		/* try least-used characters first */
        KEY * arg;
{
    register short *S1,
                   *S2,
                   *S3;
    register    KEY * K;
    short   val1[2 * MAXKEY + 1],
            val2[MAXKEY + 1];
 /* copy lists of values */
    for (S1 = val1, S2 = arg -> set; *S1++ = *S2++;);
    for (S1 = val2, S2 = cur -> set; *S1++ = *S2++;);
    for (S1 = val1; *S1; ++S1)	/* if value in both keys equal */
	for (S2 = val2;; ++S2)	/* number of times, ignore it */
	    if (!*S2)
		break;
	    else
		if (*S2 == *S1) {
		    *S2 = *S1 = -1;
		    break;
		}		/* clean out repeats/undefs in val1 */
    for (S1 = S2 = val1; *S1 = *S2; ++S2) {
	if (*S1 != -1)
	    ++S1;
	for (S3 = S2 + 1; *S3; ++S3)
	    if (*S3 == *S2)
		*S3 = -1;
    }
    for (S2 = val2; *S1 = *S2; ++S2) {
	if (*S1 != -1)
	    ++S1;
	for (S3 = S2 + 1; *S3; ++S3)
	    if (*S3 == *S2)
		*S3 = -1;
    }				/* S3 now storage or counter */
    for (S1 = val1, S3 = val2; *S1; ++S1)/* sort by usage, bubble */
	for (S2 = S1 + 1; *S2; ++S2)/* since max MAXKEY * 2 items */
	    if (use[*S1] > use[*S2]) {
		*S3 = *S1;
		*S1 = *S2;
		*S2 = *S3;
	    }
    b_hit = nkeys + 1;
    for (*S3 = 0, S1 = val1; *S1 && *S3 < TRYNUM; ++S1, ++*S3)
	if (!fore (*S1))
	    return;		/* try changing some values */
    if (debug)
	printf ("\tused <%c> with <%d> hits.\n", (char) b_val, b_hit);
    cval[b_val] = b_new;	/* take best value */
    for (K = begkey; K < b_first; ++K)
	if (!K -> link)
	    hash (K);
    cur = b_first - 1;		/* reset current value */
}

static				/* find out how character value change
				   will effect */
        fore (val)		/* already successfully hashed items */
short   val;
{
    register    KEY * K1,
               *K2;
    register short *S;
    register int    hit;
    KEY * K_frst;
    int     save;
    short   cnt;

    save = cval[val];		/* save original values */
    cval[val] = rand () % split;/* get a new one */
    if (debug)
	printf ("\ttrying <%c> used <%d> times -- ", (char) val, use[val]);
    for (cnt = 0; cnt < TRYLIM; ++cnt) {
	for (K1 = begkey; K1 <= cur; ++K1)
	    hash (K1);
	K_frst = (KEY *) NULL;
	for (hit = 0, K1 = begkey; K1 < cur; ++K1) {
	    if (K1 -> link)
		continue;
	    for (S = K1 -> set; *S && *S != val; ++S);
	    if (!*S)
		continue;
	    for (K2 = K1 + 1; K2 <= cur; ++K2)
		if (!K2 -> link && K1 -> hval == K2 -> hval) {
		    if (++hit >= b_hit)
			goto loop;
		    if (!K_frst)
			K_frst = K2;
		}
	}
	b_new = cval[b_val = val];
	b_first = K_frst;
	if (!(b_hit = hit)) {
	    if (debug)
		puts ("0");
	    return (NO);	/* no hits, use it */
	}
loop: 	if (debug)
	    printf ("%d ", hit);
	cval[val] += JVAL;
    }
    cval[val] = save;		/* restore original values */
    if (debug)
	putchar ('\n');
    return (YES);
}

static
        keyread () {		/* get key words */
    register short *S1,
                   *S2;
    register    KEY * K;
    char    name[MAXKEY],
           *gets (), *malloc (), *strcpy ();

    while (gets (name))
	if (*name)
	    ++nkeys;
    if (!nkeys)
	die ("no key words supplied.");
    rewind (stdin);
    if (!(begkey = (KEY *) malloc ((unsigned) (sizeof (KEY) * nkeys))))
	die ("malloc failure.");
    for (K = begkey; gets (name);) {
	if (!*name)
	    continue;
	if (!(K -> word = malloc ((unsigned) ((K -> len = strlen (name)) + 1))))
	    die ("malloc failure.");
	strcpy (K -> word, name);
	for (S1 = K -> set, S2 = pk; *S2; ++S2)
	    if (*S2 == -1)
		*S1++ = (short) K -> word[K -> len - 1];
	    else
		if (K -> len >= *S2)
		    *S1++ = (short) K -> word[*S2 - 1];
	if (S1 == K -> set) {
	    fprintf (stderr, "%s: can't hash keyword %s with %s.\n", myname, name, pk);
	    exit (1);
	}
	if (debug)
	    printf ("read <%s>\n", K -> word);
	++K;
    }
    endkey = begkey + nkeys;
    split = nkeys * RANGE;
}

static
        hash (K)		/* actually hash a string */
register    KEY * K;
{
    register short *S;

    for (K -> hval = K -> len, S = K -> set; *S; ++S)
	K -> hval += cval[*S];
}

static
        pvals () {		/* print out hashed values */
    register    KEY * K1,
               *K2;
    register short  cnt;
    int     nlink = 0;
    int     minkey;
    int     maxkey;

    if (debug) {
	for (cnt = 0; cnt < CSIZE; ++cnt)
	    if (use[cnt])
		if (isprint ((char) cnt))
		    printf ("%-3c -- %d\n", (char) cnt, cval[cnt]);
		else
		    printf ("<%o> -- %d", cnt, cval[cnt]);
    }
    for (K1 = begkey; K1 < endkey; ++K1)
	hash (K1);
    minkey =  9999;
    maxkey = -9999;
    for (K1 = begkey; K1 < endkey; ++K1) {
	if (K1 -> hval == -1)
	    continue;
	/* mwh
	printf ("%-10D -- %s", K1 -> hval, K1 -> word);
	*/
	printf ("#define %-12s	%d\n", K1 -> word, K1 -> hval);
	if (K1 -> hval > maxkey) maxkey = K1 -> hval;
	if (K1 -> hval < minkey) minkey = K1 -> hval;
	for (K2 = K1 + 1; K2 < endkey; ++K2)
	    if (K2 -> hval == K1 -> hval) {
		++nlink;
		/* mwh
		putc (' ', stdout);
		fputs (K2 -> word, stdout);
		*/
		printf ("#define %-12s	%d	/* conflict */\n", 
			K2 -> word, K2 -> hval);
		K2 -> hval = -1;
	    }
	/* mwh
	putc ('\n', stdout);
	*/
    }
    putc ('\n', stdout);
    printf ("#define MINKEY	%d\n", minkey); /* mwh */
    printf ("#define MAXKEY	%d\n", maxkey); /* mwh */

    printf ("\n%s: %d keywords\n", myname, nkeys); /* mwh */
    printf ("%s: %d is the maximum key range\n", myname, 
		maxkey-minkey+1); /* mwh */
    if (nlink)
	printf ("%s: %d conflicts\n", myname, nlink); /* mwh */
}

static
        parse (nargc, nargv)	/* deal with arguments */
int     nargc;			/* set debug flag */
char  **nargv;			/* open keyword file for reading */
{
    extern int  optind;
    extern char *optarg;
    register short *S;
    register char  *C;
    register int    c;

    while ((c = getopt (nargc, nargv, "dk:")) != EOF)
	switch ((char) c) {
	    case 'd': 		/* debug flag */
		debug = YES;
		printf ("starting %s.\n", myname);
		break;
	    case 'k': 		/* number of keys */
		for (C = optarg, S = pk; *C; ++C)
		    if (*C <= '9' && *C > '0')
			*S++ = *C - '0';
		    else
			if (*C == '$')
			    *S++ = -1;
			else
			    die ("illegal key value.  Use 1-9 or $.");
		if (S == pk)
		    die ("no selected keys.");
		*S = 0;
		break;
	    default: 
		fprintf (stderr, "usage: %s [-d] [-k keys] file\n", myname);
		exit (1);
	}
    if (!*nargv[optind] || !freopen (nargv[optind], "r", stdin))
	die ("unable to read key word file.");
}

static
        die (msg)		/* die with some last words */
register char  *msg;
{
    fprintf (stderr, "%s: %s\n", myname, msg);
    exit (1);
}

static
        setlink () {		/* get rid of unhashables *//* if keys are
				   identical (in any order) */
    register short *S1,		/* and length is the same, it's a link */
                   *S2;
    register    KEY * K1,
               *K2;
    short   hold[MAXKEY + 1];

    for (K1 = begkey; K1 < endkey - 1; ++K1)
	if (K1 -> link)
	    continue;
	else
	    for (K2 = K1 + 1; K2 < endkey; ++K2) {
		if (K2 -> link || K2 -> len != K1 -> len)
		    continue;
		for (S1 = hold, S2 = K2 -> set; *S1++ = *S2++;);
		for (S1 = K1 -> set;; ++S1) {
		     /* lengths are equal */ if (!*S1) {
			 /* so keys must be too */ K2 -> link = YES;
			if (debug)
			    printf ("linked <%s> to <%s>\n", K2 -> word, K1 -> word);
			break;
		    }
		    for (S2 = hold; *S2 && *S2 != *S1; ++S2);
		    if (*S2)
			*S2 = -1;
		    else
			break;
		}
	    }
}

setuse () {			/* initialize how many times a character
    is used *//* initialize values of those characters */
    register    KEY * K;
    register short *S,
                    cnt;

    for (K = begkey; K < endkey; ++K)
	if (!K -> link)
	    for (S = K -> set; *S; ++S)
		++use[*S];
    for (cnt = 0; cnt < CSIZE; ++cnt)
	if (use[cnt])
	    cval[cnt] = rand () % split;
}

static
        pcode () {		/* print out the code to hash */
    register short *S1,
                   *S2;
    register short  cnt;
    char    hold;
    short   dollar = NO;

    for (S1 = pk; *S1; ++S1)
	if (*S1 == -1) {
	    dollar = YES;
	    break;
	}
    fputs ("\n******\n\nstatic long\nhash(str)\nregister char\t*str;\n{\n\tstatic int	cval[] = {", stdout);
    for (cnt = 0; cnt < CSIZE; ++cnt) {
	if (!(cnt % 10))
	    fputs ("\n\t\t", stdout);
	printf ("%d, ", cval[cnt]);
    }
    fputs ("\n\t};\n\tregister long\thval;\n", stdout);
    if (dollar)
	fputs ("\tregister int\tlen;\n\n\tswitch(hval = (long)(len = strlen(str)))", stdout);
    else
	fputs ("\n\tswitch(hval = strlen(str))", stdout);
    fputs (" {\n\t\tdefault:\n", stdout);
    for (S1 = pk; *S1; ++S1)
	for (S2 = S1 + 1; *S2; ++S2)
	    if (*S2 < *S1) {
		hold = *S2;
		*S2 = *S1;
		*S1 = hold;
	    }
    cnt = *--S1;
    printf ("\t\t\thval += cval[(int)str[%d]];\n", *S1 - 1);
    for (--S1; S1 >= pk; --S1)
	if (*S1 == -1)
	    printf ("\t\t\thval += cval[(int)str[len - 1]];\n", *S1);
	else {
	    while (--cnt > *S1)
		printf ("\t\tcase %d:\n", cnt);
	    printf ("\t\tcase %d:\n\t\t\thval += cval[(int)str[%d]];\n", *S1, *S1 - 1);
	}
    fputs ("\t\tcase 0:\n\t\t\treturn(hval);\n\t}\n}\n", stdout);
}
//E*O*F main.c//

echo x - foo
cat > "foo" << '//E*O*F foo//'
political
man
can
have
as
his
aim
the
realization
of
freedom
//E*O*F foo//

echo x - perfect.hdr
cat > "perfect.hdr" << '//E*O*F perfect.hdr//'