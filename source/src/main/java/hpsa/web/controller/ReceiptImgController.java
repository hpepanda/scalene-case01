package hpsa.web.controller;

import hpsa.persist.entity.Receipt;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ReceiptImgController {

	private static final Logger logger = LoggerFactory.getLogger(ReceiptImgController.class);

	@Transactional
	@RequestMapping("/receipt/img/{id}")
	public HttpEntity<byte[]> getReceiptImg(@PathVariable("id") Receipt receipt, HttpServletResponse response) {

		HttpEntity<byte[]> result = null;
		byte[] blob;

		if (receipt != null) {
			blob = receipt.getBinaryImage();
			if (blob != null) {
				HttpHeaders headers = new HttpHeaders();
				headers.setContentType(MediaType.IMAGE_JPEG);
				headers.setContentLength(blob.length);
				result = new HttpEntity<byte[]>(blob, headers);
			} else {
				logger.error("blob was empty");
			}
		}
		return result;

	}
}
