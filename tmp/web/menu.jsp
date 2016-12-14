<%-- 
    Document   : menu.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<div class="profile">
             
            </div>
            <!-- /menu profile quick info -->
            <br />
            <!-- sidebar menu -->
            <div id="sidebar-menu" class="main_menu_side hidden-print main_menu">
              <div class="menu_section">
                 
                <ul class="nav side-menu">
                     <% if(request.getParameter("perfil").toString().equals("1"))
                  {
                   %>
                    <li><a><i class="fa fa-home"></i> In&iacute;cio <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                      <li><a href="<%= request.getParameter("link1")%>"><i class="fa fa-area-chart"></i>Dashboard</a></li>
                    </ul>
                  </li>
                <% } %>
                <% if(request.getParameter("perfil").toString().equals("1") || request.getParameter("perfil").toString().equals("2"))
                  {
                   %>
                  <li><a><i class="fa fa-edit"></i> Op&ccedil;&otilde;es <span class="fa fa-chevron-down"></span></a>
                    <ul class="nav child_menu">
                  
                      <li><a href="<%= request.getParameter("link2") %>"><i class="fa fa-newspaper-o"></i>An&uacute;ncio</a></li>
                      <li><a href="<%= request.getParameter("link3") %>"><i class="fa fa-university"></i>Empresa</a></li>
                  
                  <% if(request.getParameter("perfil").toString().equals("1"))
                  {
                   %>
                      <li><a href="<%= request.getParameter("link4") %>"><i class="fa fa-user-plus"></i>Utilizador</a></li>
                      <li><a href="<%= request.getParameter("link5") %>"><i class="fa fa-cog"></i>Configura&ccedil;&otilde;es</a></li>
               <% } %>
                    </ul>
                  </li>
            <% } %>  
                </ul>
              </div>
            </div>


