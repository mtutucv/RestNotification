<%-- 
    Document   : getImage
    Created on : Nov 17, 2016, 10:50:53 PM
    Author     : Admin
--%>

<%@page import="java.io.OutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
            if(request.getParameter("img") != null)
            {
                try
                {
                    ServletContext cntx= request.getServletContext();
                    // Get the absolute path of the image
                    String filename = cntx.getRealPath(request.getParameter("img").toString());
                    // retrieve mimeType dynamically
                    String mime = cntx.getMimeType(filename);
                    
                    response.setContentType(mime);
                    File file = new File(filename);
                    response.setContentLength((int)file.length());

                    FileInputStream in = new FileInputStream(file);
                    OutputStream out1 = response.getOutputStream();

                    // Copy the contents of the file to the output stream
                     byte[] buf = new byte[1024];
                     int count = 0;
                     while ((count = in.read(buf)) >= 0) {
                       out1.write(buf, 0, count);
                    }
                  out1.close();
                  in.close();
                  } catch (IOException e) {
                  }
            }


%>