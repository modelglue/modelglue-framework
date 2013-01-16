<cfcomponent output="false" hint="I am a Model-Glue controller." extends="ModelGlue.gesture.controller.Controller">

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfargument name="framework" />
		<cfset var i = 0 />
		
		<cfset super.init(framework) />
		
		<!--- Duplicate the message listener function for the controller portion of the test --->
		<cfloop index="i" from="1" to="1000">
			<cfset this["doSomething#i#"] = this.doSomething />
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="doSomething" access="public" output="false" returntype="void" >
	   <cfargument name="event" type="any" required="true" />
	   
	   <cfset var listenCount = arguments.event.getValue( "listenCount", "0" ) />
	   <cfset var beanName = "" />
	   <cfset arguments.event.setValue( "listenCount", listenCount+1 ) />

	   <cfloop item="beanName" collection="#beans#">
		<cfset arguments.event.setValue( "lastBeanName", beanName ) />
		<cfif StructKeyExists(beans[beanName],"getDSN")>
			<cfset arguments.event.setValue( "lastBeanDSN", beans[beanName].getDSN() ) />
		</cfif>
	   </cfloop>
	
	   
	</cffunction>
	
</cfcomponent>
	
