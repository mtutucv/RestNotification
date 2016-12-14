<%-- 
    Document   : config.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.mtutucv.ObterDados"%>
<%@page import="com.mtutucv.EnumString"%>
<%@page import="com.mtutucv.Library"%>
<%@page import="com.mtutucv.FilesConfig"%>
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
    JSONObject configuration=null;
    if (!Library.checkSession(session.getAttribute("nome")))
    {
             response.sendRedirect(EnumString.getNamePageByNumber(8));
    }
    else 
    {   JSONObject obj = null;
        if(session.getAttribute("appuser_id") != null)
                obj = Library.getUserInfo(session.getAttribute("appuser_id").toString());
        
        if(obj != null)
        {
            if(obj.get("perfil").toString().equals(EnumString.getPerfilByNumber(1)))
            {
                auth=1;
                configuration = Library.getObjFromFile(FilesConfig.configJSON);
                vars[5] =EnumString.getNamePageByNumber(1);
            }
            else if(obj.get("perfil").toString().equals(EnumString.getPerfilByNumber(2)))
            {
                auth=2;
                vars[5] =EnumString.getNamePageByNumber(3);
            }else
                 response.sendRedirect(EnumString.getNamePageByNumber(6));
            vars[2] = session.getAttribute("auth_key").toString();
            vars[0] = session.getAttribute("logo").toString();
            vars[1]=obj.get("nomeCompleto").toString();
        }
    }
    %>
<%    
      ObterDados dados = new ObterDados(auth,vars[2]);
                 
      String [] link = dados.getLink();
      
    %>
    <div class="container body">
      <div class="main_container">
        <div class="col-md-3 left_col">
          <div class="left_col scroll-view">
            <div class="navbar nav_title" style="border: 0;">
              <a href="<%=vars[5] %>" class="site_title"><i class="fa fa-plane"></i> <span>AirportPub</span></a>
            </div>

            <div class="clearfix"></div>

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
          <div>
               <span class="site_title" style="color:#000 !important;">
               <i class="fa fa-cog" style="border: 1px solid #2a3f54; color:#000 !important;"></i> 
               <span>Configura&ccedil;&otilde;es</span></span>
          </div>
            <div class="clearfix"></div>
              <div class="separator">
            <div class="clearfix"></div>
        <% if(auth == 1)
          {
              
          if(request.getParameter("appID")!= null)
        {
            try {
                    for (Object key : configuration.keySet()) 
                    {
                        configuration.put((String)key,request.getParameter((String)key).toString());
                    }
                    
                    if(Library.SaveJSONToFile(configuration,FilesConfig.configJSON))
                    {
                        vars[3] =EnumString.getMsgByNumber(8);
                        vars[4] = EnumString.getIconByNumber(1);//sucess
                    }
                
            
                } catch (Exception e) {
                    e.printStackTrace();
                }
            
        }
        %>
          <!-- top tiles -->
          <form method="POST" action="<%=EnumString.getNamePageByNumber(5)%>" >
                <ul class="nav nav-tabs">
                    <li class="active"><a data-toggle="tab" href="#geral">Geral</a></li>
                   <li ><a data-toggle="tab" href="#email">E-mail</a></li>
                   <li><a data-toggle="tab" href="#sms">SMS</a></li>
                   <li><a data-toggle="tab" href="#xmpp">XMPP</a></li>
                   <li><a data-toggle="tab" href="#firebase">FireBase Push</a></li>
                 </ul>

                 <div class="tab-content" style="border: solid 1px; border-color: #e5e6e9 #dfe0e4 #d0d1d5; border-radius: 3px; background: #FFF; padding: 10px;">
                     
                   <div id="geral" class="tab-pane fade in active">
                     <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> ID de Aplica&ccedil;&atilde;o:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="appID" placeholder="ID de Aplica&ccedil;&atilde;o" required="" value="<%=configuration.get("appID")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Acess Point An&uacute;ncio:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="urlAnuncio" placeholder="Acess Point An&uacute;ncio" required="" value="<%=configuration.get("urlAnuncio")%>" />
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Acess Point Autentica&ccedil;&atilde;o:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="UrlUserAPI" placeholder="Acess Point Autentica&ccedil;&atilde;o" required="" value="<%=configuration.get("UrlUserAPI")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Acess Point Post Publicidade:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="urlPublicidade" placeholder="Acess Point Post Publicidade" required="" value="<%=configuration.get("urlPublicidade")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;
                                    <label for="exampleInputFile"> Pasta Imagem:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="ImagesPath" placeholder="Pasta Imagem:" required="" value="<%=configuration.get("ImagesPath")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> URL HTTP imagem:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="imagesHTTPurl" placeholder="URL HTTP imagem" required="" value="<%=configuration.get("imagesHTTPurl")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Acess Point Autentica&ccedil;&atilde;o:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="URLAutenticacao" placeholder="Acess Point Autenticacao" required="" value="<%=configuration.get("URLAutenticacao")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> ID para Admin:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="AppUserIDAdmin" placeholder="ID para Admin" required="" value="<%=configuration.get("AppUserIDAdmin")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;
                                    <label for="exampleInputFile"> Riak Port:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="RiakPort" placeholder="Riak Port" required="" value="<%=configuration.get("RiakPort")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Riak Server:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="RiakUrlServer" placeholder="Riak Server" required="" value="<%=configuration.get("RiakUrlServer")%>"/>
                                </td>
                            </table>
                        </div>
                   </div>
                   <div id="email" class="tab-pane fade">
                        <div>
                            <table width="60%">
                                <td align="right">
                                    <label for="exampleInputFile"> Servidor SMTP:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="host" placeholder="Servidor" required="" value="<%=configuration.get("host")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Utilizador:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="user" placeholder="Utilizador" required="" value="<%=configuration.get("user")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Password:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="password" class="form-control" name="password" placeholder="Password" required="" value="<%=configuration.get("password")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">
                                    <label for="exampleInputFile"> Assunto E-mail:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="subject" placeholder="Assunto" required="" value="<%=configuration.get("subject")%>"/>
                                </td>
                            </table>
                        </div>
                   </div>
                   <div id="sms" class="tab-pane fade">
                     <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> URL SMS:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="URL_SMS" placeholder="URL SMS" required="" value="<%=configuration.get("URL_SMS")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Utilizador:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="USER_SMS" placeholder="Utilizador" required="" value="<%=configuration.get("USER_SMS")%>"/>
                                </td>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Acess Token:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="KEY_SMS" placeholder="Acess Token SMS" required="" value="<%=configuration.get("KEY_SMS")%>"/>
                                </td>
                            </table>
                        </div>
                   </div>
                   <div id="xmpp" class="tab-pane fade">
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Utilizador:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="USER_XMPP" placeholder="Utilizador" required="" value="<%=configuration.get("USER_XMPP")%>"/>
                                </td>
                            </table>
                        </div> <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile">Password:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="password" class="form-control" name="KEY_XMPP" placeholder="Pasword XMPP" required="" value="<%=configuration.get("KEY_XMPP")%>"/>
                                </td>
                            </table>
                        </div><br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile"> Servidor:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="Server_XMPP" placeholder="Servidor" required="" value="<%=configuration.get("Server_XMPP")%>"/>
                                </td>
                            </table>
                        </div> <br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile">Aplica&ccedil;&atilde;o:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="Aplication_XMPP" placeholder="Aplica&ccedil;&atilde;o XMPP" required="" value="<%=configuration.get("Aplication_XMPP")%>"/>
                                </td>
                            </table>
                        </div><br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile">Porta:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="Port_XMPP" placeholder="Porta" required="" value="<%=configuration.get("Port_XMPP")%>"/>
                                </td>
                            </table>
                        </div>
                   </div>
                    <div id="firebase" class="tab-pane fade">
                     <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile">Acess Token:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="serverKeyFirebase" placeholder="Acess Token" required="" value="<%=configuration.get("serverKeyFirebase")%>"/>
                                </td>
                            </table>
                        </div><br/>
                        <div>
                            <table width="60%">
                                <td align="right">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <label for="exampleInputFile">Url Server:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="UrlFirebase" placeholder="Url Server" required="" value="<%=configuration.get("UrlFirebase")%>"/>
                                </td>
                            </table>
                        </div><br/>
                        <div>
                            <table width="60%">
                                <td align="right">
                                    <label for="exampleInputFile">Title Push Notification:</label>&nbsp;&nbsp;
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="titlePushNotification" placeholder="Title Push Notification" required="" value="<%=configuration.get("titlePushNotification")%>"/>
                                </td>
                            </table>
                        </div>
                   </div>
                 </div>
              <div>
                  <div class="modal-footer">
                    <a href="<%=EnumString.getNamePageByNumber(1)%>">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                    </a>
                    <button type="submit" name="guardar" class="btn btn-primary">Guardar</button>
                  </div>
                  <!--<table>
                      <td>
                         <input type="submit" value="&nbsp;&nbsp;Save" class="btn btn-default submit" style="background: url('images/save.png');background-position:left;background-repeat:no-repeat"/>
                          <input type="Button" value="&nbsp;&nbsp; Cancelar" class="btn btn-default submit" style="background: url('images/cancel.png');background-position:left;background-repeat:no-repeat"/>
                      </td>
                  </table>-->
              </div>
            </form>
        <% 
          }
        %>
        <div class="clearfix"></div>

              <div class="separator">
                <div class="clearfix"></div>
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
  </body>
</html>
