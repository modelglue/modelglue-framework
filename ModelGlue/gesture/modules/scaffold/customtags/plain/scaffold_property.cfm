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


<cfif thisTag.executionMode eq "start"><cfexit method="exittemplate" /></cfif>
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.length" type="numeric" default="0" />
	<!--- TODO: These should be configurable via Coldspring somehow --->
	<cfparam name="attributes.dateFormat" type="string" default="mm/dd/yyyy" />
	<cfparam name="attributes.timeFormat" type="string" default="" />
<</cfsilent>
<cfoutput>
<div class="formfield">
	<label for="#attributes.name#"><b>#attributes.label#:</b></label>
	<span class="input">
		<cfif attributes.type eq "boolean">
			<input type="radio" id="#attributes.name#_true" name="#attributes.name#" value="true"<cfif isBoolean(attributes.value) and attributes.value> checked="checked"</cfif>/>
			<label for="#attributes.name#_true"> Yes</label>
			<input type="radio" id="#attributes.name#_false" name="#attributes.name#" value="false"<cfif isBoolean(attributes.value) and not attributes.value >checked="checked"</cfif>/>
			<label for="#attributes.name#_false"> No</label>		
		<cfelseif attributes.length LT 65535>
			<input type="text" class="input" id="#attributes.name#" name="#attributes.name#" value="<cfif attributes.type eq "date">#trim( dateFormat(attributes.value, attributes.dateFormat) & ' ' & timeFormat(attributes.value, attributes.timeFormat) )#<cfelse>#attributes.value#</cfif>" />
		<cfelse>
			<textarea class="input" id="#attributes.name#" name="#attributes.name#">#attributes.value#</textarea>
		</cfif>
	</span>
</div>
</cfoutput>
