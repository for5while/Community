<%@page import="member.MemberDAO"%>
<%@page import="sun.security.jca.GetInstance"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// memberID 세션이 null이 아닐 때
if(session.getAttribute("memberID") != null) {
	MemberDAO mdao = MemberDAO.getInstance();
	String memberID = (String)session.getAttribute("memberID");
	
	// 이메일 인증을 완료했을 때
	if(mdao.getMemberEmailChecked(memberID)) {
		out.print("<script type='text/javascript'>");
		out.print("alert('이미 로그인이 된 상태입니다.');");
		out.print("location.href = '../index.jsp';");
		out.print("</script>");
		return;
	}
}
%>
<jsp:include page="../main/head.jsp" />

<div id="login">
	<div class="wrap">
		<div class="logo">Login</div>
		
		<form action="loginPro.jsp" method="post" name="fl" onsubmit="return floginform_submit();">
			<p><input type="text" id="id" class="input" name="memberID" maxlength="15" placeholder="아이디" style="ime-mode:disabled" onkeyup="this.value=this.value.replace(/[^a-zA-Z-_0-9]/g,'');" required></p>
			<p><input type="password" class="input" name="password" maxlength="50" placeholder="비밀번호" required></p>

			<p><input type="submit" class="btn_submit" value="로그인"></p>
		</form>
		
		<div class="link">
			<a class="reg" href="register.jsp">회원가입</a>
		</div>
		
		<script type="text/javascript">
			function floginform_submit() {
				if(!fl.id.value) {
					alert("아이디를 입력해주세요.");
					fl.id.focus();
					return false;
				} else if(!fl.password.value) {
					alert("비밀번호를 입력해주세요.");
					fl.password.focus();
					return false;
				}
				
				return true;
			}
		</script>
	</div>
</div>

<jsp:include page="../main/tail.jsp" />