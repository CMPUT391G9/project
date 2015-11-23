<HTML>
<HEAD>
<TITLE>Manage Page</TITLE>
</HEAD>
<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%
	if(request.getParameter("Subscribe") != null && ((String)session.getAttribute("role"))!=null){
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
			ResultSet resSet=null;
			
			//out.println("<FORM NAME='SubscribeComm' ACTION='SubscribeComm.jsp' METHOD='post'>");
			out.println("<BR></BR>");
			out.println("<H1><CENTER><font color =Gold>Subscribe Sensor:</font></CENTER></H1>");
			out.println("<BR></BR>");
			out.println("<BR></BR>");
			String p_id = request.getParameter("person_id");
			
			out.println("<CENTER>");
			out.println("<SELECT NAME='ID'>");
			sqlStatement="SELECT sensor_id, location, sensor_type, description FROM sensors";
			resSet=s.executeQuery(sqlStatement);
			Integer s_id=null;
			while(resSet.next()){
				s_id=resSet.getInt("sensor_id");
				String loc=resSet.getString("location");
				String s_type=resSet.getString("sensor_type");
				String s_des=resSet.getString("description");
					
				out.println("<OPTION VALUE='"+s_id+"' SELECTED> "+loc+" "+s_type+","+s_id+"</OPTION>");
				}
			out.println("</SELECT>");
			//out.println("<INPUT TYPE='submit' NAME='SubscribeComm' VALUE='Subscribe'>");
			out.println("</CENTER>");
			//out.println("</FORM>");
			out.println("<CENTER><a href='SubscribeComm.jsp?SubscribeComm=1&person_id="+p_id+"&sensor_id="+s_id+"'><b>Subscribe</b></a></CNETER>");
			out.println("<BR></BR>");
			out.println("<BR></BR>");
			out.println("<BR></BR>");
			out.println("<FORM NAME='CancelForm' ACTION='scientist.jsp' METHOD='get'>");
			out.println("<Center><INPUT TYPE='submit' NAME='cancel' VALUE='Back'></Center>");
			out.println("</FORM>");
			con.close();
		}
	}
	
	

	else{
		response.sendRedirect("scientist.jsp");
	}
	%>
</BODY>
</HTML>
