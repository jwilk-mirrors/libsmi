/*
 * This Java file has been generated by smidump 0.2.7. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class represents a Java AgentX (JAX) implementation of
    the table row usrHistoryObjectEntry defined in RMON2-MIB.

    @version 1
    @author  smidump 0.2.7
    @see     AgentXTable, AgentXEntry
 */

import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXEntry;

public class UsrHistoryObjectEntry extends AgentXEntry
{

    protected int usrHistoryObjectIndex = 0;
    protected AgentXOID usrHistoryObjectVariable = new AgentXOID();
    protected AgentXOID undo_usrHistoryObjectVariable = new AgentXOID();
    protected int usrHistoryObjectSampleType = 0;
    protected int undo_usrHistoryObjectSampleType = 0;
    // foreign indices
    protected int usrHistoryControlIndex;

    public UsrHistoryObjectEntry(int usrHistoryControlIndex,
                                 int usrHistoryObjectIndex)
    {
        this.usrHistoryControlIndex = usrHistoryControlIndex;
        this.usrHistoryObjectIndex = usrHistoryObjectIndex;

        instance.append(usrHistoryControlIndex);
        instance.append(usrHistoryObjectIndex);
    }

    public int get_usrHistoryControlIndex()
    {
        return usrHistoryControlIndex;
    }

    public int get_usrHistoryObjectIndex()
    {
        return usrHistoryObjectIndex;
    }

    public AgentXOID get_usrHistoryObjectVariable()
    {
        return usrHistoryObjectVariable;
    }

    public int set_usrHistoryObjectVariable(AgentXSetPhase phase, AgentXOID value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_usrHistoryObjectVariable = usrHistoryObjectVariable;
            usrHistoryObjectVariable = value;
            break;
        case AgentXSetPhase.UNDO:
            usrHistoryObjectVariable = undo_usrHistoryObjectVariable;
            break;
        case AgentXSetPhase.CLEANUP:
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }
    public int get_usrHistoryObjectSampleType()
    {
        return usrHistoryObjectSampleType;
    }

    public int set_usrHistoryObjectSampleType(AgentXSetPhase phase, int value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_usrHistoryObjectSampleType = usrHistoryObjectSampleType;
            usrHistoryObjectSampleType = value;
            break;
        case AgentXSetPhase.UNDO:
            usrHistoryObjectSampleType = undo_usrHistoryObjectSampleType;
            break;
        case AgentXSetPhase.CLEANUP:
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }
}

