<HTML>
<TITLE>Picture choose page</TITLE>
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/demos/style.css">
<style>
.at {
	
}

</style>
<!-- 
<script>
	$(function() {
		$(".at").datepicker({
			defaultDate : "+1w",
			changeMonth : true,
			changeYear : true,
			onClose : function(selectedDate) {
				$(".to").datepicker("option", "minDate", selectedDate);
			}
		});
	});
</script>
 -->

<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%@ page contentType = "text/html" import="java.util.*"%>
	<%@ page import="java.io.*,java.util.*" %>
	<%@ page import="javax.servlet.*,java.text.*" %>
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
		
		Statement s=con.createStatement();
    	ResultSet resSet=null;
		String sqlStatement=null;
		java.util.Date dNow = new java.util.Date();
		SimpleDateFormat ft = new SimpleDateFormat ("dd/MM/yyyy hh:mm:ss");
		String catchDate = ft.format(dNow);
		out.println(catchDate);
		if(canConnect){
			out.println("<BR></BR>");
			out.println("<H1><CENTER><font color=Gold>Please Choose the pictures to be upload: </font></CENTER></H1>");
			out.println("<BR></BR><BR></BR>");
			out.println("<FORM NAME='upload_pic_form' ACTION='UploadImg_Processor.jsp' METHOD='post'>");

			out.println("<B><I><font color=Gold> Image ID: </font></I></B> <INPUT TYPE='text' NAME='ImgID' VALUE=''>");
			out.println("<BR></BR>");
			out.println("<B><I><font color=Gold> Sensor ID: </font></I></B>");
			out.println("<SELECT NAME='ID'>");
			sqlStatement="SELECT sensor_id, location, sensor_type, description FROM sensors";
			resSet=s.executeQuery(sqlStatement);
			while(resSet.next()){
				Integer s_id=resSet.getInt("sensor_id");
				String loc=resSet.getString("location");
				String s_type=resSet.getString("sensor_type");
				String s_des=resSet.getString("description");
				
				out.println("<OPTION VALUE='"+s_id+"' SELECTED> "+loc+" "+s_type+","+s_id+"</OPTION>");
			}
			out.println("</SELECT>");

			//out.println("<BR></BR>");
			//out.println("<B><I><font color=GOLD>Date: </font></I></B> <INPUT TYPE='text' class='at' NAME='at' />");
			
			out.println("<BR></BR>");
			out.println("<B><I><font color=Gold> Description: </font></I></B> <INPUT TYPE='text' NAME='Des' VALUE=''>");
			
			//out.println("<BR></BR>");
			//out.println("<B><I><font color=Gold> Select Image: </font></I></B> <input name='filePath1' type='file' size='30'>");
			
			out.println("<BR></BR>");
			out.println("<B><I><font color=Gold> Select Recorded Data: </font></I></B> <input name='filePath2' type='file' size='30'>");
			
			out.println("<BR></BR>");
			out.println("<INPUT TYPE='submit' NAME='UploadPicComm' VALUE='Upload'></CENTER>");
			out.println("</FORM>");
			con.close();
		}
	%>
</BODY>
</HTML>