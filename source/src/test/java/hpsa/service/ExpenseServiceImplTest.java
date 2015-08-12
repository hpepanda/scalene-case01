package hpsa.service;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import hpsa.persist.entity.Expense;
import hpsa.web.init.WebAppConfig;

import javax.transaction.Transactional;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = WebAppConfig.class)
@WebAppConfiguration
public class ExpenseServiceImplTest {

	@Autowired
	private ExpenseService expenseService;

	@Test
	public void test() {

		Iterable<Expense> expenses = expenseService.findAll();
		assertNotNull(expenses);

	}

	@Test
	public void test_findByReport() {

		Iterable<Expense> expenses = expenseService.findUnsubmittedAndNotPersonal();
		assertNotNull(expenses);
		assertNull(expenses.iterator().next().getReportId());

	}

	@Test
	@Transactional
	public void test_findById() {

		Expense expense = expenseService.findById(261);
		assertNotNull(expense);
	}

}
