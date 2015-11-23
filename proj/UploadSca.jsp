<HTML>
<TITLE>Picture choose page</TITLE>


<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%@ page contentType = "text/html" import="java.util.*"%>
	<%@ page import="java.io.*,java.util.*" %>
	<%@ page import="javax.servlet.*,java.text.*" %>
	<%
		String oracleId = (String)session.getAttribute("ORACLE_ID");
		String oraclePassword=(String)session.getAttribute("ORACLE_PASSWORD");
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
        	out.println("<p><b>Press RETURN to the previous page.</b></p>");
            out.println("<FORM NAME='ConnectFailForm' ACTION='Connector.html' METHOD='get'>");
            out.println("    <CENTER><INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='RETURN'></CENTER>");
            out.println("</FORM>");
        }
		
		Statement s=con.createStatement();
    	ResultSet resSet=null;
		String sqlStatement=null;
		
		if(canConnect){
			out.println("<BR></BR>");
			out.println("<H1><CENTER><font color=Gold>Please Choose the pictures to be upload: </font></CENTER></H1>");
			out.println("<BR></BR><BR></BR>");
			out.println("<FORM NAME='upload_sca_form' ACTION='UploadSca_Processor.jsp' METHOD='post'>");

			out.println("<B><I><font color=Gold> ID: </font></I></B> <INPUT TYPE='text' NAME='s_id' VALUE=''>");
			out.println("<BR></BR>");
			out.println("<B><I><font color=Gold> Sensor ID: </font></I></B>");
			out.println("<SELECT NAME='ID'>");
			sqlStatement="SELECT sensor_id, location, sensor_type, description FROM sensors";
			resSet=s.executeQuery(sqlStatement);
			while(resSet.next()){
				Integer s_id=resSet.getInt("sensor_id");
				String loc=resSet.getString("location");
				String s_type=resSet.getString("sensor_type");
				String s_des=resSet.getString("description");
				
				out.println("<OPTION VALUE='"+s_id+"' SELECTED> "+loc+" "+s_type+","+s_id+"</OPTION>");
			}
			out.println("</SELECT>");

			out.println("<BR></BR>");
			out.println("<B><I><font color=Gold> Value: </font></I></B> <INPUT TYPE='text' NAME='val' VALUE=''>");
			
			
			out.println("<BR></BR>");
			java.util.Date dNow = new java.util.Date();
			SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd");
			String catchDate = ft.format(dNow);
			out.println("<INPUT TYPE='hidden' NAME='date' VALUE='"+catchDate+"'>");
			out.println("<INPUT TYPE='submit' NAME='UploadScaComm' VALUE='Upload'></CENTER>");
			out.println("</FORM>");
			con.close();
		}
	%>
</BODY>
</HTML>
