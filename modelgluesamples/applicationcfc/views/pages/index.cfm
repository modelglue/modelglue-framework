<p>I'm an example of using the new "onApplicationStart", "onSessionStart", and "onSessionEnd" broadcasts.</p>

<cfoutput>
<p>
According to its controller, this app has <font color="green" size="+1"><strong>#event.getValue("sessionCount")#</strong></font> active session<cfif event.getValue("sessionCount") gt 1>s</cfif>.  If you open a second type of browser or browse from another computer, you should see this number go up when you reload.
</p>
</cfoutput>

<p>To listen for any of these events, just add a message listener tag to any of your controllers:</p>

<pre>
&lt;controller id="Controller" type="modelgluesamples/applicationcfc.controller.Controller">
	&lt;message-listener message="onApplicationStart" function="onApplicationStart" />
	&lt;message-listener message="onRequestStart" function="getSessionCount" />
	&lt;message-listener message="onSessionStart" function="onSessionStart" />
	&lt;message-listener message="onSessionEnd" function="onSessionEnd" />
&lt;/controller>
</pre>

<p>Like any other message broadcast, you can have as many listener functions as you desire.</p>

