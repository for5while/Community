<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>로그인 결과</title>
	</head>
	<body>
		<%
		String memberID = null;
		String password = null;
		
		if(request.getParameter("memberID") != "") memberID = request.getParameter("memberID");
		if(request.getParameter("password") != "") password = request.getParameter("password");
		
		if(memberID == "" || password == "") {
			out.print("<script type='text/javascript'>");
			out.print("alert('필수사항이 입력되지 않았습니다.');");
			out.print("history.back();");
			out.print("</script>");
		} else {
			MemberDAO mdao = MemberDAO.getInstance();
			
			int loginCheck = mdao.loginCheck(memberID, password);

			if(loginCheck == -1 || loginCheck == 1) {
				// 메시지를 하나로 띄워주는 이유는 메시지로 추측한 해킹 시도를 막기 위함
				out.print("<script type='text/javascript'>");
				out.print("alert('아이디가 존재하지 않거나 비밀번호가 일치하지 않습니다.');");
				out.print("history.back();");
				out.print("</script>");
				return;
			} else if(loginCheck == 2) {
				// 세션 사라질 때 emailSendPro에서 인식해주기 위함 
				if(session.getAttribute("memberID") == null) session.setAttribute("memberID", memberID);
				
				out.print("<script type='text/javascript'>");
				out.print("var emailChecked = confirm('" + mdao.getMemberEmail(memberID) + " 이메일로 인증 확인 이메일을 전송해드렸습니다.\\n이메일을 확인하세요.\\n\\n만약 이메일을 발신받지 못했을 경우 [확인]을 누르시면\\n재발신 요청이 가능합니다.');");
				out.print("if(emailChecked) { location.href = 'emailSendPro.jsp'; }");
				out.print("else { history.back(); } ");
				out.print("</script>");
				
				return;
			}

			session.setAttribute("memberID", memberID);
			response.sendRedirect("../index.jsp");
		}
		%>
	</body>
</html>