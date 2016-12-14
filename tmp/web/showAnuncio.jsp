<%-- 
    Document   : showAnuncio.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.mtutucv.EnumString"%>
<%@page import="com.mtutucv.Library"%>
<%@page import="com.mtutucv.Publicidade"%>
<%@page import="com.mtutucv.ObterDados"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <%@include  file="header.html" %>
  </head>
  <body class="nav-md">
<%
    int auth=0;
    String [] vars = {"","","","","#"}; // 0 - Logo 1 - NomeUser 2 - autKey  3 - loginLogout 4  - inicioLink 6 - controlSaldoCredito
    if (Library.checkSession(session.getAttribute("nome"))) 
    {
        JSONObject obj = Library.getUserInfo(session.getAttribute("appuser_id").toString());

        if(obj != null)
        {
            if(obj.get("perfil").toString().equals(EnumString.getPerfilByNumber(1)))
            {
                auth=1;
                vars[4] =EnumString.getNamePageByNumber(1);
            }
            else if(obj.get("perfil").toString().equals(EnumString.getPerfilByNumber(2)))
            {
                auth=2;
                 vars[4] =EnumString.getNamePageByNumber(3);
            }else
                response.sendRedirect(EnumString.getNamePageByNumber(6));

            vars[2] = session.getAttribute("auth_key").toString();
            vars[0]=session.getAttribute("logo").toString();
            vars[1]=obj.get("nomeCompleto").toString();
        }
     vars[3]="Log Out";

    }
    else 
    {
     vars[0] ="images/user.png";
     vars[1]="An&oacute;nimo";
     vars[3]="Login";
    }
   
  com.mtutucv.ObterDados dados = new ObterDados(auth,vars[2]);
  String [] link = dados.getLink(); // Obter links da pagina
%>

<div class="container body">
<div class="main_container">
<div class="col-md-3 left_col">
  <div class="left_col scroll-view">
    <div class="navbar nav_title" style="border: 0;">
      <a href="<%= vars[4] %>" class="site_title"><i class="fa fa-plane"></i> <span>AirportPub</span></a>
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
            <li><a href="<%=EnumString.getNamePageByNumber(7)%>"><i class="fa fa-sign-out pull-right"></i><%= vars[3] %></a></li>
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
<% 
  String [] infoAnuncio = {"","","","",""}; 
if(request.getParameter("id")!= null)
{
    //procurar a publicidade de acordo com o ID
    Publicidade publ = Publicidade.getPublicidade(request.getParameter("id").toString());

    if(publ != null)
    {
      infoAnuncio[1]= publ.getTitulo();
      infoAnuncio[2]= publ.getDescricaoTexto();
      infoAnuncio[0]= publ.getImagemFileUrl();
      infoAnuncio[3]= publ.getVideoFileUrl();
      infoAnuncio[4]= publ.getEmpresa();
    }
    else
    {
        infoAnuncio[0] ="http://192.168.160.104/WebServicesREST/images/bannerPublicitario/airport.jpg";
        infoAnuncio[1]="Avan&ccedil;o Cabo Verde";
        infoAnuncio[2]="Amplia a imagem da sua empresa com uma das melhores aplicações de publicidade do pais, que pode alcançar os seus clientes em qualquer parte do mundo.";
        infoAnuncio[3]="https://www.youtube.com/embed/TRgZngAsvdk";
        infoAnuncio[4]="AirportPub";
    }
}
%>
<br></br>
<h3 style="padding-top: 20px;">
<%= infoAnuncio[4] %>
</h3>

<div class="well" style="padding: 5px !important; background: #FFF;">
    <p><%=infoAnuncio[2]%></p>
</div>

<div class="row">
    <div class="col-md-5">

        <div class="panel panel-default">
            <div class="panel-heading">
                <%= infoAnuncio[1] %>
            </div>
                <% 
                if(infoAnuncio[0].contains("http"))
                     infoAnuncio[0]=Library.getImageFromHTTP(infoAnuncio[0]);
            {
            %>
            <div class="panel-body">
                <img src="<%=infoAnuncio[0] %>" class="img-thumbnail" style="height: auto;  width: auto;">
            </div>
          <%}%>
            <div class="panel-footer">
            </div>
        </div>
    </div>  
    <% if(infoAnuncio[3].contains("http"))
    {   
        if(infoAnuncio[3].contains("watch") && infoAnuncio[3].contains("="))
            infoAnuncio[3] = "https://www.youtube.com/embed/"+infoAnuncio[3].split("=")[1];
    %>
    <div class="col-md-7">
        <div class="panel panel-default">
            <div class="panel-heading">
                Ver Vídeo
            </div>
            <div class="panel-body">
                <div class="embed-responsive embed-responsive-16by9">
                                                <iframe class="embed-responsive-item" src="<%=infoAnuncio[3] %>"></iframe>

                                            </div>
            </div>
            <div class="panel-footer">

            </div>
        </div>
    </div>
 <% } %> 
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
