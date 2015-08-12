package hpsa.service;

import hpsa.persist.entity.Category;
import hpsa.persist.entity.Expense;
import hpsa.persist.repository.ExpenseRepository;

import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class ExpenseServiceImpl implements ExpenseService {

	@Autowired
	private ExpenseRepository expenseRepository;

	@Override
	public Iterable<Expense> findAll() {
		return expenseRepository.findAll();
	}

	@Override
	public Expense findById(long id) {
		return expenseRepository.findOne(id);
	}

	@Override
	public Page<Expense> findAll(Pageable pageable) {
		return expenseRepository.findAll(pageable);
	}

	@Override
	public Expense save(Expense expense) {
		return expenseRepository.save(expense);

	}

	@Override
	public Page<Expense> findUnsubmitted(Pageable page) {
		return expenseRepository.findByReportId(null, page);
	}

	@Override
	public List<Expense> findByIds(Collection<Long> ids) {
		return expenseRepository.findByIdIn(ids);
	}

	@Override
	public List<Expense> findUnsubmitted() {
		return expenseRepository.findByReportId(null);
	}

	@Override
	public List<Expense> findUnsubmittedAndNotPersonal() {
		return expenseRepository.findByReportIdIsNullAndPersonalFalse();
	}

	@Override
	public Page<Expense> filter(Category category, Date start, Date end, Pageable page) {
		if (start == null && end == null && category.getId() == null) {
			return findUnsubmitted(page);
		} else if (start == null && end == null && category.getId() != null) {
			return expenseRepository.findByCategoryIdAndReportIdIsNull(category.getId(), page);
		} else {
			if (start == null) {
				Calendar calendar = Calendar.getInstance();
				calendar.set(1970, 0, 0);
				start = calendar.getTime();
			}
			if (end == null) {
				end = new Date();
			}

			if (category.getId() != null) {
				return expenseRepository.findByCategoryIdAndDateBetweenAndReportIdIsNull(category.getId(), start, end, page);
			} else {
				return expenseRepository.findByDateBetweenAndReportIdIsNull(start, end, page);
			}
		}
	}
}
