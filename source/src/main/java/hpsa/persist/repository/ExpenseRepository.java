package hpsa.persist.repository;

import hpsa.persist.entity.Expense;

import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;

public interface ExpenseRepository extends PagingAndSortingRepository<Expense, Long> {

	public Page<Expense> findByReportId(Long id, Pageable page);

	public List<Expense> findByReportId(Long id);

	public List<Expense> findByIdIn(Collection<Long> ids);

	public List<Expense> findByReportIdIsNullAndPersonalFalse();

	public Page<Expense> findByCategoryIdAndReportIdIsNull(Long categoryId, Pageable page);

	public Page<Expense> findByDateBetweenAndReportIdIsNull(Date start, Date end, Pageable page);

	public Page<Expense> findByCategoryIdAndDateBetweenAndReportIdIsNull(Long categoryId, Date start, Date end, Pageable page);

}
