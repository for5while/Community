<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDateTime"%>
<%@ page import="member.MemberDAO"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="gallery.GalleryBean" %>
<%@ page import="gallery.GalleryDAO" %>
<%@ page import="thumbnail.ThumbnailBean" %>
<%@ page import="thumbnail.ThumbnailDAO" %>
<%@ page import="java.util.ArrayList" %>

<%
request.setCharacterEncoding("UTF-8");

if(request.getParameter("id") == null) { // 뷰 페이지일 때
%>
<link href="../css/board.css" rel="stylesheet" type="text/css">
<jsp:include page="../main/head.jsp" />
<%
}
%>

<%
int type = 0;
int id = 0;
String table = null;
String keyword = null;

// project 게시판은 갤러리 리스트 페이지 따로 나눔
if(request.getParameter("table") != null
&& "project".equals(request.getParameter("table"))) {
	table = request.getParameter("table");
} else {
	out.print("<script type='text/javascript'>");
	out.print("alert('비정상적인 접근입니다.');");
	out.print("location.href = '../index.jsp';");
	out.print("</script>");
	return;
}

if(request.getParameter("type") != null && request.getParameter("keyword") != null) {
	type = Integer.parseInt(request.getParameter("type"));
	keyword = request.getParameter("keyword");
}

if(request.getParameter("id") != null) {
	id = Integer.parseInt(request.getParameter("id"));
}

GalleryDAO bdao = GalleryDAO.getInstance();
GalleryBean bb = new GalleryBean();

int count = bdao.getWriteCount(table, type, keyword);

// 페이징
int pageSize = 16; // 현재 페이지에 보여 줄 글 갯수
int pageN = 1; // 현재 페이지

if(request.getParameter("pageN") != null) {
	pageN = Integer.parseInt(request.getParameter("pageN"));
}

// 페이지 시작, 끝 번호
int startRow = ((pageN-1) * pageSize)+1; // ((현재페이지-1) * 페이지 최대 글 갯수)+1)
int endRow = pageN * pageSize; // 현재페이지 * 페이지 최대 글 갯수

ArrayList<GalleryBean> list = bdao.getList(startRow, pageSize, table, type, keyword);

ThumbnailDAO tdao = ThumbnailDAO.getInstance();
ArrayList<ThumbnailBean> thumbnailList = tdao.getList();
%>

<div id="board">
	<div class="list gallery">
		<div class="count"><span class="material-icons">library_books</span>게시글 <%=count %></div>
		<%
		int listSize = list.size();

		Timestamp now = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat date1 = new SimpleDateFormat("MM-dd");
		SimpleDateFormat date2 = new SimpleDateFormat("HH:mm");
		String date3 = null;

		for(int i=0; i<listSize; i++) {
			
			if(date1.format(list.get(i).getDatetime()).equals(date1.format(now))) {
				date3 = date2.format(list.get(i).getDatetime());
			} else {
				date3 = date1.format(list.get(i).getDatetime());
			}
			
			int commentCount = bdao.getCommentCount(list.get(i).getId(), table);
			String noMargin = null; // 4번째 마다 margin-right 삭제

			// 썸네일 보여주기
			for(ThumbnailBean thumb : thumbnailList) {
				if(list.get(i).getId() == thumb.getId()) {
					noMargin = (i > 0) ? (i%4 == 3) ? " no_margin" : "" : "";
				%>
			<div class="contentBox<%=noMargin %>">
				<div class="thumbnail">
					<a href="view.jsp?table=<%=table %>&id=<%=list.get(i).getId() %><% if(request.getParameter("pageN") != null) { %>&pageN=<%=pageN %><% } %>">
						<img src='<%=request.getContextPath() %>/ThumbnailAction?file=<% out.print(java.net.URLEncoder.encode(thumb.getName(), "UTF-8")); %>'>
					</a>
				</div>
					<%
					}
				}
				%>
				<div class="top">
					<a href="view.jsp?table=<%=table %>&id=<%=list.get(i).getId() %><% if(request.getParameter("pageN") != null) { %>&pageN=<%=pageN %><% } %>" title="<%=list.get(i).getSubject() %>">
						<span class="subject">
							<span class="text"><%=list.get(i).getSubject() %></span>
							<% if(list.get(i).getNewWrite() == 1) { %><span class="ico_new"></span><% } %>
						</span>
						<span class="date">
							<span class="material-icons gallery">event</span>
							<%=date3 %>
						</span>
					</a>
				</div>
				<div class="bottom">
					<span class="nick"><%=list.get(i).getMemberId() %></span>
					<span class="right">
						<span class="co_count"><span class="material-icons gallery padding">comment</span><%=commentCount %></span>
						<span class="co_recommend">
							<span class="material-icons gallery">thumb_up_alt</span>
							<%
							if(list.get(i).getGood() == 0) out.println("0");
							else if(list.get(i).getGood() > 0) out.println("<span class='good'>" + list.get(i).getGood() + "</span>");
							else out.println("<span class='nogood'>" + list.get(i).getGood() + "</span>");
							%>
						</span>
						<span class="hit"><span class="material-icons gallery padding">visibility</span><%=list.get(i).getHit() %></span>
					</span>
				</div>
			</div>
		<%
		}
		list.clear();
		
		if(count <= 0) { %>
			<div class="empty_table">적막이 흐르는 이곳에 누군가 글을 남겨줄 것만 같은 느낌이에요! ✺◟(∗❛ัᴗ❛ั∗)◞✺</div>
		<% } %>
	
		<div class="foot">
			<div class="search">
				<form action="list.jsp?table=<%=table %>&pageN=<%=pageN %>" method="post">
					<select name="type">
						<option value="1">제목</option>
						<option value="2">내용</option>
						<option value="3">제목+내용</option>
						<option value="4">글쓴이</option>
					</select>
					<input type="text" class="keyword" name="keyword" placeholder="검색어 입력">
					<button name="search_submit"><span class="material-icons">search</span></button>
				</form>
			</div>
			<%
			boolean emailCheck = false;

			if(session.getAttribute("memberID") != null) {
				String memberID = (String)session.getAttribute("memberID");
				
				MemberDAO mdao = MemberDAO.getInstance();
				emailCheck = mdao.getMemberEmailChecked(memberID);
				
				if(emailCheck) {
			%>
			<div class="btn">
				<a href="write.jsp?table=<%=table %>"><input type="button" class="btn_write" value="글쓰기"></a>
			</div>
			<%
				}
			}
			%>
		</div>
		
		<div class="paging">
			<%
			/*
			** 전체 페이지 수의 경우 전체 글 갯수 59개, 화면에 보여줄 글 갯수 10개일 때
			** 전체 페이지의 수는 6개가 되어야하기 때문에 삼항연산자에 조건 넣어서 값 1 추가해줌
			*/
			int pageBlock = 10; // 페이지 갯수
			int pageCount = count / pageSize + (count%pageSize == 0 ? 0 : 1); // 전체 페이지 수
			int startPage = (pageN-1) / pageBlock * pageBlock + 1; // (현재페이지 -1) / 페이지갯수 * 페이지갯수 + 1
			int endPage = startPage + pageBlock - 1; // 시작페이지 + 페이지 갯수 - 1
			
			if(endPage > pageCount) {
				endPage = pageCount;
			}
			
			// 페이징 출력
			if(startPage > pageBlock) {
				%>
				<a href="list.jsp?table=<%=table %>&pageN=<%=startPage-pageBlock %>"><span class="material-icons">chevron_left</span></a>
				<%
			}
			if(pageCount >= 2) {
				for(int i=startPage; i<=endPage; i++) {
				%>
					<% if(i == pageN) { %><span><% } %>
					<a href="list.jsp?table=<%=table %>&pageN=<%=i %>"><%=i %></a>
					<% if(i == pageN) { %></span><% } %>
				<%
				}
			}
			if(endPage < pageCount) {
				%>
				<a href="list.jsp?table=<%=table %>&pageN=<%=startPage+pageBlock %>"><span class="material-icons">chevron_right</span></a>
				<%
			}
			%>
		</div>
	</div>
</div>

<% if(request.getParameter("id") == null) { // 뷰 페이지일 때 %>
<jsp:include page="../main/tail.jsp" />
<% } %>