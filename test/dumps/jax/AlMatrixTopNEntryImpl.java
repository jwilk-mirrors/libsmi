/*
 * This Java file has been generated by smidump 0.2.10. It
 * is intended to be edited by the application programmer and
 * to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class extends the Java AgentX (JAX) implementation of
    the table row alMatrixTopNEntry defined in RMON2-MIB.
 */

import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXEntry;

public class AlMatrixTopNEntryImpl extends AlMatrixTopNEntry
{

    // constructor
    public AlMatrixTopNEntryImpl(int alMatrixTopNControlIndex,
                             int alMatrixTopNIndex)
    {
        super(alMatrixTopNControlIndex,
                   alMatrixTopNIndex);
    }

    public int get_alMatrixTopNProtocolDirLocalIndex()
    {
        return alMatrixTopNProtocolDirLocalIndex;
    }

    public byte[] get_alMatrixTopNSourceAddress()
    {
        return alMatrixTopNSourceAddress;
    }

    public byte[] get_alMatrixTopNDestAddress()
    {
        return alMatrixTopNDestAddress;
    }

    public int get_alMatrixTopNAppProtocolDirLocalIndex()
    {
        return alMatrixTopNAppProtocolDirLocalIndex;
    }

    public long get_alMatrixTopNPktRate()
    {
        return alMatrixTopNPktRate;
    }

    public long get_alMatrixTopNReversePktRate()
    {
        return alMatrixTopNReversePktRate;
    }

    public long get_alMatrixTopNOctetRate()
    {
        return alMatrixTopNOctetRate;
    }

    public long get_alMatrixTopNReverseOctetRate()
    {
        return alMatrixTopNReverseOctetRate;
    }

}

