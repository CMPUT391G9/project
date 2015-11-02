<HTML>
<HEAD>
<TITLE>Login Handler</TITLE>
</HEAD>
<BODY>
	<!--Adapted from http://webdocs.cs.ualberta.ca/~yuan/servlets/login.jsp-->
	<%@ page import="java.sql.*"%>
	<%
		if(request.getParameter("LOGIN")!=null){
			String oracleId=(String)session.getAttribute("ORACLE_ID");
			String oraclePassword=(String)session.getAttribute("ORACLE_PASSWORD");
			String userName=(request.getParameter("USERNAME")).trim();
			String password=(request.getParameter("PASSWORD")).trim();
			session.setAttribute("USERNAME",userName);
			session.setAttribute("PASSWORD",password);
			
			Connection con=null;
			String driverName="oracle.jdbc.driver.OracleDriver";
			String dbstring="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
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
			if(canConnect){
				Statement s=null;
				ResultSet resSet=null;
				String sqlStatement=null;
				sqlStatement="SELECT password FROM users WHERE user_name='"+userName+"'";
            		
				try{
					s=con.createStatement();
					resSet = s.executeQuery(sqlStatement);
				}
				catch(Exception e){
					out.println("<hr>" + e.getMessage() + "<hr>");
				}
				String correctPassword=null;
				while(resSet != null && resSet.next()){
					correctPassword=(resSet.getString(1)).trim();
				}
				if(password.equals(correctPassword)==false){
					out.println("<p><b>Invalid UserName or Password!</b></p>");
					out.println("<FORM NAME='LoginFailForm' ACTION='Login.html' METHOD='get'>");
					out.println("<CENTER><INPUT TYPE='submit' NAME='RETURN' VALUE='BACK'></CENTER>");				
					out.println("</FORM>");
				}
				else{
					sqlStatement="SELECT class,person_id FROM users WHERE user_name='"+userName+"'";
					resSet = s.executeQuery(sqlStatement);
					String userClass=null;
					while(resSet.next()){
						userClass=(resSet.getString("class")).trim();
						session.removeAttribute("class");
						session.setAttribute("class",userClass);
						session.removeAttribute("person_id");
						session.setAttribute("person_id",resSet.getInt("person_id")+"");
					}
					if(userClass.equals("a")){
						response.sendRedirect("AdminPage.jsp"); 
					}
					else if(userClass.equals("r")){
						response.sendRedirect("RadPage.jsp"); 
					}
					else if(userClass.equals("d")){
						response.sendRedirect("DoctorPage.jsp");
					}
					else if(userClass.equals("p")){
						response.sendRedirect("PatientPage.jsp");
					}
            	}
			}
            try{
				con.close();
			}
			catch(Exception e){
				out.println("<hr>" + e.getMessage() + "<hr>");
			}
		}
	%>
</BODY>
</HTML>
