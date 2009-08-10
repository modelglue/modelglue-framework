<cfset event.setValue("title", "Feeds")>
<cfset event.setValue("selected", "feeds")>
<cfset myProjects = event.getValue("myprojects")>
<cfset projects = event.getValue("projects", 0)>
<cfset settings = event.getValue("settings")>
<cfset root = event.getValue("myself")>
<cfset user = event.getValue("currentuser")>
<cfset auth = "u=#user.getUserName()#&p=#user.getPassword()#">
<cfset auth = urlEncodedFormat(encrypt(auth,settings.secretkey))>

<cfif structKeyExists(settings,"rssfeedsenabled") and settings.rssfeedsenabled><!--- only execute if rss feeds are turned on --->

	<!--- FF RSS Feed URLs --->
	<cfsavecontent variable="rssheader">
	<cfoutput>
	<link rel="alternate" type="application/rss+xml" title="All Projects" href="#root#page.rss&projects=0&auth=#auth#" />
	<link rel="alternate" type="application/rss+xml" title="All Projects (My Issues)" href="#root#page.rss&projects=-1&auth=#auth#" />
	</cfoutput>
	<cfif myProjects.recordCount>   
		<cfoutput query="myProjects">
		<link rel="alternate" type="application/rss+xml" title="#name#" href="#root#page.rss&projects=#id#&auth=#auth#" />
		</cfoutput>
	</cfif>
	</cfsavecontent>
	
	<cfhtmlhead text="#rssheader#">
	
	<h2 class="red">RSS Feeds</h2>
	<p>
	The follow links correspond to various RSS feeds for each of the projects you are assigned to. You can also
	subscribe to a link for all your projects or to a feed of just your issues.
	</p>
	
	<cfif myProjects.recordCount>
	
		<cfoutput>
		<p>
		<a href="#root#page.rss&projects=0&auth=#auth#">All Projects</a><br>
		<a href="#root#page.rss&projects=-1&auth=#auth#">All Projects (My Issues)</a><br>
		</cfoutput>
	
		<cfoutput query="myProjects">
			<a href="#root#page.rss&projects=#id#&auth=#auth#">#name#</a><br>
		</cfoutput>
		
		<cfoutput>
		</p>
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
		<p>
		There are no projects available for you.
		</p>
		</cfoutput>
	
	</cfif>

<cfelse>

	<h2 class="red">RSS Feeds</h2>
	<p>
	All RSS feeds have been disabled by the administrator.  Please contact your administrator for further information.
	</p>

</cfif>