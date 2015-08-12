package hpsa.service;

import hpsa.persist.entity.Report;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ReportService {

	public Iterable<Report> findAll();

	public Page<Report> findAll(Pageable page);

	public Report findById(long id);

	public Report save(Report report);

	public Double getTotal(Report report);
}
