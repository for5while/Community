<%@page import="member.MemberDAO"%>
<%@page import="gallery.GalleryBean"%>
<%@page import="gallery.GalleryDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String pageName = "writePro.jsp"; // 기본 페이지명
String memberID = null;
String table = null;
boolean emailCheck = false;

memberID = (String)session.getAttribute("memberID");
table = request.getParameter("table");

MemberDAO mdao = MemberDAO.getInstance();
emailCheck = mdao.getMemberEmailChecked(memberID);

if(memberID == null || !emailCheck) {
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

GalleryBean bb = new GalleryBean();
GalleryDAO bdao = GalleryDAO.getInstance();

// 글 수정
if(request.getParameter("modify") != null && request.getParameter("id") != null) {
	
	bb = bdao.readModify(Integer.parseInt(request.getParameter("id")), table);

	// 글 작성자의 아이디와 내 아이디가 동일한지
	if(memberID.equals(bb.getMemberId())) {
		bb = bdao.readModify(bb.getId(), table);
		pageName = "modifyPro.jsp";
	} else {
		out.print("<script type='text/javascript'>");
		out.print("alert('권한이 없습니다.');");
		out.print("location.href = 'list.jsp?table=" + table + "';");
		out.print("</script>");
		return;
	}
}
%>

<jsp:include page="../main/head.jsp" />

<link href="../css/board.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="../css/summernote/summernote-lite.min.css">
<script src="../js/summernote/summernote-lite.min.js"></script>
<script src="../js/summernote/lang/summernote-ko-KR.min.js"></script>

<div id="board">
	<div class="write">
		<form action="<%=pageName %>?table=<%=table %><% if("modifyPro.jsp".equals(pageName)) { %>&id=<%=bb.getId() %>&modify=1<% } %>" method="post"<% if("writePro.jsp".equals(pageName)) { %> enctype="Multipart/form-data" <% } %>name="fw" onsubmit="return writeForm_submit();">
			<p><input type="text" class="subject" name="subject" maxlength="100" placeholder="제목"<% if(bb.getSubject() != null) { %>value="<%=bb.getSubject() %>"<% } %>required></p>
			<p><textarea rows="17" id="summernote" class="content" name="content" placeholder="내용" required><% if(bb.getContent() != null) { %><%=bb.getContent() %><% } %></textarea></p>
			<div class="upload">
				<input type="file" name="file" required>
				<span>대표이미지 가능 확장자: jpg</span>
			</div>
			<div id="guide">
				<p class="word">반드시 읽어보세요.</p>
				<ul>
					<li>대표 이미지 업로드는 필수이며 썸네일 이미지로 처리합니다.</li>
					<li>사이트 정책에 어긋나는 글 작성 시 경고없이 <span>"글 삭제/활동제한 조치"</span>가 이뤄질 수 있습니다.</li>
				</ul>
			</div>
			<div class="click">
				<p>
					<input type="button" class="btn btn_cancle" onclick="back()" value="취소">
					<input type="submit" class="btn btn_write" value="글쓰기">
				</p>
			</div>
		</form>
		
		<script type="text/javascript">
		$(document).ready(function() {
			$('#summernote').summernote({
				height: 350,
				lang: 'ko-KR',
				placeholder: "사이트 정책에 어긋나는 글 작성 시 경고없이 글 삭제/활동제한 조치가 이뤄질 수 있습니다.",
	            fontNames: ['Nanum Gothic', 'sans-serif', '돋움', 'Courier New', 'Helvetica', 'Tahoma', 'Verdana', 'Roboto'],
	            fontSizes: ['8', '11', '12', '14', '18', '24', '36'],
	            toolbar: [
	                ['font', ['bold', 'italic', 'underline', 'clear']],
	                ['fontname', ['fontname']],
	                ['color', ['color']],
	                ['fontsize', ['fontsize']],
	                ['para', ['paragraph']],
	                ['height', ['height']],
	                ['table', ['table']],
	                ['insert', ['link', 'picture']],
	                ['view', ['fullscreen', 'codeview']],
	                ['help', ['help']]
	              ]
			});
		});

		var checkUnload = 1;
		window.onbeforeunload = function() {
			if(checkUnload) {
				return "이 페이지를 벗어나면 작성중인 글은 사라집니다.";
			}
		}
		
		function back() {
			var submit = confirm('글 작성을 취소하면 현재 작성중인 글은 모두 사라집니다.\n그래도 취소하시겠습니까?');
			
			if(submit) location.href = "list.jsp?table=<%=table %>";
		}
		
		function writeForm_submit() {
			checkUnload = 0;
			var input = document.getElementById('password');
			
			if(!fw.subject.value) {
				alert("글 제목을 입력해주세요.");
				fw.subject.focus();
				return false;
			} else if(!fw.content.value) {
				alert("글 내용을 입력해주세요.");
				fw.content.focus();
				return false;
			}
			
			return true;
		}
		</script>
	</div>
</div>

<jsp:include page="../main/tail.jsp" />