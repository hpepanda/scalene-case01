package hpsa.web.controller;

import hpsa.persist.entity.Expense;
import hpsa.persist.entity.Receipt;
import hpsa.service.ExpenseService;
import hpsa.service.ReceiptService;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value = "/receipt")
public class ReceiptController extends GenericController {

	@Autowired
	private ExpenseService      expenseService;

	@Autowired
	private ReceiptService      receiptServive;

	private static final Logger logger = LoggerFactory.getLogger(ReceiptController.class);

	@RequestMapping(value = "/{id}")
	public ModelAndView getReceiptDetails(@PathVariable("id") Expense expense, HttpServletRequest request) {
		ModelAndView mav = getBasicPage();
		if (expense != null) {
			mav.setViewName("receipt");
			mav.addObject("expense", expense);
			mav.addObject("id", expense.getReceipt().getId());
			mav.addObject("timestamp", expense.getReceipt().getTimeStamp());
			String url = receiptServive.getImageUrl(expense.getReceipt(), request.getContextPath());
			mav.addObject("url", url);
		} else {
			mav.setViewName("error");
			mav.addObject("errorText", "receipt not found");
		}
		return mav;
	}

	@Transactional
	@RequestMapping(value = "/{id}/update", method = RequestMethod.POST)
	public ModelAndView updateReceipt(@PathVariable("id") Expense expense, @RequestParam("file") MultipartFile file,
	        HttpServletRequest request) throws Exception {
		ModelAndView mav = getBasicPage();
		if (expense != null) {
			if (!file.isEmpty()) {
				try {
					Receipt receipt;
					receipt = receiptServive.updateReceipt(file.getBytes(), file.getOriginalFilename(),
					        file.getContentType(), expense.getReceipt());

					expense.setReceipt(receipt);
					expense = expenseService.save(expense);
					if (receipt == null) {
						throw new Exception("unable to save receipt, image upload failed");
					}
				} catch (IOException e) {
					logger.error(e.toString(), e);
				}
			}

			mav.setViewName("receipt");
			mav.addObject("expense", expense);
			mav.addObject("id", expense.getReceipt().getId());
			mav.addObject("timestamp", expense.getReceipt().getTimeStamp());
			String url = receiptServive.getImageUrl(expense.getReceipt(), request.getContextPath());
			mav.addObject("url", url);
		}
		return mav;
	}
}
