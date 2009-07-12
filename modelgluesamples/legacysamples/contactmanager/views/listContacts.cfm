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



<h3>Contact List</h3>

<cfset contacts = viewState.getValue("contacts") />

<cfset keyArray = StructKeyArray(contacts) />
<cfloop index="i" from="1" to="#ArrayLen(keyArray)#">
	<cfset contact = contacts[keyArray[i]] />

	<cfoutput>
	<table border="1" cellspacing="1" cellpadding="1">
		<tr>
		<tr>
			<td valign="top"><b>Name</b></td>
			<td valign="top">
				#contact.getFirstName()# #contact.getLastName()#
				(<a href="index.cfm?event=editContact&id=#contact.getId()#">Edit</a>)
			</td>
		</tr>
		</tr>
		<tr>
			<td valign="top"><b>Address</b></td>
			<td valign="top">
				#contact.getStreet()# <br>
				#contact.getCity()#, #contact.getState()#  #contact.getZip()# <br>
			</td>
		</tr>
	</table>
	<br>
	</cfoutput>
</cfloop>
