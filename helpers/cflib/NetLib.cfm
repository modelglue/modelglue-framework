<!---
	
	This library is part of the Common Function Library Project. An open source
	collection of UDF libraries designed for ColdFusion 5.0. For more information,
	please see the web site at:
		
		http://www.cflib.org
		
	Warning:
	You may not need all the functions in this library. If speed
	is _extremely_ important, you may want to consider deleting
	functions you do not plan on using. Normally you should not
	have to worry about the size of the library.
		
	License:
	This code may be used freely. 
	You may modify this code as you see fit, however, this header, and the header
	for the functions must remain intact.
	
	This code is provided as is.  We make no warranty or guarantee.  Use of this code is at your own risk.
--->

<cfscript>
/**
 * calculate a network address from an IP address and a (sub)Netmask.
 * 
 * @param myIP 	 IP Address. (Required)
 * @param myNetMask 	 Netmask. (Required)
 * @return Returns an IP address (string). 
 * @author Tanguy Rademakers (&#116;&#64;&#110;&#101;&#119;&#109;&#101;&#100;&#105;&#97;&#116;&#119;&#105;&#110;&#115;&#46;&#110;&#101;&#116;) 
 * @version 1, May 12, 2003 
 */
function calcNetAddress (myIP, myNetMask) {
	var NetAddress = "";
	var i = 1;
	
	for (i = 1; i lte 4; i = i + 1) {
		NetAddress = ListAppend(NetAddress, BitAnd(ListGetAt(myIP,i,'.'),ListGetAt(myNetMask,i,'.')) ,'.'); 
	}
	return NetAddress;
}

/**
 * Converts CIDR numbers to valid network mask numbers.
 * 
 * @param cidr 	 CIDR number. (Required)
 * @return Returns a string. 
 * @author Sufiyan bin Yasa (&#99;&#105;&#110;&#111;&#100;&#95;&#55;&#57;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, July 19, 2005 
 */
function cidrToNetMask (cidr) {
	var netMask = "";	

	var post = 0;
	var remainder = cidr MOD 8;
	var divide = cidr \ 8;

	while(divide gt 0) {
		netMask = listAppend(netMask, 255,'.'); 
		divide = divide - 1;
		post = post + 1;		
	}

	if(remainder gt 0) {			
		netMask = listAppend(NetMask,
				  bitSHLN(BitOr(0,2^remainder-1), 8-remainder),
				  '.'); 		
		post = post +1;			
	}

	while(post lt 4) {
		netMask = listAppend(netMask, "0",'.'); 			
		post = post + 1;
	}
	
	if(right(netMask, 1) eq "."){		
		netMask = left(netMask,len(netMask));
	}
	return netMask;
}

/**
 * Looks up all IP addresses for a hostname and returns them in an array.  Requires Java.
 * 
 * @param host 	 Host name. (Required)
 * @return Returns an array. 
 * @author David Chaplin-Loebell (&#100;&#97;&#118;&#105;&#100;&#99;&#108;&#64;&#116;&#108;&#97;&#118;&#105;&#100;&#101;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, September 22, 2005 
 */
function getAllHostAddresses(host) {
	var iaclass=""; //holds the Java object
	var addr="";    //holds the array returned by the java object
	var hostaddr=arrayNew(1);    //holds the returned array of IP addresses.
	var i = "";
	   
	// Init class
	iaclass=CreateObject("java", "java.net.InetAddress");

	// Get address
	addr=iaclass.getAllByName(host);

	// Return the address
	for (i=1; i LTE ArrayLen(addr); i=i+1) {
		iaclass = Addr[i]; //can't access Addr[i].getHostAddress() directly in CF5
		hostaddr[i] = iaclass.getHostAddress();
	}
	return hostaddr;
}

/**
 * Get the URL of the current page.
 * Modded by RCamden
 * 
 * @return Returns a string. 
 * @author Matthew Walker (&#109;&#97;&#116;&#116;&#104;&#101;&#119;&#64;&#99;&#97;&#98;&#98;&#97;&#103;&#101;&#116;&#114;&#101;&#101;&#46;&#99;&#111;&#46;&#110;&#122;) 
 * @version 1, June 26, 2002 
 */
function GetCurrentURL() {
	var theURL = "http";
	if (cgi.https EQ "on" ) theURL = "#TheURL#s";
	theURL = theURL & "://#cgi.server_name#";
	if(cgi.server_port neq 80) theURL = theURL & ":#cgi.server_port#";
	theURL = theURL & "#cgi.path_info#";
	if(len(cgi.query_string)) theURL = theURL & "?#cgi.query_string#";
	return theURL;	
}

/**
 * Performs a reverse DNS lookup.
 * 
 * @param host 	 The host name to lookup. (Required)
 * @return Returns an IP address. 
 * @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, November 11, 2002 
 */
function GetHostAddress(host) {
   // Variables
   var iaclass="";
   var addr="";
   
   // Init class
   iaclass=CreateObject("java", "java.net.InetAddress");

   // Get address
   addr=iaclass.getByName(host);

   // Return the address	
   return addr.getHostAddress();
}

/**
 * Performs a DNS lookup on an IP address.
 * 
 * @param address 	 IP address to look up. 
 * @return Returns a domain name. 
 * @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, December 19, 2001 
 */
function GetHostName(address) {
   // Variables
   var iaclass="";
   var addr="";
   
   // Init class
   iaclass=CreateObject("java", "java.net.InetAddress");

   // Get address
   addr=iaclass.getByName(address);

   // Return the name	
   return addr.getHostName();
}

/**
 * UDF equivelant of &lt;CFHTTP&gt;
 * 
 * @param u 	 The URL to fetch. (Required)
 * @return Returns a string. 
 * @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, November 11, 2002 
 */
function HTTPGet(u) {
   // Variables
   var urlclass="";
   var page="";
   var stream="";
   var c="";
   var output="";
   
   // Init class
   urlclass=CreateObject("java", "java.net.URL");

   // Get page
   page=urlclass.init(u);

   // Get stream
   stream=page.getContent();
	
   // Display it
   for (c=stream.read(); c GT 0; c=stream.read())
   {
      output=output&chr(c);
   }

   // don't forget this part
   stream.close();
   
   return output;
}

/**
 * IP4r converts standard dotted IP addresses to their reversed IP4r equivalent.
 * 
 * @param ip4 	 IP address. (Required)
 * @return Returns a string. 
 * @author Scott Glassbrook (&#99;&#102;&#108;&#105;&#98;&#64;&#118;&#111;&#120;&#46;&#112;&#104;&#121;&#100;&#105;&#117;&#120;&#46;&#99;&#111;&#109;) 
 * @version 2, November 18, 2004 
 */
function ip4r(ip4) {
	return ReReplaceNoCase(ip4,  "([0-9]{1,3}).([0-9]{1,3}).([0-9]{1,3}).([0-9]{1,3})",  "\4.\3.\2.\1");
}

/**
 * Converts an IP address to a 32-bit dotted decimal IP number.
 * 
 * @param ipAddress 	 IP Address to convert. (Optional)
 * @return Returns a number. 
 * @author Jonathan Pickard (&#106;&#95;&#112;&#105;&#99;&#107;&#97;&#114;&#100;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, September 27, 2002 
 */
function IPAddress2IPDottedDecimal( ipAddress ) {
	var	ipValue = 0;
	var lBitShifts = "24,16,8,0";
	var i = 1;

	if ( ListLen( ipAddress, "." ) EQ 4 )
	{
		for ( ; i LTE 4; i = i + 1 )
		{
			ipValue = ipValue + BitSHLN( ListGetAt( ipAddress, i, "." ), ListGetAt( lBitShifts, i ) );
		}
	}

	return ipValue;
}

/**
 * Converts an IP address to a network class.
 * 
 * @param ip 	 IP address. (Required)
 * @return Returns a string. 
 * @author del usr (&#100;&#101;&#108;&#117;&#115;&#114;&#101;&#120;&#112;&#101;&#114;&#116;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, February 14, 2004 
 */
function IPclass(ip) {
	var myint = listFirst(ip, ".");
	if (myint GTE 1 and myint LTE 127) return "Class A";
	if (myint GTE 128 and myint LTE 191) return "Class B";
	if (myint GTE 192 and myint LTE 223) return "Class C";
	if (myint GTE 224 and myint LTE 239) return "Class D";
	if (myint GTE 240 and myint LTE 255) return "Class E";
}

/**
 * Converts IPs to integers and back for efficient database storage.
 * 
 * @param ip or numeric version 	 IP or numeric version of IP. (Required)
 * @return Returns either a number of an IP. 
 * @author Aaron Eisenberger (&#97;&#97;&#114;&#111;&#110;&#64;&#120;&#45;&#99;&#108;&#111;&#116;&#104;&#105;&#110;&#103;&#46;&#99;&#111;&#109;) 
 * @version 1, August 28, 2003 
 */
function IPConvert(val) {
	var int = '';
	var ip = arraynew(1);
	if (find('.',val))
		{
		int = 0;
		int = ListGetAt(val, 1, ".") * 256^3;
		int = int + ListGetAt(val, 2, ".") * 256^2;
		int = int + ListGetAt(val, 3, ".") * 256;
		int = int + ListGetAt(val, 4, ".");
		return int;
		}
	else
		{
		int = val;
		ip[1] = Int(int / 256^3);
		int = int - (ip[1] * 256^3);
		ip[2] = int(int / 256^2);
		int = int - (ip[2] * 256^2);
		ip[3] = int(int / 256);
		ip[4] = int - (ip[3] * 256);
		ip = ip[1] & "." & ip[2] & "." & ip[3] & "." & ip[4];
		return ip;
		}
}

/**
 * Converts a 32-bit dotted decimal IP number to an IP address.
 * 
 * @param ipValue 	 Dotted decimal value of IP address. (Required)
 * @return Returns a string. 
 * @author Jonathan Pickard (&#106;&#95;&#112;&#105;&#99;&#107;&#97;&#114;&#100;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, September 27, 2002 
 */
function IPDottedDecimal2IPAddress( ipvalue ) {
	var ipAddress = "";
	var lBitMasks = "24,16,8,0";
	var i = 1;

	for ( ; i LTE 4; i = i + 1 )
	{
		ipAddress = ipAddress & "." & BitMaskRead( ipvalue, ListGetAt( lBitMasks, i ), 8 );
	}
	ipAddress = Right( ipAddress, Len( ipAddress ) - 1 );

	return ipAddress;
}

/**
 * Is this IP within any of the IP ranges supplied.
 * 
 * @param sIP 	 The IP. (Required)
 * @param sIPREList 	 List of IP Regex strings. (Required)
 * @return Returns a boolean. 
 * @author Peter Crowley (&#112;&#99;&#114;&#111;&#119;&#108;&#101;&#121;&#64;&#119;&#101;&#98;&#122;&#111;&#110;&#101;&#46;&#105;&#101;) 
 * @version 1, April 14, 2005 
 */
function isIPInRange(sIP,sIPREList) {
	var i = 1;
	var nREListCount=ListLen(sIPREList);
	
	for (i = 1; i LTE nREListCount; i = i+1) {
		if (REFind(ListGetAt(sIPREList,i),sIP)) return true;
	}
	return false;
}

/**
 * Checks to see if a specifid address (IP address or host name) is a multicast address (Class D).
 * 
 * @param address 	 The address to check. 
 * @return Returns a boolean. 
 * @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, December 19, 2001 
 */
function IsMulticastAddress(address) {
   // Variables
   var iaclass="";
   var addr="";
   
   // Init class
   iaclass=CreateObject("java", "java.net.InetAddress");

   // Get address
   addr=iaclass.getByName(address);

   // Is Multicast (Class D)?
   return addr.isMulticastAddress();
}
</cfscript>

<!---
 Checks to see if a CF FTP connection is still connected.
 
 @param ftpObject 	 Result of a previous CFFTP call. (Required)
 @return Returns a boolean. 
 @author Willy Chang (&#119;&#105;&#108;&#108;&#121;&#46;&#109;&#120;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 @version 1, September 22, 2005 
--->
<cffunction name="ftpisConnected" output="false" returnType="boolean">
	<cfargument name="ftpObject" required="yes">
	<cfreturn ftpObject.isConnected()>
</cffunction>

<!---
 Pings a TrackBack URL.
 
 @param trackbackurl 	 The TrackBack ping URL to ping (Required)
 @param permalink 	 The permalink for the entry (Required)
 @param charset 	 Default to utf-8. (Optional)
 @param title 	 The title of the entry (Optional)
 @param excerpt 	 An excerpt of the entry (Optional)
 @param blogName 	 The name of the weblog to which the entry was posted (Optional)
 @param timeout 	 Default to 30. Value, in seconds, that is the maximum time the request can take (Optional)
 @return Returns a string. 
 @author Giampaolo Bellavite (&#103;&#105;&#97;&#109;&#112;&#97;&#111;&#108;&#111;&#64;&#98;&#101;&#108;&#108;&#97;&#118;&#105;&#116;&#101;&#46;&#99;&#111;&#109;) 
 @version 1, January 12, 2006 
--->
<cffunction name="pingTrackback" output="false" returntype="string">
	<cfargument name="trackBackURL" type="string" required="yes">
	<cfargument name="permalink" type="string" required="yes">
	<cfargument name="charset" type="string" required="no" default="utf-8">
	<cfargument name="title" type="string" required="no">
	<cfargument name="excerpt" type="string" required="no">
	<cfargument name="blogName"  type="string" required="no">
	<cfargument name="timeout"  type="numeric" required="no" default="30">
	<cfset var cfhttp = "">
	<cfhttp url="#arguments.trackBackURL#" method="post" timeout="#arguments.timeout#" charset="#arguments.charset#">
		<cfhttpparam type="header" name="Content-Type" value="application/x-www-form-urlencoded; charset=#arguments.charset#">
		<cfhttpparam type="formfield" encoded="yes" name="url" value="#arguments.permalink#">
		<cfif structKeyExists(arguments, "title")>
			<cfhttpparam type="formfield" encoded="yes" name="title" value="#arguments.title#">
		</cfif>
		<cfif structKeyExists(arguments, "excerpt")>
			<cfhttpparam type="formfield" encoded="yes" name="excerpt" value="#arguments.excerpt#">
		</cfif>
		<cfif structKeyExists(arguments, "blogName")>
			<cfhttpparam type="formfield" encoded="yes" name="blog_name" value="#arguments.blogName#">
		</cfif>
	</cfhttp>
	<cfreturn cfhttp.FileContent>
</cffunction>

<!---
 Checks to see if a particular URL actually exists.
 Gus made some changes to handle a unresolving domain.
 
 @param u 	 The URL to check. (Required)
 @return Returns a boolean. 
 @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 @version 1, January 3, 2006 
--->
<cffunction name="urlExists" output="no" returntype="boolean">
	<!--- Accepts a URL --->
	<cfargument name="u" type="string" required="yes">

	<!--- Initialize result --->
	<cfset var result=true>

	<!--- Attempt to retrieve the URL --->
	<cfhttp url="#arguments.u#" resolveurl="no" throwonerror="no" />

	<!--- Check That a Status Code is Returned --->
	<cfif isDefined("cfhttp.responseheader.status_code")>
		<cfif cfhttp.responseheader.status_code EQ "404">
			<!--- If 404, return FALSE --->
			<cfset result=false>
		</cfif>
	<cfelse>
		<!--- No Status Code Returned --->
		<cfset result=false>
	</cfif>
	<cfreturn result>
</cffunction>
