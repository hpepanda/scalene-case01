package hpsa.service;

import hpsa.web.entity.ObjectStorageAuthReposnse;
import hpsa.web.init.AppProperties;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Service
public class ObjectStorageService implements InitializingBean {

	@Autowired
	private AppProperties       appProperties;

	private AuthData            authData;

	private static final Logger logger = LoggerFactory.getLogger(ObjectStorageService.class);

	@Override
	public void afterPropertiesSet() throws Exception {
		authData = new AuthData(appProperties);
		this.auth();
	}

	public void auth() {
		if (authData.getToken() == null || authData.getExpires() == null || authData.getExpires().before(new Date())) {
			RestTemplate restTemplate = new RestTemplate();
			HttpHeaders headers = new HttpHeaders();
			headers.set("x-auth-user", authData.getLogin());
			headers.set("x-auth-key", authData.getPassword());
			HttpEntity<String> entity = new HttpEntity<String>("parameters", headers);
			try {
				ResponseEntity<ObjectStorageAuthReposnse> response = restTemplate.exchange(authData.getAuthUri(),
				        HttpMethod.GET, entity, ObjectStorageAuthReposnse.class);
				authData.setExpires(response.getBody().getAccess().getToken().getExpires());
				authData.setToken(response.getBody().getAccess().getToken().getId());
			} catch (RestClientException e) {
				logger.error("Could not acquire an access token due to: " + e.toString(), e);
			}

		}

	}

	public String uploadImage(byte[] image, String fileName, String contentType) {
		auth();
		RestTemplate restTemplate = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		headers.set("X-Auth-Token", authData.getToken());
		headers.set("Content-Type", contentType);
		HttpEntity<byte[]> entity = new HttpEntity<byte[]>(image, headers);
		try {
			String id = generateFileName(fileName);
			ResponseEntity<String> response = restTemplate.exchange(authData.getContainerUri() + id, HttpMethod.PUT,
			        entity, String.class);
			logger.debug(response.toString());
			if (HttpStatus.CREATED.equals(response.getStatusCode())) {
				return id;
			}
		} catch (RestClientException e) {
			logger.error("Could not upload image due to: " + e.toString(), e);
		}
		return null;

	}

	private String generateFileName(String fileName) {
		return new Date().getTime() + fileName;
	}

	public class AuthData {
		public AuthData(AppProperties properties) {
			this.login = properties.getLogin();
			this.password = properties.getPassword();
			this.containerUri = properties.getObjectStorageContainer();
			this.authUri = properties.getObjectStorageAuth();

		}

		private String containerUri;

		private String authUri;

		private String login;

		private String password;

		private String token;

		private Date   expires;

		public String getContainerUri() {
			return containerUri;
		}

		public void setContainerUri(String containerUri) {
			this.containerUri = containerUri;
		}

		public String getAuthUri() {
			return authUri;
		}

		public void setAuthUri(String authUri) {
			this.authUri = authUri;
		}

		public String getLogin() {
			return login;
		}

		public void setLogin(String login) {
			this.login = login;
		}

		public String getPassword() {
			return password;
		}

		public void setPassword(String password) {
			this.password = password;
		}

		public String getToken() {
			return token;
		}

		public void setToken(String token) {
			this.token = token;
		}

		public Date getExpires() {
			return expires;
		}

		public void setExpires(Date expires) {
			this.expires = expires;
		}

	}

}
