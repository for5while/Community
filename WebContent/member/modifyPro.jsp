<%@page import="member.MemberDAO"%>
<%@page import="member.MemberBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>회원정보수정 결과</title>
	</head>
	<body>
		<%
		request.setCharacterEncoding("utf-8");
		
		String memberID = null;
		String password = null;
		String nick = null;
		String zip = null;
		String addr1 = null;
		String addr2 = null;
		
		if(request.getParameter("memberID") != null) memberID = request.getParameter("memberID");
		if(request.getParameter("password") != null) password = request.getParameter("password");
		if(request.getParameter("nick") != null) nick = request.getParameter("nick");
		if(request.getParameter("zip") != null) zip = request.getParameter("zip");
		if(request.getParameter("addr1") != null) addr1 = request.getParameter("addr1");
		if(request.getParameter("addr2") != null) addr2 = request.getParameter("addr2");
		
		if(memberID == null || password == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('유효하지 않은 정보입니다.');");
			out.print("history.back();");
			out.print("</script>");
		} else {
			MemberDAO mdao = MemberDAO.getInstance();
			
			boolean idChk = mdao.getMemberIdChk(memberID);
			boolean nickChk = mdao.getMemberNickChk(nick);
			
			// 닉네임 중복 체크
			if(nickChk) {
				out.print("<script type='text/javascript'>");

				if(nickChk) out.print("alert('이미 존재하는 닉네임입니다.');");
				
				out.print("history.back();");
				out.print("</script>");
			} else {
				session.setAttribute("memberID", memberID);
	
				MemberBean mb = new MemberBean();
				
				mb.setId(memberID);
				mb.setPassword(password);
				mb.setNick(nick);
				mb.setZip(zip);
				mb.setAddr1(addr1);
				mb.setAddr2(addr2);
	
				mdao.modifyMember(mb);

				out.print("<script type='text/javascript'>");
				out.print("alert('회원정보수정이 완료 되었습니다.');");
				out.print("location.href='../index.jsp';");
				out.print("</script>");
			}
		}
		%>
	</body>
</html>