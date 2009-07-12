<cfcomponent output="false" displayName="Milestone Bean" hint="Bean.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.name = "" />
	<cfset variables.instance.duedate = "" />
	<cfset variables.instance.projectidfk = "" />
	
	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>
	
	<cffunction name="setName" returnType="void" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>
	
	<cffunction name="getName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.name>
	</cffunction>	
	
	<cffunction name="setDueDate" returnType="void" access="public" output="false">
		<cfargument name="duedate" type="any" required="true">
		<cfset variables.instance.duedate = arguments.duedate>
	</cffunction>
	
	<cffunction name="getDueDate" returnType="any" access="public" output="false">
		<cfreturn variables.instance.duedate>
	</cffunction>

	<cffunction name="setProjectIDFK" returnType="void" access="public" output="false">
		<cfargument name="projectidfk" type="uuid" required="true">
		<cfset variables.instance.projectidfk = arguments.projectidfk>
	</cffunction>
	
	<cffunction name="getProjectIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.projectidfk>
	</cffunction>
		
	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>
		
		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>
		<cfif len(trim(getDueDate())) and not isDate(getDueDate())>
			<cfset arrayAppend(errors, "Due date must be a valid date.")>
		</cfif>

		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

</cfcomponent>	