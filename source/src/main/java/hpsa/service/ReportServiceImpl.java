package hpsa.service;

import hpsa.persist.entity.Expense;
import hpsa.persist.entity.Report;
import hpsa.persist.entity.Report.Status;
import hpsa.persist.repository.ReportRepository;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.google.common.base.Strings;

@Service
public class ReportServiceImpl implements ReportService {

	@Autowired
	private ReportRepository reportRepository;

	@Override
	public Iterable<Report> findAll() {
		return reportRepository.findAll();
	}

	@Override
	public Page<Report> findAll(Pageable page) {
		return reportRepository.findAll(page);
	}

	@Override
	public Report findById(long id) {
		return reportRepository.findOne(id);
	}

	@Override
	public Report save(Report report) {
		if (!Strings.isNullOrEmpty(report.getApprover())) {
			report.setStatus(Status.Approved);
		} else {
			report.setStatus(Status.Pending);
		}
		report.setDate(new Date());
		return reportRepository.save(report);
	}

	@Override
	public Double getTotal(Report report) {
		Double total = 0.;
		for (Expense e : report.getExpenses()) {
			total += e.getAmount();
		}
		total = Math.round(total * 100) / 100.;
		return total;
	}

}
