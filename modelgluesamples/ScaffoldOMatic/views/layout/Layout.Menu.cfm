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


<cfsilent>
	<cffile action="read" file="#expandPath('/ScaffoldOMatic/config/ModelGlue.xml')#" variable="xmlNodes" />
	<cfset xmlNodes = xmlParse(xmlNodes) />
	<cfset xmlNodes = xmlSearch( xmlNodes, "//scaffold") />
	<cfset itemArray = [] />
	<cfloop from="1" to="#arrayLen( xmlNodes )#" index="i">
			<cfset arrayAppend(itemArray, xmlNodes[i].XmlAttributes['object'] )>
	</cfloop>
	<cfset currentEvent = event.getValue("Event") />
</cfsilent>
<cfoutput>
<div id="navcontainer">
	<ul id="navlist">
		<cfloop array="#itemArray#" index="currentItem">
			<cfset currentClassAdvice = "" />
			<cfif listFirst(currentEvent, ".") IS currentItem>
				<cfset currentClassAdvice = 'current' />
			</cfif>
			<li<a href="#event.linkTo( currentItem & '.List')#" class="#currentClassAdvice#">#CurrentItem#</a></li>
		</cfloop>
	</ul>
</div>
</cfoutput>
