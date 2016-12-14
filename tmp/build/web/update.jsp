
<%-- 
    Document   : update.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="com.mtutucv.Library"%>
<%@page import="org.json.simple.JSONObject"%>
<%
    if(request.getParameter("delete") != null)
    {
        //Eliminar Anuncio do JSON
        String ficheiro = "";
        
        if(request.getParameter("file").toString().equals("anuncio"))
            ficheiro = com.mtutucv.FilesConfig.publicidadeJSON;
        else  if(request.getParameter("file").toString().equals("empresa"))
            ficheiro = com.mtutucv.FilesConfig.empresasJSON;
        
         boolean resul = com.mtutucv.Library.elmininarDados(request.getParameter("delete").toString(),ficheiro);
         out.print(resul);
         out.flush();
    }else if(request.getParameter("enviar") != null){
        
        boolean send = false;
        try {
                JSONObject objAnuncio = Library.getObjFromFile(com.mtutucv.FilesConfig.publicidadeJSON);
                
                if(objAnuncio != null)
                {
                    JSONObject anuncio = com.mtutucv.Library.toJSONObject(objAnuncio.get(request.getParameter("enviar").toString()));
                    if(anuncio != null)
                    {
                        JSONObject objGeral = com.mtutucv.Library.getObjFromFile(com.mtutucv.FilesConfig.configJSON);
                        String autKey = session.getAttribute("auth_key") != null ? session.getAttribute("auth_key").toString() : "";
                        String dados [] = {
                            anuncio.get("Imagems_ImageFile") !=null ? anuncio.get("Imagems_ImageFile").toString() : "",
                            anuncio.get("Videos_VideoFile") != null ? anuncio.get("Videos_VideoFile").toString() : "",
                            anuncio.get("Empresas_Nome") !=null ? anuncio.get("Empresas_Nome").toString() : "",
                            anuncio.get("Publicidade_Titulo") !=null ? anuncio.get("Publicidade_Titulo").toString() : "",
                            anuncio.get("Publicidade_DescricaoTexto") !=null ? anuncio.get("Publicidade_DescricaoTexto").toString() : "",
                            anuncio.get("TipoPublicidade_Descricao") !=null ? anuncio.get("TipoPublicidade_Descricao").toString() : "",
                            anuncio.get("Genero_Nome") !=null ? anuncio.get("Genero_Nome").toString() : "",
                            anuncio.get("FaixaEtaria_Descricao") !=null ? anuncio.get("FaixaEtaria_Descricao").toString() : "",
                            anuncio.get("FaixaEtaria_From") !=null ? anuncio.get("FaixaEtaria_From").toString() : "",
                            anuncio.get("FaixaEtaria_To") !=null ? anuncio.get("FaixaEtaria_To").toString() : ""};
                            com.mtutucv.Publicidade.sendPublicidade(objGeral.get("urlPublicidade").toString(),objGeral.get("appID").toString(),autKey,dados);  
                            
                            //Eliminar Anuncio do JSON
                            com.mtutucv.Library.elmininarDados(request.getParameter("enviar").toString(),com.mtutucv.FilesConfig.publicidadeJSON);
                        }
                    }
                    send= true;
                } catch (Exception e) {
                  Logger.getLogger(Library.class.getName()).log(Level.SEVERE, null, e);      
                }
        out.print(send);
        out.flush();
                
    }else if (request.getParameter("admin") != null){
        //Ativar administrator
        if(com.mtutucv.Library.checkIfAminIsInConfig(request.getParameter("admin").toString()))
            out.print("Este Perfil Administrado tem que ser modificado na configura&ccedil;&atilde;o.");
        else
        {
            boolean resul = com.mtutucv.Library.updatePerfil(request.getParameter("admin").toString(),com.mtutucv.EnumString.getPerfilByNumber(1));
            out.print(resul);
        }
        out.flush();
    }else if (request.getParameter("empresa") != null){
        //Ativar Empresa
        boolean resul = com.mtutucv.Library.updatePerfil(request.getParameter("empresa").toString(),com.mtutucv.EnumString.getPerfilByNumber(2));
        out.print(resul);
        out.flush();
    }else if (request.getParameter("anonimo") != null){
        //Ativar Anonino
        boolean resul = com.mtutucv.Library.updatePerfil(request.getParameter("anonimo").toString(),com.mtutucv.EnumString.getPerfilByNumber(3));
        out.print(resul);
        out.flush();
    }else if (request.getParameter("editar") != null){
        JSONObject objRes = com.mtutucv.Library.getObjFromFile(com.mtutucv.FilesConfig.publicidadeJSON);
                    
        if (objRes != null)
        {
            JSONObject res =  (JSONObject) objRes.get(request.getParameter("editar").toString());
            if (res != null)
            {
                JSONObject json = new JSONObject();
                String [] parametersIN = {"Publicidade_Titulo","Empresas_Nome","Publicidade_DescricaoTexto","TipoPublicidade_Descricao","FaixaEtaria_Descricao","Genero_Nome","Imagems_ImageFile","Videos_VideoFile","Empresa_Descricao","HashTag_Tag","Imagems_Nome"};
                String [] parametersOut = {"titulo","empresa","descricao","tipoPublish","faixa_etaria","sexo","imagem","video","modoDifusao","custo","nMeses"};
     
                for(int i=0; i < parametersIN.length; i++)
                {
                    if(parametersIN[i].equals("FaixaEtaria_Descricao"))
                    {
                      String faixaEtaria = res.get(parametersIN[i]) != null ? com.mtutucv.Library.decodifyUtf8(res.get(parametersIN[i]).toString()) : "";
                      json.put(parametersOut[i], com.mtutucv.Library.getValueFromOption(faixaEtaria, 1));
                    }else if(parametersIN[i].equals("Genero_Nome"))
                    {
                      String sexo = res.get(parametersIN[i]) != null ? com.mtutucv.Library.decodifyUtf8(res.get(parametersIN[i]).toString()) : "";  
                      json.put(parametersOut[i], com.mtutucv.Library.getValueFromOption(sexo, 2));
                    }else{
                        json.put(parametersOut[i], res.get(parametersIN[i]) != null ? com.mtutucv.Library.decodifyUtf8(res.get(parametersIN[i]).toString()) : "");
                    }
                }
                json.put("idAnuncio",request.getParameter("editar").toString());
                out.print(json);
                out.flush();
            }
        }
    }else if (request.getParameter("editarEmpresa") != null){
        JSONObject objRes = com.mtutucv.Library.getObjFromFile(com.mtutucv.FilesConfig.empresasJSON);
                    
        if (objRes != null)
        {
            JSONObject res =  (JSONObject) objRes.get(request.getParameter("editarEmpresa").toString());
            if (res != null)
            {
                JSONObject json = new JSONObject();
                String [] parameters = {"Saldo","logoTipo","credito","user","nome","url","morada"};
                
                for(int i=0; i <parameters.length; i++)
                    json.put(parameters[i], res.get(parameters[i]) != null ? com.mtutucv.Library.decodifyUtf8(res.get(parameters[i]).toString()) : "");
                json.put("idEmpresa",request.getParameter("editarEmpresa").toString());
                out.print(json);
                out.flush();
            }
        }
    }
    


%>