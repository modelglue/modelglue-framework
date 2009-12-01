<cfsetting enablecfoutputonly=true showdebugoutput=false>
<cfset issues = event.getValue("issues")>
<cfset title = event.getValue("title")>

<cfif isBoolean(cgi.server_port_secure) and cgi.server_port_secure>
	<cfset lighthouseProURL = "https://">
<cfelse>
	<cfset lighthouseProURL = "http://">
</cfif>
<cfset lighthouseProURL = lighthouseProURL & cgi.server_name>
<cfif cgi.server_port neq 80>
	<cfset lighthouseProURL = lighthouseProURL & ":" & cgi.server_port>
</cfif>	
<cfset lighthouseProURL = lighthouseProURL & listDeleteAt(cgi.script_name, listlen(cgi.script_name,"/"), "/")>

<cfset z = getTimeZoneInfo()>
<cfif not find("-", z.utcHourOffset)>
	<cfset utcPrefix = " -">
<cfelse>
	<cfset z.utcHourOffset = right(z.utcHourOffset, len(z.utcHourOffset) -1 )>
	<cfset utcPrefix = " +">
</cfif>

<cfsavecontent variable="rss">
<cfoutput>
<rss version="2.0" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##">
<channel>
<title>#title#</title>
<link>#lighthouseProURL#</link>
<description>Lighthouse Pro Bug Tracker</description>
<language>en-us</language>
<pubDate>#dateFormat(now(),"ddd, dd mmm yyyy") & " " & timeFormat(now(),"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00"#</pubDate>
<cfif issues.recordCount>
<lastBuildDate>{LAST_BUILD_DATE}</lastBuildDate>
</cfif>
<generator>Lighthouse Pro</generator>
<cfloop query="issues">
<cfset dateStr = dateFormat(updated,"yyyy-mm-dd")>
<cfset dateStr = dateStr & "T" & timeFormat(updated,"HH:mm:ss") & "-" & numberFormat(z.utcHourOffset,"00") & ":00">
<item>
<title>Project: #xmlFormat(projectname)# / Issue #publicid#: #xmlFormat(name)#</title>
<link>#lighthouseProURL#/index.cfm?event=page.viewissue#xmlFormat("&id=#id#")#</link>
<description><cfif len(description) gte 500>#xmlFormat(left(description,500))#...<cfelse>#xmlFormat(description)#</cfif></description>
<pubDate>#dateStr#</pubDate>
<guid>#lighthouseProURL#/index.cfm?event=page.viewissue#xmlFormat("&id=#id#")#</guid>
</item>
</cfloop>
</channel></rss>

</cfoutput>
</cfsavecontent>

<cfif issues.recordCount>
	<cfset rss = replace(rss,'{LAST_BUILD_DATE}','#dateFormat(issues.updated[1],"ddd, dd mmm yyyy") & " " & timeFormat(issues.updated[1],"HH:mm:ss") & utcPrefix & numberFormat(z.utcHourOffset,"00") & "00"#','one')>
</cfif>

<cfcontent type="text/xml"><cfoutput><?xml version="1.0" encoding="iso-8859-1"?>#rss#</cfoutput>
