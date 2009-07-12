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



<cfset recent = viewState.getValue("recentContacts") />

<h3>Menu</h3>

<a href="index.cfm?event=editContact">Add a new Contact</a>
<br>

<a href="index.cfm?event=listContacts">List all Contacts</a>
<br>
<br>


<!--- List the most recent contacts accessed. --->
Recent Contacts: <br>
<cfloop index="i" from="1" to="#ArrayLen(recent)#">
	<cfset contact = recent[i] />
	
	<cfoutput>
	<a href="index.cfm?event=viewContact&id=#contact.getId()#">
		<cfoutput>#contact.getFirstName()# #contact.getLastName()#</cfoutput>
	</a>
	</cfoutput>
	<br>
</cfloop>
