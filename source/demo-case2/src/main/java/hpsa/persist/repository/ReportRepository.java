package hpsa.persist.repository;

import hpsa.persist.entity.Report;
import hpsa.persist.entity.Report.Status;

import java.util.List;

import org.springframework.data.repository.PagingAndSortingRepository;

public interface ReportRepository extends PagingAndSortingRepository<Report, Long> {

	List<Report> findByStatusIn(List<Status> statuses);

}
