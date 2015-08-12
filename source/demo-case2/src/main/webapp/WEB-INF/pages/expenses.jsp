<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
	<title>Scalene Expense Management</title>
</head>
<t:template>
<jsp:attribute name="menu">
<table>
	<tr>
		<td>
			<a href="${pageContext.request.contextPath}/report/new">New Report</a>
		</td>
	</tr>
	<tr>
		<td>
			My Expenses
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
	<h4>Filter:</h4>
</div>
<div class="row">
	<div id="filter">
		<div class="ui-widget" id="invalidStartDate" style="display:none">
						<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
							<p>
								<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
								<strong>Error:</strong> "From" date is invalid</p>
						</div>
		</div>	
		<div class="ui-widget" id="invalidEndDate" style="display:none">
						<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
							<p>
								<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
								<strong>Error:</strong> "To" date is invalid</p>
						</div>
		</div>
		<form id="filterBox" action="expenses">
		<table >
			<thead>
				<td>
					<p>Category</p>
				</td>

				<td>
					<p>From date:</p>
				</td>
				
				<td>
					<p>To Date</p>
				</td>
				<td></td>
			</thead>
			<tbody>
				<tr>
					<td>
						<select id="category" name="category">
							<option value=""></option>
							<c:forEach var="k" begin="0" end="${fn:length(categories)-1}">
							<option value="${categories[k].id}">${categories[k].name}</option>
						</c:forEach>							
					</select>
				</td>					
				<td class="hasDatepicker">
					<input type="text" id="startDate" name="start" value="${start}">
				</td>					
				<td class="hasDatepicker">
					<input type="text"  id="endDate" name="end" value="${end}">
				</td>					
				<td>
					<input type="submit" value="Filter">
				</td>
			</tr>
		</tbody>
	</table>	
	</form>
</div>
</div>
<div class="row">
	<h4>Unsubmitted Expenses:</h4>
</div>
<div class="row">
	<div class="expenses-container">
		<c:if test="${fn:length(expenses) > 0}">
		<form action="#" method="POST" enctype="multipart/form-data" id="formInline">
		<table class="table-bordered table-hover expenses" id="allExpenses">
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
				<c:forEach var="i" begin="0" end="${fn:length(expenses)-1}">
				<tr>
						<td class="checkboxInline">
							<c:if test="${expenses[i].personal==true}">
								<div class="checkbox"><label><input type="checkbox" class="blankCheckbox" disabled></label></div>
								<input type="hidden" class="expenseId" value="${expenses[i].id}">
							</c:if>	
							<c:if test="${expenses[i].personal==false||expenses[i].personal==null}">
								<div class="checkbox"><label><input type="checkbox" class="blankCheckbox"></label></div>
								<input type="hidden" class="expenseId" value="${expenses[i].id}">
							</c:if>
						</td>
						<td class="inlineDate"><fmt:formatDate type="date" dateStyle="short" value="${expenses[i].date}" /></td>
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
						<td class="inlinePersonal">
							<div class="checkbox">
								<c:if test="${expenses[i].personal==true}">
								<label> <input type="checkbox" id="blankCheckbox"
									disabled checked></label>
								</c:if>
								<c:if test="${expenses[i].personal==false||expenses[i].personal==null}">
								<label> <input type="checkbox" id="blankCheckbox"
									disabled></label>
								</c:if>
							</div>
						</td>
						<td>
							<button class="editInline">Edit</button>
						</td>
					</tr>
				</c:forEach>
			</tbody>						
		</table>	
		</form>	
		<table style="display:none">
			<tr id="inlineTemplate" style="display:none">				
				<td class="checkboxInline">
					<div class="checkbox"><label><input type="checkbox" id="blankCheckbox"></label></div>
					<input type="hidden" class="expenseId" name="id">
				</td>
				<td > 
					<input type="text"  id="inlineDateInput" name="date" value="${now}" class="inlineDate">
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
					<label> <input type="checkbox" id="blankCheckbox" class="inlinePersonal" name="personal" 
						></label>
					</div>
				</td>
				<td>
					<input type="submit" value="Save Expense">
				</td>
				
			</tr>
		</table>
		<c:forEach var="j" begin="1" end="${totalPages}">
			<c:if test="${current +1 == j}">
				${j}
			</c:if>
			<c:if test="${current +1 != j}">
				<a href="${pageContext.request.contextPath}/expenses?page=${j-1}&size=${perPage}&category=${category}&start=${start}&end=${end}">${j}</a>
			</c:if>
		</c:forEach>
		</c:if>
		<c:if test="${fn:length(expenses) == 0}">
			<span>No expenses to display</span>
		</c:if>
<div class="row" id="add-new-container">
	<form action="${pageContext.request.contextPath}/expenses/new">
			<input type="submit" id="add-new" value="Add New Expense">
	</form>
</div>
<div class="row" id="add-selected-container">
<button id="add-selected">Add Selected to New Report</button>
</div>
</div>
</div>
</jsp:attribute>
<jsp:attribute name="script">
<script type="text/javascript">
	$(function(){
		$( "#startDate" ).datepicker({
			showOn: "button",
			buttonImage: "${pageContext.request.contextPath}/css/img/calendar.gif",
			buttonImageOnly: true,
			buttonText: "Select date",
			constrainInput: true,
			yearRange: "2010:2020",
			defaultDate: new Date()
		});
		$( "#endDate" ).datepicker({
			showOn: "button",
			buttonImage: "${pageContext.request.contextPath}/css/img/calendar.gif",
			buttonImageOnly: true,
			buttonText: "Select date",
			constrainInput: true,
			yearRange: "2010:2020",
			defaultDate: new Date()
		});				
		$('#filterBox').submit(filterOnSubmit);
		$('#formInline').submit(endEditInline);
		$('#category').val("${category}");
		$('.editInline').click(startEditInline);
		$('#add-selected').click(addExpensesToNewReport);
		

	});
</script>
</jsp:attribute>
</t:template>