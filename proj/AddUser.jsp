<HTML>
<HEAD>
	<TITLE>Add User Page</TITLE>
</HEAD>
<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%
		if(request.getParameter("AddUser")!=null && ((String)session.getAttribute("role"))!=null){
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
				out.println("<H1><CENTER><font color=Gold> New User Register: </font></CENTER></H1>");
				out.println("<HR></HR>");
				out.println("<FORM NAME='AddUserFrom' ACTION='AddUserComm.jsp' METHOD='post'>");
				out.println("	<TABLE style='margin: 0px auto'>");
				out.println("		<TR>");
				out.println("			<B><I><font color=Gold> User Name: </font></I></B>");
				out.println("			<INPUT TYPE='text' NAME='UserName' VALUE=''>");
				out.println("		</TR>");
				out.println("		<TR>");
				out.println("			<B><I><font color=Gold> Password: </font></I></B>");
				out.println("			<INPUT TYPE='password' NAME='Password' VALUE=''>");
				out.println("		</TR>");
				out.println("		<TR>");
				out.println("			<B><I><font color=Gold> User Role: </font></I></B>");
				out.println("			<SELECT NAME='Role'>");
				out.println("           	<OPTION VALUE='a' SELECTED> Administrator </OPTION>");
				out.println("           	<OPTION VALUE='d' SELECTED> Data Curator </OPTION>");
				out.println("           	<OPTION VALUE='s' SELECTED> Scientist </OPTION>");
				out.println("			</SELECT>");
				out.println("		</TR>");
				out.println("		<TR>");
				out.println("			<B><I><font color=Gold> Choose person : </font></I></B>");
				out.println("			<SELECT NAME='ID'>");
				//get all person info from table:
				Statement s=con.createStatement();
				String sqlStatement="SELECT person_id,first_name,last_name FROM persons";
				ResultSet resSet=s.executeQuery(sqlStatement);
				while(resSet.next()){
					Integer person_id=resSet.getInt("person_id");
					String first_name=resSet.getString("first_name");
					String last_name=resSet.getString("last_name");
					out.println("           	<OPTION VALUE='"+person_id+"' SELECTED> "+first_name+" "+last_name+" ;ID: "+person_id+"</OPTION>");
				}
				//-------------------------------
				out.println("			</SELECT>");
				out.println("		</TR>");
				out.println("	</TABLE>");

				out.println("   <CENTER><INPUT TYPE='submit' NAME='CommitAddUser' VALUE='Add'></CENTER>");
				out.println("</FORM>");
				con.close();
				
				
				out.println("<FORM NAME='CancelForm' ACTION='administrator.jsp' METHOD='get'>");
				out.println("    <CENTER><INPUT TYPE='submit' NAME='cancel' VALUE='cancel'></CENTER>");
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