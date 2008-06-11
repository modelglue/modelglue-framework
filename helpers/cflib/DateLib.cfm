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
 * Given the date of birth, returns age.
 * 
 * @param dob 	 Date of birth. (Required)
 * @return Returns a string. 
 * @author Alexander Sicular (&#97;&#115;&#56;&#54;&#55;&#64;&#99;&#111;&#108;&#117;&#109;&#98;&#105;&#97;&#46;&#101;&#100;&#117;) 
 * @version 1, November 18, 2002 
 */
function ageSinceDOB(dob) {
  
  var ageYR = DateDiff('yyyy', dob, NOW());
  var ageMO = DateDiff('m', dob, NOW());
  var ageWK = DateDiff('ww', dob, NOW());
  var ageDY = DateDiff('d', dob, NOW());
  var age = "";
  
  if ( isDate(dob) ){    
    if (now() LT dob){
      age = "NA";
    }else{  
      if (ageYR LT 2) {
        age = ageMO & "m";
          if (ageMO LT 1) {
		    age = ageWK & "w";
		  }
		  if (ageWK LT 1) {
		    age = ageDY & "d";
		  }
	  }else{
	    age = ageYR & "y";
	  }  
    }  
  }else{    
    age = "NA";
  }  
  return age;
}

/**
 * Works just like dateAdd(), except it only adds business days
 * Version 2 by Steven Van Gemert, &#115;&#118;&#103;&#50;&#64;&#112;&#108;&#97;&#99;&#115;&#46;&#110;&#101;&#116;
 * 
 * @param date 	 Date you want to add business days to. (Required)
 * @param number 	 Number of business days to add to date. (Required)
 * @return Returns a date object. 
 * @author Billy Cravens (&#115;&#118;&#103;&#50;&#64;&#112;&#108;&#97;&#99;&#115;&#46;&#110;&#101;&#116;&#98;&#105;&#108;&#108;&#121;&#64;&#97;&#114;&#99;&#104;&#105;&#116;&#101;&#99;&#104;&#120;&#46;&#99;&#111;&#109;) 
 * @version 2, August 10, 2005 
 */
function businessDaysAdd(date,number) {
  var cAdded = 0;
  var tempDate = date;
  var direction = compare(number,0);
  while (cAdded LT abs(number)) {
	tempDate = dateAdd("d",direction,tempDate);
    if (dayOfWeek(tempDate) GTE 2 AND dayOfWeek(tempDate) LTE 6) {
      cAdded = incrementValue(cAdded);
    }
  }
  return tempDate;
}

/**
 * Calculates the number of business days between 2 dates.
 * 
 * @param date1 	 First date. (Required)
 * @param date2 	 Second date. (Required)
 * @return Returns a number. 
 * @author Harry Goldman (&#104;&#97;&#114;&#114;&#121;&#64;&#105;&#99;&#110;&#46;&#110;&#101;&#116;) 
 * @version 1, July 15, 2004 
 */
function businessDaysBetween(date1,date2) {
	var numberOfDays = 0;
	
	while (date1 LT date2) {
		date1 = dateAdd("d",1,date1);
		if(dayOfWeek(date1) GTE 2 AND dayOfWeek(date1) LTE 6) numberOfDays = incrementValue(numberOfDays);
	}

	return numberOfDays;
}

/**
 * Formats a date/time value for use on the y-axis in CFCHART.
 * 
 * @param date 	 Date/time value you want formatted for CFCHART. (Required)
 * @return Returns a numeric value. 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, October 18, 2002 
 */
function cfchartDateFormat() {
  var datetime = 0;
  if (ArrayLen(Arguments) eq 0) {
    datetime = Now();
  }
  else {
    datetime = arguments[1];
  }
  return numberFormat(DateDiff("s", DateConvert("utc2Local", "January 1 1970 00:00"), datetime) * 1000);
}

/**
 * Returns the Chinese Zodiac animal corresponding to the given year of birth.
 * 
 * @param yyyy 	 Year (in the format yyyy) you want the Chinese Zodiac animal for. 
 * @return Returns a string. 
 * @author Sierra Bufe (&#115;&#105;&#101;&#114;&#114;&#97;&#64;&#98;&#114;&#105;&#103;&#104;&#116;&#101;&#114;&#102;&#117;&#115;&#105;&#111;&#110;&#46;&#99;&#111;&#109;) 
 * @version 1, December 3, 2001 
 */
function ChineseZodiac(yyyy) {
  var Animals = ListToArray("Monkey,Chicken,Dog,Pig,Mouse,Ox,Tiger,Rabbit,Dragon,Snake,Horse,Sheep");
  return Animals[(yyyy MOD 12) + 1];	
}

/**
 * Function that determines if a given date range contains a leap year.
 * 
 * @param startDate 	 Initial date. (Required)
 * @param endDate 	 Ending date. (Required)
 * @return Returns a boolean. 
 * @author Mosh Teitelbaum (&#109;&#111;&#115;&#104;&#46;&#116;&#101;&#105;&#116;&#101;&#108;&#98;&#97;&#117;&#109;&#64;&#101;&#118;&#111;&#99;&#104;&#46;&#99;&#111;&#109;) 
 * @version 1, May 26, 2003 
 */
function containsLeapYear(startDate, endDate) {
	// Build offsets
	var StartDateYearOffset = DateAdd("yyyy", 1, startDate);
	var StartDateYearOffsetInDays = DateDiff("d", startDate, StartDateYearOffset);
	var EndDateYearOffset = DateAdd("yyyy", 1, Trim(endDate));
	var EndDateYearOffsetInDays = DateDiff("d", endDate, EndDateYearOffset);

	// Return result
	return IIf(StartDateYearOffsetInDays - EndDateYearOffsetInDays GT 0, DE("true"), DE("false"));
}

/**
 * Converts Active Directory 100-Nanosecond time stamps.
 * 
 * @param adTime 	 Time in ActiveDirectory format. (Required)
 * @return Returns a struct. 
 * @author Tariq Ahmed (&#116;&#97;&#114;&#105;&#113;&#64;&#100;&#111;&#112;&#101;&#106;&#97;&#109;&#46;&#99;&#111;&#109;) 
 * @version 1, September 6, 2006 
 */
function convertActiveDirectoryTime(adTime) {
	var retVal = structNew();
	var tempTime = arguments.adTime / (60*10000000);
	retVal.ts = DateAdd('n',tempTime,'1/1/1601');
	retVal.ts = DateConvert("utc2Local", retVal.ts );
	retVal.date = Dateformat(retVal.ts,'mm/dd/yyyy');
	retVal.time = Timeformat(retVal.ts,'HH:mm');
	return retVal;
}

/**
 * Function that returns legal billing time from standard time format.
 * 
 * @param hourString 	 A string containing the number of hours, minutes, and seconds in the format: H:MM:SS. (Required)
 * @return Returns a string. 
 * @author Joe (&#106;&#99;&#114;&#97;&#118;&#101;&#110;&#64;&#97;&#107;&#105;&#110;&#103;&#117;&#109;&#112;&#46;&#99;&#111;&#109;) 
 * @version 1, July 3, 2002 
 */
function ConvertHours(HourString) {
	var HourWords = "";
	var MinuteVal = Round(val(listGetAt(HourString,2,":"))/6);
	var HourVal = listFirst(hourString,":");
	
	if(len(HourVal) is 1) {
		if(HourVal is "0") HourWords = '0.';
		else HourWords = HourVal & '.';
	} else HourWords = HourVal & '.';
	
	HourWords = HourWords & MinuteVal;
	return HourWords;
}

/**
 * Returns the number of specific days between a start and end date - i.e. weekdays or workdays.
 * 
 * @param startdate 	 Starting date. (Required)
 * @param enddate 	 Ending date. (Required)
 * @param exclude 	 Days of the week (as a number) to include. Defaults to 1,7 (Optional)
 * @param includeStartDate 	 Boolean value to indicate if startdate is included in count. Defaults to true. (Optional)
 * @return Returns a number. 
 * @author Isaac Dealey (&#105;&#110;&#102;&#111;&#64;&#116;&#117;&#114;&#110;&#107;&#101;&#121;&#46;&#116;&#111;) 
 * @version 1, December 5, 2006 
 */
function countArbitraryDays(startdate,enddate) { 
	var exclude = "1,7"; var IncludeStartDate = true; 
	var daysperweek = 0; var days = 0; 
	var weekday = ArrayNew(1); var x = 0; 
	var maxdays = DateDiff("d",dateadd("d",-1,startdate),enddate); 
	
	switch (arrayLen(arguments)) { 
		case 4: { IncludeStartDate = arguments[4]; } 
		case 3: { exclude = arguments[3]; } 
	} 
	
	// create an array to hold days of the week with 1 or 0 indicating if the day is counted 
	arraySet(weekday,1,7,1); exclude = listToArray(exclude); 
	for (x = 1; x lte arrayLen(exclude); x = x + 1) { weekday[exclude[x]] = 0; } // set the value of any excluded day to 0 
	daysperweek = arraySum(weekday); // count the number of included days in a full week 
	days = daysperweek * int(maxdays/7); // get the number of included days in all full weeks 
	for (x = 1; x lte maxdays mod 7; x = x + 1) { // add any remaining days in the last partial week 
		days = days + weekday[dayofweek(enddate)]; 
		enddate = dateadd("d",-1,enddate); 
	} 
	
	// if excluding the start date, remove the value that might have been added for the starting day 
	if (not includeStartDate) { days = days - weekday[dayofweek(startdate)]; } 
	
	return days; 
}

/**
 * Creates a date range array.
 * 
 * @param startdate 	 The starting date. (Required)
 * @param ndays 	 The number of days. This will include the starting date. (Required)
 * @param dtformat 	 Date format. Defaults to "mm/dd/yyyy" (Optional)
 * @return Returns an array. 
 * @author Casey Broich (&#99;&#97;&#98;&#64;&#112;&#97;&#103;&#101;&#120;&#46;&#99;&#111;&#109;) 
 * @version 1, May 20, 2003 
 */
function CreateDateRange(startdate,ndays) {
  var dtarray = arraynew(1);
  var i = 1;
  var ndate = "";
  var dtformat = "mm/dd/yyyy";
  
  if (ArrayLen(arguments) gte 3) dtformat = arguments[3];
  ndate = dateformat(startdate,"mm/dd/yyyy") - 1;
  for(i = 1; i lte ndays; i = i+1) {
    ndate = dateformat(ndate+1,dtformat);
    arrayappend(dtarray, ndate);
  }
  return dtarray;
}

/**
 * Converts a given number of days, hours, minutes, OR seconds to a struct of days, hours, minutes, AND seconds.
 * 
 * @param timespan 	 The timespan to convert. 
 * @return Returns a structure. 
 * @author Dave Pomerance (&#100;&#112;&#111;&#109;&#101;&#114;&#97;&#110;&#99;&#101;&#64;&#109;&#111;&#115;&#46;&#111;&#114;&#103;) 
 * @version 1, January 7, 2002 
 */
function CreateTimeStruct(timespan) {
    var timestruct = StructNew();
    var mask = "s";

    if (ArrayLen(Arguments) gte 2) mask = Arguments[2];

	// if timespan isn't an integer, convert mask towards s until timespan is an integer or mask is s
	while (Int(timespan) neq timespan AND mask neq "s") {
		if (mask eq "d") {
			timespan = timespan * 24;
			mask = "h";
		} else if (mask eq "h") {
			timespan = timespan * 60;
			mask = "m";
		} else if (mask eq "m") {
			timespan = timespan * 60;
			mask = "s";
		}
	}
	
	// only 4 allowed values for mask - if not one of those, return blank struct
	if (ListFind("d,h,m,s", mask)) {
		// compute seconds
		if (mask eq "s") {
			timestruct.s = (timespan mod 60) + (timespan - Int(timespan));
			timespan = int(timespan/60);
			mask = "m";
		} else timestruct.s = 0;
		// compute minutes
		if (mask eq "m") {
			timestruct.m = timespan mod 60;
			timespan = int(timespan/60);
			mask = "h";
		} else timestruct.m = 0;
		// compute hours, days
		if (mask eq "h") {
			timestruct.h = timespan mod 24;
			timestruct.d = int(timespan/24);
		} else {
			timestruct.h = 0;
			timestruct.d = timespan;
		}
	}
	
	return timestruct;
}

/**
 * Returns a time range for a particular date from midnight to 11:59:59 the same day except for Monday.
 * 
 * @param dateIn 	 Date value to use for range. (Required)
 * @return Returns a string. 
 * @author Dharmesh Goel (&#100;&#114;&#103;&#111;&#101;&#108;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, April 4, 2007 
 */
function dailyBusinessReportDateRange(dateIn) {
	var dateRange = "";
	var dateOut1 = "";
	var dateOut2 = "";
	
	dateIn = dateFormat(dateIn, 'MM/DD/YYYY');
	
	if(dayOfWeek(dateIn) EQ 2) {
		dateOut1 = dateAdd("d",-2,dateIn);
		dateOut2 = dateadd("s",-1,dateAdd("d",1,dateIn));
	} else {
		dateOut1 = dateAdd("d",0,dateIn);
		dateOut2 = dateadd("s",-1,dateAdd("d",1,dateIn));
	}
	dateRange = dateout1 & "," & dateOut2;

	return dateRange;
}

/**
 * Converts ColdFusion date to linux timestamp.
 * 
 * @param cfdate 	 A ColdFusion datetime value. (Required)
 * @return Retuns a number. 
 * @author Michael Fritz (&#109;&#105;&#116;&#99;&#104;&#105;&#114;&#117;&#95;&#106;&#111;&#64;&#103;&#109;&#120;&#46;&#100;&#101;) 
 * @version 1, September 28, 2006 
 */
function date2Timestamp(cfdate) {
	return dateDiff('s',createDate(1970,1,1),cfdate);
}

/**
 * Convert a date in ISO 8601 format to an ODBC datetime.
 * 
 * @param ISO8601dateString 	 The ISO8601 date string. (Required)
 * @param targetZoneOffset 	 The timezone offset. (Required)
 * @return Returns a datetime. 
 * @author David Satz (&#100;&#97;&#118;&#105;&#100;&#95;&#115;&#97;&#116;&#122;&#64;&#104;&#121;&#112;&#101;&#114;&#105;&#111;&#110;&#46;&#99;&#111;&#109;) 
 * @version 1, September 28, 2004 
 */
function DateConvertISO8601(ISO8601dateString, targetZoneOffset) {
	var rawDatetime = left(ISO8601dateString,10) & " " & mid(ISO8601dateString,12,8);
	
	// adjust offset based on offset given in date string
	if (uCase(mid(ISO8601dateString,20,1)) neq "Z")
		targetZoneOffset = targetZoneOffset -  val(mid(ISO8601dateString,20,3)) ;
	
	return DateAdd("h", targetZoneOffset, CreateODBCDateTime(rawDatetime));

}

/**
 * Similar to DateConvert, but provides local2zone and zone2local conversion from one time zone to another.
 * 
 * @param conversionType 	 Conversion type to use.  Options are zone2local (date object is from the specified time zone and this will convert it to local time) and local2zone (date object is based on local server time and this will convert it to the specfied time zone.):   
 * @param dateObj 	 Date object you want to convert. 
 * @param zoneInfo 	 Standard time zone abbreviation as well as standard plus mod such as PST-8. 
 * @return Returns a date/time object. 
 * @author Chris Wigginton (&#99;&#119;&#105;&#103;&#103;&#105;&#110;&#116;&#111;&#110;&#64;&#109;&#97;&#99;&#114;&#111;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, November 26, 2001 
 */
function DateConvertZ(conversionType, dateObj, zoneInfo)
{
  var targetZone = "";
  var targetSpan = 0;
  var targetDate = "";
  var utcDate = "";
  var hourDiff = 0;
  var minDiff = 0;
  var zoneModOffSet = 0;
  var zoneMod = 0;
	
  //timeZone object
  var timeZone = StructNew();
  timeZone.UTC  =   0;     // Universal Time Coordinate or universal time zone
  timeZone.GMT  =   0;     // Greenwich Mean Time same as UTC
  timeZone.BST  =   1;     // British Summer time
  timeZone.IST  =   1;     // Irish Summer Time
  timeZone.WET  =   1;     // Western Europe Time
  timeZone.WEST =   1;     // Western Europe Summer Time
  timeZone.CET  =   1;     // Central Europe Time
  timeZone.CEST =   2;     // Central Europe Summer Time
  timeZone.EET  =   2;     // Eastern Europe Time
  timeZone.EEST =   3;     // Eastern Europe Summer Time
  timeZone.MSK  =   3;     // Moscow time
  timeZone.MSD  =   4;     // Moscow Summer Time
  timeZone.AST  =  -4;     // Atlantic Standard Time
  timeZone.ADT  =  -3;     // Atlantic Daylight Time
  timeZone.EST  =  -5;     // Eastern Standard Time
  timeZone.EDT  =  -4;     // Eastern Daylight Saving Time
  timeZone.CST  =  -6;     // Eastern Time
  timeZone.CDT  =  -5;     // Central Standard Time
  timeZone.MST  =  -7;     // Mountain Standard Time
  timeZone.MDT  =  -6;     // Mountain Daylight Saving Time
  timeZone.PST  =  -8;     // Pacific Standard Time
  timeZone.HST  = -10;     // Hawaiian Standard Time
  timeZone.AKST =  -9;     // Alaska Standard Time
  timeZone.AKDT =  -8;     // Alaska Standard Daylight Saving Time
  timeZone.AEST =  10;     // Australian Eastern Standard Time
  timeZone.AEDT =  11;     // Australian Eastern Daylight Time
  timeZone.ACST = 9.5;     // Australian Central Standard Time
  timeZone.ACDT = 10.5;    // Australian Central Daylight Time
  timeZone.AWST =   8;     // Australian Western Standard Time
    
  //Check for +- timezone mod such as PST-4
  zoneModOffSet = FindOneOf("+-", zoneInfo);
  if(zoneModOffSet) {
    //Extract out the zoneInfo and zoneMod
    zoneMod = Val(Right(zoneInfo, Len(zoneInfo) - zoneModOffSet + 1));
    zoneInfo = Left(zoneInfo, zonemodOffSet - 1);			
  }
	
  targetZone = timeZone[zoneInfo] + zoneMod;
	
  // Grab Target Zone Info
  hourDiff = fix(targetZone);
  minDiff = (targetZone - hourDiff) * 60; 
	
  targetSpan = CreateTimeSpan(0, hourDiff, minDiff, 0);

  if (conversionType IS "local2zone") {
    // date is local time so convert it to utc first
    utcDate = DateConvert("Local2Utc", dateObj) ;
    // Add the target zone difference
    targetDate = utcDate + targetSpan;
    return "{ts '" & DateFormat(targetDate, "yyyy-mm-dd ") & TimeFormat(targetDate, "HH:mm:ss") & "'}";
  }
  else if (conversionType is "zone2local") {
    //date is in the target zone so convert it to utc first
    targetDate = dateObj - targetSpan;
    //convert it back from utc to local
    targetDate = DateConvert("Utc2local", targetDate);	
    return "{ts '" & DateFormat(targetDate, "yyyy-mm-dd ") & TimeFormat(targetDate, "HH:mm:ss") & "'}";
  }
  return "{ts 'yyyy-mm-dd HH:mm:ss'}"; // error return
}

/**
 * Add's the st,nd,rd,th after a day of the month.
 * 
 * @param dateStr 	 Date to use. (Required)
 * @param formatStr 	 Format string for month and year. (Optional)
 * @return Returns a string. 
 * @author Ian Winter (&#105;&#97;&#110;&#64;&#100;&#101;&#102;&#117;&#115;&#105;&#111;&#110;&#120;&#46;&#111;&#109;) 
 * @version 1, May 22, 2003 
 */
function dateLetters(dateStr) {
	var letterList="st,nd,rd,th";
	var domStr=DateFormat(dateStr,"d");
	var domLetters='';
	var formatStr = "";

	if(arrayLen(arguments) gte 2) formatStr = dateFormat(dateStr,arguments[2]);

	switch (domStr) {
		case "1": case "21": case "31":  domLetters=ListGetAt(letterList,'1'); break;
		case "2": case "22": domLetters=ListGetAt(letterList,'2'); break;
		case "3": case "23": domLetters=ListGetAt(letterList,'3'); break;
		default: domLetters=ListGetAt(letterList,'4');
	}

	return domStr & domLetters & " " & formatStr;
}

/**
 * Format a range of dates (&quot;August 3 - 11, 2003&quot;).
 * Small bug in last statement was losing end date. RKC
 * 
 * @param startDate 	 Initial date. Defaults to now. (Optional)
 * @param endDate 	 Ending date. Defaults to now. (Optional)
 * @param format 	 Either "long" or "short". Defaults to long. (Optional)
 * @return Returns a string. 
 * @author Bryan Buchs (&#98;&#98;&#117;&#99;&#104;&#115;&#64;&#109;&#97;&#99;&#46;&#99;&#111;&#109;) 
 * @version 1, June 8, 2004 
 */
function DateRangeFormat() {
	var format = "long";
	var longformat = "mmmm d, yyyy";
	var shortformat = "m/d/yy";
	var applyformat = longformat;
	var startDate = now();
	var endDate = now();
	var startFormat = DateFormat(startDate,format);
	var endFormat = DateFormat(endDate,format);
	var DateRangeFormat = startFormat;
	
	if (arrayLen(arguments) GTE 1) { startDate = arguments[1]; }
	if (arrayLen(arguments) GTE 2) { endDate = arguments[2]; }
	if (arrayLen(arguments) GTE 3) { format = arguments[3]; }
	
	if(format is not "long" and format is not "short") format = "long";
	if(format is not "long") applyformat = shortformat;
	
	//case one, same month and year
	if(year(startDate) is year(endDate) and month(startDate) is month(endDate)) {
		startFormat = dateFormat(startDate,ReplaceNoCase(applyformat,"y","","All"));
		if(format is "long") {
			endFormat = dateFormat(endDate,ReplaceNoCase(applyformat,"m","","All"));
		} else {
			endFormat = dateFormat(endDate,applyformat);
		}
	} else if(year(startDate) is year(endDate)) {
	//case two, same year
		startFormat = DateFormat(startDate,ReplaceNoCase(applyformat,"y","","All"));
		endFormat = DateFormat(endDate,applyformat);
	} else {
	//case three, different year and month, dont change anything
		startFormat = DateFormat(startDate,applyformat);
		endFormat = DateFormat(endDate,applyformat);
	}

	if (right(trim(startFormat),1) EQ "," or right(trim(startFormat),1) EQ "/") { 
		startFormat = trim(RemoveChars(startFormat,len(trim(startFormat)), 1)); 
	}

	if (arrayLen(arguments) GTE 2 AND startDate NEQ endDate) {
		DateRangeFormat = startFormat & " - " & endFormat;
	} else {
		DateRangeFormat = dateFormat(startDate,applyformat);
	}
	
	return trim(DateRangeFormat);
}

/**
 * Calls both DateFormat and TimeFormat on a data object.
 * 
 * @param time 	 A data object. 
 * @param dateFormat 	 The string to use to format dates. Defaults to  
 * @param timeFormat 	 The string to use to format time. Defaults to  
 * @param joinStr 	 This string is placed between the date and time. Defaults to one space character. 
 * @return This function returns a string. 
 * @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, November 26, 2001 
 */
function DateTimeFormat(time) {
	var str = "";
	var dateFormat = "mmmm d, yyyy";
	var timeFormat = "h:mm tt";
	var joinStr = " ";
	
	if(ArrayLen(Arguments) gte 2) dateFormat = Arguments[2];
	if(ArrayLen(Arguments) gte 3) timeFormat = Arguments[3];
	if(ArrayLen(Arguments) gte 4) joinStr = Arguments[4];

	return DateFormat(time, dateFormat) & joinStr & TimeFormat(time, timeFormat);
}

/**
 * Returns a string for a day value.
 * 
 * @param daynum 	 Day number to convert. (Required)
 * @return Returns a string. 
 * @author Larry Juncker (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;) 
 * @version 1, November 1, 2002 
 */
function dayAsString(daynum) {
    var dayList="First,Second,Third,Fourth,Fifth,Sixth,Seventh,Eighth,Ninth,Tenth,Eleventh,Twelveth,Thirteenth,Fourteenth,Fifteenth,Sixteenth,Seventeenth,Eighteenth,Nineteenth,Twentieth,Twenty First,Twenty Second,Twenty Third,Twenty Fourth,Twenty Fifth,Twenty Sixth,Twenty Seventh,Twenty Eighth,Twenty Ninth,Thirtieth,Thirty First";
    return ListGetAt(dayList,daynum);
}

/**
 * Returns number of days until your next birthday.
 * 
 * @param birthdate 	 Birthdate you want to find the number of days until.  Accepts any valid date object. 
 * @return Returns a numeric value. 
 * @author Jason Fuller (&#106;&#97;&#115;&#111;&#110;&#64;&#121;&#111;&#109;&#97;&#109;&#109;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, February 12, 2002 
 */
function DaysTilBirthday(birthdate) {
  var daysRemaining = "";
  if (DateFormat(now(), "MMDD") GT DateFormat(birthdate, "MMDD")) 
    daysRemaining = Int(CreateDate(DatePart("yyyy", now() + 365), DatePart("m", birthdate), DatePart("d", birthdate)) - now() + 1);
  else 
    daysRemaining = Int(CreateDate(DatePart("yyyy", now()), DatePart("m", birthdate), DatePart("d", birthdate)) - now() + 1);
  Return daysRemaining;
}

/**
 * Returns an integer of the days left before Christmas.
 * Version 2 by Ken McCafferty
 * 
 * @return Returns a number. 
 * @author Larry Juncker (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;) 
 * @version 2, October 4, 2002 
 */
function DaysTillChristmas() {
	var ChristmasDayOfYearThisYear =
DayofYear(CreateDate(Year(Now()),12,25));
	var ChristmasDayOfYearNextYear =
DayofYear(CreateDate(Year(Now()) + 1,12,25));
	var TodaysDayOfYear = DayofYear(Now());
	var DaysThisYear=DaysInYear(Now());
	  //Christmas coming
	if (ChristmasDayOfYearThisYear gt TodaysDayOfYear){
	   return ChristmasDayOfYearThisYear -
TodaysDayOfYear;
	}
	 //Christmas has passed
	if (TodaysDayOfYear gt ChristmasDayOfYearThisYear){
	 return DaysThisYear-TodaysDayOfYear +
ChristmasDayOfYearNextYear;
	}
		
	return 0;
}

/**
 * Converts decimal to time.
 * 
 * @param decimal 	 A number between 0 and 23.99. (Required)
 * @param timeMask 	 Mask for formatting. Defaults to hh:mm tt. (Optional)
 * @return Returns a string. 
 * @author Nick Giovanni (&#97;&#117;&#100;&#105;&#46;&#116;&#116;&#64;&#118;&#101;&#114;&#105;&#122;&#111;&#110;&#46;&#110;&#101;&#116;) 
 * @version 1, August 9, 2005 
 */
function decimal2Time(decimal){
	var timeMask = "hh:mm tt"; 
	var timeValue = ""; 
	var decimalMinutes = "";
	var decimalHours = "";

	//make sure passed value is numeric
	if(not isNumeric(decimal)) return "The value passed to function decimalToTime() is not a valid number!";

	timeValue =  numberFormat(decimal,"99.99");
	
	if(timeValue LT 0 OR timeValue GTE 24) return "The value passed to function decimalToTime() is not within the valid range of 0 - 23.99"; 

	//if the optional mask was passed use that otherwise default to "hh:mm tt"
	if(arrayLen(arguments) gt 1) timeMask = arguments[2];
			
	decimalHours = listfirst(timeValue,".");
	decimalMinutes = listLast(timeValue,".");
			
	//attempt to determine minutes 
	if(decimalMinutes neq 0) decimalMinutes = round(60*decimalMinutes/100);
			
	timeValue = timeFormat(decimalHours & ":" & decimalMinutes,timeMask);
	return timeValue;
}

/**
 * Check if two dates refer to the same day.
 * 
 * @param date1 	 First date to check. 
 * @param date2 	 Second date to check. 
 * @return Returns a boolean. 
 * @author Matthew Walker (&#109;&#97;&#116;&#116;&#104;&#101;&#119;&#64;&#99;&#97;&#98;&#98;&#97;&#103;&#101;&#116;&#114;&#101;&#101;&#46;&#99;&#111;&#46;&#110;&#122;) 
 * @version 1, March 21, 2002 
 */
function DifferentDay(date1, date2) {
	return ( ( DayOfYear(date1) NEQ DayOfYear(date2) ) OR ( Year(date1) NEQ Year(date2) ) );
}

/**
 * Check if two dates refer to the same month.
 * 
 * @param date1 	 First date to check. 
 * @param date2 	 Second date to check. 
 * @return Returns a boolean. 
 * @author Matthew Walker (&#109;&#97;&#116;&#116;&#104;&#101;&#119;&#64;&#99;&#97;&#98;&#98;&#97;&#103;&#101;&#116;&#114;&#101;&#101;&#46;&#99;&#111;&#46;&#110;&#122;) 
 * @version 1, March 21, 2002 
 */
function DifferentMonth(date1, date2) {
	return ( ( Month(date1) NEQ Month(date2) ) OR ( Year(date1) NEQ Year(date2) ) );
}

/**
 * Duration(dateObj1, dateObj2)
Takes two date objects and returns a structure containing the duration of days, hours, and minutes.
 * 
 * @param dateObj1  	 CF Date Object to compare 
 * @param dateObj2  	 CF Date Object to compare 
 * @return Returns a structure containing the keys Days, Hours, and Minutes with their associated values. 
 * @author Chris Wigginton (&#99;&#119;&#105;&#103;&#103;&#105;&#110;&#116;&#111;&#110;&#64;&#109;&#97;&#99;&#114;&#111;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1.0, November 18, 2001 
 */
function Duration(dateObj1, dateObj2)
{
	var dateStorage = dateObj2;
	var DayHours = 0;
	var DayMinutes = 0;
	var HourMinutes = 0;
	var timeStruct = structNew();
	
	if (DateCompare(dateObj1, dateObj2) IS 1)
	{
			dateObj2 = dateObj1;
			dateObj1 = dateStorage;
	}
	
	timeStruct.days = DateDiff("d",dateObj1,dateObj2);
	DayHours = timeStruct.days * 24;
	timeStruct.hours = DateDiff("h",dateObj1,dateObj2);
	timeStruct.hours = timeStruct.hours - DayHours;

	DayMinutes = timeStruct.days * 1440;
	HourMinutes = timeStruct.hours * 60;
	timeStruct.minutes = DateDiff("n",dateObj1,dateObj2);
	timeStruct.minutes = timeStruct.minutes - (DayMinutes + HourMinutes);
	
	return timeStruct;
}

/**
 * Converts a UNIX epoch time to a ColdFusion date object.
 * 
 * @param epoch 	 Epoch time, in seconds. (Required)
 * @return Returns a date object. 
 * @author Chris Mellon (&#109;&#101;&#108;&#108;&#111;&#110;&#64;&#109;&#110;&#114;&#46;&#111;&#114;&#103;) 
 * @version 1, June 21, 2002 
 */
function EpochTimeToDate(epoch) {
    return DateAdd("s", epoch, "January 1 1970 00:00:00");
}

/**
 * Converts Epoch time to a ColdFusion date object in local time.
 * 
 * @param epoch 	 Epoch time, in seconds. (Required)
 * @return Returns a date object. 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, June 21, 2002 
 */
function EpochTimeToLocalDate(epoch) {
  return DateAdd("s",epoch,DateConvert("utc2Local", "January 1 1970 00:00"));
}

/**
 * Analogous to firstDayOfMonth() function.
 * 
 * @param date 	 Date object used to figure out week. (Required)
 * @return Returns a date. 
 * @author Pete Ruckelshaus (&#112;&#114;&#117;&#99;&#107;&#101;&#108;&#115;&#104;&#97;&#117;&#115;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, September 12, 2007 
 */
function firstDayOfWeek(date) {
	var dow = "";
	var dowMod = "";
	var dowMult = "";
	var firstDayOfWeek = "";
	date = trim(arguments.date);
	dow = dayOfWeek(date);
	dowMod = decrementValue(dow);
	dowMult = dowMod * -1;
	firstDayOfWeek = dateAdd("d", dowMult, date);
	
	return firstDayOfWeek;
}

/**
 * Returns a date object of the first occurance of a specified day in the given month and year.
 * 
 * @param day_number 	 An integer in the range 1 - 7. 1=Sun, 2=Mon, 3=Tue, 4=Wed, 5=Thu, 6=Fri, 7=Sat. (Required)
 * @param month_number 	 Month value.  (Required)
 * @param year 	 Year value. (Required)
 * @return Returns a date object. 
 * @author Troy Pullis (&#116;&#112;&#117;&#108;&#108;&#105;&#115;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, March 23, 2005 
 */
function FirstXDayOfMonth(day_number,month_number,year) {
  var start_of_month = CreateDate(year,month_number,1);  // date object of first day for given month/year
  var daydiff = DayOfWeek(start_of_month) - day_number;
  var return_date = "";
  switch(daydiff) {
    case "-1": return_date = DateAdd("d",1,start_of_month); break;
    case "6": return_date = DateAdd("d",1,start_of_month); break;
    case "-2": return_date = DateAdd("d",2,start_of_month); break;
    case "5": return_date = DateAdd("d",2,start_of_month); break;
    case "-3": return_date = DateAdd("d",3,start_of_month); break;
    case "4": return_date = DateAdd("d",3,start_of_month); break;
    case "-4": return_date = DateAdd("d",4,start_of_month); break;
    case "3": return_date = DateAdd("d",4,start_of_month); break;
    case "-5": return_date = DateAdd("d",5,start_of_month); break;
    case "2": return_date = DateAdd("d",5,start_of_month); break;
    case "-6": return_date = DateAdd("d",6,start_of_month); break;
    case "1": return_date = DateAdd("d",6,start_of_month); break;
    default: return_date = start_of_month; break;  // daydiff=0, default to first day in current month
  } //end switch
  return return_date;
}

/**
 * Returns the date for Ascension in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to get Ascension for. 
 * @return Returns a date object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 5, 2001 
 */
function GetAscension() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  Return DateAdd("d", 39, GetEaster(TheYear));
}

/**
 * Returns a date for Ash Wednesday in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to return Ash Wednesday for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, September 4, 2001 
 */
// Ash Wednesday: Seventh Wednesday before Easter
function GetAshWednesday() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return DateAdd("D",-46,GetEaster(TheYear));
}

/**
 * A function which returns a Beginning Of Day TimeStamp. For example, 1/1/2000 10:30 PM returns {ts '2000-01-01 00:00:00'}.
 * 
 * @param date 	 Date to use. (Required)
 * @return Returns a timestamp. 
 * @author Sami Hoda (&#115;&#97;&#109;&#105;&#104;&#111;&#100;&#97;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, January 30, 2006 
 */
function getBegOfDayTS(date) {
	var vDate = date;	
	vDate = dateFormat(vDate, 'MM/DD/YYYY');
	vDate = DateAdd("h",00,vDate);
	vDate = DateAdd("n",00,vDate);
	vDate = DateAdd("s",00,vDate);
	
	return vDate;
}

/**
 * Returns the date for Christmas day in a given year.
 * 
 * @param TheYear 	 The year you want to return Christmas day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 4, 2001 
 */
function GetChristmasDay() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,12,25);
}

/**
 * Returns a date for Columbus Day in a given year.  If no year is specified, defaults to the current year.
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library. Minor modifications by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;)
 * 
 * @param TheYear 	 The year you want to return Columbus Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 22, 2001 
 */
//Columbus Day:second monday in september
function GetColumbusDay()
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,10,GetNthOccOfDayInMonth(2,2,10,TheYear));
}

/**
 * Returns the date for Corpus Christi in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to get Corpus Christi for. 
 * @return Returns a date object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 5, 2001 
 */
function GetCorpusChristi() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  Return DateAdd("d", 60, GetEaster(TheYear));
}

/**
 * This UDF uses a persons birthdate to output their current age in years.
 * 11/30/01 - Optimize code: Sierra Bufe (&#115;&#105;&#101;&#114;&#114;&#97;&#64;&#98;&#114;&#105;&#103;&#104;&#116;&#101;&#114;&#102;&#117;&#115;&#105;&#111;&#110;&#46;&#99;&#111;&#109;)
 * 
 * @param birthdate 	 Valid date object representing a person's birth date. 
 * @return Returns a numeric value. 
 * @author Eric Dobris (&#115;&#105;&#101;&#114;&#114;&#97;&#64;&#98;&#114;&#105;&#103;&#104;&#116;&#101;&#114;&#102;&#117;&#115;&#105;&#111;&#110;&#46;&#99;&#111;&#109;&#115;&#119;&#111;&#111;&#111;&#115;&#104;&#50;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, November 30, 2001 
 */
function GetCurrentAge(birthdate){ 
  return datediff('yyyy',birthdate,now());
}

/**
 * Returns the current two-part financial year in a specified format.
 * 
 * @param mask 	 Formats result using y1 and y2. (Required)
 * @param date 	 Date to use. Defaults to now(). (Optional)
 * @return Returns a string. 
 * @author Toby Tremayne (&#116;&#111;&#98;&#121;&#64;&#108;&#121;&#114;&#105;&#99;&#105;&#115;&#116;&#46;&#99;&#111;&#109;&#46;&#97;&#117;) 
 * @version 1, May 26, 2003 
 */
function getCurrentFinYear(mask) {
 	var finYear = "";
	var partOne = "";
	var partTwo = "";
	var date = now();

	if(arrayLen(arguments) gte 2) date = arguments[2];
	
	// if the current month falls in the first 6 months of the year...
	if (month(date) lte 6) {
		// first part is last year
		partOne = year(dateAdd("yyyy", -1, date));
		// second part is this year
		partTwo = year(date);
	} else {
		// first part is this year
		partOne = year(date);
		// second part is next year
		partTwo = year( dateAdd("yyyy", 1, date) );
	}
	// replace mask tokens for return
	finYear = replaceNoCase(mask,"y1",partOne);
	finYear = replaceNoCase(finYear,"y2",partTwo);
	
	return finYear;
}

/**
 * Calculates the date and time from a provided Julian Day value.
 * 
 * @param JulianDay 	 Value representing the Julian day you want to retrieve the date/time for. 
 * @return Returns a date/time object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 5, 2001 
 */
function GetDateFromJulianDay(JulianDay){
	var a = 0;
	var b = 0;
	var c = 0;
	var d = 0;
	var e = 0;
	var m = 0;
	var date = 0;
	var JD = JulianDay;
	var time = 0;
	
	a = JD + 32044;
	b = ((4 * a) + 3) \ 146097;
	c = a - (b * 146097) \ 4;
	d = (4 * c + 3) \ 1461;
	e = c - ((1461 * d) \ 4);
	m = (5 * e + 2) \ 153;

	time = TimeFormat(JulianDay, "HH:MM:SS");
	date = DateAdd("h", 12, CreateDateTime(((b * 100) + d - 4800 + (m \ 10)), (m + 3 - (12 * (m \ 10))), ((e - (153 * m + 2) \ 5) + 1), DatePart("h", time), DatePart("n", time), DatePart("s", time)));
	
	return date;
}

/**
 * Calculates the date and time based on a modified Julian Day.
 * 
 * @param JulianDay 	 Value representing the modified Julian day you want to retrieve the date/time for. 
 * @return Returns a date/time object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 5, 2001 
 */
function getDateFromModifiedJulianDay(JulianDay){
	var a = 0;
	var b = 0;
	var c = 0;
	var d = 0;
	var e = 0;
	var m = 0;
	var date = 0;
	var JD = JulianDay;
	var time = 0;
	
	a = (JD + 2400001) + 32044;
	b = ((4 * a) + 3) \ 146097;
	c = a - (b * 146097) \ 4;
	d = (4 * c + 3) \ 1461;
	e = c - ((1461 * d) \ 4);
	m = (5 * e + 2) \ 153;

	time = TimeFormat(JulianDay, "HH:MM:SS");
	date = CreateDateTime(((b * 100) + d - 4800 + (m \ 10)), (m + 3 - (12 * (m \ 10))), ((e - (153 * m + 2) \ 5) + 1), DatePart("h", time), DatePart("n", time), DatePart("s", time));
	
	return date;
}

/**
 * Returns the date for the End of Daylight Saving Time for a given year.
 * This function requires the GetLastOccOfDayInMonth() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to return the end of Daylight Saving Time. (Optional)
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, December 20, 2006 
 */
function getDaylightSavingTimeEnd() {
	var TheYear=Year(Now());
  	if(ArrayLen(Arguments)) TheYear = Arguments[1];
	//US Congress changed it for 2007,may switch back
	// From last Sunday in October to First Sunday in November 
	if(TheYear lt 2007) return CreateDate(TheYear,10,GetLastOccOfDayInMonth(1,10,TheYear));
	else return CreateDate(TheYear,11,GetNthOccOfDayInMonth(1,1,11,TheYear));
	return CreateDate;
}

/**
 * Returns the date for The start of Daylight Saving Time for a given year.
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to return the start of Daylight Saving Time. (Optional)
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 2, December 20, 2006 
 */
function getDaylightSavingTimeStart() {
	var TheYear=Year(Now());
  	if(ArrayLen(arguments)) TheYear = arguments[1];
	//US Congress changed it for 2007,may switch back
	// From first Sunday in April to Second Sunday in March 
	if(TheYear lt 2007) return CreateDate(TheYear,4,GetNthOccOfDayInMonth(1,1,4,TheYear));
	else return CreateDate(TheYear,3,GetNthOccOfDayInMonth(2,1,3,TheYear));
}

/**
 * Returns the date for Easter in a given year.
 * Minor edits by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param TheYear 	 The year to get Easter for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, September 4, 2001 
 */
function GetEaster() {
  Var TheYear=iif(arraylen(arguments) gt 0,"arguments[1]", "Year(Now())");       
  Var century = Int(TheYear/100);
  Var G = TheYear MOD 19;
  Var K = Int((century - 17)/25);
  Var I = (century - Int(century/4) - Int((century - K)/3) + 19*G + 15) MOD 30;
  Var H = I - Int((I/28))*(1 - Int((I/28))*Int((29/(I + 1)))*Int(((21 - G)/11)));
  Var J = (TheYear + Int(TheYear/4) + H + 2 - century + Int(century/4)) MOD 7;
  Var L = H - J;
  Var EasterMonth = 3 + Int((L + 40)/44);
  Var EasterDay = L + 28 - 31*Int((EasterMonth/4));
  return CreateDate(TheYear,EasterMonth,EasterDay);
}

/**
 * Returns a date for Election Day in a given year
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library. Minor modifications by Rob Brooks-Bilson
 * 
 * @param TheYear 	 The year you want to return Election Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, August 28, 2001 
 */
//Election Day: Tuesday after First Monday in November, in even numbered years.
// for odd numbered years, -1 is returned
function GetElectionDay() {
 Var TheYear=Year(Now());
 if(ArrayLen(Arguments)) 
   TheYear = Arguments[1];
 if(TheYear MOD 2 eq 0){ 
   return DateAdd("d",1,CreateDate(TheYear,11,GetNthOccOfDayInMonth(1,2,11,TheYear))); //add 1 day to first monday
	} 
  else {
    return -1;
  }
}

/**
 * A function which returns a End Of Day TimeStamp. For example, 1/1/2000 returns {ts '2000-01-01 23:59:59'}.
 * 
 * @param date 	 Date to use. (Required)
 * @return Returns a timestamp. 
 * @author Sami Hoda (&#115;&#97;&#109;&#105;&#104;&#111;&#100;&#97;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, January 30, 2006 
 */
function getEndOfDayTS(date) {
	var vDate = date;
	vDate = dateFormat(vDate, 'MM/DD/YYYY');
	vDate = DateAdd("h",23,vDate);
	vDate = DateAdd("n",59,vDate);
	vDate = DateAdd("s",59,vDate);
	
	return vDate;
}

/**
 * Returns the number of seconds since January 1, 1970, 00:00:00
 * 
 * @param DateTime 	 Date/time object you want converted to Epoch time. 
 * @return Returns a numeric value. 
 * @author Chris Mellon (&#109;&#101;&#108;&#108;&#97;&#110;&#64;&#109;&#110;&#114;&#46;&#111;&#114;&#103;) 
 * @version 1, February 21, 2002 
 */
function GetEpochTime() {
	var datetime = 0;
	if (ArrayLen(Arguments) is 0) {
		datetime = Now();

	}
	else {
		if (IsDate(Arguments[1])) {
			datetime = Arguments[1];
		} else {
			return NULL;
		}
	}
	return DateDiff("s", "January 1 1970 00:00", datetime);
		
		
}

/**
 * Returns the number of seconds since January 1, 1970, 00:00:00 (Epoch time).
 * 
 * @param DateTime 	 Date/time object you want converted to Epoch time. (Required)
 * @return Returns a numeric value. 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, June 21, 2002 
 */
function GetEpochTimeFromLocal() {
  var datetime = 0;
  if (ArrayLen(Arguments) eq 0) {
    datetime = Now();
  }
  else {
    datetime = arguments[1];
  }
  return DateDiff("s", DateConvert("utc2Local", "January 1 1970 00:00"), datetime);
}

/**
 * Returns every occasion of a day of the week. A list of days of the week can be used.
 * 
 * @param dowList 	 A list of days of the week in numeric form. (Required)
 * @param year 	 The year. Defaults to this year. (Optional)
 * @return Returns an array. 
 * @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, September 29, 2006 
 */
function getEveryDOW(dowlist) {
	var year = year(now());
	var day1 = "";
	var x = "";
	var thisDOW = "";
	var result = arrayNew(1);
	var initialDOW = "";
	var offset = "";
	
	if(arrayLen(arguments) gte 2) year = arguments[2];
	day1 = createDate(year, 1,1);
	initialDOW = dayOfWeek(day1);
	
	while(year(day1) is year) {
		for(x=1; x lte listlen(dowlist); x=x+1) {
			thisDOW = listGetAt(dowlist, x);
			offset = thisDOW - initialDOW;
			dayToAdd = dateAdd("d", offset, day1 );
			arrayAppend(result, dayToAdd);
		}		
		day1 = dateAdd("ww", 1, day1);
	}
	return result;
}

/**
 * determine every nth day of week for a given year.
 * 
 * @param dow 	 The numeric day of the week. (Required)
 * @param nth 	 Week number in the month. (Required)
 * @param yy 	 Year to iterate over. (Required)
 * @return Returns an array. 
 * @author charlie griefer (&#99;&#104;&#97;&#114;&#108;&#105;&#101;&#64;&#103;&#114;&#105;&#101;&#102;&#101;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, March 30, 2006 
 */
function getEveryNthDay(dow,nth,yy) {
	var containerArray = arrayNew(1);
	
	var mm 			= "";
	var dd 			= "";
	var startDate	= "";
	var dateFound	= 0;
	
	if (val(dow) LT 1 OR val(dow) GT 7) return false;
	
	for (mm=1; mm LTE 12; mm=mm+1) {
		dateFound = 0;
		for (dd=1; dd LTE daysInMonth(createDate(yy, mm, 1)); dd=dd+1) {
			startDate = createDate(yy, mm, dd);
			if (dayOfWeek(startDate) EQ dow) {
				dateFound = dateFound + 1;
				if (dateFound EQ nth) arrayAppend(containerArray, startDate);
			}
		}
	}
	
	return containerArray;
}

/**
 * Return a date for Father's Day in a given year.  If no year is specified, defaults to the current year.
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library. Minor modifications by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;)
 * 
 * @param TheYear 	 The year you want to return Father's Day for. 
 * @return Returns a date object 
 * @author Ken McCafferty (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 22, 2001 
 */
//Father's:third sunday in june
function GetFathersDay() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,6,GetNthOccOfDayInMonth(3,1,6,TheYear));
}

/**
 * Returns the Federal Fiscal Year for a given date.
 * 
 * @param date 	 Date to return the Federal Fiscal Year for.  Defaults to the current date. (Optional)
 * @return Returns a numeric value. 
 * @author Deanna Schneider (&#100;&#101;&#97;&#110;&#110;&#97;&#46;&#115;&#99;&#104;&#110;&#101;&#105;&#100;&#101;&#114;&#64;&#99;&#101;&#115;&#46;&#117;&#119;&#101;&#120;&#46;&#101;&#100;&#117;) 
 * @version 1, July 2, 2002 
 */
function GetFederalFiscalYear() {
       var datetime = now();
       var month = month(datetime);
       if (ArrayLen(Arguments) gte 1) {
             if (IsDate(Arguments[1])) {
                   datetime = Arguments[1];
                   month = month(datetime);
             } else datetime = Now();
       }
       if (listfind("1,2,3,4,5,6", month)) 
         return Year(datetime);
       else 
         return  Year(DateAdd('yyyy', 1, datetime));
 }

/**
 * Gets the first date in a given quarter.
 * 
 * @param quarter 	 A number from 1 to 4. (Required)
 * @return Returns a date. 
 * @author Brian Sweeney (&#98;&#114;&#105;&#97;&#110;&#118;&#115;&#119;&#101;&#101;&#110;&#101;&#121;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, February 14, 2004 
 */
function GetFirstDateinQuarter(quarter){
	switch(quarter){
		case 1:
			return CreateDate(year(now()), 1, 1);
			break;
		case 2:
			return CreateDate(year(now()), 4, 1);
			break;
		case 3:
			return CreateDate(year(now()), 7, 1);
			break;
		case 4:
			return CreateDate(year(now()), 10, 1);
			break;
	}
}

/**
 * Returns a date object with the first date of the current quarter.
 * 
 * @return Returns a date. 
 * @author Scott Glassbrook (&#99;&#102;&#108;&#105;&#98;&#64;&#118;&#111;&#120;&#46;&#112;&#104;&#121;&#100;&#105;&#117;&#120;&#46;&#99;&#111;&#109;) 
 * @version 1, August 11, 2005 
 */
function getFirstDateThisQuarter() {
	if(now() gte createDateTime(DatePart("yyyy", now()), 01, 01, 00, 00, 00) and now() lte createDateTime(DatePart("yyyy", now()), 03, 31, 23, 59, 59)) return createDate(datePart("yyyy", now()), 01, 01);
	else if (now() gte createDateTime(DatePart("yyyy", now()), 04, 01, 00, 00, 00) and now() lte createDateTime(DatePart("yyyy", now()), 06, 30, 23, 59, 59)) return createDate(datePart("yyyy", now()), 04, 01);
	else if (now() gte createDateTime(DatePart("yyyy", now()), 07, 01, 00, 00, 00) and now() lte createDateTime(DatePart("yyyy", now()), 09, 30, 23, 59, 59)) return createDate(datePart("yyyy", now()), 07, 01);
	else return createDate(datePart("yyyy", now()), 10, 01);
}

/**
 * Returns the date for Good Friday in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to return Good Friday for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, September 4, 2001 
 */
// Good Friday: Friday before Easter
function GetGoodFriday() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return DateAdd("D",-2,GetEaster(TheYear));
}

/**
 * Returns a date for Halloween  of a given year.
 * 
 * @param TheYear 	 The year you want to return Halloween for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 28, 2001 
 */
// Halloween: October 31
function GetHalloween() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,10,31);
}

/**
 * Returns the date for Inauguration Day
 * Minor modifications by Rob Brooks-Bilson
 * 
 * @param TheYear 	 The year you want to return Inauguration Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, August 28, 2001 
 */
//Inauguration Day: Jan 20, every 4 years ,2001,2005 etc. If Jan 20 is Sunday, InaugurationDay is Jan 21
// for other  years, -1 is returned
function GetInaugurationDay() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  if(TheYear MOD 4 eq 1){ 
    if(DayOfWeek(CreateDate(TheYear,1,20)) eq 1){  //Sunday
      return CreateDate(TheYear,1,21);
    }
    else{
      return CreateDate(TheYear,1,20);
    }
  } 
  else{
    return -1;
  }
}

/**
 * Returns the date for U.S. Independence Day  in a given year.
 * 
 * @param TheYear 	 Year you want to return U.S. Independence Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 10, 2001 
 */
// Independence Day: July 4
function GetIndependenceDay() {
	Var TheYear=Year(Now());
  	if(ArrayLen(Arguments)) 
  	  TheYear = Arguments[1];
	return CreateDate(TheYear,7,4);
}

/**
 * Calculates the Julian Day for any date in the Gregorian calendar.
 * 
 * @param TheDate 	 Date you want to return the Julian day for. 
 * @return Returns a numeric value. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1, September 4, 2001 
 */
function GetJulianDay(){
        var date = Now();	
	var year = 0;
	var month = 0;
	var day = 0;
	var hour = 0;
	var minute = 0;
	var second = 0;
	var a = 0;
	var y = 0;
	var m = 0;
	var JulianDay =0;
        if(ArrayLen(Arguments)) 
          date = Arguments[1];	
	// The Julian Day begins at noon so in order to calculate the date properly, one must subtract 12 hours
	date = DateAdd("h", -12, date);
	year = DatePart("yyyy", date);
	month = DatePart("m", date);
	day = DatePart("d", date);
	hour = DatePart("h", date);
	minute = DatePart("n", date);
	second = DatePart("s", date);
	
	a = (14-month) \ 12;
	y = (year+4800) - a;
	m = (month + (12*a)) - 3;
	
	JD = (day + ((153*m+2) \ 5) + (y*365) + (y \ 4) - (y \ 100) + (y \ 400)) - 32045;
	JDTime = NumberFormat(CreateTime(hour, minute, second), ".99999999");
	
	JulianDay = JD + JDTime;
	
	return JulianDay;
}

/**
 * Returns a date for Labor Day in a given year.  If no year is specified, defaults to the current year.
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library. Minor modifications by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;)
 * 
 * @param TheYear 	 The year you want to return Labor Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 22, 2001 
 */
//Labor Day:first monday in september
function GetLaborDay() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,9,GetNthOccOfDayInMonth(1,2,9,TheYear));
}

/**
 * Gets the last date in a given quarter.
 * 
 * @param quarter 	 A number from 1 to 4. (Required)
 * @return Returna a date. 
 * @author Brian Sweeney (&#98;&#114;&#105;&#97;&#110;&#118;&#115;&#119;&#101;&#101;&#110;&#101;&#121;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, February 14, 2004 
 */
function GetLastDateinQuarter(quarter){
	switch(quarter){
		case 1:
			return CreateDate(year(now()), 3, DaysInMonth(CreateDate(year(now()),3,1)));
			break;
		case 2:
			return CreateDate(year(now()), 6, DaysInMonth(CreateDate(year(now()),6,1)));
			break;
		case 3:
			return CreateDate(year(now()), 9, DaysInMonth(CreateDate(year(now()),9,1)));
			break;
		case 4:
			return CreateDate(year(now()), 12, DaysInMonth(CreateDate(year(now()),12,1)));
			break;
	}
}

/**
 * Returns the day of the month(1-31) of Last Occurrence of a day (1-sunday,2-monday etc.)
in a given month.
 * 
 * @param TheDayOfWeek 	 Ordinal value representing the desired day of the week (1-sunday,2-monday etc.) 
 * @param TheMonth 	 Ordinal value representing the month (1-January, 2-February, etc.) 
 * @param TheYear 	 The year. 
 * @return Returns a numeric value. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 22, 2001 
 */
function GetLastOccOfDayInMonth(TheDayOfWeek,TheMonth,TheYear) 
{
  //Find The Number of Days in Month
  Var TheDaysInMonth=DaysInMonth(CreateDate(TheYear,TheMonth,1));
  //find the day of week of Last Day
  Var DayOfWeekOfLastDay=DayOfWeek(CreateDate(TheYear,TheMonth,TheDaysInMonth));
  //subtract DayOfWeek
  Var DaysDifference=DayOfWeekOfLastDay - TheDayOfWeek;
  //Add a week if it is negative
  if(DaysDifference lt 0){
    DaysDifference=DaysDifference + 7;
  }
  return TheDaysInMonth-DaysDifference;
}

/**
 * Returns the date for Mardi Gras  of a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to return Mardi Gras for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, September 4, 2001 
 */
// Mardi Gras: Seventh Tuesday before Easter
function GetMardiGras() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return DateAdd("D",-47,GetEaster(TheYear));
}

/**
 * Returns a date for Memorial Day in a given year.
 * This function requires the GetLastOccOfDayInMonth() function available from the DateLib library. Minor modifications by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;)
 * 
 * @param TheYear 	 The year you want to return Columbus Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, August 28, 2001 
 */
//Memorial Day:last monday in may
function GetMemorialDay()
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,5,GetLastOccOfDayInMonth(2,5,TheYear));
}

/**
 * Returns a date that Martin Luther King Day occurs on in a given year.
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library. Minor modifications by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;)
 * 
 * @param TheYear 	 The year you want to return Martin Luther King Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 28, 2001 
 */
function GetMLKDay() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,1,GetNthOccOfDayInMonth(3,2,1,TheYear));
}

/**
 * Calculates the modified Julian Day for any date in the Gregorian calendar.
 * This function requires the GetJulianDay() function available from the DateLib library.  Minor edits by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param TheDate 	 Date you want to return the modified Julian day for. 
 * @return Returns a numeric value. 
 * @author Beau A.C. Harbin (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 4, 2001 
 */
function GetModifiedJulianDay()
{
  var date = Now();
  var ModifiedJulianDay = 0;
  if(ArrayLen(Arguments)) 
    date = Arguments[1];	
  ModDate = GetJulianDay(date);
  ModifiedJulianDay = ModDate - 2400000.5;
  return ModifiedJulianDay;
}

/**
 * Returns a date for Mother's day in a given year.  If no year is specified, defaults to the current year.
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library. Minor modifications by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;)
 * 
 * @param TheYear 	 The year you want to return Mother's Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 22, 2001 
 */
//Mother's:second sunday in may
function GetMothersDay()
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,5,GetNthOccOfDayInMonth(2,1,5,TheYear));
}

/**
 * Returns the nearest half hour based on minutes of the hour supplied to the function.
 * 
 * @param minutes 	 Number of minutes past the hou for which you want to calculate the nearest half hour. (Required)
 * @return Returns a numeric value. 
 * @author Jason Smith (&#106;&#97;&#115;&#111;&#110;&#64;&#105;&#110;&#119;&#101;&#98;&#115;&#121;&#115;&#46;&#110;&#101;&#116;) 
 * @version 1, March 10, 2003 
 */
function GetHalfHour(minutes) {
  var min_diff = abs(30 - minutes);
  var half_hour = 0;
  if (minutes lte 30) {
    if (min_diff gte 15) { half_hour = "00"; }
	else { half_hour = "30"; }
  } 
  else if (minutes gt 30) {
    if (min_diff gte 15) { half_hour = "00"; }
	else { half_hour = "30"; }
  }
  return half_hour;
}

/**
 * Returns a date for New Years Day of a given year.
 * 
 * @param TheYear 	 Year you want to return New Year's Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 4, 2001 
 */
function GetNewYearsDay() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,1,1);
}

/**
 * Returns a date for New Year's Eve for a given year.
 * 
 * @param TheYear 	 Year you want to return New Years Eve for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 28, 2001 
 */
function GetNewYearsEve() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,12,31);
}

/**
 * Returns the day of the month(1-31) of an Nth Occurrence of a day (1-sunday,2-monday etc.)in a given month.
 * 
 * @param NthOccurrence 	 A number representing the nth occurrence.1-5. 
 * @param TheDayOfWeek 	 A number representing the day of the week (1=Sunday, 2=Monday, etc.). 
 * @param TheMonth 	 A number representing the Month (1=January, 2=February, etc.). 
 * @param TheYear 	 The year. 
 * @return Returns a numeric value. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, August 28, 2001 
 */
function GetNthOccOfDayInMonth(NthOccurrence,TheDayOfWeek,TheMonth,TheYear)
{
  Var TheDayInMonth=0;
  if(TheDayOfWeek lt DayOfWeek(CreateDate(TheYear,TheMonth,1))){
    TheDayInMonth= 1 + NthOccurrence*7  + (TheDayOfWeek - DayOfWeek(CreateDate(TheYear,TheMonth,1))) MOD 7;
  }
  else{
    TheDayInMonth= 1 + (NthOccurrence-1)*7  + (TheDayOfWeek - DayOfWeek(CreateDate(TheYear,TheMonth,1))) MOD 7;
  }
  //If the result is greater than days in month or less than 1, return -1
  if(TheDayInMonth gt DaysInMonth(CreateDate(TheYear,TheMonth,1)) OR   TheDayInMonth lt 1){
    return -1;
  }
  else{
    return TheDayInMonth;
  }
}

/**
 * Returns the date for Palm Sunday in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to get Palm Sunday for. 
 * @return Returns a date object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 5, 2001 
 */
function GetPalmSunday() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  Return DateAdd("d", -7, GetEaster(TheYear));
}

/**
 * Returns the date for Pentecost in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to get Pentecost for. 
 * @return Returns a date object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 5, 2001 
 */
function GetPentecost() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  Return DateAdd("d", 49, GetEaster(TheYear));
}

/**
 * Returns the date for President's Day in a given year.
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to return President's Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 5, 2001 
 */
//Presidents Day:third monday in february
function GetPresidentsDay() {
	Var TheYear=Year(Now());
  	if(ArrayLen(Arguments)) 
  	  TheYear = Arguments[1];
	return CreateDate(TheYear,2,GetNthOccOfDayInMonth(3,2,2,TheYear));
}

/**
 * Returns first and last day of quarter from first year to current quarter from array of years.
 * 
 * @param aYears 	 Array of years. (Required)
 * @return Returns an array of structs. 
 * @author Steve DeWitt (&#115;&#116;&#101;&#118;&#101;&#46;&#100;&#101;&#119;&#105;&#116;&#116;&#64;&#109;&#105;&#108;&#108;&#105;&#109;&#97;&#110;&#46;&#99;&#111;&#109;) 
 * @version 1, April 12, 2004 
 */
function getQuarters(aYears){
	var aQuarters = ArrayNew(1);
	var yLen	  = ArrayLen(aYears);
	var q1Start = '01-01-';
	var q1End	= '03-31-';
	var q2Start	= '04-01-';
	var q2End	= '06-30-';
	var q3Start	= '07-01-';
	var q3End	= '09-30-';
	var q4Start	= '10-01-';
	var q4End	= '12-31-';
	var y = 1;
	var q = 1;
	
	for(;y lte yLen;y=y+1) {
		aQuarters[y] = StructNew();
		for(q=1;q lte 4;q=q+1) {
			if(q is 1) {
				if(q1Start & aYears[y] lte DateFormat(Now(),'mm-dd-yyyy')){
					aQuarters[y].q1 = q1Start & aYears[y] & "~" & q1End & aYears[y];
				}
			} else if(q is 2) {
				if(q2Start & aYears[y] lte DateFormat(Now(),'mm-dd-yyyy')){
					aQuarters[y].q2 = q2Start & aYears[y] & "~" & q2End & aYears[y];
				}
			} else if(q is 3) {
				if(q3Start & aYears[y] lte DateFormat(Now(),'mm-dd-yyyy')){
					aQuarters[y].q3 = q3Start & aYears[y] & "~" & q3End & aYears[y];
				}
			} else if(q is 4) {
				if(q4Start & aYears[y] lte DateFormat(Now(),'mm-dd-yyyy')){
					aQuarters[y].q4 = q4Start & aYears[y] & "~" & q4End & aYears[y];
				}
			}
		}
	}
	return aQuarters;
}

/**
 * Returns the date for Quinquagesima in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 The year to get Quinquagesima for. 
 * @return Returns a date object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 5, 2001 
 */
function GetQuinquagesima() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  Return DateAdd("d", -49, GetEaster(TheYear));
}

/**
 * Returns the date for Rogation Sunday in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to get Rogation Sunday for. 
 * @return Returns a date object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 5, 2001 
 */
function GetRogationSunday() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  Return DateAdd("d", 35, GetEaster(TheYear));
}

/**
 * Returns season for given date.
 * 
 * @param myDate 	 The date. Defaults to now. (Optional)
 * @return Returns a string. 
 * @author William Steiner (&#119;&#105;&#108;&#108;&#105;&#97;&#109;&#115;&#64;&#104;&#107;&#117;&#115;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, May 13, 2003 
 */
function GetSeason() {
	var myDate = iif(arraylen(arguments) gt 0,"arguments[1]", "now()");
	var myYear = Year(myDate);
	//Winter
	var winterStart = '12-21-' & decrementValue(myYear);
	var winterEnd = '03-20-' & myYear;
	//Spring
	var springStart = '3-21-' & myYear;
	var springEnd = '06-20-' & myYear;
	//Summenr 
	var summerStart = '06-21-' & myYear;
	var summerEnd ='09-20-' & myYear;
	//Fall
	var fallStart = '09-21-' & myYear;
	var fallEnd = '12-20-' & myYear;
	
	// return the correct season
	if (myDate GTE winterStart AND myDate LTE winterEnd) {
		return "Winter";
	} else if (myDate GTE springStart AND myDate LTE springEnd) {
		return "Spring";
	} else if (myDate GTE summerStart AND myDate LTE summerEnd) {
		return "Summer";
	} else if (myDate GTE fallStart AND myDate LTE fallEnd) {
		return "Fall";
	} else {
		return "";
	}
}

/**
 * Returns the total number of seconds from midnight for a valid date/time object.
 * Note that this function returns different results depending on whether the date/time object you pass it has seconds defined.
 * 
 * @param timeObject 	 Valid date/time object. 
 * @return Returns a numeric value. 
 * @author Alan McCollough (&#107;&#105;&#116;&#116;&#121;&#99;&#97;&#116;&#64;&#107;&#105;&#116;&#116;&#121;&#99;&#97;&#116;&#111;&#110;&#108;&#105;&#110;&#101;&#46;&#99;&#111;&#109;) 
 * @version 1, February 21, 2002 
 */
function GetSecondsFromTime(timeObject){
  var theSeconds = Val(Hour(timeObject) * 720) + Val(Minute(timeObject) * 60) + Second(timeObject);
  return theSeconds;
}

/**
 * Returns the date for Septuagesima in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 The year to get Septuagesima for. 
 * @return Returns a date object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 5, 2001 
 */
function GetSeptuagesima() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  Return DateAdd("d", -63, GetEaster(TheYear));
}

/**
 * Returns the work shift for a sequence based work schedule.
 * v2 by Raymond Camden
 * 
 * @param Date 	 Date to return the shift for. (Required)
 * @param StartDate 	 Start date of the sequence. (Required)
 * @param Sequence 	 Comma delimited list defining the shift sequence. (Required)
 * @return Returns a string. 
 * @author Rob Rusher (&#114;&#111;&#98;&#64;&#114;&#111;&#98;&#114;&#117;&#115;&#104;&#101;&#114;&#46;&#99;&#111;&#109;) 
 * @version 2, December 17, 2002 
 */
function GetShift(date, startDate, sequence) {
  var daysDiff = DateDiff("d",startDate,date);
  var key = daysDiff mod listLen(sequence) + 1;
  return listGetAt(sequence,key);
}

/**
 * Adds a timespan to a date.

GetSpanDate(dateObj, days, hours, minutes, seconds)

Pass in a date object, with the span difference of days, hours, minutes, and seconds and returns a timestamp of the end of the span.
 * 
 * @param dateObj  	 ColdFusion date object to use as the starting date. 
 * @param days 	 Number of days in the timespan 
 * @param hours 	 Number of hours in the timespan 
 * @param minutes 	 Number of minutes in the timespan. 
 * @param seconds 	 Number of seconds in the timespan. 
 * @return Returns a date/time object. 
 * @author Chris Wigginton (&#99;&#119;&#105;&#103;&#103;&#105;&#110;&#116;&#111;&#110;&#64;&#109;&#97;&#99;&#114;&#111;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, December 12, 2001 
 */
function GetSpanDate(dateObj, days, hours, minutes, seconds){
  var timeDiff = CreateTimeSpan(days, hours, minutes, seconds);
  var spanDate = dateObj+timeDiff;
  return "{ts '" & DateFormat(spanDate, "yyyy-mm-dd ") & TimeFormat(spanDate, "HH:mm:ss") & "'}";
}

/**
 * Returns the date for Thanksgiving day in a given year.
 * This function requires the GetNthOccOfDayInMonth() function available from the DateLib library.
 * 
 * @param TheDate 	 The year you want to return Thanksgiving day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#102;&#121;&#105;&#46;&#110;&#101;&#116;) 
 * @version 1.0, September 5, 2001 
 */
// Thanksgiving Day 4th thursday in november
function GetThanksgivingDay() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];

  return CreateDate(TheYear,11,GetNthOccOfDayInMonth(4,5,11,TheYear));
}

/**
 * Calculates time from minutes after midnight.
 * 
 * @param Minutes 	 Number of minutes elapsed since midnight. 
 * @return Returns a date/time object. 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, February 21, 2002 
 */
function GetTimeFromMinutes(minutes)
{
  Var tHr = (((minutes\60)-1) Mod 24)+1;
  Var tMin = minutes-(tHr*60);
  return CreateTime(tHr,tMin, 0);
}

/**
 * Calculates time from seconds after midnight.
 * Minor modifications by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param seconds 	 Number of seconds from midnight used to calculate the time. 
 * @return Returns a date/time object. 
 * @author Seth Duffey (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#115;&#100;&#117;&#102;&#102;&#101;&#121;&#64;&#99;&#105;&#46;&#100;&#97;&#118;&#105;&#115;&#46;&#99;&#97;&#46;&#117;&#115;) 
 * @version 1, February 21, 2002 
 */
function GetTimeFromSeconds(seconds)
{
  Var TimeHr = (((seconds\3600)-1) Mod 24)+1; /* find hour */
  Var TimeMin = seconds\60-(seconds\3600)*60; /* Find minutes */
  Var TimeSec = seconds-(TimeHr * 3600) - (TimeMin*60); /* find seconds */
  return CreateTime(TimeHr,TimeMin,TimeSec);    /* Create time (no date) */
}

/**
 * Converts HttpTimeString into a timestamp string.
 * 
 * @param httpTime 	 HttpTimeString 
 * @return Returns a timestamp string. 
 * @author Chris  Wigginton (&#99;&#119;&#105;&#103;&#103;&#105;&#110;&#116;&#111;&#110;&#64;&#109;&#97;&#99;&#114;&#111;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, November 26, 2001 
 */
function GetTimeStampFromHttpTimeString(httpTime) {
	var dateParts = ListToArray(httpTime, " ");
	var timeStamp = "{ts '" & dateParts[4] & "-" & DateFormat("#DateParts[3]#/1/2000", "mm") & "-" & dateParts[2] & " " & dateParts[5] & "'}";
	return timeStamp;
}

/**
 * Returns the Time Zone Code (string) that corresponds to the dateTime passed in.
 * 
 * @param dateTimeIn 	 The date to parse. (Required)
 * @return Returns a string. 
 * @author Tony Felice (&#115;&#116;&#97;&#102;&#102;&#64;&#110;&#111;&#107;&#97;&#109;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, January 6, 2004 
 */
function getTimeZone(dateTimeIn) {
	var timeZoneInfo = GetTimeZoneInfo();
	var dateGMT = mid(replace(getHttpTimeString(),"GMT","","ALL"),6,len(replace(getHttpTimeString(),"GMT","","ALL")));
	var dateFactor = dateCompare(dateTimeIn, dateGMT);
	var dateDelta = round(DateDiff("n", dateTimeIn, dateGMT)/60);
	var trueZoneOffset = (dateDelta * dateFactor);
	var offsetList="";
	var zoneCodeList="";
	var listPos="";
	var timeZoneCode="";
	
	
	//standard time zones
	var stdZoneCodeList = "HST,AKST,PST,MST,CST,EST,AST,NST,GMT,CET,EET,MSK,AWST,ACST,AEST";
	var stdOffsetList = "-10,-9,-8,-7,-6,-5,-4,-3.5,0,1,2,3,8,9.5,10";
	
	// daylight saving time zones
	var dstZoneCodeList = "AKDT,PDT,MDT,CDT,EDT,ADT,NDT,GMT,WEST,CEST,EEST,MSD,ACDT,AEDT";
	var dstOffsetList = "-8,-7,-6,-5,-4,-3,-2.5,0,1,2,3,4,10.5,11";
	
	if(timeZoneInfo.isDSTOn IS "YES"){
		offsetList = dstOffsetList;
		zoneCodeList = dstZoneCodeList;
	} else {
		offsetList = stdOffsetList;
		zoneCodeList = stdZoneCodeList;
	}
	
	listPos = ListFindNoCase(OffsetList,trueZoneOffset);
	
	if(listPos NEQ 0) timeZoneCode = ListGetAt(ZoneCodeList,listPos); 
	else timeZoneCode = "UNK";
	
	return timeZoneCode;
}

/**
 * Returns the date for Trinity Sunday in a given year.
 * This function requires the GetEaster() function available from the DateLib library.
 * 
 * @param TheYear 	 Year you want to get Trinity Sunday for. 
 * @return Returns a date object. 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 5, 2001 
 */
function GetTrinitySunday() {
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  Return DateAdd("d", 56, GetEaster(TheYear));
}

/**
 * Returns the date for Valentines Day in a given year.
 * 
 * @param TheYear 	 Year you want to return Valentine's day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 4, 2001 
 */
// Valentines Day: February 14
function GetValentinesDay() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,2,14);
}

/**
 * Returns a date for Veterans Day in a given year.
 * 
 * @param TheYear 	 Year you want to return Veterans Day for. 
 * @return Returns a date object. 
 * @author Ken McCafferty (&#109;&#99;&#99;&#106;&#100;&#107;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 28, 2001 
 */
// Veterans Day: November 11
function GetVeteransDay() 
{
  Var TheYear=Year(Now());
  if(ArrayLen(Arguments)) 
    TheYear = Arguments[1];
  return CreateDate(TheYear,11,11);
}

/**
 * Returns an array of dates with the week ending date of each week in the month.
 * 
 * @param theMonth 	 Month to use. (Required)
 * @param theYear 	 Year to use. (Required)
 * @return Returns an array. 
 * @author Brian Rinaldi (&#98;&#114;&#105;&#110;&#97;&#108;&#100;&#105;&#64;&#99;&#114;&#105;&#116;&#105;&#99;&#97;&#108;&#100;&#105;&#103;&#105;&#116;&#97;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, January 13, 2004 
 */
function getWeekEnding(theMonth,theYear) {
	/**
	 * week ending day is a friday for our purposes as the end of the business week
	 * this can be modified to return a week ending on whatever day you want
	*/
	var endOfWeek = 6;
	var theDay = 0;
	var i = 1;
	var arrDate = arrayNew(1);
	
	var theDate = "";
	
	// loop to find the first friday of the month
	do {
		theDay = theDay + 1;
	} while (dayOfWeek(createDate(theYear,theMonth,theDay)) NEQ endOfWeek);
	// establish the first friday of the month
	theDate = createDate(theYear,theMonth,theDay);
	// set the first week end date in the array
	arrDate[i] = theDate;
	/**
	 * loop through the rest of the month adding seven to the date until the date
	 * exceeds the end of the month
	*/
	i=i+1;
	while (month(dateAdd('d',7,theDate)) EQ theMonth) {
		theDate = dateAdd('d',7,theDate);
		arrDate[i] = theDate;
		i = i + 1;
	}
	return arrDate;
}

/**
 * Given a date, returns the appropriate zodiac sign.
 * 
 * @param date 	 Date value. (Required)
 * @return Returns a string. 
 * @author Charlie Griefer (&#99;&#104;&#97;&#114;&#108;&#105;&#101;&#64;&#103;&#114;&#105;&#101;&#102;&#101;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, February 14, 2004 
 */
function getZodiacSign(date) {
	var bday_m = month(date);
	var bday_d = day(date);
	
	switch(bday_m) {
		case 1: 
			if (bday_d LTE 20) { sign = "Capricorn"; } else { sign = "Aquarius"; }
			break;
		case 2: 
			if (bday_d LTE 19) { sign = "Aquarius"; } else { sign = "Pisces"; }
			break;
		case 3: 
			if (bday_d LTE 20) { sign = "Pisces"; } else { sign = "Aries"; }
			break;
		case 4:
			if (bday_d LTE 20) { sign = "Aries"; } else { sign = "Taurus"; }
			break;
		case 5: 
			if (bday_d LTE 21) { sign = "Taurus"; } else { sign = "Gemini";	}
			break;
		case 6: 
			if (bday_d LTE 22) { sign = "Gemini"; } else { sign = "Cancer";	}
			break;
		case 7: 
			if (bday_d LTE 23) { sign = "Cancer"; } else { sign = "Leo"; }
			break;
		case 8: 
			if (bday_d LTE 23) { sign = "Leo"; } else { sign = "Virgo"; }
			break;
		case 9: 
			if (bday_d LTE 23) { sign = "Virgo"; } else { sign = "Libra"; }
			break;
		case 10: 
			if (bday_d LTE 23) { sign = "Libra"; } else { sign = "Scorpio"; }
			break;
		case 11: 
			if (bday_d LTE 22) { sign = "Scorpio"; } else { sign = "Sagittarius"; }
			break;
		case 12: 
			if (bday_d LTE 21) { sign = "Sagittarius"; } else { sign = "Capricorn"; }
			break;
	}
	
	return sign;
}

/**
 * This function takes a date time object and an offset, and outputs a GMT date/time formatted string.
 * 
 * @param aDate 	 A date. 
 * @param offset 	 A valid GMT offset. 
 * @return Returns a string. 
 * @author Mark Andrachek (&#104;&#97;&#108;&#108;&#111;&#119;&#64;&#119;&#101;&#98;&#109;&#97;&#103;&#101;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, March 21, 2002 
 */
function GMTDateFormat (adate,offset) {
     // adate must be a valid date time object.
     // the offset must be in the format -0000 or +0000.
     
     var dvalue = ""; // the final value.
     
     if (IsDate(adate)) {
          
          dvalue = DateAdd('h',Left(offset,3),DateAdd('s',Left(offset,1) & Right(offset,2),adate));
          dvalue = Left( DayOfWeekAsString( DayOfWeek( dvalue ) ), 3) & 
                  ', ' & 
                  DateFormat(dvalue,'dd mmm yyyy') &
                  ' ' &
                  TimeFormat(dvalue,'HH:mm:ss') &
                  ' GMT';
          
          return dvalue;
     }
     
     else { return; }
}

/**
 * Rounds a decimal number (hours) to the nearest quater hour.
 * 
 * @param theNumber 	 The number to modify. (Required)
 * @return Returns a number. 
 * @author Tim (&#116;&#105;&#109;&#46;&#103;&#97;&#114;&#118;&#101;&#114;&#64;&#110;&#105;&#99;&#101;&#46;&#99;&#111;&#109;) 
 * @version 1, May 23, 2005 
 */
function hourRound(theNumber) {
   var hour = 0;
   var mins = 0;
   if(theNumber contains "."){
   		// strip out hour and decimals
	   hour = ListFirst(theNumber,'.');
	   mins = listgetat(theNumber,2,'.');
	   //if the minute part is only 1 digit, add a zero to the end of it
	   if(Len(mins) EQ 1){
	   mins = mins * 10;
	   }  
	   // next determine were in the scheme the mins fall.
	   // between 0 - 25 then how close to each end are they
	   // between 25 - 50 and figure how close they are
	   // and 50 - 75 again closness
	   // u guessed it 75 - 99 cause there will be no x.100 passed
	   // the distance between the half way mark in each group if its under the half,
	   // round down, if above it, then round up.
	   // if number is above last half way mark, add a whole 1 to the hour.
	   // 0 - 25
	   if((mins gt 0) and (mins lte 25)){
	   		// 0 - 12.5
	   		if((mins gt 0) and (mins lt 13)) return hour;
			else return hour + .25;
	   }
	   	// 25 - 50
	   else if((mins gt 25) and (mins lte 50)){
	   		// 25 - 37.5
	  		if((mins gt 25) and (mins lt 38)) return hour + .25;
			else return hour + .50;
	   }
	   	// 50 - 75
	   else if((mins gt 50) and (mins lte 75)){
	   		// 50 - 62.5
	  		if((mins gt 50) and (mins lt 63)) return hour + .50;
			else return hour + .75;
	   }
	   	// 75 - 99
	    else if((mins gt 75) and (mins lte 99)){
			// 75 - 86.5
	  		if((mins gt 75) and (mins lt 87)) return hour + .75;
			else return hour + 1;
	   }
	   else return hour;	   
   }
   else return theNumber;
}

/**
 * Formats a number of minutes into &quot;XX hours XX minutes&quot;.
 * 
 * @param minutes 	 Number of minutes to convert to hours/minutes. 
 * @return Returns a string. 
 * @author Andrew Muller (&#114;&#101;&#98;&#101;&#108;&#64;&#100;&#97;&#101;&#109;&#111;&#110;&#46;&#99;&#111;&#109;&#46;&#97;&#117;) 
 * @version 1, March 18, 2002 
 */
function HoursMinutes(minutes)
{
	var tempstr = "";
	var strHours = minutes / 60;
	var strMinutes = minutes MOD 60;
	var hourText = "";
	if (strHours gte 1) {
		if (strHours gt 2) {
			hourText = " hours ";
		} else {
			hourText = " hour ";
		}
		tempstr = Fix(strHours) & hourText;
	}
	
	if (strMinutes gt 0) {
		tempstr = tempstr & strMinutes & " minutes";
	}
	return tempstr;
}

/**
 * Converts hour of the year to hour of the day.
 * 
 * @param hoy 	 Hour of the year. (Required)
 * @return Returns a number. 
 * @author Billy Cravens (&#98;&#105;&#108;&#108;&#121;&#64;&#102;&#117;&#122;&#119;&#101;&#98;&#46;&#99;&#111;&#109;) 
 * @version 1, May 14, 2002 
 */
function hoyToHour(hoy) {
	return hoy - ((hoy \ 24)*24);
}

/**
 * Returns True if the date provided in the first argument lies between the two dates in the second and third arguments.
 * 
 * @param dateObj  	 CF Date Object you want to test. 
 * @param dateObj1 	 CF Date Object for the starting date. 
 * @param dateObj2 	 CF Date Object for the ending date. 
 * @return Returns a Boolean. 
 * @author Bill King (&#98;&#107;&#105;&#110;&#103;&#64;&#104;&#111;&#115;&#116;&#119;&#111;&#114;&#107;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, November 29, 2001 
 */
function IsDateBetween(dateObj, dateCompared1, dateCompared2)
{
 return YesNoFormat((DateCompare(dateObj, dateCompared1) gt -1) AND (DateCompare(dateObj, dateCompared2) lt 1));
}

/**
 * Converts text string of ISO Date to datetime object; useful for parsing RSS and RDF.
 * 
 * @param str 	 ISO datetime string to parse. (Required)
 * @return Returns a date. 
 * @author James Edmunds (&#106;&#97;&#109;&#101;&#115;&#101;&#100;&#109;&#117;&#110;&#100;&#115;&#64;&#106;&#97;&#109;&#101;&#115;&#101;&#100;&#109;&#117;&#110;&#100;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, September 21, 2004 
 */
function ISODateToTS(str) {
	return ParseDateTime(ReplaceNoCase(left(str,16),"T"," ","ALL"));
}

/**
 * Returns the ordinal for the day of the week for the specified date/time object according to ISO standards.
 * 
 * @param date 	 Date time object 
 * @return Returns an integer between 1 and 7. 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, August 17, 2001 
 */
function ISODayOfWeek(date)
{
  if (DayOfWeek(date) EQ 1) 
    Return 7;
  else 
    Return DayOfWeek(date)-1;
}

/**
 * Determine whether a date of birth exceeds minimum age requirement.
 * 
 * @param dob 	 Date of birth. (Required)
 * @param minAge 	 Age in years. (Required)
 * @return Returns a boolean. 
 * @author Paul Malan (&#112;&#97;&#117;&#108;&#64;&#109;&#97;&#108;&#97;&#110;&#46;&#111;&#114;&#103;) 
 * @version 1, January 2, 2004 
 */
function isOldEnough(dob,minAge) {
	var goldenDate = dateAdd('yyyy', -minAge, now());
	if (datecompare(goldenDate,dob) gt 0) return true;
	else return false;
}

/**
 * Returns the weeknumber according to the ISO standard.
 * 
 * @param inputDate 	 Date object. (Required)
 * @return Returns a number. 
 * @author Ron Pasch (&#112;&#97;&#115;&#99;&#104;&#64;&#99;&#105;&#115;&#116;&#114;&#111;&#110;&#46;&#110;&#108;) 
 * @version 1, January 12, 2004 
 */
function ISOWeek(inputDate) {  
    var d = StructNew();
	var d2 = 0;
	var days = 0;
	d.yday = DayOfYear(inputDate);
	d.wday = DayOfWeek(inputDate)-1;
	d.year = Year(inputDate);
    days = d.yday - ((d.yday - d.wday + 382) MOD 7) + 3;
    if(days LT 0) {
        d.yday = d.yday + 365 + isLeapYear(d.year-1);
        days = d.yday - ((d.yday - d.wday + 382) MOD 7) + 3;
    } else {
        d.yday = (d.yday - 365) + isLeapYear(d.year);
        d2 = d.yday - ((d.yday - d.wday + 382) MOD 7) + 3;
        if (0 LTE d2) {
            days = d2;
        }
    }
	return int((days / 7) + 1);
}

/**
 * Returns the ISO correct year of a given date, necessary for dates from 29th Dec to 3rd Jan.
 * 
 * @param inputDate 	 The date to format. (Required)
 * @return Returns a string. 
 * @author Pete Gibb (&#112;&#101;&#116;&#101;&#114;&#46;&#103;&#105;&#98;&#98;&#64;&#105;&#99;&#97;&#101;&#119;&#46;&#99;&#111;&#46;&#117;&#107;) 
 * @version 1, August 4, 2005 
 */
function ISOYear(inputDate) {
	var inputDay = dayOfWeek(inputDate);
	var yearNo = year(inputDate);
	
	/** If the inputdate IS 29th-31st December, the input year MAY need to be next year **/
	if((dateFormat(inputDate,"ddmm") is "2912" and dayOfWeek(inputDate) eq 2)
	or (dateFormat(inputDate,"ddmm") IS "3012" and listFind("2,3",dayOfWeek(inputDate),",") gt 0)
	or (dateFormat(inputDate,"ddmm") IS "3112" and listFind("2,3,4",dayOfWeek(inputDate),",") gt 0))
	{yearNo=year(inputDate)+1;}
	
	/** If the inputdate IS 1st - 3rd January, the input year MAY need to be previous year **/
	if((dateFormat(inputDate,"ddmm") is "0301" and dayOfWeek(inputDate) eq 1)
	or (dateFormat(inputDate,"ddmm") IS "0201" AND listFind("1,7",dayOfWeek(inputDate),",") gt 0)
	or (dateFormat(inputDate,"ddmm") IS "0101" and listFind("1,7,6",dayOfWeek(inputDate),",") gt 0))
	{yearNo=year(inputDate)-1;}
	
	return yearNo;
}

/**
 * Compares a date/time string and validates it against the RFC 3339 - Date and Time on the Internet: Timestamps protocol.
 * 
 * @param input 	 String to check. (Required)
 * @return Returns a boolean. 
 * @author Ben Garrett (&#98;&#101;&#110;&#103;&#97;&#114;&#114;&#101;&#116;&#116;&#64;&#99;&#105;&#118;&#98;&#111;&#120;&#46;&#111;&#114;&#103;) 
 * @version 1, December 20, 2007 
 */
function isRFC3339(input) {
	return YesNoFormat(REFindNoCase('^(19|20)\d\d-(0[1-9]|1[0-2])-([0-2]\d|3[0-1])T([0-1]\d|2[0-4]):([0-5]\d):([0-5]\d)(.\d\d)?(Z|[\+|-]([0-1]\d|2[0-4]):([0-5]\d))$',input));
}

/**
 * Returns true if a date is during the week.
 * 
 * @param Date 	 Defaults to today. 
 * @return Returns a boolean. 
 * @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, August 17, 2001 
 */
function IsWeekDay() {
	var today = Now();
	if(ArrayLen(Arguments)) today = Arguments[1];
	return (DayOfWeek(today) GTE 2 AND DayOfWeek(today) LTE 6);
}

/**
 * Returns true if a date is on the weekend.
 * 
 * @param Date 	 Defaults to today. 
 * @return Returns a boolean. 
 * @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, August 17, 2001 
 */
function IsWeekend() {
	var today = Now();
	if(ArrayLen(Arguments)) today = Arguments[1];
	return (DayOfWeek(today) IS 1 OR DayOfWeek(today) IS 7);
}

/**
 * Returns the day of the week for a date in the Julian calendar.
 * The original alogrithim for the calculation was found at: http://www.faqs.org/faqs/calendars/faq/part1/
 * 
 * @param fullDate 	 Date you want to return the Julian day of the week for. 
 * @return Returns an integer between 1 and 7 representing the day of the week (1=Sunday). 
 * @author Beau A.C. Harbin (&#98;&#104;&#97;&#114;&#98;&#105;&#110;&#64;&#102;&#105;&#103;&#108;&#101;&#97;&#102;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 5, 2001 
 */
function JulianDayofWeek(){
        var date=iif(arraylen(arguments) gt 0,"arguments[1]", "Now()");
	var month = DatePart("m", date);
	var day = DatePart("d", date);
	var year = DatePart("yyyy", date);
	var a = 0;
	var y = 0;
	var m = 0;
	var dayOfWeek = 0;
	a = (14 - month) \ 12;
	y = year - a;
	m = month + 12*a - 2;
	// for Julian calendar:
	dayOfWeek = ((5 + day + y + y\4 + (31*m)\12) mod 7)+1;

	// for Gregorian calendar:
	if(arraylen(arguments) EQ 0){
		dayOfWeek = DayofWeek(date);
	}

	return dayOfWeek;
}

/**
 * Returns a date object representing the last Business day of the given month
 * 
 * @param strMonth 	 Month number. Should range from 1 to 12. (Required)
 * @param strYear 	 Year. Defaults to this year. (Optional)
 * @return Returns a date object. 
 * @author Sravan K Erukulla (&#101;&#114;&#117;&#107;&#117;&#108;&#108;&#97;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, May 13, 2003 
 */
function LastBusinessDayOfMonth(strMonth) {
	var strYear=Year(Now());
	var busDay = false;
	var tempDate = "";

	if (ArrayLen(Arguments) gt 1) strYear=Arguments[2];

	tempDate = DateAdd("d", -1, DateAdd("m", 1, CreateDate(strYear, strMonth, 1)));
	
	while (busDay eq false) {
  		
   		if (dayOfWeek(tempDate) GTE 2 AND dayOfWeek(tempDate) LTE 6) return tempDate;
  		else {
  			tempDate = DateAdd("d",-1,tempDate);
			busDay = false;
  		}
	}
	
}

/**
 * Returns a date object representing the last day of the given month.
 * 
 * @param strMonth 	 Month you want to get the last day for, (Required)
 * @param strYear 	 Year for the specified month.  Useful for leap years.  The default is the current year. (Optional)
 * @return Returns a date object. 
 * @author Ryan Kime (&#114;&#121;&#97;&#110;&#46;&#107;&#105;&#109;&#101;&#64;&#115;&#111;&#109;&#110;&#105;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, May 7, 2002 
 */
function LastDayOfMonth(strMonth) {
  var strYear=Year(Now());
  if (ArrayLen(Arguments) gt 1)
    strYear=Arguments[2];
  return DateAdd("d", -1, DateAdd("m", 1, CreateDate(strYear, strMonth, 1)));
}

/**
 * Returns a date object representing the first day of the previous month.
 * 
 * @param Date 	 Date object to go to the previous month on. Defaults to now. 
 * @return Returns a date object. 
 * @author Will Belden (&#119;&#98;&#101;&#108;&#100;&#101;&#110;&#64;&#100;&#119;&#111;&#46;&#110;&#101;&#116;) 
 * @version 1, September 6, 2001 
 */
function LastMonth() {
	var db = iif(arrayLen(arguments),"arguments[1]","now()");
	return DateAdd("m",-1,CreateDate(Year(db), Month(db), 1));
}

/**
 * Return a date in a locale-specific short form.
 * 
 * @param date 	 The date to modify. (Required)
 * @return Returns a string. 
 * @author Matthew Walker (&#109;&#97;&#116;&#116;&#104;&#101;&#119;&#64;&#99;&#97;&#98;&#98;&#97;&#103;&#101;&#116;&#114;&#101;&#101;&#46;&#99;&#111;&#46;&#110;&#122;) 
 * @version 1, June 28, 2002 
 */
function LSShortDateFormat(date) {
	return LSDateFormat(date, ShortDateMask());
}

/**
 * Creates pulldowns for month, day and year.
 * 
 * @param NameList 	 A list specifying the names to use for the form fields created. (Required)
 * @param StartYear 	 The first year in the year drop down. (Required)
 * @param EndYear 	 The last year in the year drop down. (Required)
 * @param DefaultDate 	 The date the drop downs will default to. Default is now(). (Optional)
 * @param theDelim 	 Delimiter for NameList. Defaults to a comma. (Optional)
 * @return Returns a string. 
 * @author Shawn Seley (&#115;&#104;&#97;&#119;&#110;&#115;&#101;&#64;&#97;&#111;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, June 21, 2002 
 */
function MakeDateSelectLists(NameList, StartYear, EndYear) {
	var out_string  = "";
	var i           = 1;
	var theDelim    = ",";
	var CR          = chr(13);
	var defaultDate = now();
	
	if(arrayLen(arguments) gte 4) defaultDate = arguments[4];
	if(ArrayLen(Arguments) GTE 5) theDelim = Arguments[5];

	// Month
	out_string = "<select name='#ListFirst(NameList, theDelim)#'>#CR#";
	for(i=1; i LTE 12; i=i+1){
		if(i EQ Month(DefaultDate)){
			out_string  = out_string & "<option value='#i#' selected>#MonthAsString(i)#</option>#CR#";
		} else {
			out_string  = out_string & "<option value='#i#'>#MonthAsString(i)#</option>#CR#";
		}
	}
	out_string = out_string & "</select>#CR##CR#";

	// Day
	out_string = out_string & "<select name='#ListGetAt(NameList, 2, theDelim)#'>#CR#";
	for(i=1; i LTE 31; i=i+1){
		if(i EQ Day(DefaultDate)){
			out_string  = out_string & "<option value='#i#' selected>#i#</option>#CR#";
		} else {
			out_string  = out_string & "<option value='#i#'>#i#</option>#CR#";
		}
	}
	out_string = out_string & "</select>#CR##CR#";

	// Year
	out_string = out_string & "<select name='#ListLast(NameList, theDelim)#'>#CR#";
	for(i = StartYear; i LTE EndYear; i=i+1){
		if(i EQ Year(DefaultDate)){
			out_string  = out_string & "<option value='#i#' selected>#i#</option>#CR#";
		} else {
			out_string  = out_string & "<option value='#i#'>#i#</option>#CR#";
		}
	}
	out_string = out_string & "</select>#CR##CR#";


	return out_string;
}

/**
 * Returns larger of 2 dates.
 * 
 * @param dt1 	 The first date. (Is always the hardest.) (Required)
 * @param dt2 	 The second date. (Required)
 * @return Returns a date. 
 * @author Shawn Fairweather (&#112;&#115;&#97;&#108;&#109;&#95;&#49;&#49;&#57;&#95;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, September 12, 2003 
 */
function maxDate(Dt1, Dt2){
     if(DateCompare(Dt1, Dt2) IS 1) return Dt1;
     else return Dt2;
}

/**
 * Returns a date in long text format.
 * 
 * @param daytString 	 Date object to convert. (Required)
 * @return Returns a string. 
 * @author Larry Juncker (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;) 
 * @version 1, November 1, 2002 
 */
function MDYAsString(daytString) {
    var dayList="First,Second,Third,Fourth,Fifth,Sixth,Seventh,Eighth,Ninth,Tenth,Eleventh,Twelveth,Thirteenth,Fourteenth,Fifteenth,Sixteenth,Seventeenth,Eighteenth,Nineteenth,Twentieth,Twenty First,Twenty Second,Twenty Third,Twenty Fourth,Twenty Fifth,Twenty Sixth,Twenty Seventh,Twenty Eighth,Twenty Ninth,Thirtieth,Thirty First";
    var DayAsString = ListGetAt(dayList,Day(DaytString));
    var numTenList="Ten,Twenty,Thirty,Fourty,Fifty,Sixty,Seventy,Eighty,Ninety";
    var numList="One,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Eleven,Twelve,Thirteen,Fourteen,Fifteen,Sixteen,Seventeen,Eighteen,Nineteen";
    var y1=mid(Year(DaytString),1,1);
    var y2=mid(Year(DaytString),2,1);
    var y3=mid(Year(DaytString),3,1);
    var y4=mid(Year(DaytString),4,1);
    var y2Str = '';
    var y3Str = '';
		
    if(y2 gt 0) y2Str = ListGetAt(numList,y2) & " Hundred";
    if(y3 gt 0) y3Str = ListGetAt(numTenList,y3);
				
    return "The " & DayAsString & " day of " & MonthAsString(Month(DaytString)) & ", in the year " & ListGetAt(numList,y1) & " Thousand "   & y2Str & " " &  " and " & y3Str & " " & ListGetAt(numList,y4);

}

/**
 * Returns smaller of 2 dates.
 * 
 * @param dt1 	 First date. (Required)
 * @param dt2 	 Second date. (Required)
 * @return Returns a date. 
 * @author Shawn Fairweather (&#112;&#115;&#97;&#108;&#109;&#95;&#49;&#49;&#57;&#95;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, September 12, 2003 
 */
function minDate(Dt1, Dt2){
     if(DateCompare(Dt2, Dt1) IS 1) return Dt1;
     else return Dt2;
}

/**
 * Converts milliseconds to seconds.
 * 
 * @param tick 	 Number of milliseconds you want converted to seconds. 
 * @return Returns a numeric value. 
 * @author Pete Ruckelshaus (&#112;&#114;&#117;&#99;&#107;&#101;&#108;&#115;&#104;&#97;&#117;&#115;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 * @version 1, November 26, 2001 
 */
function MsToSec(tick) 
{
  return tick/1000;
}

/**
 * Returns a date object representing the first day of the next month.
 * Version 2 by Raymond Camden
 * 
 * @param Date 	 Date object to go to the next month on. Defaults to now. 
 * @return Returns a date object. 
 * @author Will Belden (&#119;&#98;&#101;&#108;&#100;&#101;&#110;&#64;&#100;&#119;&#111;&#46;&#110;&#101;&#116;) 
 * @version 1, September 6, 2001 
 */
function NextMonth() {
 	var db = iif(arrayLen(arguments),"arguments[1]","now()");
	return DateAdd("m",1,CreateDate(Year(db), Month(db), 1));
}

/**
 * Returns a date object representing the next occurrence of the specified day.  The default is the next occurrence of the current day.
 * This function is based on an idea submitted by Larry Juncker (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;).
 * 
 * @param day 	 Ordinal day of the week.  1=Sunday, 2=Monday, 3=Tuesday, etc.   
 * @return Returns a date. 
 * @author Rob Brooks-Bilson (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, August 22, 2001 
 */
function  NextOccOfDOW()
{
  Var day = DayOfWeek(Now());
  Var dayOffset = 7;
  if(ArrayLen(Arguments)) 
    day = Arguments[1];
  if(Day GT DayOfWeek(Now()))
    dayOffset = 0;
  return DateAdd("d",(dayOffset + (day - DayOfWeek(Now()))),Now());    
}

/**
 * Parses a CMS (SVN or CVS) datetime into a CF datetime object.
 * 
 * @param cmsDatetime 	 Datetime value from SVN/CVS. (Required)
 * @return Returns a date and time. 
 * @author Peter J. Farrell (&#112;&#106;&#102;&#64;&#109;&#97;&#101;&#115;&#116;&#114;&#111;&#112;&#117;&#98;&#108;&#105;&#115;&#104;&#105;&#110;&#103;&#46;&#99;&#111;&#109;) 
 * @version 1, January 26, 2006 
 */
function parseCMSDatetime(cmsDatetime) {
	// Replace all /'s that CVS uses with -'s
	return LSParseDatetime(replace(listGetAt(arguments.cmsDatetime, 2, " "), "/", "-", "ALL") & " " & listGetAt(arguments.cmsDatetime, 3, " "));
}

/**
 * Makes a &quot;European&quot; date (day before month) into a U.S. style date.
 * 
 * @param euroDate 	 Date string. (Required)
 * @return Returns a date string. 
 * @author Nathan Dintenfass (&#110;&#97;&#116;&#104;&#97;&#110;&#64;&#99;&#104;&#97;&#110;&#103;&#101;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, May 13, 2003 
 */
function parseEuroDate(euroDate){
	//grab the old locale, so we can switch it back
	var oldLocale = getLocale();
	//a var to hold our dateTime
	var dateTime = "";
	//set the locale to British -- they use the Euro format!
	setLocale("English (UK)");
	//parse it using the localization function for parsing date time
	dateTime = LSParseDateTime(arguments.euroDate);
	//now set the Locale back, so we don't mess up the server
	setLocale(oldLocale);
	//return our dateTime that was parsed
	return dateTime;
}

/**
 * Creates a date/time object from a generalized time string in the format of YYYYMMDDHHMMSS.0Z
 * 
 * @param timeString 	 Generalized time string. (Required)
 * @return Returns a date object. 
 * @author Michael Dawson (&#109;&#100;&#52;&#48;&#64;&#101;&#118;&#97;&#110;&#115;&#118;&#105;&#108;&#108;&#101;&#46;&#101;&#100;&#117;) 
 * @version 1, December 16, 2005 
 */
function parseGeneralizedTimeString(timeString){
	// This function expects a generalize time string in the following format: 19880923191500.0Z

	// Return the parsed date/time object.
	return parseDateTime(left(arguments.timeString, 4) & "-" & mid(arguments.timeString, 5, 2) & "-" & mid(arguments.timeString, 7, 2) & " " & mid(arguments.timeString, 9, 2) & ":" & mid(arguments.timeString, 11, 2) & ":" & mid(arguments.timeString, 13, 2));
}

/**
 * Returns a date object representing the previous day specified.  The default is one week prior to the current day.
 * This function is based on an idea submitted by Larry Juncker (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;).
 * 
 * @param day 	 Ordinal day of the week.  1=Sunday, 2=Monday, 3=Tuesday, etc.   
 * @return Returns a date. 
 * @author Rob Brooks-Bilson (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, August 22, 2001 
 */
function  PrevOccOfDOW()
{
  Var day = DayOfWeek(Now());
  Var dayOffset = 7;
  if(ArrayLen(Arguments)) 
    day = Arguments[1];
  if(Day LT DayOfWeek(Now()))
    dayOffset = 0;    
  return DateAdd("d",- (dayOffset - (day - DayOfWeek(Now()))),Now());
}

/**
 * Qualitative description of a date.
 * 
 * @param date 	 Date you want to return a qualitative description for. 
 * @return Returns a string. 
 * @author Matthew Walker (&#109;&#97;&#116;&#116;&#104;&#101;&#119;&#64;&#99;&#97;&#98;&#98;&#97;&#103;&#101;&#116;&#114;&#101;&#101;&#46;&#99;&#111;&#46;&#110;&#122;) 
 * @version 1, April 15, 2002 
 */
function QualitativeDate(Date) {

	var Today = Now();
	var YearsDifference = Year(Today) - Year(Date);
	var MonthsDifference = Month(Today) - Month(Date);
	var WeeksDifference = Week(Today) - Week(Date);
	var DaysDifference = DayOfWeek(Today) - DayOfWeek(Date);
	
	if ( DateCompare(Date, Now()) LT 1 ) {
		if ( YearsDifference GT 2 )
			return "A long time ago";
		if ( YearsDifference EQ 2 )
			return "Two years ago";
		if ( YearsDifference EQ 1 )
			return "Last year";
		if ( MonthsDifference GT 2 )
			return "Earlier this year";
		if ( MonthsDifference EQ 2 )
			return "Two months ago";
		if ( MonthsDifference EQ 1 )
			return "Last month";
		if ( WeeksDifference GT 2 )
			return "Earlier this month";
		if ( WeeksDifference EQ 2 )
			return "Two weeks ago";
		if ( WeeksDifference EQ 1 )
			return "Last week";	
		if ( DaysDifference GT 1 )
			return "Earlier this week";
		if ( DaysDifference EQ 1 )
			return "Yesterday";	
		return "Today";
	}		
	else {
		if ( YearsDifference LT -1 )
			return "Sometime in the future";
		if ( YearsDifference EQ -1 )
			return "Next year";
		if ( MonthsDifference LT -1 )
			return "Later this year";
		if ( MonthsDifference EQ -1 )
			return "Next month";
		if ( WeeksDifference LT 0 )
			return "Later this month";
		if ( DaysDifference LT -2 )
			return "Later this week";
		if ( DaysDifference EQ -2 )
			return "Two days from now";
		if ( DaysDifference EQ -1 )
			return "Tomorrow";	
		return "Today";	
	}		
}

/**
 * Returns a string with a mixed fraction of quarters.
 * 
 * @param minutes 	 The number of minutes. (Required)
 * @return Returns a string. 
 * @author Dave Babbitt (&#100;&#97;&#118;&#101;&#64;&#98;&#97;&#98;&#98;&#105;&#116;&#116;&#46;&#111;&#114;&#103;) 
 * @version 1, September 23, 2004 
 */
function QuarterHour(minutes) {
	var mixedFraction = "";
	var hours = 0;
	var quarterHours = 0;
	
	/* Get hours and let minutes be the remainder */
	hours = Int(minutes/60);
	minutes = minutes - hours*60;

	/* 15 minutes is a "quarter hour" - round up to the nearest one */
	quarterHours = Round(minutes/15);
	if(quarterHours GTE 4) {
		quarterHours = 0;
		hours = IncrementValue(hours);
	}

	/* Build the mixed fraction */
	if(quarterHours GT 0) {
		if(quarterHours EQ 2) mixedFraction = ' 1/2';
		else mixedFraction = ' ' & quarterHours & '/4';
	} else mixedFraction = '';

	mixedFraction = hours & mixedFraction;
	return mixedFraction;
}

/**
 * Converts seconds to nearest time unit in english.
 * 
 * @param iSeconds 	 Number of seconds. (Required)
 * @return Returns a string. 
 * @author Peter Crowley (&#112;&#99;&#114;&#111;&#119;&#108;&#101;&#121;&#64;&#119;&#101;&#98;&#122;&#111;&#110;&#101;&#46;&#105;&#101;) 
 * @version 1, January 21, 2005 
 */
function secondsToEnglish(iSeconds) {
	var szPlural = "";
	var iTime = "";
	var szUpdate = "";
	
	if (iSeconds LTE 0) iSeconds=1;
	iTime=iSeconds \ 86400;
	if (iTime GT 0) {
		if (iTime GT 1) szPlural = 's';
		szUpdate = "#iTime# day#szPlural#";  // Days
	} else {
		iTime=iSeconds \ 3600;
		if (iTime GT 0) {
			if (iTime GT 1) szPlural = 's';
			szUpdate = "#iTime# hour#szPlural#"; // Hours
		} else {
			iTime=iSeconds \ 60;
			if (iTime GT 0) {
				if (iTime GT 1) szPlural = 's';
				szUpdate = "#iTime# minute#szPlural#"; // Minutes
			} else {
				iTime=iSeconds;
				if (iTime NEQ 1) szPlural = 's';
				szUpdate = "#iTime# second#szPlural#"; // Seconds
			}
		}
	}
	return szUpdate;
}

/**
 * Takes number of seconds as input and returns a formatted string representation of that duration (weeks/days/hours/mins/secs).
 * 
 * @param seconds 	 The number of seconds. (Required)
 * @param format 	 Either l, m, s, for long, medium, or short. (Required)
 * @return Returns a string. 
 * @author Kevin Miller (&#107;&#109;&#105;&#108;&#108;&#101;&#114;&#64;&#119;&#101;&#98;&#115;&#111;&#108;&#101;&#116;&#101;&#46;&#99;&#111;&#109;) 
 * @version 1, October 19, 2004 
 */
function secsToTime(seconds,format) {
	var output = "";
	var timeval_w = "";
	var remaining_time = "";
	var t_w = "";
	var timeval_d = "";
	var t_d = "";
	var timeval_h = "";
	var t_h = "";
	var timeval_m = "";
	var t_m = "";
	var timeval_s = "";
	var t_s = "";
	var f_w = "";
	var f_d = "";
	var f_h = "";
	var f_m = "";
	var f_s = "";
		
	// handle very small times 
	if(arguments.seconds lt 1) {
		return "<1 sec";
	}

	// handle format syntax
	arguments.format = left(arguments.format,1);

	
	// weeks
	timeval_w = arguments.seconds/604800;
		if(timeval_w gte 1) {
				timeval_w = int(timeval_w); t_w = "#timeval_w#";
				remaining_time = arguments.seconds - (timeval_w * 604800); }
		else {
				remaining_time = arguments.seconds;
				t_w = ""; }
	// days
	timeval_d = remaining_time/86400;
		if(timeval_d gte 1) {
				timeval_d = int(timeval_d); t_d = "#timeval_d#";
				remaining_time = remaining_time - (timeval_d * 86400); }
		else {
				t_d = ""; }
	// hours
	timeval_h = remaining_time/3600;
		if(timeval_h gte 1) {
				timeval_h = int(timeval_h); t_h = "#timeval_h#";
				remaining_time = remaining_time - (timeval_h * 3600); }
		else {
				t_h = ""; }
	// minutes
		timeval_m = remaining_time/60;
			if(timeval_m gte 1) {
				timeval_m = int(timeval_m); t_m = "#timeval_m#";
				remaining_time = remaining_time - (timeval_m * 60); }
			else {
				t_m = ""; }
	// seconds
		timeval_s = remaining_time; 
			if(timeval_s gt 0) {
				t_s = "#round(timeval_s)#"; }
			else {
				t_s = ""; }

	switch (arguments.format) { 
		case "l": 
			f_w = "week"; f_d = "day"; f_h = "hour"; f_m = "minute"; f_s = "second";
			break;
		case "m":
			f_w = "wk"; f_d = "dy"; f_h = "hr"; f_m = "min"; f_s = "sec";
			break;
		case "s":
			f_w = "w"; f_d = "d"; f_h = "h"; f_m = "m"; f_s = "s";
			break;
		default: 
			f_w = "week"; f_d = "day"; f_h = "hour"; f_m = "minute"; f_s = "second";
			break;	
	}
	
	if(val(t_w)) {
		output = output & " #t_w# #f_w#";
		if((val(t_w) neq 1) and not listfindnocase("short,s",arguments.format)) output = output & "s"; 
	}
	if(val(t_d)) {
		output = output & " #t_d# #f_d#";
		if((val(t_d) neq 1) and not listfindnocase("short,s",arguments.format)) output = output & "s";
	}
	if(val(t_h)) {
		output = output & " #t_h# #f_h#";
		if((val(t_h) neq 1) and not listfindnocase("short,s",arguments.format)) output = output & "s"; 
	}
	if(val(t_m)) {
		output = output & " #t_m# #f_m#";
		if((val(t_m) neq 1) and not listfindnocase("short,s",arguments.format)) output = output & "s"; 
	}
	if(val(t_s)) {
		output = output & " #t_s# #f_s#";
		if((val(t_s) neq 1) and not listfindnocase("short,s",arguments.format)) output = output & "s";  
	}

	return output;

}

/**
 * Generates a mask for a short date based on the locale.
 * 
 * @param locale 	 The locale to use. Defaults to getLocale() (Optional)
 * @return Returns a string. 
 * @author matthew walker (&#109;&#97;&#116;&#116;&#104;&#101;&#119;&#64;&#99;&#97;&#98;&#98;&#97;&#103;&#101;&#116;&#114;&#101;&#101;&#46;&#99;&#111;&#46;&#110;&#122;) 
 * @version 1, June 28, 2002 
 */
function ShortDateMask() {
	var Locale = GetLocale();
	var LocaleList = "Dutch (Belgian),Dutch (Standard),English (Australian),English (Canadian),English (New Zealand),English (UK),English (US),French (Belgian),French (Canadian),French (Standard),French (Swiss),German (Austrian),German (Standard),German (Swiss),Italian (Standard),Italian (Swiss),Norwegian (Bokmal),Norwegian (Nynorsk),Portuguese (Brazilian),Portuguese (Standard),Spanish (Mexican),Spanish (Modern),Spanish (Standard),Swedish";
	var MaskList = "d/mm/yyyy,d-m-yyyy,d/mm/yyyy,,dd/mm/yyyy,d/mm/yyyy,dd/mm/yyyy,m/d/yyyy,d/mm/yyyy,yyyy-mm-dd,dd/mm/yyyy,dd.mm.yyyy,dd.mm.yyyy,dd.mm.yyyy,dd.mm.yyyy,dd/mm/yyyy,dd.mm.yyyy,dd.mm.yyyy,dd.mm.yyyy,d/m/yyyy,dd-mm-yyyy,dd/mm/yyyy,dd/mm/yyyy,dd/mm/yyyy,yyyy-mm-dd";
	var ListPos = 0;
	if ( ArrayLen(Arguments) )
		Locale = Arguments[1]; 
	ListPos = ListFindNoCase(LocaleList, Locale);
	if ( ListPos )
		return ListGetAt(MaskList, ListPos);
	else 
		return "";	
}

/**
 * Returns the current internet time.
 * 
 * @return Returns a string. 
 * @author B Kiefer (&#112;&#97;&#99;&#107;&#101;&#116;&#115;&#100;&#111;&#110;&#116;&#108;&#105;&#101;&#64;&#109;&#97;&#99;&#46;&#99;&#111;&#109;) 
 * @version 1, July 5, 2002 
 */
function swatchIT(){
	var myutc = GetTimeZoneInfo();
	var beats = ((3600 + Val(Hour(now()) * 3600) + Val(Minute(now()) * 60) + Second(now()) + val(myutc.utcTotalOffset)) mod 86400) / 86.4;
	return decimalformat(beats);
}

/**
 * Returns structure containing month information.
 * 
 * @param current_date 	 The date to use. Defaults to now(). (Optional)
 * @return Returns a structure. 
 * @author Ian Winter (&#105;&#97;&#110;&#119;&#105;&#110;&#116;&#101;&#114;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, July 25, 2005 
 */
function thisMonth() {
	var returnStruct = structNew();
	var current_date = now();
	var letterList="st,nd,rd,th";
	var domLetters="";
	var i = "";
	var thisDate = "";
	var thisKey = "";
	var domStr = "";
	
	if (arrayLen(arguments)) current_date = arguments[1];
	
	returnStruct.monthBegin = CreateDate(Year(current_date),Month(current_date),01);
	returnStruct.monthEnd = CreateDate(Year(current_date),Month(current_date),DaysInMonth(current_date));
	returnStruct.monthNumber = Month(current_date);
	returnStruct.monthDays = DaysInMonth(current_date);
	
	for(i=1; i LTE returnStruct.monthDays ; i=i+1) {
		thisDate = CreateDate(Year(current_date),Month(current_date),i);
		thisKey = dateAdd("d",i-1,returnStruct.monthBegin);
		domStr = DateFormat(thisDate,"d");
		switch (domStr) {
			case "1": case "21": case "31":  domLetters=ListGetAt(letterList,'1'); break;
			case "2": case "22": domLetters=ListGetAt(letterList,'2'); break;
			case "3": case "23": domLetters=ListGetAt(letterList,'3'); break;
			default: domLetters=ListGetAt(letterList,'4');
		}
		StructInsert(returnStruct,i,StructNew());
		StructInsert(returnStruct[i],"dayAsString",DayOfWeekAsString(DayOfWeek(thisDate)));
		StructInsert(returnStruct[i],"date",thisKey);
		StructInsert(returnStruct[i],"dateLetters",domLetters);
	}
	
	return returnStruct;

}

/**
 * Generates a structure of days for the week, including the beginning and end of the week.
 * Rewrite by Raymond Camden
 * 
 * @param date 	 Date to use. Defaults to this week. 
 * @return Returns a structure. 
 * @author Rich Rein (&#114;&#105;&#99;&#104;&#97;&#114;&#100;&#46;&#114;&#101;&#105;&#110;&#64;&#109;&#101;&#100;&#116;&#114;&#111;&#110;&#105;&#99;&#46;&#99;&#111;&#109;) 
 * @version 2, February 25, 2002 
 */
function thisWeek() {
	var dayOrdinal = 0;
	var returnStruct = structNew();
	var current_date = now();
	
	if (arrayLen(arguments)) current_date = arguments[1];
	dayOrdinal = DayOfWeek(current_date);
	
	returnStruct.weekBegin = dateAdd("d",-1 * (dayOrdinal-1), current_date);
	returnStruct.weekEnd = dateAdd("d",7-dayOrdinal, current_date);
	returnStruct.weekNo = Week(returnStruct.weekBegin);
	
	for(i=1; i LTE 7; i=i+1) {
		StructInsert(returnStruct,DayOfWeekAsString(i),dateAdd("d",i-1,returnStruct.weekBegin));
	}
	
	return returnStruct;

}

/**
 * Returns a date object representing tomorrow.
 * 
 * @return Returns a date object representing tomorrow. 
 * @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, August 17, 2001 
 */
function Tomorrow() {
return DateAdd("d",1,Now());
}

/**
 * Display date in Turkish language and Turkish date format.
 * 
 * @param givenDate 	 Date you want to display in Turkish. (Required)
 * @param dateDisplayFormat 	 Format mask to apply.   (Required)
 * @return Returns a string. 
 * @author Nurettin Omer Hamzaoglu (&#111;&#109;&#101;&#114;&#64;&#104;&#97;&#109;&#122;&#97;&#111;&#103;&#108;&#117;&#46;&#99;&#111;&#109;) 
 * @version 1, May 14, 2002 
 */
function TurkishDateFormat(GivenDate,DateDisplayFormat){
  var ChangedDate=DateFormat(GivenDate,"mm/dd/yyyy");
  var Ay="";
  var Yil="";
  var Gun = "";
  var DateToDisplay = "";

  if(DateDisplayFormat IS "2" OR DateDisplayFormat IS "4"){
    Gun = ReplaceList(DateFormat(ChangedDate,"ddd"),"Mon,Tue,Wed,Thu,Fri,Sat,Sun","Pazartesi,Salý,Çarþamba,Perþembe,Cuma,Cumartesi,Pazar");
  }	
  Ay = ReplaceList(DateFormat(ChangedDate,"mm"),"01,02,03,04,05,06,07,08,09,10,11,12","Ocak,Þubat,Mart,Nisan,Mayýs,Haziran,Temmuz,Aðustos,Eylül,Ekim,Kasým,Aralýk");
  Yil = DateFormat(GivenDate,"yyyy");

  switch(DateDisplayFormat){
    case 1: {
      DateToDisplay = DateFormat(GivenDate,"dd")&"/"&Ay&"/"&Yil;
      break;
    }
    case 2: {
      DateToDisplay = DateFormat(GivenDate,"dd")&"/"&Ay&"/"&Yil&" "&Gun;
      break;
    }
    case 3: {
      DateToDisplay = DateFormat(GivenDate,"dd")&" "&Ay&" "&Yil;
      break;
    }
    case 4: {
      DateToDisplay = DateFormat(GivenDate,"dd")&" "&Ay&" "&Yil&" "&Gun;
      break;
    }
    case 5: {
      DateToDisplay = DateFormat(GivenDate,"dd");
      break;
    }
    case 6: {
      DateToDisplay = Ay;
      break;
    }
    case 7: {
      DateToDisplay = Gun;
      break;
    }
    case 8: {
      DateToDisplay = Yil;
      break;
    }    
  }
  return DateToDisplay;
}

/**
 * Returns the number of weekdays between two dates.
 * 
 * @param date1 	 Start date for the date range.  Can take any valid CF date format. 
 * @param date2 	 End date for the date range.  Can take any valid CF date format. 
 * @return Returns a numeric value. 
 * @author Dan Anderson (&#117;&#100;&#102;&#64;&#115;&#114;&#55;&#55;&#46;&#99;&#111;&#109;) 
 * @version 1.0, October 9, 2001 
 */
function weekdays(date1,date2){
  //initialize variables
  var wday=0;
  var day=0;
  var numdays=0;
  
  //get total number of days in between days and save it in numdays
  numdays=datediff("d",date1,date2);
  //loop through all the days between the dates.
  for (day=0; day lte numdays; day=day+1){
  
   if(dayofweek(dateadd("d",day,date1)) neq 1 and dayofweek(dateadd("d",day,date1)) neq 7){
   //if the day is neither saturday or sunday add a week day.
   wday=wday+1;}
  } 
 return wday;
 }

/**
 * Returns the week number in a month.
 * 
 * @param theDate 	 Date to use. Defaults to now(). (Optional)
 * @return Returns a number. 
 * @author Casey Broich (&#99;&#97;&#98;&#64;&#112;&#97;&#103;&#101;&#120;&#46;&#99;&#111;&#109;) 
 * @version 1, September 21, 2004 
 */
function weekInMonth() {
  var theDate = Now();
  
  if(arrayLen(arguments)) theDate = arguments[1];
  return  week(theDate) - week(createDate(year(theDate),month(theDate),1)) + 1;
}

/**
 * Returns the week numbers in a given month of a given year.
 * 
 * @param month 	 The month number. (Required)
 * @param year 	 The year. (Required)
 * @return Returns an array. 
 * @author Robby L. (&#114;&#111;&#98;&#98;&#121;&#64;&#111;&#104;&#115;&#111;&#103;&#111;&#111;&#101;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, January 8, 2004 
 */
function weekNumsInMonth(month,year) {
	var fakedate = createDate(year,month,1);
	var firstWeek = week(fakedate);
	var lastWeek = week(dateAdd("m", 1, fakedate));
	var i = "";
	var aWeek = arrayNew(1);
	for(i=firstWeek;i lte lastWeek;i=i+1) {
		arrayAppend(aWeek, i);
	}
	return aWeek;
 }

/**
 * Takes a week number and returns a date object of the first day of that week.
 * Added ISOFormat, RCamden, 3/19/2002
 * 
 * @param weekNum 	 The week number. 
 * @param weekYear 	 The year. 
 * @param ISOFormat 	 Use ISO for first day of week. Defaults to false. 
 * @return Returns a date object. 
 * @author David Murphy (&#100;&#109;&#117;&#114;&#112;&#104;&#121;&#53;&#50;&#64;&#108;&#121;&#99;&#111;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, March 19, 2002 
 */
function weekStartDate(weekNum,weekYear) {
	var weekDate = dateAdd("WW",weekNum-1,"1/1/" & weekYear);
	var toDay1 = dayofweek(weekDate)-1;
	var weekStartDate = dateAdd("d",-toDay1,weekDate);
	if(arrayLen(arguments) gte 3 and arguments[3]) weekStartDate = dateAdd("d",1,weekStartDate);
	return weekStartDate;	
 }

/**
 * Takes an Date/Time and makes it into XSD time format (for use in xml xsds)
 * 
 * @param str_date 	 Date/time you want converted to XSD format. 
 * @return Returns a string. 
 * @author Rob (r2) (&#114;&#111;&#98;&#64;&#114;&#116;&#119;&#111;&#46;&#110;&#101;&#116;) 
 * @version 1, March 18, 2002 
 */
function XSDDateFormat(str_date){
   return DateFormat(str_date,"yyyy-mm-ddT") & TimeFormat(str_date,"HH:mm:ss");
}

/**
 * Returns a string representation of the numeric year passed into it.
 * version 1 by Larry Juncker (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;)
 * 
 * @param yearnum 	 Numeric year. (Required)
 * @return Returns a string. 
 * @author Christopher Jewell (&#108;&#106;&#117;&#110;&#99;&#107;&#101;&#114;&#64;&#97;&#108;&#106;&#99;&#111;&#109;&#112;&#115;&#101;&#114;&#118;&#46;&#99;&#111;&#109;&#99;&#100;&#106;&#101;&#119;&#101;&#108;&#108;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 2, March 17, 2006 
 */
function yearAsString(yearnum) {
    var numTenList="Ten,Twenty,Thirty,Forty,Fifty,Sixty,Seventy,Eighty,Ninety";
    var numList="One,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Eleven,Twelve,Thirteen,Fourteen,Fifteen,Sixteen,Seventeen,Eighteen,Nineteen";
    var y1 = mid(yearnum,1,1);
    var y2 = mid(yearnum,2,1);
    var y3 = mid(yearnum,3,1);
    var y4 = mid(yearnum,4,1);
	var YY = mid(yearnum,3,2);
    var y2Str = "";
    var y3Str = "";
    var y4Str = "";
	var yearStr = "";

    if(y2 GT 0) y2Str = listGetAt(numList,y2) & " Hundred";
	
	//Special case for XX11 through XX19
	if(YY gt 10 and YY lt 20) {
		y3Str = listGetAt(numList,YY);
	} else {
	    if(y3 GT 0) y3Str = listGetAt(numTenList,y3);
		if(y4 GT 0) y4Str = listGetAt(numList,y4);
	}

	if(len(y3Str) or len(y4Str)) {
		yearStr = listGetAt(numList,y1) & " Thousand "   & y2Str & " " &  " and " & y3Str & " " & y4Str;
	} else {
		yearStr = listGetAt(numList,y1) & " Thousand "   & y2Str;
	}
	return trim(yearStr);
}

/**
 * Returns a date object representing yesterday.
 * 
 * @return Returns a date object representing tomorrow. 
 * @author Ben Forta (&#98;&#101;&#110;&#64;&#102;&#111;&#114;&#116;&#97;&#46;&#99;&#111;&#109;) 
 * @version 1, August 17, 2001 
 */
function Yesterday() {
    return DateAdd("d",-1,Now());
}
</cfscript>

<!---
 This is the opposite of CFs DayOfYear function.
 v2 bug fix by David Levin (&#100;&#97;&#118;&#101;&#64;&#97;&#110;&#103;&#114;&#121;&#115;&#97;&#109;&#46;&#99;&#111;&#109;)
 v3 fix by Christopher Jordan
 
 @param currentDayOfYear 	 Numerical day of the year. (Required)
 @param currentYear 	 The year. Defaults to this year. (Optional)
 @return Returns a date. 
 @author Jeff Houser (&#100;&#97;&#118;&#101;&#64;&#97;&#110;&#103;&#114;&#121;&#115;&#97;&#109;&#46;&#99;&#111;&#109;&#106;&#101;&#102;&#102;&#64;&#102;&#97;&#114;&#99;&#114;&#121;&#102;&#108;&#121;&#46;&#99;&#111;&#109;) 
 @version 3, September 7, 2007 
--->
<cffunction name="dayOfYearReverse" returntype="date" hint="Accepts the day of Year (Integer) and year in question, and returns the date" output="false">
        <cfargument name="currentDayOfYear" type="numeric" required="yes">
        <cfargument name="currentYear" type="numeric" default="#year(now())#" required="no">
        <cfreturn dateAdd("d",arguments.currentDayOfYear, createDate(arguments.currentyear-1,"12","31" ))>
</cffunction>

<!---
 Takes a W3 date and returns a CF datetime.
 
 @param dts 	 Datetime string. (Required)
 @return Returns a date. 
 @author Jared Rypka-Hauer (&#106;&#97;&#114;&#101;&#100;&#64;&#119;&#101;&#98;&#45;&#114;&#101;&#108;&#101;&#118;&#97;&#110;&#116;&#46;&#99;&#111;&#109;) 
 @version 1, August 2, 2006 
--->
<cffunction name="getCfDateTimeFromW3DateTime" access="public" returntype="string" output="false">
    <cfargument name="dts" type="string" required="true" />
    <cfif left(dts,1) is "(">
        <cfset dts = mid(dts,2,len(dts)-2)>
    </cfif>
    <cfset dts = listToArray(reReplace(dts,"(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(\D)?(\d{2})?(:00)?","\2/\3/\1 \4:\5:\6;\7;\8"),";")>
    <cfif arrayLen(dts) IS 2>
        <cfreturn createDateTime(year(dts[1]),month(dts[1]),day(dts[1]),hour(dts[1]),minute(dts[1]),second(dts[1])) />
    <cfelse>
        <cfif dts[2] is "-">
            <cfreturn dateAdd("h",0-listFirst(dts[3],":"),dts[1]) />
        <cfelse>
            <cfreturn dateAdd("h",listFirst(dts[3],":"),dts[1]) />
        </cfif>
    </cfif>
</cffunction>

<!---
 Gets the current graduation year/end of school year.
 
 @param switchmonth 	 Numeric value for the first month of the school year. (Required)
 @return Returns a number. 
 @author Lisa D. Brown (&#119;&#101;&#114;&#116;&#108;&#101;&#64;&#119;&#101;&#114;&#116;&#108;&#101;&#46;&#99;&#111;&#109;) 
 @version 1, April 9, 2007 
--->
<cffunction name="getCurrentGradYear" returntype="numeric">
	<!---last month of a schoolyear--->
	<cfargument name="switchmonth" type="numeric" required="no" default="6">
	<cfset var currGradYear = -1>

	<!---if the current month is between January and the last month of the schoolyear, 
	set the current graduation year to the current year--->
	<cfif month(now()) gte 1 and month(now()) lte arguments.switchmonth>
		<cfset currGradYear = year(now())>
	<!---if the current month is between the first month of the schoolyear and December,
	 set the current graduation year to be next year--->
	<cfelseif month(now()) gt arguments.switchmonth and month(now()) lte 12>
		<cfset currGradYear = year(now()) + 1>
	</cfif>
	<cfreturn currGradYear>
</cffunction>

<!---
 Returns the date for Orthodox Easter (Pascha) in a given year.
 
 @param y 	 Year. Defaults to the current year. (Optional)
 @return Returns a date. 
 @author John E Pusey (&#110;&#105;&#103;&#104;&#116;&#103;&#97;&#122;&#105;&#110;&#103;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 @version 1, April 9, 2007 
--->
<cffunction name="getPascha" returntype="date">
	<cfargument name="y" type="numeric" required="false" default="#year(now())#">
	
	<cfset var t = 0>
	<cfset var dd = 0>
	<cfset var mm = 0>
	
	<cfset t = (19 * (y mod 19) + 16) mod 30>
	<cfset dd = 3 + t + (2 * (y mod 4) + 4 * (y mod 7) + 6 * t) mod 7>

	<cfif y lt 1924>
		<cfset dd = dd - 13>
	</cfif>

	<cfif dd gt 30>
		<cfset dd = dd - 30>
		<cfset mm = 5>
	<cfelse>
		<cfset mm = 4>
	</cfif>
	
	<cfif dd lt 1>
		<cfset dd = dd + 31>
		<cfset mm = 3>
	</cfif>

  <cfreturn createDate(y, mm, dd)>
</cffunction>

<!---
 Returns true/false if a time is between the supplied start/end times.
 v2 by Raymond Camden
 
 @param minTime 	 The lower range of time. (Required)
 @param maxTime 	 The upper range of time. (Required)
 @param time 	 The time to check. Defaults to now(). (Optional)
 @return Returns a boolean. 
 @author Anthony Galano (&#97;&#110;&#116;&#104;&#111;&#110;&#121;&#64;&#119;&#101;&#98;&#112;&#101;&#120;&#46;&#99;&#111;&#109;) 
 @version 1, August 10, 2006 
--->
<cffunction name="isTimeBetween" access="public" returntype="boolean" output="false">
    <cfargument name="minTime" type="date" required="true">
    <cfargument name="maxTime" type="date" required="true">
	<cfargument name="time" type="date" required="false" default="#now()#">
	
    <cfset var curTime = createTime(timeFormat(arguments.time,"H"),timeFormat(arguments.time,"mm"),timeFormat(arguments.time,"ss"))>
    <cfif dateDiff("n",minTime,curTime) gt 0 and
          dateDiff("n",maxTime,curTime) lt 0>
        <cfreturn true>
    <cfelse>
        <cfreturn false>
    </cfif> 
       
</cffunction>

<!---
 Function that returns adjusted local server time.
 
 @return Returns a date object. 
 @author chad jackson (&#99;&#104;&#97;&#100;&#64;&#116;&#101;&#120;&#116;&#105;&#110;&#99;&#46;&#99;&#111;&#109;) 
 @version 1, September 24, 2002 
--->
<cffunction name="LocalTime" returnType="date" output="false" hint="Returns Local Time">
	<cfset var timeZoneInfo = GetTimeZoneInfo()>
	<!--- local time GMT offset. --->
	<cfset var offset = 9>
	<cfset var GMTtime = DateAdd('s', timeZoneInfo.UTCtotalOffset, Now() )>
	<cfset var theLocalTime = DateAdd('h',offset,GMTtime)>
	<cfreturn theLocaltime>
</cffunction>

<!---
 Converts epoch milleseconds to a date timestamp.
 
 @param strMilliseconds 	 The number of milliseconds. (Required)
 @return Returns a date. 
 @author Steve Parks (&#115;&#116;&#101;&#118;&#101;&#64;&#97;&#100;&#101;&#112;&#116;&#100;&#101;&#118;&#101;&#108;&#111;&#112;&#101;&#114;&#46;&#99;&#111;&#109;) 
 @version 1, May 20, 2005 
--->
<cffunction name="millisecondsToDate" access="public" output="false" returnType="date">
	<cfargument name="strMilliseconds" type="string" required="true">
	
	<cfreturn dateAdd("s", strMilliseconds/1000, "january 1 1970 00:00:00")>
</cffunction>

<!---
 cffunction that takes a text string and a format and returns a date object.
 
 @param textString 	 Date as a string. (Required)
 @param format 	 Format of the date. Valid values are: mmddyyyy,yyyymmdd,ddmmyyyy,yyyyddmm (Optional)
 @return Returns a date. 
 @author Bill Rawlinson (&#119;&#109;&#114;&#97;&#119;&#108;&#105;&#110;&#64;&#115;&#98;&#99;&#115;&#46;&#99;&#111;&#109;) 
 @version 1, January 21, 2005 
--->
<cffunction name="textToDate" returnType="string" output="false" hint="converts a numeric string to a date object">
	<cfargument name="textString" type="string"	requied="true" hint="numeric string to convert to a date object">
	<cfargument name="format" type="string" required="false" default="mmddyyyy"	hint="best guess at the format of the string; valid values are mmddyyyy | yyyymmdd | ddmmyyyy | yyyyddmm">

	<cfset var dateval	= arguments.textstring>
	<cfset var month	= "">
	<cfset var day		= "">
	<cfset var year		= "">
	<cfset var detelen = "">
	<cfset var maxDays = "">
	
	<!--- placeholders used to find month and date on strings between 4-6 characters long --->
	<cfset var sp		= "">
	<cfset var counter1	= "">
	<cfset var counter2	= "">

	<cfif isNumeric(dateval)>
		<cfset datelen = len(dateval)>

		<cfswitch expression="#datelen#">
			<cfcase value="1,2,3">
				<cfset day = 1>
				<cfset month = 1>
				<cfset year = "1900">
			</cfcase>
			<cfcase value="4,5,6">
				<cfif right(arguments.format,4) eq "yyyy">
					<cfset year = right(dateval,2)>
					<cfset dateVal = left(dateval,Len(dateval)-2)>
					<cfset arguments.format = left(arguments.format,4)>
				<CFELSE>
					<CFSET year = Left(dateval,2)>
					<CFSET dateVal = Right(dateval,Len(dateval)-2)>
					<CFSET arguments.format = Right(arguments.format,4)>
				</CFIF>

				<!--- 
				due to variable lenths of remaining numbers
				we have to figure out where to chop up the string to get 
				the month and day 
				--->
				<cfset dateLen = len(dateval)>
				<cfset counter1 = 2>
				<cfset counter2 = 2>
				<cfif dateLen EQ 3>
					<cfset counter1 = 2>
					<cfset counter2 = 1>
				<cfelseif dateLen EQ 2>
					<cfset counter1 = 1>
					<cfset counter2 = 1>
				</cfif>

				<cfif left(arguments.format,2) EQ "mm">
					<cfset month = mid(dateval,1,counter1)>
					<cfset sp = 1 + counter1>
					<cfset day = mid(dateval,sp,counter2)>
				<cfelse>
					<cfset day = mid(dateval,1,counter1)>
					<cfset sp = 1 + counter1>
					<cfset month = mid(dateval,sp,counter2)>
				</cfif>

			</cfcase>
			<cfdefaultcase><!--- datelen gt 6 --->
				<cfif right(arguments.format,4) EQ "yyyy">
					<cfset year = right(dateval,4)>
					<cfset dateVal = left(dateval,len(dateval)-4)>
					<cfset arguments.format = left(arguments.format,4)>
				<cfelse>
					<cfset year = left(dateval,4)>
					<cfset dateVal = right(dateval,len(dateval)-4)>
					<cfset arguments.format = right(arguments.format,4)>
				</cfif>
				<cfif left(arguments.format,2) EQ "mm">
					<cfset month = mid(dateval,1,2)>
					<cfset day = mid(dateval,3,2)>
				<cfelse>
					<cfset month = mid(dateval,3,2)>
					<cfset day = mid(dateval,1,2)>
				</cfif>
			</cfdefaultcase>
		</cfswitch>

		<cfset year = mid(val(year),1,4)>
		<cfset year = 0 & year>

		<cfset month = month MOD 12>
		<cfif month EQ 0>
			<cfset month = 12>
		</cfif>

		<cfset maxDays = daysInMonth(createDate(year,month,1))>
		
		<cfset day = day MOD maxDays>
		<cfif day EQ 0>
			<cfset day = maxDays>
		</cfif>

	<cfelseif isDate(dateval)>
		<cfset day = day(dateval)>
		<cfset month= month(dateval)>
		<cfset year= year(dateval)>
	<cfelse>
		 <!--- if an invalid string is passed in we return 1/1/1900 --->
		<cfset day = 1>
		<cfset month = 1>
		<cfset year = "1900">
	</cfif>

	<cfreturn createDate(year,month,day)>

</cffunction>

<!---
 Formats the given date as a Zulu date.
 
 @param offset 	 Offset from GMT. (Required)
 @param date 	 The date to format. (Required)
 @return Returns a string. 
 @author Jeffrey Pratt (&#113;&#117;&#105;&#99;&#113;&#117;&#105;&#100;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 @version 1, August 23, 2005 
--->
<cffunction name="zDateFormat" returntype="string">
	<cfargument name="offset" type="string" required="true"/>
	<cfargument name="date" type="date" required="true"/>
	
	<cfset var sign = Left(offset, 1)/>
	<cfset var hours = Mid(offset, 2, 2)/>
	<cfset var minutes = Mid(offset, 4, 2)/>
	<cfset var zDate = "">
	<cfset var formattedDate = "">
	
	<cfif not IsNumeric(offset) or len(offset) neq 5 or (sign is not "-" and sign is not "+")>
		<cfthrow type="InvalidGMTOffsetFormatException" message="A valid GMT offset is of the form '-hhmm' or '+hhmm', with 'hh' being the number of hours and 'mm' being the number of minutes by which the date is offset from GMT."/>
	</cfif>
	
	<cfif sign Is "+">
		<cfset hours = -hours/>
		<cfset minutes = -minutes/>
	</cfif>
	
	<cfset zDate = dateAdd("n", minutes, dateAdd("h", hours, date))/>
	<cfset formattedDate = dateFormat(zDate, "yyyy-mm-dd") & "T" & timeFormat(zDate, "HH:mm:ss") & "Z"/>
	
	<cfreturn formattedDate/>
</cffunction>
