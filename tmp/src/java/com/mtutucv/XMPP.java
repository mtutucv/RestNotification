package com.mtutucv;

import static com.mtutucv.Library.getConfig;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.jivesoftware.smack.XMPPException;


/**
 *
 * @author Mário Monteiro - 77910
 */
public class XMPP {
    
 private static XmppManager getManager(){
    try
    {  XmppManager xmppManager = new XmppManager(getConfig("Aplication_XMPP"),Integer.parseInt(getConfig("Port_XMPP")), getConfig("Server_XMPP"));

        xmppManager.init();
        xmppManager.performLogin(getConfig("USER_XMPP"), getConfig("KEY_XMPP"));
        xmppManager.setStatus(true, "Hello everyone");
        
        return xmppManager;
    }catch(XMPPException erro){
         Logger.getLogger(XMPP.class.getName()).log(Level.SEVERE, null, erro);
    }
    return null;
 }   
 
 public static boolean sendXMPP(String xmppTo, String conteudo){
    
    try
    { 
        XmppManager  xmppManager = getManager();
        String buddyJID = xmppTo;
        String buddyName = xmppTo;
        xmppManager.createEntry(buddyJID, buddyName);
        xmppManager.sendMessage(conteudo, xmppTo);
        return true;
    }catch(Exception erro){
        Logger.getLogger(XMPP.class.getName()).log(Level.SEVERE, null, erro);
    }
     return false;
 }
}
