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

<cfset securedModelGlueEvent = event.getValue("securedModelGlueEvent") />
<cfset validationErrors = event.getValue("validationErrors", createObject("component", "ModelGlue.Util.ValidationErrorCollection").init()) />

<cfoutput>
<cfform action="#event.linkTo("userManagement.securedModelGlueEvent.save")#">
	<input type="hidden" name="formSubmission" value="true" />
	<input type="hidden" name="eventId" value="#securedModelGlueEvent.geteventId()#" />
	<fieldset>
		<legend>Edit Secured Model-Glue Event</legend>
		<common:formfield propertyName="name" label="Name:" required="true" validationErrors="#validationErrors#">
			<cfinput name="name" id="name" value="#securedModelGlueEvent.getname()#" type="text" required="false" message="Please enter a name." />
		</common:formfield>
		<common:formcontrols>
			<input type="submit" value="Ok" />
			<a href="#event.linkTo("userManagement.securedModelGlueEvent.list")#">Back to Secured Model-Glue Event List</a>
		</common:formcontrols>
	</fieldset>
</cfform>
</cfoutput>
