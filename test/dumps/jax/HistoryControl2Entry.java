/*
 * This Java file has been generated by smidump 0.2.8. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class represents a Java AgentX (JAX) implementation of
    the table row historyControl2Entry defined in RMON2-MIB.

    @version 1
    @author  smidump 0.2.8
    @see     AgentXTable, AgentXEntry
 */

import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXEntry;

public class HistoryControl2Entry extends AgentXEntry
{

    protected long historyControlDroppedFrames = 0;

    public HistoryControl2Entry()
    {

    }

    public long get_historyControlDroppedFrames()
    {
        return historyControlDroppedFrames;
    }

}

