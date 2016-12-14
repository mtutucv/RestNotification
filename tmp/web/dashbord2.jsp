
<%-- 
    Document   : dashbord2.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="java.util.Arrays"%>
<%@page import="java.lang.reflect.Array"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.mtutucv.ObterDados"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <%@include  file="header.html" %>
  </head>
  
  <body class="nav-md">
   <%
    int auth=0;
    String logo="";
    String NomeUser="";
    String autKey ="";
    
    
    if (!com.mtutucv.Library.checkSession(session.getAttribute("nome")))
    {
             response.sendRedirect("index.jsp");
    }
    else 
    {
        JSONObject obj = com.mtutucv.Library.getUserInfo(session.getAttribute("appuser_id").toString());
        if(obj != null)
        {
            if(obj.get("perfil").toString().equals("Administrator"))
                auth=1;
            else if(obj.get("perfil").toString().equals("Empresa"))
                auth=2;
        }
        else{
            
        }
            autKey = session.getAttribute("auth_key") != null ? session.getAttribute("auth_key").toString() : "";
            logo = session.getAttribute("logo") != null ? session.getAttribute("logo").toString() : "";
            if(obj != null)
                NomeUser = obj.get("nomeCompleto").toString();
            else
                NomeUser = session.getAttribute("nome") != null ? session.getAttribute("nome").toString() : "";
            
            //Adicionar informação ao JSON de permissões
            JSONObject objListaPermissoes = com.mtutucv.Library.getObjFromFile(com.mtutucv.FilesConfig.userInfoJSON);
            JSONObject aux = new JSONObject();
            aux.put("perfil", "Anonimo");
            aux.put("nomeCompleto", session.getAttribute("nome").toString());
            aux.put("socialID", session.getAttribute("appuser_id").toString());
            objListaPermissoes.put(session.getAttribute("appuser_id").toString(), aux);
           //Save to disk
           com.mtutucv.Library.SaveJSONToFile(objListaPermissoes,com.mtutucv.FilesConfig.userInfoJSON);
    }
    %>

<%    

      com.mtutucv.ObterDados dados = new ObterDados(auth,autKey);

      String [] link = dados.getLink(); // Obter links da pagina
      String [] topEmpresas = dados.getTopEmpresas(); //Obter ranking das empresas anunciadas
      String [] textoValores = dados.getTextoValores(); //obter texto dos dados a apresentar
      String [] classValores = new String[6];
      String [] upDownValores = new String[6];
      int [] percentagemtopEmpresas = dados.getPercentagemtopEmpresas(); // apresentar o dado estatistico das empresas anunciantes
 
      int [] valores = dados.getValores(); // obter dados estatistico dos textos apresentados
      String [] percemtagemValores =dados.getPercemtagemValores(); // obter dados das percentagens diarias e semanais de cada dado estatistico
      //obter informação sobre colocar as classes a vermelho ou butom up dow conforme os valores vao aumentando ou diminuindo
      String [][] resultUpDowClass = com.mtutucv.Library.getClassUpDownValoresEstatisitica(valores,classValores,upDownValores);
 
      classValores = resultUpDowClass[0];
      upDownValores = resultUpDowClass [1];
      
    %>
    <div class="container body">
      <div class="main_container">
        <div class="col-md-3 left_col">
          <div class="left_col scroll-view">
            <div class="navbar nav_title" style="border: 0;">
              <a href="dashbord2.jsp" class="site_title"><i class="fa fa-plane"></i> <span>AirportPub</span></a>
            </div>

            <div class="clearfix"></div>

            <!-- menu profile quick info -->
            <jsp:include page="menu.jsp">
                    <jsp:param name="logo" value="<%= logo %>" />
                    <jsp:param name="perfil" value="<%= auth %>" />
                    <jsp:param name="NomeUser" value="<%= NomeUser %>" />
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
                    <img src="<%= logo %>" alt=""><%= NomeUser %>
                    <span class=" fa fa-angle-down"></span>
                  </a>
                  <ul class="dropdown-menu dropdown-usermenu pull-right">
                    <li><a href="logout.jsp"><i class="fa fa-sign-out pull-right"></i> Log Out</a></li>
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
          <div style="border: 0;background: #2a3f54;">
              <a href="#" class="site_title"><i class="fa fa-lock"></i> <span>Area restrita</span></a>
          </div>
          <div class="clearfix">
              
          </div>
              <div class="separator">
              
            </div>
          <center><img src="images/restrito.png" height="400" width="550"></center>
          </div>
        <!-- /page content -->

        <!-- footer content -->
        <footer>
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
</html>
