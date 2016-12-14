<%-- 
    Document   : logout.jsp
    Created on : Oct 21, 2016, 2:00:36 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logout</title>
    </head>
    <body>
        <%
            session.setAttribute("auth_key", null);
            session.setAttribute("estado", null);
            session.setAttribute("nome", null);
            session.setAttribute("perfil", null);
            session.setAttribute("logo", null);
            session.setAttribute("email", null);
            //session.setAttribute("username",null);
            session.invalidate();
            response.sendRedirect("https://0auth.tk/authentication/login?app_id=142422414475142352414121&client_secret=RNjc87EUp7yeNEq32byq5C9oE0YMgPJy2D_F0nVZjDB1YQa1OLO-DIbmv4zqVGwS");
        %>
    </body>
</html>
