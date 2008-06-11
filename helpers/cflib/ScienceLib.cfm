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
 * This function calculates the wind chill based upon the new NWS Wind Chill Index calculations.
 * 
 * @param intAirTemperature 	 Temperature 
 * @param intWindSpeed 	 Wind speed in MPH 
 * @return Returns the wind chill. 
 * @author Russel Madere (&#114;&#109;&#97;&#100;&#101;&#114;&#101;&#64;&#116;&#117;&#114;&#98;&#111;&#115;&#113;&#117;&#105;&#100;&#46;&#99;&#111;&#109;) 
 * @version 1, August 22, 2001 
 */
function CalculateWindChill(intAirTemperature, intWindSpeed)
{

    return Round(35.74 + (0.6215 * intAirTemperature) - (35.75 * (intWindSpeed ^ 0.16)) + (0.4275 * intAirTemperature * (intWindSpeed ^ 0.16)));

}

/**
 * Converts Celsius to Fahrenheit.
 * Renamed from CelToFar to CelsiusToFahrenheit.
 * 
 * @param celsius 	 Degrees Celsius to convert to degrees Fahrenheit 
 * @return Returns a simple value 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, September 17, 2001 
 */
function CelsiusToFahrenheit(celsius)
{
  Return ((212-32)/100 * celsius + 32);
}

/**
 * Converts degrees Celsius to degrees Kelvin.
 * 
 * @param celcius 	 Degrees celsius you want converted. 
 * @return Returns a float. 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, September 17, 2001 
 */
function CelsiusToKelvin(celsius)
{
  if (celsius lt -273.15)
    Return -1;
  else
    Return celsius + 273.15;
}

/**
 * Converts degrees Celsius to degrees Rankine.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param celsius 	 Degrees Celsius you want converted to degrees Rankine. 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, September 17, 2001 
 */
function CelsiusToRankine(celsius)
{
  if (celsius lt -273.15)
    return -1;
  else
    return (celsius*1.8)+491.67;
}

/**
 * Converts from degrees Fahrenheit to degrees Celsius.
 * Renamed from FarToCel to FahrenheitToCelsius.
 * 
 * @param fahrenheit 	 Degrees Fahrenheit to convert to Celsius 
 * @return Returns a simple value. 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1.1, September 17, 2001 
 */
function FahrenheitToCelsius(fahrenheit)
{
  Return (100/(212-32) * (fahrenheit - 32));
}

/**
 * Converts degrees Fahrenheit to Degrees Kelvin.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param fahrenheit 	 Degrees fahrenheit you want converted to degrees Kelvin. 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 17, 2001 
 */
function FahrenheitToKelvin(fahrenheit)
{
  if (fahrenheit lt -459.67)
    Return -1;
  else
    Return (fahrenheit + 459.67)/1.8;
}

/**
 * Converts degrees Fahrenheit to degrees Rankine.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param fahrenheit 	 Degrees Fahrenheit you want to convert to Rankine. 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, September 17, 2001 
 */
function FahrenheitToRankine(fahrenheit)
{
  if (fahrenheit lt -459.67)
    return -1;
  else
    return fahrenheit + 459.67;
}

/**
 * Converts degrees Kelvin to degrees Celsius.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param kelvin 	 Degrees Kelvin you want converted. 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, September 17, 2001 
 */
function KelvinToCelsius(kelvin)
{
  Return kelvin - 273.15;
}

/**
 * Converts degrees Kelvin to degrees Fahrenheit.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param kelvin 	 Degrees Kelvin you want converted to Degrees Fahrenheit. 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 17, 2001 
 */
function KelvinToFahrenheit(kelvin)
{
  Return (kelvin*1.8)-459.67;
}

/**
 * Converts degrees Kelvin to degrees Rankine.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param kelvin 	 Degrees Kelvin you want converted to degrees Rankine. 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 17, 2001 
 */
function KelvinToRankine(kelvin)
{
  Return kelvin*1.8;
}

/**
 * Kilograms to pounds conversion.
 * 
 * @param value 	 Weight in kilograms. (Required)
 * @return Returns a number. 
 * @author Casey Broich (&#99;&#97;&#98;&#64;&#112;&#97;&#103;&#101;&#120;&#46;&#99;&#111;&#109;) 
 * @version 1, May 9, 2003 
 */
function KilogramsToPounds(value) {
  var t = '0';
  if(value gt 0) t = value*2.2046;
  return t;
}

/**
 * Converts kilometers to miles.
 * 
 * @param kilometers 	 The number of kilometers you want converted to miles. 
 * @return Returns a numeric value. 
 * @author Joshua Licht (&#106;&#108;&#105;&#99;&#104;&#116;&#53;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1, September 17, 2001 
 */
function KilometersToMiles(Kilometers)
{
  Return Kilometers * 0.6214;
}

/**
 * Converts Knots to Mile Per Hour.
 * 
 * @param knots 	 Number of knots you want to convert to miles per hour. 
 * @return Returns a numeric value. 
 * @author Joshua Licht (&#106;&#108;&#105;&#99;&#104;&#116;&#53;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 10, 2001 
 */
function KtsToMph(knots)
{
  Return Knots * 1.15;
}

/**
 * Converts miles to kilometers.
 * 
 * @param miles 	 The number of miles you want converted to kilometers. 
 * @return Returns a numeric value. 
 * @author Joshua Licht (&#106;&#108;&#105;&#99;&#104;&#116;&#53;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 17, 2001 
 */
function MilesToKilometer(Miles)
{
  Return Miles * 1.609;
}

/**
 * Calculates the molecular weight (amu) of input string.
 * 
 * @param strMolecule 	 Molecule string. 
 * @return Returns a numeric value. 
 * @author Michael Corbridge (&#109;&#99;&#111;&#114;&#98;&#114;&#105;&#100;&#103;&#101;&#64;&#109;&#97;&#99;&#114;&#111;&#109;&#101;&#100;&#105;&#97;&#46;&#99;&#111;&#109;) 
 * @version 2, March 20, 2002 
 */
function molecularWeight(strMolecule) {
	var mw = 0;
	var nextChr = '';
	var strLen = Len(strMolecule);
	var newString='';
	var i = 0;
	var j = 0;
	var n = 0;
	var elementArray = arrayNew(2);
	var aString = arrayNew(1);
	var atom = '';
	var elementWeight = 0;
	var atomicWeightMultiplier = '';
	
	for(i=1; i LTE strLen; i=i+1)
	{
		aString[i]=mid( strMolecule,  i,  1);
	}
	
	arrayAppend(aString,'!');

	for(i=1; i LTE strLen; i=i+1)
	{
		if(aString[i] NEQ '!')
		{
			newString = newString & aString[i];
			nextChr = aString[i+1];
			if(nextChr NEQ '!')
			{
				if(isNumeric(nextChr) OR asc(LCase(nextChr)) IS asc(nextChr))
				{
					newString = newString & '';
				}
				if(asc(UCase(nextChr)) IS asc(nextChr)  AND NOT isNumeric(nextChr))
				{
					newString = newString & ',';
				}
			}
		}
	}
	
	
	// input validation  
	for(n=1; n LTE (arrayLen(aString)-1); n=n+1)
	{
		for(i=33;i LTE 47;i=i+1)
		{
			if(chr(i) IS aString[n])
			{
				return 'invalid input';
			}
		}
		for(i=58;i LTE 64;i=i+1)
		{
			if(chr(i) IS aString[n])
			{
				return 'invalid input';
			}
		}
		for(i=91;i LTE 96;i=i+1)
		{
			if(chr(i) IS aString[n])
			{
				return 'invalid input';
			}
		}
		for(i=123;i LTE 126;i=i+1)
		{
			if(chr(i) IS aString[n])
			{
				return 'invalid input';
			}
		}
	}
	
	
	
	elementArray[1][1]='Na';
	elementArray[1][2]= 22.989770;

	elementArray[2][1]= 'C';
	elementArray[2][2]= 12.011;
	
	elementArray[3][1]= 'N';
	elementArray[3][2]= 14.6667;
	
	elementArray[4][1]= 'H';
	elementArray[4][2]=  1.00079;
	
	elementArray[5][1]= 'O';
	elementArray[5][2]= 15.9994;
	
	elementArray[6][1]= 'K';
	elementArray[6][2]= 39.0983;
	
	elementArray[7][1]= 'Ca';
	elementArray[7][2]= 40.078;
	
	elementArray[8][1]= 'Gd';
	elementArray[8][2]= 157.25;
		
	elementArray[9][1]= 'Cl';
	elementArray[9][2]= 35.453;
	
	elementArray[10][1]= 'Au';
	elementArray[10][2]= 196.96655;
	
	elementArray[11][1]= 'Br';
	elementArray[11][2]= 79.904;
	// add elements as required 
	
	
	for(i=1;i LTE listLen(newString);i=i+1)
	{
		for(j=1;j LTE len(listgetat(newString,i));j=j+1)
		{
			if(isNumeric(mid(listgetat(newString,i),j,1)))
			{
				atomicWeightMultiplier = atomicWeightMultiplier & mid(listgetat(newString,i),j,1);
			}	
		}
		if(len(atomicWeightMultiplier) IS 0)
		{
			atomicWeightMultiplier = 1;
		}
		
		atom = replace(listgetat(newString,i),atomicWeightMultiplier,'');
		
		for(j=1;j LTE arrayLen(elementArray);j=j+1)
		{
			if(atom IS elementArray[j][1])
			{
				mw = mw + (elementArray[j][2] * atomicWeightMultiplier);
			}
		}
		atomicWeightMultiplier='';
	}
	return mw;
}

/**
 * Converts Miles Per Hour to Knots.
 * 
 * @param mph 	 Miles per hour you want converted to knots. 
 * @return Returns a numeric value. 
 * @author Joshua Licht (&#106;&#108;&#105;&#99;&#104;&#116;&#53;&#64;&#104;&#111;&#116;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 10, 2001 
 */
function MphToKts(mph)
{
  Return MPH / 1.15;
}

/**
 * Pounds to kilograms conversion.
 * 
 * @param value 	 Weight in pounds. (Required)
 * @return Returns a number. 
 * @author Casey Broich (&#99;&#97;&#98;&#64;&#112;&#97;&#103;&#101;&#120;&#46;&#99;&#111;&#109;) 
 * @version 1, May 9, 2003 
 */
function PoundsToKilograms(value) {
  var t = '0';
  if(value gt 0) t= value*0.4536;
  return t;
}

/**
 * Converts degrees Rankine to degrees Celsius.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param rankine 	 Degrees Rankine you want converted to degrees Celsius 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 17, 2001 
 */
function RankineToCelsius(rankine)
{
  Return (rankine-491.67)/1.8;
}

/**
 * Converts degrees Rankine to degrees Fahrenheit.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param rankine 	 Degrees Rankine you want converted to degrees Fahrenheit. 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, September 17, 2001 
 */
function RankineToFahrenheit(rankine)
{
  Return rankine-459.67;
}

/**
 * Converts degrees Rankine to degrees Kelvin.
 * Minor enhancements by Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;).
 * 
 * @param rankine 	 Degrees Rankine you want converted to degrees Kelvin. 
 * @return Returns a float. 
 * @author Tony Blackmon (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1.0, September 17, 2001 
 */
function RankineToKelvin(rankine)
{
  Return rankine/1.8;
}
</cfscript>

<!---
 Converts temperatures from and to Celsius, Fahrenheit and Kelvin.
 
 @param otemp 	 Temperature. (Required)
 @param ctype 	 Two character string that determines the conversion. (Required)
 @return Returns a string. 
 @author Jack Poe (&#106;&#97;&#99;&#107;&#112;&#111;&#101;&#64;&#121;&#97;&#104;&#111;&#111;&#46;&#99;&#111;&#109;) 
 @version 1, April 9, 2007 
--->
<cffunction name="tempConvert" output="false" returnType="string">

	<cfargument name="otemp" required="yes" type="numeric">
	<cfargument name="ctype" required="yes" type="string">
	
	<cfif arguments.ctype IS 'CF'>
		<cfset convertedtTemp = (arguments.otemp*1.8)+32>
		<cfset convertedtTemp = convertedtTemp & '&ordm; F'>
		<cfreturn convertedtTemp>
	<cfelseif arguments.ctype IS 'FC'>
		<cfset convertedtTemp = (arguments.otemp-32)*0.5555>
		<cfset convertedtTemp = convertedtTemp & '&ordm; C'>
		<cfreturn convertedtTemp>
	<cfelseif arguments.ctype IS 'CK'>
		<cfset convertedtTemp = arguments.otemp+273.15>
		<cfset convertedtTemp = convertedtTemp & '&ordm; K'>
		<cfreturn convertedtTemp>
	<cfelseif arguments.ctype IS 'KC'>
		<cfset convertedtTemp = arguments.otemp-273.15>
		<cfset convertedtTemp = convertedtTemp & '&ordm; C'>
		<cfreturn convertedtTemp>
	<cfelseif arguments.ctype IS 'FK'>
		<cfset convertedtTemp = ((arguments.otemp-32)*0.5555)+273.15>
		<cfset convertedtTemp = convertedtTemp & '&ordm; K'>
		<cfreturn convertedtTemp>
	<cfelseif arguments.ctype IS 'KF'>
		<cfset convertedtTemp = ((arguments.otemp-273.15)*1.8)+32>
		<cfset convertedtTemp = convertedtTemp & '&ordm; K'>
		<cfreturn convertedtTemp>
	</cfif>

</cffunction>
