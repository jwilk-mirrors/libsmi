/*
 * This Java file has been generated by smidump 0.4.2-pre1. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class represents a Java AgentX (JAX) implementation of
    the scalar group snmpSet defined in SNMPv2-MIB.

    @version 1
    @author  smidump 0.4.2-pre1
    @see     AgentXGroup, AgentXScalars
 */

import java.util.Vector;
import java.util.Enumeration;
import jax.AgentXOID;
import jax.AgentXVarBind;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXScalars;

public class SnmpSet extends AgentXScalars
{

    private final static long[] SnmpSetOID = {1, 3, 6, 1, 6, 3, 1, 1, 6};

    protected AgentXOID SnmpSetSerialNoOID;
    protected final static long[] SnmpSetSerialNoName = {1, 3, 6, 1, 6, 3, 1, 1, 6, 1, 0};
    protected int snmpSetSerialNo = 0;
    protected int undo_snmpSetSerialNo = 0;
    public SnmpSet()
    {
        oid = new AgentXOID(SnmpSetOID);
        data = new Vector();
        SnmpSetSerialNoOID = new AgentXOID(SnmpSetSerialNoName);
        data.addElement(SnmpSetSerialNoOID);
    }

    public int get_snmpSetSerialNo()
    {
        return snmpSetSerialNo;
    }

    public int set_snmpSetSerialNo(AgentXSetPhase phase, int value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_snmpSetSerialNo = snmpSetSerialNo;
            snmpSetSerialNo = value;
            break;
        case AgentXSetPhase.UNDO:
            snmpSetSerialNo = undo_snmpSetSerialNo;
            break;
        case AgentXSetPhase.CLEANUP:
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }
    public AgentXVarBind getScalar(AgentXOID pos, AgentXOID oid)
    {
        if ((pos == null) || (pos.compareTo(oid) != 0))
            return new AgentXVarBind(oid, AgentXVarBind.NOSUCHOBJECT);
        else {
            if (pos == SnmpSetSerialNoOID)
                return new AgentXVarBind(oid, AgentXVarBind.INTEGER, 
                                         get_snmpSetSerialNo());
        }
        return new AgentXVarBind(oid, AgentXVarBind.NOSUCHOBJECT);
    }

    public int setScalar(AgentXSetPhase phase, AgentXOID pos,
                         AgentXVarBind inVb)
    {
        if ((pos == null) || (pos.compareTo(inVb.getOID()) != 0))
            return AgentXResponsePDU.INCONSISTENT_NAME;
        else {
            if (pos == SnmpSetSerialNoOID)
                return set_snmpSetSerialNo(phase, inVb.intValue());
        }
        return AgentXResponsePDU.NOT_WRITABLE;
    }

    public AgentXVarBind getNextScalar(AgentXOID pos, AgentXOID oid)
    {
        if ((pos == null) || (pos.compareTo(oid) <= 0))
            return new AgentXVarBind(oid, AgentXVarBind.ENDOFMIBVIEW);
        else {
            if (pos == SnmpSetSerialNoOID)
                return new AgentXVarBind(pos, AgentXVarBind.INTEGER, 
                                         get_snmpSetSerialNo());
        }
        return new AgentXVarBind(pos, AgentXVarBind.ENDOFMIBVIEW);
    }

}

