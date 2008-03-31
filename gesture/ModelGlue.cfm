<!--- 
	CORE_COLDSPRING_PATH is defined in Unity template and _IGNORED_ in Gesture.  
	
	This is a reverse compat break considered acceptable:  if you're using a custom
	version of the framework, a 100% automatic upgrade probably isn't in the cards
	to begin with!
--->
<cfparam name="ModelGlue_PARENT_BEAN_FACTORY" default="" />
<cfparam name="ModelGlue_APP_KEY" default="_modelglue" />
<cfparam name="ModelGlue_CONFIG_PATH" default="" />
<cfparam name="ModelGlue_LOCAL_COLDSPRING_PATH" default="./config/ColdSpring.xml" />
<cfparam name="ModelGlue_PARENT_BEAN_FACTORY" default="" />
<cfparam name="ModelGlue_VERSION_INDICATOR" default="GESTURE" />

<cfset request._modelglue.bootstrap = structNew() />
<cfset request._modelglue.bootstrap.initializationRequest = false />

<cfif not structKeyExists(application, ModelGlue_APP_KEY) 
			or (
					structKeyExists(url, application[ModelGlue_APP_KEY].configuration.reloadKey)
					and url[application[ModelGlue_APP_KEY].configuration.reloadKey] eq application[ModelGlue_APP_KEY].configuration.reloadPassword
			)>
	<cflock name="#expandPath(".")#/.modelglue.loading" type="exclusive" timeout="60">
		<cfif not structKeyExists(application, ModelGlue_APP_KEY)
					or (
							structKeyExists(url, application[ModelGlue_APP_KEY].configuration.reloadKey)
							and url[application[ModelGlue_APP_KEY].configuration.reloadKey] eq application[ModelGlue_APP_KEY].configuration.reloadPassword
					)>
			<cfset request._modelglue.bootstrap.initializationRequest = true />

			<cfset boot = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper") />

			<cfset boot.applicationKey = ModelGlue_APP_KEY />
			<cfset boot.coldspringPath = ModelGlue_LOCAL_COLDSPRING_PATH />
			<cfset boot.modelglueVersionIndicator = ModelGlue_VERSION_INDICATOR />
			<cfset boot.primaryModulePath = ModelGlue_CONFIG_PATH />
			<cfset boot.parentBeanFactory = ModelGlue_PARENT_BEAN_FACTORY />

			<cfset mg = boot.storeModelGlue() />
		<cfelse>
			<cfset mg = application[ModelGlue_APP_KEY] />
		</cfif>
	</cflock>
<cfelse>
	<cfset mg = application[ModelGlue_APP_KEY] />
</cfif>

<cfset ec = mg.handleRequest() />

<cfoutput>#ec.getLastRendereredView()#</cfoutput>

<cfif mg.configuration.debug neq "false" and mg.configuration.debug neq "none"> 
<cfoutput>
	#mg.renderContextLog(ec)#
</cfoutput>
</cfif>
