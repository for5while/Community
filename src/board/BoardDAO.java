package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BoardDAO {

	private static BoardDAO instance;
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	// 싱글톤 패턴
	private BoardDAO() {}
	public static BoardDAO getInstance() {
		if(instance == null) instance = new BoardDAO();
		return instance;
	}
	
	// DB 커넥션
	public Connection connect() throws Exception {
		Context init = new InitialContext();
		DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/MysqlDB");
		conn = ds.getConnection();
		
		return conn;
	}

	// 게시글 정보 가져오기 (테이블, 글번호)
	public BoardBean getWrite(String table, int id) {
		String sql = "SELECT * FROM write_" + table + " WHERE wr_id = ?";

		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, id);

			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				BoardBean bb = new BoardBean();

				bb.setIdx(rs.getInt(1));
				bb.setId(rs.getInt(2));
				bb.setCommentID(rs.getInt(3));
				bb.setCommentGroup(rs.getInt(4));
				bb.setCommentSequen(rs.getInt(5));
				bb.setOption(rs.getInt(6));
				bb.setSubject(rs.getString(7));
				bb.setContent(rs.getString(8));
				bb.setHit(rs.getInt(9));
				bb.setGood(rs.getInt(10));
				bb.setMemberId(rs.getString(11));
				bb.setPassword(rs.getString(12));
				bb.setDatetime(rs.getTimestamp(13));
				bb.setFile(rs.getInt(14));
				bb.setLast(rs.getTimestamp(15));
				bb.setIp(rs.getString(16));
				
				return bb;
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
	
	// 게시판 글쓰기
	public void writeBoard(BoardBean bb, String table) {
		// SELECT (wr_id의 데이터가 0보다 크지않다면 1 출력하고 아니라면 게시판의 wr_id 데이터를 오름차순으로 정렬해서 제일 높은 데이터를 가져와서 1을 더해줌)
		String incrementID = "(SELECT (CASE COUNT(wr_id) > 0 "
						   + " WHEN false THEN '1' ELSE (SELECT wr_id FROM write_" + table + " board ORDER BY wr_id DESC LIMIT 1)+1 END) "
						   + " FROM write_" + table + " abc)";
		String sql = "INSERT INTO write_" + table + "(wr_id, wr_co_id, wr_co_group, wr_co_sequen, wr_option, wr_subject, wr_content, wr_hit, wr_good, mb_id, wr_password, wr_datetime, wr_file, wr_last, wr_ip) "
				   + "VALUES(" + incrementID + ",?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			// wr_id (subQuery)
			pstmt.setInt(1, bb.getCommentID());
			pstmt.setInt(2, bb.getCommentGroup());
			pstmt.setInt(3, bb.getCommentSequen());
			pstmt.setInt(4, bb.getOption());
			pstmt.setString(5, bb.getSubject());
			pstmt.setString(6, bb.getContent());
			pstmt.setInt(7, bb.getHit());
			pstmt.setInt(8, bb.getGood());
			pstmt.setString(9, bb.getMemberId());
			pstmt.setString(10, bb.getPassword());
			pstmt.setTimestamp(11, bb.getDatetime());
			pstmt.setInt(12, bb.getFile());
			pstmt.setTimestamp(13, bb.getLast());
			pstmt.setString(14, bb.getIp());
			
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
	
	// 댓글 쓰기
	public void writeComment(BoardBean bb, String table, int viewID, int commentID, int group) {
		// SELECT (wr_co_id의 데이터가 0보다 크지않다면 1 출력하고 아니라면 게시판의 wr_co_id 데이터를 오름차순으로 정렬해서 제일 높은 데이터를 가져와서 1을 더해줌)
		String incrementCommentID = "(SELECT (CASE COUNT(wr_co_id) > 0 "
								  + " WHEN false THEN '1' ELSE (SELECT wr_co_id FROM write_" + table + " board ORDER BY wr_co_id DESC LIMIT 1)+1 END) "
								  + " FROM write_" + table + " abc)";
		// 위와 방법은 동일하지만 글번호(wr_id)를 기준으로 댓글 그룹 순서를 매김
		String incrementCommentGr = "(SELECT (CASE COUNT(wr_co_group) > 0 "
								  + " WHEN false THEN '1' ELSE (SELECT wr_co_group FROM write_" + table + " board WHERE wr_id = " + viewID + " ORDER BY wr_co_group DESC LIMIT 1)+1 END) "
								  + " FROM write_" + table + " abc)";
		String incrementCommentSe = "0";

		// 대댓글 작성했을 때 (그룹은 입력받은 group 파라미터 값으로 저장)
		if(group > 0) {
			// 위와 방법은 동일하지만 글번호(wr_id)와 댓글그룹(wr_co_group)을 기준으로 대댓글 내부의 순서를 매김
			incrementCommentGr = String.valueOf(group);
			incrementCommentSe = "(SELECT (CASE COUNT(wr_co_sequen) > 0 "
							   + " WHEN false THEN '1' ELSE (SELECT wr_co_sequen FROM write_" + table + " board WHERE wr_id = " + viewID + " AND wr_co_group = " + group + " ORDER BY wr_co_sequen DESC LIMIT 1)+1 END) "
							   + " FROM write_" + table + " abc)";
		}
		
		String sql = "INSERT INTO write_" + table + "(wr_id, wr_co_id, wr_co_group, wr_co_sequen, wr_option, wr_subject, wr_content, wr_hit, wr_good, mb_id, wr_datetime, wr_file, wr_last, wr_ip) "
				+ "VALUES(?," + incrementCommentID + "," + incrementCommentGr + "," + incrementCommentSe + ",?,?,?,?,?,?,?,?,?,?)";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, viewID);
			pstmt.setInt(2, bb.getOption());
			pstmt.setString(3, bb.getSubject());
			pstmt.setString(4, bb.getContent());
			pstmt.setInt(5, bb.getHit());
			pstmt.setInt(6, bb.getGood());
			pstmt.setString(7, bb.getMemberId());
			pstmt.setTimestamp(8, bb.getDatetime());
			pstmt.setInt(9, bb.getFile());
			pstmt.setTimestamp(10, bb.getLast());
			pstmt.setString(11, bb.getIp());
			
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
	
	// 게시판 글수정
	public void writeModify(BoardBean bb, String table) {
		String sql = "UPDATE write_" + table + " SET wr_option = ?, wr_subject = ?, wr_content = ?, wr_password = ?, wr_last = ? WHERE wr_id = ? AND wr_co_id = 0";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, bb.getOption());
			pstmt.setString(2, bb.getSubject());
			pstmt.setString(3, bb.getContent());
			pstmt.setString(4, bb.getPassword());
			pstmt.setTimestamp(5, bb.getLast());
			pstmt.setInt(6, bb.getId());
			
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
	
	// 댓글 수정
	public void commentModify(BoardBean bb, String table) {
		String sql = "UPDATE write_" + table + " SET wr_content = ? WHERE wr_co_id = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, bb.getContent());
			pstmt.setInt(2, bb.getCommentID());
			
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
	 * 게시판 글/댓글 삭제
	 * @return type(1: 게시글, 2: 댓글)
	 */
	public void writeDelete(BoardBean bb, String table, int wrID, int type) {
		String sql = null;
		
		// 게시글 삭제 시 댓글의 wr_id가 동일하여 댓글도 동시 삭제 처리
		if(type == 1) sql = "DELETE FROM write_" + table + " WHERE wr_id = ?";
		else sql = "DELETE FROM write_" + table + " WHERE wr_id = " + wrID + " AND wr_co_id = ?";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, bb.getId());
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
	
	// 게시판 글 작성자 아이디 가져오기
	public String getWriteMember(int wr_id, String table) {
		String sql = "SELECT mb_id FROM write_" + table + " WHERE wr_id = ?";
		
		try {
			connect();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, wr_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) return rs.getString("mb_id");

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
	
	// 댓글 작성자 아이디 가져오기
	public String getWriteCommentMember(int wr_co_id, String table) {
		String sql = "SELECT mb_id FROM write_" + table + " WHERE wr_co_id = ?";
		
		try {
			connect();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, wr_co_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) return rs.getString("mb_id");

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
	
	// 글 수정 시 저장 된 글 데이터 가져오기
	public BoardBean readModify(int wr_id, String table) {
		String sql = "SELECT wr_id, wr_subject, wr_content, wr_option, wr_password, mb_id FROM write_" + table + " WHERE wr_id = ? AND wr_co_id = 0";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, wr_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				BoardBean bb = new BoardBean();
				bb.setId(rs.getInt("wr_id"));
				bb.setSubject(rs.getString("wr_subject"));
				bb.setContent(rs.getString("wr_content"));
				bb.setOption(rs.getInt("wr_option"));
				bb.setPassword(rs.getString("wr_password"));
				bb.setMemberId(rs.getString("mb_id"));
				
				return bb;
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
	
	/**
	 * 게시판 글 목록 가져오기
	 * 
	 * @param startRow, pageSize, table
	 * @param searchType(1: 제목, 2: 내용, 3: 제목+내용, 4: 글쓴이), keyword(검색 내용)
	 */
	public ArrayList<BoardBean> getList(int startRow, int pageSize, String table, int searchType, String keyword) {
		String sql = null;
		String type = "";

		switch(searchType) {
		case 1: type = "AND a.wr_subject LIKE ? ";
				break;
		case 2: type = "AND a.wr_content LIKE ? ";
				break;
		case 3: type = "AND a.wr_subject LIKE ? OR a.wr_content LIKE ? AND a.wr_co_id = 0 ";
				break;
		case 4: type = "AND b.mb_nick LIKE ? ";
				break;
		}

		sql = "SELECT a.wr_id, a.wr_co_id, a.wr_option, a.wr_subject, a.wr_hit, a.wr_good, a.wr_datetime, a.wr_file, a.mb_id, b.mb_nick, IF(DATE_SUB(NOW(), INTERVAL 1 DAY) <= a.wr_datetime, 1, 0) AS new "
			+ "FROM write_" + table + " a LEFT JOIN member b "
			+ "ON a.mb_id = b.mb_id "
			+ "WHERE a.wr_co_id = 0 " + type
			+ "ORDER BY a.wr_id DESC LIMIT ?, ?";
		ArrayList<BoardBean> list = new ArrayList<BoardBean>();
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			if(searchType != 0 && keyword != null) {
				pstmt.setString(1, "%" + keyword + "%");
				
				if(searchType == 3) {
					pstmt.setString(2, "%" + keyword + "%");
					pstmt.setInt(3, startRow-1); // limit은 다음 번호부터 시작하니 -1
					pstmt.setInt(4, pageSize);
				} else {
					pstmt.setInt(2, startRow-1); // limit은 다음 번호부터 시작하니 -1
					pstmt.setInt(3, pageSize);
				}
				
			} else {
				pstmt.setInt(1, startRow-1); // limit은 다음 번호부터 시작하니 -1
				pstmt.setInt(2, pageSize);
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardBean bb = new BoardBean();
				
				bb.setId(rs.getInt("wr_id"));
				bb.setOption(rs.getInt("wr_option"));
				bb.setSubject(rs.getString("wr_subject"));
				bb.setHit(rs.getInt("wr_hit"));
				bb.setGood(rs.getInt("wr_good"));
				bb.setDatetime(rs.getTimestamp("wr_datetime"));
				bb.setFile(rs.getInt("wr_file"));
				bb.setMemberId(rs.getString("mb_id"));
				bb.setNewWrite(rs.getInt("new")); // 글 작성일자 1일 이하일 때 1 출력 후 저장
				
				list.add(bb);
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
		
		return list;
	}
	
	// 게시판 댓글 목록 가져오기
	public ArrayList<BoardBean> getCommentList(int startRow, int pageSize, int wrID, String table) {
		String sql = "SELECT a.wr_id, a.wr_co_id, a.wr_co_group, a.wr_co_sequen, a.wr_content, a.wr_good, a.wr_datetime, b.mb_id, b.mb_nick "
				   + "FROM write_" + table + " a LEFT JOIN member b "
				   + "ON a.mb_id = b.mb_id "
				   + "WHERE wr_id = ? AND wr_co_id > 0 "
				   + "ORDER BY wr_co_group, wr_co_sequen LIMIT ?, ?;";
		ArrayList<BoardBean> commentList = new ArrayList<BoardBean>();
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, wrID);
			pstmt.setInt(2, startRow-1); // limit은 다음 번호부터 시작하니 -1
			pstmt.setInt(3, pageSize);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardBean bb = new BoardBean();
				bb.setId(rs.getInt("wr_id"));
				bb.setCommentID(rs.getInt("wr_co_id"));
				bb.setCommentGroup(rs.getInt("wr_co_group"));
				bb.setCommentSequen(rs.getInt("wr_co_sequen"));
				bb.setContent(rs.getString("wr_content"));
				bb.setGood(rs.getInt("wr_good"));
				bb.setDatetime(rs.getTimestamp("wr_datetime"));
				bb.setMemberId(rs.getString("mb_id"));
				bb.setNick(rs.getString("mb_nick"));
				
				commentList.add(bb);
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
		
		return commentList;
	}
	
	/**
	 * 게시판 전체 글 갯수 가져오기
	 * 
	 * @param table
	 * @param searchType(1: 제목, 2: 내용, 3: 제목+내용, 4: 글쓴이), keyword(검색 내용)
	 */
	public int getWriteCount(String table, int searchType, String keyword) {
		String type = "";
		String sql = null;

		switch(searchType) {
		case 1: type = " AND wr_subject LIKE ? ";
				break;
		case 2: type = " AND wr_content LIKE ? ";
				break;
		case 3: type = " AND wr_subject LIKE ? OR wr_content LIKE ? ";
				break;
		case 4: type = " AND b.mb_nick LIKE ? ";
				break;
		}
		
		if(searchType != 4) sql = "SELECT COUNT(wr_id) FROM write_" + table + " WHERE wr_co_id = 0" + type;
		else sql = "SELECT COUNT(*) FROM write_" + table + " a LEFT JOIN member b ON a.mb_id = b.mb_id WHERE wr_co_id = 0" + type;
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			if(searchType != 0 && keyword != null) {
				pstmt.setString(1, "%" + keyword + "%");
				if(searchType == 3) pstmt.setString(2, "%" + keyword + "%");
			}
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) { return rs.getInt(1); }
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
	
	/**
	 * 게시글 댓글 갯수 가져오기
	 * @return wrID(게시글아이디), table(테이블아이디)
	 */
	public int getCommentCount(int wrID, String table) {
		try {
			connect();
			String sql = null;
		
			sql = "SELECT COUNT(wr_co_id) FROM write_" + table + " WHERE wr_id = ? AND wr_co_id > 0";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, wrID);
			rs = pstmt.executeQuery();
			
			if(rs.next()) { return rs.getInt(1); }
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
	
	// 글 읽기
	public BoardBean writeRead(int wr_id, String table) {
		String sql = "SELECT a.wr_id, a.wr_subject, a.wr_option, a.mb_id, a.wr_hit, a.wr_good, a.wr_datetime, a.wr_content, b.mb_nick "
				+ "FROM write_" + table + " a LEFT JOIN member b "
				+ "ON a.mb_id = b.mb_id WHERE wr_id = ? AND wr_co_id = 0";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, wr_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				BoardBean bb = new BoardBean();
				
				bb.setId(rs.getInt("wr_id"));
				bb.setSubject(rs.getString("wr_subject"));
				bb.setOption(rs.getInt("wr_option"));
				bb.setContent(rs.getString("wr_content"));
				bb.setMemberId(rs.getString("mb_id"));
				bb.setNick(rs.getString("mb_nick"));
				bb.setHit(rs.getInt("wr_hit") + 1); // 미리 증가한 조회수로 출력
				bb.setGood(rs.getInt("wr_good"));
				bb.setDatetime(rs.getTimestamp("wr_datetime"));
				
				// 조회수 증가
				sql = "UPDATE write_" + table + " SET wr_hit = wr_hit + 1 WHERE wr_id = ? AND wr_co_id = 0";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, wr_id);
				pstmt.executeUpdate();
				
				return bb;
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
	
	/**
	 * 추천 or 비추천 여부 확인
	 * 
	 * @param id(글번호), type(1: 게시글, 2: 댓글)
	 * @return 0: 가능, 1: 추천완료, 2: 비추천완료
	 */
	public int getRecommend(String table, int id, String memberID, int type) {
		String sql = null;

		if(type == 1) sql = "SELECT bo_table, wr_id, mb_id, bg_flag FROM board_good WHERE bo_table = ? AND wr_id = ? AND mb_id = ?";
		else sql = "SELECT bo_table, wr_co_id, mb_id, bg_flag FROM board_good_co WHERE bo_table = ? AND wr_co_id = ? AND mb_id = ?";
		
		try {
			connect();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, table);
			pstmt.setInt(2, id);
			pstmt.setString(3, memberID);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(rs.getInt("bg_flag") == 1) return 1;
				else return 2;
			}
			else return 0;

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
	
	/**
	 * 추천 or 비추천 설정
	 * @param table, type(1: 게시글, 2: 댓글)
	 */
	public void setRecommend(BoardBean bb, String table, int type) {
		int idParam = 0;
		String sql = null;
		String upDown = null;
		
		if(type == 1) {
			sql = "INSERT INTO board_good(bo_table, wr_id, mb_id, bg_flag) "
				+ "VALUES(?,?,?,?)";
			idParam = bb.getId();
		} else {
			sql = "INSERT INTO board_good_co(bo_table, wr_co_id, mb_id, bg_flag) "
				+ "VALUES(?,?,?,?)";
			idParam = bb.getCommentID();
		}
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, table);
			pstmt.setInt(2, idParam);
			pstmt.setString(3, bb.getMemberId());
			pstmt.setInt(4, bb.getGood());
			pstmt.executeUpdate();
			
			if(bb.getGood() == 1) upDown = "+1";
			else upDown = "-1";
			
			if(type == 1) sql = "UPDATE write_" + table + " SET wr_good = wr_good" + upDown + " WHERE wr_id = ? AND wr_co_id = 0";
			else sql = "UPDATE write_" + table + " SET wr_good = wr_good" + upDown + " WHERE wr_co_id = ? AND wr_co_id > 0";
			
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, idParam);
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
	
	// 댓글 중 추천수가 가장 높은 댓글 가져오기
	public BoardBean bestRecommend(String table, int id) {
		String sql = "SELECT a.wr_co_id, a.wr_content, a.wr_good, a.wr_datetime, b.mb_id, b.mb_nick "
				   + "FROM write_" + table + " a LEFT JOIN member b "
				   + "ON a.mb_id = b.mb_id "
				   + "WHERE a.wr_id = ? AND a.wr_co_id > 0 "
				   + "ORDER BY a.wr_good DESC LIMIT 1";
		
		try {
			connect();
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				BoardBean bb = new BoardBean();
				
				bb.setCommentID(rs.getInt("wr_co_id"));
				bb.setContent(rs.getString("wr_content"));
				bb.setGood(rs.getInt("wr_good"));
				bb.setDatetime(rs.getTimestamp("wr_datetime"));
				bb.setNick(rs.getString("mb_nick"));
				
				return bb;
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
	
	// 게시판 최근 글 가져오기
	// table, count(갯수)
	public ArrayList<BoardBean> getLatest(String table, int count) {
		String subject = null;
		String sql = "SELECT wr_id, wr_subject, wr_datetime, IF(DATE_SUB(NOW(), INTERVAL 1 DAY) <= wr_datetime, 1, 0) AS new "
				   + "FROM write_" + table + " "
				   + "WHERE wr_co_id = 0 AND wr_option = 0 "
				   + "ORDER BY wr_id DESC LIMIT 0, " + count;
		ArrayList<BoardBean> list = new ArrayList<BoardBean>();
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardBean bb = new BoardBean();

				Timestamp now = new Timestamp(System.currentTimeMillis());
				SimpleDateFormat date1 = new SimpleDateFormat("MM-dd");
				SimpleDateFormat date2 = new SimpleDateFormat("HH:mm");
				String date3 = null;
				
				if(date1.format(rs.getTimestamp("wr_datetime")).equals(date1.format(now))) {
					date3 = date2.format(rs.getTimestamp("wr_datetime"));
				} else {
					date3 = date1.format(rs.getTimestamp("wr_datetime"));
				}
				
				if(rs.getString("wr_subject").length() > 14) subject = rs.getString("wr_subject").substring(0, 13) + "…";
				else subject = rs.getString("wr_subject");
				
				bb.setId(rs.getInt("wr_id"));
				bb.setSubject(subject);
				bb.setSimpleDatetime(date3);
				bb.setNewWrite(rs.getInt("new")); // 글 작성일자 1일 이하일 때 1 출력 후 저장
				bb.setTable(table);
				
				list.add(bb);
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
		
		return list;
	}
}
