<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Address"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Authenticator"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="member.MemberDAO"%>
<%@page import="util.SHA256"%>
<%@page import="util.Gmail"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String memberID = null;
	if(session.getAttribute("memberID") != null) memberID = (String)session.getAttribute("memberID");

	if(memberID == null) {
		out.print("<script type='text/javascript'>");
		out.print("alert('유효하지 않은 아이디입니다.');");
		out.print("history.back();");
		out.print("</script>");
		return;
	}

	MemberDAO mdao = MemberDAO.getInstance();
	
	if(mdao.getMemberEmailChecked(memberID) == true) {
		out.print("<script type='text/javascript'>");
		out.print("alert('이미 이메일 인증이 완료 된 회원입니다.');");
		out.print("history.back();");
		out.print("</script>");
		return;
	}
	
	// 사용자에게 보낼 메시지
	new SHA256();
	
	String host = "http://192.168.1.18:8080/MyProject/member/";
	String from = "kals.mail.smtp";
	String to = mdao.getMemberEmail(memberID);
	String subject = "[국비지원갤러리] 회원가입 인증 확인입니다.";
	String content = "아래 버튼을 클릭하여 이메일 확인을 진행하세요.<br><br>" +
		"<a href='" + host + "emailCheckPro.jsp?code=" + SHA256.getSHA256(to) + "' style='color: #FFF;padding: 10px;background: #9062f5;border: 1px solid #6f45cc;border-bottom: 3px solid #6f45cc;text-decoration:none;'>인증 확인</a>";
		
	// SMTP 접속 정보
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try{
	    Authenticator auth = new Gmail();
	    
	    Session ses = Session.getInstance(p, auth);
	    ses.setDebug(true);
	    
	    MimeMessage msg = new MimeMessage(ses); 
	    msg.setSubject(subject);
	    
	    Address fromAddr = new InternetAddress(from);
	    msg.setFrom(fromAddr);
	    
	    Address toAddr = new InternetAddress(to);
	    msg.addRecipient(Message.RecipientType.TO, toAddr);
	    msg.setContent(content, "text/html;charset=UTF-8");
	    
	    Transport.send(msg);
	} catch(Exception e) {
		out.print("<script type='text/javascript'>");
		out.print("alert('이메일 전송 오류가 발생하였습니다.');");
		out.print("history.back();");
		out.print("</script>");
	    return;
	}
	
	out.print("<script type='text/javascript'>");
	out.print("alert('" + mdao.getMemberEmail(memberID) + " 이메일로 인증 확인 메일이 전송되었습니다.\\n이메일을 확인하세요.');");
	
	session.setAttribute("memberID", memberID);
	
	out.print("location.href = 'login.jsp';");
	out.print("</script>");
%>