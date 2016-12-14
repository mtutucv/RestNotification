/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;

import static com.mtutucv.Library.toJSONObject;
import java.io.FileReader;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/**
 *
 * @author Admin
 */
public class TEstar {
    public static void main(String args[]){
        try 
    {
        
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(FilesConfig.configJSON));
        JSONObject aux1 ;
        
        aux1 = toJSONObject(obj);
        
        System.out.println("OUT"+aux1);
        
    } 
    catch (IOException | ParseException e)
    {
    Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    }
}
