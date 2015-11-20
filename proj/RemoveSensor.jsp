<HTML>
<HEAD>
<TITLE>Manage Page</TITLE>
</HEAD>
<BODY>
	<%@ page import="java.sql.*"%>
	<%
	if(request.getParameter("RemoveSensor") != null && ((String)session.getAttribute("role"))!=null){
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
			con.setAutoCommit(false);
		}
		catch(Exception e){
			canConnect = false;
			out.println("<p><b>Unable to Connect Oracle DB!</b></p>");
			out.println("<p><b>Invalid UserName or Password!</b></p>");
			out.println("<p><b>Press Return to the previous page.</b></p>");
			out.println("<FORM NAME='ConnectFailForm' ACTION='Connector.html' METHOD='get'>");
			out.println("    <CENTER><INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='Return'></CENTER>");
			out.println("</FORM>");
    	}
		if(canConnect){
			Statement s=con.createStatement();
			String sqlStatement=null;
			String s_id = request.getParameter("sensor_id");
			ResultSet resSet=null;
			sqlStatement = "DELETE FROM sensors WHERE sensor_id="+s_id;
			resSet = s.executeQuery(sqlStatement);
			con.close();
		}
		response.sendRedirect("administrator.jsp");
	}
	else{
		response.sendRedirect("administrator.jsp");
	}

	
	%>
</BODY>
</HTML>