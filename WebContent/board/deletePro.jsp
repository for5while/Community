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
		<title>글삭제 결과</title>
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

		if(request.getParameter("table") == null || request.getParameter("id") == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('비정상적인 접근입니다.');");
			out.print("location.href = '../index.jsp';");
			out.print("</script>");
			return;
		}
		
		String table = request.getParameter("table");
		int id = Integer.parseInt(request.getParameter("id"));
		
		// 댓글 파라미터 넘어왔을 때
		int commentID = 0;
		if(request.getParameter("co_id") != null) commentID = Integer.parseInt(request.getParameter("co_id")); 
		
		String memberID = (String)session.getAttribute("memberID");
		session.setAttribute("memberID", memberID);
		
		BoardDAO bdao = BoardDAO.getInstance();
		BoardBean bb = new BoardBean();
		
		String writeMemberID = bdao.getWriteMember(id, table);
		
		// 글 작성자가 내가 아닐 때
		if(!memberID.equals(writeMemberID) && !memberID.equals("admin")) {
			out.print("<script type='text/javascript'>");
			out.print("alert('권한이 없습니다.');");
			out.print("location.href='list.jsp?table=" + table + "';");
			out.print("</script>");
			return;
		}
		
		// 삭제
		String paramID = "";
		String pageName = "list";
		
		if(commentID == 0) {
			bb.setId(id);
			bdao.writeDelete(bb, table, -1, 1);
		} else {
			bb.setId(commentID);
			bdao.writeDelete(bb, table, id, 2);

			pageName = "view";
			paramID = "&id=" + id;
		}

		out.print("<script type='text/javascript'>");
		out.print("location.href='" + pageName + ".jsp?table=" + table + paramID +"';");
		out.print("</script>");
		%>
	</body>
</html>