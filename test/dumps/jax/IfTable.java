/*
 * This Java file has been generated by smidump 0.2.12. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class represents a Java AgentX (JAX) implementation of
    the table ifTable defined in IF-MIB.

    @version 1
    @author  smidump 0.2.12
    @see     AgentXTable
 */

import java.util.Vector;

import jax.AgentXOID;
import jax.AgentXVarBind;
import jax.AgentXResponsePDU;
import jax.AgentXSetPhase;
import jax.AgentXTable;
import jax.AgentXEntry;

public class IfTable extends AgentXTable
{

    // entry OID
    private final static long[] OID = {1, 3, 6, 1, 2, 1, 2, 2, 1};

    // constructor
    public IfTable()
    {
        oid = new AgentXOID(OID);

        // register implemented columns
        columns.addElement(new Long(1));
        columns.addElement(new Long(2));
        columns.addElement(new Long(3));
        columns.addElement(new Long(4));
        columns.addElement(new Long(5));
        columns.addElement(new Long(6));
        columns.addElement(new Long(7));
        columns.addElement(new Long(8));
        columns.addElement(new Long(9));
        columns.addElement(new Long(10));
        columns.addElement(new Long(11));
        columns.addElement(new Long(12));
        columns.addElement(new Long(13));
        columns.addElement(new Long(14));
        columns.addElement(new Long(15));
        columns.addElement(new Long(16));
        columns.addElement(new Long(17));
        columns.addElement(new Long(18));
        columns.addElement(new Long(19));
        columns.addElement(new Long(20));
        columns.addElement(new Long(21));
        columns.addElement(new Long(22));
    }

    public AgentXVarBind getVarBind(AgentXEntry entry, long column)
    {
        AgentXOID oid = new AgentXOID(getOID(), column, entry.getInstance());

        switch ((int)column) {
        case 1: // ifIndex
        {
            int value = ((IfEntry)entry).get_ifIndex();
            return new AgentXVarBind(oid, AgentXVarBind.INTEGER, value);
        }
        case 2: // ifDescr
        {
            byte[] value = ((IfEntry)entry).get_ifDescr();
            return new AgentXVarBind(oid, AgentXVarBind.OCTETSTRING, value);
        }
        case 3: // ifType
        {
            int value = ((IfEntry)entry).get_ifType();
            return new AgentXVarBind(oid, AgentXVarBind.INTEGER, value);
        }
        case 4: // ifMtu
        {
            int value = ((IfEntry)entry).get_ifMtu();
            return new AgentXVarBind(oid, AgentXVarBind.INTEGER, value);
        }
        case 5: // ifSpeed
        {
            long value = ((IfEntry)entry).get_ifSpeed();
            return new AgentXVarBind(oid, AgentXVarBind.GAUGE32, value);
        }
        case 6: // ifPhysAddress
        {
            byte[] value = ((IfEntry)entry).get_ifPhysAddress();
            return new AgentXVarBind(oid, AgentXVarBind.OCTETSTRING, value);
        }
        case 7: // ifAdminStatus
        {
            int value = ((IfEntry)entry).get_ifAdminStatus();
            return new AgentXVarBind(oid, AgentXVarBind.INTEGER, value);
        }
        case 8: // ifOperStatus
        {
            int value = ((IfEntry)entry).get_ifOperStatus();
            return new AgentXVarBind(oid, AgentXVarBind.INTEGER, value);
        }
        case 9: // ifLastChange
        {
            long value = ((IfEntry)entry).get_ifLastChange();
            return new AgentXVarBind(oid, AgentXVarBind.TIMETICKS, value);
        }
        case 10: // ifInOctets
        {
            long value = ((IfEntry)entry).get_ifInOctets();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 11: // ifInUcastPkts
        {
            long value = ((IfEntry)entry).get_ifInUcastPkts();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 12: // ifInNUcastPkts
        {
            long value = ((IfEntry)entry).get_ifInNUcastPkts();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 13: // ifInDiscards
        {
            long value = ((IfEntry)entry).get_ifInDiscards();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 14: // ifInErrors
        {
            long value = ((IfEntry)entry).get_ifInErrors();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 15: // ifInUnknownProtos
        {
            long value = ((IfEntry)entry).get_ifInUnknownProtos();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 16: // ifOutOctets
        {
            long value = ((IfEntry)entry).get_ifOutOctets();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 17: // ifOutUcastPkts
        {
            long value = ((IfEntry)entry).get_ifOutUcastPkts();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 18: // ifOutNUcastPkts
        {
            long value = ((IfEntry)entry).get_ifOutNUcastPkts();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 19: // ifOutDiscards
        {
            long value = ((IfEntry)entry).get_ifOutDiscards();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 20: // ifOutErrors
        {
            long value = ((IfEntry)entry).get_ifOutErrors();
            return new AgentXVarBind(oid, AgentXVarBind.COUNTER32, value);
        }
        case 21: // ifOutQLen
        {
            long value = ((IfEntry)entry).get_ifOutQLen();
            return new AgentXVarBind(oid, AgentXVarBind.GAUGE32, value);
        }
        case 22: // ifSpecific
        {
            AgentXOID value = ((IfEntry)entry).get_ifSpecific();
            return new AgentXVarBind(oid, AgentXVarBind.OBJECTIDENTIFIER, value);
        }
        }

        return null;
    }

    public int setEntry(AgentXSetPhase phase,
                        AgentXEntry entry,
                        long column,
                        AgentXVarBind vb)
    {

        switch ((int)column) {
        case 7: // ifAdminStatus
        {
            if (vb.getType() != AgentXVarBind.INTEGER)
                return AgentXResponsePDU.WRONG_TYPE;
            else
                return ((IfEntry)entry).set_ifAdminStatus(phase, vb.intValue());
        }
        }

        return AgentXResponsePDU.NOT_WRITABLE;
    }

}

