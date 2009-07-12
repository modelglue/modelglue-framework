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




<cfset contact = viewState.getValue("contact") />


<cfset val = viewState.getValue("contactValidation", structNew()) />

<h3>Contact Info</h3>

<!---
<font color="#FF0000"><cfoutput>#message#</cfoutput></font>
--->

<cfoutput>
<form action="index.cfm?event=CommitContact" method="post">
	<input type="hidden" name="id" value="#contact.getId()#"><br>
	First Name: <input type="text" name="firstName" value="#contact.getFirstName()#"><br>
	<cfoutput><cfif structKeyExists(val, "firstname")><font color="##FF0000">#val.firstname[1]#</font><br /></cfif></cfoutput>
	Last Name: <input type="text" name="lastName" value="#contact.getLastName()#"><br>
	<cfoutput><cfif structKeyExists(val, "lastName")><font color="##FF0000">#val.lastName[1]#</font><br /></cfif></cfoutput>
	Street: <input type="text" name="street" value="#contact.getStreet()#"><br>
	City: <input type="text" name="city" value="#contact.getCity()#"><br>
	State: <input type="text" name="state" value="#contact.getState()#"><br>
	Zip Code: <input type="text" name="zip" value="#contact.getZip()#"><br>
	<br>
	<input type="submit" value="#viewState.getValue("submitLabel")#">
</form>

<form action="index.cfm?event=CancelEditContact" method="post">
	<input type="submit" value="Cancel">
</form>
</cfoutput>

