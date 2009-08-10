<cfcomponent output="false" displayName="Announcement Bean" hint="Manages an announcement.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.title = "" />
	<cfset variables.instance.body = "" />
	<cfset variables.instance.projectidfk = "" />
	<cfset variables.instance.useridfk = "" />
	<cfset variables.instance.posted = "" />
	
	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>
	
	<cffunction name="setTitle" returnType="void" access="public" output="false">
		<cfargument name="title" type="string" required="true">
		<cfset variables.instance.title = arguments.title>
	</cffunction>
	
	<cffunction name="getTitle" returnType="string" access="public" output="false">
		<cfreturn variables.instance.title>
	</cffunction>	
	
	<cffunction name="setBody" returnType="void" access="public" output="false">
		<cfargument name="body" type="string" required="true">
		<cfset variables.instance.body = arguments.body>
	</cffunction>
	
	<cffunction name="getBody" returnType="string" access="public" output="false">
		<cfreturn variables.instance.body>
	</cffunction>
		
	<cffunction name="setProjectIDFK" returnType="void" access="public" output="false">
		<cfargument name="projectidfk" type="string" required="true">
		<cfset variables.instance.projectidfk = arguments.projectidfk>
	</cffunction>
	
	<cffunction name="getProjectIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.projectidfk>
	</cffunction>	
	
	<cffunction name="setUserIDFK" returnType="void" access="public" output="false">
		<cfargument name="useridfk" type="string" required="true">
		<cfset variables.instance.useridfk = arguments.useridfk>
	</cffunction>
	
	<cffunction name="getUserIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.useridfk>
	</cffunction>
	
	<cffunction name="setPosted" returnType="void" access="public" output="false">
		<cfargument name="posted" type="string" required="true">
		<cfset variables.instance.posted = arguments.posted>
	</cffunction>
	
	<cffunction name="getPosted" returnType="string" access="public" output="false">
		<cfreturn variables.instance.posted>
	</cffunction>	

	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>
		
		<cfif not len(trim(getTitle()))>
			<cfset arrayAppend(errors,"Title cannot be blank.")>
		</cfif>
		<cfif not len(trim(getBody()))>
			<cfset arrayAppend(errors,"Body cannot be blank.")>
		</cfif>
		<cfif not len(trim(getUserIDFK()))>
			<cfset arrayAppend(errors,"UserIDFK cannot be blank.")>
		</cfif>
		<cfif not len(trim(getPosted())) or not isDate(getPosted())>
			<cfset arrayAppend(errors,"Posted cannot be blank and must be a date.")>
		</cfif>

		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

</cfcomponent>	