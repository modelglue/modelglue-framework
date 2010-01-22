<cfset CurrentUser = event.getValue("CurrentUser") />
<cfset pageTitle = event.getValue("pageTitle") />
<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="/library/css/site.css" type="text/css" />
<link rel="stylesheet" href="/library/css/store.css" type="text/css" />

<script src="library/js/jQuery/jquery-1.3.2.min.js" type="text/javascript"></script>

<!--- required for validations --->
<script src="library/js/jQuery/jquery.field.min.js" type="text/javascript"></script>
<script src="library/js/jQuery/jquery.validate.pack.js" type="text/javascript"></script>

<script language="JavaScript1.1" type=text/JavaScript>
	if (parent.frames.length > 0) top.location.replace(document.location);
</script>

<script src="library/js/site2.js" type="text/javascript"></script>
<!--[if IE 6]>
<style type="text/css"> 
/* place fixes for IE in this conditional comment */
##content { _margin-top: -23px; }
.cfUniForm-form-container .uniForm .buttonHolder button { padding: 15px 0px 20px 2px; width: 110px;}
.cfUniForm-form-container .uniForm p { color: ##5b666f; }
</style>
<![endif]-->
<!--[if IE 7]>
<style type="text/css">
##header { margin-bottom: 15px;   }
.cfUniForm-form-container .uniForm .buttonHolder button { padding: 15px 0px 20px 2px; width: 110px; }
</style>
<![endif]-->


<!-- InstanceBeginEditable name="doctitle" -->
<title>Miracle 10&trade;<!--- #pageTitle# ---></title>
<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->

<!-- InstanceParam name="RightColumn" type="boolean" value="false" -->

<!-- InstanceParam name="loginoption" type="boolean" value="true" -->
<!-- InstanceParam name="bigleftcolumn" type="boolean" value="false" -->

</head>
<body>
<div id="wrapper">
    <div id="header">
    	<div id="headerimage"><a href="/" ><img src="library/images/logo.jpg" width="389" height="72" alt="Miracle 10 | maximum skin care" border="none"/></a> </div>
    	<!--- <iframe id="headerIFrame" src="accountHeader.html" width="200" height="75"></iframe> --->
		#viewcollection.getView("infoPod")#
        
    	<!-- end header div-->

    </div>
    
    <div id="topnav">
    	<div id="nav">
        	<ul style="margin-bottom: 0"><li><a href="/">Home</a></li></ul>
        </div>
    <!-- end mainnav div -->
    </div>
    


<div id="content"><!-- InstanceBeginEditable name="content" -->

<div id="store">
	<h1>#pageTitle#</h2>
	<div id="PageContent">
		#viewcollection.getView("body")#
	</div>
<!--store div ends here-->
</div>

<!-- InstanceEndEditable -->
   	  <div class="spacer"></div>

    <!--end content div-->
    </div>
    <div id="bottomnav">
    	<!-- InstanceBeginEditable name="footer" -->Customer Service toll-free: 1-800-803-6415 :: <a href="mailto:info@miracle10.com">Contact us</a> :: &copy; 2009 PSSC Inc., All Rights Reserved.<!-- InstanceEndEditable -->

    <!-- end bottomnav div-->
    </div>
<!-- end wrapper div-->
</div>
</body>
<!-- InstanceEnd --></html>


</cfoutput>
