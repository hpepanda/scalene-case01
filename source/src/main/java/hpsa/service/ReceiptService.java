package hpsa.service;

import hpsa.persist.entity.Receipt;

public interface ReceiptService {

	public Receipt findById(long id);

	public Receipt save(Receipt receipt);

	public void delete(Receipt receipt);

	public Receipt createReceipt(byte[] image, String fileName, String contentType);

	public Receipt updateReceipt(byte[] image, String fileName, String contentType, Receipt receipt);

	public String getImageUrl(Receipt receipt, String base);

}
