<HTML>
	<HEAD>
		<TITLE>DB Connection Handle Page</TITLE>
	</HEAD>
	<BODY>
		<%@ page import="java.sql.*" %>
		<%
			if(request.getParameter("CONNECT")!=null){
					String oracleId=(request.getParameter("ORACLE_ID")).trim();
	        		String oraclePassword=(request.getParameter("ORACLE_PASSWORD")).trim();
	        		session.setAttribute("ORACLE_ID",oracleId);
	        		session.setAttribute("ORACLE_PASSWORD",oraclePassword);
	       	 		Connection con = null;
	        		String driverName = "oracle.jdbc.driver.OracleDriver";
        			String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
        			try{
        				Class drvClass = Class.forName(driverName);
						DriverManager.registerDriver((Driver)drvClass.newInstance());
        				con = DriverManager.getConnection(dbstring,oracleId,oraclePassword);
         				con.setAutoCommit(false);
        			}
        			catch(Exception e){
        				out.println("<p><b>Unable to Connect Oracle DB!</b></p>");
        				out.println("<p><b>Invalid UserName or Password!</b></p>");
        				out.println("<p><b>Press RETURN to the previous page.</b></p>");
            			out.println("<FORM NAME='ConnectFailForm' ACTION='Connector.html' METHOD='get'>");
            			out.println("    <CENTER><INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='RETURN'></CENTER>");
            			out.println("</FORM>");
        			}
        			if(con != null){
						try {
							con.close(); 
						}
						catch (Exception e) {
							e.printStackTrace();
						}
						response.sendRedirect("Login.html"); 
        			}
					
			}
		%>
	</BODY>
</HTML>
