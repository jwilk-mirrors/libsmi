/*
 * This Java file has been generated by smidump 0.2.8. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class represents a Java AgentX (JAX) implementation of
    the table row ifRcvAddressEntry defined in IF-MIB.

    @version 1
    @author  smidump 0.2.8
    @see     AgentXTable, AgentXEntry
 */

import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXEntry;

public class IfRcvAddressEntry extends AgentXEntry
{

    protected byte[] ifRcvAddressAddress = new byte[0];
    protected int ifRcvAddressStatus = 0;
    protected int undo_ifRcvAddressStatus = 0;
    protected int ifRcvAddressType = 0;
    protected int undo_ifRcvAddressType = 0;
    // foreign indices
    protected int ifIndex;

    public IfRcvAddressEntry(int ifIndex,
                             byte[] ifRcvAddressAddress)
    {
        this.ifIndex = ifIndex;
        this.ifRcvAddressAddress = ifRcvAddressAddress;

        instance.append(ifIndex);
        instance.append(ifRcvAddressAddress);
    }

    public int get_ifIndex()
    {
        return ifIndex;
    }

    public byte[] get_ifRcvAddressAddress()
    {
        return ifRcvAddressAddress;
    }

    public int get_ifRcvAddressStatus()
    {
        return ifRcvAddressStatus;
    }

    public int set_ifRcvAddressStatus(AgentXSetPhase phase, int value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_ifRcvAddressStatus = ifRcvAddressStatus;
            ifRcvAddressStatus = value;
            break;
        case AgentXSetPhase.UNDO:
            ifRcvAddressStatus = undo_ifRcvAddressStatus;
            break;
        case AgentXSetPhase.CLEANUP:
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }
    public int get_ifRcvAddressType()
    {
        return ifRcvAddressType;
    }

    public int set_ifRcvAddressType(AgentXSetPhase phase, int value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_ifRcvAddressType = ifRcvAddressType;
            ifRcvAddressType = value;
            break;
        case AgentXSetPhase.UNDO:
            ifRcvAddressType = undo_ifRcvAddressType;
            break;
        case AgentXSetPhase.CLEANUP:
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }
}

