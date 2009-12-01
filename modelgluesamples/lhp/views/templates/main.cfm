<cfset settings = event.getValue("settings")>
<cfset root = event.getValue("myself")>
<cfset title = event.getValue("title")>
<cfset selected = event.getValue("selected","home")>
<cfset projects = event.getValue("myprojects", queryNew("id"))>
<cfset me = event.getValue("currentuser")>

<cfparam name="url.id" default="" type="string">
<cfparam name="url.pid" default="#url.id#" type="string">

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8">
		<title>Lighthouse Pro<cfif len(trim(title))> - #title#</cfif></title>
		<link rel="stylesheet" href="css/global.css" type="text/css" charset="utf-8">	
		<link rel="stylesheet" href="css/screen.css" type="text/css" charset="utf-8">
		<link rel="shortcut icon" href="favicon.ico" type="image/vnd.microsoft.icon" />
		<link rel="icon" href="favicon.ico" type="image/vnd.microsoft.icon" />
		<link rel="stylesheet" href="js/css/smoothness/jquery.ui.custom.css" type="text/css" charset="utf-8">
		<script src="js/jquery.min.js"></script>
		<script src="js/jquery.ui.min.js"></script>
		<script type="text/javascript">
		 	function confirmDialog(message, url) {
		 		
		 		var confirmState=window.confirm(message);
				if (confirmState) {
					window.location = url;
				} 
		 	}
		
		</script>
		
	</head>
	
	<body>
		<div id="wrapper">

			<div id="hd">
				<h1 class="bgreplace">Lighthouse Pro</h1>
				<div class="topNav">
					<ul>
						<li><a href="#root#page.gettingstarted">Getting Started</a></li>
						<li><a href="#root#page.prefs">Preferences</a></li>
						<li class="noborder"><a href="#root#action.logout">Logout</a></li>
					</ul>
				</div>
				<div class="mainNav">
					<ul id="nav">
						<li id="thome"><a href="#root#page.index" <cfif selected is "home">class="selected"</cfif>>Home</a></li>
						<li id="treports"><a href="#root#page.reports" <cfif selected is "reports">class="selected"</cfif>>Reports</a></li>
						<cfif settings.rssfeedsenabled><li id="tfeeds"><a href="#root#page.feeds" <cfif selected is "feeds">class="selected"</cfif>>Feeds</a></li></cfif>
					</ul>					
				</div>
			</div>

			<div id="contentArea" class="clear">
				<div class="contentLeft">
					<h5>Your Projects</h5>
						<ul>
							<cfif projects.recordcount>
								<cfif projects.recordcount gt 20>
									<script>
										function goToProject(el){
											var id = el.options[el.selectedIndex].value
											if (id != 0){
												window.location.href='#root#page.viewissues&id='+id;
											}
										}
									</script>
									<select id="projectslist" class="input" style="width:150px;" onchange="goToProject(this);">
										<option value="0">--select project--</option>
										<cfloop query="projects">
											<option value="#projects.id#"<cfif projects.id eq url.pid> selected="true"</cfif>>#projects.name#</option>
										</cfloop>
									</select>
								<cfelse>
									<cfloop query="projects">
										<li><a href="#root#page.viewissues&id=#id#" class="blueLink">#name#</a> <a href="#root#page.viewissue&id=0&pid=#id#" title="Add new issue to #htmlEditFormat(name)#">[+]</a></li>
									</cfloop>
								</cfif>
							<cfelse>
								<li>Sorry, but there are no projects available.</li>
							</cfif>
						</ul>
			        <cfif me.hasRole("admin")>
					<h5>Admin Menu</h5>
					<ul>
						<li><a href="#root#page.users" title="Users" class="blueLink">Users</a> <a href="#root#page.user&id=0" title="Add User">[+]</a></li>
						<li><a href="#root#page.projects" title="Projects" class="blueLink">Projects</a> <a href="#root#page.project&id=0" title="Add Project">[+]</a></li>
						<li><a href="#root#page.milestones" title="Milestones" class="blueLink">Milestones</a> <a href="#root#page.milestone&id=0" title="Add Milestone">[+]</a></li>
						<li><a href="#root#page.projectareas" title="Project Areas" class="blueLink">Project Areas</a> <a href="#root#page.projectarea&id=0" title="Add Project Area">[+]</a></li>
						<li><a href="#root#page.issuetypes" title="Issue Types" class="blueLink">Issue Types</a> <a href="#root#page.issuetype&id=0" title="Add Issue Type">[+]</a></li>				
						<li><a href="#root#page.statuses" title="Issue Statuses" class="blueLink">Statuses</a> <a href="#root#page.status&id=0" title="Add Status">[+]</a></li>
						<li><a href="#root#page.severities" title="Issue Severities" class="blueLink">Severities</a> <a href="#root#page.severity&id=0" title="Add Severity">[+]</a></li>
						<li><a href="#root#page.announcements" title="Announcements" class="blueLink">Announcements</a> <a href="#root#page.announcement&id=0" title="Add Announcement">[+]</a></li>
					</ul>
					</cfif>					
				</div>
				<div class="contentRight">

				#viewCollection.getView("body")#

				</div> <!-- end contentRight -->
			</div> <!-- end contentArea -->
		</div> <!-- end wrapper -->
	</body>
</html>
</cfoutput>


	