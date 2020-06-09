<%@ page import="member.MemberDAO"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.BoardBean"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.io.File" %>
<%@ page import="java.awt.Graphics2D" %>
<%@ page import="java.awt.image.renderable.ParameterBlock" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.media.jai.JAI" %>
<%@ page import="javax.media.jai.RenderedOp" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>글쓰기 결과</title>
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
		
		if(request.getParameter("table") == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('비정상적인 접근입니다.');");
			out.print("location.href = '../index.jsp';");
			out.print("</script>");
			return;
		}
		
		String table = request.getParameter("table");

		// 입력받은 폼 처리
		int option = 0;
		String subject = null;
		String content = null;
		String password = null;
		int file = 0;

		if(request.getParameter("option") != null) option = Integer.parseInt(request.getParameter("option"));
		if(request.getParameter("subject") != null) subject = request.getParameter("subject");
		if(request.getParameter("content") != null) content = request.getParameter("content");
		if(request.getParameter("password") != null) password = request.getParameter("password");

		if((option == 1 && password == null) || subject == null || content == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('입력되지 않은 정보가 있습니다.');");
			out.print("history.back();");
			out.print("</script>");
			return;
		} else {
			session.setAttribute("memberID", writeMemberId);
			
			// DB NOT NULL 기본값 처리
			int idx = 0;
			int id = 0;
			int commentID = 0;
			int commentGroup = 0;
			int commentSequen = 0;
			int hit = 0;
			int good = 0;
			String memberId = writeMemberId;
			Timestamp datetime = new Timestamp(System.currentTimeMillis());
			Timestamp last = new Timestamp(System.currentTimeMillis());
			String ip = request.getRemoteAddr();

			BoardBean bb = new BoardBean();
			
			bb.setIdx(idx);
			bb.setId(id);
			bb.setCommentID(commentID);
			bb.setCommentGroup(commentGroup);
			bb.setCommentSequen(commentSequen);
			bb.setOption(option);
			bb.setSubject(subject);
			bb.setContent(content);
			bb.setHit(hit);
			bb.setGood(good);
			bb.setMemberId(writeMemberId);
			bb.setPassword(password);
			bb.setDatetime(datetime);
			bb.setLast(last);
			bb.setIp(ip);
			
			// 내용에 이미지가 있을 때
			if(content.contains("<img")) {
				file = 1;
			}
			
			bb.setFile(file);

			BoardDAO bdao = BoardDAO.getInstance();
			bdao.writeBoard(bb, table);

			out.print("<script type='text/javascript'>");
			out.print("location.href='list.jsp?table=" + table + "';");
			out.print("</script>");
		}
		%>
	</body>
</html>