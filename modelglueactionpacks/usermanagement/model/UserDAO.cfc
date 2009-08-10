
<cfcomponent displayname="UserDAO" hint="table ID column = userId">

	<cffunction name="init" access="public" output="false" returntype="modelglueactionpacks.usermanagement.model.UserDAO">
		<cfargument name="datasource" required="true" />
		<cfargument name="gateway" required="true" />
		<cfargument name="objectFactory" required="true" />
		<cfset variables.datasource = arguments.datasource />
		<cfset variables.gateway = arguments.gateway />
		<cfset variables.objectFactory = arguments.objectFactory />
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" output="false">
		<cfargument name="User" type="modelglueactionpacks.usermanagement.model.User" required="true" />
		<cfset var qCreate  = "" />
		<cfquery name="qCreate" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			INSERT INTO user
				(
				username,
				password,
				emailAddress,
				anonymousAccount
				)
			VALUES
				(
				<cfqueryparam value="#arguments.User.getusername()#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.User.getpassword()#" CFSQLType="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.User.getemailAddress()#" CFSQLType="cf_sql_varchar" />,
				0
				)
		</cfquery>
	</cffunction>

	<cffunction name="read" access="public" output="false">
		<cfargument name="userId" />
		<cfargument name="sourceQuery" />		
		<cfargument name="bean" />		

		<cfset var strReturn = structNew() />

		<cfif not structKeyExists(arguments, "bean")>
			<cfset arguments.bean =  variables.objectFactory.new("modelglueactionpacks.usermanagement.model.User") />
		</cfif>
	
		<cfif not structKeyExists(arguments, "sourceQuery")>
			<cfset arguments.sourceQuery = variables.gateway.listByAttributes(argumentCollection=arguments) />
		</cfif>
		
		<cfif arguments.sourceQuery.recordCount>
			<cfset strReturn = queryRowToStruct(arguments.sourceQuery)>
			<cfset arguments.bean.init(argumentCollection=strReturn)>
		</cfif>
		
		<cfset arguments.bean.refreshGroupMap() />

		<cfreturn arguments.bean />
	</cffunction>
	
	<cffunction name="readAnonymousUser" access="public" output="false">
		<cfargument name="userId" />
		
		<cfset var qRead = variables.gateway.listByAttributes(anonymousAccount=1) />

		<cfreturn read(0, qRead) />
	</cffunction>
	

	<cffunction name="update" access="public" output="false">
		<cfargument name="User" type="modelglueactionpacks.usermanagement.model.User" required="true" />
		<cfset var qUpdate  = "" />
		<cfquery name="qUpdate" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			UPDATE	user
			SET
				username = <cfqueryparam value="#arguments.User.getusername()#" CFSQLType="cf_sql_varchar" />,
				password = <cfqueryparam value="#arguments.User.getpassword()#" CFSQLType="cf_sql_varchar" />,
				emailAddress = <cfqueryparam value="#arguments.User.getemailAddress()#" CFSQLType="cf_sql_varchar" />
			WHERE	userId = <cfqueryparam value="#arguments.User.getuserId()#" CFSQLType="cf_sql_integer" />
		</cfquery>

		<cfreturn true />
	</cffunction>

	<cffunction name="delete" access="public" output="false">
		<cfargument name="User" type="modelglueactionpacks.usermanagement.model.User" required="true" />
		<cfset var qDelete  = "" />
		<cfquery name="qDelete" datasource="#variables.datasource.getDSN()#" username="#variables.datasource.getUsername()#" password="#variables.datasource.getPassword()#">
			DELETE FROM	user 
			WHERE	userId = <cfqueryparam value="#arguments.User.getuserId()#" CFSQLType="cf_sql_integer" />
		</cfquery>
	</cffunction>

	<cffunction name="save" access="public" output="false">
		<cfargument name="User" type="modelglueactionpacks.usermanagement.model.User" required="true" />

		<cfset var keyValuePopulated = false />
		
		
		<cfif len(arguments.User.getuserId()) and arguments.User.getuserId() >
			<cfset keyValuePopulated = true />
		</cfif>

		<!--- Convention from Model-Glue illudium templates:  If 0 or "" for primary key, it's a create. --->
		<cfif keyValuePopulated>
			<cfset update(arguments.User) />
		<cfelse>
			<cfset create(arguments.User) />
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
