package hpsa.service;

import hpsa.persist.entity.Category;
import hpsa.persist.entity.Currency;
import hpsa.persist.entity.Expense;
import hpsa.persist.entity.Receipt;
import hpsa.persist.entity.Vendor;
import hpsa.web.init.WebAppConfig;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.transaction.Transactional;

import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import com.google.common.collect.Lists;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = WebAppConfig.class)
@WebAppConfiguration
public class DataSetup {

	@Autowired
	private ExpenseService        expenseService;

	@Autowired
	private ReceiptService        receiptService;

	@Autowired
	private CategoryService       categoryService;

	@Autowired
	private CurrencyService       currencyService;

	@Autowired
	private VendorService         vendorService;

	private final static String[] filenames = { "1.jpg", "2.jpg", "3.jpg", "4.jpg", "5.jpg", "6.png", "7.jpg", "8.jpg" };

	// remove to populate db with data
	@Ignore
	@Test
	@Transactional
	@Rollback(false)
	public void setUp() throws IOException {
		Random random = new Random(new Date().getTime());
		List<Category> categories = Lists.newArrayList(categoryService.findAll());
		int categoriesAmount = categories.size();
		List<Currency> currencies = Lists.newArrayList(currencyService.findAll());
		List<Vendor> vendors = Lists.newArrayList(vendorService.findAll());

		Map<String, byte[]> map = new HashMap<String, byte[]>();
		for (String name : filenames) {
			Path path = Paths.get("receipts/" + name);
			map.put(name, Files.readAllBytes(path));
		}

		Expense toAdd;
		for (int i = 0; i < 50; ++i) {
			toAdd = new Expense();
			toAdd.setAmount(random.nextInt(1000) + random.nextInt(100) / 100.);
			toAdd.setCategory(categories.get(random.nextInt(categoriesAmount)));
			toAdd.setCurrency(currencies.get(0));
			toAdd.setDate(getRandomDate(random));
			toAdd.setPersonal(random.nextBoolean());

			int receiptNumber = random.nextInt(8);
			Receipt receipt = receiptService.createReceipt(map.get(filenames[receiptNumber]), filenames[receiptNumber],
			        null);
			receipt.setBinaryImage(map.get(filenames[receiptNumber]));
			receipt.setUrl("https://dl.dropboxusercontent.com/u/31179352/restaurant-receipt-with-logo.jpg");
			receipt = receiptService.save(receipt);

			toAdd.setReceipt(receipt);
			toAdd.setVendor(vendors.get(random.nextInt(vendors.size())));

			expenseService.save(toAdd);
		}
	}

	private Date getRandomDate(Random r) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(2014, r.nextInt(12), r.nextInt(28), r.nextInt(24), r.nextInt(60));
		return calendar.getTime();
	}

}
