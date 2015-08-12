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
			<a href="${pageContext.request.contextPath}/expenses">My Expenses</a>
		</td>
	</tr>
	<tr>
		<td>
			New Expense
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
		<form action="${pageContext.request.contextPath}/expenses/submit" method="POST" id="newExpense" enctype="multipart/form-data">
			<input type="hidden" value="${previous}" name="page">
			<table id="report-header">
				<tr>
					<td class="label-row">
						Date
					</td>
					<td colspan="3" class="hasDatepicker">
						<input type="text"  id="expense-date" name="date" required >
					</td>
				</tr>		
				<tr>
					<td class="label-row">
						Category
					</td>
					<td colspan="3">
						<select id="expense-category" name="category">
							<c:forEach var="k" begin="0" end="${fn:length(categories)-1}">
							<option value="${categories[k].id}">${categories[k].name}</option>
						</c:forEach>
					</td>
				</tr>		
				<tr>
					<td class="label-row">
						Vendor
					</td>
					<td colspan="3">
						<input type="text"  id="expense-vendor" name="vendor.name" required>
					</td>
				</tr>
				<tr>
					<td class="label-row">
						Amount
					</td>
					<td>
						<input type="text"  id="expense-amount" name="amount" required>
					</td>
					<td>
						Currency
					</td>
					<td>
						<select id="expense-currency" name="currency">
							<option value="USD">USD</option>
						</select>
					</td>									
				</tr>
				<tr>
					<td class="label-row">
						Personal
					</td>
					<td>
						<select id="personal" name="personal">
							<option value="false">No</option>
							<option value="true">Yes</option>							
						</select>
					</td>	
				</tr>
				<tr>
					<td></td>
					<td colspan="2"><input type="file" name="file" required></td>
					<td id="save-section"><input type="submit" id="save" value="Save & Return"></td>
				</tr>
				<tr>
					<div class="ui-widget" id="invalidDate" style="display:none">
						<div class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
							<p>
								<span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
								<strong>Error:</strong> Date is invalid</p>
							</div>
						</div>
					</tr>		
				</table>
			</form>

		</div>
	</div>

</jsp:attribute>
<jsp:attribute name="script">
<script type="text/javascript">
	$(function(){
		$( "#expense-date" ).datepicker({
			showOn: "button",
			buttonImage: "${pageContext.request.contextPath}/css/img/calendar.gif",
			buttonImageOnly: true,
			buttonText: "Select date",
			constrainInput: true,
			yearRange: "2010:2020",
			defaultDate: new Date()
		});
		initNewExpensePage();

	});
</script>
</jsp:attribute>
</t:template>