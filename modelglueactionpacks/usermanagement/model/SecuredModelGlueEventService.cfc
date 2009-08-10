
<cfcomponent name="SecuredModelGlueEventService" output="false">

	<cffunction name="init" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.SecuredModelGlueEventService">
		<cfargument name="objectFactory" type="any" required="true" />
		<cfargument name="SecuredModelGlueEventDAO" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEventDAO" required="true" />
		<cfargument name="SecuredModelGlueEventGateway" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEventGateway" required="true" />

		<cfset variables.objectFactory = arguments.objectFactory />
		<cfset variables.SecuredModelGlueEventDAO = arguments.SecuredModelGlueEventDAO />
		<cfset variables.SecuredModelGlueEventGateway = arguments.SecuredModelGlueEventGateway />

		<cfreturn this/>
	</cffunction>

	<cffunction name="createSecuredModelGlueEvent" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent">
		<cfargument name="EventId" type="numeric" required="true" />
		<cfargument name="Name" type="string" required="false" />
		
			
		<cfset var SecuredModelGlueEvent = variables.objectFactory.new("modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent", arguments) />
		<cfreturn SecuredModelGlueEvent />
	</cffunction>

	<cffunction name="getSecuredModelGlueEvent" access="public" output="false" returntype="SecuredModelGlueEvent">
		<cfargument name="EventId" type="numeric" required="true" />
		
		<cfreturn variables.SecuredModelGlueEventDAO.read(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="saveSecuredModelGlueEvent" access="public" output="false" >
		<cfargument name="SecuredModelGlueEvent" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent" required="true" />

		<cfset variables.SecuredModelGlueEventDAO.save(SecuredModelGlueEvent) />
	</cffunction>

	<cffunction name="deleteSecuredModelGlueEvent" access="public" output="false" >
		<cfargument name="EventId" type="numeric" required="true" />
		
		<cfset var SecuredModelGlueEvent = createSecuredModelGlueEvent(argumentCollection=arguments) />
		<cfset variables.SecuredModelGlueEventDAO.delete(SecuredModelGlueEvent) />
	</cffunction>

	<cffunction name="listSecuredModelGlueEvents" access="public" output="false" returntype="query">
		<cfargument name="EventId" type="numeric" required="false" />
		<cfargument name="Name" type="string" required="false" />
		
		<cfreturn variables.SecuredModelGlueEventGateway.listByAttributes(argumentCollection=arguments) />
	</cffunction>
</cfcomponent>
