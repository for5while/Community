<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
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
		String table = null;
		int id = 0;
		
		if(session.getAttribute("memberID") != null) memberID = (String)session.getAttribute("memberID");
		if(request.getParameter("password") != null) password = request.getParameter("password");
		if(request.getParameter("table") != null) table = request.getParameter("table");
		if(request.getParameter("id") != null) id = Integer.parseInt(request.getParameter("id"));  
		
		if(memberID == null || password == null || table == null || id == 0) {
			out.print("<script type='text/javascript'>");
			out.print("alert('유효하지 않은 정보입니다.');");
			out.print("history.back();");
			out.print("</script>");
			return;
		} else {
			MemberDAO mdao = MemberDAO.getInstance();
			MemberBean getMember = mdao.getMember(memberID);
			
			BoardDAO bdao = BoardDAO.getInstance();
			BoardBean getWrite = bdao.getWrite(table, id);
			
			// 해당 게시글의 비밀번호가 일치하지 않을 때
			if(!password.equals(getWrite.getPassword())) {
				out.print("<script type='text/javascript'>");
				out.print("alert('비밀번호가 틀렸습니다.');");
				out.print("history.back();");
				out.print("</script>");
				return;
			}
			
			// view 페이지에서 이 세션으로 저장 되어있으면 비밀번호 질의 없이 바로 글을 볼 수 있도록 위함
			session.setAttribute("secretTable", table);
			session.setAttribute("secretID", id);

			response.sendRedirect("../board/view.jsp?table=" + table + "&id=" + id);
		}
		%>
	</body>
</html>