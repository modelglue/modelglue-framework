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


<cffunction name="makeColumn" output="true" hint="I generate a <td> for a table column">
	<cfargument name="displayPropertyList" />
	<cfargument name="thisProp" />
	<cfargument name="viewLink" />
	<cfargument name="propValue" />
	<!--- TODO: These should be configurable via Coldspring somehow --->
	<cfargument name="dateFormat" type="string" default="mm/dd/yyyy" />
	<cfargument name="timeFormat" type="string" default="" />

	<cfoutput>
	<td<cfif listFirst(arguments.displayPropertyList) neq arguments.thisProp> class="criterion"</cfif>>
		<cfif listFirst(arguments.displayPropertyList) eq arguments.thisProp>
			<a href="#arguments.viewLink#" class="viewLink">
		</cfif>
		<cfif isDate(arguments.propValue)>
			#trim( dateFormat(arguments.propValue, arguments.dateFormat) & " " & timeFormat(arguments.propValue, arguments.timeFormat) )#
		<cfelse>
			#arguments.propValue#
		</cfif>
		<cfif listFirst(arguments.displayPropertyList) eq arguments.thisProp>
			</a>
		</cfif>
	</td>
	</cfoutput>
</cffunction>

<cffunction name="makeRow" output="true" hint="I generate a <tr> for a table row - used with Structs and Arrays of objects">
	<cfargument name="displayPropertyList" />
	<cfargument name="primaryKeyList" />
	<cfargument name="theObject" />
	<cfargument name="viewEvent" />
	<cfargument name="editEvent" />
	<cfargument name="deleteEvent" />
	<cfset var viewLink = "" />
	<cfset var thisProp = "" />
	<cfset var pk = "" />
	<cfoutput>
	<tr>	
	    <cfloop list="#arguments.displayPropertyList#"  index="thisProp">
			<cfset viewLink = arguments.viewEvent />
			<cfloop list='#arguments.primaryKeyList#' index='pk'>
				<cfset viewLink = listAppend(viewLink,"#pk#=#evaluate('arguments.theObject.get#pk#()')#","&") />
			</cfloop>
			#makeColumn(arguments.displayPropertyList,thisProp,viewLink,evaluate('arguments.theObject.get#listFirst(thisProp,'^')#()'))#
		</cfloop>
		#makeLinks(viewLink,arguments.viewEvent,arguments.editEvent,arguments.deleteEvent)#
	</tr>
	</cfoutput>
</cffunction>

<cffunction name="makeLinks" output="true" hint="I generate <td>s for the Edit and Delete events">
	<cfargument name="viewLink" />
	<cfargument name="viewEvent" />
	<cfargument name="editEvent" />
	<cfargument name="deleteEvent" />

	<cfoutput>
	<td class="button"><a href="#replaceNoCase(arguments.viewLink,arguments.viewEvent,arguments.editEvent)#">Edit</a></td>
	<td class="button delete"><a href="#replaceNoCase(arguments.viewLink,arguments.viewEvent,arguments.deleteEvent)#">Delete</a></td>
	</cfoutput>
</cffunction>

