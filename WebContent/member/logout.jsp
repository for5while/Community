<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>로그아웃</title>
	</head>
	<body>
	<%
	if(session.getAttribute("memberID") == null) {
		out.print("<script type='text/javascript'>");
		out.print("alert('이미 로그아웃 된 상태입니다.');");
		out.print("history.back();");
		out.print("</script>");
		return;
	} else {
		session.invalidate();
		response.sendRedirect("../index.jsp");
	}
	%>
	</body>
</html>