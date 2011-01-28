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


<cfparam name="attributes.section" />
<cfparam name="attributes.event" />

<cfswitch expression="#thisTag.executionMode#">

<cfcase value="start">
	<cfoutput>
		<strong>#attributes.section.title#</strong>
		<ul class="navlist">
			<cfloop from="1" to="#arrayLen(attributes.section.items)#" index="i">
				<li>
					<cfif structKeyExists(attributes.section.items[i], "renderingTag")>
						<cfmodule template="#attributes.section.items[i].renderingTag#" item="#attributes.section.items[i]#" event="#attributes.event#" />				
					<cfelse>
						<a href="#attributes.event.linkTo(attributes.section.items[i].event)#">#attributes.section.items[i].label#</a>
					</cfif>
				</li>
			</cfloop>
		</ul>	
	</cfoutput>
</cfcase>
<cfcase value="end">
<cfoutput>
</cfoutput>
</cfcase>
</cfswitch>
