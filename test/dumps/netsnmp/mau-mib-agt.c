/*
 * This C file has been generated by smidump 0.4.2-pre1.
 * It is intended to be used with the NET-SNMP agent library.
 *
 * This C file is derived from the MAU-MIB module.
 *
 * $Id$
 */

#include <stdio.h>
#include <string.h>
#include <malloc.h>

#include "mau-mib.h"

#include <ucd-snmp/asn1.h>
#include <ucd-snmp/snmp.h>
#include <ucd-snmp/snmp_api.h>
#include <ucd-snmp/snmp_impl.h>
#include <ucd-snmp/snmp_vars.h>

static oid mau_mib_caps[] = {0,0};

void init_mau_mib(void)
{
}

void deinit_mau_mib()
{
    unregister_sysORTable(mau_mib_caps, sizeof(mau_mib_caps));
}

int term_mau_mib()
{
    deinit_mau_mib();
    return 0;
}

