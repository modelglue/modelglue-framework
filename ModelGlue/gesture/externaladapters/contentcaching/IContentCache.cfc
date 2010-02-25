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