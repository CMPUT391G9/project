<HTML>
<HEAD>
<TITLE>Manage Page</TITLE>
</HEAD>
<BODY>
	<%@ page import="java.sql.*"%>
	<%
	if(request.getParameter("Remove") != null){
		String oracleId = (String)session.getAttribute("ORACLE_ID");
		String oraclePassword = (String)session.getAttribute("ORACLE_PASSWORD");
		Connection con = null;
		String driverName = "oracle.jdbc.driver.OracleDriver";
		String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
		Boolean canConnect = true;
		try{
			Class drvClass = Class.forName(driverName);
			DriverManager.registerDriver((Driver)drvClass.newInstance());
			con = DriverManager.getConnection(dbstring,oracleId,oraclePassword);
			con.setAutoCommit(true);
		}
		catch(Exception e){
			canConnect = false;
			out.println("<p><b>Unable to Connect Oracle DB!</b></p>");
			out.println("<p><b>Invalid UserName or Password!</b></p>");
			out.println("<p><b>Press RETURN to the previous page.</b></p>");
			out.println("<FORM NAME='ConnectFailForm' ACTION='Connector.html' METHOD='get'>");
			out.println("    <CENTER><INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='RETURN'></CENTER>");
			out.println("</FORM>");
    	}
		if(canConnect){
			boolean abort=false;
			String person_id=request.getParameter("person_id").trim();
			try{
				String sqlStatement="DELETE from persons where person_id = person_is"+person_id;
				if(abort==false){
					con.close();
					response.sendRedirect("administrator.jsp"); 
				}
			}
			catch(Exception e){
				out.println("<HR><CENTER>"+e.getMessage()+"<CENTER></HR>");
				out.println("<FORM NAME='AbortForm' ACTION='administrator.jsp' METHOD='get'>");
				out.println("<INPUT TYPE='hidden' NAME='ID' VALUE='"+person_id+"'>");
				out.println("    <CENTER><INPUT TYPE='submit' NAME='Return' VALUE='Return'></CENTER>");
				out.println("</FORM>");
				if(con!=null){
					con.close();
				}
			}
		}
	}
	%>
</BODY>
</HTML>