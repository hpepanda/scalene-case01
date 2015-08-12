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
			<a href="${pageContext.request.contextPath}/home">My Reports</a>
		</td>
	</tr>
</table>
</jsp:attribute>
<jsp:attribute name="main">
<div class="row">
	<div class="reports-container">
		<table id="report-header">
			<tr>
				<td class="label-row">
					Report Name
				</td>
				<td>
					<input type="text"  id="reportName" >
				</td>			
			</tr>		
			<tr>
				<td class="label-row">
					Purpose
				</td>
				<td>
					<textarea rows="6" id="purpose"></textarea>
				</td>
			</tr>		
			<tr>
				<td class="label-row">
					Approver
				</td>
				<td>
					<input type="text"  id="approver" placeholder="David Bishop" >
				</td>
			</tr>
			<tr>
				<td class="label-row">
					CC:
				</td>
				<td>
					<input type="text"  id="cc" >
				</td>
			</tr>		
		</table>

		<h2>Expenses on Report</h2>
		<table id="expenses-report">
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
				<tr>
					<td>04/01/2015</td>
					<td>Airfare</td>
					<td>Air Discover</td>
					<td>$670.15</td>
					<td>USD</td>
					<td>No</td>
					<td><a href="#">Edit</a></td>
				</tr>
				<tr>
					<td>04/14/2015</td>
					<td>Meal</td>
					<td>Coffee Hutt</td>
					<td>$12.40</td>
					<td>USD</td>
					<td>No</td>
					<td><a href="#">Edit</a></td>
				</tr>
				<tr>
					<td>05/14/2015</td>
					<td>Meal</td>
					<td>Restaurante</td>
					<td>$169.98</td>
					<td>USD</td>
					<td><a href="#">View</a></td>
					<td><a href="#">Edit</a></td>
				</tr>
			</tbody>
		</table>
		<div id="total">
			<span>TOTAL:         $ 747.55</span>
		</div>
		<div id="submitReport">
			<button>Submit Report</button>
		</div>
	</div>
</div>
<div class="row">
	<h2>Unsubmitted Expenses:</h2>
</div>

<div class="row">
	<div class="expenses-container">
		<table class="table-bordered table-hover expenses">
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
					<td id="action">Action?</td>
				</tr>
			</thead>	
			<tbody>
				<tr>
					<td><label> <input type="checkbox" id="blankCheckbox" disabled></label></td>
					<td><fmt:formatDate type="date" dateStyle="short" value="${now}" /></td>
					<td>
						<select>
							<c:forEach var="k" begin="0" end="${fn:length(categories)-1}">
							<option value="${categories[k].id}">${categories[k].name}</option>
						</c:forEach>	
					</select>
				</td>
				<td>
					<input type="text" value="Tidbits Inc.">
				</td>
				<td>
					<input type="text" value="$6.99">
				</td>
				<td>
					<input type="text" value="USD">
				</td>
				<td><a href="#">Required (upload)</a></td>
				<td>
					<div class="checkbox">					
						<label> <input type="checkbox" id="blankCheckbox"
							></label>
						</div>
					</td>
					<td>
						<button>Save Expense</button>
					</td>
				</tr>
			</tbody>		
		</table>
		<p>
		<div class="row" id="add-new-container">
			<button id="add-new">Add New Expense</button>
		</div>
		<div class="row" id="add-selected-container">
			<button id="add-selected">Add Selected to New Report</button>
		</div>
	</div>





</jsp:attribute>
</t:template>