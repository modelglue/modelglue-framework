<cfcomponent output="false" displayName="Issue Gateway">

	<cfset variables.dsn = "">
	<cfset variables.username = "">
	<cfset variables.password = "">
	<cfset variables.lock = "LHP_Lock">

	<cffunction name="init" access="public" returnType="IssueGateway" output="false">
		<cfargument name="settings" type="any" required="true">
		<cfset variables.config = arguments.settings.getConfig()>
		
		<cfset variables.dsn = variables.config.dsn>
		<cfset variables.username = variables.config.username /> 
		<cfset variables.password = variables.config.password />
		<cfreturn this>
	</cffunction>	

	<cffunction name="deleteIssue" access="public" returnType="void" output="false">
		<cfargument name="id" type="any" required="false">
		
		<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
		delete from lh_issues
		where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">		
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getIssue" access="public" returnType="IssueBean" output="false">
		<cfargument name="id" type="uuid" required="true">
		<cfset var iBean = createObject("component","IssueBean")>
		<cfset var getit = "">
		
		<cfquery name="getit" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select 	id, projectidfk, created, updated, name, useridfk, creatoridfk, description, history, locusidfk, severityidfk, statusidfk, relatedurl, duedate, publicid, issuetypeidfk, milestoneidfk
			from	lh_issues
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
		</cfquery>
		
		<cfif getit.recordCount>
			<cfset iBean.setID(getit.id)>
			<cfset iBean.setProjectIDFK(getit.projectidfk)>
			<cfset iBean.setCreated(getit.created)>
			<cfset iBean.setUpdated(getit.updated)>
			<cfset iBean.setName(getit.name)>
			<cfset iBean.setUserIDFK(getit.useridfk)>
			<cfset iBean.setCreatorIDFK(getit.creatoridfk)>
			<cfset iBean.setDescription(getit.description)>
			<cfset iBean.setHistory(getit.history)>
			<cfset iBean.setLocusIDFK(getit.locusidfk)>
			<cfset iBean.setSeverityIDFK(getit.severityidfk)>
			<cfset iBean.setStatusIDFK(getit.statusidfk)>
			<cfset iBean.setRelatedURL(getit.relatedurl)>
			<cfset iBean.setDueDate(getit.duedate)>
			<cfset iBean.setPublicID(getit.publicid)>
			<cfset iBean.setIssueTypeIDFK(getit.issuetypeidfk)>
			<cfset iBean.setMilestoneIDFK(getit.milestoneidfk)>
		</cfif>
		<cfset ibean.setConfig(variables.config)>
		<cfreturn iBean>
	</cffunction>

	<cffunction name="getIssues" access="public" returnType="query" output="false"
				hint="Gets all the issues. Allows for various filtering ops.">
		<cfargument name="sort" type="string" required="false" default="updated">
		<cfargument name="sortdir" type="string" required="false" default="desc">
		<cfargument name="projectidfk" type="string" required="false" default="">
		<cfargument name="projectidfks" type="string" required="false" default="">
		<cfargument name="useridfk" type="string" required="false" default="">
		<cfargument name="issuetypeidfk" type="string" required="false" default="">
		<cfargument name="locusidfk" type="string" required="false" default="">
		<cfargument name="severityidfk" type="string" required="false" default="">
		<cfargument name="statusidfk" type="string" required="false" default="">
		<cfargument name="owneridfk" type="string" required="false" default="">
		<cfargument name="milestoneidfk" type="string" required="false" default="">
		<cfargument name="keyword" type="string" required="false" default="">
		
		<cfset var data = "">

		<cfif arguments.sortdir is not "asc" and arguments.sortdir is not "desc">
			<cfset arguments.sortdir = "desc">
		</cfif>
		<cfif not listFindNoCase("publicid,name,issuetype,locusname,severityrank,statusrank,username,duedate,updated,milestoneidfk", arguments.sort)>
			<cfset arguments.sort = "updated">
		</cfif>
		<cfif arguments.sort is "name">
			<cfset arguments.sort = "i.name">
		</cfif>
						
		<cfquery name="data" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			SELECT 		i.id, i.projectidfk, i.created, i.updated, i.publicid, i.duedate,
						i.name, i.useridfk, i.description, i.history, i.creatoridfk,
						i.locusidfk, i.severityidfk, i.statusidfk, i.relatedurl, i.milestoneidfk,
						pl.name AS locusname,
						sev.name AS severityname,
						st.name AS statusname,
						st.rank as statusrank,
						p.name AS projectname,
						sev.rank AS severityrank,
						u.name AS username,
						it.name as issuetype,
						m.name as milestone,
						i.issuetypeidfk
						FROM ((((((lh_issues AS i 
						LEFT JOIN lh_projectloci AS pl on i.locusidfk = pl.id)
						LEFT JOIN lh_severities AS sev on i.severityidfk = sev.id)
						LEFT JOIN lh_statuses AS st on i.statusidfk = st.id)
						LEFT JOIN lh_projects AS p on i.projectidfk = p.id)
						LEFT JOIN lh_users AS u on i.useridfk = u.id)    
						LEFT JOIN lh_issuetypes AS it on i.issuetypeidfk = it.id)
						LEFT JOIN lh_milestones AS m on i.milestoneidfk = m.id
						WHERE		1=1
						<cfif arguments.projectidfk neq "">
						AND	i.projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectidfk#" maxlength="35">
						</cfif>
						<cfif arguments.projectidfks neq "">
						AND	i.projectidfk IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.projectidfks#" list=true>)
						</cfif>
						<cfif arguments.useridfk neq "">
						AND	i.useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.useridfk#" maxlength="35">
						</cfif>
						<cfif arguments.issuetypeidfk neq "">
						AND	i.issuetypeidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.issuetypeidfk#" maxlength="35">
						</cfif>
						<cfif arguments.locusidfk neq "">
						AND	i.locusidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.locusidfk#" maxlength="35">
						</cfif>
						<cfif arguments.severityidfk neq "">
						AND	i.severityidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.severityidfk#" maxlength="35">
						</cfif>
						<cfif arguments.statusidfk neq "">
						AND	i.statusidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.statusidfk#" maxlength="35">
						</cfif>
						<cfif arguments.owneridfk neq "">
						AND	i.useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.useridfk#" maxlength="35">
						</cfif>		
						<cfif arguments.milestoneidfk neq "">
						AND	i.milestoneidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.milestoneidfk#" maxlength="35">
						</cfif>

						<cfif arguments.keyword neq "">
						and (
							i.name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
							or
							i.description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%">
							or
							i.publicid = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(arguments.keyword)#">
						)
						</cfif>	
			ORDER BY  	#arguments.sort# #arguments.sortdir#
		</cfquery>

		<cfreturn data>
	</cffunction>

	<cffunction name="newIssue" access="public" returnType="IssueBean" output="false">
		<cfset var bean = createObject("component","IssueBean")>		
		<cfset bean.setConfig(variables.config)>
		<cfreturn bean>
	</cffunction>
	
	<cffunction name="saveIssue" access="public" returnType="any" output="false">
		<cfargument name="bean" type="any" required="true">
		<cfset var newID = "">
		<cfset var getLastPublicID = "">
		<cfset var newPublicID = "">

		<cfif len(bean.getId()) and bean.getId() neq 0>

			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			update lh_issues
			set	projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getProjectIDFK()#" maxlength="35">,
				created = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bean.getCreated()#" maxlength="35">,
				updated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bean.getUpdated()#" maxlength="35">,
				name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#" maxlength="255">,
				useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getUserIDFK()#" maxlength="35">,
				creatoridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getCreatorIDFK()#" maxlength="35">,
				description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getDescription()#">,
				history = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getHistory()#">,
				locusidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLocusIDFK()#" maxlength="35">,
				severityidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getSeverityIDFK()#" maxlength="35">,
				statusidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getStatusIDFK()#" maxlength="35">,
				relatedurl = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getRelatedURL()#" maxlength="255">,
				duedate = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.bean.getDueDate()#" null="#not len(arguments.bean.getDueDate())#">,
				issuetypeidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getIssueTypeIDFK()#" maxlength="35">,
				milestoneidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMilestoneIDFK()#" maxlength="35">				
				where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getID()#" maxlength="35">
			</cfquery>				
	
			<cfreturn arguments.bean>
								
		<cfelse>

			<cfset newID = createUUID()>

			<cflock name="#variables.lock#_#arguments.bean.getProjectIdFk()#" type="exclusive" timeout="30">
				
			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
				insert into lh_issues(id,projectidfk,created,updated,name,useridfk,creatoridfk,description,history,locusidfk,severityidfk,statusidfk,relatedURL,duedate,issuetypeidfk,milestoneidfk)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getProjectIDFK()#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bean.getCreated()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.bean.getUpdated()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getName()#" maxlength="255">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getUserIDFK()#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getCreatorIDFK()#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getDescription()#">,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.bean.getHistory()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getLocusIDFK()#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getSeverityIDFK()#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getStatusIDFK()#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getRelatedURL()#" maxlength="255">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#arguments.bean.getDueDate()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getIssueTypeIDFK()#" maxlength="35">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getMilestoneIDFK()#" maxlength="35">				
					)
			</cfquery>
			
			<cfquery name="getLastPublicID" datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			select	max(publicid) as maxid
			from	lh_issues
			where	projectidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bean.getProjectIDFK()#" maxlength="35">
			</cfquery>
			
			<cfif not getLastPublicID.recordCount or getLastPublicID.maxid is "">
				<cfset newPublicID = 1>
			<cfelse>
				<cfset newPublicID = getLastPublicID.maxid + 1>
			</cfif>
			
			<cfquery datasource="#variables.dsn#" username="#variables.username#" password="#variables.password#">
			update	lh_issues
			set		publicid = 	<cfqueryparam cfsqltype="cf_sql_integer" value="#newPublicID#">
			where	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">
			</cfquery>
			
			</cflock>
			
			<cfset arguments.bean.setID(newid)>
					
			<cfreturn arguments.bean>
		
		</cfif>

	</cffunction>	
		
</cfcomponent>