<HTML>
<TITLE>Picture upload page</TITLE>
<BODY>
    <%@ page import="java.sql.*"%>

	<%	if(request.getParameter("UploadPicComm") != null){
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
				String imgId=request.getParameter("ImgID");
				String sensorId=request.getParameter("ID");
				String date=request.getParameter("date");
				String des=request.getParameter("Des");
				Statement s=con.createStatement();
				String sqlStatement1 = "alter SESSION set NLS_DATE_FORMAT = 'YYYY-MM-DD'";
				String sqlStatement2="INSERT INTO images VALUES('"+imgId+"','"+sensorId+"','"+date+"','"+des+"',NULL,NULL)";
				s.executeQuery(sqlStatement1);
				try{
					s.executeQuery(sqlStatement2);
					con.close();
					response.sendRedirect("datacurator.jsp"); 
				}
				catch(Exception e){
					out.println("<p><b>"+e.getMessage()+"</b></p>");
					out.println("<p><b>Press RETURN to the previous page.</b></p>");
					out.println("<FORM NAME='AbortForm' ACTION='datacurator.jsp' METHOD='get'>");
					out.println("    <CENTER><INPUT TYPE='submit' NAME='Cancel' VALUE='Back'></CENTER>");
					out.println("</FORM>");
					con.close();
				}
			}
		}
    %>
</BODY>
</HTML>