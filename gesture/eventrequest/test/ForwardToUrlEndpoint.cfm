<cfparam name="url.someValue" default="" />

<cfset ec = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />

<cfset ec.setValue("someValue", url.someValue) />

<cfset ec.forwardToUrl(url.url, true, false) />
