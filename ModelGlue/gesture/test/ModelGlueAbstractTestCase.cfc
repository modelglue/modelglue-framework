<cfcomponent extends="mxunit.framework.TestCase">

	<cfset this.coldspringPath = "/ModelGlue/gesture/test/ColdSpring.xml" />
	<cfset variables.mg = "">

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	</cffunction>
	
	<cffunction name="createBootstrapper" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		<cfset var bootstrapper = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper")>
		<cfset bootstrapper.coldspringPath = arguments.coldspringPath>
		<cfset bootstrapper.coreColdspringPath = arguments.coldspringPath>
		
		<cfset request._modelglue.bootstrap.bootstrapper = bootstrapper />
		<cfset request._modelglue.bootstrap.initializationRequest = true />
		<cfset request._modelglue.bootstrap.initializationLockPrefix = expandPath(".") & "/.modelglue" />
		<cfset request._modelglue.bootstrap.initializationLockTimeout = 60 />
		
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
		<cfset variables.mg = createBootstrapper(coldspringPath).
					createModelGlue()>
					
		<!--- load "test" application event definitions --->
		<cfset mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML").load( mg, expandPath("/ModelGlue/gesture/test/primaryModule.xml") ) />

		<cfset request._modelglue.bootstrap.framework = mg />
		
		<cfreturn  mg>	
	</cffunction>

</cfcomponent>