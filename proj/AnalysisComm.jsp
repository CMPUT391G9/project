<HTML>
<HEAD>
<TITLE>Analysis Input Page</TITLE>
</HEAD>
<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%
	
		if(request.getParameter("AnalysisComm") != null  && ((String)session.getAttribute("role"))!=null){
			String userName = (String)session.getAttribute("USERNAME");
			String oracleId = (String)session.getAttribute("ORACLE_ID");
			String oraclePassword = (String)session.getAttribute("ORACLE_PASSWORD");
			Connection con = null;
			String driverName = "oracle.jdbc.driver.OracleDriver";
			String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
			Boolean canConnect = true;
			
			try {
				Class drvClass = Class.forName(driverName);
				DriverManager.registerDriver((Driver)drvClass.newInstance());
				con = DriverManager.getConnection(dbstring,oracleId,oraclePassword);
				con.setAutoCommit(false);
			}
			catch (Exception e) {
				canConnect = false;
				out.println("<p><b>Unable to Connect Oracle DB!</b></p>");
				out.println("<p><b>Invalid UserName or Password!</b></p>");
				out.println("<p><b>Press RETURN to the previous page.</b></p>");
				out.println("<FORM NAME='ConnectFailForm' ACTION='Connector.html' METHOD='get'>");
				out.println("    <CENTER><INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='RETURN'></CENTER>");
				out.println("</FORM>");
			}
			if(canConnect){
				Statement s=con.createStatement();
				ResultSet resSet=null;
				String sqlStatement=null;
				out.println("<BR></BR>");
				out.println("<H1><CENTER><font color=Gold>Analysis Data Report: </font></CENTER></H1>");
				out.println("<BR></BR>");

				String p_id = request.getParameter("person_id");
				String range = request.getParameter("groupByRange");
				String fDate = request.getParameter("fDate");
				String tDate = request.getParameter("tDate");
				String s_id = request.getParameter("ID");
				
				if ("year".equals(request.getParameter("groupByRange"))){
					sqlStatement="SELECT EXTRACT(year FROM date_created) as Y,count(value),avg(value),max(value),min(value)"
								+"FROM scalar_data WHERE sensor_id="+s_id
								+"group by EXTRACT(year FROM date_created)";

					resSet=s.executeQuery(sqlStatement);
					while(resSet != null && resSet.next()){
						String year = resSet.getString("Y");
						Float avg=resSet.getFloat("avg(value)");
						Float max=resSet.getFloat("max(value)");
						Float min=resSet.getFloat("min(value)");
						Integer count = resSet.getInt("count(value)");
						out.println("<H3><CENTER><font color=Gold>Year: "+year+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Totle number of Sensor: "+count+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Average: "+avg+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Minimum: "+min+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Maximum: "+max+"</font></CENTER></H3>");
						out.println("<BR></BR>");
					}
				}
				else if ("week".equals(request.getParameter("groupByRange"))){
					sqlStatement="SELECT to_char(to_date(date_created, 'dd-mm-yyyy'), 'iw') as Y,count(value),avg(value),max(value),min(value)"
							+"FROM scalar_data WHERE sensor_id="+s_id
							+"group by to_char(to_date(date_created, 'dd-mm-yyyy'), 'iw')";

					resSet=s.executeQuery(sqlStatement);
					while(resSet != null && resSet.next()){
						String week = resSet.getString("Y");
						Float avg=resSet.getFloat("avg(value)");
						Float max=resSet.getFloat("max(value)");
						Float min=resSet.getFloat("min(value)");
						Integer count = resSet.getInt("count(value)");
						out.println("<H3><CENTER><font color=Gold>Number of Week: "+week+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Totle number of Sensor: "+count+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Average: "+avg+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Minimum: "+min+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Maximum: "+max+"</font></CENTER></H3>");
						out.println("<BR></BR>");
					}
				}
				else if ("month".equals(request.getParameter("groupByRange"))){
					sqlStatement="SELECT EXTRACT(month FROM date_created) as Y,count(value),avg(value),max(value),min(value)"
							+"FROM scalar_data WHERE sensor_id="+s_id
							+"group by EXTRACT(month FROM date_created)";

					resSet=s.executeQuery(sqlStatement);
					while(resSet != null && resSet.next()){
						String month = resSet.getString("Y");
						Float avg=resSet.getFloat("avg(value)");
						Float max=resSet.getFloat("max(value)");
						Float min=resSet.getFloat("min(value)");
						Integer count = resSet.getInt("count(value)");
						out.println("<H3><CENTER><font color=Gold>Month: "+month+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Totle number of Sensor: "+count+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Average: "+avg+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Minimum: "+min+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Maximum: "+max+"</font></CENTER></H3>");
						out.println("<BR></BR>");
					}
				}
				else if ("daily".equals(request.getParameter("groupByRange"))){
					sqlStatement="SELECT EXTRACT(day FROM date_created) as Y,count(value),avg(value),max(value),min(value)"
							+"FROM scalar_data WHERE sensor_id="+s_id
							+"group by EXTRACT(day FROM date_created)";

					resSet=s.executeQuery(sqlStatement);
					while(resSet != null && resSet.next()){
						String day = resSet.getString("Y");
						Float avg=resSet.getFloat("avg(value)");
						Float max=resSet.getFloat("max(value)");
						Float min=resSet.getFloat("min(value)");
						Integer count = resSet.getInt("count(value)");
						out.println("<H3><CENTER><font color=Gold>Day: "+day+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Totle number of Sensor: "+count+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Average: "+avg+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Minimum: "+min+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Maximum: "+max+"</font></CENTER></H3>");
						out.println("<BR></BR>");
					}
				}
				else if ("quarterly".equals(request.getParameter("groupByRange"))){
					sqlStatement="SELECT to_char(to_date(date_created, 'dd-mm-yyyy'), 'q') as Y,count(value),avg(value),max(value),min(value)"
							+"FROM scalar_data WHERE sensor_id="+s_id
							+"group by to_char(to_date(date_created, 'dd-mm-yyyy'), 'q')";

					resSet=s.executeQuery(sqlStatement);
					while(resSet != null && resSet.next()){
						String quarter = resSet.getString("Y");
						Float avg=resSet.getFloat("avg(value)");
						Float max=resSet.getFloat("max(value)");
						Float min=resSet.getFloat("min(value)");
						Integer count = resSet.getInt("count(value)");
						out.println("<H3><CENTER><font color=Gold>Quarter: "+quarter+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Totle number of Sensor: "+count+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Average: "+avg+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Minimum: "+min+"</font></CENTER></H3>");
						out.println("<H3><CENTER><font color=Gold>Maximum: "+max+"</font></CENTER></H3>");
						out.println("<BR></BR>");
					}
				}
				con.close();
			}
		}

	%>

	<FORM NAME='ReturnForm' ACTION='Analysis.jsp' METHOD='get'>
	<CENTER><INPUT TYPE='submit' NAME='return' VALUE='Back'></CENTER>
	</FORM>
	<CENTER>User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a></CENTER>
</BODY>
</HTML>