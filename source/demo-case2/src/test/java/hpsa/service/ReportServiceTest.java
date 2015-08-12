package hpsa.service;

import static org.junit.Assert.assertFalse;
import hpsa.persist.entity.Expense;
import hpsa.persist.entity.Report;
import hpsa.persist.entity.Report.Status;
import hpsa.web.init.WebAppConfig;

import java.util.Date;

import javax.transaction.Transactional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = WebAppConfig.class)
@WebAppConfiguration
@TransactionConfiguration
public class ReportServiceTest {

	@Autowired
	private ReportService  service;

	@Autowired
	private ExpenseService expenseService;

	@Test
	@Transactional
	@Rollback(false)
	public void test() {

		Page<Expense> expenses = expenseService.findAll(new PageRequest(0, 5));
		Report report = new Report();
		report.setName("test");
		report.setPurpose("4TEST");
		report.setApprover("name");
		report.setCc("other guy");
		report.addAllExpenses(expenses.getContent());
		report.setStatus(Status.Approved);
		report.setDate(new Date());
		report = service.save(report);

	}

	@Test
	@Transactional
	public void test_find() {
		Page<Report> reports = service.findAll(new PageRequest(0, 5));
		assertFalse(reports.getContent().isEmpty());

	}

}
