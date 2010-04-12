$(document).ready(function() {
	
	$('table.dataTable').each(function() {
		
		var thisTable = $(this);
		var entityName = thisTable.attr('id').replace(/Table/, '');
		var th = thisTable.find('thead th');
		var columns = [];
		
		th.each(function(index) {
			if (index == 0)
				columns.push( { sType: 'html' } );
			else if ($.trim( $(this).text() ).length == 0)
				columns.push( { bSearchable: false, bSortable: false } );
			else
				columns.push( null );
		});
		
		thisTable.dataTable( {
			aoColumns: columns,
			bAutoWidth: false,
			bJQueryUI: true,
			fnDrawCallback: function() {
				var tableId = arguments[0].sTableId;
				
				$('#' + tableId).parents('.dataTables_wrapper').next('.addLink').add('#' + tableId + ' td.button a').button();
			}
		});
		
		thisTable.find('td.delete a').live('click', function() {
			
			var linkTarget = $(this).attr('href');
			
			$('<div>Are you sure you wish to delete this ' + entityName + ' record?</div>').appendTo('body').dialog( {
				buttons: {
					Cancel: function() {
						$(this).dialog('close').remove();
					},
					OK: function() {
						window.location.href = linkTarget;
						$(this).dialog('close').remove();
					}
				},
				modal: true,
				title: 'Delete ' + entityName
			});
			
			return false;
			
		});
		
	});
	
});