<cfcomponent displayName="Controller" output="false" hint="I am the controller that provides generic ORM service." extends="ModelGlue.gesture.controller.Controller">

<cfset variables._debug = false />

<cffunction name="Init" access="public" returnType="any" output="false" hint="I return a new Controller.">
  <cfargument name="ModelGlue" type="any" required="true" hint="I am an instance of ModelGlue.">
  <cfargument name="name" type="string" required="false" hint="A name for this controller." default="#createUUID()#">
  <cfargument name="debug" type="boolean" required="true" default="false" />
	
	<cfset super.init(arguments.ModelGlue, arguments.name) />
	<cfset variables.ValidationService = arguments.ModelGlue.getValidationService() />
  <cfreturn this />
</cffunction>
	
<cffunction name="getOrmAdapter" access="private" returntype="any" output="false">
	<cfreturn getModelGlue().getOrmAdapter() />
</cffunction>
	
<cffunction name="loadORMAdapter" access="public" output="false">
	<cfargument name="event" />
	
	<cfset var svc = "" />
	<cfset var adapter = "" />
	<cfset var mg = getModelGlue() />

	<cftry>
		<cfset svc = mg.getBean("ormService") />
		<cfset adapter = mg.getBean("ormAdapter") />
		
		<cfset mg.setOrmService(svc) />
		<cfset mg.setOrmAdapter(adapter) />
		
		<cfcatch type="coldspring.NoSuchBeanDefinitionException">
			<!--- No bean, no ORM.  --->
		</cfcatch>
	</cftry>
	
	<cfif not isObject(getOrmAdapter())>
		<cfset arguments.event.addTraceStatement("ORM", "No ORM adapter is configured.  You will not be able to scaffold or use generic database messages.") />
	</cfif>
</cffunction>

<cffunction name="onRequestStart" access="public" output="false">
	<cfargument name="event" />
	<cfif not isObject(getOrmAdapter())>
		<cfset arguments.event.addTraceStatement("ORM", "No ORM adapter is configured.  You will not be able to scaffold or use generic database messages.") />
	</cfif>
</cffunction>

<cffunction name="genericList" access="public" returntype="void" output="false">
	<cfargument name="event" />

	<cfset var table = arguments.event.getArgument("object") />
	<cfset var queryName = arguments.event.getArgument("queryName", table & "Query") />
	<cfset var criteriaList = arguments.event.getArgument("criteria") />
	<cfset var criteria = structNew() />
	<cfset var field = "" />
	<cfset var result = "" />
	
	<cfloop list="#criteriaList#" index="field">
		<cfif listLen(field, "=") gt 1>
			<cfset criteria[listFirst(field, "=")] = listLast(field, "=") />
		<cfelseif listLen(field, ":") gt 1>
			<cfif not arguments.event.valueExists(listFirst(field, ":"))>
				<cfset arguments.event.setValue(listFirst(field, ":"), listLast(field, ":")) />
			</cfif>
			<cfset criteria[listFirst(field, ":")] = arguments.event.getValue(listFirst(field, ":")) />
		<cfelseif arguments.event.valueExists(field)>
			<cfset criteria[field] = arguments.event.getValue(field) />
		</cfif>
	</cfloop>
	
	<cfif not arguments.event.argumentExists("gatewayMethod")>
		<cfif arguments.event.argumentExists("orderBy")>
			<cfif not arguments.event.argumentExists("ascending")>
				<cfset result = getOrmAdapter().list(table, criteria, arguments.event.getArgument("orderBy"), true) />
			<cfelse>
				<cfset result = getOrmAdapter().list(table, criteria, arguments.event.getArgument("orderBy"), arguments.event.getArgument("ascending")) />
			</cfif>
		<cfelse>
			<cfset result = getOrmAdapter().list(table, criteria) />
		</cfif>
	<cfelse>
		<cfif not arguments.event.argumentExists("gatewayBean")>
			<cfset result = getOrmAdapter().list(table=table,criteria=criteria,gatewaymethod=arguments.event.getArgument("gatewayMethod")) />
		<cfelse>
			<cfset result = getOrmAdapter().list(table=table,criteria=criteria,gatewaymethod=arguments.event.getArgument("gatewayMethod"),gatewayBean=arguments.event.getArgument("gatewayBean")) />
		</cfif>
	</cfif>
	
	<cfset arguments.event.setValue(queryName, result) />
</cffunction>

<cffunction name="genericRead" access="public" returntype="void" output="false">
	<cfargument name="event" />
	
	<cfset var table = arguments.event.getArgument("object") />
	<cfset var recordName = arguments.event.getArgument("recordName", table & "Record") />
	<cfset var criteriaValues = arguments.event.getArgument("criteria") />
	<cfset var criteria = structNew() />
	<cfset var result = "" />
	<cfset var i = "" />
	<cfset var templateTO = structNew() />
	<cfset var criteriaProps = getOrmAdapter().getCriteriaProperties(table) />
	<cfset var criteriaExists = false />
	
	<cfloop list="#criteriaProps#" index="i">
		<cfset templateTO[i] = "" />
	</cfloop>
	
	<cfif not arguments.event.valueExists(recordName)>
		<cfloop list="#criteriaValues#" index="i">
			<cfif arguments.event.valueExists(i)>
				<cfset criteria[i] = arguments.event.getValue(i, templateTO[i]) />
				<cfset criteriaExists = true />
			</cfif>
		</cfloop>

		<cfif criteriaExists>
			<cftry>
				<cfset result = getOrmAdapter().read(table, criteria) />
				<cfcatch type="ModelGlue.unity.orm.AcceptableReadFailure">
					<cfset result = getOrmAdapter().new(table) />
				</cfcatch>
			</cftry>
		<cfelse>
			<cfset result = getOrmAdapter().new(table) />
		</cfif>
			
		<cfset arguments.event.setValue(recordName, result) />
	</cfif>
</cffunction>

<cffunction name="genericCommit" access="public" returntype="void" output="false">
	<cfargument name="event" />
	<cfset var orm = getOrmAdapter() />
	<cfset var values = arguments.event.getAllValues() />
	<cfset var table = arguments.event.getArgument("object") />
	<cfset var recordName = arguments.event.getArgument("recordName", table & "Record") />
	<cfset var validationName = arguments.event.getArgument("validationName", table & "Validation") />
	<cfset var criteriaList = arguments.event.getArgument("criteria") />
	<cfset var criteria = structNew() />
	<cfset var metadata = orm.getObjectMetadata(table) />
	<cfset var i = "" />
	<cfset var record = "" />
	<cfset var tmp = "" />
	<cfset var assembleErrors = "" />
	<cfset var validationErrors = "" />
		
	<!--- Determine Criteria --->
	<cfloop list="#criteriaList#" index="i">
		<cfif arguments.event.valueExists(i)>
			<cfset criteria[i] = arguments.event.getValue(i) />
		</cfif>
	</cfloop>

	<!--- Moved the cftransaction above the read to address problems with detached objects in Hibernate --->
	<cftransaction>
		<!--- Create Record --->	
		<cfset record = orm.read(table,criteria) />
	
		<!--- Assemble, which returns an error collection if any setters failed --->
		<cfset assembleErrors = orm.assemble(arguments.event, record) />
	
		<!--- Validate --->
		<cfset validationErrors = ValidationService.validate(table, record) />
		
		<!--- Merge error collections --->
		<cfset validationErrors.merge(assembleErrors) />
		
		<!--- Place into state --->
		<cfset arguments.event.setValue(recordName, record) />
		
		<cfif not validationErrors.hasErrors()>
			<cfset orm.commit(table, record, false) />
	
			<!--- Place keys into state, handling common "appends" situations --->
			<cfloop from="1" to="#arrayLen(metadata.primaryKeys)#" index="i">
				<cfinvoke component="#record#" method="get#metadata.primaryKeys[i]#" returnvariable="tmp" />
				<cfset arguments.event.setValue(metadata.primaryKeys[i], tmp) />
			</cfloop>
	
			<!--- Flag that a commit was successful:  there's no good way to success vs. new on the client-side if the form is re-displayed --->
			<cfset arguments.event.setValue(table & "Committed", true) />
	
			<cftransaction action="commit" />

			<cfset arguments.event.addResult("commit") />
		<cfelse>
			<cfset arguments.event.setValue(validationName, validationErrors.getErrors()) />
			<cfset arguments.event.setValue(table & "Committed", false) />

			<cftransaction action="rollback" />

			<cfset arguments.event.addResult("validationError") />
		</cfif>
	</cftransaction>
	
</cffunction>

<cffunction name="genericDelete" access="public" returntype="void" output="false">
	<cfargument name="event" />

	<cfset var table = arguments.event.getArgument("object") />
	<cfset var criteriaValues = arguments.event.getArgument("criteria") />
	<cfset var criteria = structNew() />
	<cfset var i = "" />
	
	<cfloop list="#criteriaValues#" index="i">
		<cfset criteria[i] = arguments.event.getValue(i) />
	</cfloop>
	
	<cftransaction>
		<cfset getOrmAdapter().delete(table, criteria, false) />
		<cftransaction action="commit" />
	</cftransaction>
</cffunction>

</cfcomponent>