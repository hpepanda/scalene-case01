package hpsa.web.controller;

import hpsa.persist.entity.Category;
import hpsa.persist.entity.Expense;
import hpsa.persist.entity.Receipt;
import hpsa.persist.entity.Report;
import hpsa.persist.entity.Vendor;
import hpsa.service.CategoryService;
import hpsa.service.CurrencyService;
import hpsa.service.ExpenseService;
import hpsa.service.ReceiptService;
import hpsa.service.ReportService;
import hpsa.service.VendorService;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.common.base.Strings;

@Controller
public class ExpenseController extends GenericController {

	private static final Logger logger = LoggerFactory
			.getLogger(ExpenseController.class);

	private static final int ITEM_PER_PAGE = 10;

	@Autowired
	private ReportService reportService;

	@Autowired
	private ExpenseService expenseService;

	@Autowired
	private CategoryService categoryService;

	@Autowired
	private ReceiptService receiptServive;

	@Autowired
	private VendorService vendorService;

	@Autowired
	private CurrencyService currencyService;

	private SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");

	@RequestMapping(value = "/expenses")
	public ModelAndView getNextPage(Pageable pageable, Category category,
			String start, String end) throws ParseException {
		Date startDate = null;
		Date endDate = null;
		if (!Strings.isNullOrEmpty(start)) {
			startDate = format.parse(start);
		}
		if (!Strings.isNullOrEmpty(end)) {
			endDate = format.parse(end);
		}

		Page<Expense> findAll = expenseService.filter(category, startDate,
				endDate, new PageRequest(pageable.getPageNumber(),
						ITEM_PER_PAGE));

		int totalPages = findAll.getTotalPages();
		int current = findAll.getNumber();

		if (current != 0 && current >= totalPages) {
			findAll = expenseService.filter(category, startDate, endDate,
					new PageRequest(pageable.getPageNumber(), ITEM_PER_PAGE));
			totalPages = findAll.getTotalPages();
			current = findAll.getNumber();
		}
		List<Expense> expenses = findAll.getContent();

		ModelAndView mav = getBasicPage();
		mav.setViewName("expenses");
		mav.addObject("current", current);
		mav.addObject("totalPages", totalPages);
		mav.addObject("perPage", ITEM_PER_PAGE);
		mav.addObject("expenses", expenses);
		mav.addObject("now", format.format(new Date()));
		mav.addObject("categories", categoryService.findAll());
		// filter
		mav.addObject("category", category.getId());
		mav.addObject("start", start);
		mav.addObject("end", end);

		return mav;
	}

	@RequestMapping(value = "/expenses/new")
	@Transactional
	public ModelAndView getNewExpensePage(HttpServletRequest request) {
		ModelAndView mav = getBasicPage();
		mav.setViewName("newExpense");
		String referrer = request.getHeader("referer");
		mav.addObject("previous", referrer);
		mav.addObject("categories", categoryService.findAll());
		return mav;
	}

	@RequestMapping(value = "/expenses/submit", method = RequestMethod.POST)
	@Transactional
	public ModelAndView submitExpense(Expense expense,
			@RequestParam("file") MultipartFile file, String page)
			throws Exception {
		if (!file.isEmpty()) {
			try {
				Receipt receipt = receiptServive.createReceipt(file.getBytes(),
						file.getOriginalFilename(), file.getContentType());
				if (receipt == null) {
					throw new Exception(
							"unable to save receipt, image upload failed");
				}
				receipt = receiptServive.save(receipt);
				expense.setReceipt(receipt);
			} catch (IOException e) {
				logger.error(e.toString(), e);
			}
		}
		expense.setCategory(categoryService.find(expense.getCategory()));
		expense.setCurrency(currencyService.find(expense.getCurrency()));
		Vendor vendor = vendorService.find(expense.getVendor());
		if (vendor != null) {
			expense.setVendor(vendor);
		}
		expenseService.save(expense);
		ModelAndView mav = getBasicPage();
		mav.setViewName("redirect:" + page);
		return mav;
	}

	@RequestMapping(value = "/expenses/update", method = RequestMethod.POST)
	@ResponseBody
	@Transactional
	public Expense updateExpense(Expense expense,
			@RequestParam(value = "file", required = false) MultipartFile file,
			String page) throws Exception {
		Expense toUpdate = expenseService.findById(expense.getId());
		if (file != null && !file.isEmpty()) {
			try {
				Receipt receipt = toUpdate.getReceipt();
				if (receipt != null) {
					receipt = receiptServive.updateReceipt(file.getBytes(),
							file.getOriginalFilename(), file.getContentType(),
							receipt);
				} else {
					receipt = receiptServive.createReceipt(file.getBytes(),
							file.getOriginalFilename(), file.getContentType());
				}

				toUpdate.setReceipt(receipt);
				if (receipt == null) {
					throw new Exception(
							"unable to save receipt, image upload failed");
				}
			} catch (IOException e) {
				logger.error(e.toString(), e);
			}
		}
		toUpdate.setAmount(expense.getAmount());
		toUpdate.setCategory(categoryService.find(expense.getCategory()));
		toUpdate.setCurrency(currencyService.find(expense.getCurrency()));
		Vendor vendor = vendorService.find(expense.getVendor());
		if (vendor != null) {
			toUpdate.setVendor(vendor);
		} else {
			toUpdate.setVendor(expense.getVendor());
		}

		toUpdate.setDate(expense.getDate());
		toUpdate.setPersonal(expense.getPersonal());
		return expenseService.save(toUpdate);
	}

	@RequestMapping(value = "/expenses/unsubmitted", method = RequestMethod.POST)
	@Transactional
	@ResponseBody
	public List<Expense> getUnsubmitted(Pageable page) {
		// TODO code duplication
		Page<Expense> findAll = expenseService.findUnsubmitted(new PageRequest(
				page.getPageNumber(), ITEM_PER_PAGE));
		int totalPages = findAll.getTotalPages();
		int current = findAll.getNumber();

		if (current >= totalPages) {
			findAll = expenseService.findAll(new PageRequest(totalPages - 1,
					ITEM_PER_PAGE));
			totalPages = findAll.getTotalPages();
			current = findAll.getNumber();
		}
		return findAll.getContent();
	}

	@RequestMapping(value = "/expenses/addToReport/{id}", method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
	@Transactional
	@ResponseBody
	public void addExpensesToReport(@PathVariable Long id,
			@RequestBody ArrayList<Long> expenseIds) {
		Report report = reportService.findById(id);
		List<Expense> expenses = expenseService.findByIds(expenseIds);
		report.addAllExpenses(expenses);
		reportService.save(report);
	}

	@ExceptionHandler
	public ModelAndView handle(Exception e) {
		logger.error("exception occured", e);
		ModelAndView mav = new ModelAndView();
		mav.setViewName("error");
		mav.addObject("errorText", "error occured: " + e.toString());
		return mav;
	}
}
