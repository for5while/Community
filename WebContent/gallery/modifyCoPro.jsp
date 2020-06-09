<%@page import="member.MemberDAO"%>
<%@page import="gallery.GalleryDAO"%>
<%@page import="gallery.GalleryBean"%>
<%@page import="java.sql.Timestamp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>댓글수정 결과</title>
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
		|| request.getParameter("co_id") == null
		|| request.getParameter("modify") == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('비정상적인 접근입니다.');");
			out.print("location.href = '../index.jsp';");
			out.print("</script>");
			return;
		}
			
		String table = request.getParameter("table");

		// 입력받은 파라미터 처리
		int id = 0;
		int commentID = 0;
		String content = null;

		if(request.getParameter("id") != null) id = Integer.parseInt(request.getParameter("id"));
		if(request.getParameter("co_id") != null) commentID = Integer.parseInt(request.getParameter("co_id"));
		if(request.getParameter("co_content") != null) content = request.getParameter("co_content");

		if(id == 0 || commentID == 0 || content == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('입력되지 않은 정보가 있습니다.');");
			out.print("history.back();");
			out.print("</script>");
			return;
		} else {
			String memberID = (String)session.getAttribute("memberID");
			session.setAttribute("memberID", memberID);
			
			GalleryDAO bdao = GalleryDAO.getInstance();
			GalleryBean bb = new GalleryBean();
			
			String writeMemberID = bdao.getWriteCommentMember(commentID, table);
			
			// 글 작성자가 내가 아닐 때
			if(!memberID.equals(writeMemberID)) {
				out.print("<script type='text/javascript'>");
				out.print("alert('권한이 없습니다.');");
				out.print("location.href='view.jsp?table=" + table + "&id=" + id + "';");
				out.print("</script>");
				return;
			}

			// 댓글 수정
			bb.setCommentID(commentID);
			bb.setContent(content);
			
			bdao.commentModify(bb, table);

			out.print("<script type='text/javascript'>");
			out.print("location.href='view.jsp?table=" + table + "&id=" + id + "';");
			out.print("</script>");
		}
		%>
	</body>
</html>