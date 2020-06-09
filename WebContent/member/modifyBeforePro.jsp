<%@page import="member.MemberDAO"%>
<%@page import="member.MemberBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>비밀번호 확인</title>
	</head>
	<body>
		<%
		request.setCharacterEncoding("utf-8");
		
		String memberID = null;
		String password = null;
		String modifyBefore = null;
		
		if(request.getParameter("memberID") != null) memberID = request.getParameter("memberID");
		if(request.getParameter("password") != null) password = request.getParameter("password");
		
		if(memberID == null || password == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('유효하지 않은 정보입니다.');");
			out.print("history.back();");
			out.print("</script>");
			return;
		} else {
			MemberDAO mdao = MemberDAO.getInstance();
			MemberBean getMember = mdao.getMember(memberID);

			if(!password.equals(getMember.getPassword())) {
				out.print("<script type='text/javascript'>");
				out.print("alert('비밀번호가 틀렸습니다.');");
				out.print("history.back();");
				out.print("</script>");
				return;
			} else {
				session.setAttribute("memberID", memberID);
				session.setAttribute("memberModify", "1"); // 이 세션값이 없으면 회원정보수정 페이지 접속 불가

				response.sendRedirect("../member/modify.jsp");
			}
		}
		%>
	</body>
</html>