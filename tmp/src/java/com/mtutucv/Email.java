/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;

import static com.mtutucv.Library.getConfig;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 *
 * @author Mário Monteiro - 77910
 */
public class Email {
 
 /**
  * Este metodo permite criar a sessão de envio de um e-mail
  * @param parameters - envio de parametros como servidor SMTP, Utilizador e Password
  * @return - devolve a sessão criada
  */   
 private static Session createSession(){
     try {
            //Get the session object  
            Properties props = new Properties();  
            props.put("mail.smtp.host",getConfig("host"));  
            props.put("mail.smtp.auth", "true");  

            Session session = Session.getDefaultInstance(props,  
             new javax.mail.Authenticator() {  
               @Override
               protected PasswordAuthentication getPasswordAuthentication() {  
             return new PasswordAuthentication(getConfig("user"),getConfig("password"));  
               }  
             }); 
            return session;
     } catch (Exception e) {
         Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
     }
   return null;
 }  
 
 /***
  * Metodo que permite o envio do E-mail para um determinado contacto fornecido
  * @param to - contacto pelo qual se pretende enviar a mensagem de E-mail
  * @param subject - Titulo da Mensagem
  * @param text - Texto da Mensagem
  * @return 
  */
 public static boolean sendMail(String to,String text){

     //Compose the message  
    try { 
            //Criar Sessão
            Session session = createSession();
            if(session != null)
            {
                MimeMessage message = new MimeMessage(session);  
                message.setFrom(new InternetAddress(getConfig("user")));  
                message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));  
                message.setSubject(getConfig("subject"));  
                message.setText(text);  
               //send the message  
                Transport.send(message);  

                return true;  
            }
         } catch (MessagingException e) {
            Logger.getLogger(Email.class.getName()).log(Level.SEVERE, null, e);
         }
     
     return false;
 }      
}
