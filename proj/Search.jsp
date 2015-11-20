<HTML>
<HEAD>
<TITLE>Search Module</TITLE>
</HEAD>
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

<BODY background="login.jpg">
 	<%@ page import="java.sql.*"%>
	<%
	if(request.getParameter("SearchRequest") != null || request.getParameter("CommitSearch") != null){
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
			con.setAutoCommit(false);
		}
		catch(Exception e){
			canConnect = false;
			out.println("<p><b>Unable to Connect Oracle DB!</b></p>");
			out.println("<p><b>Invalid UserName or Password!</b></p>");
			out.println("<p><b>Press Return to the previous page.</b></p>");
			out.println("<FORM NAME='ConnectFailForm' ACTION='Connector.html' METHOD='get'>");
			out.println("    <CENTER><INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='Return'></CENTER>");
			out.println("</FORM>");
    	         }
                 if (canConnect){
                        Statement s =  null;
                        ResultSet rs = null; 
			String personID = (String)session.getAttribute("person_id");
                        String sqlstr = "SELECT sensor_id FROM subscription WHERE person_id = '"+personID+"'";
                        try {
                                s = con.createStatement();
                                rs = s.executeQuery(sqlstr);
                        }
                        catch(Exception e){
                                out.println("<hr>"+e.getMessage()+"<hr>");
                        }

	                Integer sensorId = null;
	            	while(rs != null && rs.next()){
	                        sensorId = (rs.getInt("sensor_id"));
	            	}
                        
 
                        out.println("<BR></BR>");
                        out.println("<BR></BR>");
	                out.println("<H1><font color=Gold><CENTER>Hello Scientist! This is the search page.</CENTER></font></H1>");
                        out.println("<BR></BR>");
                        out.println("<H2><font color=Gold>Please enter the Information you want to Search: </font></H2>");
	                out.println("<FORM NAME="search_form" ACTION="Search.jsp" METHOD="post">");
		        out.println("<TABLE>");
			out.println("<TR>");
			out.println("<TD><B><I><font color=HotPink>Search keys:&nbsp;&nbsp;&nbsp;</TD>");
			out.println("<TD style="width: 205px;"><INPUT TYPE="text" NAME="search_key"
					VALUE="" style="width: 194px;">");
			out.println("</TR>");
			out.println("<TR>");
                        out.println(" <TD><B><I><font color=HotPink>Location:&nbsp;</TD>");
                        out.println(" <TD style="width: 205px;"><INPUT TYPE="text" NAME="search_location"
					VALUE="" style="width: 194px;"></TD>");
			out.println("</TR>");
			out.println("<TR>");
                        out.println(" <TD><B><I><font color=HotPink>Sensor type:&nbsp;</TD>");
                        out.println(" <TD style="width: 205px;"><INPUT TYPE="text" NAME="search_sensor_type"
					VALUE="" style="width: 194px;"></TD>");
			out.println("</TR>");
                        out.println(" <TR>");
			out.println("<TD><B><I><font color=HotPink>Time period:</font></I></B></TD>");
			out.println("<TD><label for="from"><font color=HotPink>&nbsp;From</font></label>");
                        out.println(" <INPUT TYPE="text" class="from" NAME="from" /></TD>");
			out.println("<TD><label for="to"><font color=HotPink >To</font></label>");
                        out.println(" <INPUT TYPE="text" class="to" NAME="to" /><font color=HotPink >*</font></TD>");
                        out.println("</TR>");
                        out.println("</TABLE>");
                        out.println(" <br><B><I><font color=HotPink>filter by:</font></I></B><select NAME="OPERATION">");
			out.println("<option VALUE="newest-to-oldest" SELECTED>newest to oldest</option>");
			out.println("<option VALUE="oldest-to-newest" SELECTED>oldest to newest</option>");
		        out.println("</select> <input TYPE="submit" NAME="CommitSearch" VALUE="Search"><br>");
                        out.println(" <BR></BR>");
                        out.println("<b><font color=Gold>Here is the list of all sensor records for satisfied the search condition.</font></b>");

        
                        if (request.getParameter("CommitSearch") != null) {
                                if(!(request.getParameter("search_key").equals("")&&
                                     request.getParameter("search_location").equals("")&&
                                     request.getParameter("search_sensor_type").equals("")&&
                                     request.getParameter("from").equals("") &&
                                     request.getParameter("to").equals(""))) {
			             String op = request.getParameter("OPERATION").trim();
            	                     if(request.getParameter("from").equals("") && request.getParameter("to").equals("")){
            		                   out.println("<br><b>Cannot filter by best match if there is no search key</b>");
            	                     }
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
                                }

                  
				if(request.getParameter("search_key").equals("")){
				    	sqlString = "SELECT DISTINCT ar.recording_id,ar.date_created, ar.length, ar.recording_data, ar.description"
				    		+"i.image_id, i.date_created, i.recorded_data,i.thumbnail, i.description "
                                                +"sd.id, sd.date_created, sd.value"
				    		+"FROM audio_recordings ar, images i, scalar_data sd WHERE ";
				    	if(((String)session.getAttribute("role")).equals("s")){
						sqlString = sqlString +"ar.sensor_id = "+sensorId+", i.sensor_id = "+sensorId+", sd.sensor_id = "+sensorId+" " ;
					}

					if(!(request.getParameter("from").equals(""))){
						from = (String)request.getParameter("from");
						sqlString = sqlString + "ar.date_created >= to_date('"+from+"','MM/DD/YYYY')"
                                                         +" AND i.date_created  >= to_date('"+from+"','MM/DD/YYYY')"
                                                         +" AND sd.date_created >= to_date('"+from+"','MM/DD/YYYY')";
					}
					if(!(request.getParameter("to").equals(""))){
						to = (String)request.getParameter("to");
						sqlString = sqlString + "ar.date_created <= to_date('"+to+"','MM/DD/YYYY') "
                                                         + " AND i.date_created  >= to_date('"+to+"','MM/DD/YYYY') "
                                                         +" AND sd.date_created >= to_date('"+to+"','MM/DD/YYYY') ";
					}
				 } 
				        


				 if(op.equals("newest-to-oldest")){
				    	sqlString = sqlString + "ORDER BY ar.date_created DESC, i.date_created DESC, sd.date_created DESC";
				 }
				 else if(op.equals("oldest-to-newest")){
				    	sqlString = sqlString + "ORDER BY ar.date_created ASE, i.date_created ASE, sd.date_created ASE";
				 }


				try{
					PreparedStatement setTimeFormat = con.prepareStatement("alter SESSION set NLS_DATE_FORMAT = 'MM/DD/YYYY'");
					setTimeFormat.executeQuery();
					PreparedStatement dropTableName = con.prepareStatement(dropFullname);
					PreparedStatement createTableName = con.prepareStatement(crFullname);
					createTableName.executeQuery();
					PreparedStatement createIndexName = con.prepareStatement(crIndexName);
					createIndexName.executeQuery();
					PreparedStatement takeImageID = con.prepareStatement("select image_id from images where sensor_id = ?");
					PreparedStatement doGenerate = con.prepareStatement(sqlString);
					ResultSet rset2 = doGenerate.executeQuery();
					ResultSet imageID = null;

					out.println("<br>");
				        out.println("<br>");
				        if(!(request.getParameter("search_key").equals("") &&
				             request.getParameter("from").equals("") &&
				             request.getParameter("to").equals(""))){
						out.println("All records with "+search_key+" key words from "+from+" to "+to+":");
                                        }
                                        else if(request.getParameter("search_key").equals("") && 
						request.getParameter("from").equals("") &&
                                                request.getParameter("to").equals("")){
						out.println("All records from "+from+" to "+to+":");
                                        }
					else if(!request.getParameter("search_location").equals("") && 
						request.getParameter("from").equals("") &&
                                                request.getParameter("to").equals("")){	
						out.println("All records with "+search_location+" from "+from+" to "+to+":");
                                        }
				        else if (!request.getParameter("search_sensor_type").equals("") && 
						request.getParameter("from").equals("") &&
                                                request.getParameter("to").equals(""))	{
						out.println("All records with "+search_sensor_type+" from "+from+" to "+to+":");
                                        }
					else if (!request.getParameter("search_sensor_type").equals("") && 
                                                 !request.getParameter("search_location").equals("") &&
						 request.getParameter("from").equals("") &&
                                                 request.getParameter("to").equals(""))	{
					         out.println("All records with sensor type "+search_sensor_type+" and "+search_location+" from "+from+" to "+to+":");
                                        }
					else if (!request.getParameter("search_key").equals("") && 
                                                 !request.getParameter("search_location").equals("") &&
						 request.getParameter("from").equals("") &&
                                                 request.getParameter("to").equals(""))	{
						 out.println("All records with keyword "+search_key+" and "+search_location+" from "+from+" to "+to+":");
                                        }
				        else if (!request.getParameter("search_sensor_type").equals("") && 
                                                 !request.getParameter("search_key").equals("") &&
						 request.getParameter("from").equals("") &&
                                                 request.getParameter("to").equals(""))	{
						 out.println("All records with sensor type "+search_sensor_type+" and "+search_key+" from "+from+" to "+to+":");
                                        }
					else if (!request.getParameter("search_sensor_type").equals("") && 
                                                 !request.getParameter("search_location").equals("") &&
                                                 !request.getParameter("search_key").equals("") &&
						 request.getParameter("from").equals("") &&
                                                 request.getParameter("to").equals(""))		
						 out.println("All records with sensor type "+search_sensor_type+" and "+search_location+" and key "+search_key+" from "+from+" to "+to+":");
                                        }
						  	

                                        out.println("<br>");
					out.println("*date format is MM/DD/YYYY");
					out.println("<br>");
					out.println("*click on the thumbnail to see details");
					out.println("<br>");
					out.println("<table border=1>");
					out.println("<tr>");

                                }
				catch(SQLException e){
					out.println("SQLException: " +e.getMessage());
					con.rollback();
				}
				out.println("</table>");
			}
			con.close();
            	}

            }
            	
          else
            {
              out.println("<br><b>Search condition is missing.</b>");
            }
        }
      %>
	</FORM>
	
	
	<CENTER>User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a></CENTER>
</BODY>
</HTML>



