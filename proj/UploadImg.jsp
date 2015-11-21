<HTML>
<TITLE>Picture choose page</TITLE>
<BODY background="BGP.jpg">
	<%@ page import="java.sql.*"%>
	<%
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
		if(canConnect){
			out.println("<H1><CENTER><font color=Teal>Please Choose the pictures to be upload: </font></CENTER></H1>");
			out.println("<BR></BR><BR></BR>");
			out.println("<FORM NAME='upload_pic_form' ACTION='UploadImg_Processor.jsp' ENCTYPE='multipart/form-data' METHOD='post'>");
			out.println("<H2><CENTER><input name='filePath' type='file' size='30' multiple/></CENTER></H2>");
			out.println("<H3><CENTER><input name='CommitUploadPic' type='submit' value='UploadPic'></CENTER></H3>");
			out.println("</FORM>");
			con.close();
		}
	%>
</BODY>
</HTML>