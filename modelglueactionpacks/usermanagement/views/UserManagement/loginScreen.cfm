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

<cfset creationErrors = event.getValue("createUserValidationErrors") />
<cfset loginErrors = event.getValue("loginUserValidationErrors") />
<cfset showSignup = event.getValue("allowUserSignUp", false) />

<h2>Welcome back.</h2>

<cfif isObject(loginErrors)>
	<p class="error">Please correct the following errors.</p>
</cfif>
<cfoutput>
<cfform action="#event.linkTo("userManagement.login")#">
	<fieldset>
		<common:formfield propertyname="username" label="Username:" required="true" validationErrors="#loginErrors#">
			<cfinput name="loginUsername" id="loginUsername" type="text" required="false" message="Please enter a username." />
		</common:formfield>
		<common:formfield propertyname="password" label="Password:" required="true" validationErrors="#loginErrors#">
			<cfinput name="loginPassword" id="loginPassword" type="password" required="false" message="Please enter a password." />
		</common:formfield>
		<common:formcontrols>
			<input type="submit" value="Ok" />
		</common:formcontrols>
	</fieldset>
</cfform>
</cfoutput>

<cfif showSignup>

	<h2>New here?</h2>
	
	<cfif isObject(creationErrors)>
		<p class="error">Please correct the following errors.</p>
	</cfif>
	
	<cfform action="#event.linkTo("userManagement.createAccount")#">
		<fieldset>
			<common:formfield propertyname="username" label="Username:" required="true" validationErrors="#creationErrors#">
				<cfinput name="username" id="username" value="#event.getValue("username")#" type="text" required="false" message="Please enter a username." />
			</common:formfield>
			<common:formfield propertyname="password" label="Password:" required="true" validationErrors="#creationErrors#">
				<cfinput name="password" id="password" value="#event.getValue("password")#" type="password" required="false" message="Please enter a password." />
			</common:formfield>
			<common:formfield propertyname="password2" label="Password (Again):" required="true" validationErrors="#creationErrors#">
				<cfinput name="password2" id="password2" value="#event.getValue("password2")#" type="password" required="false" message="Please re-enter your password." />
			</common:formfield>
			<common:formfield propertyname="emailAddress" label="E-Mail Address:" required="true" validationErrors="#creationErrors#">
				<cfinput name="emailAddress" id="emailAddress" value="#event.getValue("emailAddress")#" type="text" required="false" validate="email" message="Please enter a valid e-mail address." />
			</common:formfield>
			<common:formcontrols>
				<input type="submit" value="Ok" />
			</common:formcontrols>
		</fieldset>
	</cfform>

</cfif>
