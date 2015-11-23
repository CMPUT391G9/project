<HTML>
<HEAD>
	<TITLE>Subscribe Page</TITLE>
</HEAD>
<BODY>
	<%@ page import="java.sql.*"%>
	<%@ page import="java.util.*"%>
	<%
	if(request.getParameter("SubscribeComm") != null){
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
			String SensorId=request.getParameter("sensor_id");
			String PersonId=request.getParameter("person_id");

			Long time=(new java.util.Date()).getTime();
				
			String current=(new java.sql.Date(time)).toString();
				
			Statement s=con.createStatement();
			String sqlStatement1 = "alter SESSION set NLS_DATE_FORMAT = 'YYYY-MM-DD'";
			String sqlStatement2="INSERT INTO subscriptions VALUES('"+SensorId+"','"+PersonId+"')";
			s.executeQuery(sqlStatement1);
			try{
				s.executeQuery(sqlStatement2);
				con.close();
				response.sendRedirect("scientist.jsp"); 
			}
			catch(Exception e){
				out.println("<p><b>"+e.getMessage()+"</b></p>");
				out.println("<p><b>Press RETURN to the previous page.</b></p>");
				out.println("<FORM NAME='AbortForm' ACTION='Subscribe.jsp' METHOD='get'>");
				out.println("    <CENTER><INPUT TYPE='submit' NAME='AddSensor' VALUE='Back'></CENTER>");
				out.println("</FORM>");
				con.close();
			}
		}
	}
	else{
		out.println("<p><b>You have no right to use this module</b></p>");
		out.println("<p><b>Press Return to the login page.</b></p>");
		out.println("<FORM NAME='NotAllowFrom' ACTION='Login.html' METHOD='get'>");
		out.println("    <CENTER><INPUT TYPE='submit' NAME='NOT_ALLOW' VALUE='RETURN'></CENTER>");
		out.println("</FORM>");
	}
	%>
</BODY>
</HTML>