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
	<cfparam name="attributes.objectName" type="string" />
	<cfparam name="attributes.valueQuery" type="query" />
	<cfparam name="attributes.childDescProperty" type="string" />
	<cfparam name="attributes.selectedList" type="string" default="" />
	<cfparam name="attributes.label" type="string" default="#attributes.name#" />
	<cfparam name="attributes.value" type="string" default="" />
	<cfparam name="attributes.nullable" type="boolean" default="true" />
	<cfparam name="attributes.validation" type="struct" default="#structNew()#" />
<</cfsilent>
<cfoutput>
<div class="formfield">
	<label for="#attributes.name#"><b>#attributes.label#:</b></label>
	<span class="input">
		<!--- 
		hidden makes the field always defined.  if this was not here, and you deleted this whole field
		from the control, you would wind up deleting all child records during a genericCommit...
		--->
		<input type="hidden" name="#attributes.label#|#attributes.name#" value="" />
		
		<div class="formfieldinputstack">
			<cfloop query="attributes.valueQuery">
				<label for="#attributes.name#_#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#">
					<input type="checkbox" name="#attributes.label#|#attributes.name#" id="#attributes.name#_#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#" value="#attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow]#"<cfif listFindNoCase(attributes.selectedList, attributes.valueQuery[attributes.name][attributes.valueQuery.currentRow])> checked</cfif>/>
					#attributes.valueQuery[attributes.childDescProperty][attributes.valueQuery.currentRow]#
				</label><br />
			</cfloop>
		</div>
	</span>
</div>
</cfoutput>
