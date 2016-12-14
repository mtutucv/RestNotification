
package com.mtutucv;

import java.awt.image.BufferedImage;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import javax.imageio.ImageIO;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.multipart.FilePart;
import org.apache.commons.httpclient.methods.multipart.MultipartRequestEntity;
import org.apache.commons.httpclient.methods.multipart.Part;
import org.apache.commons.httpclient.methods.multipart.StringPart;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import com.basho.riak.client.api.RiakClient;
import com.basho.riak.client.api.commands.kv.FetchValue;
import com.basho.riak.client.api.commands.kv.StoreValue;
import com.basho.riak.client.core.RiakCluster;
import com.basho.riak.client.core.RiakNode;
import com.basho.riak.client.core.query.Location;
import com.basho.riak.client.core.query.Namespace;
import com.basho.riak.client.core.query.RiakObject;
import com.basho.riak.client.core.util.BinaryValue;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.util.concurrent.ExecutionException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.io.IOUtils;

/**
* @author Mário Monteiro - 77910
*/
public class Library 
{ 
    
/***
* Obter a configuração para um determinado Item no fichiro JSON de configuração
* @param item - Chave de configuração no ficheiro JSON
* @return 
*/
    
public static String getConfig(String item)
{
    String itemSend = null;
    try 
    {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(FilesConfig.configJSON));
        if(obj == null)
            return null;
        JSONObject jsonObject = toJSONObject(obj);
        if(jsonObject.get(item) != null)
          itemSend = jsonObject.get(item).toString();
    } catch (IOException | ParseException e) 
    {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return itemSend;
}
    
/***
* Carregar a informação num determinado ficheiro fisico para a memoria num formato objeto JSON
* @param file - ficheiro JSON para obter a informação
* @return 
*/
public static JSONObject getObjFromFile(String file)
{
    try 
    {
         JSONParser parser = new JSONParser();
         Object obj = parser.parse(new FileReader(file));
         if(obj != null)
            return toJSONObject(obj);
    } catch (IOException | ParseException e) {
       Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
   return null;
}
    
/***
* Contabilizar as publicidades pendentes num determinado ficheiro JSON 
* @param file - ficheiro JSON com as publicidade Pendentes
* @return 
*/
public static int countPublicidadePendentes(String file){
try 
{
    JSONParser parser = new JSONParser();
    Object obj = parser.parse(new FileReader(file));
    if (obj == null)
     return 0;
    int cont=0;
    for (Object key : toJSONObject(obj).keySet()) 
    {
        cont++;
    }
        return cont;
    } 
    catch (IOException | ParseException e)
    {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return 0;
}
/***
* Obter alista de Empresas de acordo com o utilizador responsavel pela empresa
* @param file - Ficheiro da Lista de Empresas
* @param idUSer - utilizador Responsavel
* @return 
*/
public static JSONObject getEmpresasFromUSer(String file,String idUSer)
{
    try 
    {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(file));
        JSONObject aux1,aux2,aux3 = new JSONObject();
        if (obj == null)
         return null;
        aux1 = toJSONObject(obj);
        for (Object key : aux1.keySet()) 
        {
            aux2 = (JSONObject)  aux1.get(key);
            if(aux2 != null && aux2.get("user").toString().equals(idUSer))
                aux3.put(key, aux2);
        }
        return aux3;
    } 
    catch (IOException | ParseException e)
    {
    Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return null;
}
   
/***
* Calcular e verificar se o utilizador possui credito para enviar publicidade
* @param file - ficheiro do credito
* @param idUSer - utilizador 
* @param nomeEmpresa - Empresa a fazer publicidade
     * @param custo
 * @param pagar - caso for pagamento ou reposicao
* @return 
*/
public static boolean calcularSaldoCredito(String file,String idUSer, String nomeEmpresa, String custo, boolean pagar)
{
    try 
    {
        int preco = Integer.parseInt(custo);

         JSONParser parser = new JSONParser();
         Object obj = parser.parse(new FileReader(file));
         JSONObject aux1,aux2;
         if (obj == null)
               return false;
         aux1 = toJSONObject(obj);
         String idEmpresa = getIdEmpresaByName(FilesConfig.empresasJSON,nomeEmpresa);
         if(idEmpresa != null)
         {
            aux2 = (JSONObject)  aux1.get(idEmpresa);
               if(aux2 != null)
               {

                   int saldo = Integer.parseInt(aux2.get("Saldo") != null ? aux2.get("Saldo").toString() : "0") ;
                   int credito = Integer.parseInt(aux2.get("credito") != null ? aux2.get("credito").toString() : "0") ;
                   if(pagar)
                   {
                        if(saldo != 0 && saldo > preco)
                        {
                            aux2.put("Saldo", saldo - preco);
                            aux2.put("creditoSaldo", "saldo");
                            return true;
                        }else if(credito != 0 && credito > preco)
                        {
                            aux2.put("credito", credito - preco);
                            aux2.put("creditoSaldo", "credito");
                            return true;
                        }
                   }
                   else
                   {
                       if(aux2.get("creditoSaldo").equals("saldo"))
                       {
                           aux2.put("Saldo", saldo + preco);
                       }
                       else
                       {
                           aux2.put("credito", credito + preco);
                       }
                   }
               }
         }
    } 
    catch (IOException | ParseException e)
    {
       Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return false;
}
/***
* Obter o ID da empresa atraves do seu nome
* @param file - ficheiro com as empresas
* @param nomeEmpresa - Nome da empresa a pesquisar
* @return 
*/
public static String getIdEmpresaByName(String file, String nomeEmpresa)
{
   try 
   {
       
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(file));
        JSONObject jsonObject = toJSONObject(obj);
        JSONObject jsonObject1;

        for (Object key : jsonObject.keySet()) 
        {
             jsonObject1 = toJSONObject(jsonObject.get(key.toString()));
             if(jsonObject1.get("nome") != null)
                 if(jsonObject1.get("nome").toString().contains(decodifyUtf8(nomeEmpresa)))
                     return key.toString();
        }

   } catch (IOException | ParseException e) {
       Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
   }
   return null;
}
   
/***
* Contabilizar as publicidades pendentes num determinado ficheiro JSON  da ultima semana
* @param file - ficheiro JSON para obter a informaçºao
* @return 
*/
public static int countPublicidadePendentesLastWeek(String file)
{
    try 
    {
         JSONParser parser = new JSONParser();
         Object obj = parser.parse(new FileReader(file));
         if(obj == null)
             return 0;
         JSONObject jsonObject = toJSONObject(obj);
         JSONObject jsonObject1 ;
         int cont=0;

         String dataActual = getCurrentDate();
         String dataSemanaPassada = getLastWeek(dataActual);

         for (Object key : jsonObject.keySet()) 
         {
             jsonObject1 = toJSONObject(jsonObject.get(key.toString()));
             if(chekDate(dataSemanaPassada, jsonObject1.get("data").toString()))
                cont++;
         }
         return cont;
    } 
    catch (IOException | ParseException e)
    {
       Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return 0;
}
    
/***
* Verificar se uma data esta depois de uma determinada data fornecida
* @param dataLastWeek - data da semana passada
* @param dataValidade - data para validar
* @return 
*/
public static boolean chekDate(String dataLastWeek, String dataValidade)
{
   try 
   {

       DateFormat format = new SimpleDateFormat("dd-MM-yyyy");
        Date date2 = format.parse(dataLastWeek.replace("/", "-"));
        Date date3 = format.parse(dataValidade.replace("/", "-"));

        return date3.after(date2);

   } catch (java.text.ParseException e) {
       Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
   }

   return false;
} 
   
/***
* Obeter a data actual e formata-la em formato (dd/mm/yyyy)
* @return 
*/
public static String getCurrentDate()
{
   String dataActual = LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
   String [] aux = dataActual.split("-");
   dataActual = aux[2] +"/" + aux[1] + "/" + aux[0];
   return dataActual;
}
   
/***
* Obter a data da semana passada ou sejá sete dias antes da data actual
* @param data - data da semana passada
* @return 
*/
public static String getLastWeek(String data)
{
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DAY_OF_MONTH, -7);
    String [] aux =  cal.getTime().toString().split(" ");
    int mes = cal.get(Calendar.MONTH) + 1;

    if(mes < 10)
        return aux[2] + "/0" + mes + "/" +aux[5];
    else
        return aux[2] + "/" + mes + "/" +aux[5];

}
    
/***
 * Obter todas as publicidades de uma determinada empresa de forma ser apresentada a mesma
 * @param file - Ficheiro JSON com as publicidades
 * @param user - utilizador responsavel pela publicidade
 * @return 
 */
public static JSONObject getPublicidadeUser(String file,String user)
{
    try 
    {
         JSONObject aux = new JSONObject();
         JSONParser parser = new JSONParser();
         Object obj = parser.parse(new FileReader(file));
         if(obj == null)
             return null;
         JSONObject jsonObject = toJSONObject(obj);
         JSONObject jsonObject2,jsonObject3;

         JSONObject obEmpresas = getEmpresasFromUSer(FilesConfig.empresasJSON, user);
         if(obEmpresas != null)
         {
            for (Object keyEmp : obEmpresas.keySet()) 
            {
                jsonObject3 = toJSONObject(obEmpresas.get(keyEmp.toString()));
                if(jsonObject3 != null)
                {
                    String empresa  = jsonObject3.get("nome") != null ? decodifyUtf8(jsonObject3.get("nome").toString()) : null;
                    if(empresa != null)
                    {
                        for (Object key : jsonObject.keySet()) 
                       {
                           jsonObject2 = toJSONObject(jsonObject.get(key.toString()));
                           if(decodifyUtf8(jsonObject2.get("Empresas_Nome").toString()).equals(empresa))
                               aux.put(key,jsonObject2);
                       }
                    }
                }
            }
         }
         return aux;
    } catch (IOException | ParseException e) {
       Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return null;
}
    
/***
 * Obter a informação de um determinado utilizador
 * @param item - utilizador pelo qual pretende obter a informação
 * @return 
 */
public static JSONObject getUserInfo(String item)
{
    try 
    {
        JSONParser parser = new JSONParser();
        Object obj = parser.parse(new FileReader(FilesConfig.userInfoJSON));
        if(obj == null)
         return null;
        JSONObject jsonObject = toJSONObject(obj);
        if(jsonObject.get(item) != null)
        return toJSONObject(jsonObject.get(item));
    } catch (IOException | ParseException e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
   return null;
}
    
/***
* Obter uma lista com todas permissões definidas no ficheiro JSON
* @param obj - Objeto com os dados de utilizador
* @return 
*/
public static List<String> getAllPerfil(JSONObject obj)
{
    List<String> list;
    try 
    {
        list = new ArrayList<>();
        if(obj != null)
        {
        for (Object key : obj.keySet()) 
        {
            String keyStr = (String)key;
            JSONObject keyvalue = toJSONObject(obj.get(keyStr));
            list.add(keyvalue.get("perfil").toString());
        }    
        //Eliminar Duplicados
        Set<String> hs = new HashSet<>();
        hs.addAll(list);
        list.clear();
        list.addAll(hs);
          return list;
        }
    } catch (Exception e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return null;
}
    
/***
* Metodo para garantir que seja feita a conexão ao API via HTTPS, permite descaregar o certificado e confiar no Servidor
*/
public  static  void trustServer()
{

    TrustManager[] trustAllCerts = new TrustManager[]{new X509TrustManager(){
    @Override
    public X509Certificate[] getAcceptedIssuers(){return null;}
    @Override
    public void checkClientTrusted(X509Certificate[] certs, String authType){}
    @Override
    public void checkServerTrusted(X509Certificate[] certs, String authType){}
    }};

    // Install the all-trusting trust manager
    try {
        SSLContext sc = SSLContext.getInstance("TLS");
        sc.init(null, trustAllCerts, new SecureRandom());
        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
    } catch (KeyManagementException | NoSuchAlgorithmException e) {
      Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
}
    
/***
 * Verificar se a sessão esta estabelecida
 * @param session - objeto da sessão
 * @return 
 */
public static boolean checkSession(Object session)
{
    return session != null;
}
    
/****
* Recebe a informação sobre a publicidade que o utilizador pretende guardar e adiciona ao Ficheiro JSON que armazena todas as publicidades
* @param dados - informação sobre a publicidade
* @param id
* @return 
*/
public static boolean savePublicidade(String [] dados, String id)
{
    try 
    {
        JSONObject objEstatistica = getObjFromFile(FilesConfig.publicidadeJSON);
        if(objEstatistica != null && dados.length == 13)
        {
            JSONObject aux = new JSONObject();
              aux.put("Publicidade_URL","asdds");
              aux.put("Empresa_Descricao",dados[10]);
              aux.put("Endereco_MoradaCompleta","adadad");
              aux.put("Videos_Nome","ddas");
              aux.put("Videos_Descricao","adada");
              aux.put("Videos_VideoFile",dados[1]);
              aux.put("Videos_Extensao","dasd");
              aux.put("Imagems_Nome",dados[12]);
              aux.put("Imagems_Descricao","sfdsdf");
              aux.put("Imagems_Extensao","fdsf");
              aux.put("Empresas_Nome",dados[2]);
              aux.put("Genero_Nome",dados[6]);
              aux.put("FaixaEtaria_Nome",dados[7]);
              aux.put("FaixaEtaria_From",dados[8]);
              aux.put("FaixaEtaria_To",dados[9]);
              aux.put("FaixaEtaria_Descricao",dados[7]);
              aux.put("HashTag_Tag",dados[11]);
              aux.put("TipoPublicidade_Nome","asdd");
              aux.put("TipoPublicidade_Descricao",dados[5]);
              aux.put("Publicidade_DescricaoTexto",dados[4]);
              aux.put("Publicidade_Titulo",dados[3]);
              aux.put("Imagems_ImageFile",dados[0]);
              aux.put("Imagems_Tamanho",10);
              aux.put("Videos_Tamanho",15);   

              aux.put("data", getCurrentDate());
              if(id != null && !id.equals("") && !id.isEmpty()) 
                objEstatistica.put(id, aux);
              else
                objEstatistica.put(getLastKey(FilesConfig.publicidadeJSON), aux);

              if(com.mtutucv.Library.SaveJSONToFile(objEstatistica,FilesConfig.publicidadeJSON))
                    return true;
        }
    } catch (Exception e) 
    {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return false;
}
    
public static boolean saveEmpresa(String [] dados, String id)
{
    try 
    {
        JSONObject objEmpresa = getObjFromFile(FilesConfig.empresasJSON);
        if(objEmpresa != null && dados.length == 7)
        {
            for(int i=2; i < 4; i++)
            {
                if(dados[i].contains("$"))
                    dados[i] = dados[i].split("$")[0];
                else if(dados[2].contains("\\."))
                    dados[i] = dados[i].split("\\.")[0];
            }
            JSONObject aux = new JSONObject();
            aux.put("nome",dados[0]);
            aux.put("morada",codifUtf8(dados[1]));
            aux.put("Saldo",Integer.parseInt(dados[2]));
            aux.put("credito",Integer.parseInt(dados[3]));
            aux.put("user",codifUtf8(dados[5]));
            aux.put("logoTipo",codifUtf8(dados[6]));
            aux.put("url",codifUtf8(dados[4]));  
            aux.put("creditoSaldo", "saldo");

            if(id != null && !id.equals("") && !id.isEmpty()) 
                objEmpresa.put(id, aux);
            else
                objEmpresa.put(getLastKey(FilesConfig.empresasJSON), aux);

            if(com.mtutucv.Library.SaveJSONToFile(objEmpresa,FilesConfig.empresasJSON))
                return true;
        }
    } catch (NumberFormatException e) {
         Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return false;
}
/***
* Obter a ultima chave do respetivo ficheiro para ser utilizado
* @return 
*/
public static String  getLastKey(String file){

    try 
    {
        JSONObject obj = getObjFromFile(file);
        if(obj == null)
            return "1";
        else
        {
            int maior =0; 
            for (Object key : obj.keySet()) 
                {

                    if(Integer.parseInt(key.toString()) > maior)
                        maior = Integer.parseInt(key.toString());
                }
            return  String.valueOf(maior + 1);
        }
    } catch (NumberFormatException e) {
          Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return null;
}
 
/***
* Verificar se o utilizador a alterar a permissão não é um Admin FIXO no config
 * @param keyAdmin
* @return 
*/  
public static boolean checkIfAminIsInConfig(String keyAdmin)
{
    try 
    {
        JSONObject obj = getObjFromFile(FilesConfig.configJSON);
        
        if(obj == null)
            return false;
        else
        {
            if(obj.get("AppUserIDAdmin").toString().equals(keyAdmin))
                return  true;
        }
    } catch (NumberFormatException e) {
          Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return false;
}
    
/***
* Salvar um objeto JSON num Ficheiro JSON
* @param obj - objeto que pretende salvar
* @param url - ficheiro que pretende armazenar o objeto JSON
* @return 
*/
public static boolean SaveJSONToFile(JSONObject obj,String url)
{
    try 
    {
        FileWriter file = new FileWriter(url);
        file.write(obj.toJSONString());
        file.close();
        return true;
    } catch (IOException e) 
    {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return false;
}
    
/***
* Criar uma imagem apartir do byte recebido
* @param ib - bite da imagem
* @param type - tipo de ficheiro
*/
public static void createImagefromBytes(byte [] ib,String type)
{
    try 
    {
        System.out.println("com.mtutucv.Library.createImagefromBytes()"+Arrays.toString(ib));
        // convert byte array back to BufferedImage
        InputStream in = new ByteArrayInputStream(ib);
        BufferedImage bImageFromConvert = ImageIO.read(in);
        ImageIO.write(bImageFromConvert, type, new File("newImage"+"."+type));
    } 
    catch (IOException e) 
    {
       Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
}
     
/***
* Extrair byte apartir de um ficheiro de imagem fornecido
* @param ImageName - ficheiro de imagem 
* @return 
*/
public static byte[] extractBytes (String ImageName)
{
    try 
    {
        byte[] imageInByte;
        BufferedImage originalImage = ImageIO.read(new File(ImageName));
        // convert BufferedImage to byte array
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(originalImage, getTypeFile(ImageName), baos);
        baos.flush();
        imageInByte = baos.toByteArray();
        baos.close();
        return imageInByte;
    } catch (IOException e) {
    Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return null;
}  

/***
* Extrair byte apartir de um ficheiro de video fornecido
* @param videoUrl - ficheiro de video 
* @return 
*/
public static byte [] extractVideoByte(String videoUrl)
{
    try
    {
        return IOUtils.toByteArray(new FileInputStream(videoUrl));
    }
    catch (IOException e)
    {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return null;
} 
/***
* devolver od dados da Faixa etaria apartir de um numero fornecido para a categoria
* @param faixaEtaria - numero da faixa etaria fornecido apartir do formulario
* @return 
*/
public static String [] dataFaixaEtaria(String faixaEtaria)
{

   if(faixaEtaria.equals("1"))
    {   String [] dados = {"Todos","0","100"};
        return dados;

    }else if(faixaEtaria.equals("2")){

        String [] dados = {"Criança","0","9"};
        return dados;
    }else if(faixaEtaria.equals("3")){
        String [] dados = {"Adolescente","10","17"};
        return dados;
    }else if(faixaEtaria.equals("4")){
         String [] dados = {"Jovem","18","30"};
        return dados;
    }else if(faixaEtaria.equals("5")){
         String [] dados = {"Adulto","31","60"};
        return dados;
    }else if(faixaEtaria.equals("6")){
        String [] dados = {"Idoso","60","100"};
        return dados;
    }
   return null;
}
   
/***
* Ligar a um detrmindao acess point para obter os dados via metodo GET
* @param linkAccessPoint - link fornecido para o acess Point
* @return 
*/
public static JSONObject connectToAcessPointWithGet(String linkAccessPoint)
{
    try 
    {  
        trustServer();
        //Criar a instancia URL para realizar a conexão GET ao getAdvertisements
        URL url = new URL(linkAccessPoint);
        //Relizar a conexão
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");
        if (conn.getResponseCode() != 200) {
                return null;
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(
                (conn.getInputStream())));

        String output;
        while ((output = br.readLine()) != null) {
            JSONParser parser = new JSONParser();
            Object obj = parser.parse(output);
            if(obj == null)
                return null;
            return  toJSONObject(obj);
        }
        conn.disconnect();
    } catch (IOException | ParseException e) {
        Logger.getLogger(Publicidade.class.getName()).log(Level.SEVERE, null, e);
    } 
    return null;
}
  
/***
* Obter a quantidade total de Anuncio num determinado End Point
* @param tokenUSer - Id da conexão do utilizador
* @return 
*/
public static String getTotalAnuncio(String tokenUSer)
{
    try 
    {
        String urlLink = getConfig("urlAnuncio")+ "getTotalAdvertisements/"+getConfig("appID")+"/"+tokenUSer;

        JSONParser parser = new JSONParser();
        JSONObject jsonObject1 = connectToAcessPointWithGet(urlLink);
        if(jsonObject1 == null)
            return "0";
        else{
            if(jsonObject1.get("getTotalAdvertisementsResult") == null)
                return "0";
            if(jsonObject1.get("getTotalAdvertisementsResult").toString().contains("getTotalAdvertisementsResult"))
            {
                Object obj = parser.parse(jsonObject1.get("getTotalAdvertisementsResult").toString());
                JSONObject jsonObject2 = toJSONObject(obj);

                if(jsonObject2.get("getTotalAdvertisementsResult") == null)
                    return "0";
                
                return (jsonObject2.get("getTotalAdvertisementsResult")).toString();
            }
        }      
    } catch (ParseException e) {
          Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    } 
    return "0";
}
   
/***
* Obter a quantidade total de Anuncio num determinado End Point durante a ultima semana
* @param tokenUSer - Id da conexão do utilizador
* @return 
*/
public static String getTotalAnuncioSemanal(String tokenUSer)
{

    try 
    {
        String urlLink = getConfig("urlAnuncio")+ "getTotalAdvertisementsLastWeek/"+getConfig("appID")+"/"+tokenUSer;
        JSONParser parser = new JSONParser();
        JSONObject jsonObject1 = connectToAcessPointWithGet(urlLink);
        if(jsonObject1 == null)
            return "0";
        else
        {
            if(jsonObject1.get("getTotalAdvertisementsLastWeekResult").toString().contains("getTotalAdvertisementsLastWeekResult"))
            {
                JSONObject jsonObject2 = toJSONObject(parser.parse(jsonObject1.get("getTotalAdvertisementsLastWeekResult").toString()));
                return (jsonObject2.get("getTotalAdvertisementsLastWeekResult")).toString();
            }
        }
    } catch (ParseException e) 
    {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    } 
    return "0";
}
   
/***
* obter a lista dos 5 maiores empresas a realizar a publicidade no sistema
* @param tokenUSer - Id da conexão do utilizador
* @param top - Array para devolver os nomes das empresas
* @param percentagem - array para devolver a quantidade de publicidade realizada por cada empresa
* @return 
*/
public static boolean getTop5Anunciantes(String tokenUSer,String [] top, int [] percentagem)
{
    try 
    {
        String urlLink = getConfig("urlAnuncio")+ "getTopFiveAdvertisers/"+getConfig("appID")+"/"+tokenUSer;
        JSONParser parser = new JSONParser();
        JSONObject jsonObject1 = connectToAcessPointWithGet(urlLink);
        
        if(jsonObject1 == null || jsonObject1.get("getTopFiveAdvertisersResult") == null)
            return false;
        else
        {
                if(!jsonObject1.get("getTopFiveAdvertisersResult").toString().contains("AccessToken"))
                {
                    Object obj = parser.parse(jsonObject1.get("getTopFiveAdvertisersResult").toString());
                    JSONObject jsonObject2 = toJSONObject(obj);
                    if(jsonObject2 != null)
                    {
                        JSONArray jsonarray = toJSONArray(jsonObject2.get("getTopFiveAdvertisersResult"));
                        if(jsonarray != null && jsonarray.size() <= top.length)
                        {
                            for(int i=0; i< jsonarray.size(); i++)
                            {
                                top[i] = decodifyUtf8(toJSONObject(jsonarray.get(i)).get("Nome") != null ? toJSONObject(jsonarray.get(i)).get("Nome").toString() : "");
                                percentagem [i] = Integer.parseInt(toJSONObject(jsonarray.get(i)).get("CountEmpresas") != null ? toJSONObject(jsonarray.get(i)).get("CountEmpresas").toString() : "0");
                            }
                            ordenarTop5(top,percentagem);
                            return true;
                        }
                    }
                }
        }
    } catch (NumberFormatException | ParseException  e) {
          Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    } 
    return true;
}
/***
* Ordenar os dois Arrays da lista do Top5 para que essa possa ser apresentada de forma ordenada
* @param top - Array para devolver os nomes das empresas
* @param percentagem - array para devolver a quantidade de publicidade realizada por cada empresa
*/
public static void ordenarTop5(String [] top, int [] percentagem)
{
   int maior;
   String topMaior;
   for(int i=0; i<top.length; i++)
   {
       maior = percentagem[i];
       topMaior = top[i];
       for(int y=i+1; y<top.length; y++)
        {
            if(percentagem[y] > maior)
            {
                maior=percentagem[y];
                topMaior = top[y];

                percentagem[y]=percentagem[i];
                top[y]=top[i];
                percentagem[i]=maior;
                top[i]=topMaior;
            }
        }
   }
}
/***
* obter as classes para ser adicionadas na dashboard de forma a representar se houve queda ou crescimento de um determinado campo estatistico
* @param valores - quatidade para cada item estatistico
* @param classValores - classa para mostrar se houve crecimento ou não (Vermelho para queda e Verde para crescimento ou estabilidade)
* @param upDownValores - class para mostrar a seta para baixo ou para cima do crescimento das estatisticas
* @return 
*/
public static  String [][] getClassUpDownValoresEstatisitica(int [] valores, String [] classValores, String  [] upDownValores)
{
    boolean semafaro=false;
    JSONObject objEstatistica = getObjFromFile(FilesConfig.estatisticaJSON);
    if(objEstatistica != null)
    {
        for(int i=0; i < valores.length; i++)
        {
            if(Integer.parseInt(objEstatistica.get("Estat"+i).toString()) <= valores[i])
            {
                classValores[i]="green";
                upDownValores[i]="fa-sort-asc";
                semafaro=true;
            }else{
                classValores[i]="red";
                upDownValores[i]="fa-sort-desc";
            }
            objEstatistica.put("Estat"+i, valores[i]);
        }
        //Save to disk
        if(semafaro)
            SaveJSONToFile(objEstatistica,FilesConfig.estatisticaJSON);

        String [][] dados = {classValores,upDownValores};
        return dados;
    }
   return null;
}
   
/***
* Devolver um valor Double com duas casas Decimais
* @param d valor em Double
* @return 
*/
public static String roud2Decimal(double d)
{
    DecimalFormat df = new DecimalFormat("#.##");
    return df.format(d);
}
/***
* Codificar String UTF-8
* @param texto - texto para descodificar
* @return 
*/ 
public static String codifUtf8(String texto){
   try {
       return URLEncoder.encode(texto,"utf-8");
   } catch (UnsupportedEncodingException e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
   }   
   return null;
}
/***
* Descodificar String UTF-8
* @param texto - texto codificado em UTF-8
* @return 
*/
public static String decodifyUtf8(String texto){
   try 
   {
       return URLDecoder.decode(texto,"utf-8");
   } catch (UnsupportedEncodingException e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
   }   
   return null;
}
   
  /***
   * Enviar dados atraves do POST para um determinado servidor
   * @param urlString
   * @param filePath
   * @return 
   */         
public static int postData(String urlString, String filePath) 
{
    try 
    {
        File f = new File(filePath);
        PostMethod postMessage = new PostMethod(urlString);
        Part [] parts = {new StringPart("param_name", "value"), new FilePart(f.getName(), f)};
        postMessage.setRequestEntity(new MultipartRequestEntity(parts, postMessage.getParams()));
        HttpClient client = new HttpClient();
        return client.executeMethod(postMessage);

    } catch (IOException e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    } 
    return 400;
}     
  
/***
* Enviar um ficheiro para o servidor Riak
* @param fileName - Nome do Ficheiro
* @param type - Tipo do Ficheiro
* @param urlFile - pasta onde se encontra o ficheiro
* @param imagem - imagem ou video
* @return 
*/
public static boolean uploadFileToServerRiak(String fileName, String type, String urlFile, boolean imagem)
{
    try 
    {

        byte[] buffer = extractBytes(urlFile);
        String typeContent = "image/"+type;
        String nameSpa = "images";
        if(!imagem)
        {
            typeContent = "video/"+type;
            nameSpa = "videos";
        }
        // First, we'll create a basic object storing a movie quote
        RiakObject quoteObject = new RiakObject()
                // We tell Riak that we're storing plaintext, not JSON, HTML, etc.
                .setContentType(typeContent)
                        // Objects are ultimately stored as binaries
                .setValue(BinaryValue.create(buffer));

        // In the new Java client, instead of buckets you interact with Namespace
        // objects, which consist of a bucket AND a bucket type; if you don't
        // supply a bucket type, "default" is used; the Namespace below will set
        // only a bucket, without supplying a bucket type
        Namespace quotesBucket = new Namespace(nameSpa);

        // With our Namespace object in hand, we can create a Location object,
        // which allows us to pass in a key as well
        Location quoteObjectLocation = new Location(quotesBucket, fileName);

        // With our RiakObject in hand, we can create a StoreValue operation
        StoreValue storeOp = new StoreValue.Builder(quoteObject)
                .withLocation(quoteObjectLocation)
                .build();
        //System.out.println("StoreValue operation created");

        // And now we can use our setUpCluster() function to create a cluster
        // object which we can then use to create a client object and then
        // execute our storage operation
        RiakCluster cluster = setUpCluster();
        RiakClient client = new RiakClient(cluster);
        //System.out.println("Client object successfully created");

        StoreValue.Response storeOpResp = client.execute(storeOp);
        //System.out.println("Response riak:" + storeOpResp);

        // Now we can verify that the object has been stored properly by
        // creating and executing a FetchValue operation
        FetchValue fetchOp = new FetchValue.Builder(quoteObjectLocation)
                .build();
        RiakObject fetchedObject = client.execute(fetchOp).getValue(RiakObject.class);
        assert(fetchedObject.getValue().equals(quoteObject.getValue()));
        //System.out.println("Success! The object we created and the object we fetched have the same value");
        client.shutdown();
        //cluster.shutdown();
        //System.exit(0);
        return true;
    } catch (InterruptedException | UnknownHostException | ExecutionException e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    } 
     return false;   
}

/****
* This will create a client object that we can use to interact with Riak
* @return
* @throws UnknownHostException 
*/ 
private static RiakCluster setUpCluster() throws UnknownHostException 
{
    RiakNode node = new RiakNode.Builder()
            .withRemoteAddress(getConfig("RiakUrlServer"))
            .withRemotePort(Integer.parseInt(getConfig("RiakPort")))
            .withConnectionTimeout(5)
            .build();
    // This cluster object takes our one node as an argument
    RiakCluster cluster = new RiakCluster.Builder(node)
            .build();
    // The cluster must be started to work, otherwise you will see errors
    cluster.start();
    return cluster;
}

/***
 * Obter o tipo de ficheiro
 * @param file
 * @return 
 */    
public static String getTypeFile(String file){
        return file.replace(".",",").split(",")[1] ;
}

/***
 *  Converter objecto do JSONObject
 * @param data
 * @return 
 */
public static JSONObject toJSONObject(Object data){
    return (JSONObject) data;
}

/***
 * Converter objet to JSONArray
 * @param data
 * @return 
 */
public static JSONArray toJSONArray(Object data)
{
   return (JSONArray) data;
}
    
 /***
  * Eliminar conteudo do ficheiro atraves de um ID
  * @param id
  * @param File
  * @return 
  */   
 public static boolean elmininarDados(String id,String File)
 {
    JSONObject objAnuncioEliminar = getObjFromFile(File);
    if(objAnuncioEliminar != null && id != null && !id.isEmpty())
    {
        objAnuncioEliminar.remove(id);
        com.mtutucv.Library.SaveJSONToFile(objAnuncioEliminar,File);
        return true;
    }
     return false;
 }
 
 /***
  * Atualizar perfil so utilizador
  * @param id
  * @param newPerfil
  * @return 
  */
public static boolean updatePerfil(String id,String newPerfil)
{
    JSONObject objUser = getObjFromFile(FilesConfig.userInfoJSON);
    if(objUser != null)
    {
        boolean semafaro=false;
        JSONObject dados = new JSONObject();
        for (Object key : objUser.keySet())
        {
            String keyStr = (String)key;
          
            JSONObject aux = (JSONObject) objUser.get(keyStr);
            if(key != null && key.equals(id))
            { 
                    aux.put("perfil",newPerfil);
                    dados.put(keyStr,aux);
                    semafaro=true;
            }else
                dados.put(keyStr,aux);
        }
    if(semafaro)//Save to disk
        if(com.mtutucv.Library.SaveJSONToFile(dados,FilesConfig.userInfoJSON))
            return true;
    }
     return false;
 }

/***
 * Obter a quantidade de utilizadores semanais no servidor de autenticação 
 * @param autKey
 * @return 
 */  
public static String obterTotalUtilizadores(String autKey)
{
    try 
    {	
        String [] total= {"0","0","0","0"};
        JSONObject jsonObject1 = Library.connectToAcessPointWithGet(getConfig("UrlUserAPI")+"get-count-users?app_id="+getConfig("appID")+"&access_token="+autKey);
        if(jsonObject1 != null)
        {
            JSONObject jsonObject2 = (JSONObject) jsonObject1.get("_data");
            if(jsonObject2 != null)
            {
                total[0] = jsonObject2.get("total") != null ? jsonObject2.get("total").toString(): "0";
                total[1] = jsonObject2.get("total_female") != null ? jsonObject2.get("total_female").toString(): "0";
                total[2] = jsonObject2.get("total_male") != null ? jsonObject2.get("total_male").toString() : "0";
                total[3] = jsonObject2.get("total_nao_definido")!= null ? jsonObject2.get("total_nao_definido").toString() : "0";

                return total[0]+","+total[1]+","+total[2]+","+total[3]; 
            }
        }
    } catch (Exception e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    } 
    return "0,0,0,0";
}

/***
 * Obter total de utilizadores Semanais no servidor de autenticação
 * @param autKey
 * @return 
 */
public static String obterTotalUtilizadoresSemanal(String autKey)
{
    try 
    {
        String [] total= {"0","0","0","0"};

        JSONObject jsonObject1 = connectToAcessPointWithGet(getConfig("UrlUserAPI")+"get-count-lastweek-users?app_id="+getConfig("appID")+"&access_token="+autKey);
        if(jsonObject1 != null)
        {
            JSONObject jsonObject2 = (JSONObject) jsonObject1.get("_data");
            if(jsonObject2 != null)
            {
                total[0] = jsonObject2.get("total") != null ? jsonObject2.get("total").toString(): "0";
                total[1] = jsonObject2.get("total_female") != null ? jsonObject2.get("total_female").toString(): "0";
                total[2] = jsonObject2.get("total_male") != null ? jsonObject2.get("total_male").toString() : "0";
                total[3] = jsonObject2.get("total_nao_definido")!= null ? jsonObject2.get("total_nao_definido").toString() : "0";

                return total[0]+","+total[1]+","+total[2]+","+total[3]; 
            }
        }
      } catch (Exception e) {
            Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
      }
        return "0,0,0,0";
}

/***
 * Calcular as percentagens de utilizadores semanais
 * @param total
 * @param totalSemanal
 * @param size
 * @return 
 */
public static double [] getPercentagemSemanal(String total, String totalSemanal, int size){
     double [] dados = new double[4];
     for(int i=0;i<dados.length;i++)
        dados[i] = 0;

    if(total != null && totalSemanal != null)
    {
        if(dados.length == size)
        {
            String [] totalArray = total.split(",");
            String [] totalSemanalArray = totalSemanal.split(",");

            for(int i=0;i<dados.length;i++){
                if(Double.parseDouble(totalArray[i]) != 0)
                    dados[i] = Double.parseDouble(totalSemanalArray[i]) * 100 / Double.parseDouble(totalArray[i]);
                else
                    dados[i]=0;
            }
        }
    }
    return dados;
}

/***
 * Obter informação do utilizador no servidor de autenticação 
 * @param acessToken
 * @return 
 */
public  static JSONObject getUserInfoFromServer(String acessToken)
{
        
        try { 
                JSONObject jsonObject1 = connectToAcessPointWithGet(getConfig("URLAutenticacao")+""+getConfig("appID")+"&access_token="+acessToken);
                if(jsonObject1 == null)
                    return null;
                else
                {
                   if(jsonObject1.get("_statusAction") != null) 
                        if(Integer.parseInt(jsonObject1.get("_statusAction").toString()) == 1)  
                        {
                            JSONObject jsonObject2 = (JSONObject) jsonObject1.get("_data");
                            return jsonObject2;
                        }
                }
            } catch (NumberFormatException e) {

                  Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
            }         
        return null;
}

/***
 * Guardar um determinado ficheiro imagem no disco
 * @param imageUrl
 * @param destinationFile
 * @return 
 */
public static boolean saveImage(String imageUrl, String destinationFile)
{
    try 
    {
        URL url = new URL(imageUrl);
        InputStream is = url.openStream();
        OutputStream os = new FileOutputStream(destinationFile);

        byte[] b = new byte[2048];
        int length;

        while ((length = is.read(b)) != -1) {
            os.write(b, 0, length);
        }
        is.close();
        os.close();
        return true;
        
    } catch (IOException e) {
         Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return false;
}

/***
 * Eliminar um Determinado ficheiro no Disco
 * @param urlFile
 * @return 
 */
public static boolean deleteFile(String urlFile){
    try {
            File file = new File(urlFile);
            return file.delete();
    } catch (Exception e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return false;
}

/***
 * Eliminar um Determinado ficheiro no Disco
 * @param urlFile
 * @return 
 */

public static boolean chekConfigFileExist(){
    try {
            File file1 = new File(FilesConfig.configJSON);
            File file2 = new File(FilesConfig.empresasJSON);
            File file3 = new File(FilesConfig.estatisticaJSON);
            File file4 = new File(FilesConfig.publicidadeJSON);
            File file5 = new File(FilesConfig.userInfoJSON);
            return file1.exists() && file2.exists() && file3.exists() && file4.exists() && file5.exists();
    } catch (Exception e) {
        Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
    return false;
}

/***
 * Obter imagem de um servidor como o Riak e devolve-lo em dataFile, para ser apresentado na pagina web
 * @param UrlLink
 * @return 
 */
public static String getImageFromHTTP(String UrlLink){
        try {
                String [] arraAux = UrlLink.split("/");
                String typeFile = arraAux[arraAux.length -1];
                arraAux = typeFile.split("\\.");
                typeFile = arraAux[1];
                
                if(UrlLink.contains("riak"))
                {
                    URL url = new URL(UrlLink);
                    BufferedImage img = ImageIO.read(url);
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    ImageIO.write( img, typeFile, baos );
                    baos.flush();
                    byte[] imageInByteArray = baos.toByteArray();
                    baos.close();
                    return "data:image/"+typeFile+";base64," + javax.xml.bind.DatatypeConverter.printBase64Binary(imageInByteArray);
                }
                return UrlLink;

        } catch (IOException e) {
            Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
        }
        return null;
    }
/***
 * Determinar o que enviar quando receber uma determinada faixa etaria ou sexo
 * @param value
 * @param tipo
 * @return 
 */
public static String getValueFromOption(String value, int tipo)
{
    try {
        switch(tipo)
        {
            case 1 : //Faixa etaria
            {
                if(value.equals("Todos"))
                    value = "1";
                else if(value.equals("Criança"))
                    value = "2";
                else if(value.equals("Adolescente"))
                    value = "3";
                else if(value.equals("Jovem"))
                    value = "4";
                else if(value.equals("Adulto"))
                    value = "5";
                else if(value.equals("Idoso"))
                    value = "6";
                break;
            }
            case 2: // Sexo
            {
                if(value.contains("Ma") || value.contains("ma"))
                    value = "M";
                else if(value.contains("Fe") || value.contains("fe"))
                    value = "F";
                else 
                    value = "U";
                break;
            }
            case 3: // TipoDifusão
            {
                String idTipoDifusao ="";
                if(value.contains("Email"))
                    idTipoDifusao = idTipoDifusao + "1";
                if(value.contains("SMS"))
                    idTipoDifusao = idTipoDifusao + "2";
                if(value.contains("gTalk"))
                    idTipoDifusao = idTipoDifusao + "3";
                if(value.contains("Push"))
                    idTipoDifusao = idTipoDifusao + "4";
                
                value = idTipoDifusao;
                            break;
            }
        }
        return value;
        
    } catch (Exception e) {
         Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);
    }
return null;
}
}