package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

public class MemberDAO {
	
	private static MemberDAO instance;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 싱글톤 패턴
	private MemberDAO() {}
	public static MemberDAO getInstance() {
		if(instance == null) instance = new MemberDAO();
		return instance;
	}
	
	public Connection connect() throws Exception {
		Context init = new InitialContext();
		DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/MysqlDB");
		conn = ds.getConnection();
		
		return conn;
	}
	
	// 회원정보 가져오기
	public MemberBean getMember(String memberID) {
		String sql = "SELECT * FROM member WHERE mb_id = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, memberID);

			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				MemberBean mb = new MemberBean();

				mb.setNo(rs.getInt(1));
				mb.setPassword(rs.getString(3));
				mb.setNick(rs.getString(4));
				mb.setEmail(rs.getString(5));
				mb.setLevel(rs.getInt(6));
				mb.setPoint(rs.getInt(7));
				mb.setIp(rs.getString(8));
				mb.setDatetime(rs.getTimestamp(9));
				mb.setLeaveDatetime(rs.getString(10));
				mb.setEmailCertify(rs.getInt(11));
				mb.setEmailCertify2(rs.getString(12));
				mb.setLostCertify(rs.getString(13));
				mb.setZip(rs.getString(14));
				mb.setAddr1(rs.getString(15));
				mb.setAddr2(rs.getString(16));
				
				return mb;
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return null;
	}
	
	// 이메일인증 및 회원가입 완료 된 명수 가져오기 
	// Schedule cron 사용이 필요함
	public int getMemberCount(String memberID) {
		String sql = "SELECT COUNT(mb_no) FROM member WHERE mb_email_certify = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, "1");

			rs = pstmt.executeQuery();
			
			if(rs.next()) return rs.getInt(1);
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return -1;
	}
	
	// 회원가입
	public void insertMember(MemberBean mb) {		
		String sql = " insert into member(mb_id, mb_password, mb_nick, mb_email, mb_level, mb_point, mb_login_ip, mb_datetime, mb_leave_date, mb_email_certify, mb_email_certify2, mb_lost_certify, mb_zip, mb_addr1, mb_addr2) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, mb.getId());
			pstmt.setString(2, mb.getPassword());
			pstmt.setString(3, mb.getNick());
			pstmt.setString(4, mb.getEmail());
			pstmt.setInt(5, mb.getLevel());
			pstmt.setInt(6, mb.getPoint());
			pstmt.setString(7, mb.getIp());
			pstmt.setTimestamp(8, mb.getDatetime());
			pstmt.setString(9, mb.getLeaveDatetime());
			pstmt.setInt(10, mb.getEmailCertify());
			pstmt.setString(11, mb.getEmailCertify2());
			pstmt.setString(12, mb.getLostCertify());
			pstmt.setString(13, mb.getZip());
			pstmt.setString(14, mb.getAddr1());
			pstmt.setString(15, mb.getAddr2());
			
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
	}
	
	// 아이디 중복체크
	// return (false: 중복 아님, true: 중복)
	public boolean getMemberIdChk(String id) {
		String sql = "SELECT * FROM member WHERE mb_id = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(id.equals(rs.getString("mb_id"))) return true;
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return false;
	}
	
	// 닉네임 중복체크
	// return (false: 중복 아님, true: 중복)
	public boolean getMemberNickChk(String nick) {
		String sql = "SELECT * FROM member WHERE mb_nick = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, nick);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(nick.equals(rs.getString("mb_nick"))) return true;
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return false;
	}
	
	// 이메일 중복체크
	// return (false: 중복 아님, true: 중복)
	public boolean getMemberEmailChk(String email) {
		String sql = "SELECT * FROM member WHERE mb_email = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(email.equals(rs.getString("mb_email"))) return true;
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return false;
	}
	
	// 이메일 인증 여부 체크
	// return (false: 인증 필요, true: 인증 완료)
	public boolean getMemberEmailChecked(String id) {
		String sql = "SELECT mb_email_certify FROM member WHERE mb_id = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(rs.getInt("mb_email_certify") != 0) return true;
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return false;
	}
	
	// 회원 이메일주소 인증 설정 후 난수 컬럼 초기화
	public void setMemberEmailChecked(String id) {
		String sql = "UPDATE member SET mb_email_certify = ?, mb_email_certify2 = ? WHERE mb_id = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
	
			pstmt.setInt(1, 1);
			pstmt.setString(2, "");
			pstmt.setString(3, id);
			
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
	}
	
	// 회원 이메일주소 리턴
	public String getMemberEmail(String id) {
		String sql = "SELECT mb_email FROM member WHERE mb_id = ?";
		String str = "";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) str = rs.getString("mb_email");
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return str;
	}
	
	// 로그인 체크
	// return (-1:아이디 없음, 0:로그인 가능, 1:비밀번호 불일치, 2:이메일 미인증)
	public int loginCheck(String id, String password) {
		String sql = "SELECT * FROM member WHERE mb_id = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();

			if(rs.next()) {
				// 비밀번호 불일치
				if(!password.equals(rs.getString("mb_password"))) {
					return 1;
				} else if(rs.getInt("mb_email_certify") != 1) { // 이메일 미인증
					return 2;
				}
			} else {
				// 아이디 없음
				return -1;
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return 0;
	}
	
	// 회원정보수정
	public void modifyMember(MemberBean mb) {
		String sql = "update member set mb_password = ?, mb_nick = ?, mb_zip = ?, mb_addr1 = ?, mb_addr2 = ? where mb_id = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, mb.getPassword());
			pstmt.setString(2, mb.getNick());
			pstmt.setString(3, mb.getZip());
			pstmt.setString(4, mb.getAddr1());
			pstmt.setString(5, mb.getAddr2());
			pstmt.setString(6, mb.getId());

			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
	}
	
	/** 
	 * 회원정보 중복 검사
	 * 
	 * @param	str, type(1:id, 2:nick, 3:email)
	 * @return	true(중복), false(미중복)
	 * 
	 */
	public boolean duplicateCheck(String str, int type) {
		String column = null;
		
		if(type == 1) column = "id";
		else if(type == 2) column = "nick";
		else if(type == 3) column = "email";
		
		String sql = "SELECT mb_" + column + " FROM member WHERE mb_" + column + " = ?";
		boolean x = false;
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, str);
			rs = pstmt.executeQuery();
			
			if(rs.next()) x = true;
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) { pstmt.close(); pstmt=null; }
				if(conn != null) { conn.close(); conn=null; }
				if(rs != null) { rs.close(); rs=null; }
			} catch(Exception e) {
				e.toString();
			}
		}
		
		return x;
	}
}
