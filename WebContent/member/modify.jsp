<%@page import="member.MemberBean"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="../main/head.jsp" />
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<%
String memberID = null; 

if(session.getAttribute("memberID") != null && session.getAttribute("memberModify") != null) {
	memberID = (String)session.getAttribute("memberID");
} else {
	out.print("<script type='text/javascript'>");
	out.print("alert('비정상적인 접근입니다.');");
	out.print("location.href = '../index.jsp'");
	out.print("</script>");
	return;
}

MemberDAO mdao = MemberDAO.getInstance();
MemberBean getMember = mdao.getMember(memberID);
%>

<div id="modify">
	<div class="wrap">
		<div class="logo">회원정보수정</div>
		
		<form action="modifyPro.jsp" method="post" name="fm" onsubmit="return fmodifyform_submit();">
			<p><input type="text" name="memberID" maxlength="15" value="<%=memberID %>" readonly="readonly" style="ime-mode:disabled;cursor:default;background:#DDD" onkeyup="this.value=this.value.replace(/[^a-zA-Z-_0-9]/g,'');" required></p>
			<p><input type="password" name="password" maxlength="50" placeholder="★ 비밀번호" required></p>
			<p><input type="password" name="rePassword" maxlength="50" placeholder="★ 비밀번호확인" required></p>
			<p><input type="text" name="nick" maxlength="10" value="<%=getMember.getNick() %>" placeholder="닉네임"></p>
			<p><input type="text" name="email" maxlength="100" value="<%=getMember.getEmail() %>" style="cursor:default;background:#DDD" readonly="readonly" required></p>
			<p><input type="text" style="cursor:pointer;" id="zip" class="inp_zip" name="zip" maxlength="7" placeholder="우편번호" onclick="zipSearch()" value="<%=getMember.getZip() %>" readonly="readonly"><input type="button" class="btn_zip" name="zip" value="검색" onclick="zipSearch()"></p>
			<p><input type="text" style="cursor:pointer;" id="addr1" name="addr1" maxlength="100" placeholder="주소" onclick="zipSearch()" value="<%=getMember.getAddr1() %>" readonly="readonly"></p>
			<p><input type="text" id="addr2" name="addr2" maxlength="100" value="<%=getMember.getAddr2() %>" placeholder="상세주소"></p>

			<p><input type="submit" class="btn_submit" value="정보수정"></p>
		</form>
		
		<script type="text/javascript">
			function fmodifyform_submit() {
				if(!fm.password.value) {
					alert("비밀번호를 입력해주세요.");
					fm.password.focus();
					return false;
				} else if(fm.password.value.length < 6) {
					alert("비밀번호는 최소 6자 이상 입력해주세요.");
					fm.password.focus();
					return false;
				} else if(fm.rePassword.value !== fm.password.value) {
					alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
					fm.rePassword.focus();
					return false;
				} else if(fm.nick.value.length > 10) {
					alert("닉네임은 10자 까지 가능합니다.");
					fm.nick.focus();
					return false;
				}
				
				return true;
			}
			
			function zipSearch() {
				new daum.Postcode({
			        oncomplete: function(data) {
		                var addr = ''; // 주소
		                var extraAddr = ''; // 참고항목

		                if (data.userSelectedType === 'R') { // 도로명 주소를 선택했을 경우
		                    addr = data.roadAddress;
		                } else { // 지번 주소를 선택했을 경우(J)
		                    addr = data.jibunAddress;
		                }

		                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합
		                if(data.userSelectedType === 'R'){
		                    // 법정동명이 있을 경우 추가 (법정리 제외)
		                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝남
		                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
		                        extraAddr += data.bname;
		                    }
		                    // 건물명이 있고, 공동주택일 경우 추가
		                    if(data.buildingName !== '' && data.apartment === 'Y'){
		                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
		                    }
		                    if(extraAddr !== ''){
		                        extraAddr = ' (' + extraAddr + ')';
		                    }

		                    extraAddr = extraAddr;
		                } else {
		                	extraAddr = '';
		                }

		                document.getElementById('zip').value = data.zonecode;
		                document.getElementById("addr1").value = addr + extraAddr;
		                document.getElementById("addr2").focus();
	 		        }
	 		    }).open();
			}
		</script>
	</div>
</div>

<jsp:include page="../main/tail.jsp" />