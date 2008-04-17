<cfcomponent output="false" hint="I am a shell CFC into which an include-based helper file is loaded.">
	
<cffunction name="init" output="false" hint="Includes a .cfm's functions into this CFC.">
	<cfargument name="template" type="string" />

	<cfinclude template="#arguments.template#" />
	
	<!--- Put your underwear on the outside. --->
	<cfset this = variables />
	
	<cfreturn this />
</cffunction>

</cfcomponent>