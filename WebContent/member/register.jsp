<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
if(session.getAttribute("id") != null) response.sendRedirect("../index.jsp"); 
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>국비지원갤러리 | 회원가입</title>
		<link rel="icon" type="image/png" sizes="16x16" href="../img/favicon.png">
		<link href="../css/font/NotoSansKR.css" rel="stylesheet" type="text/css">
		<link href="../css/pages.css" rel="stylesheet" type="text/css">
		<script src="../js/jquery-3.4.1.min.js"></script>
		<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	</head>
	
	<body>
		<div id="register">
			<div class="wrap">
				<div class="logo"><a href="../index.jsp"><img src="../img/logo.png" alt="국비지원갤러리" /></a></div>
				
				<form action="registerPro.jsp" method="post" name="ff" onsubmit="return fregisterform_submit(this);">
					<input type="hidden" name="id_dup" value="">
					<input type="hidden" name="nick_dup" value="">
					
					<p>
						<input type="text" class="inp_small" id="register_id" name="memberID" maxlength="15" placeholder="★ 아이디" style="ime-mode:disabled" onkeyup="this.value=this.value.replace(/[^a-zA-Z-_0-9]/g,'');" onkeydown="if(event.keyCode != 9) inputChk('id');" onkeypress="if(event.keyCode == 13) { idCheck(); return false; }" tabindex="1" required="required">
						<input type="button" class="btn_small2" onclick="idCheck()" value="중복검사">
						<span id="msg_id"></span>
					</p>
					<p>
						<input type="password" name="password" maxlength="50" placeholder="★ 비밀번호" tabindex="2" required>
					</p>
					<p>
						<input type="password" name="rePassword" maxlength="50" placeholder="★ 비밀번호확인" tabindex="3" required>
					</p>
					<p>
						<input type="text" class="inp_small" id="register_nick" name="nick" maxlength="10" placeholder="★ 닉네임" onkeydown="if(event.keyCode != 9) inputChk('nick');" onkeypress="if(event.keyCode == 13) { nickCheck(); return false; }" tabindex="4" required>
						<input type="button" class="btn_small2" onclick="nickCheck()" value="중복검사">
						<span id="msg_nick"></span>
					</p>
					<p>
						<input type="text" name="email" maxlength="100" placeholder="★ 이메일"  tabindex="5" required>
					</p>
					<p>
						<input type="text" style="cursor:pointer;" id="zip" class="inp_small" name="zip" maxlength="7" placeholder="우편번호" onclick="zipSearch()" tabindex="6" readonly="readonly">
						<input type="button" class="btn_small" name="zip" value="검색" onclick="zipSearch()">
					</p>
					<p>
						<input type="text" style="cursor:pointer;" id="addr1" name="addr1" maxlength="100" placeholder="주소" onclick="zipSearch()" tabindex="7" readonly="readonly">
					</p>
					<p>
						<input type="text" id="addr2" name="addr2" maxlength="100" placeholder="상세주소" tabindex="8">
					</p>
		
					<p><input type="submit" class="btn_submit" value="회원가입" tabindex="8"></p>
				</form>
			</div>
		</div>
		
		<script type="text/javascript">
			function idCheck() {
				var id = ff.memberID.value;
				
				if(!id) {
					document.getElementById("msg_id").innerHTML = "아이디를 입력해주세요.";
					document.getElementById("msg_id").style.color = '#d45555';
					document.getElementById("msg_id").style.display = 'block';
					ff.memberID.focus();
					return false;
				} else if(id.length > 20 || id.length < 4) {
					document.getElementById("msg_id").innerHTML = "아이디는 4~20자 까지 가능합니다.";
					document.getElementById("msg_id").style.color = '#d45555';
					document.getElementById("msg_id").style.display = 'block';
					ff.memberID.focus();
					return false;
				} else if((id > "9" || id < "0") && (id > "Z" || id < "A") && (id > "z" || id < "a")) {
					document.getElementById("msg_id").innerHTML = "아이디는 영어와 숫자로만 조합할 수 있습니다.";
					document.getElementById("msg_id").style.color = '#d45555';
					document.getElementById("msg_id").style.display = 'block';
					ff.memberID.focus();
					return false;
				} else {
					var register_id = $('#register_id').val();
					
					$.ajax({
						url: '../member/duplicationCheckPro.jsp?register_id=' + register_id,
						type: 'get',
						success: function(data) {
							if(data == 1) {
								var str = 'id';
								
								document.getElementById("msg_id").innerHTML = "누군가 이미 사용중인 아이디입니다 :(";
								document.getElementById("msg_id").style.color = '#fc5230';
								ff.id_dup.value = '';
							} else {
								document.getElementById("msg_id").innerHTML = "사용 가능한 아이디입니다 :)";
								document.getElementById("msg_id").style.color = '#3883c9';
								ff.id_dup.value = '1';
							}
							
							ff.memberID.focus();
							document.getElementById("msg_id").style.display = 'block';
						}, error: function() {
							alert("서버가 불안정하거나 연결되어 있지 않아 통신을 할 수 없습니다.");
						}
					});
				}
			}
			
			function nickCheck() {
				var nick = ff.nick.value;
				
				if(!nick) {
					document.getElementById("msg_nick").innerHTML = "닉네임을 입력해주세요.";
					document.getElementById("msg_nick").style.color = '#d45555';
					document.getElementById("msg_nick").style.display = 'block';
					ff.nick.focus();
					return false;
				} else if(ff.nick.value.length > 10) {
					document.getElementById("msg_nick").innerHTML = "닉네임은 10자 까지 가능합니다.";
					document.getElementById("msg_nick").style.color = '#d45555';
					document.getElementById("msg_nick").style.display = 'block';
					ff.nick.focus();
					return false;
				} else {
					var register_nick = $('#register_nick').val();
					
					$.ajax({
						url: '../member/duplicationCheckPro.jsp?register_nick=' + register_nick,
						type: 'get',
						success: function(data) {
							if(data == 1) {
								var str = 'nick';
								
								document.getElementById("msg_nick").innerHTML = "누군가 이미 사용중인 닉네임입니다 :(";
								document.getElementById("msg_nick").style.color = '#fc5230';
								ff.nick_dup.value = '';
							} else {
								document.getElementById("msg_nick").innerHTML = "잘 어울리는 닉네임이네요 :)";
								document.getElementById("msg_nick").style.color = '#3883c9';
								ff.nick_dup.value = '1';
							}
							
							ff.nick.focus();
							document.getElementById("msg_nick").style.display = 'block';
						}, error: function() {
							alert("서버가 불안정하거나 연결되어 있지 않아 통신을 할 수 없습니다.");
						}
					});
				}
			}
		
			function fregisterform_submit() {
				// 이메일 유효성 검사 정규표현식
				var reg_email = /^([0-9a-zA-Z_\.-]+)@([0-9a-zA-Z_-]+)(\.[0-9a-zA-Z_-]+){1,2}$/;
				
				if(!ff.id_dup.value) {
					alert("아이디 중복검사를 해주세요.");
					ff.id.focus();
					return false;
				} else if(!ff.password.value) {
					alert("비밀번호를 입력해주세요.");
					ff.password.focus();
					return false;
				} else if(ff.password.value.length < 6) {
					alert("비밀번호는 최소 6자 이상 입력해주세요.");
					ff.password.focus();
					return false;
				} else if(ff.rePassword.value !== ff.password.value) {
					alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
					ff.rePassword.focus();
					return false;
				} else if(!ff.nick_dup.value) {
					alert("닉네임 중복검사를 해주세요.");
					ff.nick.focus();
					return false;
				} else if(!ff.email.value) {
					alert("이메일을 입력해주세요.");
					ff.email.focus();
					return false;
				} else if(!reg_email.test(ff.email.value)) {
					alert("이메일 형식이 올바르지 않습니다.");
					ff.email.focus();
					return false;
				}

				return true;
			}
			
			// 중복체크 후 input 값 건들면 다시 uncheck
			function inputChk(str) {
				if(str == 'id') ff.id_dup.value = '';
				else if(str == 'nick') ff.nick_dup.value = '';
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
	</body>
</html>