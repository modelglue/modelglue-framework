$(document).ready(function() {
	
	$('#frmMain .multiSelect').each(function() {
		var label = $.trim( $(this).prev('label').text() );
		
		$(this).css('width', '33%').multiSelect({
			checkAllText: 'Select all',
			noneSelectedText: 'Select ' + label,
			onOpen: function() {
				$('.ui-multiselect-options').position( { my: 'left top', at: 'left bottom', of: $('.ui-multiselect-options').prev() } );
			},
			selectedText: function(numChecked, numTotal, checkedInputs) {
				if (numChecked > 5)
					return numChecked + ' ' + label + ' selected';
				else {
					var message = '';
					$.each(checkedInputs, function() {
						if (message.length == 0)
							message = $(this).attr('title');
						else
							message += ', ' + $(this).attr('title');
					});
					return message;
				}
			},
			unCheckAllText: 'Select none'
		});
	});
	
	$('#frmMain .ui-multiselect').css({ borderWidth: '2px', fontSize: '.8em' });
	$('#frmMain .ui-multiselect input').css({ marginRight: '-2px', paddingLeft: '2px' });
	$('#frmMain .ui-multiselect span').css('margin-top', '2px');

	$('#frmMain .textInput, #frmMain .selectInput').addClass('ui-corner-all ui-state-default')
		.css({ background: 'white none repeat scroll 0 0', paddingLeft: '2px' })
		.hover(
			function() {
				$(this).css('border', '2px solid #999999')
			},
			function() {
				$(this).css('border', '2px solid #DFDFDF');
			}
		);
	
	$('#frmMain .addDatePicker').datepicker();
	
	$('#frmMain :submit').button();
	
});