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


<cfset users = event.getValue("users") />

<cfoutput><form action="#event.linkTo("userManagement.user.delete")#" method="post"></cfoutput>

<cfoutput>
	<div class="recordSetControls">
		<a href="#event.linkTo("userManagement.user.edit")#" class="add">Add New User</a>
		<input type="submit" value="Delete Selected Users" />
	</div>
</cfoutput>

<table class="recordSet">
<thead>
	<tr>
		<th>&nbsp;</th>
		<th>Username</th>
		<th>E-Mail Address</th>
	</tr>
</thead>
<tbody>
	<cfoutput query="users">
		<tr <cfif users.currentRow mod 2 eq 0>class="odd"<cfelse>class="even"</cfif>>
			<td class="skinny"><input type="checkbox" name="userId" value="#users.userId#" /></td>		
			<td><a href="#event.linkTo("userManagement.user.edit")##event.formatUrlParameter("userId", users.userId)#">#htmlEditFormat(users.username)#</a></td>
			<td><a href="mailto:#htmlEditFormat(users.emailAddress)#">#htmlEditFormat(users.emailAddress)#</a></td>
		</td>
	</cfoutput>
</tbody>
</table>

</form>
