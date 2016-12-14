<%-- 
    Document   : index.jsp
    Created on : Nov 10, 2016, 11:15:13 PM
    Author     : Mario Monteiro
--%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.mtutucv.Library"%>
<!DOCTYPE html>
<html lang="en">
  <head>
  </head>

  <body class="login">
      
    <%
       
        if(!com.mtutucv.Library.chekConfigFileExist())
                response.sendRedirect("erroConfig.jsp"); 
        
        if (com.mtutucv.Library.checkSession(session.getAttribute("nome")))
        {
            if(session.getAttribute("perfil") == null || session.getAttribute("perfil").toString().equals("Anonimo"))
            {
                response.sendRedirect("dashbord2.jsp");
            }
            else if (session.getAttribute("perfil").toString().equals("Empresa"))
            {
                response.sendRedirect("empresa.jsp"); 
            }else
                response.sendRedirect("dashbord1.jsp"); 
        }
    %>
     
      
      <%
          
          try {
                boolean semafaro = false;
                String acess = request.getParameter("access_token");
                JSONObject objUser = null;
                
                if(acess != null)
                {     
                    //Obter dados de Utilizador no Sevidor de autenticacao
                    objUser = com.mtutucv.Library.getUserInfoFromServer(acess);
                    if(objUser != null)
                    {
                            semafaro = true;
                    }
                }
                
                if(semafaro)
                {
                        String userAdmiID = com.mtutucv.Library.getConfig("AppUserIDAdmin");
                        session.setAttribute("auth_key", (objUser.get("access_token")!= null ? objUser.get("access_token").toString() : ""));
                        session.setAttribute("appuser_id", (objUser.get("appuser_id") != null ? objUser.get("appuser_id").toString() : ""));
                        session.setAttribute("nome", (objUser.get("name") != null ? objUser.get("name").toString() : ""));
                        
                        if(userAdmiID.equals(objUser.get("appuser_id").toString()))
                        {
                            session.setAttribute("perfil", "Administrator");
                            session.setAttribute("username", "Admin");
                            
                            JSONObject objListaPermissoes = com.mtutucv.Library.getObjFromFile(com.mtutucv.FilesConfig.userInfoJSON);
                                if(!objListaPermissoes.containsKey(userAdmiID))
                                {
                                    JSONObject aux = new JSONObject();
                                    aux.put("perfil", "Administrator");
                                    aux.put("nomeCompleto", session.getAttribute("nome").toString());
                                    aux.put("socialID", objUser.get("appuser_id").toString());
                                    objListaPermissoes.put(userAdmiID, aux);
                                   //Save to disk
                                   com.mtutucv.Library.SaveJSONToFile(objListaPermissoes,com.mtutucv.FilesConfig.userInfoJSON);
                                }
                        }
                        else{
                            JSONObject obj = com.mtutucv.Library.getUserInfo(objUser.get("appuser_id").toString());
                            session.setAttribute("perfil", obj.get("perfil") != null ? obj.get("perfil").toString() : "Anonimo");
                            
                            //session.setAttribute("username",  (objUser.get("username") != null ? objUser.get("username").toString() : "anonimo"));
                        }
                        
                        session.setAttribute("logo", (objUser.get("profile_url") != null ? objUser.get("profile_url").toString() : ""));
                        session.setAttribute("email", (objUser.get("email") != null ? objUser.get("email").toString():""));
                        
                            if(session.getAttribute("perfil").toString().equals("Anonimo"))
                            {
                                response.sendRedirect("dashbord2.jsp");
                                
                            }if (session.getAttribute("perfil").toString().equals("Empresa"))
                            {
                                response.sendRedirect("empresa.jsp"); 
                            }
                            else
                            {
                                response.sendRedirect("dashbord1.jsp"); 
                            }
                }else{
                    response.sendRedirect("https://0auth.tk/authentication/login?app_id=142422414475142352414121&client_secret=RNjc87EUp7yeNEq32byq5C9oE0YMgPJy2D_F0nVZjDB1YQa1OLO-DIbmv4zqVGwS");
                }
              } catch (Exception e) {
              }
        
        %>
  </body>
</html>
