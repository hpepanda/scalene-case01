package hpsa.service;

import hpsa.persist.entity.Receipt;
import hpsa.persist.repository.ReceiptRepository;
import hpsa.web.init.AppProperties;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReceiptServiceImpl implements ReceiptService {

	private static final Logger  logger = LoggerFactory.getLogger(ReceiptServiceImpl.class);

	@Autowired
	private ReceiptRepository    receiptRepository;

	@Autowired
	private AppProperties        appProperties;

	@Autowired
	private ObjectStorageService objectStorageService;

	@Override
	public Receipt findById(long id) {
		return receiptRepository.findOne(id);
	}

	@Override
	public Receipt save(Receipt receipt) {
		return receiptRepository.save(receipt);
	}

	@Override
	public void delete(Receipt receipt) {
		receiptRepository.delete(receipt);
	}

	@Override
	public Receipt createReceipt(byte[] image, String fileName, String contentType) {
		String error = "image upload only implemented for BLOB and ObjectStorage";
		Receipt receipt;

		switch (appProperties.getImgSrc()) {
		case BLOB:
			receipt = new Receipt();
			receipt.setTimeStamp(new Date());
			receipt.setBinaryImage(image);
			return this.save(receipt);
		case ObjectStorage:
			receipt = new Receipt();
			receipt.setTimeStamp(new Date());
			receipt.setFileName(objectStorageService.uploadImage(image, fileName, contentType));
			return this.save(receipt);
		case URL:
		default:
			logger.error(error);
			throw new IllegalArgumentException(error);
		}
	}

	@Override
	public Receipt updateReceipt(byte[] image, String fileName, String contentType, Receipt receipt) {
		String error = "image upload only implemented for BLOB and ObjectStorage";

		switch (appProperties.getImgSrc()) {
		case BLOB:
			receipt.setTimeStamp(new Date());
			receipt.setBinaryImage(image);
			return this.save(receipt);
		case ObjectStorage:
			receipt.setTimeStamp(new Date());
			receipt.setFileName(objectStorageService.uploadImage(image, fileName, contentType));
			return this.save(receipt);
		case URL:
		default:
			logger.error(error);
			throw new IllegalArgumentException(error);
		}
	}

	public String getImageUrl(Receipt receipt, String base) {
		switch (appProperties.getImgSrc()) {
		case BLOB:
			return base + "/receipt/img/" + receipt.getId();
		case ObjectStorage:
			return appProperties.getObjectStorageContainer() + receipt.getFileName();
		case URL:
		default:
			return receipt.getUrl();
		}
	}

}
