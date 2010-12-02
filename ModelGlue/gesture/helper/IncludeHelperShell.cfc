<cfcomponent output="false" hint="I am a shell CFC into which an include-based helper file is loaded.">
	
<cffunction name="init" output="false" hint="Includes a .cfm's functions into this CFC.">
	<cfargument name="template" type="string" />
	<cfset var key = "" />
	<cfinclude template="#arguments.template#" />
	
	<!--- add all helpers to the Shell --->	
	<cfloop collection="#variables#" item="key">
		<!--- No unintentional recursion please --->
		<cfif key IS NOT "this">
        	<cfset this[key]=variables[key]>
		</cfif>
      </cfloop>
	
	<cfreturn this />
</cffunction>

</cfcomponent>