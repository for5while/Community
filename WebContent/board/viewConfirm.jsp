<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@page import="member.MemberBean"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="../main/head.jsp" />

<%
String memberID = null;
String table = null;
int id = 0;

if(request.getParameter("table") == null || request.getParameter("id") == null) {
	out.print("<script type='text/javascript'>");
	out.print("alert('비정상적인 접근입니다.');");
	out.print("location.href = '../index.jsp';");
	out.print("</script>");
	return;
}

if(session.getAttribute("memberID") != null) memberID = (String)session.getAttribute("memberID");

table = request.getParameter("table");
id = Integer.parseInt(request.getParameter("id"));

BoardDAO bdao = BoardDAO.getInstance();
BoardBean getWrite = bdao.getWrite(table, id);

MemberDAO mdao = MemberDAO.getInstance();
MemberBean getMember = mdao.getMember(getWrite.getMemberId());

// 글 작성자이거나 관리자일 때는 패스워드 입력 X
if(memberID != null) {
	if(memberID.equals(getWrite.getMemberId()) || memberID.equals("admin")) {
		response.sendRedirect("../board/view.jsp?table=" + table + "&id=" + id);
		return;
	}
} else {
	out.print("<script type='text/javascript'>");
	out.print("alert('비밀글은 회원만 볼 수 있습니다.');");
	out.print("location.href = '../member/login.jsp';");
	out.print("</script>");
	return;
}
%>

<div id="modify">
	<div class="wrap">
		<div class="logo">비밀번호 확인</div>
		<p class="write_info">
			<span><%=getMember.getNick() %></span>
			<span class="division_bar">|</span>
			<span><%=getWrite.getSubject() %></span>
		</p>
		<form action="viewConfirmPro.jsp" method="post" name="vc" onsubmit="return view_confirm_submit();">
			<input type="hidden" name="table" value="<%=table %>">
			<input type="hidden" name="id" value="<%=id %>">
			<p><input type="password" name="password" maxlength="10" placeholder="게시글의 비밀번호를 입력하세요." required></p>
			<p><input type="submit" class="btn_submit" value="확인"></p>
		</form>
		
		<script type="text/javascript">
			function view_confirm_submit() {
				if(!vc.password.value) {
					alert("게시글의 비밀번호를 입력해주세요.");
					vc.password.focus();
					return false;
				}
				
				return true;
			}
		</script>
	</div>
</div>

<jsp:include page="../main/tail.jsp" />