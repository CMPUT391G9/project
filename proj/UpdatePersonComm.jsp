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
		public void updatePersons(Connection con,String tag,String person_id,String newValue) throws SQLException{
			Statement s=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
			String sqlStatement="SELECT "+tag+" FROM persons WHERE person_id="+person_id+" FOR UPDATE";
			ResultSet resSet=s.executeQuery(sqlStatement);
			while(resSet.next()){
				resSet.updateString(tag,newValue);
				resSet.updateRow();
			}
			s.executeUpdate("commit");
		}
	%>
	<%!
		public Boolean checkEmailUnique(Connection con,String newEmail,String person_id) throws SQLException{
			Statement s=con.createStatement();
			String sqlStatement="SELECT email FROM persons WHERE person_id<>"+person_id;
			ResultSet resSet=s.executeQuery(sqlStatement);
			while(resSet != null && resSet.next()){
				String email=(resSet.getString("email"));
				if(newEmail.equals(email)){
					return false;
				}
			}
			return true;
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
			String person_id=request.getParameter("person_id").trim();
			try{	
				String oldFirstName=request.getParameter("oldFirstName").trim();
				String newFirstName=request.getParameter("newFirstName").trim();
				if(cmp(oldFirstName,newFirstName)==false){
					updatePersons(con,"first_name",person_id,newFirstName);
				}
				
				String oldLastName=request.getParameter("oldLastName").trim();
				String newLastName=request.getParameter("newLastName").trim();
				if(cmp(oldLastName,newLastName)==false){
					updatePersons(con,"last_name",person_id,newLastName);
				}
				
				String oldAddress=request.getParameter("oldAddress").trim();
				String newAddress=request.getParameter("newAddress").trim();
				if(cmp(oldAddress,newAddress)==false){
					updatePersons(con,"address",person_id,newAddress);
				}
				
				String oldEmail=request.getParameter("oldEmail").trim();
				String newEmail=request.getParameter("newEmail").trim();
				if(cmp(oldEmail,newEmail)==false){
					if(checkEmailUnique(con,newEmail,person_id)){
						updatePersons(con,"email",person_id,newEmail);
					}
					else{
						abort=true;
						out.println("<HR><CENTER>Email is not updated because your new email is the same as some one else's email.<CENTER></HR>");
						out.println("<FORM NAME='AbortForm' ACTION='administrator.jsp' METHOD='get'>");
						out.println("<INPUT TYPE='hidden' NAME='ID' VALUE='"+person_id+"'>");
						out.println("    <CENTER><INPUT TYPE='submit' NAME='Return' VALUE='Return'></CENTER>");
						out.println("</FORM>");
					}
				}
				
				String oldPhone=request.getParameter("oldPhone").trim();
				String newPhone=request.getParameter("newPhone").trim();
				if(cmp(oldPhone,newPhone)==false){
					updatePersons(con,"phone",person_id,newPhone);
				}
				if(abort==false){
					con.close();
					response.sendRedirect("administrator.jsp"); 
				}
			}
			catch(Exception e){
				out.println("<HR><CENTER>"+e.getMessage()+"<CENTER></HR>");
				out.println("<FORM NAME='AbortForm' ACTION='administrator.jsp' METHOD='get'>");
				out.println("<INPUT TYPE='hidden' NAME='ID' VALUE='"+person_id+"'>");
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