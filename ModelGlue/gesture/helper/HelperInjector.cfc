<cfcomponent output="false" hint="I inject the ""helpers"" scope into a CFC.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="setBeanInjector" access="public" returntype="void" hint="I set the bean injector to use.">
	<cfargument name="beanInjector" type="any" required="true" />
	<cfset variables._beanInjector = arguments.beanInjector />
</cffunction>

<cffunction name="injectPath" output="false" hint="Injects files (.cfm or .cfc) from a path into a target cfc.  Not recursive.">
	<cfargument name="target" hint="Structure into which helpers should be placed." />
	<cfargument name="path" />
	
	<cfset var files = "" />
	
	<cfdirectory action="list" directory="#expandPath(arguments.path)#" name="files">
	
	<cfloop query="files">
		<cftry>
			<cfif listLast(files.name, ".") eq "cfc">
				<cfset injectComponent(arguments.target, arguments.path & "/" & files.name) />
			<cfelseif listLast(files.name, ".") eq "cfm">
				<cfset injectInclude(arguments.target, arguments.path & "/" & files.name) />
			</cfif>
			<cfcatch type="coldfusion.runtime.TemplateNotFoundException">
				<cfthrow message="Couldn't add helper: #arguments.path#/#files.name#. It doesn't look like that file exists made sure the file exists? " />
			</cfcatch>
			<cfcatch>
				<cfthrow message="Couldn't add helper: #arguments.path#/#files.name# because of this: [#CFCatch.Detail#] I'm sorry it didn't work out. " />
			</cfcatch>
		</cftry>
	</cfloop>
</cffunction> 

<cffunction name="injectInclude" output="false" hint="Injects a file (""IncludeFile.cfm"")'s UDFs into a target cfc.">
	<cfargument name="target" />
	<cfargument name="template" />
	
	<cfset var helperPath = expandPath(arguments.template) />
	<cfset var helperFileName = listFirst(getFileFromPath(helperPath), ".") />
	<cfset var shell = createObject("component", "ModelGlue.gesture.helper.IncludeHelperShell").init(arguments.template) />
	
	<cfset arguments.target[helperFileName] = shell />
</cffunction>

<cffunction name="injectComponent" output="false" hint="Injects a component (""HelperComponent.cfc"")'s methods into a target cfc.">
	<cfargument name="target" />
	<cfargument name="componentPath" />
	
	<cfset var helperPath = expandPath(arguments.componentPath) />
	<cfset var helperFileName = listFirst(getFileFromPath(helperPath), ".") />
	<cfset var componentName = replaceNoCase(arguments.componentPath, "/", ".", "all") />
	<cfset var instance = "" />

	<cfif left(componentName, 1) eq ".">
		<cfset componentName = right(componentName, len(componentName) - 1) />
	</cfif>
		
	<cfset componentName = listDeleteAt(componentName, listLen(componentName, "."), ".") />
	
	<cfset instance = createObject("component", componentName) />
	
	<!--- Do not assume the helper component has an init() method, but if it does then call it --->
	<cfif StructKeyExists(instance, "init")>
		<cfset instance.init() />
	</cfif>
	
	<!--- Perform bean injection: Metadata --->
	<cfset variables._beanInjector.injectBeanByMetadata(instance) />
	
	<!--- Perform autowiring --->
	<cfset variables._beanInjector.autowire(instance) />

	<cfset arguments.target[helperFileName] = instance />
</cffunction>

</cfcomponent>