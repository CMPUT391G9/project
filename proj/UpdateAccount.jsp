<HTML>
<HEAD>
	<TITLE>Reset Account Page</TITLE>
</HEAD>
<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%
	if((request.getParameter("UpdateAccount")!=null 
	|| request.getParameter("UpdateAccountComm")!=null )
	&& ((String)session.getAttribute("role"))!=null){
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
			out.println("<p><b>Press Return to the previous page.</b></p>");
			out.println("<FORM NAME='ConnectFailForm' ACTION='Connector.html' METHOD='get'>");
			out.println("<INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='Return'>");
			out.println("</FORM>");
    	}
		if(canConnect){
			String user_name = request.getParameter("Username").trim();
			Statement s=con.createStatement();
			String sqlStatement="SELECT * FROM users WHERE user_name='"+user_name+"'";
			String password = null; 
			String userRole = null; 
 			Integer person_id = null;
			ResultSet resSet=s.executeQuery(sqlStatement);
			int cnt=0;
			while(resSet.next()){
				user_name=resSet.getString("user_name");
				password=resSet.getString("password");
				userRole=resSet.getString("role");
				cnt++;
			}
			if(cnt==0){
				out.println("<p><b>No such an Account</b></p>");
				out.println("<p><b>Invalid UserName!</b></p>");
				out.println("<p><b>Press Return to the previous page.</b></p>");
				out.println("<FORM NAME='AbortForm' ACTION='administrator.jsp' METHOD='get'>");
				out.println("<CENTER><INPUT TYPE='submit' NAME='RETURN' VALUE='Return'></CNETER>");
				out.println("</FORM>");
			}
			else{
				out.println("<H1><font color =Gold> Manage a Account: </font></H1>");
				out.println("<HR></HR>");
				out.println("<FORM NAME='AddUserFrom' ACTION='UpdateAccount.jsp' METHOD='post'>");
				out.println("<TABLE style='margin: 0px auto'>");
				
				
				out.println("<TR>");
				if(request.getParameter("UpdateAccountComm") == null){
					out.println("<B><I><font color=Gold> User Name: </font></I></B>");
					out.println("<INPUT TYPE='text' NAME='newUsername' VALUE='"+user_name+"'>");
				}
				else{
					String newUsername=request.getParameter("newUsername").trim();
					out.println("<B><I><font color=Gold> User Name: </font></I></B>");
					out.println("<INPUT TYPE='text' NAME='newUsername' VALUE='"+newUsername+"'>");
				}
				out.println("</TR>");
				
				out.println("<TR>");
				if(request.getParameter("UpdateAccountComm") == null){
					out.println("<B><I><font color=Gold> Password: </font></I></B>");
					out.println("<INPUT TYPE='text' NAME='newPassword' VALUE='"+password+"'>");
				}
				else{
					String newPassword=request.getParameter("newPassword").trim();
					out.println("<B><I><font color=Gold> Password: </font></I></B>");
					out.println("<INPUT TYPE='text' NAME='newPassword' VALUE='"+newPassword+"'>");
				}
				out.println("</TR>");
				
				
				out.println("<TR>");
				if(request.getParameter("UpdateAccountComm") == null){
					out.println("<B><I><font color=Gold> User Roles(type in one of a,d,s)*: </font></I></B>");
					out.println("<INPUT TYPE='text' NAME='newRole' VALUE='"+userRole+"'>");
				}
				else{
					String newRole=request.getParameter("newRole").trim();
					out.println("<B><I><font color=Gold> Password: </font></I></B>");
					out.println("<INPUT TYPE='text' NAME='newRole' VALUE='"+newRole+"'>");
				}
				out.println("</TR>");
				
				
				out.println("</TABLE>");
				out.println("<CENTER><font color = GOld> (a for Admininstrator, d for Data Curator, s for Scientist)</CENTER>");
				
				out.println("<INPUT TYPE='hidden' NAME='Username' VALUE='"+user_name+"'>");
				out.println("<CENTER><p><INPUT TYPE='submit' NAME='UpdateAccountComm' VALUE='Update'></p></CENTER>");
				
			}
			if(request.getParameter("UpdateAccountComm")!=null){
				String newPassword=request.getParameter("newPassword").trim();
					
				Statement s1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
				String sqlStatement1="SELECT user_name,password,role FROM users WHERE user_name='"+user_name+"' FOR UPDATE";
				ResultSet resSet1=s1.executeQuery(sqlStatement1);
				try{
					while(resSet1.next()){
						resSet1.updateString("password",newPassword);
						resSet1.updateRow();
					}
					s1.executeUpdate("commit");
					out.println("Change password successfully! New Password is: "+newPassword+"");
				}
				catch(Exception e){
					
				}
			}
			out.println("</FORM>");
			out.println("<FORM NAME='CancelForm' ACTION='administrator.jsp' METHOD='get'>");
			out.println("<CENTER><INPUT TYPE='submit' NAME='cancel' VALUE='Cancel'></CENTER>");
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

