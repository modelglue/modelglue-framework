<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller" beans="issueService,projectService,severityService,statusService,issuetypeService,projectAreaService,milestoneService,userService,mailService,applicationSettings">

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfargument name="framework" />
		<cfset var rootDir = getDirectoryFromPath(getCurrentTemplatePath()) & "../">

		<cfset super.init(framework) />

		<cfset variables.attachmentPath = rootDir & "attachments">
		<cfif not directoryExists(variables.attachmentPath)>
			<cftry>
				<cfdirectory action="create" directory="#variables.attachmentpath#">
				<cfcatch>
					<cfthrow message="LighthousePro was unable to create the attachment directory: #variables.attachmentpath#">
				</cfcatch>
			</cftry>
		</cfif>		

		<cfreturn this />
	</cffunction>
	
	<cffunction name="deleteAttachment" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var issueid = arguments.event.getValue("issue")>
		<cfset var attachmentid = arguments.event.getValue("attachmentid")>
		<cfset var issue = beans.issueService.getIssue(issueid)>
		<cfset var myprojects = arguments.event.getValue("myprojects")>
		<cfset var attachments = issue.getAttachments()>
		
		<cfset arguments.event.setValue("id", issueid)>
		<cfset arguments.event.setValue("pid", issue.getProjectIdFk())>
		
		<!--- does the issue belong to a project I can use? --->
		<cfif not listFind(valueList(myprojects.id), issue.getProjectIdFK())>
			<cfreturn>
		</cfif>

		<!--- now check the attachements --->
		<cfloop query="attachments">
			<cfif id is attachmentid>
				<cffile action="delete" file="#variables.attachmentPath#/#filename#">
				<cfset issue.removeAttachment(attachmentid)>
			</cfif>
		</cfloop>

	</cffunction>

	<cffunction name="deleteIssueType" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var markedtodie = arguments.event.getValue("mark")>
		<cfset beans.issueTypeService.deleteIssueTypes(markedtodie)>
	</cffunction>

	<cffunction name="doMailProcess" access="public" output="true">
		<cfargument name="event" type="any">		

		<!--- First, get projects that have mail settings. --->
		<cfset var projects = beans.projectService.getMailProjects()>
		<cfset var projectid = "">
		<cfset var ms = "">
		<cfset var mu = "">
		<cfset var mp = "">
		<cfset var me = "">
		<cfset var mail = "">
		<cfset var issue = "">
		<cfset var thefile = "">
		<cfset var history = "">
		<cfset var originalfilename = "">
		<cfset var extension = "">
		<cfset var newfilename = "">
		<cfset var deleteMail = "">
		<cfset var email = "">
		
		<cfif not projects.recordCount>
			<cfreturn>
		</cfif>
		
		<cfloop query="projects">
	
			<cfset projectid = id>
			<cfset ms = mailserver>
			<cfset mu = mailusername>
			<cfset mp = mailpassword>
			<cfset me = mailemailaddress>

			<cfpop server="#mailserver#" username="#mailusername#" password="#mailpassword#" name="mail" action="getAll"
				   attachmentPath="lhp">
			<cfloop query="mail">
			
				<!--- 
				Note that an account may have aliases, check the mail email address we specifically asked for.
				Also note that sometimes mail will look like this:
					Formalname <email address>
				I'm going to take an easy way and just look for ME inside the string. That
				should be fine I believe.

				--->
				<cfif findNoCase(me, to)>
					<!--- make a new issue bean --->
					<cfset issue = beans.issueService.getIssue()>
					<cfset issue.setProjectIDFK(projectid)>
					<cfset issue.setName("MAIL ISSUE: " & subject)>
					<cfset history = "Created by email from #from# : #dateFormat(now(),'mm/dd/yy')# #timeFormat(now(),'h:mm tt')#">
					<cfset issue.setHistory(history)>
					<cfset issue.setDescription(body)>
					<cfset issue.setCreated(now())>
					<cfset issue.setUpdated(now())>
					<cfset issue = beans.issueService.saveIssue(issue)>
				
					<!--- handle attachments --->
					<cfif len(attachmentfiles)>
						<!--- We can have N attachments seperated by  tab. --->
						<cfloop index="thefile" list="#attachmentfiles#" delimiters="#chr(9)#">
							<cfif fileExists(thefile)>
								<!--- 
								We need to copy to attachment path, but make unique. Because I'm not CFLOCKING
								in the front end, it won't help much to lock here. BUT - now that I've added
								support to remember the original file name, it doesn't matter what file name
								I use on the file system. Therefore I'll just UUID the file.
								--->
								<cfset originalfilename = getFileFromPath(thefile)>
								<cfif listLen(originalfilename,".") gte 2>
									<cfset extension = "." & listLast(originalfilename, ".")>
								<cfelse>
									<cfset extension = "">
								</cfif>
								
								<cfset newfilename = replace(createUUID(), "-", "_", "all") & extension>
								<cffile action="move" source="#thefile#" destination="#variables.attachmentpath#/#newfilename#">
								<cfset issue.addAttachment(originalfilename, newfilename)>	
							</cfif>
						</cfloop>
					</cfif>

					<cfset emailNotifications(issue)>
					<cfpop server="#ms#" username="#mu#" password="#mp#" name="mail" action="delete" uid="#uid#">
				<cfelse>

					<!--- Added 10/09/2008 by Tjarko Rikkerink, also delete all mail not in ANY project defined to keep a clean inbox. --->
					<cfset deleteMail = true />
					<cfloop list="#valuelist(projects.mailemailaddress)#" index="email">
						<cfif findNoCase(email, to)>
							<cfset deleteMail = false />
							<cfbreak>
						</cfif>
					</cfloop>
					
					<cfif deleteMail>
						<cfpop server="#ms#" username="#mu#" password="#mp#" name="mail" action="delete" uid="#uid#">
					</cfif>
	
				</cfif>
	
			</cfloop>

		</cfloop>
	
	</cffunction>
	
	<cffunction name="emailNotifications" access="public" returnType="void" output="false"
				hint="Sends an email to those subscribed to the projects. Now also emails owner.">
		<cfargument name="issueBean" type="any" required="true">
		<cfargument name="oldBean" type="any" required="false">
		<cfset var projectid = arguments.issueBean.getProjectIDFK()>
		<cfset var project = beans.projectService.getProject(projectid)>
		<cfset var emails = "">
		<cfset var user = "">
		<cfset var olduser = "">
		<cfset var locus = "Not Defined">
		<cfset var oldlocus = "">
		<cfset var status = "Not Defined">
		<cfset var oldstatus = "">
		<cfset var severity = "Not Defined">
		<cfset var issuetype = "Not Defined">
		<cfset var milestone = "Not Defined">
		<cfset var oldmilestone = "">
		<cfset var oldissuetype = "">
		<cfset var oldseverity = "">
		<cfset var oldduedate = "">
		<cfset var mailbody = "">
		<cfset var root = "">
		<cfset var creator = "">
		<cfset var subject = "">
		<cfset var timezone = "">
		<cfset var offset = "">
		<cfset var replyby = "">
		<cfset var doReplyBy = false>
		<cfset var fromName = "">
		<cfset var link = "">
		<cfset var textMailBody = "">
		<cfset var htmlMailBody = "">
		
		<cfif arguments.issueBean.getStatusIDFK() neq "">
			<cfset status = beans.statusService.getStatus(arguments.issueBean.getStatusIDFK()).getName()>
		</cfif>

		<cfif arguments.issueBean.getSeverityIDFK() neq "">
			<cfset severity = beans.severityService.getSeverity(arguments.issueBean.getSeverityIDFK()).getName()>
		</cfif>

		<cfif arguments.issueBean.getIssueTypeIDFK() neq "">
			<cfset issuetype = beans.issueTypeService.getIssueType(arguments.issueBean.getIssueTypeIDFK()).getName()>
		</cfif>

		<cfif arguments.issueBean.getMilestoneIDFK() neq "">
			<cfset milestone = beans.milestoneService.getMileStone(arguments.issueBean.getMilestoneIDFK()).getName()>
		</cfif>
		
		<cfset emails = project.getSubscribedUsers()>

		<cfif arguments.issueBean.getUserIDFK() neq "">
			<cfset user = beans.userService.getUser(arguments.issueBean.getUserIdFk())>
		</cfif>
		
		<!--- Emails is a query with people who subscribed. But we also want to add owner/creator. --->
		<!--- We also want to potentially add an OLD owner since he may be off the bug now. --->
		<!--- First see if user is in the list. --->
		<cfif isObject(user) and not listFindNoCase(valueList(emails.emailaddress), user.getEmailAddress())>
			<cfset queryAddRow(emails)>
			<cfset querySetCell(emails, "emailaddress", user.getEmailAddress())>
		</cfif>

		<cfif arguments.issueBean.getCreatorIDFK() neq "">
			<cfset creator = beans.userService.getUser(arguments.issueBean.getCreatorIdFk())>
		</cfif>
	
		<!--- now see if creator is in there --->
		<cfif isObject(creator) and len(creator.getEmailAddress()) and not listFindNoCase(valueList(emails.emailaddress), creator.getEmailAddress())>
			<cfset queryAddRow(emails)>
			<cfset querySetCell(emails, "emailaddress", creator.getEmailAddress())>
		</cfif>

		
		<cfif arguments.issueBean.getLocusIDFK() neq "">
			<cfset locus = beans.projectAreaService.getProjectArea(arguments.issueBean.getLocusIdFk())>
		</cfif>

		<cfif isDefined("arguments.oldBean")>
			<cfif arguments.oldBean.getLocusIDFK() neq "">
				<cfset oldlocus = beans.projectAreaService.getProjectArea(arguments.oldBean.getLocusIdFk())>
			</cfif>
			<cfif arguments.oldBean.getMilestoneIDFK() neq "">
				<cfset oldmilestone = beans.milestoneService.getMilestone(arguments.oldBean.getMilestoneIDFK())>
				<cfset oldmilestone = oldmilestone.getName()>
			</cfif>
			<cfif arguments.oldBean.getUserIDFK() neq "">
				<cfset olduser = beans.userService.getUser(arguments.oldBean.getUserIdFk())>
			</cfif>
			<cfif arguments.oldBean.getStatusIDFK() neq "">
				<cfset oldStatus = beans.statusService.getStatus(arguments.oldBean.getStatusIdFk()).getName()>
			</cfif>
			<cfif arguments.oldBean.getSeverityIDFK() neq "">
				<cfset oldseverity = beans.severityService.getSeverity(arguments.oldBean.getSeverityIDFK()).getName()>
			</cfif>
			<cfif arguments.oldBean.getIssueTypeIDFK() neq "">
				<cfset oldissuetype = beans.issueTypeService.getIssueType(arguments.oldBean.getIssueTypeIDFK()).getName()>
			</cfif>
			<cfif arguments.oldBean.getDueDate() neq "">
				<cfset oldduedate = arguments.oldBean.getDueDate()>
			</cfif>

		</cfif>

		<!--- last but not least, if old user, check him --->
		<cfif not isSimpleValue(olduser) and len(oldUser.getEmailAddress()) and not listFindNoCase(valueList(emails.emailaddress), oldUser.getEmailAddress())>
			<cfset queryAddRow(emails)>
			<cfset querySetCell(emails, "emailaddress", oldUser.getEmailAddress())>
		</cfif>
		
		<!--- if emails is at RC 0, split --->
		<cfif emails.recordCount is 0>
			<cfreturn>
		</cfif>

		<cfif isBoolean(cgi.server_port_secure) and cgi.server_port_secure>
			<cfset link = "https://">
		<cfelse>
			<cfset link = "http://">
		</cfif>

		<cfset root = cgi.script_name>
		<!---
		 root is now, /lighthousepro/something.cfm or another.
		 We just want /lhp
		--->
		<cfset root = listDeleteAt(root, listLen(root, "/"), "/")>

		<!--- Fix by Sebastien Portefaix --->
		<cfset link = link & cgi.server_name>
		  
		<cfif cgi.server_port neq '80'> 
		    <cfset link = link & ':' & cgi.server_port>
		</cfif>
		<cfset link = link & "#root#/index.cfm?event=page.viewissue&id=#issueBean.getID()#">  
<cfsavecontent variable="textmailbody">
<cfoutput>
Lighthouse Pro Notification

============================================

Project: #project.getname()#

Issue: #issueBean.getPublicID()#) #issueBean.getName()# <cfif isDefined("arguments.oldBean") and issueBean.getName() neq arguments.oldBean.getName()> (was #arguments.oldBean.getName()#)</cfif>

Project Area: <cfif isObject(locus)>#locus.getName()#<cfelse>#locus#</cfif> <cfif isObject(oldLocus) and isObject(locus) and locus.getName() neq oldLocus.getName()> (was #oldLocus.getName()#)</cfif>

Milestone: <cfif len(issueBean.getMilestoneIDFK())>#milestone#</cfif> <cfif isDefined("arguments.oldBean") and milestone neq oldmilestone and oldmilestone neq ""> (was #oldmilestone#)</cfif>

Severity: #severity# <cfif isDefined("arguments.oldBean") and severity neq oldseverity and oldseverity neq ""> (was #oldseverity#)</cfif>

Status: #status# <cfif isDefined("arguments.oldBean") and status neq oldstatus and oldstatus neq ""> (was #oldstatus#)</cfif>

Due Date: <cfif len(issueBean.getDueDate())>#dateFormat(issueBean.getDueDate(), "m/d/yy")#</cfif><cfif isDefined("arguments.oldBean") and len(oldduedate)> was #dateFormat(oldduedate, "m/d/yy")#</cfif>

Type: #issuetype# <cfif isDefined("arguments.oldBean") and issuetype neq oldissuetype and oldissuetype neq ""> (was #oldissuetype#)</cfif>

Related URL: #issueBean.getRelatedURL()#
	
Creator: <cfif isObject(creator) and len(creator.getName())>#creator.getName()#</cfif>

Created: #dateFormat(issueBean.getCreated(),"m/d/yy")# #timeFormat(issueBean.getCreated(),"h:mm tt")#

Updated:#dateFormat(issueBean.getUpdated(),"m/d/yy")# #timeFormat(issueBean.getUpdated(),"h:mm tt")#

Owner: <cfif isObject(user)>#user.getName()# <cfif isObject(oldUser) and user.getName() neq oldUser.getName()> (was #oldUser.getName()#)</cfif></cfif>

Description: #issueBean.getDescription()#

History: #issueBean.getHistory()#

Link: #link#
Log into Lighthouse to update issue

This email was generated by Lighthouse Pro, an open-source ColdFusion bug tracker application created by Raymond Camden. Find more information at the Lighthouse Pro web site: http://lighthousepro.riaforge.org
</cfoutput>
</cfsavecontent>
<cfsavecontent variable="HTMLmailbody">
<cfoutput>
<html>
<head>
<title>Lighthouse Pro Notification</title>
<style type="text/css">
	body {font-family:verdana, helvetica, arial, sans-serif;margin:0;padding:0;}
	h1 {background:##B82619;padding:.3em;margin:0;font-style:italic;}
	h1 span {color:##fff;}
	dl {border-top:15px solid ##000;padding:1em;background:##E6DFCF;overflow:auto;margin:0;}
	dt,dd {float:left;margin:.5em 0 0 0;font-size:small;}
	dt {clear:left;width:15%;font-weight:bold;text-align:right;padding-right:.5em;}
	dd {width:80%;}
	p.footnote {clear:both; margin:0;font-size:small;padding:.5em;}
</style>
</head>

<body>
<h1>Lighthouse <span>Pro</span> Notification</h1>
<dl>
	<dt>Project:</dt>
	<dd>#project.getname()#</dd>
	<dt>Issue:</dt>
	<dd>#issueBean.getPublicID()#) #issueBean.getName()# <cfif isDefined("arguments.oldBean") and issueBean.getName() neq arguments.oldBean.getName()> (was #arguments.oldBean.getName()#)</cfif></dd>
	<dt>Project Area:</dt>
	<dd><cfif isObject(locus)>#locus.getName()#<cfelse>#locus#</cfif> <cfif isObject(oldLocus) and isObject(locus) and locus.getName() neq oldLocus.getName()> (was #oldLocus.getName()#)</cfif></dd>
	<dt>Milestone:</dt>
	<dd><cfif len(issueBean.getMilestoneIDFK())>#milestone#</cfif> <cfif isDefined("arguments.oldBean") and milestone neq oldmilestone and oldmilestone neq ""> (was #oldmilestone#)</cfif></dd>
	<dt>Severity:</dt>
	<dd>#severity# <cfif isDefined("arguments.oldBean") and severity neq oldseverity and oldseverity neq ""> (was #oldseverity#)</cfif></dd>
	<dt>Status:</dt>
	<dd>#status# <cfif isDefined("arguments.oldBean") and status neq oldstatus and oldstatus neq ""> (was #oldstatus#)</cfif></dd>
	<dt>Due Date:</dt>
	<dd><cfif len(issueBean.getDueDate())>#dateFormat(issueBean.getDueDate(), "m/d/yy")#</cfif><cfif isDefined("arguments.oldBean") and len(oldduedate)> was #dateFormat(oldduedate, "m/d/yy")#</cfif></dd>
	<dt>Type:</dt>
	<dd>#issuetype# <cfif isDefined("arguments.oldBean") and issuetype neq oldissuetype and oldissuetype neq ""> (was #oldissuetype#)</cfif></dd>
	<dt>Related URL:</dt>
	<dd><cfif len(issueBean.getRelatedURL())><a href="#issueBean.getRelatedURL()#">#issueBean.getRelatedURL()#</a></cfif></dd>
	<dt>Creator:</dt>
	<dd><cfif isObject(creator) and len(creator.getName())>#creator.getName()#</cfif></dd>
	<dt>Created:</dt>
	<dd>#dateFormat(issueBean.getCreated(),"m/d/yy")# #timeFormat(issueBean.getCreated(),"h:mm tt")#</dd>
	<dt>Updated:</dt>
	<dd>#dateFormat(issueBean.getUpdated(),"m/d/yy")# #timeFormat(issueBean.getUpdated(),"h:mm tt")#</dd>
	<dt>Owner:</dt>
	<dd><cfif isObject(user)>#user.getName()# <cfif isObject(oldUser) and user.getName() neq oldUser.getName()> (was #oldUser.getName()#)</cfif></cfif></dd>
	<dt>Description:</dt>
	<dd>#helpers.udfs.paragraphFormat2(htmlEditFormat(issueBean.getDescription()))#</dd>
	<dt>History:</dt>
	<dd>#helpers.udfs.paragraphFormat2(htmlEditFormat(issueBean.getHistory()))#</dd>
	<dt>Link:</dt>
	<dd><a href="#link#">Log into Lighthouse to update issue</a></dd>
</dl>	

<p class="footnote">This email was generated by Lighthouse Pro, an open-source ColdFusion bug tracker application created by Raymond Camden. Find more information at the Lighthouse Pro web site: <a href="http://lighthousepro.riaforge.org">http://lighthousepro.riaforge.org</a></p>
</body>
</html>
</cfoutput>
</cfsavecontent>
		<cfset subject = "">

		<cfif len(issueBean.getName()) gt 100>
			<cfset subject = subject & left(issueBean.getName(),100) & "...">
		<cfelse>
			<cfset subject = subject & issueBean.getName()>
		</cfif>

		<cfif issueBean.getDueDate() neq "">
			<cfset timezone = GetTimeZoneInfo()>
			<cfset offset = timezone.utcHourOffset>
			<cfif offset LT 10>
				<cfset offset = '-0' & offset & '00'>
			<cfelse>
				<cfset offset = '-' & offset & '00'>
			</cfif>

			<!--- Set the Reply By Variable for use in the follow-up flag  --->
			<cfset replyby = issueBean.getDueDate()><!--- your variable for the Due Date --->
			<cfset replyby = DateFormat(replyby, "DDD, DD MMM YYYY")>
			<cfset replyby = replyby & ' 00:00:00 ' & offset><!--- I've hardcoded 4:00pm --->

			<cfset doReplyBy = true>
		</cfif>
		
		<cfset fromName = "Project " & project.getName() />
		<cfset beans.mailService.sendMail(emails, fromName, subject, replyby, severity,textmailbody,htmlmailbody)>

	</cffunction>

	<cffunction name="getDashboardData" access="public" output="true">
		<cfargument name="event" type="any">		
		<cfset var me = arguments.event.getValue("currentuser")>
		<cfset var issues = beans.issueService.getIssues(useridfk=me.getId())>
		<cfset var openissues = "">
		<cfset var overdue = "">
		<cfset var projectswithissues = "">
		
		<cfquery name="openissues" dbtype="query">
		select 	count(id) as openissues
		from	issues
		where	statusname = 'Open'
		</cfquery>
		
		<cfquery name="overdue" dbtype="query">
		select 	created, id, name, publicid, projectidfk, duedate
		from	issues
		where	duedate is not null and duedate < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		and		statusname = 'Open'
		order by created asc
		</cfquery>

		<cfquery name="projectswithissues" dbtype="query">
		select	distinct projectname, projectidfk
		from	issues
		order by projectname
		</cfquery>

		<cfset arguments.event.setValue("openissues", openissues.openissues)>
		<cfset arguments.event.setValue("overdue", overdue.recordcount)>
		<cfset arguments.event.setValue("issues", issues)>
		<cfset arguments.event.setValue("projectswithissues", projectswithissues)>
		
	</cffunction>
			
	<cffunction name="getIssue" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var id = arguments.event.getValue("id")>
		<cfset var issue = beans.issueService.getIssue(id)>
		
		<cfset arguments.event.setValue("issue", issue)>
		
		<!--- help out by getting an issue creator --->
		<cfif issue.getId() is 0>
			<cfset arguments.event.setValue("issuecreator", arguments.event.getValue("currentuser"))>
		<cfelseif len(issue.getCreatorIdFk())>
			<cfset arguments.event.setValue("issuecreator", beans.userService.getUser(issue.getCreatorIdFk()))>
		</cfif>
		
	</cffunction>

	<cffunction name="gatherReportData" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var submit_charts = arguments.event.getValue("submit_charts")>
		<cfset var submit_excel = arguments.event.getValue("submit_excel")>
		<cfset var projects = arguments.event.getValue("projects")>
		<cfset var myprojects = arguments.event.getValue("myprojects")>
		<cfset var me = arguments.event.getValue("currentuser")>
		<cfset var issues = "">
		<cfset var getuniqueprojects = "">
		<cfset var statuses = beans.statusService.getStatuses()>
		<cfset var severities = beans.severityService.getSeverities()>
		<cfset var issuetypes = beans.issueTypeService.getIssueTypes()>
		<cfset var loci = "">
		<cfset var data = "">
		<cfset var projectidfk = "">
		<cfset var project = "">
		<cfset var projectCollection = structNew()>

		<cfset var users = structNew()>
		<cfset var locusdata = structNew()>
		<cfset var sevdata = structNew()>
		<cfset var statdata = structNew()>
		<cfset var issuetypedata = structNew()>
		<cfset var lid = "">
		<cfset var sid = "">
			
		<!--- if we have not done submit_*, leave --->
		<cfif not len(submit_charts) and not len(submit_excel)>
			<cfreturn>
		</cfif>
		
		<!--- Ok, if projects == 0, it means all --->
		<cfif projects is 0>
			<cfset projects = valueList(myprojects.id)>
		</cfif>
		
		<cfif projects neq -1>
			<cfset issues = beans.issueService.getIssues(projectidfks=projects)>
		<cfelse>
			<cfset issues = beans.issueService.getIssues(useridfk=me.getId())>
			<!--- get distinct project list --->
			<cfquery name="getuniqueprojects" dbtype="query">
			select	distinct projectidfk
			from	issues
			</cfquery>
			<cfset projects = valueList(getuniqueprojects.projectidfk)>
		</cfif>
	
		<cfif projects is not "">
			<cfset loci = beans.projectAreaService.getProjectAreasForProjectList(projects)>
		<cfelse>
			<cfset loci = "">
		</cfif>

		<cfif len(submit_charts)>
				
			<!--- generate totals for all descriptors --->
			<cfset data = structNew()>
			<cfloop list="#projects#" index="projectidfk">
				<cfset data[projectidfk] = structNew()>
				<cfset data[projectidfk].issuetypes = structNew()>
				<cfset data[projectidfk].issuetypes["Unassigned"] = 0>
				<cfloop query="issuetypes">
					<cfset data[projectidfk].issuetypes[id] = 0>
				</cfloop>
				<cfset data[projectidfk].statuses = structNew()>
				<cfset data[projectidfk].statuses["Unassigned"] = 0>
				<cfloop query="statuses">
					<cfset data[projectidfk].statuses[id] = 0>
				</cfloop>
				<cfset data[projectidfk].severities = structNew()>
				<cfset data[projectidfk].severities["Unassigned"] = 0>
				<cfloop query="severities">
					<cfset data[projectidfk].severities[id] = 0>
				</cfloop>
				<cfset data[projectidfk].loci = structNew()>
				<cfset data[projectidfk].loci["Unassigned"] = 0>
				<cfloop query="loci">
					<cfset data[projectidfk].loci[id] = 0>
				</cfloop>
				<cfset data[projectidfk].users = structNew()>
				<cfset project = beans.projectService.getProject(projectidfk)>
				<cfset projectCollection[projectidfk] = project>
				<cfset users = project.getFullUsers()>
				<cfloop query="users">
					<cfset data[projectidfk].users[id] = structNew()>
					<cfset data[projectidfk].users[id].name = name>
					<cfset data[projectidfk].users[id].total = 0>
				</cfloop>
			</cfloop>

			<cfloop query="issues">

				<cfif structKeyExists(data, issues.projectidfk)>
					<!--- handle an issue with no type --->
					<cfif issuetypeidfk is "">
						<cfset data[issues.projectidfk].issuetypes["Unassigned"] = data[issues.projectidfk].issuetypes["Unassigned"] + 1>			
					<cfelse>
						<cfset data[issues.projectidfk].issuetypes[issuetypeidfk] = data[issues.projectidfk].issuetypes[issuetypeidfk] + 1>			
					</cfif>
					<!--- ditto for status --->
					<cfif statusidfk is "">
						<cfset data[issues.projectidfk].statuses["Unassigned"] = data[issues.projectidfk].statuses["Unassigned"] + 1>			
					<cfelse>
						<cfset data[issues.projectidfk].statuses[statusidfk] = data[issues.projectidfk].statuses[statusidfk] + 1>			
					</cfif>
					<cfif severityidfk is "">
						<cfset data[issues.projectidfk].severities["Unassigned"] = data[issues.projectidfk].severities["Unassigned"] + 1>
					<cfelse>
						<cfset data[issues.projectidfk].severities[severityidfk] = data[issues.projectidfk].severities[severityidfk] + 1>
					</cfif>
					<!--- loci is going to be a bit funky. Not all projects share the same loci --->			
					<cfif locusidfk is "">
						<cfset data[issues.projectidfk].loci["Unassigned"] = data[issues.projectidfk].loci["Unassigned"] + 1>
					<cfelse>
						<!--- 
						if the locusidfk doesn't exist, it is an issue that points to a locusidfk we REMOVED from a project, 
						this can happen if you edit a project after making issues. these guys will be dropped
						--->
						<cfif structKeyExists(data[issues.projectidfk].loci,locusidfk)>
							<cfset data[issues.projectidfk].loci[locusidfk] = data[issues.projectidfk].loci[locusidfk] + 1>
						</cfif>
					</cfif>
					<cfif structKeyExists(data[issues.projectidfk].users, useridfk)>
						<cfset data[issues.projectidfk].users[useridfk].total = data[issues.projectidfk].users[useridfk].total + 1>
					</cfif>
				</cfif>
			</cfloop>			

			<cfset arguments.event.setValue("data", data)>
			<cfset arguments.event.setValue("projectCollection", projectCollection)>
			<cfset arguments.event.setValue("statuses", statuses)>
			<cfset arguments.event.setValue("severities", severities)>
			<cfset arguments.event.setValue("issuetypes", issuetypes)>
			<cfset arguments.event.setValue("loci", loci)>
				
		</cfif>
		
		<cfif len(submit_excel)>
				
			<cfset arguments.event.setValue("issues", issues)>
			
		</cfif>
		
	</cffunction>
			
	<cffunction name="getIssues" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var p = arguments.event.getValue("project")>
		<cfset var sort = arguments.event.getValue("sort")>
		<cfset var sortdir = arguments.event.getValue("sortdir")>
		<cfset var issuetype = arguments.event.getValue("issuetype")>
		<cfset var locus = arguments.event.getValue("locus")>
		<cfset var severity = arguments.event.getValue("severity")>
		<cfset var status = arguments.event.getValue("status")>
		<cfset var owner = arguments.event.getValue("owner")>
		<cfset var milestone = arguments.event.getValue("milestone")>
		<cfset var keyword = arguments.event.getValue("keyword")>
		<cfset var start = arguments.event.getValue("start",1)>
		<cfset var perpage = arguments.event.getValue("perpage",10)>
		<cfset var issues = "">
				
		<!--- process sort --->
		<cfif sort is "prettydate">
			<cfset sort = "updated">
		<cfelseif sort is "prettyduedate">
			<cfset sort = "duedate">
		</cfif>

		<!---
		ToDo:
		Support pagination in the query. This will be better than the pagination
		I do below. MySQL makes it trivial. I could - for the other guys, at least
		do a TOP type operation, whic wouldn't be as good as what MySQL does, but
		would be better than nothing.
		--->
		<cfinvoke component="#beans.issueService#" method="getIssues" returnVariable="issues">
			<cfinvokeargument name="projectidfk" value="#p.getId()#">
			<cfif len(issuetype)>
				<cfinvokeargument name="issuetypeidfk" value="#issuetype#">
			</cfif>	
			<cfif len(locus)>
				<cfinvokeargument name="locusidfk" value="#locus#">
			</cfif>	
			<cfif len(severity)>
				<cfinvokeargument name="severityidfk" value="#severity#">
			</cfif>	
			<cfif len(status)>
				<cfinvokeargument name="statusidfk" value="#status#">
			</cfif>	
			<cfif len(owner)>
				<cfinvokeargument name="useridfk" value="#owner#">
			</cfif>	
			<cfif len(milestone)>
				<cfinvokeargument name="milestoneidfk" value="#milestone#">
			</cfif>	
			<cfif len(keyword)>
				<cfinvokeargument name="keyword" value="#keyword#">
			</cfif>	
			<cfinvokeargument name="sort" value="#sort#">
			<cfinvokeargument name="sortdir" value="#sortdir#">
		</cfinvoke>


		<cfset arguments.event.setValue("issues", issues)>
	</cffunction>
	
	<cffunction name="getIssueType" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var id = arguments.event.getValue("id")>
		<cfset arguments.event.setValue("issuetype", beans.issueTypeService.getIssueType(id))>
	</cffunction>
	
	<cffunction name="getIssueTypes" access="public" output="false">
		<cfargument name="event" type="any">		
		<cfset arguments.event.setValue("issuetypes", beans.issuetypeService.getIssueTypes())>
	</cffunction>	

	<!--- very similar to gatherReportData, may refactor --->
	<cffunction name="getRSSData" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var projects = arguments.event.getValue("projects")>
		<cfset var myprojects = arguments.event.getValue("myprojects")>
		<cfset var me = arguments.event.getValue("currentuser")>
		<cfset var issues = "">
		<cfset var getuniqueprojects = "">
		<cfset var title = "">
		<cfset var project = "">
		<cfset var settings = beans.applicationSettings.getConfig()>
		
		<cfif not structKeyExists(settings,"rssfeedsenabled") or not settings.rssfeedsenabled>
			<cfset arguments.event.addResult("NoRSS")>
		</cfif>
		
		<!--- Ok, if projects == 0, it means all --->
		<cfif projects is 0>
			<cfset title = "All Issues">
			<cfset projects = valueList(myprojects.id)>
		<cfelseif projects is not -1>
			<cfset project = beans.projectService.getProject(projects)>
			<cfset title = project.getName()>
		</cfif>
		
		<cfif projects neq -1>
			<cfset issues = beans.issueService.getIssues(projectidfks=projects)>
		<cfelse>
			<cfset title = "All Issues (My Issues)">
			<cfset issues = beans.issueService.getIssues(useridfk=me.getId())>
			<!--- get distinct project list --->
			<cfquery name="getuniqueprojects" dbtype="query">
			select	distinct projectidfk
			from	issues
			</cfquery>
			<cfset projects = valueList(getuniqueprojects.projectidfk)>
		</cfif>
	
		<cfset arguments.event.setValue("issues", issues)>
		<cfset arguments.event.setValue("title", title)>
					
	</cffunction>

	<cffunction name="getSeverity" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var id = arguments.event.getValue("id")>
		<cfset arguments.event.setValue("severity", beans.severityService.getSeverity(id))>
	</cffunction>
	
	<cffunction name="getSeverities" access="public" output="false">
		<cfargument name="event" type="any">		
		<cfset arguments.event.setValue("severities", beans.severityService.getSeverities())>
	</cffunction>	

	<cffunction name="getStatus" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var id = arguments.event.getValue("id")>
		<cfset arguments.event.setValue("status", beans.statusService.getStatus(id))>
	</cffunction>
	
	<cffunction name="getStatuses" access="public" output="false">
		<cfargument name="event" type="any">		
		<cfset arguments.event.setValue("statuses", beans.statusService.getStatuses())>
	</cffunction>	

	<cffunction name="saveIssue" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var issue = arguments.event.getValue("issue")>
		<cfset var myprojects = arguments.event.getValue("myprojects")>
		<cfset var oBean = "">
		<cfset var name = arguments.event.getValue("name")>
		<cfset var description = arguments.event.getValue("description")>
		<cfset var historyheader = "">
		<cfset var me = arguments.event.getValue("currentuser")>
		<cfset var history = "">
		<cfset var projectChangedFlag = false>
		<cfset var cancel = arguments.event.getValue("cancel")>
		<cfset var otherproject = "">
		<cfset var newPossibleLoci = ""> 
		<cfset var newPossibleUsers = "">
		<cfset var newissue = true>
		<cfset var newfile = "">
		<cfset var addAttachment = "">
		<cfset var print = arguments.event.getValue("print")>
		<cfset var errors = "">
		
		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>

		<cfif print is "Print">
			<!--- copy a few utility values for the print job --->
			<cfset arguments.event.setValue("issuetype", beans.issueTypeService.getIssueType(issue.getIssueTypeIdFk()))>
			<cfset arguments.event.setValue("projectarea", beans.projectAreaService.getProjectArea(issue.getLocusIdFk()))>
			<cfset arguments.event.setValue("severity", beans.severityService.getSeverity(issue.getSeverityIDFK()))>
			<cfset arguments.event.setValue("status", beans.statusService.getStatus(issue.getStatusIDFK()))>
			<cfset arguments.event.setValue("milestone", beans.milestoneService.getMilestone(issue.getMilestoneIDFK()))>
			<cfset arguments.event.setValue("owner", beans.userService.getUser(issue.getUserIDFK()))>
			<cfset arguments.event.setValue("creator", beans.userService.getUser(issue.getCreatorIDFK()))>			
			<cfset arguments.event.addResult("print")>
		</cfif>
		
		<!--- make a copy --->
		<cfif issue.getId() neq 0>
			<cfset newissue = false>
			<cfset oBean = beans.issueService.getIssue(issue.getId())>
		<cfelse>
			<cfset issue.setCreated(now())>
		</cfif>

		<cfset name = helpers.udfs.UnicodeWin1252(name)>
		<cfset description = helpers.udfs.UnicodeWin1252(description)>
		
		<cfset issue.setName(name)>
		<cfset issue.setUpdated(now())>
		<cfset issue.setProjectIDFK(arguments.event.getValue("projectidfk"))>
		<cfset issue.setUserIdFk(arguments.event.getValue("useridfk"))>
		<cfset issue.setDescription(description)>
		<cfset issue.setRelatedURL(arguments.event.getValue("relatedurl"))>
		<cfset issue.setDueDate(arguments.event.getValue("duedate"))>		

		<cfset issue.setIssueTypeIDFK(arguments.event.getValue("issuetypeidfk"))>
		<cfset issue.setLocusIDFK(arguments.event.getValue("locusidfk"))>
		<cfset issue.setSeverityIDFK(arguments.event.getValue("severityidfk"))>
		<cfset issue.setStatusIDFK(arguments.event.getValue("statusidfk"))>
		<cfset issue.setMilestoneIDFK(arguments.event.getValue("milestoneidfk"))>

		<cfset historyheader = "#dateFormat(now(),'mm/dd/yy')# #timeFormat(now(),'h:mm tt')# / #me.getUsername()# (#me.getName()#)#chr(10)#">

		<cfif issue.getId() is 0>
			<cfset history = "#historyheader#Initial Creation#chr(10)#">
			<cfset issue.setCreatorIDFK(me.getID())>
		<cfelse>
			<cfset history = issue.getHistory() & historyheader>

			<cfif issue.getName() neq oBean.getName()>
				<cfset history = history & "Name changed from ""#oBean.getName()#"" to ""#issue.getName()#""#chr(10)#">
			</cfif>
	
			<cfif issue.getUserIDFK() neq oBean.getUserIDFK()>
				<cfif oBean.getUserIDFK() eq "">
					<cfset history = history & "Owner set to ""#beans.userService.getUser(issue.getUserIdFk()).getUserName()#""#chr(10)#">
				<cfelse>
					<cfset history = history & "Owner changed from ""#beans.userService.getUser(oBean.getUserIdFk()).getUserName()#"" to ""#beans.userService.getUser(issue.getUserIdFk()).getUserName()#""#chr(10)#">
				</cfif>
			</cfif>
	
			<cfif issue.getIssueTypeIDFK() neq oBean.getIssueTypeIDFK()>
				<cfif oBean.getIssueTypeIDFK() eq "">
					<cfset history = history & "Type set to ""#beans.issueTypeService.getIssueType(issue.getIssueTypeIdFk()).getName()#""#chr(10)#">
				<cfelse>
					<cfset history = history & "Type changed from ""#beans.issueTypeService.getIssueType(oBean.getIssueTypeIdFk()).getName()#"" to ""#beans.issueTypeService.getIssueType(issue.getIssueTypeIdFk()).getName()#""#chr(10)#">
				</cfif>
			</cfif>
			
			<cfif issue.getMilestoneIDFK() neq oBean.getMilestoneIDFK()>
				<cfif oBean.getMilestoneIDFK() neq "">
					<cfset history = history & "Milestone changed from ""#beans.milestoneService.getMilestone(oBean.getMilestoneIdFk()).getName()#"" to ""#beans.milestoneService.getMilestone(issue.getMilestoneIdFk()).getName()#""#chr(10)#">
				<cfelse>
					<cfset history = history & "Milestone set to ""#beans.milestoneService.getMilestone(issue.getMilestoneIdFk()).getName()#""#chr(10)#">
				</cfif>
			</cfif>
	
			<cfif issue.getLocusIDFK() neq oBean.getLocusIDFK()>
				<cfif oBean.getLocusIDFK() eq "">
					<cfset history = history & "Area set to ""#beans.projectAreaService.getProjectArea(issue.getLocusIdFk()).getName()#""#chr(10)#">
				<cfelse>
					<cfset history = history & "Area changed from ""#beans.projectAreaService.getProjectArea(oBean.getLocusIdFk()).getName()#"" to ""#beans.projectAreaService.getProjectArea(issue.getLocusIdFk()).getName()#""#chr(10)#">
				</cfif>
			</cfif>
			
			<cfif issue.getSeverityIDFK() neq oBean.getSeverityIDFK()>
				<cfif oBean.getSeverityIDFK() eq "">
					<cfset history = history & "Severity set to ""#beans.severityService.getSeverity(issue.getSeverityIdFk()).getName()#""#chr(10)#">
				<cfelse>
					<cfset history = history & "Severity changed from ""#beans.severityService.getSeverity(oBean.getSeverityIdFk()).getName()#"" to ""#beans.severityService.getSeverity(issue.getSeverityIdFk()).getName()#""#chr(10)#">
				</cfif>
			</cfif>
			
			<cfif issue.getStatusIDFK() neq oBean.getStatusIDFK()>
				<cfif oBean.getStatusIDFK() eq "">
					<cfset history = history & "Status set to ""#beans.statusService.getStatus(issue.getStatusIdFk()).getName()#""#chr(10)#">
				<cfelse>
					<cfset history = history & "Status changed from ""#beans.statusService.getStatus(oBean.getStatusIdFk()).getName()#"" to ""#beans.statusService.getStatus(issue.getStatusIdFk()).getName()#""#chr(10)#">
				</cfif>
			</cfif>
			
			<cfif issue.getProjectIdFK() neq oBean.getProjectIdFK()>
				<cfset projectChangedFlag = true>
				<cfset history = history & "Project reassigned from ""#beans.projectService.getProject(oBean.getprojectIdFk()).getName()#"" to ""#beans.projectService.getProject(issue.getProjectIdFk()).getName()#""#chr(10)#">
			</cfif>		
	
			<cfif len(trim(notes))>
				<cfset history = history & "Notes: " &form.notes & chr(10)>
			</cfif>
		</cfif>

		<cfset history = history & chr(10)>	
		<cfset issue.setHistory(history)>

		<cfset errors = issue.validate()>

		<!--- Yep, using the form scope here. Yes, I could do it PROPERLY mvc, but nope, I'm too lazy. --->
		<cfif structKeyExists(form, "newattachment") and len(form.newattachment)>
			<cffile action="upload" destination="#variables.attachmentpath#" filefield="newattachment" result="newfile" nameconflict="makeunique">
			<cfif newfile.fileWasSaved>
				<cfset addAttachment = structNew()>
				<cfset addAttachment.filename = newFile.serverfile>
				<cfset addAttachment.attachment = newfile.clientfile>
			</cfif>
		</cfif>
						
		<cfif not arrayLen(errors)>
		
			<!--- handle change to new project --->
			<cfif projectChangedFlag>
				<!--- first, look for a hack. ensure we didn't change to a project we can't use. Because this is something
				that only a hacker would do, don't throw an error, just eject. ---->
				<cfif not me.hasRole("admin")>
					<cfif not listFindNoCase(valueList(myProjects.id), issueBean.getProjectIDFK())>
						<cflocation url="index.cfm" addToken="false">
					</cfif>
				</cfif>
				<!--- get the other project --->
				<cfset otherproject = beans.projectService.getProject(issue.getProjectIDFK())>
				<!--- We have 3 things to worry about: areaidfk,useridfk,milestoneidfk. Since milestones are 100% project specific, we just nuke it --->
				<cfset issue.setMilestoneIDFK("")>
				<cfset newPossibleLoci = otherproject.getProjectAreas()> 
				<cfset newPossibleUsers = otherproject.getUsers()>
				<cfif not listFind(newPossibleLoci, issue.getLocusIDFK())>
					<cfset issue.setLocusIDFK("")>
				</cfif>
				<cfif not listFind(newPossibleUsers, issue.getUserIDFK())>
					<cfset issue.setUserIDFK("")>
				</cfif>
			</cfif>
			
			<cfset issue = beans.issueService.saveIssue(issue)>
			<cfif newissue>
				<cfset emailNotifications(issue)>			
			<cfelse>
				<cfset emailNotifications(issue,oBean)>			
			</cfif>
			<cfif isStruct(addAttachment)>
				<cfset issue.addAttachment(addAttachment.attachment, addAttachment.filename)>
			</cfif>
			
			<cfset arguments.event.setValue("id", issue.getProjectIdFk())>
			<cfset arguments.event.addResult("good")>
		<cfelse>
			<cfif isStruct(newfile) and newfile.fileWasSaved>
				<cffile action="delete" file="#variables.attachmentpath#/#newfile.serverfile#">
				<cfset arrayAppend(errors, "Your attachment was removed. Please upload it again.")>
			</cfif>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>	
	
	<cffunction name="saveIssueType" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var it = arguments.event.getValue("issuetype")>
		<cfset var name = htmlEditFormat(trim(arguments.event.getValue("name")))>
		<cfset var errors = "">
		<cfset var cancel = arguments.event.getValue("cancel")>
		
		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>
		
		<cfset it.setName(name)>
	
		<cfset errors = it.validate()>
		
		<cfif not arrayLen(errors)>
			<cfset beans.issueTypeService.saveIssueType(it)>
			<cfset arguments.event.addResult("good")>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>		
		
	<cffunction name="saveSeverity" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var sev = arguments.event.getValue("severity")>
		<cfset var name = htmlEditFormat(trim(arguments.event.getValue("name")))>
		<cfset var rank = htmlEditFormat(trim(arguments.event.getValue("rank")))>
		<cfset var errors = "">
		<cfset var cancel = arguments.event.getValue("cancel")>
		
		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>
		
		<cfset sev.setName(name)>
		<cfset sev.setRank(rank)>
	
		<cfset errors = sev.validate()>
		
		<cfif not arrayLen(errors)>
			<cfset beans.severityService.saveSeverity(sev)>
			<cfset arguments.event.addResult("good")>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>		

	<cffunction name="saveStatus" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var stat = arguments.event.getValue("status")>
		<cfset var name = htmlEditFormat(trim(arguments.event.getValue("name")))>
		<cfset var rank = htmlEditFormat(trim(arguments.event.getValue("rank")))>
		<cfset var errors = "">
		<cfset var cancel = arguments.event.getValue("cancel")>
		
		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>
		
		<cfset stat.setName(name)>
		<cfset stat.setRank(rank)>
	
		<cfset errors = stat.validate()>
		
		<cfif not arrayLen(errors)>
			<cfset beans.statusService.saveStatus(stat)>
			<cfset arguments.event.addResult("good")>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>			
	
</cfcomponent>
	
