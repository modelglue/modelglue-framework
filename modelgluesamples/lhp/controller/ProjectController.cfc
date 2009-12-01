<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller" beans="projectService,severityService,statusService,issuetypeService,projectAreaService,milestoneService">

	<cffunction name="init" access="public" output="false" hint="Constructor">
		<cfargument name="framework" />
		
		<cfset super.init(framework) />
	
		<cfreturn this />
	</cffunction>

	<cffunction name="deleteMilestone" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var markedtodie = arguments.event.getValue("mark")>
		<!--- get one of the milestones so we can sniff the project --->
		<cfset var m = "">
		
		<cfif len(markedtodie)>
			<cfset m = beans.milestoneService.getMilestone(listFirst(markedtodie))>
			<cfset arguments.event.setValue("lastproject", m.getProjectIDFK())>
		</cfif>		
		<cfset beans.milestoneService.deleteMilestones(markedtodie)>
	</cffunction>

	<cffunction name="deleteProject" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var markedtodie = arguments.event.getValue("mark")>
		
		<cfset beans.projectService.deleteProjects(markedtodie)>
	</cffunction>
	
	<cffunction name="deleteProjectArea" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var markedtodie = arguments.event.getValue("mark")>
		
		<cfset beans.projectAreaService.deleteProjectAreas(markedtodie)>
	</cffunction>

	<cffunction name="getMilestone" access="public" output="false">
		<cfargument name="event" type="any">		
		<cfset var id = arguments.event.getValue("id")>
		<cfset arguments.event.setValue("milestone", beans.milestoneService.getMilestone(id))>
	</cffunction>		
		
	<cffunction name="getMilestones" access="public" output="false">
		<cfargument name="event" type="any">		
		<cfset var project = arguments.event.getValue("project")>
		<cfset arguments.event.setValue("milestones", beans.milestoneService.getMilestones(project))>
	</cffunction>		

	<cffunction name="getProject" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var me = arguments.event.getValue("currentUser")>
		<cfset var id = arguments.event.getValue("id")>
		<cfset var pid = arguments.event.getValue("pid")>
		<cfset var project = "">
		
		<!--- allow pid to overrule id --->
		<cfif len(pid)>
			<cfset id = pid>
		</cfif>
		
		<cfset project = beans.projectService.getProject(id)>
		<!--- lock it down --->
		<cfif me.hasRole("admin") or listFind(me.getProjects(), id)>
			<cfset arguments.event.setValue("project", beans.projectService.getProject(id))>
		<cfelse>
			<cfthrow message="Invalid Access. This is not the project you are looking for.">
		</cfif>
	
	</cffunction>
				
	<cffunction name="getMyProjects" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var user = arguments.event.getValue("currentuser")>
		<cfset arguments.event.setValue("myprojects", beans.projectService.getProjectsForUser(user))>
	</cffunction>

	<cffunction name="getProjectArea" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var id = arguments.event.getValue("id")>
		<cfset arguments.event.setValue("projectarea", beans.projectAreaService.getProjectArea(id))>
	</cffunction>
	
	<cffunction name="getProjectAreas" access="public" output="false">
		<cfargument name="event" type="any">		
		<cfset arguments.event.setValue("projectareas", beans.projectAreaService.getProjectAreas())>
	</cffunction>	
		
	<cffunction name="getProjects" access="public" output="false">
		<cfargument name="event" type="any">		
		<cfset arguments.event.setValue("projects", beans.projectService.getProjects())>
	</cffunction>	
	
	<cffunction name="saveMilestone" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var m = arguments.event.getValue("milestone")>
		<cfset var name = htmlEditFormat(trim(arguments.event.getValue("name")))>
		<cfset var duedate = htmlEditFormat(trim(arguments.event.getValue("duedate")))>
		<cfset var project = htmlEditFormat(trim(arguments.event.getValue("project")))>

		<cfset var errors = "">
		<cfset var cancel = arguments.event.getValue("cancel")>
		
		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>
		
		<cfset m.setName(name)>
		<cfset m.setDueDate(duedate)>
		<cfset m.setProjectIDFK(project)>
	
		<cfset errors = m.validate()>
		
		<cfif not arrayLen(errors)>
			<cfset beans.milestoneService.saveMilestone(m)>
			<cfset arguments.event.setValue("lastproject", m.getProjectIDFK())>
			<cfset arguments.event.addResult("good")>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>	

	<cffunction name="saveProject" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var p = arguments.event.getValue("project")>
		<cfset var name = htmlEditFormat(trim(arguments.event.getValue("name")))>
		<cfset var mailserver = htmlEditFormat(trim(arguments.event.getValue("mailserver")))>
		<cfset var mailusername = htmlEditFormat(trim(arguments.event.getValue("mailusername")))>
		<cfset var mailpassword = htmlEditFormat(trim(arguments.event.getValue("mailpassword")))>
		<cfset var mailemailaddress = htmlEditFormat(trim(arguments.event.getValue("mailemailaddress")))>
		<cfset var selprojectareas = arguments.event.getValue("selprojectareas","")>
		<cfset var selusers = arguments.event.getValue("selusers","")>
		
		<cfset var errors = "">
		<cfset var cancel = arguments.event.getValue("cancel")>
		
		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>
			
		<cfset p.setName(left(name,50))>
		<cfset p.setMailServer(mailserver)>				
		<cfset p.setMailUsername(mailusername)>
		<cfset p.setMailPassword(mailpassword)>
		<cfset p.setMailEmailAddress(mailemailaddress)>
		<cfset p.setProjectAreas(selprojectareas)>
		<cfset p.setUsers(selusers)>
		
		<cfset errors = p.validate()>
				
		<cfif not arrayLen(errors)>
			<cfset beans.projectService.saveProject(p)>
			<cfset arguments.event.addResult("good")>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>	
		
	<cffunction name="saveProjectArea" access="public" output="false">
		<cfargument name="event" type="any">
		<cfset var pa = arguments.event.getValue("projectarea")>
		<cfset var name = htmlEditFormat(trim(arguments.event.getValue("name")))>
		<cfset var errors = "">
		<cfset var cancel = arguments.event.getValue("cancel")>
		
		<cfif cancel is "Cancel">
			<cfset arguments.event.addResult("good")>
		</cfif>
		
		<cfset pa.setName(name)>
	
		<cfset errors = pa.validate()>
		
		<cfif not arrayLen(errors)>
			<cfset beans.projectAreaService.saveProjectArea(pa)>
			<cfset arguments.event.addResult("good")>
		<cfelse>
			<cfset arguments.event.setValue("errors", errors)>
			<cfset arguments.event.addResult("bad")>
		</cfif>
			
	</cffunction>	
					
</cfcomponent>
	
