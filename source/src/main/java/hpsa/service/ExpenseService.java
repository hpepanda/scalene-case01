package hpsa.service;

import hpsa.persist.entity.Category;
import hpsa.persist.entity.Expense;

import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ExpenseService {

	public Iterable<Expense> findAll();

	public Page<Expense> findAll(Pageable page);

	public Page<Expense> findUnsubmitted(Pageable page);

	public List<Expense> findUnsubmitted();

	public List<Expense> findUnsubmittedAndNotPersonal();

	public Expense findById(long id);

	public List<Expense> findByIds(Collection<Long> ids);

	public Expense save(Expense expense);

	public Page<Expense> filter(Category category, Date start, Date end, Pageable page);

}
