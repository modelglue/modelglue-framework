<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


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
