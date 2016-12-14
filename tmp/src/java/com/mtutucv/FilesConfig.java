/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;

import java.io.File;

/**
 *
 * @author Admin
 */
public class FilesConfig {
    private static File file = new File(System.getProperty("config.location"), "");
    public static String dir = file.getAbsolutePath().replace("\\", "/");
    public static   String configJSON = dir+"/config.json";
    public static String userInfoJSON = dir+"/UserInfo.json";
    public static  String publicidadeJSON = dir+"/Publicidade.json";
    public static  String  estatisticaJSON = dir+"/Estatistica.json";
    public static  String  empresasJSON = dir+"/EmpresaInfo.json";
}
