<%-- 
    Document   : user.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="java.util.List"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.mtutucv.ObterDados"%>
<%@page import="com.mtutucv.EnumString"%>
<%@page import="com.mtutucv.Library"%>
<%@page import="com.mtutucv.FilesConfig"%>
<!DOCTYPE html>
<html lang="pt">
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
    String [] vars = {"","","","","","#"}; // 0 - Logo 1 - NomeUser 2 - autKey  3 - resultado 4 - inicioLink 
    
    if (!Library.checkSession(session.getAttribute("nome")))
    {
             response.sendRedirect("index.jsp");
    }
    else 
    {
        JSONObject obj = Library.getUserInfo(session.getAttribute("appuser_id").toString());
        if(obj != null)
        {
            if(obj.get("perfil").toString().equals("Administrator"))
            {
                auth=1; 
                vars[4] ="dashbord1.jsp";
            }
            else if(obj.get("perfil").toString().equals("Empresa"))
            {
                auth=2;
                vars[4] ="empresa.jsp";
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
      String [] link = dados.getLink(); // Obter links da pagina
      //String [] topEmpresas = dados.getTopEmpresas(); //Obter ranking das empresas anunciadas
      //String [] textoValores = dados.getTextoValores(); //obter texto dos dados a apresentar
      //int [] percentagemtopEmpresas = dados.getPercentagemtopEmpresas(); // apresentar o dado estatistico das empresas anunciantes
      //int [] valores = dados.getValores(); // obter dados estatistico dos textos apresentados
      //int [] percemtagemValores =dados.getPercemtagemValores(); // obter dados das percentagens diarias e semanais de cada dado estatistico
      
    %>
<div class="container body">
<div class="main_container">
<div class="col-md-3 left_col">
  <div class="left_col scroll-view">
    <div class="navbar nav_title" style="border: 0;">
      <a href="<%=vars[4] %>" class="site_title"><i class="fa fa-plane"></i> <span>AirportPub</span></a>
    </div>

    <div class="clearfix"></div>

    <!-- menu profile quick info -->
    <jsp:include page="menu.jsp">
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
   <div>
   <span href="#" class="site_title" style="color:#000 !important;">
      <i class="fa fa-user-plus" style="border: 1px solid #2a3f54; color:#000 !important;"></i> <span>Utilizadores</span></span>
  </div>
  <div class="separator"></div>

  <div class="row" style="border: solid 1px; border-color: #e5e6e9 #dfe0e4 #d0d1d5; border-radius: 3px; background: #FFF; padding: 10px;">
            	
<table id="TableDados" class="table table-striped table-bordered" cellspacing="0">
    <thead class="thead-inverse">
        <tr>
          <th>Nome</th>
          <th>Social ID</th>
          <th>Alterar perfil</th>
        </tr>
    </thead>
    <tbody>
        <tr>
<% 
    if(auth == 1)
        {
         JSONObject obj = Library.getObjFromFile(FilesConfig.userInfoJSON);
         if(obj != null)
         {
             //Apresentar dados no Formulario
            for (Object key : obj.keySet()) 
            {
                String keyStr = (String)key;
                JSONObject valor = (JSONObject) obj.get(keyStr);
                String pf = valor.get("perfil").toString();
                String img="";
                if(pf.equals("Administrator"))
                img="<img src=\"images/admin_icon.jpg\" title=\"Administrador\">";
                else if(pf.equals("Empresa"))
                img="<img src=\"images/empresa.png\" title=\"Empresa\">";
                else
                img="<img src=\"images/anonimo.jpg\" title=\"An&oacute;nimo\">";

     if(!keyStr.equals(session.getAttribute("appuser_id").toString()))
     {
 %>
        <td>
            <%=img%> &nbsp;
            <%=valor.get("nomeCompleto").toString() %>

        </td>
        <td>
            <%=valor.get("socialID").toString() %>
        </td>
        <td>
            <% if( !pf.equals("Administrator"))
            {
            %>
             <span data-id="<%=keyStr%>" data-tipo="Admin" class="actionFor">
                    <img src="images/admin_icon.jpg" title="Administrador">
            </span>&nbsp;&nbsp;
            <% } %>
             <% if( !pf.equals("Empresa"))
            {
            %>
             <span data-id="<%=keyStr%>" data-tipo="Empresa" class="actionFor">
                    <img src="images/empresa.png" title="Empresa">
            </span>&nbsp;&nbsp;
            <% } %>
             <% if( !pf.equals("Anonimo"))
            {
            %>
              <span data-id="<%=keyStr%>" data-tipo="Anonimo" class="actionFor">
             <img src="images/anonimo.jpg" title="An&oacute;nimo">
             </span> 
             <% } 
             %>
        </td>
        </tr>
    <%    }
        }
        }
     }   
     %>
      </tbody>
    </table> 
    <div class="clearfix"></div>

    <!-- footer content -->
    <footer style="margin-left: 0px !important; margin-top: 20px; margin-top: 100px !important;">
      <div class="pull-right">
          AirportPub &copy 2016
      </div>
      <div class="clearfix"></div>
    </footer>
    <!-- /footer content -->
  </div>
</div>
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
        <button type="button" class="btn btn-secondary" id="confirmOK" data-dismiss="modal">Ok</button>
      </div>
    </div>
  </div>
</div>
    <%@include  file="footer.html" %>
  </body>

  <script type="text/javascript">
  
  var id = 0;
  var result='<%=vars[3] %>';

$('#confirmOK').click(function(){
    location.reload();
});

 $(function(){

      $('.actionFor').click(function(){

        id = $(this).attr('data-id');
        tipo = $(this).attr('data-tipo');
        parameter = "";
        
        if (tipo == "Admin"){
            parameter = "admin";
        }
        else if(tipo == "Anonimo")
        {
            parameter = "anonimo";
        }
        else{
            parameter = "empresa";
        }

        $('body').LoadingOverlay("show"); 

        $.ajax({
            url: "update.jsp?"+parameter+"="+id,
            method: "GET",
            success: function(data){
                
                if(Boolean(data) === true)
                   showMSG("success-icon.png","Pefil alterado com Sucesso");
                else if (Boolean(data) === false)
                   showMSG("errorICON.png","N&atilde;o foi possivel alterar o perfil.");
                else 
                   showMSG("alertICON.jpg",result);
            },
            error: function(){
                alert('erro ao alterar perfil ');
            }
        });
      });
  });
</script>

</html>
