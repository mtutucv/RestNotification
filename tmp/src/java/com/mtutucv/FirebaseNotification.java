/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;

import static com.mtutucv.Library.getConfig;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;

/**
 *
 * @author Mário Monteiro - 77910
 */
public class FirebaseNotification {
    
    private static HttpURLConnection connection(String serverKey){
    try {
            HttpURLConnection httpcon = (HttpURLConnection) ((new URL(getConfig("UrlFirebase")).openConnection()));
            httpcon.setDoOutput(true);
            httpcon.setRequestProperty("Content-Type", "application/json");
            httpcon.setRequestProperty("Authorization", "key="+serverKey);
            httpcon.setRequestMethod("POST");
            httpcon.connect();
            return httpcon;
        } catch (IOException e) {
            Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
        }
        return null;
    }
    
    public static boolean sendNotify(String to, String msg){
    try {
           HttpURLConnection httpcon = connection(getConfig("serverKeyFirebase"));
          
           if(httpcon == null)
                return false;
//           String value ="{\"notification\":{\"title\":\"";
//           value +=getConfig("titlePushNotification")+"\",";
//           value +="\"text\": \"";
//           value +=URLEncoder.encode(msg,"utf-8")+"\",";
//           value +="\"click_action\": \"com.example.emanuel.airportpub_Target_Notification\",";
//           value +="\"sound\": \"default\"}, \"to\": \"";
//           value +=to+"\"}";
           
           String value ="{" +
                "\"to\": \""+to+"\"," +
                "\"notification\":{" +
                "\"title\":\""+getConfig("titlePushNotification")+"\"," +
                "\"body\":\""+Library.codifUtf8(msg)+"\"," +
                "\"icon\":\"ic_notification\"" +
                "\"click_action\":\"com.example.emanuel.airportpub_Target_Notification\"" +
                "\"sound\":\"default\"" +
                "}," +
                "\"data\":{" +
                "\"someData\":\""+Library.codifUtf8(msg)+"\"," +
                "}" +
                "}";
        
        byte [] outputBytes = value.getBytes("UTF-8");
        OutputStream os = httpcon.getOutputStream();
        os.write(outputBytes);
        os.close();

        // Reading response
        
        InputStream input = httpcon.getInputStream();
        JsonObject jObject;
        JsonReader jsonReader;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(input))) {
            for (String line; (line = reader.readLine()) != null;) 
            {
                    jsonReader = Json.createReader(new StringReader(line));
                    jObject = jsonReader.readObject();
                    if(jObject.get("success").toString().equals("1"))
                        return true;
            }
        }

        return false;
    } catch (IOException e) {
        Logger.getLogger(FirebaseNotification.class.getName()).log(Level.SEVERE, null, e);
    }   catch (Exception ex) {
            Logger.getLogger(FirebaseNotification.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }
}
