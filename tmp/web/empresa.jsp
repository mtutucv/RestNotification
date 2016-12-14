<%-- 
    Document   : empresa.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.mtutucv.EnumString"%>
<%@page import="com.mtutucv.Library"%>
<%@page import="com.mtutucv.FilesConfig"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.mtutucv.ObterDados"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    String [] vars = {"","","",null,"","#",""}; // 0 - Logo 1 - NomeUser 2 - autKey  3 - resultado 4 - iconMSG  5 - inicioLink 6 - controlSaldoCredito
    
    if (!Library.checkSession(session.getAttribute("nome")))
    {
             response.sendRedirect(EnumString.getNamePageByNumber(8));
    }
    else 
    {
     JSONObject obj = Library.getUserInfo(session.getAttribute("appuser_id").toString());
        if(obj != null)
        {
            if(obj.get("perfil").toString().equals(EnumString.getPerfilByNumber(1)))
            {
                auth=1;
                vars[5] =EnumString.getNamePageByNumber(1);
                vars[6] ="";
            }
            else if(obj.get("perfil").toString().equals(EnumString.getPerfilByNumber(2)))
            {
                auth=2;
                vars[5] =EnumString.getNamePageByNumber(3);
                vars[6] ="disabled";
            }else
                 response.sendRedirect(EnumString.getNamePageByNumber(6));
            
            
            vars[2] = session.getAttribute("auth_key").toString();
            vars[0]=session.getAttribute("logo").toString();
            vars[1]=obj.get("nomeCompleto").toString();
            
            //Caregar dados
            try {
                JSONObject objGeral = Library.getObjFromFile(FilesConfig.configJSON);
                
                MultipartRequest m = new MultipartRequest(request, objGeral.get("ImagesPath").toString()); 
                
                if(m != null){
                    String logoEmpresa = null;
                    //Caregar logo
                    if(!m.getParameter("URLLogoEmpresa").isEmpty()) //Caso for inserido um Url em vez de Upload da Imagem
                           logoEmpresa=m.getParameter("URLLogoEmpresa").toString();
                    else //Caso  Upload da Imagem
                        if( m.getFile("LogoEmpresa") != null){
                             String nomeFile = m.getFile("LogoEmpresa").getName();
                             String urlFile = objGeral.get("ImagesPath").toString() + "/"+ nomeFile;
                             if(Library.uploadFileToServerRiak(nomeFile, Library.getTypeFile(nomeFile), urlFile, true))
                                logoEmpresa = objGeral.get("imagesHTTPurl").toString()+"images/"+nomeFile;
                                //eliminar a imagem caregada
                                Library.deleteFile(urlFile);
                            }
                    String nomeEmpresa = m.getParameter("nomeEmpresa") != null ? m.getParameter("nomeEmpresa").toString() : "";
                    String moradaEmpresa = m.getParameter("moradaEmpresa") != null ? m.getParameter("moradaEmpresa").toString() : "";
                    String saldoEmpresa = m.getParameter("saldoEmpresa") != null ? m.getParameter("saldoEmpresa").toString() : "";
                    String creditoEmpresa = m.getParameter("creditoEmpresa") != null ? m.getParameter("creditoEmpresa").toString() : "";
                    String urlEmpresa = m.getParameter("urlEmpresa") != null ? m.getParameter("urlEmpresa").toString() : "";
                    String userEmpresa = m.getParameter("userEmpresa") != null ? m.getParameter("userEmpresa").toString() : "";
                    
                     String dados [] = 
                        {
                            nomeEmpresa, //Nome da Empresa
                            moradaEmpresa, //Morada da Empresa
                            saldoEmpresa, //Saldo da Empresa
                            creditoEmpresa, //Credito da Empresa
                            urlEmpresa,//Descricao do Anuncio
                            userEmpresa,
                            logoEmpresa
                        };
                     
                    String idEmpresa = m.getParameter("idEmpresa") != null ? m.getParameter("idEmpresa").toString() : "";
                    
                    if(Library.saveEmpresa(dados,idEmpresa))
                    {
                        vars[3] = EnumString.getMsgByNumber(6);
                        vars[4] =EnumString.getIconByNumber(1);
                    }
                    else
                    {
                        vars[3] = EnumString.getMsgByNumber(7);
                        vars[4] = EnumString.getIconByNumber(2);
                    }    
                }
            }
            catch(Exception e)
            {
            }
        }
    }
    %>
<%    
      ObterDados dados = new ObterDados(auth,vars[2]);
      String [] link = dados.getLink(); // Obter links da pagina
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
            <jsp:include page="<%=EnumString.getNamePageByNumber(11)%>">
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
                    <li><a href="<%=EnumString.getNamePageByNumber(7)%>"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
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
  <div>
      <span class="site_title" style="color:#000 !important;">
      <i class="fa fa-university" style="border: 1px solid #2a3f54; color:#000 !important;"></i> <span>Empresa</span></span>
    </div>
  <hr class="clearfix" style="background:#000; size:2;">
  <% if(auth == 1) 
  { %>
          <button style="float: right; margin-top: -9px;" data-toggle="modal" data-target="#myModal">
                        <i class="fa fa-newspaper-o"></i> Novo Empresa
                  </button>
 <%}%>
<div class="separator" style="background: #FFF; padding: 5px; margin-top: 40px;">
    <div class="clearfix"></div>
                <div class="clearfix"></div>
<!-- /page content -->
<table  id="TableDados" class="table table-striped table-bordered" cellspacing="0">
    <thead>
        <tr>
            <th>Empresa</th>
            <th>Morada</th>
            <th>Saldo / Credito</th>
            <th align="center">Opera&ccedil;&atilde;o</th>
        </tr>
    </thead>
    <tbody>
<%
    JSONObject objEmpresa = null, aux;
    if(auth == 1)
        objEmpresa = Library.getObjFromFile(FilesConfig.empresasJSON);
    else if(auth == 2)
        objEmpresa = Library.getEmpresasFromUSer(FilesConfig.empresasJSON,session.getAttribute("appuser_id").toString());
                
        if(objEmpresa != null)
        {
            for (Object key : objEmpresa.keySet()) 
                {
                    aux = (JSONObject) objEmpresa.get(key.toString());
                    String logoT = Library.decodifyUtf8(aux.get("logoTipo").toString());
                    if(logoT.contains("http"))
                    {
                        logoT=Library.getImageFromHTTP(logoT);
                    }
            %>
                    <tr>
                        <td><a href='<%=aux.get("url") != null ? Library.decodifyUtf8(aux.get("url").toString()) : "#"%>' target="_new">
                               <img class="imageEmp" src='<%=logoT%>' />
                                &nbsp;
                                <%= aux.get("nome") != null ? Library.decodifyUtf8(aux.get("nome").toString()) : "" %>
                            </a>
                        </td>
                        <td><%= aux.get("morada") != null ? Library.decodifyUtf8(aux.get("morada").toString()) : "" %></td>
                        <td><%= aux.get("Saldo")!= null ? aux.get("Saldo").toString() : "0" %> ECV / <%= aux.get("credito") != null ? aux.get("credito").toString() : "0" %> ECV</td>
                        <td align="center">
                            <span class="" data-toggle="modal" data-id-paypal="<%= key.toString()%>" data-target="#myModalPaypal" title="PayPal"><i class="fa fa-paypal"></i></span>&nbsp;&nbsp;
                            <span class="glyphicon glyphicon-edit" data-toggle="modal" data-id-pub="<%= key.toString()%>" data-target="#myModalEditarEmpresa" title="Editar"></span>&nbsp;&nbsp;
                            <% if(auth == 1) 
                            {%>
                            <span data-toggle="modal" class="glyphicon glyphicon-trash" data-anuncio="<%= key.toString() %>" data-target="#myModalAdvertisiment" title="Eliminar"></span>
                         <% } %>
                        </td>
                    </tr>
                <% }
                  }
                %>    
            </tbody>
        </table>
   <div class="modal modal-wide" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            <h4 class="modal-title" id="myModalLabel">Adicionar Empresa</h4>
          </div>
          <div class="modal-body">
            
              <section class="login_content">
              <form method="POST" action="empresa.jsp" enctype="multipart/form-data">
                  <div>
                    <input type="text" class="form-control" name="nomeEmpresa" placeholder="Nome da Empresa" required="" />
                  </div>
                  <div>
                      <input type="text" class="form-control" name="moradaEmpresa" placeholder="Morada da Empresa" required="" />
                  </div>
                  <div>
                      <table>
                          <td style="width: 400px"><input type="text" class="form-control" name="saldoEmpresa" placeholder="Saldo ECV (00$00) da Empresa" required="" <%=vars[6]%>/></td> 
                          <td>&nbsp;<span class="" data-toggle="modal" data-id-paypal="" data-target="#myModalPaypal" title="PayPal" style="float: right"><i class="fa fa-paypal"></i></span></td>
                      </table>
                  </div>
                  <div><table>
                          <td style="width: 400px">
                              <input type="text" class="form-control" name="creditoEmpresa" placeholder="Credito ECV (00$00) da Empresa" required="" <%=vars[6]%>/>
                          </td>
                      </table>
                  </div>
                  <div>
                      <input type="text" class="form-control" name="urlEmpresa" placeholder="Url da Empresa"  />
                  </div>
                  <div>
                      <select  class="form-control" name="userEmpresa">
                          <%
                              JSONObject objUser = Library.getObjFromFile(FilesConfig.userInfoJSON);
                                JSONObject auxUser;
                                if(objUser != null)
                                {
                                    for (Object key : objUser.keySet()) 
                                        {
                                            auxUser = (JSONObject) objUser.get(key.toString());
                                            if(auxUser.get("perfil").toString().equals("Empresa"))
                                            {
                           %>
                                            <option value ="<%=auxUser.get("socialID").toString()%>">  
                                                Responsavel : <%=auxUser.get("nomeCompleto").toString()%>
                                            </option>
                           <%               }
                                        }
                                }%>
                      </select>
                    <table>
                        <td>
                            <label for="exampleInputFile"> Escolha Logo</label>&nbsp;&nbsp;
                        </td>
                        <td>
                            <div class="form-group">
                                <input type="file" id="exampleInputFile" name="LogoEmpresa">
                             </div>
                        </td>
                        <td>
                            <i class="fa fa-anchor"></i> Ou Insira link de Logo
                            &nbsp;&nbsp;
                        </td>
                        <td valign="bottom">
                                <div class="form-group"><br/>
                                    <input type="text" id="exampleInputFile" name="URLLogoEmpresa">
                                </div>
                        </td>
                    </table>
              </section>         
          </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
              <button type="submit" name="guardar" class="btn btn-primary">Guardar</button>
          </div>
          </form>
        </div>
      </div>
    </div>   
                      
   <!-- Editar Empresa -->         
   <div class="modal modal-wide" id="myModalEditarEmpresa" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
            <h4 class="modal-title" id="myModalLabel">Editar Empresa</h4>
          </div>
          <div class="modal-body">
            
              <section class="login_content">
              <form method="POST" action="<%=EnumString.getNamePageByNumber(3)%>" enctype="multipart/form-data">
                   <input type="hidden" name="idEmpresa" class="idEmpresaEditar">
                  <div>
                    <input type="text" class="form-control nomeEmpresaEditar" name="nomeEmpresa" placeholder="Nome da Empresa" required="" />
                  </div>
                  <div>
                      <input type="text" class="form-control moradaEmpresaEditar" name="moradaEmpresa" placeholder="Morada da Empresa" required="" />
                  </div>
                  <div>
                      <table>
                          <td style="width: 400px"><input type="text" class="form-control saldoEmpresaEditar" name="saldoEmpresa" placeholder="Saldo ECV (00$00) da Empresa" required="" <%=vars[6]%>/></td> 
                          <td>&nbsp;<span class="" data-toggle="modal" data-id-paypal="" data-target="#myModalPaypal" title="PayPal" style="float: right"><i class="fa fa-paypal"></i></span></td>
                      </table>
                  </div>
                  <div><table>
                          <td style="width: 400px">
                              <input type="text" class="form-control creditoEmpresaEditar" name="creditoEmpresa" placeholder="Credito ECV (00$00) da Empresa" required="" <%=vars[6]%>/>
                          </td>
                      </table>
                  </div>
                  <div>
                      <input type="text" class="form-control urlEmpresaEditar" name="urlEmpresa" placeholder="Url da Empresa"  />
                  </div>
                  <div>
                      <select  class="form-control userEmpresaEditar" name="userEmpresa" >
                          <%
                              JSONObject objUser2 = Library.getObjFromFile(FilesConfig.userInfoJSON);
                                JSONObject auxUser2;
                                if(objUser != null)
                                {
                                    for (Object key : objUser2.keySet()) 
                                        {
                                            auxUser2 = (JSONObject) objUser.get(key.toString());
                                            if(auxUser2.get("perfil").toString().equals("Empresa"))
                                            {
                           %>
                                            <option value ="<%=auxUser2.get("socialID").toString()%>">  
                                                Responsavel : <%=auxUser2.get("nomeCompleto").toString()%>
                                            </option>
                           <%               }
                                        }
                                }%>
                      </select>
                    <table>
                        <td>
                            <label for="exampleInputFile"> Escolha Logo</label>&nbsp;&nbsp;
                        </td>
                        <td>
                            <div class="form-group">
                                <input type="file" id="exampleInputFile" name="LogoEmpresa">
                             </div>
                        </td>
                        <td>
                            <i class="fa fa-anchor"></i> Ou Insira link de Logo
                            &nbsp;&nbsp;
                        </td>
                        <td valign="bottom">
                                <br/> <input type="text" id="exampleInputFile" name="URLLogoEmpresa" class="form-control URLLogoEmpresaEditar" >
                        </td>
                    </table>
              </section>         
          </div>
          <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
              <button type="submit" name="guardar" class="btn btn-primary">Guardar</button>
          </div>
          </form>
        </div>
      </div>
    </div>   
    
 <!-- Modal Delete Empresa -->
<div class="modal fade" id="myModalAdvertisiment" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="myModalLabel">Pretende Eliminar a Empresa?</h4>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Não</button>
        <button type="button" id="deleteData" class="btn btn-primary" data-dismiss="modal">Sim</button>
      </div>
    </div>
  </div>
</div>
 
<!-- Modal PayPal -->
<div class="modal fade" id="myModalPaypal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
           <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_blank">
                <input type="hidden" name="cmd" value="_s-xclick">
                <input type="hidden" name="hosted_button_id" value="EWS4YUET2D9KA">
                <input type="image" src="https://www.paypalobjects.com/pt_PT/PT/i/btn/btn_buynowCC_LG.gif" border="0" name="submit" alt="PayPal - A forma mais fácil e segura de efetuar pagamentos online!">
                <img alt="" border="0" src="https://www.paypalobjects.com/pt_PT/i/scr/pixel.gif" width="1" height="1">
            </form>

       </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Não</button>
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
  
<% if(vars[3] != null)
{
%>
<script> 
   showMSG("<%=vars[4]%>","<%=vars[3]%>");
</script>
<% }
%>  
 <script type="text/javascript">
  
  var id = 0;
  $(function()
  {
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
              url: "update.jsp?delete="+id+"&file=empresa",
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

          $.ajax({
              url: "update.jsp?editarEmpresa="+id,
              method: "GET",
              success: function(data){
                  var result = JSON.parse(data);
                 $('.nomeEmpresaEditar').attr('value', result.nome);
                 $('.moradaEmpresaEditar').attr('value', result.morada);
                  $('.saldoEmpresaEditar').attr('value', result.Saldo);
                 $('.creditoEmpresaEditar').attr('value', result.credito);
                  $('.urlEmpresaEditar').attr('value', result.url);
                  $('.URLLogoEmpresaEditar').attr('value', result.logoTipo);
                  $('.userEmpresaEditar').val(result.user).change();
                  $('.idEmpresaEditar').attr('value', result.idEmpresa);
              },
              error: function(){
                  alert('erro ao editar ');
              }
          });

      });

  });
  </script>
  </body>
  
  
</html>
