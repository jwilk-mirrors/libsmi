/*
 * This Java file has been generated by smidump 0.2.14. Do not edit!
 * It is intended to be used within a Java AgentX sub-agent environment.
 *
 * $Id$
 */

import jax.AgentXOID;
import jax.AgentXVarBind;
import jax.AgentXNotification;
import java.util.Vector;

public class IfMauJabberTrap extends AgentXNotification
{

    private final static long[] ifMauJabberTrap_OID = {1, 3, 6, 1, 2, 1, 26, 0, 2};
    private static AgentXVarBind snmpTrapOID_VarBind =
        new AgentXVarBind(snmpTrapOID_OID,
                          AgentXVarBind.OBJECTIDENTIFIER,
                          new AgentXOID(ifMauJabberTrap_OID));

    private final static long[] OID1 = {1, 3, 6, 1, 2, 1, 26, 2, 1, 1, 7};
    private final static AgentXOID ifMauJabberState_OID = new AgentXOID(OID1);


    public IfMauJabberTrap(IfMauEntry ifMauEntry) {
        AgentXOID oid;
        AgentXVarBind varBind;

        // add the snmpTrapOID object
        varBindList.addElement(snmpTrapOID_VarBind);

        // add the ifMauJabberState columnar object
        oid = ifMauJabberState_OID;
        oid.appendImplied(ifMauEntry.getInstance());
        varBind = new AgentXVarBind(oid,
                                    AgentXVarBind.INTEGER,
                                    ifMauEntry.get_ifMauJabberState());
        varBindList.addElement(varBind);
    }

    public Vector getVarBindList() {
        return varBindList;
    }

}

