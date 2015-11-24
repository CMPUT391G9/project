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
 	<%@ page import="java.io.*"%>
 	<%@ page import="java.util.*"%>
 	<%@ page import="java.servlet.*"%>
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
			out.println("<CENTER><INPUT TYPE='submit' NAME='CONNECTION_FAIL' VALUE='Return'></CENTER>");
			out.println("</FORM>");
		}
		
        if (canConnect){
        	Statement s = con.createStatement();
        	
        	
        	ResultSet resSet = null;
			String personID = (String)session.getAttribute("person_id");
			String sqlstr = null;
            sqlstr = "SELECT * FROM subscriptions WHERE person_id = "+personID;
         	out.println("<BR></BR>");
        
	        resSet = s.executeQuery(sqlstr);
	        Integer sensorId =null;
	        while (resSet.next()){
	        	sensorId = resSet.getInt("sensor_id");
	        	out.println("<H2><CENTER><font color=Gold>Your subscribed sensor id is:"+sensorId+"</font></CENTER></H2>");
	        }
	        
	        
	        ResultSet rrss=null;
	        String sqlStatement = "SELECT * FROM persons WHERE person_id="+personID;
	        rrss=s.executeQuery(sqlStatement);
			while(rrss != null && rrss.next()){
				String fname=rrss.getString("first_name");
				String lname=rrss.getString("last_name"); 
				out.println("<H2><CENTER><font color=Gold>Scientist: "+fname+" "+lname+" &nbsp;&nbsp;person ID: "+personID+"</font></CENTER></H2>");
			}
                        
 
            out.println("<BR></BR>");
	        out.println("<H1><font color=Gold><CENTER>Hello Scientist! This is the search page.</CENTER></font></H1>");
            out.println("<BR></BR>");
            out.println("<H2><font color=Gold>Please enter the Information you want to Search: </font></H2>");
	        out.println("<FORM NAME='search_form' ACTION='Search.jsp' METHOD='post'>");
		    out.println("<TABLE>");
			out.println("<TR>");
			out.println("<TD><B><I><font color=HotPink>Search keys:&nbsp;&nbsp;&nbsp;</TD>");
			out.println("<TD><INPUT TYPE='text' NAME='search_key' VALUE=''>");
			out.println("</TR>");
			out.println("<TR>");
            out.println("<TD><B><I><font color=HotPink>Location:&nbsp;</TD>");
            out.println("<TD><INPUT TYPE='text' NAME='search_location' VALUE=''></TD>");
			out.println("</TR>");
			out.println("<TR>");
            out.println(" <TD><B><I><font color=HotPink>Sensor type:&nbsp;</TD>");
            out.println(" <TD><INPUT TYPE='text' NAME='search_sensor_type' VALUE=''></TD>");
			out.println("</TR>");
            out.println(" <TR>");
			out.println("<TD><B><I><font color=HotPink>Time period:</font></I></B></TD>");
			out.println("<TD><label for='from'><font color=HotPink>&nbsp;From</font></label>");
            out.println(" <INPUT TYPE='text' class='from' NAME='from'></TD>");
			out.println("<TD><label for='to'><font color=HotPink >To</font></label>");
            out.println(" <INPUT TYPE='text' class='to' NAME='to'><font color=HotPink >*</font></TD>");
            out.println("</TR>");
            out.println("</TABLE>");
		    out.println("</select> <input TYPE='submit' NAME='CommitSearch' VALUE='Search'><br>");
            out.println(" <BR></BR>");
            out.println("<b><font color=Gold>Here is the list of all sensor records for satisfied the search condition.</font></b>");


            String sqlString = "";
	    	String fdate = request.getParameter("from");
	    	String tdate = request.getParameter("to");
			String searchKey = request.getParameter("search_key");
            String searchLocation = request.getParameter("search_location");
            String searchSType= request.getParameter("search_sensor_type");
        
            if (request.getParameter("CommitSearch") != null) {
            	
            	if(request.getParameter("from").equals("") &&
            	   request.getParameter("to").equals("")) {
            		out.println("<br><b>Must select a time period to search.</b>");
                } 
            	
            
            	
            	int i = 0;
            	sqlString =" SELECT * FROM sensors s, images i, audio_recordings ar WHERE ";
            	
            	if (searchKey != "") {
            		sqlString = sqlString + "s.description like '%" +searchKey+"%' "
        					+ "OR (s.sensor_id = ar.sensor_id AND ar.description LIKE '%" +searchKey+ "%') "
        					+ "OR (s.sensor_id = i.sensor_id AND i.description LIKE '%" +searchKey+ "%')";
        			i++;
            	}
            	

            	if (searchLocation != "" ){
            		if (i > 0 ) {
            			sqlString = sqlString + " AND ";  
            		}
            		sqlString = sqlString + "s.location = '"+searchLocation+"'";
        			i++;
            	}
            	
            	if (searchSType != ""){
            		if (i > 0 ){
            			sqlString = sqlString + " AND ";           			
            		}
            		sqlString = sqlString + "s.sensor_type = '"+searchSType+"'";
        			i++;
            	}
            	


			    Statement ss = con.createStatement();
			    ResultSet rs = null;
            	
            	try{


		        	rs = ss.executeQuery(sqlString);
		        	

            	}
            	
            	catch(SQLException e){
            		out.println("<hr>"+e.getMessage()+"<hr>");
                    /* con.rollback(); */
				}
			 
            	
            	ArrayList<ArrayList<String>> matchSensor = new ArrayList();
           
            	if (rs != null){
            		
                while(rs.next()){
   					 ArrayList<String> searchSensors = new ArrayList();
   					 
   					 for (i=1;i<=10;i++){
   						 Object object = rs.getObject(i);
   						 if (object != null){
   							 searchSensors.add(object.toString());
   						
   						 }
   					 }
   					 
   					 matchSensor.add(searchSensors);
   					/*  out.println(matchSensor); */
   					 }
   				}
            	

            	ResultSet rss = null;
            	String ssql = "";

            	for (ArrayList<String> sensor: matchSensor){
            		
            		String ty = sensor.get(2);
            		
            		if (ty =="a"){
            			
            			ssql = "SELECT * FROM audio_recordings "
            					+ "WHERE date_created BETWEEN to_date('"+fdate+"','MM/DD/YYYY') "
            					+ "AND to_date('"+tdate+"','MM/DD/YYYY')";
            		} 
            		else if (ty =="i"){


            			ssql = "SELECT * FROM images "
            					+"WHERE date_created BETWEEN to_date('"+fdate+"','MM/DD/YYYY') "
            					+"AND to_date('"+tdate+"','MM/DD/YYYY')";
            		}
            		else if (ty =="s"){
            			ssql = "SELECT * FROM scalar_data "
            					+"WHERE date_created BETWEEN to_date('"+fdate+"','MM/DD/YYYY') "
            					+ "AND to_date('"+tdate+"','MM/DD/YYYY'))";
            		}
            		
            		try {       	
            			
    		        	rss = ss.executeQuery(ssql);	
    		        	/* while (rs.next()) {
    		        		Date dateCreated = rss.getDate("date_created");
    		        		System.out.println(dateCreated + "\t" );
    		        	} */
            		}
            		catch(SQLException e){
            			out.println("<hr>"+e.getMessage()+"<hr>");
            		}
            		
            	}
            	
			 
            	rs = null;
            	ArrayList<ArrayList<String>> subSensor = new ArrayList();
            	for (ArrayList<String> sensor: matchSensor) {
            		sqlString = sqlstr+ " AND sensor_id ="+ sensor.get(0);           		
            		try{
            		rs = ss.executeQuery(sqlString);
            		/* Object obj = rs.getObject(1);
            		subSensor.add(obj); */
            		}
            		catch(SQLException e){
            			out.println("<hr>"+e.getMessage()+"<hr>");
            			out.println("Invalid subscription.");
            		}
            		if (rs != null){
            		subSensor.add(sensor);
            		/* out.println(subSensor); */
            		}
            		
            	}
            	
            	
            	if (subSensor.size()==0){
            		out.println("You have 0 subscribed sensor.");
            	}
            	else{
            		out.println("<CENTER>");
            		out.println("<table>");
            		out.println("<tr>");
            		out.println("<th>sensor id</th>");
            		out.println("<th>sensor location</th>");
            		out.println("<th>sensor type</th>");
            		out.println("<th>sensor description</th>");
            		out.println("<th>blob data</th>");
            		out.println("</tr>");
            		
            		for(ArrayList<String> showSensor: subSensor) {
            			String query = "";
            			String showId = showSensor.get(0);
            			if (showSensor.get(2)=="a"){
                			query = "SELECT * FROM audio_recordings WHERE sensor_id = " +showId;
                		}
                		else if (showSensor.get(2)=="i"){
                			query = "SELECT * FROM images WHERE sensor_id = " +showId;
                		}
                		else if (showSensor.get(2)=="s"){
                			query = "SELECT * FROM scalar_data WHERE sensor_id = " +showId;
                		}
        
   
            			
            			try{
            				rs=ss.executeQuery(query);
            				
            		            
            			}
            			catch(SQLException e){
                			out.println("<hr>"+e.getMessage()+"<hr>");
                		}
            			
            			if (rs!= null){
            				while(rs.next()){
            					/* ResultSetMetaData rsMD = rs.getMetaData();
            					int j = rsMD.getColumnCount();
            					String printId = rs.getObject(1).toString();
            					String print */
            					
            					/* http://docs.oracle.com/javase/7/docs/api/java/sql/ResultSetMetaData.html */
            				    ResultSetMetaData rsmd = rs.getMetaData();
            				    int numberOfColumns = rsmd.getColumnCount();
            				   /*  Blob blob = rs.getBlob(); */
            				    String id = rs.getString(1).toString();
            				    /* Date date = new Date(); */ 
            				    /* java.util.Date date;
            				    Timestamp timestamp = rs.getTimestamp(3);
            				    if (timestamp != null){
            				    date = new java.util.Date(timestamp.getTime());
            				    } */
            				    /* String date = rs.getDate(3).toString(); */

            				    
            				    
                        		out.println("<tr>");
                        		out.println(showSensor.get(0));
                        		out.println(showSensor.get(1));
                        		out.println(showSensor.get(2));
                        		out.println(showSensor.get(3));
                        		out.println(id);
                        		out.println("</tr>");
            				}
            			} 
            			
            			
            			
            		}
            		
            		out.println("</table>");
            		out.println("</CENTER>");
            		
            	}
            	
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
            	
            	con.close();
            	
            }
            
        }
        
        else {
        	out.println("<p><b>You have no right to use this module</b></p>");
			out.println("<p><b>Press RETURN to the login page.</b></p>");
			out.println("<FORM NAME='NotAllowFrom' ACTION='Login.html' METHOD='get'>");
			out.println("<CENTER><INPUT TYPE='submit' NAME='NOT_ALLOW' VALUE='RETURN'></CENTER>");
			out.println("</FORM>");
        }
	}
	
	out.println(num);
            	
	
    
    %>
    <FORM NAME='ReturnForm' ACTION='scientist.jsp' METHOD='get'>
	<CENTER><INPUT TYPE='submit' NAME='return' VALUE='Back'></CENTER>
	</FORM>
	
	
	<CENTER>User Documentation:<a href='Documentation.html' target ='_blank'><b>Documentation</b></a></CENTER>
</BODY>
</HTML>



