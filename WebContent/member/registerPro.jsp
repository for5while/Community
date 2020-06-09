<%@page import="member.MemberDAO"%>
<%@page import="member.MemberBean"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="util.SHA256" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>회원가입 결과</title>
	</head>
	<body>
		<%
		request.setCharacterEncoding("utf-8");
		
		// 입력받은 폼 처리 (선택사항: zip, addr1, addr2)
		String memberID = null;
		String password = null;
		String nick = null;
		String email = null;
		String zip = null;
		String addr1 = null;
		String addr2 = null;
		
		if(request.getParameter("memberID") != null) memberID = request.getParameter("memberID");
		if(request.getParameter("password") != null) password = request.getParameter("password");
		if(request.getParameter("nick") != null) nick = request.getParameter("nick");
		if(request.getParameter("email") != null) email = request.getParameter("email");
		if(request.getParameter("zip") != null) zip = request.getParameter("zip");
		if(request.getParameter("addr1") != null) addr1 = request.getParameter("addr1");
		if(request.getParameter("addr2") != null) addr2 = request.getParameter("addr2");
		
		if(memberID == null || password == null || nick == null || email == null) {
			out.print("<script type='text/javascript'>");
			out.print("alert('유효하지 않은 정보입니다.');");
			out.print("history.back();");
			out.print("</script>");
			return;
		} else {
			MemberDAO mdao = MemberDAO.getInstance();
			
			boolean idChk = mdao.getMemberIdChk(memberID);
			boolean nickChk = mdao.getMemberNickChk(nick);
			boolean emailChk = mdao.getMemberEmailChk(email);
			
			// 중복이 하나라도 존재한다면
			if(idChk || nickChk || emailChk) {
				out.print("<script type='text/javascript'>");
				
				if(idChk) out.print("alert('이미 존재하는 아이디입니다.');");
				else if(nickChk) out.print("alert('이미 존재하는 닉네임입니다.');");
				else if(emailChk) out.print("alert('이미 사용중인 이메일입니다.');");
				
				out.print("history.back();");
				out.print("</script>");
			} else {
				session.setAttribute("memberID", memberID);
				
				// DB 기본값 처리
				int no = 1;
				int level = 1;
				int point = 0;
				String ip = request.getRemoteAddr();
				Timestamp dateTime = new Timestamp(System.currentTimeMillis()); // 가입일시
				String leaveDate = ""; // 탈퇴일자
				int emailCertify = 0; // 이메일 인증여부
				String emailCertify2 = SHA256.getSHA256(email); // 이메일인증 SHA256 난수 암호화
				String lostCertify = ""; // 비밀번호 분실
	
				MemberBean mb = new MemberBean();
				
				mb.setId(memberID);
				mb.setPassword(password);
				mb.setNick(nick);
				mb.setEmail(email);
				mb.setZip(zip);
				mb.setAddr1(addr1);
				mb.setAddr2(addr2);
				mb.setNo(no);
				mb.setLevel(level);
				mb.setPoint(point);
				mb.setIp(ip);
				mb.setDatetime(dateTime);
				mb.setLeaveDatetime(leaveDate);
				mb.setEmailCertify(emailCertify);
				mb.setEmailCertify2(emailCertify2);
				mb.setLostCertify(lostCertify);
	
				mdao.insertMember(mb);
				
				// 이메일 전송 후 인증 대기 페이지로 이동
				out.print("<script type='text/javascript'>");
				out.print("location.href='emailSendPro.jsp';");
				out.print("</script>");
			}
		}
		%>
	</body>
</html>