<cfsilent>
    <cfset endTime = getTickCount() />
    <cfset totalTime = endTime - request.startTime />

	<!--- Push this value into the event state to make it easier to create an app init event link --->
	<cfset event.setValue('init','true') />
</cfsilent>

<cfoutput>

	<h2>#GetFileFromPath(GetBaseTemplatePath())#</h2>
	<p>
		Number of Additional Controllers: #request.numControllers#<br>
		Number of Additional Event Handlers: #request.numEventHandlers#<br>
		<br>
		<b>#event.getEventHandlerName()#</b><br>
		Number of 'needSomething' Listener Invocations: #event.getValue('listenCount','0')#<br>
		Last bean name: #event.getValue('lastBeanName')#<br>
		Last bean DSN: #event.getValue('lastBeanDSN')#<br>
		Start time: #request.startTime# <br>
		End time: #endTime#<br>
		Total time: #totalTime# ms
	</p>

	<p>
		<a href="#event.linkTo('page.broadcast')#">Test Broadcast</a>
		| <a href="#event.linkTo('page.index')#">Test Home</a>
		| <a href="#event.linkTo('page.index','init')#">Reload Test App</a>
		| <a href="index.cfm">Test Suite Home</a>
	</p>
	
	<table cellspacing="5" cellpadding="5">
		<tr>

		<cfloop from="1" to="10" index="col">
			<cfset startEh = ((col-1) * 100) + 1 />
			<cfif startEh lte request.numEventHandlers>
			<td>
				<cfloop from="#startEh#" to="#(startEh+99)#" index="i">
					<cfif i lte request.numEventHandlers>
						<a href="#event.linkTo('event#i#')#">Event #i#</a><br>
					</cfif>
				</cfloop>
			</td>
			</cfif>
		</cfloop>
		
		</tr>
	
	</table>
	
</cfoutput>