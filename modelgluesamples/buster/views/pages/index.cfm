<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script>

<script type="text/javascript">
$(function() {
	
	$('#getLink').click(function() {
		ajaxRequest('get');
		
		return false;
	});
	
	$('#postLink').click(function() {
		ajaxRequest('post');
		
		return false;
	});
	
});

function ajaxRequest(type) {
	$.ajax({
		type: type,
		url: 'RemotingService.cfc',
		data: {
			method: 'executeEvent',
			eventName: 'get.users',
			returnValues: 'users',
			returnformat: 'json'
		},
		success: function(data) {
			$('#ajaxData').html('<b>Ajax ' + type + ' result:</b><br />' + data);
		}
	});
}
</script>

<div align="center">
	<img src="images/buster.jpg"/>
	
	<h2>Buster, the Model-Glue crash test dummy.</h2>
	<p><b>How funny is your dummy?</b></p>
	
	<p><a id="getLink" href="#">Test Ajax get request</a></p>
	<p><a id="postLink" href="#">Test Ajax post request</a></p>
	
	<p id="ajaxData"></p>
</div>
