/*
 * This C file has been generated by smidump 0.2.14.
 * It is intended to be used with the NET-SNMP agent library.
 *
 * This C file is derived from the SNMPv2-MIB module.
 *
 * $Id$
 */

#include <stdio.h>
#include <string.h>
#include <malloc.h>

#include "snmpv2-mib.h"

#include <ucd-snmp/asn1.h>
#include <ucd-snmp/snmp.h>
#include <ucd-snmp/snmp_api.h>
#include <ucd-snmp/snmp_impl.h>
#include <ucd-snmp/snmp_vars.h>

static oid snmpv2_mib_caps[] = {0,0};

void init_snmpv2_mib(void)
{
}

void deinit_snmpv2_mib()
{
    unregister_sysORTable(snmpv2_mib_caps, sizeof(snmpv2_mib_caps));
}

int term_snmpv2_mib()
{
    deinit_snmpv2_mib();
    return 0;
}

