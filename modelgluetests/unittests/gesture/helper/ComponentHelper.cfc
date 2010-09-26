<cfcomponent beans="bean2">
	
<cffunction name="helperFunction">
	<cfreturn "I am a component helper." />
</cffunction>

<cffunction name="setBean" returntype="void">
	<cfargument name="bean" type="any" required="true" />
	<cfset variables._bean = arguments.bean />
</cffunction>

<cffunction name="getBean" returntype="any">
	<cfreturn variables._bean />
</cffunction>

<cffunction name="getBean2" returntype="any">
	<cfreturn beans.bean2 />
</cffunction>

</cfcomponent>