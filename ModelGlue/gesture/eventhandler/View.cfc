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


<cfcomponent output="false" hint="I represent a view and its values.">

<cfproperty name="name" type="string" hint="The name of the message." />
<cfproperty name="template" type="string" hint="The .cfm template (present in one of the view mappings) to render." />
<cfproperty name="values" type="struct" hint="The collection of values associated with this view." />
<cfproperty name="append" type="boolean" hint="Does this view append to existing views of the same name?" />
<cfproperty name="cache" type="boolean" hint="Cache this view?" />
<cfproperty name="cacheKey" type="string" hint="Key by which this event-handler should be known in the cache.  Typically set by convention." />
<cfproperty name="cacheKeyValues" type="string" hint="List of event values to append to the cache key." />
<cfproperty name="cacheTimeout" type="numeric" hint="Number of seconds this event-handler should be cached." />
<cfproperty name="format" type="string" hint="The request format of the view." />

<cfset this.name = "" />
<cfset this.values = structNew() />
<cfset this.template = "" />
<cfset this.append = false />
<cfset this.cache = 0 />
<cfset this.cacheKey = "" />
<cfset this.cacheKeyValues = "" />
<cfset this.cacheTimeout = 0 />
<cfset this.format = "" />

<cffunction name="addValue" returntype="ModelGlue.gesture.eventhandler.View" output="false" hint="Adds a Value and returns this.">
	<cfargument name="value" type="ModelGlue.gesture.eventhandler.Value" />
	
	<cfset this.values[value.name] = value />
	
	<cfreturn this />
</cffunction>

</cfcomponent>
