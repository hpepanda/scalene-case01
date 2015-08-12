package hpsa.service;

import static org.junit.Assert.assertNotNull;
import hpsa.persist.entity.Receipt;
import hpsa.web.init.WebAppConfig;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = WebAppConfig.class)
@WebAppConfiguration
public class ReceiptServiceImplTest {

	@Autowired
	private ReceiptService receiptService;

	@Test
	public void test() {

		Receipt result = receiptService.findById(341);

		assertNotNull(result);
	}

}
