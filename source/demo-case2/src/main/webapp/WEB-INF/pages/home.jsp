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
			My Reports
		</td>
	</tr>
</table>
</jsp:attribute>
<jsp:attribute name="main">
<div class="row">
	<H4>Reports:</H4>
</div>
<div class="row">
	<c:if test="${fn:length(reports) > 0}">
	<table>
		<thead>
			<td>
				Date
			</td>
			<td>
				Report Name
			</td>
			<td>
				Status
			</td>
			<td>
				Action
			</td>
			<td>
			</td>
		</thead>
		<tbody>
			
			<c:forEach var="i" begin="0" end="${fn:length(reports)-1}">
			<tr>
				<td>
					${reports[i].date}
				</td>
				<td>
					${reports[i].name}
				</td>
				<td>
					${reports[i].status}
				</td>
				<td>
					<a href="${pageContext.request.contextPath}/report/${reports[i].id}/edit">View / Edit</a>
				</td>
				<td>
				</td>
			</tr>
			</c:forEach>	
			
		</tbody>
	</table>
	</c:if>
	<c:if test="${fn:length(reports) == 0}">
	<span>No reports available</span>
	</c:if>
</div>
</jsp:attribute>
</t:template>