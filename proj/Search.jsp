<HTML>
<HEAD>
<TITLE>Search Module</TITLE>
<!--Adapted from http://jqueryui.com/datepicker/#date-range-->
<link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/demos/style.css">
<style>
.from {
	
}

.to {
	
}
</style>
<script>
	$(function() {
		$(".from").datepicker({
			defaultDate : "+1w",
			changeMonth : true,
			changeYear : true,
			onClose : function(selectedDate) {
				$(".to").datepicker("option", "minDate", selectedDate);
			}
		});
		$(".to").datepicker({
			defaultDate : "+1w",
			changeMonth : true,
			changeYear : true,
			onClose : function(selectedDate) {
				$(".from").datepicker("option", "maxDate", selectedDate);
			}
		});
	});
</script>
</HEAD>
<BODY background="login.jpg">
 	<%!
		public Connection getConnection(String oracleId,String oraclePassword){
			Connection con = null;
			String driverName = "oracle.jdbc.driver.OracleDriver";
			String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
			try{
				Class drvClass = Class.forName(driverName);
				DriverManager.registerDriver((Driver)drvClass.newInstance());
				con=DriverManager.getConnection(dbstring,oracleId,oraclePassword);
				con.setAutoCommit(true);
			}
			catch(Exception e){
			}
			return con;
		}
	%>
	<%@ page import="java.sql.*"%>
	<%@ page import="java.util.*"%>
	<%
		String userName=null;
		if(request.getParameter("SearchRequest") != null 
			|| request.getParameter("CommitSearch") != null){
			userName = (String)session.getAttribute("USERNAME");
		}
		else{
			response.sendRedirect("Login.html");
		}
     %>
        <BR></BR>
        <BR></BR>
	<H1><font color=Gold><CENTER>Hello Scientist! This is the search page.</CENTER></font></H1>
        <BR></BR>
        <H2><font color=Gold>Please enter the Information you want to Search: </font></H2>	
	
	<FORM NAME="search_form" ACTION="Search.jsp" METHOD="post">
		<TABLE>
			<TR>
				<TD><B><I><font color=HotPink>Search keys:&nbsp;&nbsp;&nbsp;</TD>
				<TD style="width: 205px;"><INPUT TYPE="text" NAME="search_key"
					VALUE="" style="width: 194px;"><font color=HotPink >*</font></TD>
			</TR>
			<TR>
                                <TD><B><I><font color=HotPink>Location:&nbsp;</TD>
                                <TD style="width: 205px;"><INPUT TYPE="text" NAME="search_location"
					VALUE="" style="width: 194px;"></TD>
			</TR>
			<TR>
                                <TD><B><I><font color=HotPink>Sensor type:&nbsp;</TD>
                                <TD style="width: 205px;"><INPUT TYPE="text" NAME="search_sensor_type"
					VALUE="" style="width: 194px;"></TD>
			</TR>
                        <TR>
				<TD><B><I><font color=HotPink>Time period:</font></I></B></TD>
				<TD><label for="from"><font color=HotPink>&nbsp;From</font></label>
                                <INPUT TYPE="text" class="from" NAME="from" /></TD>
				<TD><label for="to"><font color=HotPink >To</font></label>
                                <INPUT TYPE="text" class="to" NAME="to" /><font color=HotPink >*</font></TD>
                        </TR>

		</TABLE>

                <br><B><I><font color=HotPink>filter by:</font></I></B><select NAME="OPERATION">
			<option VALUE="newest-to-oldest" SELECTED>newest to oldest</option>
			<option VALUE="oldest-to-newest" SELECTED>oldest to newest</option>
			<option VALUE="best-match" SELECTED>best match</option>
		</select> <input TYPE="submit" NAME="CommitSearch" VALUE="Search"><br>

        <BR></BR>
        <b>Here is the list of all sensor records for satisfied the search condition.</b>

        <%
            Connection con=null;
            if (request.getParameter("CommitSearch") != null) {

                if(!(request.getParameter("search_key").equals("")&&
                request.getParameter("search_location").equals("")&&
                request.getParameter("search_sensor_type").equals("")&&
                request.getParameter("from").equals("") &&
                request.getParameter("to").equals(""))) {

			String op = request.getParameter("OPERATION").trim();
            	        if(request.getParameter("search_key").equals("") && op.equals("best-match")){
            		        out.println("<br><b>Cannot filter by best match if there is no search key</b>");
            	        }
			else{
				String dropFullname = "DROP TABLE fullname";
	            	        String crFullname = "CREATE TABLE fullname AS "
	            			+"(SELECT person_id, CONCAT(CONCAT(first_name,' '),last_name) as full_name FROM persons)";

	            	                String crIndexName = "CREATE INDEX name ON fullname(full_name) INDEXTYPE IS CTXSYS.CONTEXT";
	            	                String sqlString = "";
	                                String from = "";
					String to = "";
					String search_key = "";
                                        String search_location = "";
                                        String search_sensor_type = "";
					String oracleId=(String)session.getAttribute("ORACLE_ID");
					String oraclePassword=(String)session.getAttribute("ORACLE_PASSWORD");
					String personID = (String)session.getAttribute("person_id");
                                        
					
					if(request.getParameter("search_key").equals("")){
				    	        sqlString = "SELECT DISTINCT r.record_id,r.patient_id, r.doctor_id, r.radiologist_id,"
				    			+"r.test_type, r.test_date, r.prescribing_date,r.diagnosis, r.description "
				    			+"FROM  r WHERE ";
				    	if(((String)session.getAttribute("role")).equals("s")){
						sqlString = sqlString +"r.radiologist_id = "+personID+" AND ";
						}

						if(!(request.getParameter("from").equals(""))){
						    from = (String)request.getParameter("from");
						    sqlString = sqlString + "r.test_date >= to_date('"+from+"','MM/DD/YYYY') ";
						}
						if(!(request.getParameter("to").equals(""))){
						 	to = (String)request.getParameter("to");
							sqlString = sqlString + "r.test_date <= to_date('"+to+"','MM/DD/YYYY') ";
						}
				    }




