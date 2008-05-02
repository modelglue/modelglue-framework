
<cfcomponent displayname="GroupDAO" hint="table ID column = GroupId">

	<cffunction name="init" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.GroupDAO">
		<cfargument name="datasource" required="true" />
		<cfargument name="gateway" required="true" />
		<cfargument name="objectFactory" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.gateway = arguments.gateway />
		<cfset variables.objectFactory = arguments.objectFactory />
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" output="false">
		<cfargument name="Group" type="modelglueactionpacks.usermanagement.model.Group" required="true" />

		<cfset var qCreate = "" />
		
		<cfquery name="qCreate" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			INSERT INTO `group`
				(
				Name,
				Description
				)
			VALUES
				(
				<cfqueryparam value="#arguments.Group.getName()#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.Group.getDescription()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.Group.getDescription())#" />
				)
		</cfquery>
		
		<cfquery name="qCreate" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			select last_insert_id() as groupId
		</cfquery>
		
		<cfset group.setGroupId(qCreate.groupId) />
	</cffunction>

	<cffunction name="read" access="public" output="false">
		<cfargument name="GroupId" />
		

		<cfset var qRead = variables.gateway.listByAttributes(argumentCollection=arguments) />
		<cfset var bean =  variables.objectFactory.new("modelglueactionpacks.usermanagement.model.Group") />
		<cfset var strReturn = structNew() />

		
		<cfif qRead.recordCount>
			<cfset strReturn = queryRowToStruct(qRead)>
			<cfset bean.init(argumentCollection=strReturn)>
		</cfif>

		<cfreturn bean />
	</cffunction>

	<cffunction name="update" access="public" output="false">
		<cfargument name="Group" type="modelglueactionpacks.usermanagement.model.Group" required="true" />

		<cfquery name="qUpdate" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			UPDATE	`group`
			SET
				Name = <cfqueryparam value="#arguments.Group.getName()#" CFSQLType="cf_sql_varchar" />,
				Description = <cfqueryparam value="#arguments.Group.getDescription()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.Group.getDescription())#" />
			WHERE	GroupId = <cfqueryparam value="#arguments.Group.getGroupId()#" CFSQLType="cf_sql_integer" />
		</cfquery>

		<cfreturn true />
	</cffunction>

	<cffunction name="delete" access="public" output="false">
		<cfargument name="Group" type="modelglueactionpacks.usermanagement.model.Group" required="true" />

		<cfquery name="qDelete" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			DELETE FROM	`group` 
			WHERE	GroupId = <cfqueryparam value="#arguments.Group.getGroupId()#" CFSQLType="cf_sql_integer" />
		</cfquery>
	</cffunction>

	<cffunction name="save" access="public" output="false">
		<cfargument name="Group" type="modelglueactionpacks.usermanagement.model.Group" required="true" />

		<cfset var keyValuePopulated = false />
		
		
		<cfif len(arguments.Group.getGroupId()) and arguments.Group.getGroupId() >
			<cfset keyValuePopulated = true />
		</cfif>

		<!--- Convention from Model-Glue illudium templates:  If 0 or "" for primary key, it's a create. --->
		<cfif keyValuePopulated>
			<cfset update(arguments.Group) />
		<cfelse>
			<cfset create(arguments.Group) />
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
