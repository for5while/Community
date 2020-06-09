package board;

import java.sql.Timestamp;

public class BoardBean {
	private int idx;
	private int id;
	private int commentID;
	private int commentGroup;
	private int commentSequen;
	private String subject;
	private String content;
	private int option;
	private int hit;
	private int good;
	private String memberId;
	private String nick;
	private String password;
	private Timestamp datetime;
	private String simpleDatetime;
	private int file;
	private Timestamp last;
	private String ip;
	private int newWrite;
	private String table;
	
	public int getIdx() { return idx; }
	public void setIdx(int idx) { this.idx = idx; }
	
	public int getId() { return id; }
	public void setId(int id) { this.id = id; }
	
	public int getCommentID() { return commentID; }
	public void setCommentID(int num) { this.commentID = num; }
	
	public int getCommentGroup() { return commentGroup; }
	public void setCommentGroup(int commentGroup) { this.commentGroup = commentGroup; }
	
	public int getCommentSequen() { return commentSequen; }
	public void setCommentSequen(int commentSequen) { this.commentSequen = commentSequen; }
	
	public String getSubject() { return subject; }
	public void setSubject(String subject) { this.subject = subject; }
	
	public String getContent() { return content; }
	public void setContent(String content) { this.content = content; }
	
	public int getOption() { return option; }
	public void setOption(int option) { this.option = option; }
	
	public int getHit() { return hit; }
	public void setHit(int hit) { this.hit = hit; }
	
	public int getGood() { return good; }
	public void setGood(int good) { this.good = good; }
	
	public String getMemberId() { return memberId; }
	public void setMemberId(String memberId) { this.memberId = memberId; }
	
	public String getNick() { return nick; }
	public void setNick(String nick) { this.nick = nick; }
	
	public String getPassword() { return password; }
	public void setPassword(String password) { this.password = password; }

	public Timestamp getDatetime() { return datetime; }
	public void setDatetime(Timestamp datetime) { this.datetime = datetime; }

	public String getSimpleDatetime() { return simpleDatetime; }
	public void setSimpleDatetime(String simpleDatetime) { this.simpleDatetime = simpleDatetime; }
	
	public int getFile() { return file; }
	public void setFile(int file) { this.file = file; }
	
	public Timestamp getLast() { return last; }
	public void setLast(Timestamp last) { this.last = last; }
	
	public String getIp() { return ip; }
	public void setIp(String ip) { this.ip = ip; }
	
	public int getNewWrite() { return newWrite; }
	public void setNewWrite(int newWrite) { this.newWrite = newWrite; }
	
	public String getTable() { return table; }
	public void setTable(String table) { this.table = table; }
}
