/*
 * parser-smi.y --
 *
 *      Syntax rules for parsing the SMIv1/v2 MIB module language.
 *
 * Copyright (c) 1998 Technical University of Braunschweig.
 *
 * See the file "license.terms" for information on usage and redistribution
 * of this file, and for a DISCLAIMER OF ALL WARRANTIES.
 *
 * @(#) $Id: parser-smi.y,v 1.5 1999/03/17 19:09:08 strauss Exp $
 */

%{

#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
    
#ifdef linux
#include <getopt.h>
#endif

#include "defs.h"
#include "smi.h"
#include "error.h"
#include "parser-smi.h"
#include "scanner-smi.h"
#include "data.h"
#include "util.h"
    


/*
 * These arguments are passed to yyparse() and yylex().
 */
#define YYPARSE_PARAM parserPtr
#define YYLEX_PARAM   parserPtr

    
    
#define thisParserPtr      ((Parser *)parserPtr)
#define thisModulePtr     (((Parser *)parserPtr)->modulePtr)


    
/*
 * NOTE: The argument lvalp ist not really a void pointer. Unfortunately,
 * we don't know it better at this point. bison generated C code declares
 * YYSTYPE just a few lines below based on the `%union' declaration.
 */
extern int yylex(void *lvalp, Parser *parserPtr);



Node   *parentNodePtr;

 
 
%}

/*
 * The grammars start symbol.
 */
%start mibFile



/*
 * We call the parser from within the parser when IMPORTing modules,
 * hence we need reentrant parser code. This is a bison feature.
 */
%pure_parser



/*
 * The attributes.
 */
%union {
    char        *text;	       			/* scanned quoted text       */
    char        *id;				/* identifier name           */
    int         err;				/* actually just a dummy     */
    Object      *objectPtr;			/* object identifier         */
    smi_status  status;				/* a STATUS value            */
    smi_access  access;				/* an ACCESS value           */
    Type        *typePtr;
    List        *listPtr;			/* SEQUENCE and INDEX lists  */
}



/*
 * Tokens and their attributes.
 */
%token DOT_DOT
%token COLON_COLON_EQUAL

%token <id>UPPERCASE_IDENTIFIER
%token <id>LOWERCASE_IDENTIFIER
%token <id>NUMBER
%token <text>BIN_STRING
%token <text>HEX_STRING
%token <text>QUOTED_STRING

%token <id>ACCESS
%token <id>AGENT_CAPABILITIES
%token <id>APPLICATION
%token <id>AUGMENTS
%token <id>BEGIN_
%token <id>BITS
%token <id>CHOICE
%token <id>CONTACT_INFO
%token <id>CREATION_REQUIRES
%token <id>COUNTER32
%token <id>COUNTER64
%token <id>DEFINITIONS
%token <id>DEFVAL
%token <id>DESCRIPTION
%token <id>DISPLAY_HINT
%token <id>END
%token <id>ENTERPRISE
%token <id>EXPORTS
%token <id>FROM
%token <id>GROUP
%token <id>GAUGE32
%token <id>IDENTIFIER
%token <id>IMPLICIT
%token <id>IMPLIED
%token <id>IMPORTS
%token <id>INCLUDES
%token <id>INDEX
%token <id>INTEGER
%token <id>INTEGER32
%token <id>IPADDRESS
%token <id>LAST_UPDATED
%token <id>MACRO
%token <id>MANDATORY_GROUPS
%token <id>MAX_ACCESS
%token <id>MIN_ACCESS
%token <id>MODULE
%token <id>MODULE_COMPLIANCE
%token <id>MODULE_IDENTITY
%token <id>NOTIFICATIONS
%token <id>NOTIFICATION_GROUP
%token <id>NOTIFICATION_TYPE
%token <id>OBJECT
%token <id>OBJECT_GROUP
%token <id>OBJECT_IDENTITY
%token <id>OBJECT_TYPE
%token <id>OBJECTS
%token <id>OCTET
%token <id>OF
%token <id>ORGANIZATION
%token <id>OPAQUE
%token <id>PRODUCT_RELEASE
%token <id>REFERENCE
%token <id>REVISION
%token <id>SEQUENCE
%token <id>SIZE
%token <id>STATUS
%token <id>STRING
%token <id>SUPPORTS
%token <id>SYNTAX
%token <id>TEXTUAL_CONVENTION
%token <id>TIMETICKS
%token <id>TRAP_TYPE
%token <id>UNITS
%token <id>UNIVERSAL
%token <id>UNSIGNED32
%token <id>VARIABLES
%token <id>VARIATION
%token <id>WRITE_SYNTAX



/*
 * Types of non-terminal symbols.
 */
%type  <err>mibFile
%type  <err>modules
%type  <err>module
%type  <id>moduleName
%type  <id>importIdentifier
%type  <err>importIdentifiers
%type  <id>importedKeyword
%type  <err>linkagePart
%type  <err>linkageClause
%type  <err>importPart
%type  <err>imports
%type  <err>declarationPart
%type  <err>declarations
%type  <err>declaration
%type  <err>exportsClause
%type  <err>macroClause
%type  <id>macroName
%type  <typePtr>choiceClause
%type  <id>typeName
%type  <id>typeSMI
%type  <err>typeTag
%type  <err>valueDeclaration
%type  <typePtr>conceptualTable
%type  <typePtr>row
%type  <typePtr>entryType
%type  <listPtr>sequenceItems
%type  <objectPtr>sequenceItem
%type  <typePtr>Syntax
%type  <typePtr>sequenceSyntax
%type  <typePtr>NamedBits
%type  <typePtr>NamedBit
%type  <id>identifier
%type  <err>objectIdentityClause
%type  <err>objectTypeClause
%type  <err>trapTypeClause
%type  <text>descriptionClause
%type  <err>VarPart
%type  <err>VarTypes
%type  <err>VarType
%type  <err>DescrPart
%type  <access>MaxAccessPart
%type  <err>notificationTypeClause
%type  <err>moduleIdentityClause
%type  <err>typeDeclaration
%type  <typePtr>typeDeclarationRHS
%type  <typePtr>ObjectSyntax
%type  <typePtr>sequenceObjectSyntax
%type  <err>valueofObjectSyntax
%type  <typePtr>SimpleSyntax
%type  <err>valueofSimpleSyntax
%type  <typePtr>sequenceSimpleSyntax
%type  <typePtr>ApplicationSyntax
%type  <typePtr>sequenceApplicationSyntax
%type  <err>anySubType
%type  <err>integerSubType
%type  <err>octetStringSubType
%type  <err>ranges
%type  <err>range
%type  <err>value
%type  <err>enumSpec
%type  <err>enumItems
%type  <err>enumItem
%type  <err>enumNumber
%type  <status>Status
%type  <status>Status_Capabilities
%type  <text>DisplayPart
%type  <text>UnitsPart
%type  <access>Access
%type  <listPtr>IndexPart
%type  <listPtr>IndexTypes
%type  <objectPtr>IndexType
%type  <objectPtr>Index
%type  <listPtr>Entry
%type  <err>DefValPart
%type  <err>Value
%type  <err>BitsValue
%type  <err>BitNames
%type  <err>BitName
%type  <objectPtr>ObjectName
%type  <objectPtr>NotificationName
%type  <err>ReferPart
%type  <err>RevisionPart
%type  <err>Revisions
%type  <err>Revision
%type  <err>ObjectsPart
%type  <err>Objects
%type  <err>Object
%type  <err>NotificationsPart
%type  <err>Notifications
%type  <err>Notification
%type  <text>Text
%type  <text>ExtUTCTime
%type  <objectPtr>objectIdentifier
%type  <objectPtr>subidentifiers
%type  <objectPtr>subidentifier
%type  <err>objectIdentifier_defval
%type  <err>subidentifiers_defval
%type  <err>subidentifier_defval
%type  <err>objectGroupClause
%type  <err>notificationGroupClause
%type  <err>moduleComplianceClause
%type  <err>ModulePart_Compliance
%type  <err>Modules_Compliance
%type  <err>Module_Compliance
%type  <err>ModuleName_Compliance
%type  <err>MandatoryPart
%type  <err>Groups
%type  <err>Group
%type  <err>CompliancePart
%type  <err>Compliances
%type  <err>Compliance
%type  <err>ComplianceGroup
%type  <err>Object_Compliance
%type  <err>SyntaxPart
%type  <err>WriteSyntaxPart
%type  <err>WriteSyntax
%type  <access>AccessPart
%type  <err>agentCapabilitiesClause
%type  <err>ModulePart_Capabilities
%type  <err>Modules_Capabilities
%type  <err>Module_Capabilities
%type  <err>ModuleName_Capabilities
%type  <err>VariationPart
%type  <err>Variations
%type  <err>Variation
%type  <err>NotificationVariation
%type  <err>ObjectVariation
%type  <err>CreationPart
%type  <err>Cells
%type  <err>Cell
%type  <id>number

%%

/*
 * Yacc rules.
 *
 * Conventions:
 *
 * All uppercase symbols are terminals as given by the lexer.
 * 
 * Symbols with mixed characters and the first letter uppercase
 * are taken from the specifications in RFCs (and probably the
 * Simple Book). In some cases conflicts were resolved by appending
 * a `_' character and a context specification like in
 * ModuleName_Compliance.
 * 
 * Symbols starting with a lowercase letter are defined by the author
 * based on prosa definitions in documents or for other obvious use.
 *
 */


/*
 * One mibFile may contain multiple MIB modules.
 * It's also possible that there's no module in a file.
 */
mibFile:		modules
    			{ $$ = 0; }
	|		/* empty */
    			{ $$ = 0; }
	;

modules:		module
			{ $$ = 0; }
	|		modules module
			{ $$ = 0; }
	;

/*
 * The general structure of a module is described at REF:RFC1902,3. .
 * An example is given at REF:RFC1902,5.7. .
 */
module:			moduleName
			{
			    /*
			     * This module is to be parsed, either if we
			     * want the whole file or if its name matches
			     * the module name we are looking for.
			     * In fact, we always parse it, but we just
			     * remember its contents if needed.
			     */
			    thisParserPtr->modulePtr = findModuleByName($1);
			    if (!thisParserPtr->modulePtr) {
				thisParserPtr->modulePtr =
				    addModule($1,
					      thisParserPtr->path,
					      thisParserPtr->locationPtr,
					      thisParserPtr->character,
					      0,
					      thisParserPtr);
			    }
			    thisParserPtr->modulePtr->flags &= ~FLAG_SMIV2;
			    thisParserPtr->modulePtr->numImportedIdentifiers
				                                           = 0;
			    thisParserPtr->modulePtr->numStatements = 0;
			    thisParserPtr->modulePtr->numModuleIdentities = 0;
			    if (!strcmp($1, "SNMPv2-SMI")) {
			        /*
				 * SNMPv2-SMI is an SMIv2 module that cannot
				 * be identified by importing from SNMPv2-SMI.
				 */
			        thisParserPtr->modulePtr->flags |= FLAG_SMIV2;
			    }

			}
			DEFINITIONS COLON_COLON_EQUAL BEGIN_
			exportsClause
			linkagePart
			declarationPart
			END
			{
			    /* TODO
			    PendingNode *p;
			    
			    if ((thisParserPtr->modulePtr->flags & FLAG_SMIV2) &&
				(thisParserPtr->modulePtr->numModuleIdentities < 1)) {
			        printError(parser, ERR_NO_MODULE_IDENTITY);
			    }
			    for (p = firstPendingNode; p; p = p->next) {
				printError(parser, ERR_UNKNOWN_OIDLABEL,
					   p->descriptor->name);
			    }
			    */
			    $$ = 0;
			}
	;

/*
 * REF:RFC1902,3.2.
 */
linkagePart:		linkageClause
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

linkageClause:		IMPORTS importPart ';'
			{ $$ = 0; }
        ;

exportsClause:		/* empty */
			{ $$ = 0; }
	|		EXPORTS
			{
			    if (strcmp(thisParserPtr->modulePtr->name,
				       "RFC1155-SMI")) {
			        printError(thisParserPtr, ERR_EXPORTS);
			    }
			}
			/* the scanner skips until... */
			';'
			{ $$ = 0; }
	;

importPart:		imports
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
			/* TODO: ``IMPORTS ;'' allowed? refer ASN.1! */
	;

imports:		import
			{ $$ = 0; }
	|		imports import
			{ $$ = 0; }
	;

import:			importIdentifiers FROM moduleName
			/* TODO: multiple clauses with same moduleName
			 * allowed? I guess so. refer ASN.1! */
			{
			    if (!strcmp($3, "SNMPv2-SMI")) {
			        /*
				 * A module that imports from SNMPv2-SMI
				 * seems to be SMIv2 style.
				 */
			        thisParserPtr->modulePtr->flags |= FLAG_SMIV2;
			    }

			    /*
			     * Recursively call the parser to suffer
			     * the IMPORTS, if the module is not yet
			     * loaded.
			     */
			    if (!findModuleByName($3)) {
				smiLoadModule($3);
			    }
			    checkImports($3, thisParserPtr);
			}
	;

importIdentifiers:	importIdentifier
			{ $$ = 0; }
	|		importIdentifiers ',' importIdentifier
			/* TODO: might this list list be empty? */
			{ $$ = 0; }
	;

/*
 * Note that some named types must not be imported, REF:RFC1902,590 .
 */
importIdentifier:	LOWERCASE_IDENTIFIER
			{
			    addImport($1, thisParserPtr);
			    thisParserPtr->modulePtr->numImportedIdentifiers++;
			    $$ = util_strdup($1);
			}
	|		UPPERCASE_IDENTIFIER
			{
			    addImport($1, thisParserPtr);
			    thisParserPtr->modulePtr->numImportedIdentifiers++;
			    $$ = util_strdup($1);
			}
	|		importedKeyword
			/* TODO: what exactly is allowed here?
			 * What should be checked? */
			{
			    addImport($1, thisParserPtr);
			    thisParserPtr->modulePtr->numImportedIdentifiers++;
			    $$ = util_strdup($1);
			}
	;

/*
 * These keywords are no real keywords. They have to be imported
 * from the SMI, TC, CONF MIBs.
 */
/*
 * TODO: Think! Shall we really leave these words as keywords or should
 * we prefer the symbol table appropriately??
 */
importedKeyword:	ACCESS
        |		AGENT_CAPABILITIES
	|		AUGMENTS
	|		BITS
	|		CONTACT_INFO
	|		CREATION_REQUIRES
	|		COUNTER32
	|		COUNTER64
	|		DEFVAL
	|		DESCRIPTION
	|		DISPLAY_HINT
	|		GROUP
	|		GAUGE32
	|		IMPLIED
	|		INDEX
	|		INTEGER32
	|		IPADDRESS
	|		LAST_UPDATED
	|		MANDATORY_GROUPS
	|		MAX_ACCESS
	|		MIN_ACCESS
	|		MODULE
	|		MODULE_COMPLIANCE
	|		MODULE_IDENTITY
	|		NOTIFICATIONS
	|		NOTIFICATION_GROUP
	|		NOTIFICATION_TYPE
	|		OBJECT_GROUP
	|		OBJECT_IDENTITY
	|		OBJECT_TYPE
	|		OBJECTS
	|		ORGANIZATION
	|		OPAQUE
	|		PRODUCT_RELEASE
	|		REFERENCE
	|		REVISION
	|		STATUS
	|		SUPPORTS
	|		SYNTAX
	|		TEXTUAL_CONVENTION
	|		TIMETICKS
	|		TRAP_TYPE
	|		UNITS
	|		UNSIGNED32
	|		VARIATION
	|		WRITE_SYNTAX
			/* TODO: which keywords should really be
			 * allowed in import clauses? */
	;

moduleName:		UPPERCASE_IDENTIFIER
			{
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_MODULENAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_MODULENAME_32, $1);
			    }
			    $$ = util_strdup($1);
			}
	;

/*
 * The paragraph at REF:RFC1902,490 lists roughly what's allowed
 * in the body of an information module.
 */
declarationPart:	declarations
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
			/* TODO: might this list really be emtpy? */
	;

declarations:		declaration
			{ $$ = 0; }
	|		declarations declaration
			{ $$ = 0; }
	;

declaration:		typeDeclaration
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		valueDeclaration
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		objectIdentityClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		objectTypeClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		trapTypeClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		notificationTypeClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		moduleIdentityClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
			/* TODO: check it's first and once */
	|		moduleComplianceClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		objectGroupClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		notificationGroupClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		macroClause
			{ 
			    thisParserPtr->modulePtr->numStatements++;
			    $$ = 0;
			}
	|		error '}'
			{
			    printError(thisParserPtr, ERR_FLUSH_DECLARATION);
			    yyerrok;
			    $$ = 1;
			}
	;

/*
 * Macro clauses. Its contents are not really parsed, but skipped by
 * the scanner until 'END' is read. This is just to make the SMI
 * documents readable.
 */
macroClause:		macroName
			MACRO
			{
			    /*
			     * ASN.1 macros are known to be in these
			     * modules.
			     */
			    if (strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-SMI") &&
			        strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-TC") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-CONF") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "RFC-1212") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "RFC1155-SMI")) {
			        printError(thisParserPtr, ERR_MACRO);
			    }
			}
			/* the scanner skips until... */
			END
			{
			    /*
			     * Some bison magics make the objectIdentifier
			     * to be $7 instead of $6.
			     */
			    addMacro($1, thisParserPtr->character, 0,
				     thisParserPtr);
			    $$ = 0;
                        }
	;

macroName:		MODULE_IDENTITY     { $$ = util_strdup($1); } 
	|		OBJECT_TYPE	    { $$ = util_strdup($1); }
	|		NOTIFICATION_TYPE   { $$ = util_strdup($1); }
	|		OBJECT_IDENTITY	    { $$ = util_strdup($1); }
	|		TEXTUAL_CONVENTION  { $$ = util_strdup($1); }
	|		OBJECT_GROUP	    { $$ = util_strdup($1); }
	|		NOTIFICATION_GROUP  { $$ = util_strdup($1); }
	|		MODULE_COMPLIANCE   { $$ = util_strdup($1); }
	|		AGENT_CAPABILITIES  { $$ = util_strdup($1); }
	;

choiceClause:		CHOICE
			{
			    if (strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-SMI") &&
			        strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-TC") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-CONF") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "RFC-1212") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "RFC1155-SMI")) {
			        printError(thisParserPtr, ERR_CHOICE);
			    }
			}
			/* the scanner skips until... */
			'}'
			{
			    $$ = addType(NULL, SMI_SYNTAX_CHOICE, 0,
					 thisParserPtr);
			}
	;

/*
 * The only ASN.1 value declarations are for OIDs, REF:RFC1902,491 .
 */
valueDeclaration:	LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			    if (thisParserPtr->modulePtr->flags & FLAG_SMIV2) {
			        if (strchr($1, '-')) {
				    printError(thisParserPtr,
					       ERR_OIDNAME_INCLUDES_HYPHEN,
					       $1);
				}
			    }
			}
			OBJECT IDENTIFIER
			COLON_COLON_EQUAL '{' objectIdentifier '}'
			{
			    Object *objectPtr;
			    
			    objectPtr = $7;
			    if (objectPtr->modulePtr != thisParserPtr->modulePtr) {
				objectPtr =
				    duplicateObject(objectPtr,
						    0, thisParserPtr);
			    }
			    objectPtr = setObjectName(objectPtr, $1);
			    setObjectDecl(objectPtr,
					  SMI_DECL_VALUEASSIGNMENT);
			    $$ = 0;
			}
	;

/*
 * This is for simple ASN.1 style type assignments and textual conventions.
 */
typeDeclaration:	typeName
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_TYPENAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_TYPENAME_32, $1);
			    }
			}
			COLON_COLON_EQUAL typeDeclarationRHS
			{
			    Type *typePtr;
			    
			    if (strlen($1)) {
				typePtr = $4;
				setTypeName(typePtr, $1);
				$$ = 0;
			    } else {
				$$ = 0;
			    }
			}
	;

typeName:		UPPERCASE_IDENTIFIER
			{
			    $$ = util_strdup($1);
			}
	|		typeSMI
			{
			    /*
			     * well known types (keywords in this grammar)
			     * are known to be defined in these modules.
			     */
			    if (strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-SMI") &&
			        strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-TC") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-CONF") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "RFC-1212") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "RFC1155-SMI")) {
			        printError(thisParserPtr, ERR_TYPE_SMI, $1);
			    }
			    /*
			     * clear $$, so that the `typeDeclarationRHS'
			     * rule will not add a new Descriptor for this
			     * already known type.
			     */
			}
	;

typeSMI:		INTEGER32   { $$ = util_strdup($1); }
	|		IPADDRESS   { $$ = util_strdup($1); }
	|		COUNTER32   { $$ = util_strdup($1); }
	|		GAUGE32     { $$ = util_strdup($1); }
	|		UNSIGNED32  { $$ = util_strdup($1); }
	|		TIMETICKS   { $$ = util_strdup($1); }
	|		OPAQUE      { $$ = util_strdup($1); }
	|		COUNTER64   { $$ = util_strdup($1); }
	;

typeDeclarationRHS:	Syntax
			{
			    if ($1->name) {
				/*
				 * If we found an already defined type,
				 * we have to inherit a new type structure.
				 * (Otherwise the `Syntax' rule created
				 * a new type for us.)
				 */
				$$ = duplicateType($1, 0, thisParserPtr);
			    } else {
				$$ = $1;
			    }
			}
	|		TEXTUAL_CONVENTION
			DisplayPart
			STATUS Status
			DESCRIPTION Text
			ReferPart
			SYNTAX Syntax
			{
			    if (($9) && !($9->name)) {
				/*
				 * If the Type we found has just been
				 * defined, we don't have to allocate
				 * a new one.
				 */
				$$ = $9;
			    } else {
				/*
				 * Otherwise, we have to allocate a
				 * new Type struct, inherited from $9.
				 */
				$$ = duplicateType($9, 0, thisParserPtr);
			    }
			    setTypeDescription($$, $6);
			    setTypeStatus($$, $4);
			    if ($2) {
				setTypeFormat($$, $2);
			    }
			    setTypeDecl($$, SMI_DECL_TEXTUALCONVENTION);
			}
	|		choiceClause
			{
			    $$ = $1;
			}
	;

/* REF:RFC1902,7.1.12. */
conceptualTable:	SEQUENCE OF row
			{
			    char s[SMI_MAX_FULLNAME];
			    
			    if ($3) {
				$$ = addType(NULL,
					     SMI_SYNTAX_SEQUENCEOF, 0,
					     thisParserPtr);
				sprintf(s, "%s!%s", $3->modulePtr->name,
					$3->name);
				setTypeParent($$, s);
			    } else {
				$$ = NULL;
			    }
			}
	;

row:			UPPERCASE_IDENTIFIER
			/*
			 * In this case, we do NOT allow `Module.Type'.
			 * The identifier must be defined in the local
			 * module.
			 */
			{
			    Type *typePtr;
			    Import *importPtr;
			    smi_type *stypePtr;

			    $$ = findTypeByModulenameAndName(
				thisParserPtr->modulePtr->name, $1);
			    if (! $$) {
				importPtr = findImportByName($1,
							     thisModulePtr);
				if (!importPtr) {
				    /* 
				     * forward referenced type. create it,
				     * marked with FLAG_INCOMPLETE.
				     */
				    typePtr = addType($1, SMI_SYNTAX_SEQUENCE,
						   FLAG_INCOMPLETE,
						   thisParserPtr);
				    $$ = typePtr;
				} else {
				    /*
				     * imported type.
				     * TODO: is this allowed in a SEQUENCE? 
				     */
				    stypePtr = smiGetType($1,
							  importPtr->module);
				    if (stypePtr) {
					$$ = addType($1, stypePtr->syntax,
						     FLAG_IMPORTED,
						     thisParserPtr);
				    } else {
					$$ = addType($1, SMI_SYNTAX_UNKNOWN,
					       FLAG_INCOMPLETE | FLAG_IMPORTED,
						     thisParserPtr);
				    }
				}
			    }
			}
		        /* TODO: this must be an entryType */
	;

/* REF:RFC1902,7.1.12. */
entryType:		SEQUENCE '{' sequenceItems '}'
			{
			    $$ = addType(NULL, SMI_SYNTAX_SEQUENCE, 0,
					 thisParserPtr);
			    setTypeSequencePtr($$, $3);
			}
;

sequenceItems:		sequenceItem
			{
			    $$ = util_malloc(sizeof(List));
			    /* TODO: success? */
			    $$->ptr = $1;
			    $$->nextPtr = NULL;
			}
	|		sequenceItems ',' sequenceItem
			/* TODO: might this list be emtpy? */
			{
			    List *p, *pp;
			    
			    p = util_malloc(sizeof(List));
			    p->ptr = (void *)$3;
			    p->nextPtr = NULL;
			    for (pp = $1; pp->nextPtr; pp = pp->nextPtr);
			    pp->nextPtr = p;
			    $$ = $1;
			}
	;

/*
 * In a SEQUENCE { ... } there are no sub-types, enumerations or
 * named bits. REF: draft, p.29
 * NOTE: REF:RFC1902,7.1.12. was less clear, it said:
 * `normally omitting the sub-typing information'
 */
sequenceItem:		LOWERCASE_IDENTIFIER sequenceSyntax
			{
			    Object *objectPtr;
			    smi_node *snodePtr;
			    Import *importPtr;
			    
			    objectPtr =
			        findObjectByModuleAndName(thisParserPtr->modulePtr,
							  $1);

			    if (objectPtr) {
				$$ = objectPtr;
			    } else {
				importPtr = findImportByName($1,
							     thisModulePtr);
				if (!importPtr) {
				    objectPtr = addObject($1, pendingNodePtr,
					                  0,
					                  FLAG_INCOMPLETE,
						          thisParserPtr);
				    setObjectFileOffset(objectPtr,
						        thisParserPtr->character);
				    $$ = objectPtr;
				} else {
				    /*
				     * imported object.
				     */
				    snodePtr = smiGetNode($1,
							  importPtr->name);
				    $$ = addObject($1,
					getParentNode(
					    createNodes(snodePtr->oid)),
					getLastSubid(snodePtr->oid),
					FLAG_IMPORTED, thisParserPtr);
				}
			    }
			}
	;

Syntax:			ObjectSyntax
			{
			    $$ = $1;
			}
	|		BITS '{' NamedBits '}'
			/* TODO: standalone `BITS' ok? seen in RMON2-MIB */
			/* -> no, it's only allowed in a SEQUENCE {...} */
			{
			    /* TODO: ?? */
			    $$ = $3;
			}
	;

sequenceSyntax:		/* ObjectSyntax */
			sequenceObjectSyntax
			{
			    $$ = $1;
			}
	|		BITS
			{
			    /* TODO: $$ = $1; */
			    $$ = NULL;
			    $$ = typeOctetStringPtr;
			}
	|		UPPERCASE_IDENTIFIER anySubType
			{
			    Type *typePtr;
			    Import *importPtr;
			    
			    $$ = findTypeByModulenameAndName(
				thisParserPtr->modulePtr->name, $1);
			    if (! $$) {
				importPtr = findImportByName($1,
							     thisModulePtr);
				if (!importPtr) {
				    /* 
				     * forward referenced type. create it,
				     * marked with FLAG_INCOMPLETE.
				     */
				    typePtr = addType($1, SMI_SYNTAX_UNKNOWN,
						      FLAG_INCOMPLETE,
						      thisParserPtr);
				    $$ = typePtr;
				} else {
				    /*
				     * imported type.
				     *
				     * We are in a SEQUENCE clause,
				     * where we do not have to create
				     * a new Type struct.
				     */
				}
			    }
			}
	;

NamedBits:		NamedBit
			{
			    $$ = $1;
			}
	|		NamedBits ',' NamedBit
			{
			    /* TODO: append $3 to $1 */
			    $$ = $1;
			}
	;

NamedBit:		identifier
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_BITNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_BITNAME_32, $1);
			    }
			}
			'(' number ')'
			{
			    /* TODO */
			    $$ = NULL;
			    $$ = typeOctetStringPtr;
			}
	;

identifier:		LOWERCASE_IDENTIFIER
			/* TODO */
			{
			    $$ = util_strdup($1);
			}
	;

objectIdentityClause:	LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			OBJECT_IDENTITY
			STATUS Status
			DESCRIPTION Text
			ReferPart
			COLON_COLON_EQUAL
			'{' objectIdentifier '}'
			{
			    Object *objectPtr;
			    
			    objectPtr = $11;
			    
			    if (objectPtr->modulePtr !=
				thisParserPtr->modulePtr) {
				objectPtr = duplicateObject(objectPtr,
				                            0, thisParserPtr);
			    }
			    objectPtr = setObjectName(objectPtr, $1);
			    setObjectDecl(objectPtr, SMI_DECL_OBJECTIDENTITY);
			    setObjectStatus(objectPtr, $5);
			    setObjectDescription(objectPtr, $7);
			    addObjectFlags(objectPtr, FLAG_REGISTERED);
#if 0
			    setObjectReferences(objectPtr, $8);
#endif
			    $$ = 0;
			}
	;

objectTypeClause:	LOWERCASE_IDENTIFIER
			{
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			OBJECT_TYPE
			SYNTAX Syntax
		        UnitsPart
			MaxAccessPart
			STATUS Status
			descriptionClause
			ReferPart
			IndexPart
			DefValPart
			COLON_COLON_EQUAL '{' ObjectName '}'
			{
			    Object *objectPtr;

			    objectPtr = $16;
			    
			    if (objectPtr->modulePtr != thisParserPtr->modulePtr) {
				objectPtr = duplicateObject(objectPtr,
				                            0, thisParserPtr);
			    }
			    objectPtr = setObjectName(objectPtr, $1);
			    setObjectDecl(objectPtr, SMI_DECL_OBJECTTYPE);
			    setObjectType(objectPtr, $5);
			    setObjectAccess(objectPtr, $7);
			    setObjectStatus(objectPtr, $9);
			    addObjectFlags(objectPtr, FLAG_REGISTERED);
			    if ($10) {
				setObjectDescription(objectPtr, $10);
			    }
			    setObjectIndex(objectPtr, $12);
			    /*
			     * TODO: ReferPart ($11)
			     * TODO: DefValPart ($13)
			     */
			    $$ = 0;
			}
	;

descriptionClause:	/* empty */
			{
			    if (thisParserPtr->modulePtr->flags &
			            FLAG_SMIV2) {
				printError(thisParserPtr,
					   ERR_MISSING_DESCRIPTION);
			    }
			    $$ = NULL;
			}
	|		DESCRIPTION Text
			{
			    $$ = $2;
			}
	;

trapTypeClause:		LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			TRAP_TYPE
			{
			    if (thisParserPtr->modulePtr->flags &
			            FLAG_SMIV2) {
			        printError(thisParserPtr, ERR_TRAP_TYPE);
			    }
			}
			ENTERPRISE objectIdentifier
			VarPart
			DescrPart
			ReferPart
			COLON_COLON_EQUAL number
			/* TODO: range of number? */
			{ $$ = 0; }
	;

VarPart:		VARIABLES '{' VarTypes '}'
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

VarTypes:		VarType
			{ $$ = 0; }
	|		VarTypes ',' VarType
			{ $$ = 0; }
	;

VarType:		ObjectName
			{ $$ = 0; }
	;

DescrPart:		DESCRIPTION Text
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

MaxAccessPart:		MAX_ACCESS
			{
			    if (!(thisParserPtr->modulePtr->flags &
			              FLAG_SMIV2)) {
			        printError(thisParserPtr, ERR_MAX_ACCESS_IN_SMIV1);
			    }
			}
			Access
			{ $$ = $3; }
	|		ACCESS
			{
			    if (thisParserPtr->modulePtr->flags &
			            FLAG_SMIV2) {
			        printError(thisParserPtr, ERR_ACCESS_IN_SMIV2);
			    }
			}
			Access
			/* TODO: limited values in v1 */
			{ $$ = $3; }
	;

notificationTypeClause:	LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			NOTIFICATION_TYPE
			ObjectsPart
			STATUS Status
			DESCRIPTION Text
			ReferPart
			COLON_COLON_EQUAL
			'{' NotificationName '}'
			{
			    Object *objectPtr;
			    
			    objectPtr = $12;
				
			    if (objectPtr->modulePtr != thisParserPtr->modulePtr) {
				objectPtr = duplicateObject(objectPtr, 0,
							    thisParserPtr);
			    }
			    objectPtr = setObjectName(objectPtr, $1);
			    setObjectDecl(objectPtr,
					  SMI_DECL_NOTIFICATIONTYPE);
			    addObjectFlags(objectPtr, FLAG_REGISTERED);
			    setObjectStatus(objectPtr, $6);
			    setObjectDescription(objectPtr, $8);
			    $$ = 0;
			}
	;

moduleIdentityClause:	LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			MODULE_IDENTITY
			{
			    if (thisParserPtr->modulePtr->numModuleIdentities > 0)
			    {
			        printError(thisParserPtr,
					   ERR_TOO_MANY_MODULE_IDENTITIES);
			    }
			    if (thisParserPtr->modulePtr->numStatements > 0) {
			        printError(thisParserPtr,
					   ERR_MODULE_IDENTITY_NOT_FIRST);
			    }
			}
			LAST_UPDATED ExtUTCTime
			{
			    setModuleLastUpdated(thisParserPtr->modulePtr,
						 smiMkTime($6));
			}
			ORGANIZATION Text
			CONTACT_INFO Text
			DESCRIPTION Text
			RevisionPart
			COLON_COLON_EQUAL
			'{' objectIdentifier '}'
			{
			    Object *objectPtr;
			    
			    objectPtr = $17;
			    
			    thisParserPtr->modulePtr->numModuleIdentities++;
			    if (objectPtr->modulePtr !=
				thisParserPtr->modulePtr) {
				objectPtr = duplicateObject(objectPtr, 0,
							    thisParserPtr);
			    }
			    objectPtr = setObjectName(objectPtr, $1);
			    setObjectDecl(objectPtr, SMI_DECL_MODULEIDENTITY);
			    addObjectFlags(objectPtr, FLAG_REGISTERED);
			    setModuleIdentityObject(thisParserPtr->modulePtr,
						    objectPtr);
			    setModuleOrganization(thisParserPtr->modulePtr,
						  $9);
			    setModuleContactInfo(thisParserPtr->modulePtr,
						 $11);
			    setObjectDescription(objectPtr, $13);
			    $$ = 0;
			}
        ;

ObjectSyntax:		SimpleSyntax
			{
			    $$ = $1;
			}
	|		typeTag SimpleSyntax
			{
			    if (strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-SMI") &&
			        strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-TC") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "SNMPv2-CONF") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "RFC-1212") &&
				strcmp(thisParserPtr->modulePtr->name,
				       "RFC1155-SMI")) {
			        printError(thisParserPtr, ERR_TYPE_TAG, $1);
			    }
			    $$ = $2;
			}
	|		conceptualTable	     /* TODO: possible? row? entry? */
			{
			    /* TODO */
			    $$ = $1;
			}
	|		row		     /* the uppercase name of a row  */
			{
			    /* TODO */
			    $$ = $1;
			}
	|		entryType	     /* SEQUENCE { ... } phrase */
			{
			    /* TODO */
			    $$ = $1;
			}
	|		ApplicationSyntax
			{
			    /* TODO */
			    $$ = $1;
			}
        ;

typeTag:		'[' APPLICATION number ']' IMPLICIT
			{ $$ = 0; }
	|		'[' UNIVERSAL number ']' IMPLICIT
			{ $$ = 0; }
	;

/*
 * In a SEQUENCE { ... } there are no sub-types, enumerations or
 * named bits. REF: draft, p.29
 */
sequenceObjectSyntax:	sequenceSimpleSyntax
			{ $$ = $1; }
/*	|		conceptualTable	     /* TODO: possible? row? entry? */
/*	|		row		     /* the uppercase name of a row  */
/*	|		entryType	     /* it's SEQUENCE { ... } phrase */
	|		sequenceApplicationSyntax
			{ $$ = $1; }
        ;

/* TODO: specify really according to ObjectSyntax!!! */
valueofObjectSyntax:	valueofSimpleSyntax
			{ $$ = 0; }
			/* conceptualTables and rows do not have DEFVALs
			 */
			/* valueofApplicationSyntax would not introduce any
			 * further syntax of ObjectSyntax values.
			 */
	;

SimpleSyntax:		INTEGER			/* (-2147483648..2147483647) */
			{
			    $$ = typeIntegerPtr;
			}
	|		INTEGER integerSubType
			{
			    $$ = duplicateType(typeIntegerPtr, 0, thisParserPtr);
			    setTypeParent($$, typeIntegerPtr->name);
				/* TODO: add subtype restriction */
			}
	|		INTEGER enumSpec
			{
			    $$ = duplicateType(typeIntegerPtr, 0, thisParserPtr);
			    setTypeParent($$, typeIntegerPtr->name);
				/* TODO: add enum restriction */
			}
	|		INTEGER32		/* (-2147483648..2147483647) */
			{
			    /* TODO: any need to distinguish from INTEGER? */
			    $$ = typeIntegerPtr;
			}
        |		INTEGER32 integerSubType
			{
			    $$ = duplicateType(typeIntegerPtr, 0, thisParserPtr);
			    setTypeParent($$, typeIntegerPtr->name);
				/* TODO: add subtype restriction */
			}
	|		UPPERCASE_IDENTIFIER enumSpec
			{
			    Type *parentPtr;
			    smi_type *stypePtr;
			    char s[SMI_MAX_FULLNAME];
			    Import *importPtr;
			    
			    parentPtr = findTypeByModuleAndName(
			        thisParserPtr->modulePtr, $1);
			    if (!parentPtr) {
			        importPtr = findImportByName($1,
							     thisModulePtr);
				if (!importPtr) {
				    /* 
				     * forward referenced type. create it,
				     * marked with FLAG_INCOMPLETE.
				     */
				    parentPtr = addType($1, SMI_SYNTAX_UNKNOWN,
						        FLAG_INCOMPLETE,
						        thisParserPtr);
				    $$ = duplicateType(parentPtr, 0,
						       thisParserPtr);
				    sprintf(s, "%s.%s",
					    thisParserPtr->modulePtr->name,
					    parentPtr->name);
				    setTypeParent($$, s);
				} else {
				    /*
				     * imported type.
				     */
				    stypePtr = smiGetType($1,
							  importPtr->module);
				    $$ = addType(NULL, stypePtr->syntax, 0,
						 thisParserPtr);
				    sprintf(s, "%s.%s", importPtr->module,
					    importPtr->name);
				    setTypeParent($$, s);
				}
			    } else {
			        $$ = duplicateType(parentPtr, 0, thisParserPtr);
				sprintf(s, "%s.%s",
				        thisParserPtr->modulePtr->name, $1);
				setTypeParent($$, s);
			    }
				/* TODO: add enum restriction */
			}
	|		moduleName '.' UPPERCASE_IDENTIFIER enumSpec
			/* TODO: UPPERCASE_IDENTIFIER must be an INTEGER */
			{
			    Type *parentPtr;
			    smi_type *stypePtr;
			    char s[SMI_MAX_FULLNAME];
			    Import *importPtr;
			    
			    parentPtr = findTypeByModulenameAndName($1, $3);
			    if (!parentPtr) {
				importPtr = findImportByModulenameAndName($1,
							  $3, thisModulePtr);
				if (!importPtr) {
				    printError(thisParserPtr,
					       ERR_UNKNOWN_TYPE, $3);
				    $$ = NULL;
				} else {
				    /*
				     * imported type.
				     */
				    stypePtr = smiGetType($3, $1);
				    /* TODO: success? */
				    $$ = addType(NULL, stypePtr->syntax, 0,
						 thisParserPtr);
				    sprintf(s, "%s.%s", importPtr->module,
					    importPtr->name);
				    setTypeParent($$, s);
				}
			    } else {
			        $$ = duplicateType(parentPtr, 0, thisParserPtr);
				sprintf(s, "%s.%s", $1, $3);
				setTypeParent($$, s);
			    }
				/* TODO: add enum restriction */
			}
	|		UPPERCASE_IDENTIFIER integerSubType
			{
			    Type *parentPtr;
			    smi_type *stypePtr;
			    char s[SMI_MAX_FULLNAME];
			    Import *importPtr;
			    
			    parentPtr = findTypeByModuleAndName(
				thisParserPtr->modulePtr, $1);
			    if (!parentPtr) {
				importPtr = findImportByName($1,
							     thisModulePtr);
				if (!importPtr) {
				    /* 
				     * forward referenced type. create it,
				     * marked with FLAG_INCOMPLETE.
				     */
				    parentPtr = addType($1,
							SMI_SYNTAX_UNKNOWN,
							FLAG_INCOMPLETE,
							thisParserPtr);
				    $$ = duplicateType(parentPtr, 0,
						       thisParserPtr);
				    sprintf(s, "%s.%s",
					    thisParserPtr->modulePtr->name,
					    parentPtr->name);
				    setTypeParent($$, s);
				} else {
				    /*
				     * imported type.
				     */
				    stypePtr = smiGetType($1,
							  importPtr->module);
				    $$ = addType(NULL, stypePtr->syntax, 0,
						 thisParserPtr);
				    sprintf(s, "%s.%s", importPtr->module,
					    importPtr->name);
				    setTypeParent($$, s);
				}
			    } else {
				$$ = duplicateType(parentPtr, 0,
						   thisParserPtr);
				sprintf(s, "%s.%s",
				        thisParserPtr->modulePtr->name, $1);
				setTypeParent($$, s);
			    }
				/* TODO: add subtype restriction */
			}
	|		moduleName '.' UPPERCASE_IDENTIFIER integerSubType
			/* TODO: UPPERCASE_IDENTIFIER must be an INT/Int32. */
			{
			    Type *parentPtr;
			    smi_type *stypePtr;
			    char s[SMI_MAX_FULLNAME];
			    Import *importPtr;
			    
			    parentPtr = findTypeByModulenameAndName($1, $3);
			    if (!parentPtr) {
				importPtr = findImportByModulenameAndName($1,
							  $3, thisModulePtr);
				if (!importPtr) {
				    printError(thisParserPtr,
					       ERR_UNKNOWN_TYPE, $3);
				    $$ = NULL;
				} else {
				    /*
				     * imported type.
				     */
				    stypePtr = smiGetType($3, $1);
				    /* TODO: success? */
				    $$ = addType(NULL, stypePtr->syntax, 0,
						 thisParserPtr);
				    sprintf(s, "%s.%s", importPtr->module,
					    importPtr->name);
				    setTypeParent($$, s);
				}
			    } else {
				$$ = duplicateType(parentPtr, 0,
						   thisParserPtr);
				sprintf(s, "%s.%s", $1, $3);
				setTypeParent($$, s);
			    }
				/* TODO: add subtype restriction */
			}
	|		OCTET STRING		/* (SIZE (0..65535))	     */
			{
			    $$ = typeOctetStringPtr;
			}
	|		OCTET STRING octetStringSubType
			{
			    $$ = duplicateType(typeOctetStringPtr, 0,
					       thisParserPtr);
			    setTypeParent($$, typeOctetStringPtr->name);
				/* TODO: add subtype restriction */
			}
	|		UPPERCASE_IDENTIFIER octetStringSubType
			{
			    Type *parentPtr;
			    smi_type *stypePtr;
			    char s[SMI_MAX_FULLNAME];
			    Import *importPtr;
			    
			    parentPtr = findTypeByModuleAndName(
				thisParserPtr->modulePtr, $1);
			    if (!parentPtr) {
				importPtr = findImportByName($1,
							     thisModulePtr);
				if (!importPtr) {
				    /* 
				     * forward referenced type. create it,
				     * marked with FLAG_INCOMPLETE.
				     */
				    parentPtr = addType($1,
						     SMI_SYNTAX_UNKNOWN,
						     FLAG_INCOMPLETE,
						     thisParserPtr);
				    $$ = duplicateType(parentPtr, 0,
						       thisParserPtr);
				    sprintf(s, "%s.%s",
					    thisParserPtr->modulePtr->name,
					    parentPtr->name);
				    setTypeParent($$, s);
				} else {
				    /*
				     * imported type.
				     */
				    stypePtr = smiGetType($1,
							  importPtr->module);
				    $$ = addType(NULL, stypePtr->syntax, 0,
						 thisParserPtr);
				    sprintf(s, "%s.%s", importPtr->module,
					    importPtr->name);
				    setTypeParent($$, s);
				}
			    } else {
				$$ = duplicateType(parentPtr, 0,
						   thisParserPtr);
				sprintf(s, "%s.%s",
				        thisParserPtr->modulePtr->name, $1);
				setTypeParent($$, s);
			    }
				/* TODO: add subtype restriction */
			}
	|		moduleName '.' UPPERCASE_IDENTIFIER octetStringSubType
			/* TODO: UPPERCASE_IDENTIFIER must be an OCTET STR. */
			{
			    Type *parentPtr;
			    smi_type *stypePtr;
			    char s[SMI_MAX_FULLNAME];
			    Import *importPtr;
			    
			    parentPtr = findTypeByModulenameAndName($1, $3);
			    if (!parentPtr) {
				importPtr = findImportByModulenameAndName($1,
							  $3, thisModulePtr);
				if (!importPtr) {
				    printError(thisParserPtr,
					       ERR_UNKNOWN_TYPE, $3);
				    $$ = NULL;
				} else {
				    /*
				     * imported type.
				     */
				    stypePtr = smiGetType($3, $1);
				    /* TODO: success? */
				    $$ = addType(NULL, stypePtr->syntax, 0,
						 thisParserPtr);
				    sprintf(s, "%s.%s", importPtr->module,
					    importPtr->name);
				    setTypeParent($$, s);
				}
			    } else {
			        $$ = duplicateType(parentPtr, 0, thisParserPtr);
				sprintf(s, "%s.%s", $1, $3);
				setTypeParent($$, s);
			    }
				/* TODO: add enum restriction */
			}
	|		OBJECT IDENTIFIER
			{
			    $$ = typeObjectIdentifierPtr;
			}
        ;

valueofSimpleSyntax:	number			/* 0..2147483647 */
			/* NOTE: Counter64 must not have a DEFVAL */
			{ $$ = 0; }
	|		'-' number		/* -2147483648..0 */
			{ $$ = 0; }
	|		BIN_STRING		/* number or OCTET STRING */
			{ $$ = 0; }
	|		HEX_STRING		/* number or OCTET STRING */
			{ $$ = 0; }
	|		LOWERCASE_IDENTIFIER	/* enumeration label */
			{ $$ = 0; }
	|		QUOTED_STRING		/* an OCTET STRING */
			{ $$ = 0; }
			/* NOTE: If the value is an OBJECT IDENTIFIER, then
			 *       it must be expressed as a single ASN.1
			 *	 identifier, and not as a collection of
			 *	 of sub-identifiers.
			 *	 REF: draft,p.34
			 *	 Anyway, we try to accept it. But it's only
			 *	 possible for numbered sub-identifiers, since
			 *	 other identifiers would make something like
			 *	 { gaga } indistiguishable from a BitsValue.
			 */
	|		'{' objectIdentifier_defval '}'
			{
			    printError(thisParserPtr, ERR_OID_DEFVAL_TOO_LONG);
			}
			/* TODO: need context knowledge about SYNTAX
			 *       to decide what is allowed
			 */
			{ $$ = 0; }
	;

/*
 * In a SEQUENCE { ... } there are no sub-types, enumerations or
 * named bits. REF: draft, p.29
 */
sequenceSimpleSyntax:	INTEGER	anySubType	/* (-2147483648..2147483647) */
			{
			    $$ = typeIntegerPtr;
			}
        |		INTEGER32 anySubType	/* (-2147483648..2147483647) */
			{
			    /* TODO: any need to distinguish from INTEGER? */
			    $$ = typeIntegerPtr;
			}
	|		OCTET STRING anySubType
			{
			    /* TODO: warning: ignoring subtype in SEQUENCE */
			    $$ = typeOctetStringPtr;
			}
	|		OBJECT IDENTIFIER
			{
			    $$ = typeObjectIdentifierPtr;
			}
	;

ApplicationSyntax:	IPADDRESS
			{
			    $$ = findTypeByName("IpAddress");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "IpAddress");
			    }
			}
	|		COUNTER32		/* (0..4294967295)	     */
			{
			    $$ = findTypeByName("Counter32");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Counter32");
			    }
			}
	|		GAUGE32			/* (0..4294967295)	     */
			{
			    $$ = findTypeByName("Gauge32");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Gauge32");
			    }
			}
	|		GAUGE32 integerSubType
			{
			    Type *parentPtr;
			    
			    parentPtr = findTypeByName("Gauge32");
			    if (! parentPtr) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Gauge32");
			    }
			    $$ = duplicateType(parentPtr, 0, thisParserPtr);
			    setTypeParent($$, parentPtr->name);
				/* TODO: add subtype restriction */
			}
	|		UNSIGNED32		/* (0..4294967295)	     */
			{
			    $$ = findTypeByName("Unsigned32");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Unsigned32");
			    }
			}
	|		UNSIGNED32 integerSubType
			{
			    Type *parentPtr;
			    
			    parentPtr = findTypeByName("Unsigned32");
			    if (! parentPtr) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Unsigned32");
			    }
			    $$ = duplicateType(parentPtr, 0, thisParserPtr);
			    setTypeParent($$, parentPtr->name);
				/* TODO: add subtype restriction */
			}
	|		TIMETICKS		/* (0..4294967295)	     */
			{
			    $$ = findTypeByName("TimeTicks");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "TimeTicks");
			    }
			}
	|		OPAQUE			/* IMPLICIT OCTET STRING     */
			{
			    $$ = findTypeByName("Opaque");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Opaque");
			    }
			}
	|		COUNTER64	        /* (0..18446744073709551615) */
			{
			    $$ = findTypeByName("Counter64");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Counter64");
			    }
			}
	;

/*
 * In a SEQUENCE { ... } there are no sub-types, enumerations or
 * named bits. REF: draft, p.29
 */
sequenceApplicationSyntax: IPADDRESS
			{
			    $$ = findTypeByName("IpAddress");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "IpAddress");
			    }
			}
	|		COUNTER32		/* (0..4294967295)	     */
			{
			    $$ = findTypeByName("Counter32");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Counter32");
			    }
			}
	|		GAUGE32	anySubType	/* (0..4294967295)	     */
			{
			    $$ = findTypeByName("Gauge32");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Gauge32");
			    }
			}
	|		UNSIGNED32 anySubType /* (0..4294967295)	     */
			{
			    $$ = findTypeByName("Unsigned32");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Unsigned32");
			    }
			}
	|		TIMETICKS		/* (0..4294967295)	     */
			{
			    $$ = findTypeByName("TimeTicks");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "TimeTicks");
			    }
			}
	|		OPAQUE			/* IMPLICIT OCTET STRING     */
			{
			    $$ = findTypeByName("Opaque");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Opaque");
			    }
			}
	|		COUNTER64	        /* (0..18446744073709551615) */
			{
			    $$ = findTypeByName("Counter64");
			    if (! $$) {
				printError(thisParserPtr, ERR_UNKNOWN_TYPE,
					   "Counter64");
			    }
			}
	;

anySubType:		integerSubType
			/* TODO: warning: ignoring SubType */
	|	        octetStringSubType
			/* TODO: warning: ignoring SubType */
	|		enumSpec
			/* TODO: warning: ignoring SubType */
	|		/* empty */
			{ $$ = 0; }
        ;		      


/* REF: draft,p.46 */
integerSubType:		'(' ranges ')'		/* at least one range        */
			/*
			 * the specification mentions an alternative of an
			 * empty RHS here. this would lead to reduce/reduce
			 * conflicts. instead, we differentiate the parent
			 * rule(s) (SimpleSyntax).
			 */
			{ $$ = 0; }
	;

octetStringSubType:	'(' SIZE '(' ranges ')' ')'
			/*
			 * the specification mentions an alternative of an
			 * empty RHS here. this would lead to reduce/reduce
			 * conflicts. instead, we differentiate the parent
			 * rule(s) (SimpleSyntax).
			 */
			{ $$ = 0; }
	;

ranges:			range
			{ $$ = 0; }
	|		ranges '|' range
			{ $$ = 0; }
	;

range:			value
			{ $$ = 0; }
	|		value DOT_DOT value
			{ $$ = 0; }
	;

value:			'-' number
			{ $$ = 0; }
	|		number
			{ $$ = 0; }
	|		HEX_STRING
			{ $$ = 0; }
	|		BIN_STRING
			{ $$ = 0; }
	;

enumSpec:		'{' enumItems '}'
			{ $$ = 0; }
	;

enumItems:		enumItem
			{ $$ = 0; }
	|		enumItems ',' enumItem
			{ $$ = 0; }
	;

enumItem:		LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_ENUMNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_ENUMNAME_32, $1);
			    }
			}
			'(' enumNumber ')'
			{ $$ = 0; }
	;

enumNumber:		number
			{
			    $$ = 0;
			}
	|		'-' number
			{
			    /* TODO: non-negative is suggested */
			    $$ = 0;
			}
	;

Status:			LOWERCASE_IDENTIFIER
			{
			    if (thisParserPtr->modulePtr->flags & FLAG_SMIV2) {
				if (!strcmp($1, "current")) {
				    $$ = SMI_STATUS_CURRENT;
				} else if (!strcmp($1, "deprecated")) {
				    $$ = SMI_STATUS_DEPRECATED;
				} else if (!strcmp($1, "obsolete")) {
				    $$ = SMI_STATUS_OBSOLETE;
				} else {
				    printError(thisParserPtr,
					       ERR_INVALID_SMIV2_STATUS, $1);
				    $$ = SMI_STATUS_UNKNOWN;
				}
			    } else {
				if (!strcmp($1, "mandatory")) {
				    $$ = SMI_STATUS_MANDATORY;
				} else if (!strcmp($1, "optional")) {
				    $$ = SMI_STATUS_OPTIONAL;
				} else if (!strcmp($1, "obsolete")) {
				    $$ = SMI_STATUS_OBSOLETE;
				} else {
				    printError(thisParserPtr,
					       ERR_INVALID_SMIV1_STATUS, $1);
				    $$ = SMI_STATUS_UNKNOWN;
				}
			    }
			}
        ;		

Status_Capabilities:	LOWERCASE_IDENTIFIER
			{
			    if (!strcmp($1, "current")) {
				$$ = SMI_STATUS_CURRENT;
			    } else if (!strcmp($1, "obsolete")) {
				$$ = SMI_STATUS_OBSOLETE;
			    } else {
				printError(thisParserPtr,
					   ERR_INVALID_CAPABILITIES_STATUS,
					   $1);
				$$ = SMI_STATUS_UNKNOWN;
			    }
			}
        ;

DisplayPart:		DISPLAY_HINT Text
			{
			    $$ = $2;
			}
        |		/* empty */
			{
			    $$ = NULL;
			}
        ;

UnitsPart:		UNITS Text
			{
			    $$ = $2;
			}
        |		/* empty */
			{
			    $$ = NULL;
			}
        ;

Access:			LOWERCASE_IDENTIFIER
			{
			    if (thisParserPtr->modulePtr->flags & FLAG_SMIV2) {
				if (!strcmp($1, "not-accessible")) {
				    $$ = SMI_ACCESS_NOT_ACCESSIBLE;
				} else if (!strcmp($1,
						   "accessible-for-notify")) {
				    $$ = SMI_ACCESS_NOTIFY;
				} else if (!strcmp($1, "read-only")) {
				    $$ = SMI_ACCESS_READ_ONLY;
				} else if (!strcmp($1, "read-write")) {
				    $$ = SMI_ACCESS_READ_WRITE;
				} else if (!strcmp($1, "read-create")) {
				    $$ = SMI_ACCESS_READ_CREATE;
				} else {
				    printError(thisParserPtr,
					       ERR_INVALID_SMIV2_ACCESS,
					       $1);
				    $$ = SMI_ACCESS_UNKNOWN;
				}
			    } else {
				if (!strcmp($1, "not-accessible")) {
				    $$ = SMI_ACCESS_NOT_ACCESSIBLE;
				} else if (!strcmp($1, "read-only")) {
				    $$ = SMI_ACCESS_READ_ONLY;
				} else if (!strcmp($1, "read-write")) {
				    $$ = SMI_ACCESS_READ_WRITE;
				} else if (!strcmp($1, "write-only")) {
				    $$ = SMI_ACCESS_WRITE_ONLY;
				} else {
				    printError(thisParserPtr,
					       ERR_INVALID_SMIV1_ACCESS, $1);
				    $$ = SMI_ACCESS_UNKNOWN;
				}
			    }
			}
        ;

IndexPart:		INDEX '{' IndexTypes '}'
			{ $$ = $3; }
        |		AUGMENTS '{' Entry '}'
			/* TODO: no AUGMENTS clause in v1 */
			/* TODO: how to differ INDEX and AUGMENTS ? */
			{ $$ = $3; }
        |		/* empty */
			{ $$ = NULL; }
	;

IndexTypes:		IndexType
			{
			    $$ = util_malloc(sizeof(List));
			    /* TODO: success? */
			    $$->ptr = $1;
			    $$->nextPtr = NULL;
			}
        |		IndexTypes ',' IndexType
			/* TODO: might this list be emtpy? */
			{
			    List *p, *pp;
			    
			    p = util_malloc(sizeof(List));
			    p->ptr = $3;
			    p->nextPtr = NULL;
			    for (pp = $1; pp->nextPtr; pp = pp->nextPtr);
			    pp->nextPtr = p;
			    $$ = $1;
			}
	;

IndexType:		IMPLIED Index
			{
			    /* TODO: handle `IMPLIED' ?! */
			    $$ = $2;
			}
	|		Index
			{
			    $$ = $1;
			}
	;

Index:			ObjectName
			/* TODO: use the SYNTAX value of the correspondent
			 *       OBJECT-TYPE invocation
			 */
			{
			    $$ = $1;
			}
        ;

Entry:			ObjectName
			/* TODO: use the SYNTAX value of the correspondent
			 *       OBJECT-TYPE invocation
			 */
			{
			    $$ = util_malloc(sizeof(List));
			    /* TODO: success? */
			    $$->ptr = $1;
			    $$->nextPtr = NULL;
			}
        ;

DefValPart:		DEFVAL '{' Value '}'
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
			/* TODO: different for DefValPart in AgentCaps ? */
	;

Value:			valueofObjectSyntax
			{ $$ = 0; }
	|		'{' BitsValue '}'
			{ $$ = 0; }
	;

BitsValue:		BitNames
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

BitNames:		BitName
			{ $$ = 0; }
	|		BitNames ',' BitName
			{ $$ = 0; }
	;

BitName:		identifier
			{ $$ = 0; }
	;

ObjectName:		objectIdentifier
			{
			    $$ = $1;
			}
	;

NotificationName:	objectIdentifier
			{
			    $$ = $1;
			}
	;

ReferPart:		REFERENCE Text
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

RevisionPart:		Revisions
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

Revisions:		Revision
			{ $$ = 0; }
	|		Revisions Revision
			{ $$ = 0; }
	;

Revision:		REVISION ExtUTCTime
			DESCRIPTION Text
			{
			    time_t date;

			    date = smiMkTime($2);

			    /*
			     * If the first REVISION (which is the newest)
			     * has another date than the LAST-UPDATED clause,
			     * we add an implicit Revision structure.
			     */
			    if ((!thisModulePtr->firstRevisionPtr) &&
				(date != thisModulePtr->lastUpdated)) {
				addRevision(thisModulePtr->lastUpdated,
	     "[Revision added by libsmi due to an SMIv2 LAST-UPDATED clause.]",
					    thisParserPtr);
			    }
			    
			    if (addRevision(date, $4, thisParserPtr))
				$$ = 0;
			    else
				$$ = -1;
			}
	;

ObjectsPart:		OBJECTS '{' Objects '}'
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

Objects:		Object
			{ $$ = 0; }
	|		Objects ',' Object
			{ $$ = 0; }
	;

Object:			ObjectName
			{ $$ = 0; }
	;

NotificationsPart:	NOTIFICATIONS '{' Notifications '}'
			{
			    $$ = 0;
			}
	;

Notifications:		Notification
			{ $$ = 0; }
	|		Notifications ',' Notification
			{ $$ = 0; }
	;

Notification:		NotificationName
			{ $$ = 0; }
	;

Text:			QUOTED_STRING
			{
			    $$ = util_strdup($1);
			}
	;

/*
 * TODO: REF: 
 */
ExtUTCTime:		QUOTED_STRING
			{
			    /* TODO: check length and format */
			    $$ = util_strdup($1);
			}
	;

objectIdentifier:	{
			    parentNodePtr = rootNodePtr;
			}
			subidentifiers
			{
			    $$ = $2;
			    parentNodePtr = $2->nodePtr;
			}
	;

subidentifiers:
			subidentifier
			{
			    $$ = $1;
			}
	|		subidentifiers
			subidentifier
			{
			    $$ = $2;
			}
        ;

subidentifier:
			LOWERCASE_IDENTIFIER
			{
			    Object *objectPtr;
			    smi_node *snodePtr;
			    Import *importPtr;
			    
			    if (parentNodePtr != rootNodePtr) {
				printError(thisParserPtr,
					   ERR_OIDLABEL_NOT_FIRST, $1);
			    } else {
				objectPtr = findObjectByModuleAndName(
				    thisParserPtr->modulePtr, $1);
				if (objectPtr) {
				    $$ = objectPtr;
				} else {
				    importPtr = findImportByName($1,
							       thisModulePtr);
				    if (!importPtr) {
					/* 
					 * forward referenced node. create it,
					 * marked with FLAG_INCOMPLETE.
					 */
					objectPtr = addObject($1,
							      pendingNodePtr,
							      0,
							      FLAG_INCOMPLETE,
							      thisParserPtr);
					setObjectFileOffset(objectPtr,
						     thisParserPtr->character);
					$$ = objectPtr;
				    } else {
					/*
					 * imported object.
					 */
					snodePtr = smiGetNode($1,
							    importPtr->module);
					if (snodePtr) {
					    $$ = addObject($1, 
							   getParentNode(
					           createNodes(snodePtr->oid)),
					           getLastSubid(snodePtr->oid),
							   FLAG_IMPORTED,
							   thisParserPtr);
					} else {
					    $$ = addObject($1, pendingNodePtr,
							   0,
					       FLAG_IMPORTED | FLAG_INCOMPLETE,
							   thisParserPtr);
					}
				    }
				}
				parentNodePtr = $$->nodePtr;
			    }
			}
	|		moduleName '.' LOWERCASE_IDENTIFIER
			{
			    Object *objectPtr;
			    smi_node *snodePtr;
			    char s[2*MAX_IDENTIFIER_LENGTH+2];
			    Import *importPtr;
			    
			    sprintf(s, "%s.%s", $1, $3);

			    if (parentNodePtr != rootNodePtr) {
				printError(thisParserPtr,
					   ERR_OIDLABEL_NOT_FIRST, $1);
			    } else {
				objectPtr = findObjectByModulenameAndName(
				    $1, $3);
				if (objectPtr) {
				    $$ = objectPtr;
				} else {
				    importPtr = findImportByModulenameAndName(
					$1, $3, thisModulePtr);
				    if (!importPtr) {
					/* TODO: check: $1 == thisModule ? */
					/* 
					 * forward referenced node. create it,
					 * marked with FLAG_INCOMPLETE.
					 */
					objectPtr = addObject($1,
							    pendingNodePtr,
							      0,
							      FLAG_INCOMPLETE,
							      thisParserPtr);
					setObjectFileOffset(objectPtr,
						     thisParserPtr->character);
					$$ = objectPtr;
				    } else {
					/*
					 * imported object.
					 */
					snodePtr = smiGetNode($3, $1);
					$$ = addObject($3, 
					  getParentNode(
					      createNodes(snodePtr->oid)),
					  getLastSubid(snodePtr->oid),
					  FLAG_IMPORTED,
					  thisParserPtr);
				    }
				}
				parentNodePtr = $$->nodePtr;
			    }
			}
	|		number
			{
			    Node *nodePtr;
			    Object *objectPtr;

			    nodePtr = findNodeByParentAndSubid(parentNodePtr,
							       atoi($1));
			    if (nodePtr) {
				/*
				 * hopefully, the last defined Object for
				 * this Node is the one we expect.
				 */
				$$ = nodePtr->lastObjectPtr;
			    } else {
				objectPtr = addObject("",
						      parentNodePtr,
						      atoi($1),
						      FLAG_INCOMPLETE,
						      thisParserPtr);
				$$ = objectPtr;
				setObjectFileOffset(objectPtr,
						    thisParserPtr->character);
			    }
			    parentNodePtr = $$->nodePtr;
			}
	|		LOWERCASE_IDENTIFIER '(' number ')'
			{
			    Object *objectPtr;
			    
			    /* TODO: search in local module and
			     *       in imported modules
			     */
			    objectPtr = findObjectByModuleAndName(
				thisParserPtr->modulePtr, $1);
			    if (objectPtr) {
				printError(thisParserPtr,
					   ERR_EXISTENT_OBJECT, $1);
				$$ = objectPtr;
				if ($$->nodePtr->subid != atoi($3)) {
				    printError(thisParserPtr,
					       ERR_SUBIDENTIFIER_VS_OIDLABEL,
					       $3, $1);
				}
			    } else {
				objectPtr = addObject($1, parentNodePtr,
						      atoi($3), 0,
						      thisParserPtr);
				setObjectFileOffset(objectPtr,
						    thisParserPtr->character);
				$$ = objectPtr;
			    }
			    
			    parentNodePtr = $$->nodePtr;
			}
	|		moduleName '.' LOWERCASE_IDENTIFIER '(' number ')'
			{
			    Object *objectPtr;
			    char md[2*MAX_IDENTIFIER_LENGTH+2];
			    
			    sprintf(md, "%s.%s", $1, $3);
			    objectPtr = findObjectByModulenameAndName($1, $3);
			    if (objectPtr) {
				printError(thisParserPtr, ERR_EXISTENT_OBJECT,
					   $1);
				$$ = objectPtr;
				if ($$->nodePtr->subid != atoi($5)) {
				    printError(thisParserPtr,
					       ERR_SUBIDENTIFIER_VS_OIDLABEL,
					       $5, md);
				}
			    } else {
				printError(thisParserPtr,
					   ERR_ILLEGALLY_QUALIFIED, md);
				objectPtr = addObject($3, parentNodePtr,
						   atoi($5), 0,
						   thisParserPtr);
				setObjectFileOffset(objectPtr,
						    thisParserPtr->character);
				$$ = objectPtr;
			    }

			    parentNodePtr = $$->nodePtr;
			}
	;

objectIdentifier_defval: subidentifiers_defval
			{ $$ = 0; }
        ;		/* TODO: right? */

subidentifiers_defval:	subidentifier_defval
			{ $$ = 0; }
	|		subidentifiers_defval subidentifier_defval
			{ $$ = 0; }
        ;		/* TODO: right? */

subidentifier_defval:	LOWERCASE_IDENTIFIER '(' number ')'
			{ $$ = 0; }
	|		number
			{ $$ = 0; }
	;		/* TODO: right? range? */

objectGroupClause:	LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			OBJECT_GROUP
			ObjectsPart
			STATUS Status
			DESCRIPTION Text
			ReferPart
			COLON_COLON_EQUAL '{' objectIdentifier '}'
			{
			    Object *objectPtr;
			    
			    objectPtr = $12;
			    
			    if (objectPtr->modulePtr !=
				thisParserPtr->modulePtr) {
				objectPtr = duplicateObject(objectPtr, 0,
							    thisParserPtr);
			    }
			    objectPtr = setObjectName(objectPtr, $1);
			    setObjectDecl(objectPtr, SMI_DECL_OBJECTGROUP);
			    addObjectFlags(objectPtr, FLAG_REGISTERED);
			    setObjectStatus(objectPtr, $6);
			    setObjectDescription(objectPtr, $8);
			    setObjectAccess(objectPtr,
					    SMI_ACCESS_NOT_ACCESSIBLE);
#if 0
				/*
				 * TODO: ObjectsPart ($4)
				 * TODO: ReferPart ($9)
				 */
#endif
			    $$ = 0;
			}
	;

notificationGroupClause: LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			NOTIFICATION_GROUP
			NotificationsPart
			STATUS Status
			DESCRIPTION Text
			ReferPart
			COLON_COLON_EQUAL
			'{' objectIdentifier '}'
			{
			    Object *objectPtr;
			    
			    objectPtr = $12;
			    
			    if (objectPtr->modulePtr !=
				thisParserPtr->modulePtr) {
				objectPtr = duplicateObject(objectPtr, 0,
							    thisParserPtr);
			    }
			    objectPtr = setObjectName(objectPtr, $1);
			    setObjectDecl(objectPtr,
					  SMI_DECL_NOTIFICATIONGROUP);
			    addObjectFlags(objectPtr, FLAG_REGISTERED);
			    setObjectStatus(objectPtr, $6);
			    setObjectDescription(objectPtr, $8);
			    setObjectAccess(objectPtr,
					    SMI_ACCESS_NOT_ACCESSIBLE);
#if 0
				/*
				 * TODO: NotificationsPart ($4)
				 * TODO: ReferPart ($9)
				 */
#endif
			    $$ = 0;
			}
	;

moduleComplianceClause:	LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			MODULE_COMPLIANCE
			STATUS Status
			DESCRIPTION Text
			ReferPart
			ModulePart_Compliance
			COLON_COLON_EQUAL '{' objectIdentifier '}'
			{
			    Object *objectPtr;
			    
			    objectPtr = $12;
			    
			    if (objectPtr->modulePtr !=
				thisParserPtr->modulePtr) {
				objectPtr = duplicateObject(objectPtr, 0,
							    thisParserPtr);
			    }
			    setObjectDecl(objectPtr,
					  SMI_DECL_MODULECOMPLIANCE);
			    addObjectFlags(objectPtr, FLAG_REGISTERED);
			    setObjectStatus(objectPtr, $5);
			    setObjectDescription(objectPtr, $7);
#if 0
				/*
				 * TODO: ReferPart ($8)
				 * TODO: ModulePart_Compliance ($9)
				 */
#endif
			    $$ = 0;
			}
	;

ModulePart_Compliance:	Modules_Compliance
			{ $$ = 0; }
	;

Modules_Compliance:	Module_Compliance
			{ $$ = 0; }
	|		Modules_Compliance Module_Compliance
			{ $$ = 0; }
	;

Module_Compliance:	MODULE ModuleName_Compliance
			MandatoryPart
			CompliancePart
			{ $$ = 0; }
	;

ModuleName_Compliance:	UPPERCASE_IDENTIFIER objectIdentifier
			{ $$ = 0; }
	|		UPPERCASE_IDENTIFIER
			{ $$ = 0; }
	|		/* empty, only if contained in MIB module */
			/* TODO: RFC 1904 looks a bit different, is this ok? */
			{ $$ = 0; }
	;

MandatoryPart:		MANDATORY_GROUPS '{' Groups '}'
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

Groups:			Group
			{ $$ = 0; }
	|		Groups ',' Group
			{ $$ = 0; }
	;

Group:			objectIdentifier
			{ $$ = 0; }
	;

CompliancePart:		Compliances
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

Compliances:		Compliance
			{ $$ = 0; }
	|		Compliances Compliance
			{ $$ = 0; }
	;

Compliance:		ComplianceGroup
			{ $$ = 0; }
	|		Object_Compliance
			{ $$ = 0; }
	;

ComplianceGroup:	GROUP objectIdentifier
			DESCRIPTION Text
			{ $$ = 0; }
	;

Object_Compliance:	OBJECT ObjectName
			SyntaxPart
			WriteSyntaxPart
			AccessPart
			DESCRIPTION Text
			{ $$ = 0; }
	;

SyntaxPart:		SYNTAX Syntax
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

WriteSyntaxPart:	WRITE_SYNTAX WriteSyntax
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

WriteSyntax:		Syntax
			/* TODO: right? */
			{ $$ = 0; }
	;

AccessPart:		MIN_ACCESS Access
			{ $$ = $2; }
	|		/* empty */
			{ $$ = SMI_ACCESS_UNKNOWN; }
	;

agentCapabilitiesClause: LOWERCASE_IDENTIFIER
			{ 
			    if (strlen($1) > 64) {
			        printError(thisParserPtr, ERR_OIDNAME_64, $1);
			    } else if (strlen($1) > 32) {
			        printError(thisParserPtr, ERR_OIDNAME_32, $1);
			    }
			}
			AGENT_CAPABILITIES
			PRODUCT_RELEASE Text
			STATUS Status_Capabilities
			DESCRIPTION Text
			ReferPart
			ModulePart_Capabilities
			COLON_COLON_EQUAL '{' objectIdentifier '}'
			{
			    Object *objectPtr;
			    
			    objectPtr = $14;
			    
			    if (objectPtr->modulePtr !=
				thisParserPtr->modulePtr) {
				objectPtr = duplicateObject(objectPtr, 0,
							    thisParserPtr);
			    }
			    setObjectDecl(objectPtr,
					  SMI_DECL_AGENTCAPABILITIES);
			    addObjectFlags(objectPtr, FLAG_REGISTERED);
			    setObjectStatus(objectPtr, $7);
			    setObjectDescription(objectPtr, $9);
#if 0
				/*
				 * TODO: PRODUCT_RELEASE Text ($5)
				 * TODO: ReferPart ($10)
				 * TODO: ModulePart_Capabilities ($11)
				 */
#endif
			    $$ = 0;
			}
	;

ModulePart_Capabilities: Modules_Capabilities
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

Modules_Capabilities:	Module_Capabilities
			{ $$ = 0; }
	|		Modules_Capabilities Module_Capabilities
			{ $$ = 0; }
	;

Module_Capabilities:	SUPPORTS ModuleName_Capabilities
			/* TODO: example in the SimpleBook names the module
			 * while the given syntax provides oids ?! */
			INCLUDES '{' Groups '}'
			VariationPart
			{ $$ = 0; }
	;

ModuleName_Capabilities: objectIdentifier
			{ $$ = 0; }
	|		UPPERCASE_IDENTIFIER
			{ $$ = 0; }
	|		/* empty */
			/* empty, only if contained in MIB module */
			/* TODO: ?? */
			{ $$ = 0; }
	;

VariationPart:		Variations
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

Variations:		Variation
			{ $$ = 0; }
	|		Variations Variation
			{ $$ = 0; }
	;

Variation:		ObjectVariation
			{ $$ = 0; }
	|		NotificationVariation
			{ $$ = 0; }
	;

NotificationVariation:	VARIATION ObjectName
			AccessPart
			DESCRIPTION Text
			{ $$ = 0; }
	;

ObjectVariation:	VARIATION ObjectName
			SyntaxPart
			WriteSyntaxPart
			AccessPart
			CreationPart
			DefValPart
			DESCRIPTION Text
			{ $$ = 0; }
	;

CreationPart:		CREATION_REQUIRES '{' Cells '}'
			{ $$ = 0; }
	|		/* empty */
			{ $$ = 0; }
	;

Cells:			Cell
			{ $$ = 0; }
	|		Cells ',' Cell
			{ $$ = 0; }
	;

Cell:			ObjectName
			{ $$ = 0; }
	;

number:			NUMBER
			{
			    $$ = util_strdup($1);
			    /* TODO */
			}
	;

%%			    /*  */
