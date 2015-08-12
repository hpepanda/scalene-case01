package hpsa.web.controller;

import hpsa.persist.entity.Expense;
import hpsa.persist.entity.Report;
import hpsa.service.CategoryService;
import hpsa.service.ExpenseService;
import hpsa.service.ReportService;

import java.util.ArrayList;
import java.util.List;

import javax.transaction.Transactional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping(value = "/report")
public class ReportsController extends GenericController {

	private static final Logger logger = LoggerFactory.getLogger(ReportsController.class);

	@Autowired
	private ReportService       reportService;

	@Autowired
	private CategoryService     categoryService;

	@Autowired
	private ExpenseService      expenseService;

	@Transactional
	@RequestMapping(value = "/viewAll")
	public ModelAndView getHomePage(Pageable pageable) {
		ModelAndView view = getBasicPage();
		view.setViewName("reports");

		Iterable<Report> reports = reportService.findAll();

		view.addObject("reports", reports);

		return view;
	}

	@Transactional
	@RequestMapping(value = "/submit", method = RequestMethod.POST)
	@ResponseBody
	public Report submitReport(Report report,
	        @RequestParam(value = "expenseIds", required = false) ArrayList<Long> expenseIds) {
		try {
			if (expenseIds != null && !expenseIds.isEmpty()) {
				report = reportService.save(report);
				List<Expense> expenses = expenseService.findByIds(expenseIds);
				report.addAllExpenses(expenses);
			}
			return reportService.save(report);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			return null;
		}

	}

	@RequestMapping(value = "/{id}/edit")
	@Transactional
	public ModelAndView editReport(@PathVariable("id") Long id) {
		Report report = reportService.findById(id);
		ModelAndView mav = getBasicPage();
		mav.setViewName("editReport");

		mav.addObject("categories", categoryService.findAll());
		mav.addObject("report", report);
		mav.addObject("expenses", report.getExpenses());
		mav.addObject("total", reportService.getTotal(report));
		mav.addObject("unsubmitted", expenseService.findUnsubmittedAndNotPersonal());
		return mav;
	}

	@RequestMapping(value = "/{id}/view")
	@Transactional
	public ModelAndView viewReport(@PathVariable("id") Long id) {
		Report report = reportService.findById(id);
		ModelAndView mav = getBasicPage();
		mav.setViewName("viewReport");
		mav.addObject("categories", categoryService.findAll());
		mav.addObject("report", report);
		mav.addObject("expenses", report.getExpenses());
		mav.addObject("total", reportService.getTotal(report));
		return mav;
	}

	@RequestMapping(value = "/new")
	@Transactional
	public ModelAndView newReport(@RequestParam(value = "expenseIds", required = false) ArrayList<Long> expenseIds) {
		ModelAndView mav = getBasicPage();

		List<Expense> unsubmittedExpenses = expenseService.findUnsubmittedAndNotPersonal();
		if (expenseIds != null && !expenseIds.isEmpty()) {
			List<Expense> expensesToAdd = expenseService.findByIds(expenseIds);
			unsubmittedExpenses.removeAll(expensesToAdd);
			mav.addObject("expenses", expensesToAdd);
		}

		mav.setViewName("editReport");
		mav.addObject("categories", categoryService.findAll());
		mav.addObject("unsubmitted", unsubmittedExpenses);
		return mav;
	}
}
