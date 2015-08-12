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
	<div class="reports-container reports-container-view">		
		<input type="hidden" id="reportId" name="id" value="${report.id}">
		<table id="report-header">
			<tr>
				<td class="label-row">
					Report Date
				</td>
				<td class="bold">
					${report.date}
				</td>			
			</tr>	
			<tr>
				<td class="label-row">
					Report Name
				</td>
				<td class="bold">
					${report.name}
				</td>			
			</tr>		
			<tr>
				<td class="label-row">
					Purpose
				</td>
				<td>
					<textarea rows="6" id="purpose" name="purpose" class="view" disabled>${report.purpose}</textarea>
				</td>
			</tr>		
			<tr>
				<td class="label-row">
					Approver
				</td>
				<td class="bold">
					${report.approver}
				</td>
			</tr>
			<tr>
				<td class="label-row">
					CC:
				</td>
				<td class="bold">
					${report.cc}
				</td>
			</tr>		
		</table>
		
		<div class="spacer"></div>
		<h2>Submitted Expenses</h2>
		<c:if test="${fn:length(expenses) > 0}">
		<table id="expenses-report">
			<thead>
				<td id="date">Date</td>
				<td id="category">Category</td>
				<td id="vendor">Vendor</td>
				<td id="amount">Amount</td>
				<td id="currency"></td>
				<td id="receipt">Receipt</td>							
			</thead>
			<tbody>		
				<c:forEach var="i" begin="0" end="${fn:length(report.expenses)-1}">	
				<tr>
					<td><fmt:formatDate type="date" dateStyle="short" value="${expenses[i].date}" /></td>
					<td>${expenses[i].category.name}</td>
					<td>${expenses[i].vendor.name}</td>
					<td>${expenses[i].amount}</td>
					<td>${expenses[i].currency.code}</td>
					<td>
						<c:if test="${expenses[i].receipt!=null}">
						<a href="/receipt/${expenses[i].id}">View</a>
						</c:if>
						<c:if test="${expenses[i].receipt==null}">
							No
						</c:if>
					</td>								
				</tr>
				</c:forEach>										
			</tbody>
		</table>
		</c:if>
		<c:if test="${fn:length(expenses) == 0}">
			<span>No expenses on report yet</span>
		</c:if>
		<div id="total">
			<span>TOTAL: $</span><span id="total-value">${total}</span>
		</div>
		<div id="submitReport">
			<form action="${pageContext.request.contextPath}/report/viewAll"><input type="submit" value="Back to Home"></form>
		</div>		
	</div>
</div>
</jsp:attribute>
<jsp:attribute name="script">
<script type="text/javascript">
	$(function(){
		initEditReportPage();
	});
</script>
</jsp:attribute>
</t:template>

