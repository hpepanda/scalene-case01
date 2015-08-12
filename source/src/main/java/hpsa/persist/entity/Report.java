package hpsa.persist.entity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.hibernate.Hibernate;

@Entity
@Table(name = "reports")
public class Report {

	@Id
	@GeneratedValue
	private Long          id;

	private String        name;

	private String        purpose;

	private String        approver;

	private String        cc;

	private Date          date;

	private Status        status;

	@OneToMany(cascade = CascadeType.ALL, mappedBy = "reportId", fetch = FetchType.LAZY)
	private List<Expense> expenses = new ArrayList<>();

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPurpose() {
		return purpose;
	}

	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	public String getApprover() {
		return approver;
	}

	public void setApprover(String approver) {
		this.approver = approver;
	}

	public String getCc() {
		return cc;
	}

	public void setCc(String cc) {
		this.cc = cc;
	}

	public List<Expense> getExpenses() {
		// TODO check for better solution
		if (!Hibernate.isInitialized(expenses)) {
			Hibernate.initialize(expenses);
		}
		return Collections.unmodifiableList(expenses);
	}

	public void addExpense(Expense expense) {
		if (this.expenses.contains(expense)) {
			return;
		}
		expense.setReportId(this.getId());
		this.expenses.add(expense);
	}

	public void addAllExpenses(List<Expense> expenses) {
		if (expenses == null) {
			return;
		}

		for (Expense expense : expenses) {
			addExpense(expense);
		}
	}

	public void removeExpense(Expense expense) {
		if (!this.expenses.contains(expense)) {
			return;
		}

		expense.setReportId(null);
		this.expenses.remove(expense);
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public enum Status {
		Pending, Approved;
	}
}
