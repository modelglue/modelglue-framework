<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<div style="color:#F00">WARNING: This example application requires CFMX7 Enterprise or Developer Edition, and for Sean Corfield's concurrency library to be installed and tested independently of the framework!</div><br />

<form>
Enter a number to count to:
<input type="text" name="number" id="number">
<input type="button" value="Go" onClick="var win=window.open('index.cfm?event=startCount&number=' + document.getElementById('number').value, 'count', 'height=600,width=800,status=yes,toolbar=no,menubar=no,location=yes,resizable=yes,scrollbars=yes');win.focus()">
</form>
