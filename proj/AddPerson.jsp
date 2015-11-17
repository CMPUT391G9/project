<HTML>
<HEAD>
	<TITLE>Add Person Page</TITLE>
</HEAD>
<BODY background="login.jpg">
	<%@ page import="java.sql.*"%>
	<%
		if(request.getParameter("AddPerson")!=null && ((String)session.getAttribute("role"))!=null){
			out.println("<H1><CENTER><font color =Gold> New Person Register: </font></CENTER></H1>");
			out.println("<HR></HR>");
			out.println("<FORM NAME='AddPersonFrom' ACTION='AddPersonComm.jsp' METHOD='post'>");
			out.println("	<TABLE style='margin: 0px auto'>");
			out.println("		<TR>");
			out.println("			<B><I><font color=Gold> First Name: </font></I></B>");
			out.println("			<INPUT TYPE='text' NAME='FirstName' VALUE=''>");
			out.println("		</TR>");
			out.println("		<TR>");
			out.println("			<B><I><font color=Gold> Last Name: </font></I></B>");
			out.println("			<INPUT TYPE='text' NAME='LastName' VALUE=''>");
			out.println("		</TR>");
			out.println("		<TR>");
			out.println("			<B><I><font color=Gold> Address: </font></I></B></TD>");
			out.println("			<INPUT TYPE='text' NAME='Address' VALUE=''>");
			out.println("		</TR>");
			out.println("		<TR>");
			out.println("			<B><I><font color=Gold> Email: </font></I></B>");
			out.println("			<INPUT TYPE='text' NAME='Email' VALUE=''>");
			out.println("		</TR>");
			out.println("		<TR>");
			out.println("			<B><I><font color=Gold> Phone: </font></I></B>");
			out.println("			<INPUT TYPE='text' NAME='Phone' VALUE=''>");
			out.println("		</TR>");
			out.println("	</TABLE>");
			out.println("   <HR></HR>");
			out.println("   <CENTER><INPUT TYPE='submit' NAME='AddPersonComm' VALUE='Add'></CENTER>");
			out.println("</FORM>");
			
			
			out.println("<FORM NAME='CancelForm' ACTION='administrator.jsp' METHOD='get'>");
			out.println("    <CENTER><INPUT TYPE='submit' NAME='cancel' VALUE='cancel'></CENTER>");
			out.println("</FORM>");
		}
		else{
			out.println("<p><b>You have no right to use this module</b></p>");
			out.println("<p><b>Press RETURN to the login page.</b></p>");
			out.println("<FORM NAME='NotAllowFrom' ACTION='Login.html' METHOD='get'>");
			out.println("    <CENTER><INPUT TYPE='submit' NAME='NOT_ALLOW' VALUE='RETURN'></CENTER>");
			out.println("</FORM>");
		}
	%>
</BODY>
</HTML>