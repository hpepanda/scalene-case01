<%@tag description="Page template" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@attribute name="main" fragment="true"%>
<%@attribute name="menu" fragment="true"%>
<%@attribute name="script" fragment="true"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/bootstrap-theme.min.css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/hpsa.css" />
<link href="${pageContext.request.contextPath}/css/jquery-ui.css" rel="stylesheet">
</head>
<body>
	<div class="container-fluid">
		<div class="row">
			<div class="col-xs-6" id="heading">
				<h3>Scalene Expense Management</h3>
				<p>
					response received in <span id="generated"></span>ms
				</p>
				<p>from ${ip}</p>
			</div>
			<div class="col-xs-6" id="login-form">
				<table>
					<tr>
						<td rowspan="2"><img alt="user" src="${pageContext.request.contextPath}/css/img/user.png"></td>
						<td>Logged in as: <input type="button" value="Log Out" />
						</td>
					</tr>
					<tr>
						<td><input type="text" value="John Smith" /></td>
					</tr>
				</table>
			</div>


		</div>
		<div class="row">
			<div class="col-xs-2" id="menu">
				<jsp:invoke fragment="menu"></jsp:invoke>
			</div>
			<div class="col-xs-10" id="main">
				<jsp:invoke fragment="main"></jsp:invoke>
			</div>
		</div>
		<div class="row">
			<hr>
		</div>
	</div>
	<script src="${pageContext.request.contextPath}/js/jquery-2.1.4.min.js"></script>
	<script src="${pageContext.request.contextPath}/js/core.js"></script>
	<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
	<script type="text/javascript">
		$(function() {
			$('#generated').text(
					window.performance.timing.responseStart
							- window.performance.timing.requestStart)
		});
	</script>
	<jsp:invoke fragment="script"></jsp:invoke>

</body>
</html>