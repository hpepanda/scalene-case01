package hpsa.web.entity;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class ObjectStorageAuthReposnse {
	public ObjectStorageAuthReposnse() {
	}

	private Access access;

	public class Access {

		private Token token;

		public class Token {

			private Date   expires;

			private String id;

			public Date getExpires() {
				return expires;
			}

			public void setExpires(Date expires) {
				this.expires = expires;
			}

			public String getId() {
				return id;
			}

			public void setId(String id) {
				this.id = id;
			}
		}

		public Token getToken() {
			return token;
		}

		public void setToken(Token token) {
			this.token = token;
		}
	}

	public Access getAccess() {
		return access;
	}

	public void setAccess(Access access) {
		this.access = access;
	}
}