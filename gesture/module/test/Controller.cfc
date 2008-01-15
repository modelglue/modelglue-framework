<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="setBean2">
	<cfargument name="bean2" />
	<cfset variables._bean2 = arguments.bean2 />
</cffunction>
<cffunction name="getBean2">
	<cfreturn variables._bean2 />
</cffunction>

</cfcomponent>