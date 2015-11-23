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
	
	int num = 1;
	
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
        	Statement s = con.createStatement();
        	ResultSet resSet = null;
			String personID = (String)session.getAttribute("person_id");
			//out.println(personID);
			String sqlstr = null;
            sqlstr = "SELECT sensor_id FROM subscriptions WHERE person_id = "+personID;
        
	        resSet = s.executeQuery(sqlstr);
	        Integer sensorId =null;
	        while (resSet.next()){
	        	out.println("asdfasd");
	        	sensorId = resSet.getInt("sensor_id");
	        }
	        out.println(sensorId);
                        
 
            out.println("<BR></BR>");
            out.println("<BR></BR>");
	        out.println("<H1><font color=Gold><CENTER>Hello Scientist! This is the search page.</CENTER></font></H1>");
            out.println("<BR></BR>");
            out.println("<H2><font color=Gold>Please enter the Information you want to Search: </font></H2>");
	        out.println("<FORM NAME='search_form' ACTION='Search.jsp' METHOD='post'>");
		    out.println("<TABLE>");
			out.println("<TR>");
			out.println("<TD><B><I><font color=HotPink>Search keys:&nbsp;&nbsp;&nbsp;</TD>");
<<<<<<< HEAD
			out.println("<TD><INPUT TYPE='text' NAME='search_key' VALUE=''>");
			out.println("</TR>");
			out.println("<TR>");
            out.println("<TD><B><I><font color=HotPink>Location:&nbsp;</TD>");
            out.println("<TD><INPUT TYPE='text' NAME='search_location' VALUE=''></TD>");
=======
			out.println("<TD><INPUT TYPE='text' NAME='search_key' VALUE=''></TD>");
			out.println("</TR>");
			out.println("<TR>");
            out.println(" <TD><B><I><font color=HotPink>Location:&nbsp;</TD>");
            out.println(" <TD><INPUT TYPE='text' NAME='search_location' VALUE=''></TD>");
>>>>>>> f553d6a5fa074fe7571283318b7c32a20544b99e
			out.println("</TR>");
			out.println("<TR>");
            out.println(" <TD><B><I><font color=HotPink>Sensor type:&nbsp;</TD>");
            out.println(" <TD><INPUT TYPE='text' NAME='search_sensor_type' VALUE=''></TD>");
			out.println("</TR>");
            out.println(" <TR>");
			out.println("<TD><B><I><font color=HotPink>Time period:</font></I></B></TD>");
			out.println("<TD><label for='from'><font color=HotPink>&nbsp;From</font></label>");
<<<<<<< HEAD
            out.println(" <INPUT TYPE='text' class='from' NAME='from'></TD>");
			out.println("<TD><label for='to'><font color=HotPink >To</font></label>");
            out.println(" <INPUT TYPE='text' class='to' NAME='to'><font color=HotPink >*</font></TD>");
            out.println("</TR>");
            out.println("</TABLE>");
		    out.println("</select> <input TYPE='submit' NAME='CommitSearch' VALUE='Search'><br>");
            out.println(" <BR></BR>");
            out.println("<b><font color=Gold>Here is the list of all sensor records for satisfied the search condition.</font></b>");

=======
            out.println(" <INPUT TYPE='text' class='from' NAME='from' /></TD>");
			out.println("<TD><label for='to'><font color=HotPink >To</font></label>");
            out.println(" <INPUT TYPE='text' class='to' NAME='to' /><font color=HotPink >*</font></TD>");
            out.println("</TR>");
            out.println("</TABLE>");
            out.println(" <br><B><I><font color=HotPink>filter by:</font></I></B><select NAME='OPERATION'>");
			out.println("<option VALUE='a' SELECTED>newest to oldest</option>");
			out.println("<option VALUE='b' SELECTED>oldest to newest</option>");
		    out.println("</select> <input TYPE='submit' NAME='CommitSearch' VALUE='Search'><br>");
            out.println(" <BR></BR>");
            out.println("<b><font color=Gold>Here is the list of all sensor records for satisfied the search condition.</font></b>");
>>>>>>> f553d6a5fa074fe7571283318b7c32a20544b99e

            String sqlString = "";
	    	String fdate = request.getParameter("from");
	    	String tdate = request.getParameter("to");
			String searchKey = request.getParameter("search_key");
            String searchLocation = request.getParameter("search_location");
            String searchSType= request.getParameter("search_sensor_type");
        
            if (request.getParameter("CommitSearch") != null) {
<<<<<<< HEAD
            	
            	if(request.getParameter("from").equals("") &&
            	   request.getParameter("to").equals("")) {
            		out.println("<br><b>Must select a time period to search.</b>");
                }
            	
            	out.println("haha");
            	
            	
            	
            	sqlString = "SELECT distinct ar.recording_id,ar.date_created, ar.length, ar.recorded_data, ar.description"
				    		+"i.image_id, i.date_created, i.recoreded_data,i.thumbnail, i.description "
                          +"sd.id, sd.date_created, sd.value"
				    		+"FROM audio_recordings ar, images i, scalar_data sd WHERE "; 
            	
				
				    		
            	if(((String)session.getAttribute("role")).equals("s")){
            		sqlString = sqlString +"ar.sensor_id ="+sensorId+", AND i.sensor_id = "+sensorId+", AND sd.sensor_id = "+sensorId ;
            		out.println("hehe");
			    }
				    	

            	if(fdate != null){
				    sqlString = sqlString + "ar.date_created >= to_date('"+fdate+"','MM/DD/YYYY')"
				                          +" AND i.date_created  >= to_date('"+fdate+"','MM/DD/YYYY')"
                                        +" AND sd.date_created >= to_date('"+fdate+"','MM/DD/YYYY')";
				    out.println("heihei");
            	}

            	if(tdate != null){

            		sqlString = sqlString + "ar.date_created <= to_date('"+tdate+"','MM/DD/YYYY') "
                                        + " AND i.date_created  >= to_date('"+tdate+"','MM/DD/YYYY') "
                                        +" AND sd.date_created >= to_date('"+tdate+"','MM/DD/YYYY') ";
            		out.println("lala");
            	} 
			
=======
            	if(!(request.getParameter("search_key").equals("")&&
                	request.getParameter("search_location").equals("")&&
                    request.getParameter("search_sensor_type").equals("")&&
                    request.getParameter("from").equals("") &&
                    request.getParameter("to").equals(""))) {
            	
            		String op1 = "a"
      					String op = request.getParameter("OPERATION");
  	                    if(request.getParameter("from").equals("") && request.getParameter("to").equals("")){
  		                	out.println("<br><b>Cannot filter if there is no search key</b>");
  	                    }
                }
			    else{
					String dropFullname = "DROP TABLE fullname";
	            	String crFullname = "CREATE TABLE fullname AS "+"(SELECT person_id, CONCAT(CONCAT(first_name,' '),last_name) as full_name FROM persons)";
					String crIndexName = "CREATE INDEX name ON fullname(full_name) INDEXTYPE IS CTXSYS.CONTEXT";
					String search_key = "";
                    String search_location = "";
                    String search_sensor_type = "";
					String OracleId=(String)session.getAttribute("ORACLE_ID");
					String OraclePassword=(String)session.getAttribute("ORACLE_PASSWORD");
                }

                  
				if(request.getParameter("search_key").equals("")){
				    	String sqlString = "SELECT DISTINCT ar.recording_id,ar.date_created, ar.length, ar.recording_data, ar.description"
				    		+"i.image_id, i.date_created, i.recorded_data,i.thumbnail, i.description "
                                                +"sd.id, sd.date_created, sd.value"
				    		+"FROM audio_recordings ar, images i, scalar_data sd WHERE ";
				    	if(((String)session.getAttribute("role")).equals("s")){
						sqlString = sqlString +"ar.sensor_id = "+sensorId+", i.sensor_id = "+sensorId+", sd.sensor_id = "+sensorId+" " ;
					}

					if(!(request.getParameter("from").equals(""))){
						String from = (String)request.getParameter("from");
						sqlString = sqlString + "ar.date_created >= to_date('"+from+"','MM/DD/YYYY')"
                                                         +" AND i.date_created  >= to_date('"+from+"','MM/DD/YYYY')"
                                                         +" AND sd.date_created >= to_date('"+from+"','MM/DD/YYYY')";
					}
					if(!(request.getParameter("to").equals(""))){
						String to = (String)request.getParameter("to");
						sqlString = sqlString + "ar.date_created <= to_date('"+to+"','MM/DD/YYYY') "
                                                         + " AND i.date_created  >= to_date('"+to+"','MM/DD/YYYY') "
                                                         +" AND sd.date_created >= to_date('"+to+"','MM/DD/YYYY') ";
					}
				 } 
				        
>>>>>>> f553d6a5fa074fe7571283318b7c32a20544b99e

            	
            	
            	try{
					/* PreparedStatement setTimeFormat = con.prepareStatement("alter SESSION set NLS_DATE_FORMAT = 'MM/DD/YYYY'");
					setTimeFormat.executeQuery(); */
					
					num = num+170;
					
					Statement ss = con.createStatement();
					num = 173;
					
		        	ResultSet rs = null;
		        	num = 176;
		        	
		        	rs = ss.executeQuery(sqlString);
		        	num = 179;
					
					/* PreparedStatement doGenerate = con.prepareStatement(sqlString);
					ResultSet rset2 = doGenerate.executeQuery(); */
					
					num = num +177;
					
					out.println("<br>");
				  	out.println("<br>");
				  	
				  	if (searchKey == null && searchLocation == null && searchSType == null){
	            		out.println("All records from "+fdate+" to "+tdate+":");
	            	}
				

<<<<<<< HEAD
	            	if (searchKey == null && searchLocation == null) {
	            		out.println("All records with sensor type "+searchSType+" from "+fdate+" to "+tdate+":");
	            	}
=======
				 if(op1 == "a"){
				    	sqlString = sqlString + "ORDER BY ar.date_created DESC, i.date_created DESC, sd.date_created DESC";
				 }
				 else if(op1 == "b")){
				    	sqlString = sqlString + "ORDER BY ar.date_created ASE, i.date_created ASE, sd.date_created ASE";
				 }
>>>>>>> f553d6a5fa074fe7571283318b7c32a20544b99e

	            	if (searchKey == null){
	            		out.println("All records with sensor type "+searchSType+" and "+searchLocation+" from "+fdate+" to "+tdate+":");
	            		}

	            	if (searchSType == null && searchLocation == null){
	            		out.println("All records with "+searchKey+" key words from "+fdate+" to "+tdate+":");
	            		}
				

	            	if (searchSType == null && searchKey == null){
	            		out.println("All records with "+searchLocation+" from "+fdate+" to "+tdate+":");
	            		}
				

	            	if (searchLocation == null){
	            		out.println("All records with sensor type "+searchSType+" and "+searchKey+" from "+fdate+" to "+tdate+":");
	            	}
				

	            	if (searchSType == null){
	            		out.println("All records with keyword "+searchKey+" and "+searchLocation+" from "+fdate+" to "+tdate+":");

	            	}
	            	
				  	out.println("<br>");
				  	out.println("*date format is MM/DD/YYYY");
				  	out.println("<br>");
				  	out.println("*click on the thumbnail to see details");
				  	out.println("<br>");
					out.println("<table border=1>");
					out.println("<tr>");
					out.println("<th>Record ID</th>");
					out.println("<th></th>");
					out.println("<th>Sensor ID</th>");
					out.println("<th>Test Date*</th>");
					out.println("<th>Prescribing Date*</th>");
					out.println("<th>Diagnosis*</th>");
					out.println("<th>Description</th>");
					out.println("<th>Thumbnail Record Photos*</th>");
					out.println("</tr>");


            	}
            	
            	catch(SQLException e){
            		out.println("xixi");
            		out.println("<hr>"+e.getMessage()+"<hr>");
                    con.rollback();
				}
            	
            	con.close();
            	
            }
            
        }
        
        else {
        	response.sendRedirect("Login.html");
        }
	}
	
	out.println(num);
            	
	
    
    %>
	</FORM>
	
	
	<CENTER>User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a></CENTER>
</BODY>
</HTML>



