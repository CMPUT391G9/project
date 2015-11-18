<HTML>
<HEAD>
<TITLE>Manage Page</TITLE>
</HEAD>
<BODY background="login.jpg">
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
			String sensor_id=request.getParameter("ID").trim();
			ResultSet resSet=null;
			sqlStatement = "SELECT * FROM sensors WHERE sensor_id="+sensor_id;
			resSet = s.executeQuery(sqlStatement);
			String location = null;
			String sensor_type=null;
			String description=null;

			while(resSet != null && resSet.next()){
				location=resSet.getString("location");
				sensor_type=resSet.getString("sensor_type");
				description=resSet.getString("description");

			}
			out.println("<H1><CENTER><font color =Gold> Sensor Id: "+sensor_id+"</font></CENTER></H1>");
			out.println("<H1><CENTER><font color =Gold> Location: "+location+"</font></CENTER></H1>");
			out.println("<HR></HR>");
			out.println("<FORM NAME='UpdateSensorForm' ACTION='UpdateSensorComm.jsp' METHOD='post'>");
			out.println("	<TABLE style='margin: 0px auto'>");
			out.println("		<TR>");
			out.println("			<B><I><font color=Gold> Location: </font></I></B>");
			out.println("			<INPUT TYPE='text' NAME='newLoaction' VALUE='"+location+"'>");
			out.println("		</TR>");
			out.println("		<TR>");
			out.println("			<B><I><font color=Gold>Sensor Type: </font></I></B>");
			out.println("			<INPUT TYPE='text' NAME='newSensor_type' VALUE='"+sensor_type+"'>");
			out.println("		</TR>");
			out.println("		<TR>");
			out.println("			<B><I><font color=Gold>Description: </font></I></B>");
			out.println("			<INPUT TYPE='text' NAME='newDescription' VALUE='"+description+"'>");
			out.println("		</TR>");
			
			out.println("	</TABLE>");
			out.println("   <HR></HR>");
			
			out.println("<INPUT TYPE='hidden' NAME='sensor_id' VALUE='"+sensor_id+"'>");
			out.println("<INPUT TYPE='hidden' NAME='oldLocation' VALUE='"+location+"'>");
			out.println("<INPUT TYPE='hidden' NAME='oldSensor_type' VALUE='"+sensor_type+"'>");
			out.println("<INPUT TYPE='hidden' NAME='oldDes' VALUE='"+description+"'>");

			
			out.println("<CENTER><INPUT TYPE='submit' NAME='UPDATE' VALUE='Update'></CENTER>");
			out.println("</FORM>");
			out.println("<FORM NAME='CancelForm' ACTION='administrator.jsp' METHOD='get'>");
			out.println("<Center><INPUT TYPE='submit' NAME='cancel' VALUE='Back'></Center>");
			out.println("</FORM>");
			con.close();
		}
	}
	else{
		response.sendRedirect("Login.html");
	}
	%>
</BODY>
</HTML>