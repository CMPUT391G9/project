<HTML>
<BODY>
<%
	session.removeAttribute("USERNAME");
	session.removeAttribute("PASSWORD");
	session.removeAttribute("person_id");
	session.removeAttribute("role");
	response.sendRedirect("Login.html");
%>
</BODY>
</HTML>