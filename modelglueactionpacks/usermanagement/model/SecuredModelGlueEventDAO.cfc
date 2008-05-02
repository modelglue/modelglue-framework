
<cfcomponent displayname="SecuredModelGlueEventDAO" hint="table ID column = EventId">

	<cffunction name="init" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.SecuredModelGlueEventDAO">
		<cfargument name="datasource" required="true" />
		<cfargument name="gateway" required="true" />
		<cfargument name="objectFactory" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.gateway = arguments.gateway />
		<cfset variables.objectFactory = arguments.objectFactory />
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" output="false">
		<cfargument name="SecuredModelGlueEvent" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent" required="true" />

		<cfquery name="qCreate" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			INSERT INTO securedModelGlueEvent
				(
				Name
				)
			VALUES
				(
				<cfqueryparam value="#arguments.SecuredModelGlueEvent.getName()#" CFSQLType="cf_sql_varchar" />
				)
		</cfquery>
	</cffunction>

	<cffunction name="read" access="public" output="false">
		<cfargument name="EventId" />
		

		<cfset var qRead = variables.gateway.listByAttributes(argumentCollection=arguments) />
		<cfset var bean =  variables.objectFactory.new("modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent") />
		<cfset var strReturn = structNew() />

		
		<cfif qRead.recordCount>
			<cfset strReturn = queryRowToStruct(qRead)>
			<cfset bean.init(argumentCollection=strReturn)>
		</cfif>

		<cfreturn bean />
	</cffunction>

	<cffunction name="update" access="public" output="false">
		<cfargument name="SecuredModelGlueEvent" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent" required="true" />

		<cfquery name="qUpdate" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			UPDATE	securedModelGlueEvent
			SET
				Name = <cfqueryparam value="#arguments.SecuredModelGlueEvent.getName()#" CFSQLType="cf_sql_varchar" />
			WHERE	EventId = <cfqueryparam value="#arguments.SecuredModelGlueEvent.getEventId()#" CFSQLType="cf_sql_integer" />
		</cfquery>

		<cfreturn true />
	</cffunction>

	<cffunction name="delete" access="public" output="false">
		<cfargument name="SecuredModelGlueEvent" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent" required="true" />

		<cfquery name="qDelete" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			DELETE FROM	securedModelGlueEvent 
			WHERE	EventId = <cfqueryparam value="#arguments.SecuredModelGlueEvent.getEventId()#" CFSQLType="cf_sql_integer" />
		</cfquery>
	</cffunction>

	<cffunction name="save" access="public" output="false">
		<cfargument name="SecuredModelGlueEvent" type="modelglueactionpacks.usermanagement.model.SecuredModelGlueEvent" required="true" />

		<cfset var keyValuePopulated = false />
		
		
		<cfif len(arguments.SecuredModelGlueEvent.getEventId()) and arguments.SecuredModelGlueEvent.getEventId() >
			<cfset keyValuePopulated = true />
		</cfif>

		<!--- Convention from Model-Glue illudium templates:  If 0 or "" for primary key, it's a create. --->
		<cfif keyValuePopulated>
			<cfset update(arguments.SecuredModelGlueEvent) />
		<cfelse>
			<cfset create(arguments.SecuredModelGlueEvent) />
		</cfif>
	</cffunction>

	<cffunction name="queryRowToStruct" access="private" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		
		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 * 
			 * @param query 	 The query to work with. 
			 * @param row 	 Row number to check. Defaults to row 1. 
			 * @return Returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, December 11, 2001 
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			//return the struct
			return stReturn;
		</cfscript>
	</cffunction>

</cfcomponent>
