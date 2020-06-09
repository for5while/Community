<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("utf-8");

int type = 0;
String str = null;

if(request.getParameter("register_id") != null) {
	str = request.getParameter("register_id");
	type = 1;
} else if(request.getParameter("register_nick") != null) {
	str = request.getParameter("register_nick");
	type = 2;
}

MemberDAO mdao = MemberDAO.getInstance();
boolean result = mdao.duplicateCheck(str, type);

if(result && type == 1) out.println("1"); // 아이디 중복
else if(!result && type == 1) out.println("0");
else if(result && type == 2) out.println("1"); // 닉네임 중복
else if(!result && type == 2) out.println("0");
%>