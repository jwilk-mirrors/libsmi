/*
 * This Java file has been generated by smidump 0.2.12. It
 * is intended to be edited by the application programmer and
 * to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class extends the Java AgentX (JAX) implementation of
    the scalar group addressMap defined in RMON2-MIB.
 */

import java.util.Vector;
import java.util.Enumeration;
import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;

public class AddressMapImpl extends AddressMap
{

    public long get_addressMapInserts()
    {
        return addressMapInserts;
    }

    public long get_addressMapDeletes()
    {
        return addressMapDeletes;
    }

    public int get_addressMapMaxDesiredEntries()
    {
        return addressMapMaxDesiredEntries;
    }

    public int set_addressMapMaxDesiredEntries(AgentXSetPhase phase, int value)
    {
        switch (phase.getPhase()) {
        case AgentXSetPhase.TEST_SET:
            break;
        case AgentXSetPhase.COMMIT:
            undo_addressMapMaxDesiredEntries = addressMapMaxDesiredEntries;
            addressMapMaxDesiredEntries = value;
            break;
        case AgentXSetPhase.UNDO:
            addressMapMaxDesiredEntries = undo_addressMapMaxDesiredEntries;
            break;
        case AgentXSetPhase.CLEANUP:
            undo_addressMapMaxDesiredEntries = -1; // TODO: better check!
            break;
        default:
            return AgentXResponsePDU.PROCESSING_ERROR;
        }
        return AgentXResponsePDU.NO_ERROR;
    }

}

