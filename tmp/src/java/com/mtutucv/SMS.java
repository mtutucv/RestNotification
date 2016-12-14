/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;




import static com.mtutucv.Library.getConfig;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

/**
 *
 * @author Mário Monteiro - 77910
 */
public class SMS {

/***
 * 
 * @param smsTo - Contacto para enviar o SMS
 * @param conteudo - Mensagem Publicitario para enviar ao contacto
 * @return - status do envio da mensagem
 */
    
public static boolean sendSMS(String smsTo, String conteudo){
    
    
    String url = getURL(smsTo,conteudo);
    
    if(url == null)
        return false;    
    try
    {  
        
        HttpClient client = new DefaultHttpClient();
        HttpGet request = new HttpGet(url);
        HttpResponse response = client.execute(request);

        BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

        String line;

        StringBuilder resposta = new StringBuilder();
        
        while ((line = rd.readLine()) != null) {
            resposta.append(line);
        } 
        
        DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        InputSource is = new InputSource();
        is.setCharacterStream(new StringReader(resposta.toString()));

        Document doc = db.parse(is);
        String result = doc.getElementsByTagName("errortext").item(0).getTextContent();
        if(result.equals("Success") && result != null)
        return true;
        
    }catch(IOException | IllegalStateException | ParserConfigurationException | DOMException | SAXException Erro){
         Logger.getLogger(SMS.class.getName()).log(Level.SEVERE, null, Erro);
    }   
       return false; 
  }

/***
 * 
 * @param toPhoneNumber - Numero telefone para enviar o SMS
 * @param myMessage - Conteudo da Mensagem a ser enviado
 * @return - url a ser utilizado no processo de envio da mensagem SMS
 */
public static String getURL(String toPhoneNumber, String myMessage) {
    try {
            String url = getConfig("URL_SMS"); 
            url += getConfig("USER_SMS");
            url +="&key=";
            url +=getConfig("KEY_SMS");
            url +="&to=";
            url +=toPhoneNumber;
            url +="&message=";
            url +=Library.codifUtf8(myMessage);
            return url;

    }catch(Exception erro){
         Logger.getLogger(SMS.class.getName()).log(Level.SEVERE, null, erro);
    }
    return null;
  }
}
