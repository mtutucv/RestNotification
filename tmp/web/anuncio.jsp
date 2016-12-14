<%-- 
    Document   : anuncio.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="java.io.File"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.mtutucv.Publicidade"%>
<%@page import="com.mtutucv.ObterDados"%>
<%@page import="org.jsoup.Jsoup"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include  file="header.html" %>
        <script type="text/javascript">    
            function showMSG(icon,msg) 
            {
                document.getElementById("yModalLabelMSG").innerHTML="<h4 class='modal-title' >"+msg+"</h4>";
                document.getElementById("yModalLabelMSGicon").innerHTML="<img src='images/"+icon+"'/>";     
                $('#myModalShowMSG').modal('show');
            }
        </script>
    </head>
  <body class="nav-md">
<% 
int auth=0;
String [] vars = {"","","","","","#"}; // 0 - Logo 1 - NomeUser 2 - autKey  3 - resultado 4 - iconMSG  5 - inicioLink

if (!com.mtutucv.Library.checkSession(session.getAttribute("nome")))
{
         response.sendRedirect(com.mtutucv.EnumString.getNamePageByNumber(8));
}
else 
{
  JSONObject obj = com.mtutucv.Library.getUserInfo(session.getAttribute("appuser_id").toString());
    if(obj != null)
    {
        if(obj.get("perfil").toString().equals(com.mtutucv.EnumString.getPerfilByNumber(1)))
        {
            auth=1;
            vars[5] =com.mtutucv.EnumString.getNamePageByNumber(1);
        }
        else if(obj.get("perfil").toString().equals(com.mtutucv.EnumString.getPerfilByNumber(2)))
        {
            auth=2;
            vars[5] =com.mtutucv.EnumString.getNamePageByNumber(3);
        }
        else
             response.sendRedirect(com.mtutucv.EnumString.getNamePageByNumber(6));

        vars[2] = session.getAttribute("auth_key") != null ? session.getAttribute("auth_key").toString() : "";
        vars[0] = session.getAttribute("logo") != null ? session.getAttribute("logo").toString() : "";
        vars[1] = obj.get("nomeCompleto") != null ? obj.get("nomeCompleto").toString() : "";

        try {
            JSONObject objGeral = com.mtutucv.Library.getObjFromFile(com.mtutucv.FilesConfig.configJSON);

            MultipartRequest m = new MultipartRequest(request, objGeral.get("ImagesPath").toString()); 
            if(m != null){
                   Publicidade publ = new Publicidade();
                    if(!m.getParameter("URLimagemBanner").isEmpty()) //Caso for inserido um Url em vez de Upload da Imagem
                        publ.setImagemFileUrl(com.mtutucv.Library.codifUtf8(m.getParameter("URLimagemBanner")));
                    else //Caso  Upload da Imagem
                        if( m.getFile("imagemBanner") != null){
                             String nomeFile = m.getFile("imagemBanner").getName();
                             String urlFile = objGeral.get("ImagesPath").toString() + "/"+ nomeFile;
                             if(com.mtutucv.Library.uploadFileToServerRiak(nomeFile, com.mtutucv.Library.getTypeFile(nomeFile), urlFile, true))
                                publ.setImagemFileUrl(com.mtutucv.Library.codifUtf8(objGeral.get("imagesHTTPurl").toString()+"images/"+nomeFile));
                                //eliminar a imagem caregada
                                com.mtutucv.Library.deleteFile(urlFile);
                        }
                    if(!m.getParameter("URLvideo").isEmpty()) //Caso for inserido um Url em vez de Upload do Video
                        publ.setVideoFileUrl(com.mtutucv.Library.codifUtf8(m.getParameter("URLvideo")));
                    else //Caso Upload do Video
                        if(m.getFile("video") != null)
                        {
                            String nomeFile = m.getFile("video").getName();
                             String urlFile = objGeral.get("ImagesPath").toString() + "/"+ nomeFile;
                             if(com.mtutucv.Library.uploadFileToServerRiak(nomeFile, com.mtutucv.Library.getTypeFile(nomeFile), urlFile, false))
                                publ.setVideoFileUrl(com.mtutucv.Library.codifUtf8(objGeral.get("imagesHTTPurl").toString()+"videos/"+nomeFile));
                        }   
                    String modoDifusao ="";

                    if(m.getParameter("SMS") != null)
                        modoDifusao = modoDifusao + "SMS";
                    if(m.getParameter("email") != null)
                        modoDifusao = modoDifusao + "_Email";
                    if(m.getParameter("gTalk") != null)
                        modoDifusao = modoDifusao + "_gTalk";
                    if(m.getParameter("push") != null)
                         modoDifusao = modoDifusao + "_Push";

                    publ.setCusto(m.getParameter("custoAnuncioHidden"));
                    publ.setModoDifusaoAnuncio(modoDifusao);
                    publ.setTitulo(com.mtutucv.Library.codifUtf8(m.getParameter("titulo")));
                    publ.setDescricaoTexto(com.mtutucv.Library.codifUtf8(Jsoup.parse(m.getParameter("descricao")).text())); //ima
                    publ.setTipoPublicidade(com.mtutucv.Library.codifUtf8(m.getParameter("tipoPublicidade")));
                    publ.setEmpresa(com.mtutucv.Library.codifUtf8(m.getParameter("empresas")));

                    if((m.getParameter("SexoF") != null && m.getParameter("SexoM") != null) || (m.getParameter("SexoF") == null && m.getParameter("SexoM") == null)){
                        publ.setGenero(com.mtutucv.Library.codifUtf8("FemininoMasculino"));
                    }else if(m.getParameter("SexoF") != null )
                    {
                        publ.setGenero(com.mtutucv.Library.codifUtf8("Feminino"));
                    }else {
                        publ.setGenero(com.mtutucv.Library.codifUtf8("Masculino"));
                    }

                    String [] dadosFaixaEtaria = com.mtutucv.Library.dataFaixaEtaria(m.getParameter("faixaEtaria").toString());
                    String dados [] = 
                    {
                        publ.getImagemFileUrl(),//Link da Imagem no Riak
                        publ.getVideoFileUrl(),//Link do video
                        publ.getEmpresa(),//Nome da Empresa
                        publ.getTitulo(), //Titulo do Anuncio
                        publ.getDescricaoTexto(),//Descricao do Anuncio
                        publ.getTipoPublicidade(),//Tipo de Publicidade
                        publ.getGenero(), //Gernero para a publicidade
                        dadosFaixaEtaria[0], // faixa etaria da publicidade
                        dadosFaixaEtaria[1], //incio da faixa etaria
                        dadosFaixaEtaria[2], // Fim da Faixa etaria
                        publ.getModoDifusaoAnuncio(),
                        publ.getCusto(),
                        m.getParameter("QuantidsadeMeses")
                    };
                    String idAnuncio = m.getParameter("idAnuncio") != null ? m.getParameter("idAnuncio").toString() : "";
                   
                    if(m.getParameter("guardar") != null)
                    {

                        if(com.mtutucv.Library.savePublicidade(dados,idAnuncio))
                        {
                            vars[3] = com.mtutucv.EnumString.getMsgByNumber(1);
                            vars[4] =com.mtutucv.EnumString.getIconByNumber(1);
                        }
                        else
                        {
                            vars[3] = com.mtutucv.EnumString.getMsgByNumber(2);
                            vars[4] = com.mtutucv.EnumString.getIconByNumber(2);
                        }
                    }
                    else if(m.getParameter("enviar") != null)
                    {
                        //Verificar se a empresa tem saldo e fazer o pagamento
                        boolean resultPagamento = com.mtutucv.Library.calcularSaldoCredito(
                                    com.mtutucv.FilesConfig.empresasJSON, 
                                    session.getAttribute("appuser_id").toString(), 
                                    publ.getEmpresa(), 
                                    publ.getCusto(),
                                    true);
                        System.out.println("Pagamento: "+resultPagamento);            
                        //Caso o pagamento ocorrer deve enviar o Anuncio
                        if(resultPagamento)
                        {
                            //Enviar o Anuncio
                            if(com.mtutucv.Publicidade.sendPublicidade(objGeral.get("urlPublicidade").toString(),objGeral.get("appID").toString(),vars[2],dados))
                            {
                                if(!idAnuncio.isEmpty() && !idAnuncio.equals("") )
                                    com.mtutucv.Library.elmininarDados(idAnuncio,com.mtutucv.FilesConfig.empresasJSON);
                                vars[3] =com.mtutucv.EnumString.getMsgByNumber(3);
                                vars[4] = com.mtutucv.EnumString.getIconByNumber(1);//sucess
                            }
                            else
                            {
                                vars[3] = com.mtutucv.EnumString.getMsgByNumber(4);
                                vars[4] = com.mtutucv.EnumString.getIconByNumber(2); //error
                                //Roolback da transação do pagamento
                                com.mtutucv.Library.calcularSaldoCredito(
                                    com.mtutucv.FilesConfig.empresasJSON, 
                                    session.getAttribute("appuser_id").toString(), 
                                    publ.getEmpresa(), 
                                    publ.getTipoPublicidade(),
                                    false);
                            }
                        }else{
                            vars[3] = com.mtutucv.EnumString.getMsgByNumber(5);
                            vars[4] = com.mtutucv.EnumString.getIconByNumber(3); //Alert
                        }
                    }
            }
          } catch (Exception e) {
            // Logger.getLogger("anuncio.jsp").log(Level.SEVERE, null, e);
          }
    }   
}
%>
<%    
      com.mtutucv.ObterDados dados = new ObterDados(auth,vars[2]);
      String [] link = dados.getLink(); 
      
    %>
<div class="container body">
  <div class="main_container">
    <div class="col-md-3 left_col">
      <div class="left_col scroll-view">
        <div class="navbar nav_title" style="border: 0;">
          <a href="<%=vars[5]%>" class="site_title"><i class="fa fa-plane"></i> <span>AirportPub</span></a>
        </div>
        <div class="clearfix"></div>
        <!-- menu profile quick info -->
        <jsp:include page="<%=com.mtutucv.EnumString.getNamePageByNumber(11)%>">
                <jsp:param name="logo" value="<%= vars[0] %>" />
                <jsp:param name="perfil" value="<%= auth %>" />
                <jsp:param name="NomeUser" value="<%= vars[1] %>" />
                <jsp:param name="link1" value="<%= link[0] %>" />
                <jsp:param name="link2" value="<%= link[1] %>" />
                <jsp:param name="link3" value="<%= link[2] %>" />
                <jsp:param name="link4" value="<%= link[3] %>" />
                <jsp:param name="link5" value="<%= link[4] %>" />
        </jsp:include> 
        <!-- /sidebar menu -->
      </div>
    </div>
    <!-- top navigation -->
    <div class="top_nav">
      <div class="nav_menu">
        <nav>
          <div class="nav toggle">
            <a id="menu_toggle"><i class="fa fa-bars"></i></a>
          </div>
          <ul class="nav navbar-nav navbar-right">
            <li class="">
              <a href="javascript:;" class="user-profile dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
                <img src="<%= vars[0] %>" alt=""><%= vars[1] %>
                <span class=" fa fa-angle-down"></span>
              </a>
              <ul class="dropdown-menu dropdown-usermenu pull-right">
                <li><a href="<%=com.mtutucv.EnumString.getNamePageByNumber(7)%>"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
              </ul>
            </li>
          </ul>
        </nav>
      </div>
    </div>
        <!-- /top navigation -->
        <!-- page content -->
<div class="right_col" role="main">
  <!-- top tiles -->
  <div style="height: 95px;">
                  <a href="#" class="site_title" style="color:#000 !important;">
                  <i class="fa fa-newspaper-o" style="border: 1px solid #2a3f54; color:#000 !important;"></i> <span>An&uacute;ncios</span></a>

  </div>
  <hr class="clearfix" style="background:#000; size:2">
          <button style="float: right; margin-top: -9px;" data-toggle="modal" data-target="#myModal">
                        <i class="fa fa-newspaper-o"></i> Novo Anúncios
                  </button>
<div class="separator" style="background: #FFF; padding: 5px; margin-top: 40px;">
    <div class="clearfix"></div>
                <div class="clearfix"></div>
<table  id="TableDados" class="table table-striped table-bordered" cellspacing="0">
<thead>
    <tr>
        <th>Titulo</th>
        <th>Descri&ccedil;&atilde;o</th>
        <th>Data</th>
        <th align="center">Opera&ccedil;&atilde;o</th>
    </tr>
    </thead>
 <tbody>
<%
    JSONObject objPublish = null, aux;
    if(auth == 1)
        objPublish = com.mtutucv.Library.getObjFromFile(com.mtutucv.FilesConfig.publicidadeJSON);
    else if(auth == 2)
        objPublish = com.mtutucv.Library.getPublicidadeUser(com.mtutucv.FilesConfig.publicidadeJSON,session.getAttribute("appuser_id").toString());
                
        if(objPublish != null)
        {
            for (Object key : objPublish.keySet()) 
                {
                    aux = (JSONObject) objPublish.get(key.toString());
            %>
                            <tr>
                                <td><a href="<%=com.mtutucv.EnumString.getNamePageByNumber(9)%>?id=<%=key.toString()%>"><%= com.mtutucv.Library.decodifyUtf8(aux.get("Publicidade_Titulo").toString()) %></a></td>
                                <td><%= com.mtutucv.Library.decodifyUtf8(aux.get("Publicidade_DescricaoTexto").toString()) %></td>
                                <td><%= aux.get("data").toString() %></td>
                                <td align="center">
                                    <span class="glyphicon glyphicon-edit" data-toggle="modal" data-id-pub="<%= key.toString()%>" data-target="#editAnuncio" title="Editar"></span>&nbsp;&nbsp;
                                    <span data-toggle="modal" class="glyphicon glyphicon-trash" data-anuncio="<%= key.toString() %>" data-target="#myModalAdvertisiment" title="Eliminar"></span>&nbsp;&nbsp;
                                    <span data-toggle="modal" class="glyphicon glyphicon-send" data-anuncio="<%= key.toString() %>" data-target="#myModalSendData" title="Enviar"></span></a>
                                </td>
                            </tr>
                    <% }
                      }
                    %>    
                        </tbody>
                    </table>                                  
                            <!-- /.row -->
          <br><br>
          <div class="clearfix">
          </div>
    <div class="clearfix"></div>
<%
    JSONObject objEmpresas = null;
    if(auth == 1)
        objEmpresas = com.mtutucv.Library.getObjFromFile(com.mtutucv.FilesConfig.empresasJSON);
    else if(auth == 2)
        objEmpresas = com.mtutucv.Library.getEmpresasFromUSer(com.mtutucv.FilesConfig.empresasJSON,session.getAttribute("appuser_id").toString());
    JSONObject auxEmpresas;
    List<String> empresas = new ArrayList();

    if(objEmpresas != null)
    {
        for (Object key : objEmpresas.keySet()) 
            {
                auxEmpresas = (JSONObject) objEmpresas.get(key.toString());
                if(auxEmpresas.get("nome") != null)
                {    
                    String saldo = auxEmpresas.get("Saldo") != null ? auxEmpresas.get("Saldo").toString() : "0" ;
                    String credito = auxEmpresas.get("credito") != null ? auxEmpresas.get("credito").toString() : "0" ;
                    if(!credito.equals("0") || !saldo.equals("0"))
                        empresas.add(com.mtutucv.Library.decodifyUtf8(auxEmpresas.get("nome").toString()) + "- ( Saldo: "+saldo + "$00 / Credito:"+ credito +"$00 )");

                }
            }
    }
         Collections.sort(empresas);  
%>

		<!-- Modal -->
    <div class="modal modal-wide fade" id="editAnuncio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            <h4 class="modal-title" id="myModalLabel">Editar Anúncio</h4>
          </div>
          <div class="modal-body"> 
              <section class="login_content">
              <form method="POST" action="<%=com.mtutucv.EnumString.getNamePageByNumber(2)%>" enctype="multipart/form-data" id="FormEdit">
                  <input type="hidden" name="idAnuncio" class="idAnuncioEditar">
                  
                  <div>
                      <select  class="form-control empresasEditar" name="empresas" id ="IDempresasNomeEditar" onChange="activateEnviarEditar()">
                        
                          <% 
                            for(String emp : empresas)
                            {
                          %>
                          <option value="<%=emp.split("-")[0]%>"> <%=emp%>  </option>
                          <%}%>
                      </select>
                  </div> 
                    </br>
                  <div>
                    <input type="text" class="form-control tituloEditar" name="titulo" value="" placeholder="Titulo" required="" />
                  </div>
                  <div>
                      <textarea class="form-control descricaoEditar" name="descricao" required=""></textarea>
                      
                  </div><br>
                  <div>
                      <select  class="form-control tipoPublicidadeEditar" name="tipoPublicidade" id="IDtipoPublicidadeEditar">
                           <option value ="Anuncio Simples">  An&uacute;ncio Simples (3000$00)</option>
                          <option value ="Anuncio Anual"> An&uacute;ncio Anual (1000$00)</option>
                          <option value ="Anuncio diario"> An&uacute;ncio diario (4000$00)</option>
                      </select>
                  </div><br/>
                    <div>
                      <select  class="form-control faixaEtariaEditar" name="faixaEtaria">
                          <option value ="1">Todos (> 0)</option>
                          <option value ="2">Crianças (0 a 10)</option>
                          <option value ="3">Adolecentes (11 a 17)</option>
                          <option value ="4">Jovens (18 a 30)</option>
                          <option value ="5">Adultos (30 a 60)</option>
                          <option value ="6">Idosos (> 60)</option>
                      </select>
                  </div>
                  </br>
                    <table>
                        <td>
                            <div class="form-group">
                                <label><input type="checkbox" name="SexoM" class="masculinoEditar"> Masculino</label>&nbsp;&nbsp;
                                <label><input  type="checkbox" name="SexoF" class="femininoEditar"> Feminino</label>
                            </div>
                        </td>
                    </table>
                    </br>
                    <table>
                        <td>
                            <label for="exampleInputFile"> Escolha Banner</label>&nbsp;&nbsp;
                        </td>
                        <td>
                            <div class="form-group">
                                <input type="file" id="exampleInputFile" name="imagemBanner">
                             </div>
                        </td>
                        <td>
                            <i class="fa fa-anchor"></i> Ou Insira link de Imagem
                            &nbsp;&nbsp;
                        </td>
                        <td valign="bottom">
                                <div class="form-group"><br/>
                                    <input type="text" id="exampleInputFile" name="URLimagemBanner" class="imagemEditar">
                                </div>
                        </td>
                    </table>
                    <table>
                        <td>
                            <label for="exampleInputFile"> Escolha Video</label>&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>
                            <div class="form-group">
                                <input type="file" id="exampleInputFileVideo" name="video" >
                             </div>
                        </td>
                        <td>
                         <i class="fa fa-anchor"></i> Ou Insira link do video &nbsp;&nbsp;
                        </td>
                        <td valign="bottom">
                                <div class="form-group"><br/>
                                   <input type="text" id="exampleInputFile" name="URLvideo" class="videoEditar">
                                </div>
                        </td>
                    </table>
                    <table>
                        <td>
                            <label for="exampleInputFile">Enviar An&uacute;ncios por: </label>&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>
                            <div class="form-group">
                                <label><input type="checkbox" name="SMS" class="SMSEditar" onclick="activateEnviarEditar()" > SMS (200$00 ECV)</label>&nbsp;&nbsp;
                                <label><input type="checkbox" name="email" class="emailEditar" onclick="activateEnviarEditar()" > E-mail (10$00 ECV)</label>&nbsp;&nbsp;
                                <label><input  type="checkbox" name="gTalk" class="gtalkEditar" onclick="activateEnviarEditar()"> Google Talk (20$00 ECV)</label>&nbsp;&nbsp;
                                <label><input  type="checkbox" name="push" class="pushEditar" onclick="activateEnviarEditar()" > Push Notification (50$00 ECV)</label>
                            </div>
                            </div>
                        </td>
                    </table>
                    <table>
                        <td>
                            <label for="exampleInputFile">Custo Total do A&uacute;ncio: </label>&nbsp;&nbsp;
                        </td>
                        <td> <div class="form-group">
                                <select  class="form-control numeroMesesEditar" name="QuantidsadeMeses" id="QuantidsadeMesesEditar" onchange="activateEnviarEditar()">
                                 <% for(int i=1; i< 13; i++)
                                 {
                                 %>    
                                   <option value ="<%=i%>">  <%=i%> m&ecirc;ses</option>
                               <%}
                               %>
                                </select>
                            </div>
                        </td>
                        <td> <div class="form-group"><br>
                            <input type="text" class="custoAnuncioEditar"  name = "custoAnuncio" disabled="true"/>
                            <input type="hidden" class="custoAnuncioEditarHidden"  name = "custoAnuncioHidden" />
                            </div>
                        </td>
                    </table>
              </section>         
          </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
              <button type="submit" name="enviar" class="btn btn-primary enviarEditar" disabled="true">Enviar</button>
              <button type="submit" name="guardar" class="btn btn-primary">Guardar</button>
          </div>
          </form>
        </div>
      </div>
    </div>
    <div class="modal modal-wide" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            <h4 class="modal-title" id="myModalLabel">Adicionar Anúncio</h4>
          </div>
          <div class="modal-body">
              <section class="login_content">
                  <form method="POST" action="<%=com.mtutucv.EnumString.getNamePageByNumber(2)%>" enctype="multipart/form-data" novalidate id="FormAdd">
                  <div>
                      <select  class="form-control empresasNomeNovo" id ="IDempresasNomeNovo" name="empresas" onChange="activateEnviar()">
                          <% 
                            for(String emp : empresas)
                            {
                          %>
                          <option value="<%=emp.split("-")[0]%>"> <%=emp%>  </option>
                          <%}%>
                      </select>
                  </div> 
                    </br>
                  <div>
                    <input type="text" class="form-control" name="titulo" placeholder="Titulo" required="" />
                  </div>
                  <div>
                      <textarea class="form-control descricaoEditar" name="descricao" required="" placeholder="Descri&ccedil;&atilde;o" ></textarea>
                  </div><br/>
                  <div>
                      <select  class="form-control " id="tipoAnuncioNovo" name="tipoPublicidade" onchange="activateEnviar()">
                          <option value ="Anuncio Simples">  An&uacute;ncio Simples (3000$00)</option>
                          <option value ="Anuncio Anual"> An&uacute;ncio Anual (1000$00)</option>
                          <option value ="Anuncio diario"> An&uacute;ncio diario (4000$00)</option>
                      </select>
                  </div><br/>
                    <div>
                      <select  class="form-control" name="faixaEtaria">
                          <option value ="1">Todos (> 0)</option>
                          <option value ="2">Crianças (0 a 10)</option>
                          <option value ="3">Adolecentes (11 a 17)</option>
                          <option value ="4">Jovens (18 a 30)</option>
                          <option value ="5">Adultos (30 a 60)</option>
                          <option value ="6">Idosos (> 60)</option>
                      </select>
                  </div>
                    </br>
                    <table>
                        <td>
                            <div class="form-group">
                                <label><input type="checkbox" name="SexoM" class="masculinoNovo" > Masculino</label>&nbsp;&nbsp;
                                <label><input  type="checkbox" name="SexoF" class="femininoNovo"> Feminino</label>
                            </div>
                        </td>
                    </table>
                    <table>
                        <td>
                            <label for="exampleInputFile"> Escolha Banner</label>&nbsp;&nbsp;
                        </td>
                        <td>
                            <div class="form-group">
                                <input type="file" id="exampleInputFile" name="imagemBanner">
                             </div>
                        </td>
                        <td>
                            <i class="fa fa-anchor"></i> Ou Insira link de Imagem
                            &nbsp;&nbsp;
                        </td>
                        <td valign="bottom">
                                <div class="form-group"><br/>
                                    <input type="text" id="exampleInputFile" name="URLimagemBanner">
                                </div>
                        </td>
                    </table>
                    <table>
                        <td>
                            <label for="exampleInputFile"> Escolha Video</label>&nbsp;&nbsp;&nbsp;&nbsp;
                        </td>
                        <td>
                            <div class="form-group">
                                <input type="file" id="exampleInputFileVideo" name="video">
                             </div>
                        </td>
                        <td>
                         <i class="fa fa-anchor"></i> Ou Insira link do video &nbsp;&nbsp;
                        </td>
                        <td valign="bottom">
                                <div class="form-group"><br/>
                                   <input type="text" id="exampleInputFile" name="URLvideo">
                                </div>
                        </td>
                    </table>
                    </br>
                    <table>
                        <td>
                            <label for="exampleInputFile">Enviar An&uacute;ncios por: </label>&nbsp;&nbsp;&nbsp;&nbsp;
                        </td></br>
                        <td>
                            <div class="form-group">
                                <label><input type="checkbox" name="SMS" class="SMSNovo" onclick="activateEnviar()" > SMS (200$00 ECV)</label>&nbsp;&nbsp;
                                <label><input type="checkbox" name="email" class="emailNovo" onclick="activateEnviar()" > E-mail (10$00 ECV)</label>&nbsp;&nbsp;
                                <label><input  type="checkbox" name="gTalk" class="gtalkNovo" onclick="activateEnviar()"> Google Talk (20$00 ECV)</label>&nbsp;&nbsp;
                                <label><input  type="checkbox" name="push" class="pushNovo" onclick="activateEnviar()" > Push Notification (50$00 ECV)</label>
                            </div>
                        </td>
                    </table>
                    <table style="width: 40%">
                        <td>
                            <label for="exampleInputFile">Custo Total do A&uacute;ncio: </label>&nbsp;&nbsp;
                        </td>
                        <td> <div class="form-group">
                                <select  class="form-control numeroMesesNovo" name="QuantidsadeMeses" id="QuantidsadeMesesNovo" onchange="activateEnviar()">
                                 <% for(int i=1; i< 13; i++)
                                 {
                                 %>    
                                   <option value ="<%=i%>">  <%=i%> m&ecirc;ses</option>
                               <%}
                               %>
                                </select>
                            </div>
                        </td>
                        <td>  
                            <div class="form-group">
                                &nbsp;&nbsp; <input type="text" class="custoAnuncioNovo form-group"  name = "custoAnuncio" disabled="true"/>
                                <input type="hidden" class="custoAnuncioNovoHidden"  name = "custoAnuncioHidden" />
                            </div>
                        </td>
                    </table>
              </section>         
          </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
              <button type="submit" name="enviar" class="btn btn-primary btnEnviar" disabled="true">Enviar</button>
              <button type="submit" name="guardar" class="btn btn-primary">Guardar</button>
          </div>
          </form>

        </div>
      </div>
    </div>
        </div>
        <!-- /page content -->

        <!-- footer content -->
        <footer style="margin-left: 0px !important; margin-top: 20px; margin-top: 10px !important;">
          <div class="pull-right">
              AirportPub &copy 2016
          </div>
          <div class="clearfix"></div>
        </footer>
        <!-- /footer content -->
      </div>
    </div>
        <%@include  file="footer.html" %>
  </body>

<!-- Modal Delete Anúncios -->
<div class="modal fade" id="myModalAdvertisiment" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="myModalLabel">Pretende Apagar o Anúncio?</h4>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Não</button>
        <button type="button" id="deleteData" class="btn btn-primary" data-dismiss="modal">Sim</button>
      </div>
    </div>
  </div>
</div>


<!-- Modal Delete Anúncios -->
<div class="modal fade" id="myModalSendData" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="myModalLabel">Pretende Enviar o Anúncio?</h4>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Não</button>
        <button type="button" id="sendData" class="btn btn-primary" data-dismiss="modal">Sim</button>
      </div>
    </div>
  </div>
</div>


<!-- Modal Saldo -->
<div class="modal fade" id="myModalShowMSG" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
          <table>
              <td>
                  <div  id='yModalLabelMSGicon'></div>
              </td>
              <td>
                  <div class="modalMSG" id='yModalLabelMSG'></div>.
              </td>    
         </table>           
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Ok</button>
      </div>
    </div>
  </div>
</div>
<% if(!vars[3].equals(""))
{
%>
<script> 
   showMSG("<%=vars[4]%>","<%=vars[3]%>");
</script>
<%}
%>
<script type="text/javascript" src="js/tinymce/tinymce.min.js"></script>
<script type="text/javascript">
  
  var id = 0;
  $(function(){
      $('.glyphicon-trash').click(function(){

        id = $(this).attr('data-anuncio');

      });

      $('.glyphicon-send').click(function(){

        id = $(this).attr('data-anuncio');

      });

      $('.modal-wide').on('hidden.bs.modal', function(){
          $(this).find('form')[0].reset();
      });

      $('#deleteData').click(function(){
          $('body').LoadingOverlay("show");
          $.ajax({
              url: "update.jsp?delete="+id+"&file=anuncio",
              method: "GET",
              success: function(data){
                  location.reload(true);
              },
              error: function(){
                  alert('erro ao apagar ');
              }
          });
          
      });

      $('#sendData').click(function(){
          $('body').LoadingOverlay("show");
          $.ajax({
              url: "update.jsp?enviar="+id,
              method: "GET",
              success: function(data){
                  location.reload(true);
              },
              error: function(){
                  alert('erro ao enviar ');
              }
          });
          
      });

      $('.glyphicon-edit').click(function(){

          id = $(this).attr('data-id-pub');
          //$('body').LoadingOverlay("show");

          $.ajax({
              url: "update.jsp?editar="+id,
              method: "GET",
              success: function(data){
                  var result = JSON.parse(data);
                  $('.tituloEditar').attr('value', result.titulo);
                  $('.idAnuncioEditar').attr('value', result.idAnuncio);
                  $(tinymce.get('descricao').getBody()).html(result.descricao);
                  $('.empresasEditar').val(result.empresa).change();
                  $('.tipoPublicidadeEditar').val(result.tipoPublish).change();
                  $('.faixaEtariaEditar').val(result.faixa_etaria).change();
                  if(result.sexo == 'M')
                      $('.masculinoEditar').attr('checked','checked');
                  else if(result.sexo == 'F')
                      $('.femininoEditar').attr('checked','checked');
                  else{
                      $('.masculinoEditar').attr('checked','checked');
                       $('.femininoEditar').attr('checked','checked');
                  }
                  $('.imagemEditar').attr('value', result.imagem);
                  $('.videoEditar').attr('value', result.video);
                  
                  if(result.modoDifusao.indexOf('SMS') !== -1)
                         $('.SMSEditar').attr('checked','checked');
                  if(result.modoDifusao.indexOf('Email') !== -1)
                         $('.emailEditar').attr('checked','checked');
                  if(result.modoDifusao.indexOf('gTalk') !== -1)
                         $('.gtalkEditar').attr('checked','checked');
                  if(result.modoDifusao.indexOf('Push') !== -1)
                         $('.pushEditar').attr('checked','checked');
                    activateEnviarEditar(); 
                  $('.numeroMesesEditar').val(result.nMeses).change();

              },
              error: function(){
                  alert('erro ao editar ');
              }
          });

      });

  });
 
function activateEnviar() 
{
            
    var mylist = document.getElementById("tipoAnuncioNovo");
        iterations = mylist.options[mylist.selectedIndex].text;

      var mylistQuant = document.getElementById("QuantidsadeMesesNovo");
        iterationsQuant = mylistQuant.options[mylistQuant.selectedIndex].value;

         var mylistSaldoCusto = document.getElementById("IDempresasNomeNovo");
        iterationsSaldoCusto = mylistSaldoCusto.options[mylistSaldoCusto.selectedIndex].text;

        var saldo = 0;
        var credito = 0;
        var somaCreditoSaldo =0;
        if(iterationsSaldoCusto !== '')
        {
            var a1 = iterationsSaldoCusto.split(':');

            saldo = parseInt(a1[1].split('$')[0]);
            credito = parseInt(a1[2].split('$')[0]);
            somaCreditoSaldo = parseInt(saldo) + parseInt(credito);
        }       

        var custo = calcularCusto(iterations,iterationsQuant);

        $('.custoAnuncioNovo').attr('value',  custo + "$00 ECV")
        $('.custoAnuncioNovoHidden').attr('value',  custo);

        if(parseInt(custo) < saldo )
            $('.btnEnviar').attr('disabled', false);
        else if (parseInt(custo) < credito)
            $('.btnEnviar').attr('disabled', false);
        else if (parseInt(custo) < somaCreditoSaldo)
            $('.btnEnviar').attr('disabled', false);
        else{

            $('.btnEnviar').attr('disabled', true);
            showMSG("alertICON.jpg","Não tens saldo ou Credito suficiente, Adicione credito a empresa ou contacte o Administrador!");
            //$('#myModalSemSaldo').modal('show');
        }
    if($('.SMSNovo').prop('checked') == false && $('.emailNovo').prop('checked') == false && $('.gtalkNovo').prop('checked') == false && $('.pushNovo').prop('checked') == false)
    {
         $('.btnEnviar').attr('disabled', true);
         $('.custoAnuncioNovo').attr('value',  "");
         $('.custoAnuncioNovoHidden').attr('value', "");
    }
              
 }
 function activateEnviarEditar() 
 {
    
     var mylist = document.getElementById("IDtipoPublicidadeEditar");
        iterations = mylist.options[mylist.selectedIndex].text;

        var mylistQuant = document.getElementById("QuantidsadeMesesEditar");
        iterationsQuant = mylistQuant.options[mylistQuant.selectedIndex].value;

        var custo = calcularCusto(iterations,iterationsQuant);
        
        var mylistSaldoCusto = document.getElementById("IDempresasNomeEditar");
        iterationsSaldoCusto = mylistSaldoCusto.options[mylistSaldoCusto.selectedIndex].text;

        var saldo = 0;
        var credito = 0;
        var somaCreditoSaldo =0;
        if(iterationsSaldoCusto !== '')
        {
            var a1 = iterationsSaldoCusto.split(':');

            saldo = parseInt(a1[1].split('$')[0]);
            credito = parseInt(a1[2].split('$')[0]);
            somaCreditoSaldo = parseInt(saldo) + parseInt(credito);
        }       

        $('.custoAnuncioNovo').attr('value',  custo + "$00 ECV")
        $('.custoAnuncioNovoHidden').attr('value',  custo);

        if(parseInt(custo) < saldo )
            $('.enviarEditar').attr('disabled', false);
        else if (parseInt(custo) < credito)
            $('.enviarEditar').attr('disabled', false);
        else if (parseInt(custo) < somaCreditoSaldo)
            $('.enviarEditar').attr('disabled', false);
        else{

            $('.enviarEditar').attr('disabled', true);
            //$('#myModalSemSaldo').modal('show');
        }

     $('.custoAnuncioEditar').attr('value',  custo + "$00 ECV");
     $('.custoAnuncioEditarHidden').attr('value',  custo);
     
     
     if($('.SMSEditar').prop('checked') == false && $('.emailEditar').prop('checked') == false && $('.gtalkEditar').prop('checked') == false && $('.pushEditar').prop('checked') == false)
    { 
        $('.enviarEditar').attr('disabled', true);
            $('.custoAnuncioEditar').attr('value',  "");
            $('.custoAnuncioEditarHidden').attr('value', "");
    }        
}
            
function calcularCusto(iterations,iterationsQuant) {
                var preco1 = 0;
                var precoSMS = 0;
                var precoEmail = 0;
                var precoGtalk = 0;
                var precoPush = 0;
                if(iterations.indexOf('Simples') !== -1)
                    preco1 = 3000;
                else if(iterations.indexOf('diario') !== -1)
                    preco1 = 4000;
                else if(iterations.indexOf('Anuel') !== -1)
                    preco1 = 1000;
                
                 if($('.SMSNovo').prop('checked') == true)
                     precoSMS = 200;
                 if($('.emailNovo').prop('checked') == true)
                      precoEmail = 10;
                 if($('.gtalkNovo').prop('checked') == true) 
                      precoGtalk = 20;
                 if( $('.pushNovo').prop('checked') == true)
                       precoPush = 50;
                   
                  var conta = (preco1 + precoSMS + precoEmail + precoGtalk + precoPush) * iterationsQuant;
                  
                  return conta;
                  
             }
             

        tinymce.init({
            selector: "textarea",
            plugins: [
                "advlist autolink lists link image charmap print preview anchor",
                "searchreplace visualblocks code fullscreen",
                "insertdatetime media table contextmenu paste"
            ],
            toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image",
            language : "pt_PT"
        });
        

         </script>
</html>
