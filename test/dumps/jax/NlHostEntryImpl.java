/*
 * This Java file has been generated by smidump 0.2.7. It
 * is intended to be edited by the application programmer and
 * to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class extends the Java AgentX (JAX) implementation of
    the table row nlHostEntry defined in RMON2-MIB.
 */

import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXEntry;

public class NlHostEntryImpl extends ��%@
{

    // constructor
    public NlHostEntryImpl(int hlHostControlIndex,
                       long nlHostTimeMark,
                       int protocolDirLocalIndex,
                       byte[] nlHostAddress)
    {
        super(hlHostControlIndex,
             nlHostTimeMark,
             protocolDirLocalIndex,
             nlHostAddress);
    }

    public long get_nlHostInPkts()
    {
        return nlHostInPkts;
    }

    public long get_nlHostOutPkts()
    {
        return nlHostOutPkts;
    }

    public long get_nlHostInOctets()
    {
        return nlHostInOctets;
    }

    public long get_nlHostOutOctets()
    {
        return nlHostOutOctets;
    }

    public long get_nlHostOutMacNonUnicastPkts()
    {
        return nlHostOutMacNonUnicastPkts;
    }

    public long get_nlHostCreateTime()
    {
        return nlHostCreateTime;
    }

}

