<cfcomponent output="false" hint="A lo-fi ColdFusion code generator that uses content with ""<cg"" tags and ""<=--"" comments instead of XML or templating.">

<cffunction name="init" output="false">
</cffunction>

<cffunction name="clean" output="false">
	<cfargument name="content" />
	
	<cfset arguments.content = replaceNoCase(content, "<cg", "<cf", "all") />
	<cfset arguments.content = replaceNoCase(content, "</cg", "</cf", "all") />
	<cfset arguments.content = replaceNoCase(content, "<=--", "<!--", "all") />
	
	<cfreturn content />
</cffunction>

<cffunction name="write" output="false">
	<cfargument name="filename" />
	<cfargument name="content" />

	<cfif not directoryExists(getDirectoryFromPath(arguments.filename))>
		<cfdirectory action="create" directory="#getDirectoryFromPath(arguments.filename)#" mode="777" />
	</cfif>

	<cffile action="write" file="#arguments.filename#" output="#arguments.content#" mode="777" />
</cffunction>

<cffunction name="writeXML" output="false">
	<cfargument name="filename" />
	<cfargument name="content" />

	<cfset var builder = "" />
	<cfset var format = "" />
	<cfset var out = "" />
	<cfset var xml = "" />
	<cfset var xsl = "" />
	<cfset var document = "" />
	<cfset var fileInStream = "" />
	<cfset var fileOutStream = "" />
	<cfset var fileObj = "" />
	<cfset var system = "" />
	
	<cfset fileObj = createObject("java", "java.io.File").init(filename) />

	<!--- Write it, read it to a jdom doc rather than ColdFusion node list, then pretty it --->
	<cfset write(filename, content) />

	<!--- Only do the formatting if capable. --->
	<cftry>	
		<cfset builder = createObject("java", "org.jdom.input.SAXBuilder").init() />
		<cfset format = createObject("java", "org.jdom.output.Format").getPrettyFormat() />
		<cfset format.setIndent("	") />
		<cfset out = createObject("java", "org.jdom.output.XMLOutputter").init(format) />
		<cfset fileObj = createObject("java", "java.io.File").init(filename) />
		<cfset fileInStream = createObject("java", "java.io.FileInputStream").init(fileObj) />
		
		<cfset system = createObject("java", "java.lang.System") />
		
		<cfset document = builder.build(fileInStream) />
		
		<cfset fileInStream.close() />
		
		<cfset fileOutStream = createObject("java", "java.io.FileOutputStream").init(fileObj) />
		
		<cfset out.output(document, fileOutStream) />
	
		<cfset fileOutStream.close() />
		<cfcatch>
			<!--- Fail siliently. --->
		</cfcatch>
	</cftry>
</cffunction>


</cfcomponent>