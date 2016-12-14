<link rel="stylesheet" type="text/css" href="css/style.css" />
 <script src="http://instant.0auth.tk:8080/socket.io/socket.io.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.5.7/angular.min.js"></script>
<%-- 
    Document   : dashbord1.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="java.lang.reflect.Array"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.mtutucv.ObterDados"%>
<%@page import="com.mtutucv.EnumString"%>
<%@page import="com.mtutucv.Library"%>
<%@page import="com.mtutucv.FilesConfig"%>
<!DOCTYPE html>
<html lang="pt">
  <head>
   <%@include  file="header.html" %>
    <%
        int anoSend;
        JSONObject configuration =  Library.getObjFromFile(FilesConfig.configJSON);;
        if(request.getParameter("anoSelecionado") == null)
        {
            GregorianCalendar cal = new GregorianCalendar();
            anoSend=cal.get(Calendar.YEAR);
        }else
        {
            anoSend = Integer.parseInt(request.getParameter("anoSelecionado").toString());
        }
        String urlN="";
        if(session.getAttribute("auth_key") != null)
         urlN = configuration.get("urlAnuncio")+ "getTotalAdvertisementsPerMonthPerYear/"+anoSend+"/"+configuration.get("appID")+"/"+session.getAttribute("auth_key").toString();   
    %>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

	<script type="text/javascript">

		function reload() {
                 location.reload();
            }
            
     function drawChart2(linkAPI){
		 $.ajax({
			type: "GET",
			url: linkAPI,
			dataType: "jsonp",
			success: function(data) {
				var dadosMeses;
				var result = JSON.parse(data.getTotalAdvertisementsPerMonthPerYearResult);
				
					var meses = [0,0,0,0,0,0,0,0,0,0,0,0];
				   for(var i = 0; i < result.length;i++)
					{
						for(var y=0; y < 12; y++)
						{
							if(result[i].mes == y+1)
							{
								meses[y] = result[i].pubCout;
								break;
							}
						}
					}
					dadosMeses = [meses[0], meses[1], meses[2],meses[3],meses[4],meses[5],meses[6],meses[7],meses[8],meses[9],meses[10],meses[11]];
				drawChart(dadosMeses);
				},
			error: function (xhr, ajaxOptions, thrownError) {
			  alert(xhr.status);
			  alert(thrownError);
			}
			}) 
		 }
                 
     var linkAPI="<%=urlN%>";
    //Tempo para recarrecar de novo a pagina 
    //setTimeout(reload, 9000);
    
    google.charts.load("current", {packages:['corechart']});
    google.charts.setOnLoadCallback(function() { drawChart2(linkAPI); });
    
    function drawChart(dadosMeses) {
         var color = '#1abb9c';
		 
      var data2 = google.visualization.arrayToDataTable([
        ["Element", "Numero Anuncio", { role: "style" } ],
        ["Jan", dadosMeses[0], color],
        ["Fev", dadosMeses[1], color],
        ["Mar", dadosMeses[2], color],
        ["Abr", dadosMeses[3], color],
        ["Mai", dadosMeses[4], color],
        ["Jun", dadosMeses[5], color],
        ["Jul", dadosMeses[6], color],
        ["Ago", dadosMeses[7], color],
        ["Set", dadosMeses[8], color],
        ["Out", dadosMeses[9], color],
        ["Nov", dadosMeses[10], color],
        ["Dez", dadosMeses[11], color]
      ]);

      var view = new google.visualization.DataView(data2);
      view.setColumns([0, 1,
                       { calc: "stringify",
                         sourceColumn: 1,
                         type: "string",
                         role: "annotation" },
                       2]);
        var largura= $('.principal').width(); 
        var altura= $('.principal_1').height();
      var options = {
        title: "Quantidade de Anúncios por Meses",
        width: largura,
        height: 350,
        bar: {groupWidth: "95%"},
        legend: { position: "none" },
      };
      var chart = new google.visualization.ColumnChart(document.getElementById("columnchart_values"));
      chart.draw(view, options);
  }
  
 
  
   var app = angular.module("DasApp", [])
        
        app.controller("DashBoardController", function($scope){
            
            $scope.model = {
                report_type:"GET_USER_COUNT", filter:false, num_users:0,
                total_male:0, total_female:0, total_nao_definido:0 }
			    
			$scope.modelUsersActive = { total:0, fb:0, im:0, ge:0, }
			
			if(!io) 
				reload();
			
            var socket = io.connect("http://instant.0auth.tk:8080");
            
            socket.on('stats userscount', function(data){
               
                $scope.model.report_type = data._data.report_type
                $scope.model.filter = data._data.filter
                $scope.model.num_users = data._data.total
                $scope.model.total_male = data._data.total_male
                $scope.model.total_female = data._data.total_female
                $scope.model.total_nao_definido = data._data.total_nao_definido
                
                //console.log($scope.model)
                $scope.$apply()
            })
            
            socket.on('stats usersactivecount', function(data){
               
                $scope.modelUsersActive.total = data._data.total
                $scope.modelUsersActive.fb = data._data.fb
                $scope.modelUsersActive.im = data._data.im
                $scope.modelUsersActive.ge = data._data.ge
                //console.log($scope.modelUsersActive)
                $scope.$apply()
            })
            
            //console.log("Dash App")
        })
		
	
		
		
  </script>
  </head>
  
  <body class="nav-md" style="" ng-app="DasApp" ng-controller="DashBoardController">
  
	
   <%
    int auth=0;
    String logo="";
    String NomeUser="";
    String autKey ="";
	
	String total = "{{model.num_users}}";
	String total_male = "{{model.total_male}}";
	String total_female = "{{model.total_female}}";
	String total_nao_definido = "{{model.total_nao_definido}}";
    
    if (!Library.checkSession(session.getAttribute("nome")))
    {
             response.sendRedirect(EnumString.getNamePageByNumber(8));
    }
    else 
    {
        
        JSONObject obj = Library.getUserInfo(session.getAttribute("appuser_id").toString());
        if(obj != null)
        {
            if(obj.get("perfil") != null && obj.get("perfil").toString().equals(EnumString.getPerfilByNumber(1)))
                auth=1;
            else if(obj.get("perfil") != null && obj.get("perfil").toString().equals(EnumString.getPerfilByNumber(2)))
                auth=2;
            else
                 response.sendRedirect(EnumString.getNamePageByNumber(6));
        }
        else{
            //Adicionar informação ao JSON de permissões
            JSONObject objListaPermissoes = Library.getObjFromFile(FilesConfig.userInfoJSON);
            JSONObject aux = new JSONObject();
            aux.put("perfil", EnumString.getPerfilByNumber(3));
            aux.put("nomeCompleto", session.getAttribute("nome").toString());
            aux.put("socialID", session.getAttribute("appuser_id").toString());
            objListaPermissoes.put(session.getAttribute("appuser_id").toString(), aux);
           //Save to disk
           Library.SaveJSONToFile(objListaPermissoes,FilesConfig.userInfoJSON);
        }
            autKey = session.getAttribute("auth_key") != null ? session.getAttribute("auth_key").toString() : "";
            logo = session.getAttribute("logo") != null ? session.getAttribute("logo").toString() : "";
            if(obj != null)
                NomeUser = obj.get("nomeCompleto") != null ? obj.get("nomeCompleto").toString() : "No Name";
            else
                NomeUser = session.getAttribute("nome") != null ? session.getAttribute("nome").toString() : "";
    }
    %>

<%    
      ObterDados dados = new ObterDados(auth,autKey);

      String [] link = dados.getLink(); // Obter links da pagina
      String [] topEmpresas = dados.getTopEmpresas(); //Obter ranking das empresas anunciadas
      String [] textoValores = dados.getTextoValores(); //obter texto dos dados a apresentar
      String [] classValores = new String[6];
      String [] upDownValores = new String[6];
      int [] percentagemtopEmpresas = dados.getPercentagemtopEmpresas(); // apresentar o dado estatistico das empresas anunciantes
       int [] valores = dados.getValores(); // obter dados estatistico dos textos apresentados
      String [] percemtagemValores =dados.getPercemtagemValores(); // obter dados das percentagens diarias e semanais de cada dado estatistico
 
      String [] valores1 = {
		  "{{model.num_users}}","{{model.total_male}}","{{model.total_female}}","{{model.total_nao_definido}}",String.valueOf(valores[4]),String.valueOf(valores[5])
	  }; // obter dados estatistico dos textos apresentados
      
      //obter informação sobre colocar as classes a vermelho ou butom up dow conforme os valores vao aumentando ou diminuindo
      String [][] resultUpDowClass = Library.getClassUpDownValoresEstatisitica(valores,classValores,upDownValores);
 
      classValores = resultUpDowClass[0];
      upDownValores = resultUpDowClass [1];
      
    %>
    <div class="container body">
      <div class="main_container">
        <div class="col-md-3 left_col">
          <div class="left_col scroll-view">
            <div class="navbar nav_title" style="border: 0;">
              <a href="<%=EnumString.getNamePageByNumber(1)%>" class="site_title"><i class="fa fa-plane"></i> <span>AirportPub</span></a>
            </div>
            <div class="clearfix"></div>
            <!-- menu profile quick info -->
            <jsp:include page="<%=EnumString.getNamePageByNumber(11)%>">
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
              <span href="#" class="site_title" style="color:#000 !important;">
			         <i class="fa fa-area-chart" style="border: 1px solid #2a3f54; color:#000 !important;"></i> <span>Dashboard</span></span>
          </div>
          <div class="clearfix"></div>
              <div class="separator">
            <div class="clearfix"></div>
          <div class="row tile_count">
              <%
                  for(int i=0;i<valores.length;i++)
                  {
               %>
	
            <div class="col-md-2 col-sm-4 col-xs-6 tile_stats_count">
              <span class="count_top"><i class="fa fa-user"></i> <%= textoValores[i] %></span>
              <div class="count"><i class="<%=classValores[i]%>"><%= valores1[i] %></i></div>
              <span class="count_bottom"><i class="<%=classValores[i]%>"><i class="fa <%=upDownValores[i]%>"></i><%= percemtagemValores[i] %>% </i> &Uacute;ltima Semana</span>
            </div>
              <%
              }
              %>
          </div>
          <!-- /top tiles -->

          <div class="row">
            <div class="col-md-12 col-sm-12 col-xs-12 principal_1">
              <div class="dashboard_graph" style="border: solid 1px; border-color: #e5e6e9 #dfe0e4 #d0d1d5; border-radius: 3px;">

                <div class="row x_title">
                  <div class="col-md-6">
                      <label class="ap--active-users-label" title="Online Users:">Utilizadores Ativos:</label>
					  <a href="https://admin.0auth.tk/index.php?r=auth%2Findex&access_token=_V5gp6rn2eKO729GOc3prlZfxd0lsrMT_V4gp6rn2eKO729GOc3prlZfxd0lsrMT_V4gp6rn2eKO729GOc3prlZfxd" target="_blank">
                      <i  class="ap--active-users-value">
					  {{modelUsersActive.total}}
                      </i>
					  </a>
                  </div>
                    <form method="POST" action="<%=EnumString.getNamePageByNumber(1)%>">
                        <div class="col-md-6">
                           
                    <div id="" class="pull-right" style="background: #fff; cursor: pointer; padding: 5px 10px; border: 1px solid #ccc">
                        <i class="glyphicon glyphicon-calendar fa fa-calendar"></i>
                        <select style="border: 0" onchange="drawChart2(this.value)" name="anoSelecionado">
                            <%
                                if(request.getParameter("anoSelecionado") != null)
                                {
                                    String urlS = configuration.get("urlAnuncio")+ "getTotalAdvertisementsPerMonthPerYear/"+anoSend+"/"+configuration.get("appID")+"/"+autKey;
                            %>
                                <option value="<%=urlS%>">
                               1 Janeiro, <%=anoSend%> - 30 Dezembro , <%=anoSend%> 
                                </option>
                            <%
                                
                                }
                                for(int i=2016;i > 2012;i--)
                                {
                                    String urlS = configuration.get("urlAnuncio")+ "getTotalAdvertisementsPerMonthPerYear/"+i+"/"+configuration.get("appID")+"/"+autKey;
                            %>
                            <option value="<%=urlS %>">
                               1 Janeiro, <%=i %> - 30 Dezembro , <%=i %> 
                            </option>
                            <% } %>
                        </select>
                        
                    </div>
                  </div>
                 </form>
                </div>
                 
                <div class="row">
                    <div class="col-md-8 col-sm-8 col-xs-12 principal">
                   
                        <div id="columnchart_values" ></div>
                   </div>

                    <div class="col-md-4 col-sm-4 col-xs-4 bg-white">
                        <div class="col-md-12 col-sm-12 col-xs-6">
                            <div class="x_title">
                            <h2>Top empresas an&uacute;nciantes</h2>
                            <div class="clearfix"></div>
                          </div>
                            <%
                                for(int i=0; i< topEmpresas.length; i++)
                                {
                                    if(percentagemtopEmpresas[i] > 0)
                                    {
                            %>
                          <div>
                              <p><%= topEmpresas[i] %>( <b><%= percentagemtopEmpresas[i] %></b> An&uacute;ncios)</p>
                            <div class="">
                              <div class="progress progress_sm" style="width: 76%;">
                                <div class="progress-bar bg-green" role="progressbar" data-transitiongoal="<%= percentagemtopEmpresas[i] %>"></div>
                              </div>
                            </div>
                          </div>
                              <%    }
                                }
                              %>
                        </div>

                    </div>
                </div>
                <div class="clearfix"></div>
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
</html>

