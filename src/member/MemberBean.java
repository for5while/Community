package member;

import java.sql.Timestamp;

public class MemberBean {
	private int no;
	private String id;
	private String password;
	private String nick;
	private String email;
	private int level;
	private int point;
	private String ip;
	private Timestamp datetime;
	private String leaveDatetime;
	private int emailCertify;
	private String emailCertify2;
	private String lostCertify;

	private String zip;
	private String addr1;
	private String addr2;
	
	public int getNo() { return no; }
	public void setNo(int no) { this.no = no; }

	public String getId() { return id; }
	public void setId(String id) { this.id = id; }
	
	public String getPassword() { return password; }
	public void setPassword(String password) { this.password = password; }
	
	public String getNick() { return nick; }
	public void setNick(String nick) { this.nick = nick; }
	
	public String getEmail() { return email; }
	public void setEmail(String email) { this.email = email; }
	
	public int getLevel() { return level; }
	public void setLevel(int level) { this.level = level; }
	
	public int getPoint() { return point; }
	public void setPoint(int point) { this.point = point; }
	
	public String getIp() { return ip; }
	public void setIp(String ip) { this.ip = ip; }
	
	public Timestamp getDatetime() { return datetime; }
	public void setDatetime(Timestamp datetime) { this.datetime = datetime; }
	
	public String getLeaveDatetime() { return leaveDatetime; }
	public void setLeaveDatetime(String leaveDatetime) { this.leaveDatetime = leaveDatetime; }
	
	public int getEmailCertify() { return emailCertify; }
	public void setEmailCertify(int emailCertify) { this.emailCertify = emailCertify; }
	
	public String getEmailCertify2() { return emailCertify2; }
	public void setEmailCertify2(String emailCertify2) { this.emailCertify2 = emailCertify2; }
	
	public String getLostCertify() { return lostCertify; }
	public void setLostCertify(String lostCertify) { this.lostCertify = lostCertify; }

	public String getZip() { return zip; }
	public void setZip(String zip) { this.zip = zip; }
	
	public String getAddr1() { return addr1; }
	public void setAddr1(String addr1) { this.addr1 = addr1; }
	
	public String getAddr2() { return addr2; }
	public void setAddr2(String addr2) { this.addr2 = addr2; }
}
