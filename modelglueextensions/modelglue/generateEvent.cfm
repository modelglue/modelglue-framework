<cfsilent>
	<cfset event.copyToScope(variables, "eventName,CFUniformConfig,eventGenerationConfig,eventHandlerNames,eventTypeNames") />
	
	<cfset eventDefaults = structNew() />
	<cfset eventDefaults.eventType = eventGenerationConfig.eventType />
	<cfset eventDefaults.generateView = eventGenerationConfig.generateView />
	<cfset eventDefaults.viewLocation = eventGenerationConfig.viewLocationPrefix & evaluate(eventGenerationConfig.viewLocationFunction) & eventGenerationConfig.viewLocationSuffix />
	<cfset eventDefaults.viewFileName = eventGenerationConfig.viewFilePrefix & evaluate(eventGenerationConfig.viewFileFunction) & eventGenerationConfig.viewFileSuffix />
	<cfset eventDefaults.generateMessageListener = eventGenerationConfig.generateMessageListener />
	<cfset eventDefaults.controllerFileName = eventGenerationConfig.controllerFilePrefix & evaluate(eventGenerationConfig.controllerFileFunction) & eventGenerationConfig.controllerFileSuffix />
	<cfset eventDefaults.messageListenerName = eventGenerationConfig.messageListenerPrefix & evaluate(eventGenerationConfig.messageListenerFunction) & eventGenerationConfig.messageListenerSuffix />
	<cfset eventDefaults.resultEvent = eventGenerationConfig.resultEvent />
	<cfset eventDefaults.resultRedirect = eventGenerationConfig.resultRedirect />
	
	<cfset formAction = event.linkTo(eventName) />
	
	<cfset event.addCSSAssetFile( "ui/css/smoothness/jquery-ui-1.8.custom.css" ) />
	<cfset event.addCSSAssetFile( "multiSelect/css/jquery.multiselect.css" ) />
	<cfset event.addCSSAssetFile( "generateEvent.css" ) />
	
	<cfset event.addJSAssetFile( "core/jquery-1.4.2.min.js" ) />
	<cfset event.addJSAssetFile( "ui/js/jquery-ui-1.8.custom.min.js" ) />
	<cfset event.addJSAssetFile( "multiSelect/js/jquery.multiselect.min.js" ) />
	<cfset event.addJSAssetFile( "generateEvent.js" ) />
	
	<cfsavecontent variable="arrayJS"><cfoutput><script type="text/javascript">
		var eventHandlerNames = ['#listChangeDelims(arrayToList(eventHandlerNames), "','")#'];
	</script></cfoutput></cfsavecontent>
	
	<cfset event.addJSAssetCode(arrayJS)>
	
	<cfimport prefix="uform" taglib="/modelglueextensions/cfuniform/tags/forms/cfUniForm/" />
</cfsilent>

<cfoutput><h1>#eventName# Event Generation Settings</h1></cfoutput>
<uform:form action="#formAction#" id="eventGenerationForm" attributecollection="#CFUniformConfig#" submitValue=" Generate Event " cssLoadVar="uformCSS" jsLoadVar="uformJS">
	<uform:fieldset>
		<uform:field type="select" name="typeSelect" label="Event Type(s)" inputClass="multiselect">
			<uform:option display="Select Event Type(s)" value="" />
			
			<cfloop from="1" to="#arrayLen(eventTypeNames)#" index="index">
				<uform:option display="#eventTypeNames[index]#" value="#eventTypeNames[index]#" isSelected="#eventDefaults.eventType eq eventTypeNames[index]#" />
			</cfloop>
		</uform:field>
		
		<uform:field type="text" name="type" label="" value="#eventDefaults.eventType#" />
		
		<uform:field type="select" name="generateView" label="Generate View?">
			<uform:option display="Yes" value="1" isSelected="#eventDefaults.generateView#" />
			<uform:option display="No" value="0" isSelected="#!eventDefaults.generateView#" />
		</uform:field>
	</uform:fieldset>
	
	<uform:fieldset>		
		<uform:field type="text" name="viewLocation" label="View File Location" value="#eventDefaults.viewLocation#" />
		
		<uform:field type="text" name="viewFileName" label="View File Name" value="#eventDefaults.viewFileName#" />
	</uform:fieldset>
	
	<uform:fieldset>
		<uform:field type="select" name="generateMessageListener" label="Generate Message Listener?">
			<uform:option display="Yes" value="1" isSelected="#eventDefaults.generateMessageListener#" />
			<uform:option display="No" value="0" isSelected="#!eventDefaults.generateMessageListener#" />
		</uform:field>
	</uform:fieldset>
	
	<uform:fieldset>
		<uform:field type="text" name="messageListenerName" label="Message Listener Name" value="#eventDefaults.messageListenerName#" />
		
		<uform:field type="text" name="controllerFileName" label="Controller File Name" value="#eventDefaults.controllerFileName#" />
		
		<uform:field type="text" name="controllerFunctionName" label="Controller Function Name" value="#eventDefaults.messageListenerName#" />		
	</uform:fieldset>
	
	<uform:fieldset>
		<uform:field type="text" name="resultEvent" label="Result Event" value="#eventDefaults.resultEvent#" />
		
		<uform:field type="select" name="resultRedirect" label="Result Redirects?">
			<uform:option display="Yes" value="1" isSelected="#eventDefaults.resultRedirect#" />
			<uform:option display="No" value="0" isSelected="#!eventDefaults.resultRedirect#" />
		</uform:field>
	</uform:fieldset>
</uform:form>

<cfset event.addCSSAssetCode( uformCSS ) />
<cfset event.addJSAssetCode( uformJS ) />