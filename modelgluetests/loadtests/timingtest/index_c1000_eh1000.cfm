<cfsilent>

<!--- Number of additional controllers and event handlers to load for this test --->
<cfset request.numControllers = 1000 />
<cfset request.numEventHandlers = 1000 />

<!--- Define a key for the framework that won't conflict with the other tests in this suite ---> 
<cfset ModelGlue_APP_KEY = "c#request.numControllers#_eh#request.numEventHandlers#" />

<!--- Configure framework with a custom ModelGlue.xml path and index.cfm that corresponds to this test --->
<cfset ModelGlue_LOCAL_COLDSPRING_DEFAULT_PROPERTIES = StructNew() />
<cfset ModelGlue_LOCAL_COLDSPRING_DEFAULT_PROPERTIES.modelglueXmlPath = "config/ModelGlue_#ModelGlue_APP_KEY#.xml" />
<cfset ModelGlue_LOCAL_COLDSPRING_DEFAULT_PROPERTIES.defaultTemplate = GetFileFromPath(GetCurrentTemplatePath()) />

</cfsilent><cfinclude template="/ModelGlue/gesture/ModelGlue.cfm" />