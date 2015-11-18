<HTML>
<HEAD>
<TITLE>Data Curator Home Page</TITLE>
</HEAD>
<BODY background="login.jpg">
        <%@ page import="java.sql.*"%>
	<%
                       
		if(session.getAttribute("role") != null && ((String)session.getAttribute("role")).equals("d")){
			String userName = (String)session.getAttribute("USERNAME");
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
				out.println("<BR></BR><BR></BR><H1><CENTER><font color=Gold>Hello! Data Curator: <a href='PersonalInfo.jsp?Manage=1'><b>"+first_name+" "+last_name+"</b></a> </font></CENTER></H1>");

        		out.println("<BR></BR>");
        		out.println("<H3><font color=Gold>This is an Uploading Module</font></H3>");
                        out.println("<BR></BR>");
                        out.println("<ul>");
                        out.println("<li><font color=DarkOrchid> Please select an csv file to upload an audio recording:</font></li>");
                        out.println("<FORM NAME='upload_rec_form' ACTION='UploadRec_Processor.jsp' ENCTYPE='multipart/form-data' METHOD='post'>");
			out.println("<H2><input name='filePath' type='file' size='30' multiple/></H2>");
			out.println("<H3><input name='CommitUploadPic' type='submit' value='Upload'></H3>");
                        out.println("<BR></BR>");
                        out.println("<li><font color=DarkOrchid> Please select an csv file to upload an image:</font></li>");
                        out.println("<FORM NAME='upload_img_form' ACTION='UploadImg_Processor.jsp' ENCTYPE='multipart/form-data' METHOD='post'>");
			out.println("<H2><input name='filePath' type='file' size='30' multiple/></H2>");
			out.println("<H3><input name='CommitUploadPic' type='submit' value='Upload'></H3>");
			out.println("</FORM>");
                        out.println("<BR></BR>");
                        out.println("<li><font color=DarkOrchid> Please select an csv file to upload an scalar measurements:</font></li>");
                        out.println("<FORM NAME='upload_sca_form' ACTION='Uploadsca_Processor.jsp' ENCTYPE='multipart/form-data' METHOD='post'>");
			out.println("<H2><input name='filePath' type='file' size='30' multiple/></H2>");
			out.println("<H3><input name='CommitUploadPic' type='submit' value='Upload'></H3>");
                        out.println("</ul>");
			}
			
	%>
	<BR></BR>
        <BR></BR>
	<FORM NAME='ReturnForm' ACTION='UserLogout.jsp' METHOD='get'>
		<CENTER>
			<INPUT TYPE='submit' NAME='BACK' VALUE='Log out'>
		</CENTER>
	</FORM>
	<CENTER>User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a></CENTER>
</BODY>
</HTML>
