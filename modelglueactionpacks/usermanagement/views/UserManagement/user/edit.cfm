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


<cfimport prefix="common" taglib="/modelglueactionpacks/common/tags" /> 

<cfset user = event.getValue("user") />
<cfset validationErrors = event.getValue("validationErrors") />

<cfoutput>
<cfform action="#event.linkTo("userManagement.user.save")#" class="cssform">
	<input type="hidden" name="userId" value="#user.getUserId()#" />
	<fieldset>
		<legend>Edit User</legend>
		<common:formfield propertyname="username" label="Username:" required="true" validationErrors="#validationErrors#">
			<cfinput name="username" id="username" value="#user.getusername()#" type="text" required="false" message="Please enter a username." />
		</common:formfield>
		<common:formfield propertyname="password" label="Password:" required="true" validationErrors="#validationErrors#">
			<cfinput name="password" id="password" value="#event.getValue("password")#" type="password" required="false" message="Please enter a password." />
		</common:formfield>
		<common:formfield propertyname="password2" label="Password (again):" required="true" validationErrors="#validationErrors#">
			<cfinput name="password2" id="password2" value="#event.getValue("password2")#" type="password" required="false" message="Please re-enter your password." />
			<div class="hint">To change the user's password, enter it twice.  Otherwise, don't enter a password.</div>
		</common:formfield>
		<common:formfield propertyname="emailAddress" label="E-mail Address:" required="true" validationErrors="#validationErrors#">
			<cfinput name="emailAddress" id="emailAddress" value="#user.getemailAddress()#" type="text" required="false" validate="email" message="Please enter a valid e-mail address." />
		</common:formfield>
		<common:formcontrols>
			<input type="submit" value="Ok" />
			<a href="#event.linkTo("userManagement.user.list")#">Back to User List</a>
		</common:formcontrols>
	</fieldset>
</cfform>
</cfoutput>
