<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="board.BoardDAO"%>
<%@page import="board.BoardBean"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
BoardBean mb = new BoardBean();
BoardDAO mdao = BoardDAO.getInstance();

ArrayList<BoardBean> list1 = mdao.getLatest("notice", 7);
ArrayList<BoardBean> list2 = mdao.getLatest("free", 7);
ArrayList<BoardBean> list3 = mdao.getLatest("infocom", 7);
ArrayList<BoardBean> list4 = mdao.getLatest("foodservice", 7);
ArrayList<BoardBean> list5 = mdao.getLatest("machine", 7);
ArrayList<BoardBean> list6 = mdao.getLatest("build", 7);
ArrayList<BoardBean> list7 = mdao.getLatest("law", 7);
ArrayList<BoardBean> list8 = mdao.getLatest("driving", 7);

int list1Size = list1.size();
int list2Size = list2.size();
int list3Size = list3.size();
int list4Size = list4.size();
int list5Size = list5.size();
int list6Size = list6.size();
int list7Size = list7.size();
int list8Size = list8.size();
%>
<jsp:include page="head.jsp" />

<div id="index">
	<div class="latest">
		<div class="subject_board"><a href="../board/list.jsp?table=notice">공지사항</a></div>
		<ul>
			<% for(int i=0; i<list1Size; i++) { %>
			<li><a href="../board/view.jsp?table=<%=list1.get(i).getTable() %>&id=<%=list1.get(i).getId() %>"><%=list1.get(i).getSubject() %><% if(list1.get(i).getNewWrite() == 1) out.print("<span class='ico_new'></span>"); %><span class="txt_date"><%=list1.get(i).getSimpleDatetime() %></span></a></li>
			<% } %>
			<% if(list1Size == 0) { %>
			<li class="empty">조용한 박스 ₍₍ ◝(・ω・)◟ ⁾⁾</li>
			<% } %>
		</ul>
	</div>
	<div class="talk_area">
		<div class="talk">
			<div class="rolling">
				<ul id="talk_list">
					<li><a href="javascript:alert('링크1');">국지갤의 다양한 영역에 광고해보세요!</a></li><!-- 기간, 영역, 비용 소개 -->
					<li><a href="javascript:alert('링크2');">배너 클릭 횟수가 궁금하신가요?</a></li><!-- 클릭 횟수 정보 제공 -->
					<li><a href="javascript:alert('링크3');">귀원이 특별히 찾는 수강생이 있다면 이 곳을 눌러주세요.</a></li><!-- 게시판별 공지사항 AD 안내 -->
				</ul>
			</div>
			<span></span>
		</div>
		<div class="banner_1 banner_common"><a href="javascript:alert('1번 배너');"><img src="../img/banner_1.png"></a></div>
		<div class="banner_2 banner_common"><a href="javascript:alert('2번 배너');"><img src="../img/banner_2.png"></a></div>
	</div>
	<div class="latest margin_left none_margin_right">
		<div class="subject_board"><a href="../board/list.jsp?table=free">자유게시판</a></div>
		<ul>
			<% for(int i=0; i<list2Size; i++) { %>
			<li><a href="../board/view.jsp?table=<%=list2.get(i).getTable() %>&id=<%=list2.get(i).getId() %>"><%=list2.get(i).getSubject() %><% if(list2.get(i).getNewWrite() == 1) out.print("<span class='ico_new'></span>"); %><span class="txt_date"><%=list2.get(i).getSimpleDatetime() %></span></a></li>
			<% } %>
			<% if(list2Size == 0) { %>
			<li class="empty">조용한 박스 ₍₍ ◝(・ω・)◟ ⁾⁾</li>
			<% } %>
		</ul>
	</div>
	<div class="banner_3 banner_common"><a href="javascript:alert('3번 배너');"><img src="../img/banner_3.gif" title="사이트 이용 규정 바로가기"></a></div>
	<div class="banner_4 banner_common"><a href="javascript:alert('4번 배너');"><img src="../img/banner_4.png" title="직업훈련학원 검색"></a></div>
	<div class="latest margin_top">
		<div class="subject_board"><a href="../board/list.jsp?table=infocom">정보통신</a></div>
		<ul>
			<% for(int i=0; i<list3Size; i++) { %>
			<li><a href="../board/view.jsp?table=<%=list3.get(i).getTable() %>&id=<%=list3.get(i).getId() %>"><%=list3.get(i).getSubject() %><% if(list3.get(i).getNewWrite() == 1) out.print("<span class='ico_new'></span>"); %><span class="txt_date"><%=list3.get(i).getSimpleDatetime() %></span></a></li>
			<% } %>
			<% if(list3Size == 0) { %>
			<li class="empty">조용한 박스 ₍₍ ◝(・ω・)◟ ⁾⁾</li>
			<% } %>
		</ul>
	</div>
	<div class="latest margin_top center">
		<div class="subject_board"><a href="../board/list.jsp?table=foodservice">음식서비스</a></div>
		<ul>
			<% for(int i=0; i<list4Size; i++) { %>
			<li><a href="../board/view.jsp?table=<%=list4.get(i).getTable() %>&id=<%=list4.get(i).getId() %>"><%=list4.get(i).getSubject() %><% if(list4.get(i).getNewWrite() == 1) out.print("<span class='ico_new'></span>"); %><span class="txt_date"><%=list4.get(i).getSimpleDatetime() %></span></a></li>
			<% } %>
			<% if(list4Size == 0) { %>
			<li class="empty">조용한 박스 ₍₍ ◝(・ω・)◟ ⁾⁾</li>
			<% } %>
		</ul>
	</div>
	<div class="latest margin_top none_margin_right">
		<div class="subject_board"><a href="../board/list.jsp?table=machine">기계</a></div>
		<ul>
			<% for(int i=0; i<list5Size; i++) { %>
			<li><a href="../board/view.jsp?table=<%=list5.get(i).getTable() %>&id=<%=list5.get(i).getId() %>"><%=list5.get(i).getSubject() %><% if(list5.get(i).getNewWrite() == 1) out.print("<span class='ico_new'></span>"); %><span class="txt_date"><%=list5.get(i).getSimpleDatetime() %></span></a></li>
			<% } %>
			<% if(list5Size == 0) { %>
			<li class="empty">조용한 박스 ₍₍ ◝(・ω・)◟ ⁾⁾</li>
			<% } %>
		</ul>
	</div>
	<div class="latest margin_top">
		<div class="subject_board"><a href="../board/list.jsp?table=build">건설</a></div>
		<ul>
			<% for(int i=0; i<list6Size; i++) { %>
			<li><a href="../board/view.jsp?table=<%=list6.get(i).getTable() %>&id=<%=list6.get(i).getId() %>"><%=list6.get(i).getSubject() %><% if(list6.get(i).getNewWrite() == 1) out.print("<span class='ico_new'></span>"); %><span class="txt_date"><%=list6.get(i).getSimpleDatetime() %></span></a></li>
			<% } %>
			<% if(list6Size == 0) { %>
			<li class="empty">조용한 박스 ₍₍ ◝(・ω・)◟ ⁾⁾</li>
			<% } %>
		</ul>
	</div>
	<div class="latest margin_top center">
		<div class="subject_board"><a href="../board/list.jsp?table=law">법률·경찰·소방·교도</a></div>
		<ul>
			<% for(int i=0; i<list7Size; i++) { %>
			<li><a href="../board/view.jsp?table=<%=list7.get(i).getTable() %>&id=<%=list7.get(i).getId() %>"><%=list7.get(i).getSubject() %><% if(list7.get(i).getNewWrite() == 1) out.print("<span class='ico_new'></span>"); %><span class="txt_date"><%=list7.get(i).getSimpleDatetime() %></span></a></li>
			<% } %>
			<% if(list7Size == 0) { %>
			<li class="empty">조용한 박스 ₍₍ ◝(・ω・)◟ ⁾⁾</li>
			<% } %>
		</ul>
	</div>
	<div class="latest margin_top none_margin_right">
		<div class="subject_board"><a href="../board/list.jsp?table=driving">운전·운송</a></div>
		<ul>
			<% for(int i=0; i<list8Size; i++) { %>
			<li><a href="../board/view.jsp?table=<%=list8.get(i).getTable() %>&id=<%=list8.get(i).getId() %>"><%=list8.get(i).getSubject() %><% if(list8.get(i).getNewWrite() == 1) out.print("<span class='ico_new'></span>"); %><span class="txt_date"><%=list8.get(i).getSimpleDatetime() %></span></a></li>
			<% } %>
			<% if(list8Size == 0) { %>
			<li class="empty">조용한 박스 ₍₍ ◝(・ω・)◟ ⁾⁾</li>
			<% } %>
		</ul>
	</div>
	<div id="guide">
		<p class="word">잠깐 읽어보세요.</p>
		<ul>
			<li>좌측 게시판은 활동량에 따라 순서가 변경 또는 폐쇄될 수 있음을 인지하시기 바랍니다.</li>
			<li>사이트 정책에 어긋나는 행위 시 경고 없이 <span>"활동제한 조치"</span>가 이뤄질 수 있습니다.</li>
			<li><span>프라이버시 보호</span>가 필요한 중요한 문의는 하단 이메일 문의를 통하여 연락해주시기 바랍니다.</li>
			<li>이용에 불편한 점은 꼭 <span>피드백</span> 부탁드립니다.</li>
		</ul>
	</div>
</div>

<script type="text/javascript">
/* 톡 롤링 */
var talk_num = 0;

function talkroll() {
	talk_num++;
	
	jQuery('#talk_list').animate({top: '-'+talk_num*14+'px'}, 300);
	if(talk_num == (jQuery("#talk_list li").length-1)) {
		if(talk_num > 1) talk_num = -1;
	} 
}

var talk_movement = setInterval("talkroll()", 4000);
</script>

<jsp:include page="tail.jsp" />