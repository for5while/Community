<%@page import="member.MemberBean"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="../main/head.jsp" />
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<%
String memberID = null; 

if(session.getAttribute("memberID") != null) { memberID = (String)session.getAttribute("memberID"); }
else { response.sendRedirect("../index.jsp"); }

MemberDAO mdao = MemberDAO.getInstance();
MemberBean getMember = mdao.getMember(memberID);
%>

<div id="modify">
	<div class="wrap">
		<div class="logo">비밀번호 확인</div>
		<form action="modifyBeforePro.jsp" method="post" name="fm" onsubmit="return fmodifyform_submit();">
			<p><input type="text" name="memberID" maxlength="15" value="<%=memberID %>" readonly="readonly" style="ime-mode:disabled;cursor:default;background:#DDD" onkeyup="this.value=this.value.replace(/[^a-zA-Z-_0-9]/g,'');" required></p>
			<p><input type="password" name="password" maxlength="50" placeholder="★ 비밀번호" required></p>

			<p><input type="submit" class="btn_submit" value="확인"></p>
		</form>
		
		<script type="text/javascript">
			function fmodifyform_submit() {
				if(!fm.password.value) {
					alert("비밀번호를 입력해주세요.");
					fm.password.focus();
					return false;
				}
				
				return true;
			}
		</script>
	</div>
</div>

<jsp:include page="../main/tail.jsp" />