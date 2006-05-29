/*
 * This Java file has been generated by smidump 0.4.5. It
 * is intended to be edited by the application programmer and
 * to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class extends the Java AgentX (JAX) implementation of
    the table row filter2Entry defined in RMON2-MIB.
 */

import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXEntry;

public class Filter2EntryImpl extends Filter2Entry
{

    // constructor
    public Filter2EntryImpl()
    {
        super();
    }

    public int get_filterProtocolDirDataLocalIndex()
    {
        return filterProtocolDirDataLocalIndex;
    }

    public int set_filterProtocolDirDataLocalIndex(AgentXSetPhase phase, int value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_filterProtocolDirDataLocalIndex = filterProtocolDirDataLocalIndex;
            filterProtocolDirDataLocalIndex = value;
            break;
        case AgentXSetPhase.UNDO:
            filterProtocolDirDataLocalIndex = undo_filterProtocolDirDataLocalIndex;
            break;
        case AgentXSetPhase.CLEANUP:
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }
    public int get_filterProtocolDirLocalIndex()
    {
        return filterProtocolDirLocalIndex;
    }

    public int set_filterProtocolDirLocalIndex(AgentXSetPhase phase, int value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_filterProtocolDirLocalIndex = filterProtocolDirLocalIndex;
            filterProtocolDirLocalIndex = value;
            break;
        case AgentXSetPhase.UNDO:
            filterProtocolDirLocalIndex = undo_filterProtocolDirLocalIndex;
            break;
        case AgentXSetPhase.CLEANUP:
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }
}

