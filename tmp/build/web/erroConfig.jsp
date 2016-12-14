
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
                    
                    <span class=" fa fa-angle-down"></span>
                  </a>
                  <ul class="dropdown-menu dropdown-usermenu pull-right">
                    
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
              Errro na configuração, ficheiros de configuração JSON (EmpresaInfo, Estatistica, Publicidade, UserInfo config) não foi encontrado
              por favor copia os ficheiros de configuração para a pasta.
              <%=com.mtutucv.FilesConfig.dir%> e volta para o <a href="index.jsp">inicio<a/>
          <div class="clearfix">
              
          </div>
              <div class="separator">
              
            </div>
         
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
