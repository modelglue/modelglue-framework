<cfcomponent hint="I am a simple time-based content cache.  Sweeps cache based on the ""sweepInterval"" constructor argument, checking for sweep necessity on each write to the cache.">

<cffunction name="init" access="public" hint="Constructor">
	<cfargument name="sweepInterval" type="numeric" hint="Number of seconds to wait between cache sweeps."	/>
	<cfargument name="defaultTimeout" type="numeric" hint="Number of seconds an item should live in a cache unless explicitly stated."	/>
	
	<cfset variables._content = structNew() />
	<cfset variables._sweepInterval = arguments.sweepInterval />
	<cfset variables._defaultTimeout = arguments.defaultTimeout />
	<cfset variables._lastSweep = now() />
	<cfset variables._lockName = createUUID() />
	
	<cfreturn this />
</cffunction>

<cffunction name="put" access="public" hint="Puts content into the cache.">
	<cfargument name="key" type="string" hint="Key for the content." />
	<cfargument name="content" type="string" hint="The content to cache." />
	<cfargument name="timeout" type="numeric" hint="Seconds this item should live in the cache." default="#variables._defaultTimeout#" />

	<cfset arguments.created = now() />
	<cfset variables._content[arguments.key] = arguments />	
	
	<cfif dateDiff("s", variables._lastSweep, now())>
		<cflock name="#variables._lockName#" type="exclusive" timeout="30">
			<cfif dateDiff("s", variables._lastSweep, now())>
				<cfset sweep() />
			</cfif>
		</cflock>
	</cfif>
</cffunction>

<cffunction name="get" access="public" returntype="struct" hint="Gets content from the cache.  Returns struct of {success:true, content=""content""}.  If not found, success will be false.">
	<cfargument name="key" type="string" hint="Key for the content." />

	<cfset var content = structNew() />
	<cftry>
		<cfif structKeyExists(variables._content, arguments.key)>
			<cfset content.success = true />
			<cfset content.content = variables._content[arguments.key].content />
		<cfelse>
			<cfset content.success = false />
		</cfif>
		<cfcatch>
			<cfset content.success = false />
		</cfcatch>
	</cftry>
	
	<cfreturn content />
</cffunction>

<cffunction name="sweep" access="public" returntype="void" hint="Instructs implementation to sweep stale items.">
	
	<cfset var key = "" />
	<cfset var item = "" />
	<cfset var sinceLastSweep = dateDiff("s", variables._lastSweep, now()) />
	
	<cflog text="Since last sweep: #sinceLastSweep#" />
	
	<cfloop collection="#variables._content#" item="key">
		<cfset item = variables._content[key] />
		
		<cfif sinceLastSweep gt item.timeout>
			<cfset structDelete(variables._content, key) />
		</cfif>
	</cfloop>
	
	<cfset variables._lastSweep = now() />
</cffunction>

<cffunction name="getContents" access="public" returntype="struct" hint="Gets information about cache contents.">
	<cfreturn variables._content />
</cffunction>

</cfcomponent>