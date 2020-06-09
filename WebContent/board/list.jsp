<%@page import="member.MemberBean"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="member.MemberDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="board.BoardBean" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

if(request.getParameter("id") == null) { // 뷰 페이지일 때
%>
<jsp:include page="../main/head.jsp" />
<link href="../css/board.css" rel="stylesheet" type="text/css">
<% } %>

<%
int type = 0;
int id = 0;
String table = null;
String keyword = null;

// project 게시판은 갤러리 리스트 페이지 따로 나눔
if(request.getParameter("table") != null) {
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

MemberDAO mdao = MemberDAO.getInstance();
BoardDAO bdao = BoardDAO.getInstance();
BoardBean bb = new BoardBean();

int count = bdao.getWriteCount(table, type, keyword);

// 페이징
int pageSize = 20; // 현재 페이지에 보여 줄 글 갯수
int pageN = 1; // 현재 페이지

if(request.getParameter("pageN") != null) {
	pageN = Integer.parseInt(request.getParameter("pageN"));
}

// 페이지 시작, 끝 번호
int startRow = ((pageN-1) * pageSize)+1; // ((현재페이지-1) * 페이지 최대 글 갯수)+1)
int endRow = pageN * pageSize; // 현재페이지 * 페이지 최대 글 갯수

ArrayList<BoardBean> list = bdao.getList(startRow, pageSize, table, type, keyword);
%>

<div id="board">
	<div class="list">
		<div class="count"><span class="material-icons">library_books</span>게시글 <%=count %></div>
		<table>
			<caption>게시판 목록</caption>
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">추천</th>
					<th scope="col" class="writer">글쓴이</th>
					<th scope="col">제목</th>
					<th scope="col">조회</th>
					<th scope="col">날짜</th>
				</tr>
			</thead>
			<tbody>
				<%
				// num = 가상의 게시글 번호
				// int num = count - (pageN - 1) * pageSize;
				// 출력문에 num-- 사용
				int size = list.size();

				Timestamp now = new Timestamp(System.currentTimeMillis());
				SimpleDateFormat date1 = new SimpleDateFormat("MM-dd");
				SimpleDateFormat date2 = new SimpleDateFormat("HH:mm");
				String date3 = null;
				
				for(int i=0; i<size; i++) {

					if(date1.format(list.get(i).getDatetime()).equals(date1.format(now))) {
						date3 = date2.format(list.get(i).getDatetime());
					} else {
						date3 = date1.format(list.get(i).getDatetime());
					}
					
					int listID = list.get(i).getId();
					String listMemberID = list.get(i).getMemberId();
					String listSubject = list.get(i).getSubject();
					int listGood = list.get(i).getGood();
					int listHit = list.get(i).getHit();
					int listOption = list.get(i).getOption();
					int listNew = list.get(i).getNewWrite();
					int listFile = list.get(i).getFile();
					
					String viewPageName = null;
					if(listOption == 1) viewPageName = "viewConfirm";
					else viewPageName = "view";
					
					int commentCount = bdao.getCommentCount(listID, table);
					MemberBean getMember = mdao.getMember(listMemberID);
				%>
				
				<tr<% if(listID == id) { %> class="on"<% } %>>
					<td class="num"><%=listID %></td>
					<td class="recommend">
						<%
						if(listGood == 0) out.println("-");
						else if(listGood > 0) out.println("<span class='good'>" + listGood + "</span>");
						else out.println("<span class='nogood'>" + listGood + "</span>");
						%>
					</td>
					<td class="nick" title="<%=getMember.getNick() %>"><%=getMember.getNick() %></td>
					<td class="subject left">
						<a href="<%=viewPageName %>.jsp?table=<%=table %>&id=<%=listID %><% if(listOption == 1) { %>&option=1<% } %><% if(request.getParameter("pageN") != null) { %>&pageN=<%=pageN %><% } %>" title="<%=listSubject %>">
							<% if(listOption == 1) { %><span class="ico_secret"></span>
							<% } else { %><span class="ico_write"></span><% } %>
							<span class="hover_underline"><%=listSubject %></span>
							<span class="after_subject">
								<span class="co_count">+<%=commentCount %></span>
								<% if(listNew == 1) { %><span class="ico_new"></span><% } %>
								<% if(listFile == 1) { %><span class="ico_img"></span><% } %>
							</span>
						</a>
					</td>
					<td class="hit"><%=listHit %></td>
					<td class="date"><%=date3 %></td>
				</tr>
				<%
				}
				list.clear();
				
				if(count <= 0) {
				%>
				<tr>
					<td colspan="6" class="empty_table">적막이 흐르는 이곳에 누군가 글을 남겨줄 것만 같은 느낌이에요! ✺◟(∗❛ัᴗ❛ั∗)◞✺</td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
	
		<div class="foot">
			<div class="search">
				<form action="../board/list.jsp?table=<%=table %>&pageN=<%=pageN %>" method="post">
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