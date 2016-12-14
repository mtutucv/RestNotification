/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;

import java.util.regex.Pattern;
import javax.ws.rs.Consumes;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
//import javax.ws.rs.QueryParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 *
 * @author Mário Monteiro - 77910
 */

@Path("Notify")
public class SendNotify {
    @Context
    private UriInfo context;
    /**
     * Retrieves representation of an instance of com.mtutucv.SendNotify
     * @param input
     * @return an instance of java.lang.String
     */
    
    @POST
    @Consumes({MediaType.APPLICATION_JSON})
    @Produces({MediaType.APPLICATION_JSON})
    @Path("NotifyByAll")
    public String notifyByAll(InputJSON input) {
        int tipo = Integer.parseInt(input.getTipo());
        String contato = input.getContato();
        String conteudo = Library.decodifyUtf8(input.getConteudo());
        
        if(tipo != -1 && contato != null && conteudo != null)
        {
         switch(tipo)
         {
            case 1://Envio de E-mail 
            {     
                
                if(Email.sendMail(contato, conteudo))
                    return "200";
                else
                    return "400";
            }
            case 2://Envio de SMS
            {               
                contato = contato.replace(Pattern.quote("+"),"00").replaceAll("[^\\d]", "");
                System.out.println("Mobile Numero: "+contato);
                if(contato.length() == 14)
                    if(SMS.sendSMS(contato, conteudo))
                         return "200";
               
                      return "400";
            }
            case 3://Envio de XMPP
            {
                boolean resposta = XMPP.sendXMPP(contato, conteudo);
               if(resposta)
                   return "200";
               else
                   return "400";
               
            }
            case 4://Envio de Push Notification
            {
              if(FirebaseNotification.sendNotify(contato, conteudo))
                   return "200";
               else
                   return "400";
               
            }
            case 0://Envio para todos
            {
                return "400";
            }
            default:
            {
                return "400";
            }
        }
        
        }
        return "400";
    }
    
    
}
