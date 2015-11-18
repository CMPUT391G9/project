<HTML>
<HEAD>
	<TITLE>Add User Page</TITLE>
</HEAD>
<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%
		if(request.getParameter("AddSensor")!=null && ((String)session.getAttribute("role"))!=null){
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
				out.println("<H1><CENTER><font color=Gold> New Sensor Register: </font></CENTER></H1>");
				out.println("<HR></HR>");
				out.println("<FORM NAME='AddSensorFrom' ACTION='AddSensorComm.jsp' METHOD='post'>");
				out.println("	<TABLE style='margin: 0px auto'>");
				out.println("		<TR>");
				out.println("			<B><I><font color=Gold> Sensor Id: </font></I></B>");
				out.println("			<INPUT TYPE='text' NAME='SensorId' VALUE=''>");
				out.println("		</TR>");
				out.println("		<TR>");
				out.println("			<B><I><font color=Gold> Location: </font></I></B>");
				out.println("			<INPUT TYPE='text' NAME='Location' VALUE=''>");
				out.println("		</TR>");
				out.println("		<TR>");
				out.println("			<B><I><font color=Gold> Sensor Type: </font></I></B>");
				out.println("			<SELECT NAME='sensor_type'>");
				out.println("           	<OPTION VALUE='a' SELECTED> Audio Recorder </OPTION>");
				out.println("           	<OPTION VALUE='i' SELECTED> Image Recorder </OPTION>");
				out.println("           	<OPTION VALUE='s' SELECTED> Scalar Value Recorder </OPTION>");
				out.println("			</SELECT>");
				out.println("		</TR>");
				out.println("		<TR>");
				out.println("		<TR>");
				out.println("			<B><I><font color=Gold> Description: </font></I></B>");
				out.println("			<INPUT TYPE='text' NAME='Description' VALUE=''>");
				out.println("		</TR>");

				//get all person info from table:
				Statement s=con.createStatement();
				String sqlStatement="SELECT * FROM sensors";
				ResultSet resSet=s.executeQuery(sqlStatement);
				while(resSet.next()){
					Integer sensor_id=resSet.getInt("sensor_id");
					String location=resSet.getString("location");
					String sensor_type=resSet.getString("sensor_type");
					String description=resSet.getString("description");
				}
				//-------------------------------
				out.println("			</SELECT>");
				out.println("		</TR>");
				out.println("	</TABLE>");

				out.println("   <CENTER><INPUT TYPE='submit' NAME='AddSensorComm' VALUE='Add'></CENTER>");
				out.println("</FORM>");
				con.close();
				
				
				out.println("<FORM NAME='CancelForm' ACTION='administrator.jsp' METHOD='get'>");
				out.println("    <CENTER><INPUT TYPE='submit' NAME='cancel' VALUE='Back'></CENTER>");
				out.println("</FORM>");
			}
		}
		else{
			out.println("<p><b>You have no right to use this module</b></p>");
			out.println("<p><b>Press RETURN to the login page.</b></p>");
			out.println("<FORM NAME='NotAllowFrom' ACTION='Login.html' METHOD='get'>");
			out.println("    <CENTER><INPUT TYPE='submit' NAME='NOT_ALLOW' VALUE='RETURN'></CENTER>");
			out.println("</FORM>");
		}
	%>

</BODY>
</HTML>