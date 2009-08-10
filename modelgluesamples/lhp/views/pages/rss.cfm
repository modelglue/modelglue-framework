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

<cfcontent type="text/xml"><cfoutput><?xml version="1.0" encoding="iso-8859-1"?>

<rdf:RDF 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://purl.org/rss/1.0/"
>
	<channel rdf:about="#lighthouseProURL#">
	<title>#title#</title>
	<description>Lighthouse Pro Bug Tracker</description>
	<link>#lighthouseProURL#</link>
	
	<items>
		<rdf:Seq>
			<cfloop query="issues">
			<rdf:li rdf:resource="#lighthouseProURL#/view.cfm?#xmlFormat("id=#id#")#" />
			</cfloop>
		</rdf:Seq>
	</items>
	
	</channel>
</cfoutput>

		<cfloop query="issues">
		<cfset dateStr = dateFormat(updated,"yyyy-mm-dd")>
		<cfset dateStr = dateStr & "T" & timeFormat(updated,"HH:mm:ss") & "-" & numberFormat(z.utcHourOffset,"00") & ":00">
		<cfoutput>
  	<item rdf:about="#lighthouseProURL#/view.cfm?#xmlFormat("id=#id#")#">
	<title>Project: #xmlFormat(projectname)# / Issue #publicid#: #xmlFormat(name)#</title>
	<description><cfif len(description) gte 500>#xmlFormat(left(description,500))#...<cfelse>#xmlFormat(description)#</cfif></description>
	<link>#lighthouseProURL#/view.cfm?#xmlFormat("id=#id#")#</link>
	<dc:date>#dateStr#</dc:date>
	<dc:subject></dc:subject>
	</item>
		</cfoutput>
	 	</cfloop>

<cfoutput>
</rdf:RDF>
</cfoutput>

