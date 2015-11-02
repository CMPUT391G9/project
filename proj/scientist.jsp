<HTML>
<HEAD>
<TITLE>Scientist Home Page</TITLE>
</HEAD>
<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%
			if(session.getAttribute("class") != null && ((String)session.getAttribute("class")).equals("d")){
				String userName = (String)session.getAttribute("USERNAME");
				String oracleId = (String)session.getAttribute("ORACLE_ID");
    			String oraclePassword = (String)session.getAttribute("ORACLE_PASSWORD");
    	
    			Connection con = null;
	    		String driverName = "oracle.jdbc.driver.OracleDriver";
       			String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    			Boolean canConnect = true;
    			
      			try {
    				Class drvClass = Class.forName(driverName);
					DriverManager.registerDriver((Driver)drvClass.newInstance());
    				con = DriverManager.getConnection(dbstring,oracleId,oraclePassword);
     				con.setAutoCommit(false);
    			}
    			catch (Exception e) {
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
	                String first_name = null;
	                String last_name=null;
	            	while(resSet != null && resSet.next()){
	       				first_name=resSet.getString("first_name");
	       				last_name=resSet.getString("last_name");
	            	}
	        		out.println("<H1><CENTER><font color =Teal>Hello! Scientist: <a href='PersonalManage.jsp?Manage=1'><b>"+first_name+" "+last_name+"</b></a> You can:</font></CENTER></H1>");
                               
				}
			
		%>
	<BR></BR>
        <BR></BR>
        <BR></BR>
	<H3><CENTER><a href="Search.jsp?SearchRequest=1"><b>Search Records</b></a></CENTER></H3>
        <BR></BR>
        <BR></BR>
        <BR></BR>
	<HR></HR>
	<CENTER>
		<a href="Subscribe.jsp?UploadRecord=1"><b>Subscribe Data</b></a>
	</CENTER>
	<HR></HR>
        <BR></BR>
        <BR></BR>
        <BR></BR>
        <HR></HR>
        <CENTER>
		<a href="Analysis.jsp?UploadRecord=1"><b>Data Analysis</b></a>
	</CENTER>
	<HR></HR>
	<FORM NAME='ReturnForm' ACTION='UserLogout.jsp' METHOD='get'>
		<CENTER>
			<INPUT TYPE='submit' NAME='BACK' VALUE='Log out'>
		</CENTER>
	</FORM>
	<CENTER>User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a></CENTER>
</BODY>
</HTML>
