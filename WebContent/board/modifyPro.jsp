<%@page import="member.MemberDAO"%>
<%@page import="board.BoardDAO"%>
<%@page import="board.BoardBean"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>글수정 결과</title>
	</head>
	<body>
		<%
		request.setCharacterEncoding("utf-8");
		
		boolean emailCheck = false;
		String writeMemberId = (String)session.getAttribute("memberID");

		MemberDAO mdao = MemberDAO.getInstance();
		emailCheck = mdao.getMemberEmailChecked(writeMemberId);

		if(writeMemberId == null || !emailCheck) {
			out.print("<script type='text/javascript'>");
			out.print("alert('로그인이 필요합니다.');");
			out.print("location.href = '../member/login.jsp';");
			out.print("</script>");
			return;
		}

		if(request.getParameter("table") == null 
		|| request.getParameter("id") == null 
		|| request.getParameter("modify") == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('비정상적인 접근입니다.');");
			out.print("location.href = '../index.jsp';");
			out.print("</script>");
			return;
		}
		
		String table = request.getParameter("table");

		// 입력받은 폼 처리
		int option = 0;
		int id = 0;
		String subject = null;
		String content = null;
		String password = null;
		
		if(request.getParameter("option") != null) option = Integer.parseInt(request.getParameter("option"));
		if(request.getParameter("subject") != null) subject = request.getParameter("subject");
		if(request.getParameter("content") != null) content = request.getParameter("content");
		if(request.getParameter("password") != null) password = request.getParameter("password");
		if(request.getParameter("id") != null) id = Integer.parseInt(request.getParameter("id"));
		
		if(id == 0 || (option == 1 && password == null) || subject == null || content == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('입력되지 않은 정보가 있습니다.');");
			out.print("history.back();");
			out.print("</script>");
			return;
		} else {
			String memberID = (String)session.getAttribute("memberID");
			session.setAttribute("memberID", memberID);
			
			BoardDAO bdao = BoardDAO.getInstance();
			BoardBean bb = new BoardBean();
			
			String writeMemberID = bdao.getWriteMember(id, table);
			
			// 글 작성자가 내가 아닐 때
			if(!memberID.equals(writeMemberID)) {
				out.print("<script type='text/javascript'>");
				out.print("alert('권한이 없습니다.');");
				out.print("location.href='list.jsp?table=" + table + "';");
				out.print("</script>");
				return;
			}
			
			// DB NOT NULL 기본값 처리
			String memberId = writeMemberID;
			Timestamp last = new Timestamp(System.currentTimeMillis());

			bb.setId(id);
			bb.setOption(option);
			bb.setSubject(subject);
			bb.setContent(content);
			bb.setMemberId(writeMemberID);
			bb.setPassword(password);
			bb.setLast(last);

			bdao.writeModify(bb, table);

			out.print("<script type='text/javascript'>");
			out.print("location.href='list.jsp?table=" + table + "';");
			out.print("</script>");
		}
		%>
	</body>
</html>