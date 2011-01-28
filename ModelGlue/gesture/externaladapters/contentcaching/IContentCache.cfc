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


<cfinterface hint="I am the contract for a Model-Glue content caching provider.  I am built for speed, not for OO pureness.">

<cffunction name="setDefaultTimeout" access="public" hint="Sets the default timeout for items put in the cache.">
	<cfargument name="defaultTimeout" type="numeric" required="true" hint="Number of seconds an item should live in a cache unless explicitly stated." />
</cffunction>

<cffunction name="put" access="public" hint="Puts content into the cache.">
	<cfargument name="key" type="string" required="true" hint="Key for the content." />
	<cfargument name="content" type="any" required="true" hint="The content to cache." />
	<cfargument name="timeout" type="numeric" required="false" hint="Seconds this item should live in the cache." />
</cffunction>

<cffunction name="get" access="public" returntype="struct" hint="Gets content from the cache.  Returns struct of {success:true, content=""content""}.  If not found, success will be false.">
	<cfargument name="key" type="string" required="true" hint="Key for the content." />
</cffunction>

<cffunction name="purge" access="public" returntype="struct" hint="Purges content from the cache.">
	<cfargument name="key" type="string" required="true" hint="Key for the content." />
</cffunction>

<cffunction name="sweep" access="public" returntype="void" hint="Instructs implementation to sweep stale items.">
</cffunction>

<cffunction name="getContents" access="public" returntype="struct" hint="Gets information about cache contents.">
</cffunction>

</cfinterface>
