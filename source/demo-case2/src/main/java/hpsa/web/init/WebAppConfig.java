package hpsa.web.init;

import hpsa.web.init.AppProperties.ImgSrc;

import java.util.Properties;
import java.util.concurrent.TimeUnit;

import javax.sql.DataSource;

import org.hibernate.jpa.HibernatePersistenceProvider;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.guava.GuavaCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.web.config.EnableSpringDataWebSupport;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.servlet.view.UrlBasedViewResolver;

import com.google.common.cache.CacheBuilder;

@Configuration
@EnableCaching
@ComponentScan("hpsa")
@EnableWebMvc
@EnableSpringDataWebSupport
@EnableTransactionManagement
@PropertySource("classpath:application.properties")
@EnableJpaRepositories("hpsa.persist.repository")
public class WebAppConfig extends WebMvcConfigurerAdapter {

	private static final Logger logger                         = LoggerFactory.getLogger(WebAppConfig.class);

	private static final String DATABASE_DRIVER                = "db.driver";
	private static final String DATABASE_PASSWORD              = "db.password";
	private static final String DATABASE_URL                   = "db.url";
	private static final String DATABASE_USERNAME              = "db.username";

	private static final String HIBERNATE_DIALECT              = "hibernate.dialect";
	private static final String HIBERNATE_SHOW_SQL             = "hibernate.show_sql";
	private static final String ENTITYMANAGER_PACKAGES_TO_SCAN = "entitymanager.packages.to.scan";

	private static final String IMG_SRC                        = "img.src";
	private static final String OBJECT_STORAGE_CONTAINER       = "object.storage.container";
	private static final String OBJECT_STORAGE_AUTH            = "object.storage.auth";

	@Autowired
	private Environment         env;

	@Bean
	public DataSource dataSource() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();

		dataSource.setDriverClassName(env.getRequiredProperty(DATABASE_DRIVER));
		dataSource.setUrl(env.getRequiredProperty(DATABASE_URL));
		dataSource.setUsername(env.getRequiredProperty(DATABASE_USERNAME));
		dataSource.setPassword(env.getRequiredProperty(DATABASE_PASSWORD));

		return dataSource;
	}

	@Bean
	public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
		LocalContainerEntityManagerFactoryBean entityManagerFactoryBean = new LocalContainerEntityManagerFactoryBean();
		entityManagerFactoryBean.setDataSource(dataSource());
		entityManagerFactoryBean.setPersistenceProviderClass(HibernatePersistenceProvider.class);
		entityManagerFactoryBean.setPackagesToScan(env.getRequiredProperty(ENTITYMANAGER_PACKAGES_TO_SCAN));
		entityManagerFactoryBean.setJpaProperties(hibernateProperties());
		return entityManagerFactoryBean;
	}

	private Properties hibernateProperties() {
		Properties properties = new Properties();
		properties.put(HIBERNATE_DIALECT, env.getRequiredProperty(HIBERNATE_DIALECT));
		properties.put(HIBERNATE_SHOW_SQL, env.getRequiredProperty(HIBERNATE_SHOW_SQL));
		return properties;
	}

	@Bean
	public JpaTransactionManager transactionManager() {
		JpaTransactionManager transactionManager = new JpaTransactionManager();
		transactionManager.setEntityManagerFactory(entityManagerFactory().getObject());
		return transactionManager;
	}

	@Bean
	public UrlBasedViewResolver setupViewResolver() {
		UrlBasedViewResolver resolver = new UrlBasedViewResolver();
		resolver.setPrefix("/WEB-INF/pages/");
		resolver.setSuffix(".jsp");
		resolver.setViewClass(JstlView.class);
		return resolver;
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/css/**").addResourceLocations("/css/").setCachePeriod(86400);
		registry.addResourceHandler("/js/**").addResourceLocations("/js/").setCachePeriod(86400);
		registry.addResourceHandler("/css/img/**").addResourceLocations("/css/img/").setCachePeriod(86400);
	}

	@Bean
	public AppProperties buildAppProperties() {
		String imgSrcValue = env.getProperty(IMG_SRC);
		ImgSrc source = ImgSrc.URL;// default
		if (imgSrcValue != null) {
			try {
				source = ImgSrc.valueOf(imgSrcValue);
			} catch (IllegalArgumentException e) {
				logger.error(e.toString() + "; defaulting to URL image source");
			}
		}

		String objectStorageContainer = env.getProperty(OBJECT_STORAGE_CONTAINER);
		String objectStorageAuth = env.getProperty(OBJECT_STORAGE_AUTH);
		if (source == ImgSrc.ObjectStorage && objectStorageContainer == null) {
			String message = "object.storage.container should defined in application.properties in case ObjectStorage is chosen";
			logger.error(message);
			throw new IllegalArgumentException(message);
		}

		AppProperties properties = new AppProperties();
		properties.setImgSrc(source);
		properties.setObjectStorageContainer(objectStorageContainer);
		properties.setObjectStorageAuth(objectStorageAuth);
		return properties;
	}

	@Bean
	public CacheManager cacheManager() {
		GuavaCacheManager cacheManager = new GuavaCacheManager();
		cacheManager.setCacheBuilder(CacheBuilder.newBuilder().expireAfterAccess(30, TimeUnit.MINUTES));
		return cacheManager;
	}

	@Bean
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver resolver = new CommonsMultipartResolver();
		resolver.setMaxUploadSize(10485760);
		return resolver;
	}
}