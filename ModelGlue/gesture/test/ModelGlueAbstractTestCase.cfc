<cfcomponent extends="mxunit.framework.TestCase">

	<cfset this.coldspringPath = "/ModelGlue/gesture/eventrequest/url/test/ColdSpring.xml" />
	<cfset mg = "">

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	</cffunction>
	
	<cffunction name="createBootstrapper" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		<cfset var bootstrapper = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper")>
		<cfset bootstrapper.coldspringPath = arguments.coldspringPath>
		<cfset bootstrapper.coreColdspringPath = arguments.coldspringPath>
		<cfreturn bootstrapper>
	</cffunction>
	
	<cffunction name="createModelGlueIfNotDefined" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		<cfif isSimpleValue(mg)>
			<cfset createModelGlue(coldspringPath)>
		</cfif>
		<cfreturn mg>
	</cffunction>
	
	<cffunction name="createModelGlue" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		<cfset mg = createBootstrapper(coldspringPath).
					createModelGlue()>
		<cfreturn  mg>	
	</cffunction>

</cfcomponent>