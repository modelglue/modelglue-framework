<cfcomponent hint="I am a simple time-based content cache.  Sweeps cache based on the ""sweepInterval"" constructor argument, checking for sweep necessity on each read from the cache.">

<cffunction name="init" access="public" hint="Constructor">
	<cfargument name="sweepInterval" type="numeric" default="20" hint="Number of seconds to wait between cache sweeps."	/>
	
	<cfset variables._content = structNew() />
	<cfset variables._sweepInterval = arguments.sweepInterval />
	<cfset variables._defaultTimeout = 60 />
	<cfset variables._lastSweep = now() />
	<cfset variables._lockName = createUUID() />
	
	<cfreturn this />
</cffunction>

<cffunction name="setDefaultTimeout" access="public" hint="Sets the default timeout for items put in the cache.">
	<cfargument name="defaultTimeout" type="numeric" required="true" hint="Number of seconds an item should live in a cache unless explicitly stated." />

	<cfset variables._defaultTimeout = arguments.defaultTimeout />
</cffunction>

<cffunction name="put" access="public" hint="Puts content into the cache.">
	<cfargument name="key" type="string" required="true" hint="Key for the content." />
	<cfargument name="content" type="any" required="true" hint="The content to cache." />
	<cfargument name="timeout" type="numeric" required="false" hint="Seconds this item should live in the cache." default="#variables._defaultTimeout#" />

	<cfset arguments.expires = dateAdd("s",arguments.timeout,now()) />
	<cfset variables._content[arguments.key] = arguments />	
</cffunction>

<cffunction name="get" access="public" returntype="struct" hint="Gets content from the cache.  Returns struct of {success:true, content=""content""}.  If not found, success will be false.">
	<cfargument name="key" type="string" required="true" hint="Key for the content." />

	<cfset var content = structNew() />

	<cfif dateDiff("s", variables._lastSweep, now()) gt variables._sweepInterval>
		<cflock name="#variables._lockName#" type="exclusive" timeout="30">
			<cfif dateDiff("s", variables._lastSweep, now()) gt variables._sweepInterval>
				<cfset sweep() />
			</cfif>
		</cflock>
	</cfif>

	<cftry>
		<cfif structKeyExists(variables._content, arguments.key)>
			<cfset content.success = true />
			<cfset content.content = variables._content[arguments.key].content />
		<cfelse>
			<cfset content.success = false />
		</cfif>
		<cfcatch type="expression">
			<cfset content.success = false />
		</cfcatch>
	</cftry>

	<cfreturn content />
</cffunction>

<cffunction name="sweep" access="public" returntype="void" hint="Instructs implementation to sweep stale items.">
	
	<cfset var key = "" />
	<cfset var item = "" />
	
	<cfset variables._lastSweep = now() />
	
	<cfloop collection="#variables._content#" item="key">
		<cftry>
			<cfset item = variables._content[key] />
			<cfcatch type="expression">
				<!--- Item no longer in cache: set item to a string so that the IsStruct(item) below returns false --->
				<cfset item = "" />
			</cfcatch>
		</cftry>
			
		<cfif IsStruct(item) and (variables._lastSweep gt item.expires)>
			<cfset purge(key) />
		</cfif>
			
	</cfloop>

</cffunction>

<cffunction name="purge" access="public" returntype="void" hint="Purges content from the cache.">
	<cfargument name="key" type="string" required="true" hint="Key for the content." />
	
	<cfset structDelete(variables._content, arguments.key) />
</cffunction>

<cffunction name="getContents" access="public" returntype="struct" hint="Gets information about cache contents.">
	<cfreturn variables._content />
</cffunction>

</cfcomponent>