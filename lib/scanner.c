/*
 * scanner.c --
 *
 *      Variables and functions needed by all scanner backends.
 *
 * Copyright (c) 1999 Frank Strauss, Technical University of Braunschweig.
 *
 * See the file "COPYING" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * @(#) $Id: scanner.c,v 1.4 1999/05/31 11:58:36 strauss Exp $
 */

#if defined(BACKEND_SMI) || defined(BACKEND_SMING)

#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>

#include "error.h"



#define thisParser      (*(Parser *)parser)



char *currentString = NULL;
int currentStringLength = 0;
int currentStringMaxLength = 0;
int currentStringColumn = 0;
int currentStringFetchLine = 0; 

int lexDepth = 0;



#endif

