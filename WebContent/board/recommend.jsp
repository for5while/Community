<%@page import="member.MemberDAO"%>
<%@page import="board.BoardDAO"%>
<%@page import="board.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>추천 결과</title>
	</head>
	<body>
		<%
		request.setCharacterEncoding("utf-8");
		
		boolean emailCheck = false;
		String memberID = (String)session.getAttribute("memberID");

		MemberDAO mdao = MemberDAO.getInstance();
		emailCheck = mdao.getMemberEmailChecked(memberID);

		if(memberID == null || !emailCheck) {
			out.print("<script type='text/javascript'>");
			out.print("alert('로그인이 필요합니다.');");
			out.print("location.href = '../member/login.jsp';");
			out.print("</script>");
			return;
		}
		
		if(request.getParameter("table") == null
		|| request.getParameter("flag") == null
		|| request.getParameter("type") == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('비정상적인 접근입니다.');");
			out.print("location.href = '../index.jsp';");
			out.print("</script>");
			return;
		}
		
		int type = Integer.parseInt(request.getParameter("type"));
		int id = 0;
		int commentID = 0;
		
		if(type == 1) {
			if(request.getParameter("id") == null) {
				out.print("<script type='text/javascript'>");
				out.print("alert('비정상적인 접근입니다.');");
				out.print("location.href = '../index.jsp';");
				out.print("</script>");
				return;
			} else {
				id = Integer.parseInt(request.getParameter("id"));
			}
		} else {
			if(request.getParameter("id") == null || request.getParameter("co_id") == null) {
				out.print("<script type='text/javascript'>");
				out.print("alert('비정상적인 접근입니다.');");
				out.print("location.href = '../index.jsp';");
				out.print("</script>");
				return;
			} else {
				id = Integer.parseInt(request.getParameter("id"));
				commentID = Integer.parseInt(request.getParameter("co_id"));
			}
		}
		
		// 입력받은 폼 & 파라미터 처리
		String table = request.getParameter("table");
		int flag = Integer.parseInt(request.getParameter("flag"));
		
		if(flag != 1 && flag != 2 || type != 1 && type != 2) {
			out.print("<script type='text/javascript'>");
			out.print("alert('비정상적인 접근입니다.');");
			out.print("location.href = '../index.jsp';");
			out.print("</script>");
			return;
		}
		
		BoardBean bb = new BoardBean();
		BoardDAO bdao = BoardDAO.getInstance();

		String flagName = null;
		int flagCheck = 0;
		
		if(type == 1) flagCheck = bdao.getRecommend(table, id, memberID, type);
		else flagCheck = bdao.getRecommend(table, commentID, memberID, type);
		
		if(flagCheck == 1) flagName = "추천";
		else if(flagCheck == 2) flagName = "비추천";
		
		// 추천 or 비추천 이미 했다면
		if(flagCheck > 0) {
			out.print("<script type='text/javascript'>");
			out.print("alert('이미 " + flagName + "하셨습니다.');");
			out.print("location.href='view.jsp?table=" + table + "&id=" + id + "';");
			out.print("</script>");
			return;
		}
		
		// 사용되는 필수 정보 BoardBean에 담아주기
		if(type == 1) bb.setId(id);
		else bb.setCommentID(commentID);
		bb.setMemberId(memberID);
		bb.setGood(flag);
		
		bdao.setRecommend(bb, table, type);
		
		if(flag == 1) flagName = "추천";
		else if(flag == 2) flagName = "비추천";
		
		out.print("<script type='text/javascript'>");
		out.print("alert('" + flagName + "을 전달했습니다.');");
		out.print("location.href='view.jsp?table=" + table + "&id=" + id + "';");
		out.print("</script>");
		%>
	</body>
</html>