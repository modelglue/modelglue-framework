<cfcomponent output="false" hint="I represent a phase inside of an event request.  I'm basically a Command script for how this phase should execute.">

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