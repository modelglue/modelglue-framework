<cfcomponent>
	
	<cfset variables.instance = structNew() />
	<cffunction name="init" returntype="CurrentPage" output="false">
		<cfargument name="eventName" type="string" default=""/>
		
		<cfset variables.instance.eventName = arguments.eventName />
		<cfreturn this />
	</cffunction>

	<cffunction name="isSelectedMenu" returntype="boolean" output="false">
		<cfargument name="menu" type="string" default="">
		<cfset var rtnVal = false />
		 
		<cfif arguments.menu IS "Home">
			<cfif len(trim(variables.instance.eventName)) IS 0 OR variables.instance.eventName IS "home">
				<cfset rtnVal = true />
			</cfif>
		<cfelseif arguments.menu IS "logout">
			<cfif listFirst( variables.instance.eventName, ".") IS "Logout">
				<cfset rtnVal = true />
			</cfif>			
		</cfif> 

		<cfreturn rtnVal />
	</cffunction>

</cfcomponent>