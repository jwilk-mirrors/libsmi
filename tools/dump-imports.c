/*
 * dump-imports.c --
 *
 *      Operations to dump import hierarchies in a human readable format.
 *
 * Copyright (c) 1999 Frank Strauss, Technical University of Braunschweig.
 * Copyright (c) 1999 J. Schoenwaelder, Technical University of Braunschweig.
 *
 * See the file "COPYING" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * @(#) $Id: dump-imports.c,v 1.7 2000/02/06 23:30:59 strauss Exp $
 */

#include <stdio.h>
#include <string.h>

#include "smi.h"
#include "smidump.h"


typedef struct Imports {
    char *module;
    int  count;
} Imports;



static Imports *getImports(SmiModule *smiModule, int *n)
{
    SmiImport *smiImport;
    Imports   *imports;
    int       i, size;
    
    for(smiImport = smiGetFirstImport(smiModule), *n = 0;
	smiImport; smiImport = smiGetNextImport(smiImport)) {
	(*n)++;
    }

    size = (*n + 1) * sizeof(Imports);
    imports = xmalloc(size);
    memset(imports, 0, size);

    for(smiImport = smiGetFirstImport(smiModule), *n = 0;
	smiImport; smiImport = smiGetNextImport(smiImport)) {
	
	for (i = 0; i < *n; i++) {
	    if (strcmp(smiImport->module, imports[i].module) == 0) {
		break;
	    }
	}
	
	if (i == *n) {
	    imports[i].module = xstrdup(smiImport->module);
	    if (imports[i].module) {
		imports[i].count = 0;
		(*n)++;
	    }
	}
	imports[i].count++;
    }

    return imports;
}



static void freeImports(Imports *imports, int n)
{
    int i;

    for (i = 0; i < n; i++) {
	xfree(imports[i].module);
    }

    xfree(imports);
}



static int printImports(SmiModule *smiModule, char *prefix)
{
    SmiModule *smiModule2;
    Imports *imports;
    int     i, n, recurse = 0, done = 0;

    imports = getImports(smiModule, &n);

    for (i = 0; i < n; i++) {
	char *newprefix;
	SmiImport *firstImport;

	smiModule2 = smiGetModule(imports[i].module);
	firstImport = smiGetFirstImport(smiModule2);
	recurse = (firstImport == NULL);
	if (recurse) {
	    printf("%s  |\n", prefix);
	}
	printf("%s  +--%s [%d identifier%s]\n", prefix, imports[i].module, 
	       imports[i].count, imports[i].count > 1 ? "s" : "");
	newprefix = xmalloc(strlen(prefix)+10);
	strcpy(newprefix, prefix);
	if (i == n-1) {
	    strcat(newprefix, "   ");
	} else {
	    strcat(newprefix, "  |");
	}
	done = printImports(smiModule2, newprefix);
	if (! recurse && done) {
	    if (i == n-1) {
		printf("%s   \n", prefix);
	    } else {
		printf("%s  |\n", prefix);
	    }
	}
	xfree(newprefix);
    }

    freeImports(imports, n);

    return recurse;
}



int dumpImports(char *modulename, int flags)
{
    SmiModule	 *smiModule;

    smiModule = smiGetModule(modulename);
    if (!smiModule) {
	fprintf(stderr, "smidump: cannot locate module `%s'\n", modulename);
	exit(1);
    }
    
    if (! (flags & SMIDUMP_FLAG_SILENT)) {
	printf("# %s imports tree (generated by smidump "
	       VERSION ")\n\n", modulename);
    }

    printf("%s\n", smiModule->name);
    printImports(smiModule, "");

    return 0;
}
