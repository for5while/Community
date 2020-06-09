package thumbnail;

public class ThumbnailBean {
	private String name;
	private String sourceName;
	private String table;
	private int id;
	
	public String getName() { return name; }
	public void setName(String name) { this.name = name; }
	
	public String getSourceName() { return sourceName; }
	public void setSourceName(String sourceName) { this.sourceName = sourceName; }
	
	public String getTable() { return table;} 
	public void setTable(String table) { this.table = table; }
	
	public int getId() { return id; }
	public void setId(int id) { this.id = id; }
	
	public ThumbnailBean(String name, String sourceName, String table, int id) {
		this.name = name;
		this.sourceName = sourceName;
		this.table = table;
		this.id = id;
	}
}
