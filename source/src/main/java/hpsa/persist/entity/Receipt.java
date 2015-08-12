package hpsa.persist.entity;

import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;

@Entity
@Table(name = "receipts")
public class Receipt {

	@Id
	@GeneratedValue
	private Long   id;

	private String url;

	@Lob
	@Basic(fetch = FetchType.LAZY)
	@Column(name = "binary_image")
	private byte[] binaryImage;

	@Column(name = "file_name")
	private String fileName;

	@Column(name = "timestamp")
	private Date   timeStamp;

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public byte[] getBinaryImage() {
		return binaryImage;
	}

	public void setBinaryImage(byte[] binaryImage) {
		this.binaryImage = binaryImage;
	}

	public Date getTimeStamp() {
		return timeStamp;
	}

	public void setTimeStamp(Date timeStamp) {
		this.timeStamp = timeStamp;
	}

}
