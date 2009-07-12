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


<p>This sample demonstrates forwarding events.  Using arguments.event.forward() inside of a controller, you can dynamically relocate the request to another event-handler.  This restarts the request cycle, so it's just like browsing to a new URL, except that all state values are maintained across the redirect.</p>

<cfform action="#viewstate.getValue("myself")#forwardRequest">
	Go to
	<select name="forwardTo">
		<option value="redPage">a page a page with red text</option>
		<option value="bluePage">a page a page with blue text</option>
	</select>
	and append the url variable "appendMe" with a value of
	<input type="text" name="appendMe" value="some appended text" />
	<input type="submit" value="Go">
</cfform>

