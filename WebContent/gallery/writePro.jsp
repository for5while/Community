<%@page import="thumbnail.ThumbnailDAO"%>
<%@ page import="member.MemberDAO"%>
<%@ page import="gallery.GalleryDAO"%>
<%@ page import="gallery.GalleryBean"%>
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
		
		/*
		** form의 enctype을 Multipart/form-data로 사용했으므로
		** 모든 Parameter는 MultipartRequest 객체를 통해 받아야 함
		*/
		
		// 이미지 업로드
		String imagePath = application.getRealPath("/data/image/");
		ServletContext context = request.getServletContext();
		
		int maxSize = 10 * 1024 * 1024;
		String encoding = "UTF-8";
		String filename = "";

		MultipartRequest mr 
		= new MultipartRequest(request, imagePath, maxSize, encoding,
						new DefaultFileRenamePolicy());
		
		Enumeration files = mr.getFileNames();
		
		String fileSys = (String)files.nextElement();
		filename = mr.getFilesystemName(fileSys);

		// 입력받은 폼 처리
		int option = 0;
		String subject = null;
		String content = null;
		String password = null;
		int file = 0;

		if(mr.getParameter("option") != null) option = Integer.parseInt(mr.getParameter("option"));
		if(mr.getParameter("subject") != null) subject = mr.getParameter("subject");
		if(mr.getParameter("content") != null) content = mr.getParameter("content");
		if(mr.getParameter("password") != null) password = mr.getParameter("password");
		
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

			GalleryBean bb = new GalleryBean();
			
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

			ParameterBlock pb = new ParameterBlock();
			pb.add(imagePath+"/"+filename);
			RenderedOp rOp = JAI.create("fileload",pb);
		
			BufferedImage bi = rOp.getAsBufferedImage();
			BufferedImage thumb = new BufferedImage(192, 120, BufferedImage.TYPE_INT_RGB);
		
			Graphics2D g = thumb.createGraphics();
			g.drawImage(bi, 0, 0, 192, 120, null);
		
			File fileThumb = new File(imagePath+"/"+filename);
			ImageIO.write(thumb, "jpg", fileThumb);
			
			// 첨부파일 업로드
			String fileName = mr.getOriginalFileName("file");
			String fileSourceName = mr.getFilesystemName("file");
			
			ThumbnailDAO tdao = ThumbnailDAO.getInstance();
		
			file = 1;
			tdao.upload(fileName, fileSourceName, table);
		
			bb.setFile(file);

			GalleryDAO bdao = GalleryDAO.getInstance();
			bdao.writeBoard(bb, table);

			out.print("<script type='text/javascript'>");
			out.print("location.href='list.jsp?table=" + table + "';");
			out.print("</script>");
		}
		%>
	</body>
</html>