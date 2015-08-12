function initEditReportPage (){
	$('#reportData').submit(reportOnSubmit);
	$('#addExpenses').submit(addExpensesOnSubmit);
	$('#add-new').click(addNewExpense);

	$.each($('.blankCheckbox'),function(index,value){
		$(value).change(function(event){
			var enable = false;
			$('#unsubmittedExpenses tbody tr').each(function(index, value){
				if($(value).find('.blankCheckbox')[0].checked){
					enable = true;
				}
			});
			if(enable){
				$('#addExpenses :submit').removeAttr('disabled');
			}else{
				$('#addExpenses :submit').attr('disabled','disabled');
			}
		});
	});
	
	
}

function addNewExpense(){
//	$.post( "/expenses/report/submit",$('#reportData').serialize()).done(function(){
	window.location.href = '/expenses/expenses/new';
//	});
}

function initNewExpensePage(){
	$('#newExpense').submit(expenseOnSubmit);
}

function expenseOnSubmit(event){
	if(!validateDate($('#expense-date').val())){
		$('#invalidDate').show();
		event.preventDefault();
	}else{
		$('#invalidDate').hide();
	}
	
}

function validateDate(dateString){

	re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
	
	if(dateString && dateString.match(re)){
		var currentDate = new Date(dateString);
		if(!(currentDate instanceof Date) || (isNaN(currentDate.getMonth()))){
			return false;
		}else{
			return true;
		}	
	}else{
		return false;
	}

}

function reportOnSubmit(event){
	var expenses = [];
	$('#expensesOnReport tbody tr').each(function(index, value){
		expenses.push($(value).find('.expenseId').val());
	});	
	
	
	$.post( "/expenses/report/submit",$('#reportData').serialize()+'&expenseIds='+expenses.join()).done(function(report){
		window.location.href = '/expenses/report/'+report.id+'/view';
	});
	event.preventDefault();
}

function addExpensesOnSubmit(event){

	if(!$('#reportName').val() || !$('#purpose').val()){
		window.scrollTo(0, 0);
		$('#reportData :submit').click();
		event.preventDefault();
		return;
	}

	//collect unsubmitted
	var data = [];
	$('#unsubmittedExpenses tbody tr').each(function(index, value){
		if($(value).find('.blankCheckbox')[0].checked){
			data.push($(value).find('.expenseId').val());
		}
	});	

	//add expenses not yet added
	var expenses = [];
	$('#expensesOnReport tbody tr').each(function(index, value){
		expenses.push($(value).find('.expenseId').val());
	});	
	
	
	if(data.length >0){
		$.post( "/expenses/report/submit",$('#reportData').serialize()+'&expenseIds='+expenses.join()).done(function(report){
			$.ajax({
				headers: { 
					'Accept': 'application/json',
					'Content-Type': 'application/json' 
				},
				'type': 'POST',
				url: '/expenses/expenses/addToReport/'+report.id,
				data: JSON.stringify(data),
				success: function(){
					window.location.href = '/expenses/report/'+report.id+'/edit';
				},
				error:function ( jqXHR , textStatus,  errorThrown ){
					console.log(textStatus);
				}	  
			});
		});
		
	}
	event.preventDefault();
}

function filterOnSubmit(event){
	$('#invalidStartDate').hide();
	$('#invalidEndDate').hide();

	var start = $('#startDate').val();
	var end = $('#endDate').val();
	if(start && !validateDate(start)){
		$('#invalidStartDate').show();
		event.preventDefault();
		return;
	}

	if(end && !validateDate(end)){
		$('#invalidEndDate').show();
		event.preventDefault();
		return;
	}

	//window.location.href = window.location.href+(window.location.href.includes('?')?"&":"?")+'category.id='+$('#category').val()+'&start='+$('#startDate').val()+'&end='+$('#endDate').val();
	//event.preventDefault();

}

function getValueByName(name, select){
	var options = select.find('option');
	for(var i=0; i < options.length; i++){
		if(options[i].text === name) {
			return options[i].value;			
		}
	}

}

function startEditInline(event,selector){
	if(!selector){
		selector = '#inlineTemplate';
	}
	if($('#editing').length >0){
		event.preventDefault();
		return;
	}
	var parent = $(event.target).parent().parent();
	var amount = parent.parent().find('.inlineAmount');
	parent.prop('id','current');
	$(parent).hide();
	var template = $(selector).clone();
	template.prop('id','editing');
	template.insertAfter(parent);
	template.show();
	template.find('.inlineDate').val(parent.find('.inlineDate').text());
	template.find('.inlineDate').datepicker({			
		constrainInput: true,
		yearRange: "2010:2020",
		defaultDate: new Date()
	});
	template.find('.inlineCategory').val(getValueByName(parent.find('.inlineCategory').text(),template.find('.inlineCategory')));
	template.find('.inlineVendor').val(parent.find('.inlineVendor').text());
	template.find('.inlineAmount').val(parent.find('.inlineAmount').text().replace('$',''));
	template.find('.inlineCurrency').val(parent.find('.inlineCurrency').text());
	if(parent.find('.inlinePersonal input').prop('checked')){
		template.find('.inlinePersonal').prop('checked','true');
	}
	template.find('.expenseId').val(parent.find('.expenseId').val());
	event.preventDefault();
}

function endEditInline(event,selector){
	if(!selector){
		selector = '#formInline';
	}
	event.preventDefault(selector);
	var data = new FormData($(selector)[0]);
	$.ajax({
		type: "POST",
		url: '/expenses/expenses/update',
		data: data,  	  
		cache: false,
		success: function(data){
			$('#editing').remove();
			var current = $('#current');
			current.show();
			var date = new Date(data.date);			
			current.find('.inlineDate').text((date.getMonth() + 1) + '/' + date.getDate() + '/' +  date.getFullYear());	
			current.find('.inlineCategory').text(data.category.name);
			current.find('.inlineVendor').text(data.vendor.name);
			current.find('.inlineAmount').text(data.amount);
			current.find('.inlineCurrency').text(data.currency.code);
			if(data.personal){
				current.find('.inlinePersonal input').prop('checked','true');
			}else{
				current.find('.inlinePersonal input').removeProp('checked');
			}
			current.removeAttr('id');

		},
		contentType: false,
		processData: false
	});	
}

function addExpensesToNewReport(){
	var data = [];
	$('#allExpenses tbody tr').each(function(index, value){
		if($(value).find('.blankCheckbox')[0].checked){
			data.push($(value).find('.expenseId').val());
		}
	});	
	if(data.length >0){		
		window.location.href = '/expenses/report/new?expenseIds='+data.join();
	}
	

}