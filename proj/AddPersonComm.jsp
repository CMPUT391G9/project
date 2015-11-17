<HTML>
<HEAD>
	<TITLE>Add Person Process Page</TITLE>
</HEAD>
<BODY>
	<%@ page import="java.sql.*"%>
	<%
		if(request.getParameter("AddPersonComm") != null){
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
				String email=request.getParameter("Email").trim();
				String firstName=request.getParameter("FirstName").trim();
				String lastName=request.getParameter("LastName").trim();
				String address=request.getParameter("Address").trim();
				String phone=request.getParameter("Phone").trim();
				Statement s=con.createStatement();
				String sqlStatement="SELECT MAX(person_id) FROM persons";
				ResultSet resSet=s.executeQuery(sqlStatement);
				Integer personId=1;
				while(resSet.next()){
					personId+=resSet.getInt(1);
				}
				sqlStatement="INSERT INTO persons VALUES ("+personId+",'"+firstName+"','"+lastName+"','"+address+"','"+email+"','"+phone+"')";
				try{
					s.executeQuery(sqlStatement);
					con.close();
					response.sendRedirect("administrator.jsp");
				}
				catch(Exception e){
					out.println("<p><b>"+e.getMessage()+"</b></p>");
					out.println("<p><b>Press RETURN to the previous page.</b></p>");
					out.println("<FORM NAME='AbortForm' ACTION='AddPerson.jsp' METHOD='get'>");
					out.println("    <CENTER><INPUT TYPE='submit' NAME='AddPerson' VALUE='RETURN'></CENTER>");
					out.println("</FORM>");
					con.close();
				}
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