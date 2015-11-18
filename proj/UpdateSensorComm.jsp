<HTML>
<HEAD>
<TITLE>Manage Page</TITLE>
</HEAD>
<BODY>
	<%@ page import="java.sql.*"%>
	<%!
		public boolean cmp(String oldVal,String newVal){
			return oldVal.equals(newVal);
		}
	%>
	<%!
		public void updateSensor(Connection con,String tag,String sensor_id,String newValue) throws SQLException{
			Statement s=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
			String sqlStatement="SELECT "+tag+" FROM sensors WHERE sensor_id="+sensor_id+" FOR UPDATE";
			ResultSet resSet=s.executeQuery(sqlStatement);
			while(resSet.next()){
				resSet.updateString(tag,newValue);
				resSet.updateRow();
			}
			s.executeUpdate("commit");
		}
	%>

	<%
	if(request.getParameter("UPDATE") != null){
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
			String sensor_id=request.getParameter("sensor_id").trim();
			try{	
				String oldLocation=request.getParameter("oldLocation").trim();
				String newLoaction=request.getParameter("newLoaction").trim();
				if(cmp(oldLocation,newLoaction)==false){
					updateSensor(con,"location",sensor_id,newLoaction);
				}
				
				String oldSensor_type=request.getParameter("oldSensor_type").trim();
				String newSensor_type=request.getParameter("newSensor_type").trim();
				if(cmp(oldSensor_type,newSensor_type)==false){
					updateSensor(con,"sensor_type",sensor_id,newSensor_type);
				}
				
				String oldDes=request.getParameter("oldDes").trim();
				String newDescription=request.getParameter("newDescription").trim();
				if(cmp(oldDes,newDescription)==false){
					updateSensor(con,"description",sensor_id,newDescription);
				}
				
				if(abort==false){
					con.close();
					response.sendRedirect("administrator.jsp"); 
				}
			}
			catch(Exception e){
				out.println("<HR><CENTER>"+e.getMessage()+"<CENTER></HR>");
				out.println("<FORM NAME='AbortForm' ACTION='administrator.jsp' METHOD='get'>");
				out.println("<INPUT TYPE='hidden' NAME='ID' VALUE='"+sensor_id+"'>");
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