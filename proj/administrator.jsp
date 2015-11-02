<HTML>
    <!--This page is used for test for now.-->
	<HEAD>
		<TITLE>Administrator Home Page</TITLE>
	</HEAD>
	<BODY background="login.jpg">
		<%@ page import="java.sql.*"%>
		<%
			if(session.getAttribute("role") != null && ((String)session.getAttribute("role")).equals("a")){
				String userName=(String)session.getAttribute("USERNAME");
				String oracleId=(String)session.getAttribute("ORACLE_ID");
    			String oraclePassword=(String)session.getAttribute("ORACLE_PASSWORD");
    	
    			Connection con = null;
	    		String driverName = "oracle.jdbc.driver.OracleDriver";
       			String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    	
      			try{
    				Class drvClass = Class.forName(driverName);
					DriverManager.registerDriver((Driver)drvClass.newInstance());
    				con = DriverManager.getConnection(dbstring,oracleId,oraclePassword);
     				con.setAutoCommit(false);
    			}
    			catch(Exception e){
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
         		
        		sqlStatement="SELECT person_id FROM users WHERE user_name='"+userName+"'";
        
        		try{
        			resSet = s.executeQuery(sqlStatement);
        		}
        		catch(Exception e){
        			out.println("<hr>" + e.getMessage() + "<hr>"); 
        		}
                Integer personId = null;
            	while(resSet != null && resSet.next()){
       				personId = (resSet.getInt("person_id"));
            	}
            
            	sqlStatement = "SELECT first_name,last_name FROM persons WHERE person_id="+personId;
            	resSet = s.executeQuery(sqlStatement);
                String first = null;
                String last=null;
            	while(resSet != null && resSet.next()){
       				first=resSet.getString("first_name");
       				last=resSet.getString("last_name");
            	}
            	
            	out.println("<BR></BR>");
            	out.println("<H1><font color =Gold>Welcome! Adminstrator <a href='PersonalInfo.jsp?Manage=1'><b>"+first+" "+last+"</b></a></font></H1>");
        		out.println("<BR></BR>");
        		out.println("<H3><B><font size = 5><font color =Gold>User Management Module</font></B></H3>");
        		
        		out.println("<B><font size = 4><font color=Gold> Enter user's name to update an account:</font></B>");
        		out.println("<FORM NAME='ResetAccountForm' ACTION='ResetAccount.jsp' METHOD='post'>");
        		out.println("<INPUT TYPE='text' NAME='Username' VALUE=''> &nbsp;&nbsp;&nbsp;<INPUT TYPE='submit' NAME='Updateaccount' VALUE='GO'>");
        		out.println("<a href ='Adduser.jsp?AddUser=1'><b> Add an user account</b></a>");
        		out.println("</FORM>");
        		
        		out.println("<BR></BR>");
        		out.println("<B><font size = 4><font color=Gold>Manage a Person: </font></B>");
				out.println("<FORM NAME='ManagePersonFrom' ACTION='PersonManage.jsp' METHOD='post'>");
				out.println("<SELECT NAME='ID'>");
				sqlStatement="SELECT person_id,first_name,last_name FROM persons";
				resSet=s.executeQuery(sqlStatement);
				while(resSet.next()){
					Integer p_id=resSet.getInt("person_id");
					String first_n=resSet.getString("first_name");
					String last_n=resSet.getString("last_name");
					out.println("<OPTION VALUE='"+p_id+"' SELECTED> "+first_n+" "+last_n+" ,ID: "+p_id+"</OPTION>");
				}
				out.println("</SELECT>");
				out.println("<INPUT TYPE='submit' NAME='PersonManage' VALUE='GO'><a href ='AddPerson.jsp?AddPerson=1'><b>Add a person</b></a>");
				out.println("</FORM>");
				
				out.println("<BR></BR>");
				out.println("<B><font size = 4><font color=Gold> Manage a Sensor: </font></B>");
				out.println("<FORM NAME='ManagePersonFrom' ACTION='SensorManage.jsp' METHOD='post'>");
				out.println("<SELECT NAME='ID'>");
				sqlStatement="SELECT sensor_id, location, sensor_type FROM sensors";
				resSet=s.executeQuery(sqlStatement);
				while(resSet.next()){
					Integer s_id=resSet.getInt("sensor_id");
					String loc=resSet.getString("location");
					String s_type=resSet.getString("sensor_type");
					out.println("<OPTION VALUE='"+s_id+"' SELECTED> "+loc+" "+s_type+" ,ID: "+s_id+"</OPTION>");
				}
				out.println("</SELECT>");
				out.println("<INPUT TYPE='submit' NAME='PersonManage' VALUE='GO'><a href ='AddSensor.jsp?AddPerson=1'><b>Add a sensor</b></a>");
				out.println("</FORM>");
				try{
					con.close();
				}
				catch(Exception e){
					out.println("<hr>" + e.getMessage() + "<hr>");
				}
			}
			else{
				response.sendRedirect("Login.html");
			}

		%>
	<BR></BR>
	<BR></BR>
	<BR></BR>
	User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a>
	</BODY>
</HTML>