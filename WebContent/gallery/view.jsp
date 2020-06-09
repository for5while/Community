<%@page import="java.sql.Timestamp"%>
<%@page import="member.MemberDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="gallery.GalleryDAO"%>
<%@page import="gallery.GalleryBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="../main/head.jsp" />

<link href="../css/board.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="../css/summernote/summernote-lite.min.css">
<script src="../js/summernote/summernote-lite.min.js"></script>
<script src="../js/summernote/lang/summernote-ko-KR.min.js"></script>

<%
int id = 0;
String memberID = null;
String table = null;
boolean emailCheck = false;

// 게시글 번호
if(request.getParameter("id") != null) {
	id = Integer.parseInt(request.getParameter("id"));
} else {
	out.print("<script type='text/javascript'>");
	out.print("alert('유효하지 않은 글입니다.');");
	out.print("location.href = 'list.jsp?table=" + table + "';");
	out.print("</script>");
	return;
}

if(session.getAttribute("memberID") != null) {
	memberID = (String)session.getAttribute("memberID");
	
	MemberDAO mdao = MemberDAO.getInstance();
	emailCheck = mdao.getMemberEmailChecked(memberID);
}

if(request.getParameter("table") != null) {
	table = request.getParameter("table");
} else {
	out.print("<script type='text/javascript'>");
	out.print("alert('비정상적인 접근입니다.');");
	out.print("location.href = '../index.jsp';");
	out.print("</script>");
	return;
}

GalleryDAO bdao = GalleryDAO.getInstance();
GalleryBean bb = new GalleryBean();

bb = bdao.writeRead(id, table);

// 현재 게시글의 댓글 갯수
int commentAllCount = bdao.getCommentCount(id, table);
%>

<div id="board">
	<div class="view">
		<div class="subject"><%=bb.getSubject()%></div>
		<div class="info">
			<span class="left">
				<span class="material-icons">record_voice_over</span><span class="txt left"><%=bb.getNick()%></span>
			</span>
			<span class="right">
				<%
					Timestamp now = new Timestamp(System.currentTimeMillis());
						SimpleDateFormat date1 = new SimpleDateFormat("MM-dd");
						SimpleDateFormat date2 = new SimpleDateFormat("HH:mm");
						String date3 = null;
						
						if(date1.format(bb.getDatetime()).equals(date1.format(now))) {
							date3 = date2.format(bb.getDatetime());
						} else {
							date3 = date1.format(bb.getDatetime());
						}
				%>
				<span class="material-icons info_right">comment</span><span class="txt"><%=commentAllCount%></span>
				<span class="material-icons info_right">visibility</span><span class="txt"><%=bb.getHit()%></span>
				<span class="material-icons info_right">thumb_up_alt</span><span class="txt"><%=bb.getGood()%></span>
				<span class="material-icons info_right">event</span><span class="txt"><%=date3%></span>
			</span>
		</div>
		
		<div class="content">
			<%=bb.getContent()%>
			<div class="recommend">
				<span class="good">
					<a href="recommend.jsp?table=<%=table%>&id=<%=id%>&flag=1&type=1">
						<span class="material-icons">thumb_up_alt</span>
					</a>
				</span>
				<span><%=bb.getGood()%></span>
				<span class="nogood">
					<a href="recommend.jsp?table=<%=table%>&id=<%=id%>&flag=2&type=1">
						<span class="material-icons">thumb_down_alt</span>
					</a>
				</span>
			</div>
		</div>
		
		<div class="foot">
			<div class="btn">
				<%
					// 글 작성자 본인이라면
						if(memberID != null && memberID.equals(bb.getMemberId())) {
				%>
				<div class="left">
					<a href="write.jsp?table=<%=table%>&id=<%=id%>&modify=1"><input type="button" class="btn_mng" value="수정"></a>
					<a href="deletePro.jsp?table=<%=table%>&id=<%=id%>" onclick="if(!confirm('정말로 삭제하시겠습니까?')) return false;"><input type="button" class="btn_mng" value="삭제"></a>
				</div>
				<%
					}
				%>
				<div class="right">
					<a href="list.jsp?table=<%=table%>"><input type="button" class="btn_all" value="목록"></a>
				</div>
			</div>
			
			<div class="co_count">
				<span class="material-icons co">comment</span>
				<span class="txt">댓글 <%=commentAllCount%></span>
			</div>
			<div class="comment">
				<%
					// 페이징
						int pageSize = 15; // 현재 페이지에 보여 줄 댓글 갯수
						int pageCN = 1; // 현재 페이지
					
						if(request.getParameter("pageCN") != null) {
							pageCN = Integer.parseInt(request.getParameter("pageCN"));
						}
						
						// 페이지 시작, 끝 번호
						int startRow = ((pageCN-1) * pageSize)+1; // ((현재페이지-1) * 페이지 최대 글 갯수)+1)
						int endRow = pageCN * pageSize; // 현재페이지 * 페이지 최대 글 갯수
					
						ArrayList<GalleryBean> commentList = bdao.getCommentList(startRow, pageSize, id, table);
						GalleryBean bestRecommend = bdao.bestRecommend(table, id); // 베스트 댓글
				%>

				<div class="co_list">
					<%
					// 댓글 리스트
					for(int i=0; i<commentList.size(); i++) {
						
						if(date1.format(commentList.get(i).getDatetime()).equals(date1.format(now))) {
							date3 = date2.format(commentList.get(i).getDatetime());
						} else {
							date3 = date1.format(commentList.get(i).getDatetime());
						}
						
						if(commentList.get(i).getCommentSequen() == 0) {
							if(i == 0 && bestRecommend.getGood() >= 3) { // 베스트 댓글은 최상단에 하나만 띄움 (추천수 3 이상)
								%>
								<div class="co_content best">
									<span class="top_best">
										<span class="txt_best">베스트댓글</span>
										<span class="ico_best"></span>
									</span>
									<span class="co_recommend">
										<span class="co_up">
											<a href="recommend.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=bestRecommend.getCommentID() %>&flag=1&type=2">
												<span class="material-icons">keyboard_arrow_up</span>
											</a>
										</span>
										<span class="co_mid">
											<% if(bestRecommend.getGood() > 0) { %>
												<span class='good'><%=bestRecommend.getGood() %></span>
											<% } else { %>
												<span class='nogood'><%=bestRecommend.getGood() %></span>
											<% } %>
										</span>
										<span class="co_down">
											<a href="recommend.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=bestRecommend.getCommentID() %>&flag=2&type=2">
												<span class="material-icons bottom">keyboard_arrow_down</span>
											</a>
										</span>
									</span>
									<div class="text_top">
										<span class="text_id"><%=bestRecommend.getNick() %></span>
									</div>
								
									<!-- 댓글 박스 -->
									<div class="text_content">
										<div class="box_read" id="gr_<%=bestRecommend.getCommentID() %>" style="display:block;"><%=bestRecommend.getContent() %></div>
									</div>
								</div>
								
								<%
							}
						%>
						<div class="co_content">
							<span class="co_recommend">
								<span class="co_up">
									<a href="recommend.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=commentList.get(i).getCommentID() %>&flag=1&type=2">
										<span class="material-icons">keyboard_arrow_up</span>
									</a>
								</span>
								<span class="co_mid">
									<% if(commentList.get(i).getGood() == 0) { %>
										<span class='none'>-</span>
									<% } else if(commentList.get(i).getGood() > 0) { %>
										<span class='good'><%=commentList.get(i).getGood() %></span>
									<% } else { %>
										<span class='nogood'><%=commentList.get(i).getGood() %></span>
									<% } %>
								</span>
								<span class="co_down">
									<a href="recommend.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=commentList.get(i).getCommentID() %>&flag=2&type=2">
										<span class="material-icons bottom">keyboard_arrow_down</span>
									</a>
								</span>
							</span>
							<div class="text_top">
								<span class="text_id">
									<%=commentList.get(i).getNick() %>
									<% if(commentList.get(i).getMemberId().equals(memberID)) { %><span class="co_author" title="글쓴이">글쓴이</span><% } %>
								</span>
								<span class="text_date"><%=date3 %></span><span class="material-icons right">event</span>
								<% if(memberID != null && emailCheck) { %>
								<span class="btn_co_top">
									<span class="btn_co_reply"><span param="<%=commentList.get(i).getCommentID() %>">답글</span></span>
									<% if(commentList.get(i).getMemberId().equals(memberID)) { %>
									<span class="btn_co_modify"><span param="<%=commentList.get(i).getCommentID() %>">수정</span></span>
									<span class="btn_co_delete"><a href="deletePro.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=commentList.get(i).getCommentID() %>" onclick="if(!confirm('정말로 삭제하시겠습니까?')) return false;">삭제</a></span>
									<% } %>
								</span>
								<% } %>
							</div>
						
							<!-- 댓글 박스 -->
							<div class="text_content">
								<!-- 원 댓글 내용 -->
								<div class="box_read" id="gr_<%=commentList.get(i).getCommentID() %>" style="display:block;"><%=commentList.get(i).getContent() %></div>
								
								<!-- 대댓글 달기 -->
								<div id="re_gi_<%=commentList.get(i).getCommentID() %>" style="display:none;">
									<form id="re_cf_<%=commentList.get(i).getCommentID() %>" param="<%=commentList.get(i).getCommentID() %>" action="writeCoPro.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=commentList.get(i).getCommentID() %>&group=<%=commentList.get(i).getCommentGroup() %>" name="rcm" method="post">
										<textarea id="re_gt_<%=commentList.get(i).getCommentID() %>" name="co_content"></textarea>
										<input type="button" class="btn_co_cancle" value="취소">
										<input type="submit" class="btn_co_reply_submit" value="대댓글 등록">
									</form>
								</div>
								
								<!-- 댓글 수정 -->
								<div id="gi_<%=commentList.get(i).getCommentID() %>" style="display:none;">
									<form id="cf_<%=commentList.get(i).getCommentID() %>" param="<%=commentList.get(i).getCommentID() %>" action="modifyCoPro.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=commentList.get(i).getCommentID() %>&modify=1" name="cm" method="post">
										<textarea id="gt_<%=commentList.get(i).getCommentID() %>" name="co_content"></textarea>
										<input type="button" class="btn_co_cancle" value="취소">
										<input type="submit" class="btn_co_modify_submit" value="수정완료">
									</form>
								</div>
							</div>
						</div>
						<%
						} else { // 대댓글일 때 (그룹 내부의 순서가 있을 때)
						%>
							<div class="co_content re">
								<span class="text_indent"><span class="material-icons">subdirectory_arrow_right</span></span>
								<div class="text_top">
									<span class="text_id">
										<%=commentList.get(i).getNick() %>
										<% if(commentList.get(i).getMemberId().equals(memberID)) { %><span class="co_author" title="글쓴이">글쓴이</span><% } %>
									</span>
									<span class="text_date"><%=date3 %></span><span class="material-icons right">event</span>
									<% if(memberID != null && emailCheck && commentList.get(i).getMemberId().equals(memberID)) { %>
									<span class="btn_co_top">
										<span class="btn_co_modify"><span param="<%=commentList.get(i).getCommentID() %>">수정</span></span>
										<span class="btn_co_delete"><a href="deletePro.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=commentList.get(i).getCommentID() %>" onclick="if(!confirm('정말로 삭제하시겠습니까?')) return false;">삭제</a></span>
									</span>
									<% } %>
								</div>
								
								<!-- 대댓글 박스 -->
								<div class="text_content re">
									<!-- 대댓글 내용 -->
									<div class="box_read" id="gr_<%=commentList.get(i).getCommentID() %>" style="display:block;"><%=commentList.get(i).getContent() %></div>
									
									<!-- 대댓글 수정 -->
									<div id="gi_<%=commentList.get(i).getCommentID() %>" style="display:none;">
										<form id="cf_<%=commentList.get(i).getCommentID() %>" param="<%=commentList.get(i).getCommentID() %>" action="modifyCoPro.jsp?table=<%=table %>&id=<%=id %>&co_id=<%=commentList.get(i).getCommentID() %>&modify=1" name="cm" method="post">
											<textarea id="gt_<%=commentList.get(i).getCommentID() %>" name="co_content" placeholder="수정할 댓글 내용을 입력하세요."></textarea>
											<input type="button" class="btn_co_cancle btn_re" value="취소">
											<input type="submit" class="btn_co_modify_submit" value="수정완료">
										</form>
									</div>
								</div>
							</div>
							<%
						} // if getCommentSequen() end
					} // for : commentList.size() end
					commentList.clear();
					%>
					
					<script type="text/javascript">
						// 댓글
						$(document).ready(function() {
							// 답글 인풋 띄우기
							$(".btn_co_reply > span").click(function() {
	 							$("div[id*='gi_']").css("display", "none");
	 							$("div[id*='gr_']").css("display", "block");
								
								var group = $(this).attr("param");
								
								$("#re_gt_"+group).summernote({
									height: 150,
									lang: 'ko-KR',
									placeholder: '대댓글 내용을 입력하세요.',
						            toolbar: [
						                ['font', ['bold', 'italic', 'underline']],
						                ['color', ['color']],
						                ['insert', ['picture']],
						                ['view', ['fullscreen']],
						              ]
								});

								$("#re_gi_"+group).css("display", "block");
								$("#re_gr_"+group).css("display", "none");
								
								return false;
							});
							
							// 수정 인풋 띄우기
							$(".btn_co_modify > span").click(function() {
	 							$("div[id*='gi_']").css("display", "none");
	 							$("div[id*='gr_']").css("display", "block");
								
								var group = $(this).attr("param");
								var content = $("#gr_"+group).html();
								
								$("#gt_"+group).val(content);
								$("#gt_"+group).summernote({
									height: 150,
									lang: 'ko-KR',
									placeholder: '수정할 댓글 내용을 입력하세요.',
						            toolbar: [
						                ['font', ['bold', 'italic', 'underline']],
						                ['color', ['color']],
						                ['insert', ['picture']],
						                ['view', ['fullscreen']],
						              ]
								});

								$("#gi_"+group).css("display", "block");
								$("#gr_"+group).css("display", "none");
								$("#gt_"+group).focus();
								
								return false;
							});
							
							// 대댓글 or 답글 작성 취소
							$(".btn_co_cancle").click(function() {
	 							$("div[id*='gi_']").css("display", "none");
	 							$("div[id*='gr_']").css("display", "block");
	 							
								return false;
							});
							
							// 서브밋 처리
							$("form[id^='cf_']").submit(function() {
								var group = $(this).attr("param");

								if($("textarea[id^='gt_"+group+"']").val().length == 0) {
									alert("수정할 댓글 내용을 입력해주세요.");
									return false;
								} else {
									return true;
								}
							});
						});
					</script>
				</div>
				
				<div class="co_paging">
					<%
						/*
						** 전체 페이지 수의 경우 전체 글 갯수 59개, 화면에 보여줄 글 갯수 10개일 때
						** 전체 페이지의 수는 6개가 되어야하기 때문에 삼항연산자에 조건 넣어서 값 1 추가해줌
						*/
						int pageBlock = 10; // 페이지 갯수
						int pageCount = commentAllCount / pageSize + (commentAllCount%pageSize == 0 ? 0 : 1); // 전체 페이지 수
						int startPage = (pageCN-1) / pageBlock * pageBlock + 1; // (현재페이지 -1) / 페이지갯수 * 페이지갯수 + 1
						int endPage = startPage + pageBlock - 1; // 시작페이지 + 페이지 갯수 - 1
						
						if(endPage > pageCount) {
							endPage = pageCount;
						}
						
						// 페이징 출력
						if(startPage > pageBlock) {
							%>
							<a href="view.jsp?table=<%=table %>&id=<%=id %>&pageCN=<%=startPage-pageBlock %>"><span class="material-icons">chevron_left</span></a>
							<%
						}
						if(pageCount >= 2) {
							for(int i=startPage; i<=endPage; i++) {
							%>
								<% if(i == pageCN) { %><span><% } %>
								<a href="view.jsp?table=<%=table %>&id=<%=id %>&pageCN=<%=i %>"><%=i%></a>
								<% if(i == pageCN) { %></span><% } %>
							<%
							}
						}
						if(endPage < pageCount) {
							%>
							<a href="view.jsp?table=<%=table %>&id=<%=id %>&pageCN=<%=startPage+pageBlock %>"><span class="material-icons">chevron_right</span></a>
							<%
						}
					%>
				</div>
				
				<%
				// 로그인 상태일 때만 댓글 입력창 띄움
				if(memberID != null) {
					%>
					<form action="writeCoPro.jsp?table=<%=table %>&id=<%=id %>" name="cw" method="post" onsubmit="return writeCommentForm_submit();">
						<div class="input">
							<textarea id="comment_input" rows="6" name="co_content"></textarea>
							<div>
								<input type="submit" class="btn_co_submit" value="댓글등록 (Alt + a)">
							</div>
						</div>
					</form>
					
					<script type="text/javascript">
						$(document).ready(function() {
							$('#comment_input').summernote({
								height: 150,
								lang: 'ko-KR',
								placeholder: "한번 내뱉은 말은 주워담을 수 없습니다.<br>바른말 고운말!",
					            toolbar: [
					                ['font', ['bold', 'italic', 'underline']],
					                ['color', ['color']],
					                ['insert', ['picture']],
					                ['view', ['fullscreen']],
					              ]
							});
						});
					
						var isAlt = false;
						document.onkeyup = function(e) {
							if(e.which == 18) isAlt = false;
							return false;
						}
						document.onkeydown = function(e) {
							if(e.which == 18) isAlt = true;
							
							// 댓글 등록 (Alt + a)
							if(e.which == 65 && isAlt) {
								if(cw.comment_input.value) {
									document.cw.submit();
								}
							}
						}
						
						function writeCommentForm_submit() {
							if(!cw.comment_input.value) {
								alert("댓글 내용을 입력해주세요.");
								cw.comment_input.focus();
								return false;
							}
							
							return true;
						}
					</script>
					<%
				}
				%>
			</div>
		</div>
	</div>
</div>

<jsp:include page="../gallery/list.jsp" />
<jsp:include page="../main/tail.jsp" />