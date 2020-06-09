<%@page import="util.SHA256"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");

	String code = request.getParameter("code");
	MemberDAO mdao = MemberDAO.getInstance();
	
	String memberID = null;
	if(session.getAttribute("memberID") != null) {
		memberID = (String) session.getAttribute("memberID");
	} else {
		out.print("<script type='text/javascript'>");
		out.print("alert('로그인을 해주세요.');");
		out.print("location.href = 'login.jsp'");
		out.print("</script>");
		return;
	}
	
	String memberEmail = mdao.getMemberEmail(memberID);

	new SHA256();
	boolean rightCode = (SHA256.getSHA256(memberEmail).equals(code)) ? true : false;
	
	// 코드 유효하고 이메일 인증 완료하지 않았으면 난수 컬럼 초기화 및 인증 완료 설정
	if(rightCode == true && !mdao.getMemberEmailChecked(memberID)) {
		mdao.setMemberEmailChecked(memberID);
		
		out.print("<script type='text/javascript'>");
		out.print("alert('이메일 인증에 성공했습니다!\\n로그인을 해주세요.');");
		
		session.invalidate();
		
		out.print("location.href = 'login.jsp'");
		out.print("</script>");
		return;
	} else {
		out.print("<script type='text/javascript'>");
		out.print("alert('유효하지 않은 코드입니다.');");
		out.print("location.href = '../index.jsp'");
		out.print("</script>");
		return;
	}
%>