/*
 * This Java file has been generated by smidump 0.4.2-pre1. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class represents a Java AgentX (JAX) implementation of
    the table row ifEntry defined in IF-MIB.

    @version 1
    @author  smidump 0.4.2-pre1
    @see     AgentXTable, AgentXEntry
 */

import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXEntry;

public class IfEntry extends AgentXEntry
{

    protected int ifIndex = 0;
    protected byte[] ifDescr = new byte[0];
    protected int ifType = 0;
    protected int ifMtu = 0;
    protected long ifSpeed = 0;
    protected byte[] ifPhysAddress = new byte[0];
    protected int ifAdminStatus = 0;
    protected int undo_ifAdminStatus = 0;
    protected int ifOperStatus = 0;
    protected long ifLastChange = 0;
    protected long ifInOctets = 0;
    protected long ifInUcastPkts = 0;
    protected long ifInNUcastPkts = 0;
    protected long ifInDiscards = 0;
    protected long ifInErrors = 0;
    protected long ifInUnknownProtos = 0;
    protected long ifOutOctets = 0;
    protected long ifOutUcastPkts = 0;
    protected long ifOutNUcastPkts = 0;
    protected long ifOutDiscards = 0;
    protected long ifOutErrors = 0;
    protected long ifOutQLen = 0;
    protected AgentXOID ifSpecific = new AgentXOID();

    public IfEntry(int ifIndex)
    {
        this.ifIndex = ifIndex;

        instance.append(ifIndex);
    }

    public int get_ifIndex()
    {
        return ifIndex;
    }

    public byte[] get_ifDescr()
    {
        return ifDescr;
    }

    public int get_ifType()
    {
        return ifType;
    }

    public int get_ifMtu()
    {
        return ifMtu;
    }

    public long get_ifSpeed()
    {
        return ifSpeed;
    }

    public byte[] get_ifPhysAddress()
    {
        return ifPhysAddress;
    }

    public int get_ifAdminStatus()
    {
        return ifAdminStatus;
    }

    public int set_ifAdminStatus(AgentXSetPhase phase, int value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_ifAdminStatus = ifAdminStatus;
            ifAdminStatus = value;
            break;
        case AgentXSetPhase.UNDO:
            ifAdminStatus = undo_ifAdminStatus;
            break;
        case AgentXSetPhase.CLEANUP:
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }
    public int get_ifOperStatus()
    {
        return ifOperStatus;
    }

    public long get_ifLastChange()
    {
        return ifLastChange;
    }

    public long get_ifInOctets()
    {
        return ifInOctets;
    }

    public long get_ifInUcastPkts()
    {
        return ifInUcastPkts;
    }

    public long get_ifInNUcastPkts()
    {
        return ifInNUcastPkts;
    }

    public long get_ifInDiscards()
    {
        return ifInDiscards;
    }

    public long get_ifInErrors()
    {
        return ifInErrors;
    }

    public long get_ifInUnknownProtos()
    {
        return ifInUnknownProtos;
    }

    public long get_ifOutOctets()
    {
        return ifOutOctets;
    }

    public long get_ifOutUcastPkts()
    {
        return ifOutUcastPkts;
    }

    public long get_ifOutNUcastPkts()
    {
        return ifOutNUcastPkts;
    }

    public long get_ifOutDiscards()
    {
        return ifOutDiscards;
    }

    public long get_ifOutErrors()
    {
        return ifOutErrors;
    }

    public long get_ifOutQLen()
    {
        return ifOutQLen;
    }

    public AgentXOID get_ifSpecific()
    {
        return ifSpecific;
    }

}

