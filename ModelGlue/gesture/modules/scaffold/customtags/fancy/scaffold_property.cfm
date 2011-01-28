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
<cfimport taglib="/modelglueextensions/cfuniform/tags/forms/cfUniForm/" prefix="uform" />
<cfsilent>
	<!--- tag attributes --->
	<cfparam name="attributes.name" type="string" />
	<cfparam name="attributes.type" type="string" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.length" type="numeric" default="0" />
	<cfparam name="attributes.event" type="any" />
	<!--- TODO: These should be configurable via Coldspring somehow --->
	<cfparam name="attributes.dateFormat" type="string" default="mm/dd/yyyy" />
	<cfparam name="attributes.timeFormat" type="string" default="" />
<</cfsilent>
<cfoutput>
<cfif structKeyExists(attributes,"event") and attributes.event.valueExists(attributes.name)>
	<cfset attributes.value = attributes.event.getValue(attributes.name) />
</cfif>
<cfif attributes.type eq "boolean">
	<uform:field label="#attributes.label#" name="#attributes.name#" type="radio">
		<uform:radio label="Yes" value="1" isChecked="#isBoolean(attributes.value) and attributes.value#" />
		<uform:radio label="No" value="0" isChecked="#isBoolean(attributes.value) and not attributes.value#" />
	</uform:field>
<cfelseif attributes.type eq "date">
	<uform:field label="#attributes.label#" name="#attributes.name#" type="date" value="#trim( dateFormat(attributes.value, attributes.dateFormat) & ' ' & timeFormat(attributes.value, attributes.timeFormat) )#" />
<cfelseif attributes.length LT 65535>
	<uform:field label="#attributes.label#" name="#attributes.name#" type="text" value="#attributes.value#" />
<cfelse>
	<uform:field label="#attributes.label#" name="#attributes.name#" type="textarea" value="#attributes.value#" />
</cfif>
</cfoutput>
