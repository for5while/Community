<%@page import="member.MemberBean"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String memberID = (String)session.getAttribute("memberID");

MemberBean mb = new MemberBean();
MemberDAO mdao = MemberDAO.getInstance();

boolean emailCheck = false;
if(mb.getId() == null) {
	mb.setId(memberID);
	emailCheck = mdao.getMemberEmailChecked(memberID);
}

String table = "";
if(request.getParameter("table") != null) table = request.getParameter("table");

MemberBean getMember = mdao.getMember(memberID);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>국비지원갤러리</title>
		<link rel="icon" type="image/png" sizes="16x16" href="../img/favicon.png">
		<link href="../css/default.css" rel="stylesheet" type="text/css">
		<link href="../css/font/NotoSansKR.css" rel="stylesheet" type="text/css">
		<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
		<script src="../js/jquery-3.4.1.min.js"></script>
		<script type="text/javascript">
		// gnb fixed horizontal scroll issue
		$(window).scroll(function() {
		    $('.tnb').css({left: 0 - $(this).scrollLeft()});
		});
		</script>
	</head>
	
	<body>
		<div id="wrap">
			<div id="header">
				<div class="top_background">
					<div class="tnb">
						<span class="logo"><a href="../index.jsp"><img src="../img/logo.png" alt="국비지원갤러리" /></a></span>
						<span class="search_all">
							<form action="javascript:alert('검색된 내용이 없습니다.');" method="post">
								<input type="text" class="keyword" name="keyword_all" placeholder="검색할 글 제목과 내용의 키워드를 입력하세요.">
								<button><span class="material-icons">search</span></button>
							</form>
						</span>
						<span class="info_member">
							<% if(memberID == null || !emailCheck) { %>
							<span title="1분마다 갱신"><%=mdao.getMemberCount(memberID) %>명의 회원이 국지갤과 함께하고 있습니다.</span>
							<% } else { %>
							<span><%=getMember.getNick() %>(<%=memberID %>)님 반갑습니다.</span>
							<% } %>
						</span>
						<span class="btn_member">
							<% if(memberID == null || !emailCheck) { %>
							<a class="btns" href="../member/login.jsp"><span class="material-icons tnb_icons">person_pin</span><span class="txt">로그인</span></a>
							<a class="btns" href="../member/register.jsp"><span class="material-icons tnb_icons">person_add</span><span class="txt">짧은회원가입</span></a>
							<% } else { %>
							<a class="btns btn_mb_modify" href="../member/modifyBefore.jsp"><i class="material-icons tnb_icons">people_alt</i><span class="txt">마이페이지</span></a>
							<a class="btns btn_logout" href="../member/logout.jsp"><i class="material-icons tnb_icons">power_settings_new</i><span class="txt">로그아웃</span></a>
							<% } %>
						</span>
					</div>
				</div>
			</div>
			<div id="container">
				<div id="aside">
					<div class="lnb">
						<div class="group">커뮤니티</div>
						<ul>
							<li><a class="link_board link_text<% if(table.equals("notice")) out.print(" on"); %>" data-board-text="공지사항" href="../board/list.jsp?table=notice"><span>&#x1F4E2;</span><span class="link_label">공지사항</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("free")) out.print(" on"); %>" data-board-text="자유게시판" href="../board/list.jsp?table=free"><span>&#x1F4A9;</span><span class="link_label">자유게시판</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("project")) out.print(" on"); %>" data-board-text="프로젝트자랑" href="../gallery/list.jsp?table=project"><span>&#x1F3A8;</span><span class="link_label">프로젝트자랑</span></a></li>
						</ul>
						<div class="group second">직업훈련 및 종사</div>
						<ul>
							<li><a class="link_board link_text<% if(table.equals("infocom")) out.print(" on"); %>" data-board-text="정보통신" href="../board/list.jsp?table=infocom"><span>&#x1F4BB;</span><span class="link_label">정보통신</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("foodservice")) out.print(" on"); %>" data-board-text="음식서비스" href="../board/list.jsp?table=foodservice"><span>&#x1F35C;</span><span class="link_label">음식서비스</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("foodpro")) out.print(" on"); %>" data-board-text="식품가공" href="../board/list.jsp?table=foodpro"><span>&#x1F371;</span><span class="link_label">식품가공</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("electrical")) out.print(" on"); %>" data-board-text="전기·전자" href="../board/list.jsp?table=electrical"><span>&#x1F4DF;</span><span class="link_label">전기·전자</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("machine")) out.print(" on"); %>" data-board-text="기계" href="../board/list.jsp?table=machine"><span>&#x1F50C;</span><span class="link_label">기계</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("build")) out.print(" on"); %>" data-board-text="건설" href="../board/list.jsp?table=build"><span>&#x1F528;</span><span class="link_label">건설</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("projectmgr")) out.print(" on"); %>" data-board-text="사업관리" href="../board/list.jsp?table=projectmgr"><span>&#x1F3EC;</span><span class="link_label">사업관리</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("business")) out.print(" on"); %>" data-board-text="경영·회계·사무" href="../board/list.jsp?table=business"><span>&#x1F4CB;</span><span class="link_label">경영·회계·사무</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("law")) out.print(" on"); %>" data-board-text="법률·경찰·소방·교도" href="../board/list.jsp?table=law"><span>&#x1F694;</span><span class="link_label">법률·경찰·소방·교도</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("finance")) out.print(" on"); %>" data-board-text="금융·보험" href="../board/list.jsp?table=finance"><span>&#x1F4B0;</span><span class="link_label">금융·보험</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("driving")) out.print(" on"); %>" data-board-text="운전·운송" href="../board/list.jsp?table=driving"><span>&#x1F69B;</span><span class="link_label">운전·운송</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("nature")) out.print(" on"); %>" data-board-text="교육·자연·사회과학" href="../board/list.jsp?table=nature"><span>&#x1F332;</span><span class="link_label">교육·자연·사회과학</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("security")) out.print(" on"); %>" data-board-text="경비·청소" href="../board/list.jsp?table=security"><span>&#x1F4A8;</span><span class="link_label">경비·청소</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("medical")) out.print(" on"); %>" data-board-text="보건·의료" href="../board/list.jsp?table=medical"><span>&#x1F489;</span><span class="link_label">보건·의료</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("religion")) out.print(" on"); %>" data-board-text="사회복지종교" href="../board/list.jsp?table=religion"><span>&#x1F5FF;</span><span class="link_label">사회복지종교</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("art")) out.print(" on"); %>" data-board-text="문화·예술·디자인·방송" href="../board/list.jsp?table=art"><span>&#x1F46C;</span><span class="link_label">문화·예술·디자인·방송</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("sales")) out.print(" on"); %>" data-board-text="영업판매" href="../board/list.jsp?table=sales"><span>&#x1F60E;</span><span class="link_label">영업판매</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("chemistry")) out.print(" on"); %>" data-board-text="화학" href="../board/list.jsp?table=chemistry"><span>&#x1F3ED;</span><span class="link_label">화학</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("travel")) out.print(" on"); %>" data-board-text="숙박·여행·오락·스포츠" href="../board/list.jsp?table=travel"><span>&#x1F3C4;</span><span class="link_label">숙박·여행·오락·스포츠</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("material")) out.print(" on"); %>" data-board-text="재료" href="../board/list.jsp?table=material"><span>&#x1F4A0;</span><span class="link_label">재료</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("fiber")) out.print(" on"); %>" data-board-text="섬유·의복" href="../board/list.jsp?table=fiber"><span>&#x1F454;</span><span class="link_label">섬유·의복</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("crafts")) out.print(" on"); %>" data-board-text="인쇄·목재·가구·공예" href="../board/list.jsp?table=crafts"><span>&#x1F4CF;</span><span class="link_label">인쇄·목재·가구·공예</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("energy")) out.print(" on"); %>" data-board-text="환경·에너지·안전" href="../board/list.jsp?table=energy"><span style="position:relative;left:3px">&#x1F6A6;</span><span class="link_label">환경·에너지·안전</span></a></li>
							<li><a class="link_board link_text<% if(table.equals("forestry")) out.print(" on"); %>" data-board-text="농림어업" href="../board/list.jsp?table=forestry"><span>&#x1F404;</span><span class="link_label">농림어업</span></a></li>
						</ul>
					</div>
				</div>
				<div id="content">