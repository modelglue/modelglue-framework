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


<meta http-equiv="refresh" content="1;url=index.cfm?event=counts">

<cfset requests = viewState.getValue("countRequests") />

<a href="index.cfm?event=counts">Reload</a>

Currently running counts:

<cfloop from="1" to="#arrayLen(requests)#" index="i">
	<cfset event = requests[i].getEvent() />
	<cfset count = event.getValue("count") />
	<cfset number = event.getValue("number") />
	<cfoutput>
	<cfif isNumeric(count) and isNumeric(number)>
		<div style="background:##CCCCCC;width:#count/number*100#%">&nbsp;</div>
	<cfelse>
		<div style="background:##CCCCCC;width:0%">&nbsp;</div>
	</cfif>
		#count# / #number#
		<a href="index.cfm?event=removeCount&pos=#i#">Remove</a>
		</div>
	</cfoutput>
</cfloop>


