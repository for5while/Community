package thumbnail;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ThumbnailDAO {
	private static ThumbnailDAO instance;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 싱글톤 패턴
	private ThumbnailDAO() {}
	public static ThumbnailDAO getInstance() {
		if(instance == null) instance = new ThumbnailDAO();
		return instance;
	}
	
	public Connection connect() throws Exception {
		Context init = new InitialContext();
		DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/MysqlDB");
		conn = ds.getConnection();
		
		return conn;
	}
	
	public int upload(String tnName, String tnSourceName, String table) {
		if(tnName == null || tnSourceName == null || table == null) return -1;
		
		// write_project 게시글 기준
		// SELECT (wr_id의 데이터가 0보다 크지않다면 1 출력하고 아니라면 게시판의 wr_id 데이터를 오름차순으로 정렬해서 제일 높은 데이터를 가져와서 1을 더해줌)
		String incrementID = "(SELECT (CASE COUNT(wr_id) > 0 "
						   + " WHEN false THEN '1' ELSE (SELECT wr_id FROM write_project board ORDER BY wr_id DESC LIMIT 1)+1 END) "
						   + " FROM write_project abc)";
		String sql = "INSERT INTO thumbnail(tn_name, tn_source_name, bo_table, wr_id) values(?,?,?," + incrementID + ") ";
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);

			pstmt.setString(1, tnName);
			pstmt.setString(2, tnSourceName);
			pstmt.setString(3, table);
			
			return pstmt.executeUpdate();
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
	
	public ArrayList<ThumbnailBean> getList() {
		String sql = "SELECT * FROM thumbnail";
		ArrayList<ThumbnailBean> list = new ArrayList<ThumbnailBean>();
		
		try {
			conn = connect();
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ThumbnailBean file = new ThumbnailBean(rs.getString(1), rs.getString(2), rs.getString(3), rs.getInt(4));
				list.add(file);
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
