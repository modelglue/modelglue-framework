<cfinterface hint="I am the contract for a Model-Glue content caching provider.  I am built for speed, not for OO pureness.">

<cffunction name="put" access="public" hint="Puts content into the cache.">
	<cfargument name="key" type="string" hint="Key for the content." />
	<cfargument name="content" type="string" hint="The content to cache." />
	<cfargument name="timeout" type="numeric" hint="Seconds this item should live in the cache." />
</cffunction>

<cffunction name="get" access="public" returntype="struct" hint="Gets content from the cache.  Returns struct of {success:true, content=""content""}.  If not found, success will be false.">
	<cfargument name="key" type="string" hint="Key for the content." />
</cffunction>

<cffunction name="purge" access="public" returntype="struct" hint="Purges content from the cache.">
	<cfargument name="key" type="string" hint="Key for the content." />
</cffunction>

<cffunction name="sweep" access="public" returntype="void" hint="Instructs implementation to sweep stale items.">
</cffunction>

<cffunction name="getContents" access="public" returntype="struct" hint="Gets information about cache contents.">
</cffunction>

</cfinterface>