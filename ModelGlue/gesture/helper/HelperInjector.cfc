<cfcomponent output="false" hint="I inject the ""helpers"" scope into a CFC.">

<cffunction name="init" output="false">
	<cfreturn this />
</cffunction>

<cffunction name="injectPath" output="false" hint="Injects files (.cfm or .cfc) from a path into a target cfc.  Not recursive.">
	<cfargument name="target" />
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
			<cfcatch>
				<cfthrow message="Couldn't add helper: #arguments.path#/#files.name#.  Have you tested it and made sure the file exists?" />
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
		
	<cfset arguments.target[helperFileName] = instance />
</cffunction>

</cfcomponent>