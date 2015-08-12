package hpsa.web.init;

public class AppProperties {

	private ImgSrc       imgSrc;

	private String       objectStorageContainer;

	private String       objectStorageAuth;

	private final String login    = "10282162123634:alexander.shemyakin";

	private final String password = "Akvelon!!!";

	public String getLogin() {
		return login;
	}

	public String getPassword() {
		return password;
	}

	public enum ImgSrc {
		URL, BLOB, ObjectStorage;
	}

	public ImgSrc getImgSrc() {
		return imgSrc;
	}

	public void setImgSrc(ImgSrc imgSrc) {
		this.imgSrc = imgSrc;
	}

	public String getObjectStorageContainer() {
		return objectStorageContainer;
	}

	public void setObjectStorageContainer(String objectStorageContainer) {
		this.objectStorageContainer = objectStorageContainer;
	}

	public String getObjectStorageAuth() {
		return objectStorageAuth;
	}

	public void setObjectStorageAuth(String objectStorageAuth) {
		this.objectStorageAuth = objectStorageAuth;
	}
}
