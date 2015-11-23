<HTML>
<HEAD>
<TITLE>Analysis Input Page</TITLE>
<!--Adapted from http://javarevisited.blogspot.ca/2013/10/how-to-use-multiple-jquery-ui-date.html-->
<link rel="stylesheet"
	href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.9.1.js"></script>
<script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/demos/style.css">
<style>
.datepicker {
	
}
</style>
<script>
	$(function() {
		$(".datepicker").datepicker({
			changeMonth : true,
			changeYear : true
		});
	});
</script>
</HEAD>
<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%
	
		if(request.getParameter("AnalysisData") != null  && ((String)session.getAttribute("role"))!=null){
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
			if(canConnect){
				Statement s=con.createStatement();
				ResultSet resSet=null;
				String sqlStatement=null;

				out.println("<BR></BR>");
				out.println("<H1><CENTER><font color=Gold>Analysis Data: </font></CENTER></H1>");
				out.println("<BR></BR>");
				
				out.println("<FORM NAME='AnalysisForm' ACTION='AnalysisComm.jsp' METHOD='post'>");
				String p_id = request.getParameter("person_id");
				String sql="SELECT * FROM persons WHERE person_id="+p_id;
				resSet=s.executeQuery(sql);
				while(resSet != null && resSet.next()){
					String fname=resSet.getString("first_name");
					String lname=resSet.getString("last_name"); 
					out.println("<H2><CENTER><font color=Gold>Scientist: "+fname+" "+lname+" ID: "+p_id+"</font></CENTER></H2>");
				}
				out.println("<BR></BR>");
				out.println("<B><font size = 4><font color=Gold>Select Sensor: </font></B>");
				out.println("<SELECT NAME='ID'>");
				sqlStatement="SELECT * FROM subscriptions WHERE person_id="+p_id;
				resSet=s.executeQuery(sqlStatement);
				while(resSet.next()){
					Integer s_id=resSet.getInt("sensor_id");
					out.println("<OPTION VALUE='"+s_id+"' SELECTED> ID: "+s_id+"</OPTION>");
				}
				out.println("</SELECT>");
				
				out.println("<BR></BR>");
				
				out.println("<B><I><font color=Gold>Group by range:</font></I></B>");
				out.println("<SELECT NAME='groupByRange'>");
				out.println("<OPTION VALUE='week' SELECTED> Weekly </OPTION>");
				out.println("<OPTION VALUE='month' SELECTED> Monthly </OPTION>");
				out.println("<OPTION VALUE='year' SELECTED> Yearly </OPTION>");
				out.println("<OPTION VALUE='daily' SELECTED> Daily </OPTION>");
				out.println("<OPTION VALUE='quarterly' SELECTED> Quarterly </OPTION>");
				out.println("</SELECT>");
				out.println("<BR></BR>");
				out.println("<BR></BR>");
				out.println("<INPUT TYPE='hidden' NAME='person_id' VALUE='"+p_id+"'>");
				out.println("<CENTER><INPUT TYPE='submit' NAME='AnalysisComm' VALUE='Analysis'></CENTER>");
				//out.println("<CENTER><a href='AnalysisComm.jsp?AnalysisComm=1&person_id="+p_id+"&sensor_id="+s_id+"'><b>Subscribe</b></a></CNETER>");
				con.close();
				
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

	<FORM NAME='ReturnForm' ACTION='scientist.jsp' METHOD='get'>
	<CENTER><INPUT TYPE='submit' NAME='return' VALUE='Back'></CENTER>
	</FORM>
	<CENTER>User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a></CENTER>
</BODY>
</HTML>