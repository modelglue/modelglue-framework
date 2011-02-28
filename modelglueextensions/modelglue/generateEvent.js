$(document).ready(function() {
	$('#eventGenerationForm :submit').button();
	
	var ms = $('#eventGenerationForm .multiselect'),
		width = ms.width() + 4,
		viewField = $('#generateView'),
		listenerField = $('#generateMessageListener');
	
	ms.css('width', width).multiselect({
		checkAllText: 'Select all',
		close: function() {
			var typeList = ms.multiselect("getChecked").map(function() {
			   return this.value;
			}).get().toString();
			
			$('#type').val(typeList);
		},
		noneSelectedText: 'No Event Types Selected',
		onOpen: function() {
			var options = $('.ui-multiselect-options');
			
			options.position( { my: 'left top', at: 'left bottom', of: options.prev() } );
		},
		selectedText: function(numChecked, numTotal, checkedInputs) {
			if (numChecked > 5)
				return numChecked + ' Event Types Selected';
			else {
				var message = '';
				
				$.each(checkedInputs, function() {
					var title = $(this).attr('title');
					
					if (message.length == 0)
						message = title;
					else
						message += ',' + title;
				});
				return message;
			}
		},
		unCheckAllText: 'Select none'
	});
	
	$('#resultEvent').autocomplete({
		minLength: 0,
		source: eventHandlerNames
	});
	
	viewField.bind('change', function() {
		$(this).toggleField();
	});
	
	listenerField.bind('change', function() {
		$(this).toggleField();
	});
	
	viewField.toggleField();
	listenerField.toggleField();
});

$.fn.toggleField = function(element) {
	var field = $(this);
	var control = field.parents('fieldset');
	var nameControl = control.next();
	
	if (field.val() == 1)
	{
		nameControl.slideDown();
	}
	else
	{
		nameControl.slideUp();
	}
	
	return this;
}