package hpsa.web;

import hpsa.persist.entity.Receipt;
import hpsa.web.init.AppProperties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ImgURLHelper {

	@Autowired
	private AppProperties appProperties;

	public String getImageUrl(Receipt receipt, String base) {
		switch (appProperties.getImgSrc()) {
		case BLOB:
			return base + "/receipt/img/" + receipt.getId();
		case ObjectStorage:
			return appProperties.getObjectStorageContainer() + "/" + receipt.getFileName();
		case URL:
		default:
			return receipt.getUrl();
		}
	}

}
