<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Scalene Expense Management</title>


	<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
	<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/bootstrap-theme.min.css" />
	<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/hpsa.css" />
</head>
<body>
	<div class="container-fluid" id="receipt">
		<div class="row">			
			<h3>Upload Receipt(s) for Expense #: ${expense.id}</h3>			
		</div>
		<div class="row" id="statistics">
			<p>
				response received in <span id="generated"></span>ms
			</p>
			<p>from ${ip}</p>
		</div>
		<div class="row" id="main">

			<table class="table-bordered" id="receipt-header">
				<tr>
					<td>
						<fmt:formatDate type="date" dateStyle="short" value="${expense.date}" />
					</td>
					<td>
						${expense.category.name}
					</td>
					<td>
						${expense.vendor.name}
					</td>
					<td>
						${expense.amount}
					</td>
					<td>
						${expense.currency.code}
					</td>				
				</tr>
			</table>
		</div>
		<p></p>
		<div class="row" id="main">
			<table class="table-bordered" id="receipt-main">
				<thead>
					<td>
						Date Loaded
					</td>
					<td>
						Image
					</td>
				</thead>
				<tbody>
					<tr>
						<td>
							<table class="table-bordered">
								<tr>
									<td>
										<a href="#"><fmt:formatDate type="both" dateStyle="short" timeStyle="short" value="${timestamp}" /></a>
									</td>									
								</tr>
								<tr>
									<td>
										<form action="${pageContext.request.contextPath}/receipt/${expense.id}/update" method="POST" id="newExpense" enctype="multipart/form-data">
											<input type="file" name="file" required>	
											<input type="submit" value="Update">
										</form>
									</td>
								</tr>
							</table>
						</td>
						<td>
							<img src="${url}"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		
		<hr>
		
	</div>
	<script
	src="${pageContext.request.contextPath}/js/jquery-2.1.4.min.js"></script>
	<script type="text/javascript">
		$(function() {
			$('#generated').text(
				window.performance.timing.responseStart
				- window.performance.timing.requestStart)
		});
	</script>
</body>
</html>