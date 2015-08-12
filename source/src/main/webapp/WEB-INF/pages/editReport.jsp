<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
	<title>Scalene Expense Management</title>
</head>
<t:template>
<jsp:attribute name="menu">
<table>
	<tr>
		<td>
			New Report
		</td>
	</tr>
	<tr>
		<td>
			<a href="${pageContext.request.contextPath}/expenses">My Expenses</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="${pageContext.request.contextPath}/expenses/new">New Expense</a>
		</td>
	</tr>
	<tr>
		<td>
			<a href="${pageContext.request.contextPath}/report/viewAll">My Reports</a>
		</td>
	</tr>
</table>
</jsp:attribute>
<jsp:attribute name="main">
<div class="row">
	<div class="reports-container">
		<form action="#" id="reportData">
			<input type="hidden" id="reportId" name="id" value="${report.id}">
			<table id="report-header">
				<tr>
					<td class="label-row">
						Report Name
					</td>
					<td>
						<input type="text" id="reportName" name="name"
						value="${report.name}" required>
					</td>			
				</tr>		
				<tr>
					<td class="label-row">
						Purpose
					</td>
					<td>
						<textarea rows="6" id="purpose" name="purpose" required>${report.purpose}</textarea>
					</td>
				</tr>		
				<tr>
					<td class="label-row">
						Approver
					</td>
					<td>
						<input type="text" id="approver" name="approver"
						placeholder="David Bishop" value="${report.approver}">
					</td>
				</tr>
				<tr>
					<td class="label-row">
						CC:
					</td>
					<td>
						<input type="text" id="cc" name="cc" value="${report.cc}">
					</td>
				</tr>		
			</table>
			<input type="submit" id="hiddenReportSubmit" style="display:none">
		</form>
		<c:if test="${fn:length(expenses) > 0}">
			<form action="#" method="POST" enctype="multipart/form-data" id="formInline">
				<h2>Expenses on Report</h2>			
				<table class="expenses-report" id="expensesOnReport">
					<thead>
						<td id="date">Date</td>
						<td id="category">Category</td>
						<td id="vendor">Vendor</td>
						<td id="amount">Amount</td>
						<td id="currency"></td>
						<td id="receipt">Receipt</td>			
						<td id="action">Action</td>
					</thead>
					<tbody>		
						<c:forEach var="i" begin="0" end="${fn:length(expenses)-1}">	
							<tr>
								<input type="hidden" class="expenseId" value="${expenses[i].id}">
								<td class="inlineDate"><fmt:formatDate type="date" dateStyle="short" value="${expenses[i].date}"></fmt:formatDate></td>
								<td class="inlineCategory">${expenses[i].category.name}</td>
								<td class="inlineVendor">${expenses[i].vendor.name}</td>
								<td class="inlineAmount">${expenses[i].amount}</td>
								<td class="inlineCurrency">${expenses[i].currency.code}</td>
								<td class="inlineReceipt">
									<c:if test="${expenses[i].receipt!=null}">
									<a href="${pageContext.request.contextPath}/receipt/${expenses[i].id}">View</a>
									</c:if>
									<c:if test="${expenses[i].receipt==null}">
										No
									</c:if>
								</td>					
								<td>
									<button class="editInline">Edit</button>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</form>
		</c:if>
		<c:if test="${fn:length(expenses) == 0}">
			<span>No expenses on report yet</span>
		</c:if>
		<div id="total">
			<span>TOTAL: $</span><span id="total-value">${total}</span>
		</div>
		<div id="submitReport">
			<button id="submitReportButton">Submit Report</button>
		</div>

		<table class="expenses-report" style="display:none">
			<tr id="inlineTemplate">
				<td> 
					<input type="text" id="inlineDateInput" name="date" value="${now}"
					class="inlineDate">
					<input type="hidden" class="expenseId" name="id">
				</td>
				<td>
					<select class="inlineCategory" name="category.id">
						<c:forEach var="k" begin="0" end="${fn:length(categories)-1}">
							<option value="${categories[k].id}">${categories[k].name}</option>
						</c:forEach>	
					</select>
				</td>
				<td>
					<input type="text" value="Tidbits Inc." class="inlineVendor"
					name="vendor.name">
				</td>
				<td>
					<input type="text" value="$6.99" class="inlineAmount" name="amount">
				</td>
				<td>
					<select class="inlineCurrency" name="currency">
						<option value="USD">USD</option>
					</select>
				</td>
				<td><input type="file" name="file"></td>			
				<td>
					<input type="submit" value="Save Expense">
				</td>
			</tr>
		</table>
	</div>
</div>
<div class="row">
	<h2>Unsubmitted Expenses:</h2>
</div>

<div class="row">
	<div class="expenses-container">
		<c:if test="${fn:length(unsubmitted) > 0}">
			<form action="#" method="POST" enctype="multipart/form-data" id="formInlineReport">
				<table class="table-bordered table-hover expenses" id="unsubmittedExpenses">
					<thead>
						<tr>
							<td id="select"></td>
							<td id="date">Date</td>
							<td id="category">Category</td>
							<td id="vendor">Vendor</td>
							<td id="amount">Amount</td>
							<td id="currency">Currency</td>
							<td id="receipt">Receipt</td>
							<td id="personal">Personal?</td>
							<td id="action">Action</td>
						</tr>
					</thead>	
					<tbody>
						<c:forEach var="i" begin="0" end="${fn:length(unsubmitted)-1}">	
							<tr>
								<td class="checkboxInline">
									<div class="checkbox"><label><input type="checkbox" class="blankCheckbox"></label></div>
									<input type="hidden" class="expenseId" value="${unsubmitted[i].id}">
								</td>
								<td class="inlineDate"><fmt:formatDate type="date" dateStyle="short" value="${unsubmitted[i].date}" /></td>
								<td class="inlineCategory">${unsubmitted[i].category.name}</td>
								<td class="inlineVendor">${unsubmitted[i].vendor.name}</td>
								<td class="inlineAmount">${unsubmitted[i].amount}</td>
								<td class="inlineCurrency">${unsubmitted[i].currency.code}</td>
								<td class="inlineReceipt">
									<c:if test="${unsubmitted[i].receipt!=null}">
									<a href="${pageContext.request.contextPath}/receipt/${unsubmitted[i].id}">View</a>
									</c:if>
									<c:if test="${unsubmitted[i].receipt==null}">
										No
									</c:if>
								</td>
								<td class="inlinePersonal">
									<div class="checkbox">

										<c:if test="${unsubmitted[i].personal==true}">
										<label> <input type="checkbox" id="blankCheckbox"
											disabled checked></label>
										</c:if>
										<c:if test="${unsubmitted[i].personal==false||unsubmitted[i].personal==null}">
										<label> <input type="checkbox" id="blankCheckbox"
											disabled></label>
										</c:if>
									</div>
								</td>
								<td>
									<button class="editInlineReport">Edit</button>
								</td>
							</tr>
						</c:forEach>							
					</tbody>		
				</table>
			</form>
		</c:if>
		<c:if test="${fn:length(unsubmitted) == 0}">
			<span>No expenses to display</span>
		</c:if>
		<p>
			<div class="row" id="add-new-container">
				<button id="add-new">Add New Expense</button>
			</div>
		</p>
		<form id="addExpenses" action="#">
			<div class="row" id="add-selected-container">
				<input type="submit" id="add-selected" value="Add Selected to Report"
				disabled>
			</div>
		</form>
		<table style="display:none">
			<tr id="inlineTemplateReport" style="display:none">				
				<td class="checkboxInline">
					<div class="checkbox"><label><input type="checkbox" id="blankCheckbox"></label></div>
					<input type="hidden" class="expenseId" name="id">
				</td>
				<td > 
					<input type="text"  id="inlineDateInputReport" name="date" value="${now}" class="inlineDate">
				</td>
				<td >
					<select class="inlineCategory" name="category.id">
						<c:forEach var="k" begin="0" end="${fn:length(categories)-1}">
						<option value="${categories[k].id}">${categories[k].name}</option>
					</c:forEach>	
				</select>
			</td>
			<td >
				<input type="text" value="Tidbits Inc." class="inlineVendor" name="vendor.name">
			</td>
			<td>
				<input type="text" value="$6.99" class="inlineAmount" name="amount">
			</td>
			<td >
				<select class="inlineCurrency" name="currency">
							<option value="USD">USD</option>
				</select>
			</td>
			<td><input type="file" name="file"></td>
			<td>
				<div class="checkbox">					
					<label> <input type="checkbox" id="blankCheckbox" class="inlinePersonal" name="personal" disabled
						></label>
					</div>
				</td>
				<td>
					<input type="submit" value="Save Expense">
				</td>
				
			</tr>
		</table>
	</div>
</div>
</jsp:attribute>
<jsp:attribute name="script">
<script type="text/javascript">
	$(function() {
		initEditReportPage();
		$('.editInline').click(startEditInline);
		$('.editInlineReport').click(function(event){
			startEditInline(event,'#inlineTemplateReport',true);
		});
		$('#formInline').submit(endEditInline);
		$('#formInlineReport').submit(function(event){
			endEditInline(event,'#formInlineReport');
		});
		

		$('#submitReportButton').click(function(event){
			$('#hiddenReportSubmit').click();	
		});

		
	});
</script>
</jsp:attribute>
</t:template>

