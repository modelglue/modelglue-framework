<!----------------------
Description: I am a factory for EventContext objects
Author: Dan Wilson (dan@nodans.com)
Date: 1/14/2010

CHANGE LOG:
------------------------>

<cfcomponent output="false">
	<cfset variables.eventContextDependencies = structNew() />
	<cffunction name="init" access="public" returntype="EventContextFactory">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="new" output="false" access="public" returntype="any" hint="I create a new event context object">
		<cfargument name="eventHandlers" default="#structNew()#" hint="Available event handlers." />
		<cfargument name="messageListeners" default="#structNew()#" hint="Message subscribers." />
		<cfargument name="values" required="false" default="#arrayNew(1)#" hint="A single structure or array of structures to merge into this collection." />
		<cfargument name="helpers" required="false" default="#structNew()#"  hint="Helpers available as part of the event context."/>
		<cfargument name="requestPhases" hint="Request phases." />
		
		<cfset structAppend( arguments, variables.eventContextDependencies ) />

		
		<cfreturn createobject( "component", variables.objectPath ).init( argumentcollection:arguments ) />
	</cffunction>
	
	<cffunction name="setModelglue" access="public" output="false" returntype="void">
		<cfargument name="modelglue" type="any" required="true" />
		<cfset variables.eventContextDependencies.modelglue = arguments.modelglue />
	</cffunction>
	
	<cffunction name="setStatePersister" access="public" output="false" returntype="void">
		<cfargument name="statePersister" type="any" required="true" />
		<cfset variables.eventContextDependencies.statePersister = arguments.statePersister />
	</cffunction>
	
	<cffunction name="setViewRenderer" access="public" output="false" returntype="void">
		<cfargument name="viewRenderer" type="any" required="true" />
		<cfset variables.eventContextDependencies.viewRenderer = arguments.viewRenderer />
	</cffunction>
	
	<cffunction name="setBeanPopulator" access="public" output="false" returntype="void">
		<cfargument name="beanPopulator" type="any" required="true" />
		<cfset variables.eventContextDependencies.beanPopulator = arguments.beanPopulator />
	</cffunction>
	
	<cffunction name="setLogWriter" access="public" output="false" returntype="void">
		<cfargument name="logWriter" type="any" required="true" />
		<cfset variables.eventContextDependencies.logWriter = arguments.logWriter />
	</cffunction>
	
	<cffunction name="setObjectPath" access="public" output="false" returntype="void">
		<cfargument name="objectPath" type="any" required="true" />
		<cfset variables.objectPath = arguments.objectPath />
	</cffunction>
	
</cfcomponent>