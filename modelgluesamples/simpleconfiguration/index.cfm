<cfsilent>
<!---
	If you want to run multiple MG applications under the same
	application name, change this value to something unique
	to this application to prevent them from colliding in the 
	application scope.
	
	<cfset ModelGlue_APP_KEY = "mySubapplication" />
--->

<!---
	**CUSTOM APPLICATION CONFIGURATION**
	
  If your path to ColdSpring.xml is custom, change it here.  Otherwise,
  it will default to Config/ColdSpring.xml
	
	<cfset ModelGlue_LOCAL_COLDSPRING_PATH = expandPath(".") & "/config/ColdSpring.xml" />
--->

<!---
	**SCAFFOLDING CONFIGURATION**
	
  If your application uses custom scaffolding settings, change this to set the location
	of your ScaffoldingConfiguration.xml file
	
	<cfset ModelGlue_SCAFFOLDING_CONFIGURATION_PATH = expandPath("/ModelGlue/unity/config/ScaffoldingConfiguration.xml") />
--->

<!---
	**CUSTOM CORE CONFIGURATION**

  If your path to /modelglue/unity/config/Configuration.xml is custom, change it here.  Otherwise,
  it will default to /modelglue/unity/config/Configuration.xml

	<cfset ModelGlue_CORE_COLDSPRING_PATH = expandPath("/ModelGlue/unity/config/Configuration.xml") />
--->

<!---
	**HIERARCHIAL BEAN FACTORY SUPPORT**

	If you'd like to designate a parent bean factory for the one that powers Model-Glue,
	simply do whatever you need to do to set the following value to the parent bean factory 
	instance:
	
	<cfset ModelGlue_PARENT_BEAN_FACTORY = ??? />
--->


<!--- If your path to ModelGlue.cfm is different, you'll need to change this line. --->
</cfsilent><cfinclude template="/ModelGlue/gesture/ModelGlue.cfm" />