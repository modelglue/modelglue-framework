<cfcomponent output="false" hint="I represent a phase inside of an event request.  I'm basically a Command script for how this phase should execute.">

<cfset this.name = "Unknown request phase." />
<cfset this.loaded = false />

<cffunction name="setup" returntype="void" output="false" hint="I make sure the phase is loaded exactly once.">
	<cfargument name="eventContext" hint="I am the event context to use for loading.  Duck typed for speed.  Should have no queued events, but this isn't checked (to save time)." />
	<cfargument name="lockPrefix" type="string" required="true" hint="Prefix for name of lock to use for setup" />
	<cfargument name="lockTimeout" type="numeric" required="true" hint="Timeout for setup lock" />
	
	<cfif not this.loaded>
		<cflock type="exclusive" name="#arguments.lockPrefix#.phase.#this.name#.loading" timeout="#arguments.lockTimeout#">
			<!--- Load could have been completed by a thread which held the lock before this thread, so check again --->
			<cfif not this.loaded>
				<cfset load(arguments.eventContext) />
				<cfset this.loaded = true />
			</cfif>
		</cflock>
	</cfif>
</cffunction>

<cffunction name="load" access="private" returntype="void" output="false" hint="I perform the loading for this phase.">
	<cfargument name="eventContext" hint="I am the event context to use for loading.  Duck typed for speed.  Should have no queued events, but this isn't checked (to save time)." />
	<!--- 
		Custom phases: 
		
		Put things to do _before_ the first execute.
	--->
</cffunction>

<cffunction name="execute" returntype="void" output="false" hint="Executes the request phase.">
	<cfargument name="eventContext" hint="I am the event context to act upon.  Duck typed for speed.  Should have no queued events when execute() is called, but this isn't checked (to save time)." />
	
	<!--- 
		Custom phases: 
		
		Put things to do _before_ executing_ the queue here.
	--->
	
	<!--- Tell the context to run its queue. --->
	<cfset arguments.eventContext.executeEventQueue() />
	
	<!--- 
		Custom phases: 
		
		Put things to do _after_ executing_ the queue here.
	--->
</cffunction>

</cfcomponent>