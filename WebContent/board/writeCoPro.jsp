<%@page import="member.MemberDAO"%>
<%@page import="board.BoardDAO"%>
<%@page import="board.BoardBean"%>
<%@page import="java.sql.Timestamp"%>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>댓글쓰기 결과</title>
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
		|| request.getParameter("co_content") == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('비정상적인 접근입니다.');");
			out.print("location.href = '../index.jsp';");
			out.print("</script>");
			return;
		}
		
		// 입력받은 폼 & 파라미터 처리
		String table = request.getParameter("table");
		String content = request.getParameter("co_content");
		int id = Integer.parseInt(request.getParameter("id"));
		int commentID = 0;
		int group = 0;
		
		// 대댓글 관련 필수 파라미터 (없으면 일반 댓글로 작성 됨)
		if(request.getParameter("co_id") != null) commentID = Integer.parseInt(request.getParameter("co_id"));
		if(request.getParameter("group") != null) group = Integer.parseInt(request.getParameter("group"));

		if(content == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('입력되지 않은 정보가 있습니다.');");
			out.print("history.back();");
			out.print("</script>");
		} else {
			BoardBean bb = new BoardBean();
			Timestamp time = new Timestamp(System.currentTimeMillis());
			
			// not null 구조로 인한 기본값 처리
			bb.setOption(0);
			bb.setSubject("");
			bb.setHit(0);
			bb.setGood(0);
			bb.setFile(0);
			
			// 사용되는 필수 정보 BoardBean에 담아주기
			bb.setId(id);
			bb.setContent(content);
			bb.setMemberId(writeMemberId);
			bb.setDatetime(time);
			bb.setLast(time);
			bb.setIp(request.getRemoteAddr());

			BoardDAO bdao = BoardDAO.getInstance();
			bdao.writeComment(bb, table, id, commentID, group);

			out.print("<script type='text/javascript'>");
			out.print("location.href='view.jsp?table=" + table + "&id=" + id + "';");
			out.print("</script>");
		}
		%>
	</body>
</html>