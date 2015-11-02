<HTML>
    <!--This page is used for test for now.-->
	<HEAD>
		<TITLE>Administrator Home Page</TITLE>
	</HEAD>
	<BODY background="login.jpg">
		<%@ page import="java.sql.*"%>
		<%
			if(session.getAttribute("class") != null && ((String)session.getAttribute("class")).equals("a")){
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
            	
            	out.println("<H1><CENTER><font color =Teal>Welcome! Adminstrator <a href='PersonalInfo.jsp?Manage=1'><b>"+first+" "+last+"</b></a></font></CENTER></H1>");
        		out.println("<BR></BR>");
        		out.println("<BR></BR>");
        		out.println("<HR></HR>");
        		out.println("<H3><CENTER><font color =Maroon>User Management Module</font></CENTER></H3>");
        		
        		out.println("<CENTER><font color=Teal> Enter user's name to update an account:</font></CENTER>");
        		out.println("<FORM NAME='ResetAccountForm' ACTION='ResetAccount.jsp' METHOD='post'>");
        		out.println("<CENTER><INPUT TYPE='text' NAME='Username' VALUE=''> &nbsp;&nbsp;&nbsp;<INPUT TYPE='submit' NAME='Updateaccount' VALUE='GO'></CENTER>");
        		out.println("<CENTER><a href ='Adduser.jsp?AddUser=1'><b> Add an user account</b></a></CENTER>");
        		out.println("</FORM>");
        		
        		out.println("<CENTER><font color =Teal> Manage a Person: </font></CENTER>");
				out.println("<FORM NAME='ManagePersonFrom' ACTION='PersonManage.jsp' METHOD='post'>");
				out.println("	<CENTER><SELECT NAME='ID'>");
				sqlStatement="SELECT person_id,first_name,last_name FROM persons";
				resSet=s.executeQuery(sqlStatement);
				while(resSet.next()){
					Integer p_id=resSet.getInt("person_id");
					String first_n=resSet.getString("first_name");
					String last_n=resSet.getString("last_name");
					out.println("<CENTER><OPTION VALUE='"+p_id+"' SELECTED> "+first_n+" "+last_n+" ,ID: "+p_id+"</OPTION><INPUT TYPE='submit' NAME='PersonManage' VALUE='GO'></CENTER>");
				}
				out.println("</SELECT></CENTER>");
				out.println("<CENTER><a href ='AddPerson.jsp?AddPerson=1'><b>Add a person</b></a></CENTER>");
				out.println("</FORM>");
				
				
				out.println("<CENTER><font color =Teal> Manage a Sensor: </font></CENTER>");
				out.println("<FORM NAME='ManagePersonFrom' ACTION='SensorManage.jsp' METHOD='post'>");
				out.println("	<CENTER><SELECT NAME='ID'>");
				sqlStatement="SELECT sensor_id, location, sensor_type FROM sensors";
				resSet=s.executeQuery(sqlStatement);
				while(resSet.next()){
					Integer s_id=resSet.getInt("sensor_id");
					String loc=resSet.getString("location");
					String s_type=resSet.getString("sensor_type");
					out.println("<CENTER><OPTION VALUE='"+s_id+"' SELECTED> "+loc+" "+s_type+" ,ID: "+s_id+"</OPTION><INPUT TYPE='submit' NAME='PersonManage' VALUE='GO'></CENTER>");
				}
				out.println("</SELECT></CENTER>");
				out.println("<CENTER><a href ='AddSensor.jsp?AddPerson=1'><b>Add a sensor</b></a></CENTER>");
				out.println("</FORM>");
			}
		%>
	<CENTER>User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a></CENTER>
	</BODY>
</HTML>