/*
 * This Java file has been generated by smidump 0.2.14. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class represents a Java AgentX (JAX) implementation of
    the table row alHostEntry defined in RMON2-MIB.

    @version 1
    @author  smidump 0.2.14
    @see     AgentXTable, AgentXEntry
 */

import jax.AgentXOID;
import jax.AgentXSetPhase;
import jax.AgentXResponsePDU;
import jax.AgentXEntry;

public class AlHostEntry extends AgentXEntry
{

    protected long alHostTimeMark = 0;
    protected long alHostInPkts = 0;
    protected long alHostOutPkts = 0;
    protected long alHostInOctets = 0;
    protected long alHostOutOctets = 0;
    protected long alHostCreateTime = 0;
    // foreign indices
    protected int hlHostControlIndex;
    protected int protocolDirLocalIndex;
    protected byte[] nlHostAddress;
    protected int protocolDirLocalIndex;

    public AlHostEntry(int hlHostControlIndex,
                       long alHostTimeMark,
                       int protocolDirLocalIndex,
                       byte[] nlHostAddress,
                       int protocolDirLocalIndex)
    {
        this.hlHostControlIndex = hlHostControlIndex;
        this.alHostTimeMark = alHostTimeMark;
        this.protocolDirLocalIndex = protocolDirLocalIndex;
        this.nlHostAddress = nlHostAddress;
        this.protocolDirLocalIndex = protocolDirLocalIndex;

        instance.append(hlHostControlIndex);
        instance.append(alHostTimeMark);
        instance.append(protocolDirLocalIndex);
        instance.append(nlHostAddress);
        instance.append(protocolDirLocalIndex);
    }

    public int get_hlHostControlIndex()
    {
        return hlHostControlIndex;
    }

    public long get_alHostTimeMark()
    {
        return alHostTimeMark;
    }

    public int get_protocolDirLocalIndex()
    {
        return protocolDirLocalIndex;
    }

    public byte[] get_nlHostAddress()
    {
        return nlHostAddress;
    }

    public int get_protocolDirLocalIndex()
    {
        return protocolDirLocalIndex;
    }

    public long get_alHostInPkts()
    {
        return alHostInPkts;
    }

    public long get_alHostOutPkts()
    {
        return alHostOutPkts;
    }

    public long get_alHostInOctets()
    {
        return alHostInOctets;
    }

    public long get_alHostOutOctets()
    {
        return alHostOutOctets;
    }

    public long get_alHostCreateTime()
    {
        return alHostCreateTime;
    }

}

