/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mtutucv;

import static com.mtutucv.Library.getConfig;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import java.io.IOException;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Mário Monteiro - 77910
 */

public class Publicidade {
    private long idPublicidade;	
    private String titulo;
    private String DescricaoTexto;	
    private String url;
    private String empresa;
    private String tipoPublicidade;	
    private String genero;
    private String imagemFileUrl;
    private String videoFileUrl;
    private String faixaEtariaDescricao;
    private String faixaEtariaFrom;
    private String faixaEtariaTo;
    private String modoDifusaoAnuncio;
    private String Custo;
    
    public Publicidade()
    { 
    }

    public Publicidade(long idPublicidade, String titulo, String DescricaoTexto, String url, String empresa, String tipoPublicidade, String genero, String imagemFileUrl, String videoFileUrl, String faixaEtariaDescricao, String faixaEtariaFrom, String faixaEtariaTo, String modoDifusaoAnuncio, String Custo) {
        this.idPublicidade = idPublicidade;
        this.titulo = titulo;
        this.DescricaoTexto = DescricaoTexto;
        this.url = url;
        this.empresa = empresa;
        this.tipoPublicidade = tipoPublicidade;
        this.genero = genero;
        this.imagemFileUrl = imagemFileUrl;
        this.videoFileUrl = videoFileUrl;
        this.faixaEtariaDescricao = faixaEtariaDescricao;
        this.faixaEtariaFrom = faixaEtariaFrom;
        this.faixaEtariaTo = faixaEtariaTo;
        this.modoDifusaoAnuncio = modoDifusaoAnuncio;
        this.Custo = Custo;
    }

    public String getCusto() {
        return Custo;
    }

    public void setCusto(String Custo) {
        this.Custo = Custo;
    }

    public String getModoDifusaoAnuncio() {
        return modoDifusaoAnuncio;
    }

    public void setModoDifusaoAnuncio(String modoDifusaoAnuncio) {
        this.modoDifusaoAnuncio = modoDifusaoAnuncio;
    }
    
    
    
    public String getFaixaEtariaDescricao() {    
        return faixaEtariaDescricao;
    }

    public void setFaixaEtariaDescricao(String faixaEtariaDescricao) {
        this.faixaEtariaDescricao = faixaEtariaDescricao;
    }

    public String getFaixaEtariaFrom() {
        return faixaEtariaFrom;
    }

    public void setFaixaEtariaFrom(String faixaEtariaFrom) {
        this.faixaEtariaFrom = faixaEtariaFrom;
    }

    public String getFaixaEtariaTo() {
        return faixaEtariaTo;
    }
    
    public void setFaixaEtariaTo(String faixaEtariaTo) {
        this.faixaEtariaTo = faixaEtariaTo;
    }

    public long getIdPublicidade() {
        return idPublicidade;
    }

    public void setIdPublicidade(long idPublicidade) {
        this.idPublicidade = idPublicidade;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescricaoTexto() {
        return DescricaoTexto;
    }

    public void setDescricaoTexto(String DescricaoTexto) {
        this.DescricaoTexto = DescricaoTexto;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getEmpresa() {
        return empresa;
    }

    public void setEmpresa(String empresa) {
        this.empresa = empresa;
    }

    public String getTipoPublicidade() {
        return tipoPublicidade;
    }

    public void setTipoPublicidade(String tipoPublicidade) {
        this.tipoPublicidade = tipoPublicidade;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

    public String getImagemFileUrl() {
        return imagemFileUrl;
    }

    public void setImagemFileUrl(String imagemFileUrl) {
        this.imagemFileUrl = imagemFileUrl;
    }

    public String getVideoFileUrl() {
        return videoFileUrl;
    }

    public void setVideoFileUrl(String videoFileUrl) {
        this.videoFileUrl = videoFileUrl;
    }

    
    public static Publicidade getPublicidade(String id){
        //LInk para abrir o anúncio de acordo com o id enviado
        String link="http://192.168.160.104/WebServicesREST/showAnuncio.jsp?id=";
        
        //Intancia do anuncio a ser devolvido pelo metodo
        Publicidade publ = null;
        
        try {   //Criar o url do acess Point para obter os dados do Anuncio
                String urlLink = getConfig("urlAnuncio")+ "getAdvertisements/"+getConfig("appID")+"/EAAL4528tlFkBAO5mniVP0TANUWx49TpQYZCO7H2OtzsOEoMVoBOJHt7BD4S4ZCKpeWit/0/0/"+id;
		          
                    JSONObject jsonObject1 = Library.connectToAcessPointWithGet(urlLink);
                    
                    if(jsonObject1 != null)
                    {
                        JSONObject jsonObject2 = (JSONObject) jsonObject1.get("getAdvertisementsResult");
                        if(jsonObject2 != null)
                        {
                            JSONArray jsonarray1 = (JSONArray) jsonObject2.get("getAdvertisementsResult");
                            if(jsonarray1 != null && jsonarray1.size() > 0)
                            {
                                JSONObject jsonObject3 = (JSONObject) jsonarray1.get(0);
                                if(jsonObject3 != null)
                                {
                                    long idPub = jsonObject3.get("IdPublicidade") != null ? (long) jsonObject3.get("IdPublicidade") : (long) 0;
                                    publ = new Publicidade(
                                        idPub, 
                                        jsonObject3.get("Publicidade_Titulo") != null ? Library.decodifyUtf8(jsonObject3.get("Publicidade_Titulo").toString()) : "", 
                                        jsonObject3.get("Publicidade_DescricaoTexto") != null ? Library.decodifyUtf8(jsonObject3.get("Publicidade_DescricaoTexto").toString()) : "", 
                                        link+""+ idPub, 
                                        jsonObject3.get("Empresas_Nome") != null ? Library.decodifyUtf8(jsonObject3.get("Empresas_Nome").toString()) : "", 
                                        jsonObject3.get("TipoPublicidades_Nome") != null ? Library.decodifyUtf8(jsonObject3.get("TipoPublicidades_Nome").toString()) : "", 
                                        jsonObject3.get("Genero_Nome") != null ? Library.decodifyUtf8(jsonObject3.get("Genero_Nome").toString()) : "",
                                        jsonObject3.get("Imagems_ImageFile") != null ? Library.decodifyUtf8(jsonObject3.get("Imagems_ImageFile").toString()) : "", 
                                        jsonObject3.get("Videos_VideoFile") != null ? Library.decodifyUtf8(jsonObject3.get("Videos_VideoFile").toString()) : "",
                                        jsonObject3.get("FaixaEtaria_Nome") != null ? Library.decodifyUtf8(jsonObject3.get("FaixaEtaria_Nome").toString()) : "",
                                        jsonObject3.get("FaixaEtaria_From") != null ? Library.decodifyUtf8(jsonObject3.get("FaixaEtaria_From").toString()) : "",
                                        jsonObject3.get("FaixaEtaria_To") != null ? Library.decodifyUtf8(jsonObject3.get("FaixaEtaria_To").toString()) : "",
                                        jsonObject3.get("Empresa_Descricao") != null ? Library.decodifyUtf8(jsonObject3.get("Empresa_Descricao").toString()) : "",
                                        jsonObject3.get("HashTag_Tag") != null ? Library.decodifyUtf8(jsonObject3.get("HashTag_Tag").toString()) : ""   
                                    );
                                }
                            }
                        }
                    }
	  } catch (Exception e) {

		Logger.getLogger(Publicidade.class.getName()).log(Level.SEVERE, null, e);

	  } 
        
        return publ;
    }
       
    public static boolean sendPublicidade(String API,String appID,String token,String dados[]){
    
    String httpUrl = API + "/" + appID + "/" + token + "/" + Library.getValueFromOption(dados[10], 3);
    String input="{\"Publicidade_URL\": \"asdds\","
            + "\"Empresa_Descricao\":\""+dados[10]+"\","
            + "\"Endereco_MoradaCompleta\": \"adadad\","
            + "\"Videos_Nome\": \"ddas\","
            + "\"Videos_Descricao\": \"adada\","
            + "\"Videos_VideoFile\": \""+dados[1]+"\","
            + "\"Videos_Extensao\": \"dasd\","
            + "\"Imagems_Nome\": \"sdfsdf\","
            + "\"Imagems_Descricao\": \"sfdsdf\","
            + "\"Imagems_Extensao\": \"fdsf\","
            + "\"Empresas_Nome\": \""+dados[2]+"\","
            + "\"Genero_Nome\": \""+dados[6]+"\","
            + "\"FaixaEtaria_Nome\": \""+dados[7]+"\","
            + "\"FaixaEtaria_From\": \""+dados[8]+"\","
            + "\"FaixaEtaria_To\": \""+dados[9]+"\","
            + "\"FaixaEtaria_Descricao\": \""+dados[7]+"\","
            + "\"HashTag_Tag\": \"#kfdf\","
            + "\"TipoPublicidade_Nome\": \"asdd\","
            + "\"TipoPublicidade_Descricao\": \""+dados[5]+"\","
            + "\"Publicidade_DescricaoTexto\": \""+dados[4]+"\","
            + "\"Publicidade_Titulo\": \""+dados[3]+"\","
            + "\"Imagems_ImageFile\": \""+dados[0]+"\","
            + "\"Imagems_Tamanho\": 10,"
            + "\"Videos_Tamanho\": 15}";      
    try {

            URL url = new URL(httpUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            OutputStream os = conn.getOutputStream();
            os.write(input.getBytes());
            os.flush();

            if (conn.getResponseCode() != 200) {
                System.out.println("ERRO: "+conn.getResponseCode() );
                return false;
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(
                    (conn.getInputStream())));

            String output;
            boolean semafaro = false;
            while ((output = br.readLine()) != null) {
                //System.out.println("Dados: "+output );
                if(output != null)
                {
                    semafaro = true;
                }
            }

            conn.disconnect();
            if(semafaro)
                return true;

        } catch (MalformedURLException e) {

              Logger.getLogger(Publicidade.class.getName()).log(Level.SEVERE, null, e);

        } catch (IOException e) {

               Logger.getLogger(Publicidade.class.getName()).log(Level.SEVERE, null, e);

        }
        return false;
    }
}
