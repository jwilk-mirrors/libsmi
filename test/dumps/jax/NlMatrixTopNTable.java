/*
 * This Java file has been generated by smidump 0.2.17. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

/**
    This class represents a Java AgentX (JAX) implementation of
    the table nlMatrixTopNTable defined in RMON2-MIB.

    @version 1
    @author  smidump 0.2.17
    @see     AgentXTable
 */

import java.util.Vector;

import jax.AgentXOID;
import jax.AgentXVarBind;
import jax.AgentXResponsePDU;
import jax.AgentXSetPhase;
import jax.AgentXTable;
import jax.AgentXEntry;

public class NlMatrixTopNTable extends AgentXTable
{

    // entry OID
    private final static long[] OID = {1, 3, 6, 1, 2, 1, 16, 15, 5, 1};

    // constructors
    public NlMatrixTopNTable()
    {
        oid = new AgentXOID(OID);

        // register implemented columns
        columns.addElement(new Long(2));
        columns.addElement(new Long(3));
        columns.addElement(new Long(4));
        columns.addElement(new Long(5));
        columns.addElement(new Long(6));
        columns.addElement(new Long(7));
        columns.addElement(new Long(8));
    }

    public NlMatrixTopNTable(boolean shared)
    {
        super(shared);

        oid = new AgentXOID(OID);

        // register implemented columns
        columns.addElement(new Long(2));
        columns.addElement(new Long(3));
        columns.addElement(new Long(4));
        columns.addElement(new Long(5));
        columns.addElement(new Long(6));
        columns.addElement(new Long(7));
        columns.addElement(new Long(8));
    }

    public AgentXVarBind getVarBind(AgentXEntry entry, long column)
    {
        AgentXOID oid = new AgentXOID(getOID(), column, entry.getInstance());

        switch ((int)column) {
        case 2: // nlMatrixTopNProtocolDirLocalIndex
        {
            int value = ((NlMatrixTopNEntry)entry).get_nlMatrixTopNProtocolDirLocalIndex();
            return new AgentXVarBind(oid, AgentXVarBind.INTEGER, value);
        }
        case 3: // nlMatrixTopNSourceAddress
        {
            byte[] value = ((NlMatrixTopNEntry)entry).get_nlMatrixTopNSourceAddress();
            return new AgentXVarBind(oid, AgentXVarBind.OCTETSTRING, value);
        }
        case 4: // nlMatrixTopNDestAddress
        {
            byte[] value = ((NlMatrixTopNEntry)entry).get_nlMatrixTopNDestAddress();
            return new AgentXVarBind(oid, AgentXVarBind.OCTETSTRING, value);
        }
        case 5: // nlMatrixTopNPktRate
        {
            long value = ((NlMatrixTopNEntry)entry).get_nlMatrixTopNPktRate();
            return new AgentXVarBind(oid, AgentXVarBind.GAUGE32, value);
        }
        case 6: // nlMatrixTopNReversePktRate
        {
            long value = ((NlMatrixTopNEntry)entry).get_nlMatrixTopNReversePktRate();
            return new AgentXVarBind(oid, AgentXVarBind.GAUGE32, value);
        }
        case 7: // nlMatrixTopNOctetRate
        {
            long value = ((NlMatrixTopNEntry)entry).get_nlMatrixTopNOctetRate();
            return new AgentXVarBind(oid, AgentXVarBind.GAUGE32, value);
        }
        case 8: // nlMatrixTopNReverseOctetRate
        {
            long value = ((NlMatrixTopNEntry)entry).get_nlMatrixTopNReverseOctetRate();
            return new AgentXVarBind(oid, AgentXVarBind.GAUGE32, value);
        }
        }

        return null;
    }

    public int setEntry(AgentXSetPhase phase,
                        AgentXEntry entry,
                        long column,
                        AgentXVarBind vb)
    {

        switch ((int)column) {
        }

        return AgentXResponsePDU.NOT_WRITABLE;
    }

}

