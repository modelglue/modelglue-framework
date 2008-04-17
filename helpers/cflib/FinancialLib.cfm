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
 * Computes the theoretical price of an equity option.
 * 
 * @param call_put_flag 	 The Call Put Flag. (Required)
 * @param S 	 The current asset price. (Required)
 * @param X 	 Exercise price. (Required)
 * @param T 	 Time to maturity. (Required)
 * @param r 	 Risk-free Interest rate. (Required)
 * @param v 	 Annualized volatility. (Required)
 * @return Returns a number. 
 * @author Alex (&#97;&#120;&#115;&#64;&#97;&#114;&#98;&#111;&#114;&#110;&#101;&#116;&#46;&#111;&#114;&#103;) 
 * @version 1, May 9, 2003 
 */
function BlackScholes (call_put_flag,S,X,T,r,v) {
    var d1 = ( log(S / X) + (r + (v^2) / 2) * T ) / ( v * (T^0.5) );
    var d2 = d1 - v * (T^0.5);

    if (call_put_flag eq 'c')
        return S * CND(d1) - X * exp( -r * T ) * CND(d2);
    else
        return X * exp( -r * T ) * CND(-d2) - S * CND(-d1);
}

/**
 * Calculate the compound interest after n years.
 * 
 * @param r 	 Interest rate (3% = 0.03). 
 * @param p 	 Principal 
 * @param t 	 Duration of the loan in years. 
 * @return Returns a numeric value. 
 * @author Stephan Scheele (&#115;&#116;&#101;&#112;&#104;&#97;&#110;&#64;&#115;&#116;&#101;&#112;&#104;&#97;&#110;&#45;&#116;&#45;&#115;&#99;&#104;&#101;&#101;&#108;&#101;&#46;&#100;&#101;) 
 * @version 1, April 23, 2002 
 */
function compoundInterest(r, p, t){
  return (p* (1 + r)^t);
}

/**
 * Calculate the actual value of an amount by discounting the interest over n years.
 * 
 * @param p 	 Principal 
 * @param r 	 Interest rate (0.03 = 3%) 
 * @param t 	 Time in years. 
 * @return Returns a numeric value. 
 * @author Stephan Scheele (&#115;&#116;&#101;&#112;&#104;&#97;&#110;&#64;&#115;&#116;&#101;&#112;&#104;&#97;&#110;&#45;&#116;&#45;&#115;&#99;&#104;&#101;&#101;&#108;&#101;&#46;&#100;&#101;) 
 * @version 1.0, April 23, 2002 
 */
function DiscountingInterest(r, p, t){
 return (p / (1 + r)^t);
}

/**
 * Calculate the future value of investment with regular deposits.
 * 
 * @param IT 	 Interest rate per year (8% = 0.08) 
 * @param PMT 	 Number of payments. 
 * @param PV 	 Present value. 
 * @param NP 	 Number of periods. 
 * @return Returns a numeric value. 
 * @author Raymond Thompson (&#114;&#97;&#121;&#116;&#64;&#113;&#115;&#121;&#115;&#116;&#101;&#109;&#115;&#46;&#110;&#101;&#116;) 
 * @version 1, April 23, 2002 
 */
function FutureValue(IR,PMT,PV,NP) {
  var tpv = abs(pv);
  var tnp = abs(np);
  var fv = pv;
  var tpmt = -abs(pmt);
  var tir = abs(ir) / 12;
  var scale=0;

  if(ArrayLen(Arguments) gt 4) {
    scale = 10^abs(Arguments[4]);
  }
  if (ir eq 0) {
    fv = tpv + abs(tpmt * tnp);
  } else {
    q = (1 + tir)^tnp;
    fv = (-pmt + q * pmt + tir * q * tpv) / tir;
  }
  if (scale NEQ 0) {
    fv = int(fv * scale + 0.5) / scale;
  }
  return(-fv);
}

/**
 * Check if a string is a well formed italian Fiscal Code.
 * 
 * @param codFisc 	 Financial code. (Required)
 * @return Returns a boolean. 
 * @author Giampaolo Bellavite (&#103;&#105;&#97;&#109;&#112;&#97;&#111;&#108;&#111;&#64;&#98;&#101;&#108;&#108;&#97;&#118;&#105;&#116;&#101;&#46;&#99;&#111;&#109;) 
 * @version 1, April 12, 2004 
 */
function IsCodFisc(codFisc) {
	return ReFind("^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$", trim(codFisc));
}

/**
 * Calculate payment on loan.
 * 
 * @param IR 	 Interest rate per year (8.5% = 0.085) 
 * @param PV 	 Present Value 
 * @param FV 	 Future Value (Generally zero for calculating payments. Non zero for pay down to ammount.) 
 * @param NP 	 Number of periods. 
 * @return Returns a numeric value. 
 * @author Raymond Thompson (&#114;&#97;&#121;&#116;&#64;&#113;&#115;&#121;&#115;&#116;&#101;&#109;&#115;&#46;&#110;&#101;&#116;) 
 * @version 1, August 2, 2001 
 */
function Payment(IR,PV,FV,NP) {
  var tir = abs(ir) / 12;
  var tfv = abs(fv);
  var tpv = abs(pv);
  var scale = 0;
  var pmt=0;
  var q = (1 + tir)^ abs(np);

  if(ArrayLen(Arguments) gt 4) {
    scale = 10^abs(Arguments[5]);
  }
  pmt = (tir * (tfv + q * tpv)) / (-1 + q);
  if (scale NEQ 0)
    pmt = int(pmt * scale + 0.5) / scale;
  return(-pmt);
}

/**
 * Calculate the number of payments for a loan.
 * 
 * @param IR 	 Interest rate per year (8% = 0.08) 
 * @param PV 	 Present Value 
 * @param FV 	 Future Value 
 * @param PMT 	 Payment Amount 
 * @return Returns a numeric value. 
 * @author Raymond Thompson (&#114;&#97;&#121;&#116;&#64;&#113;&#115;&#121;&#115;&#116;&#101;&#109;&#115;&#46;&#110;&#101;&#116;) 
 * @version 1, August 2, 2001 
 */
function Periods(IR,PV,FV,PMT) {
  var tir = ir / 12;
  var scale = 0;
  var np=0;
  var tpv = -abs(pv);
  var tfv = -abs(fv);
  var tpmt = abs(pmt);

  if(ArrayLen(Arguments) gt 4) {
    scale = 10^abs(Arguments[5]);
  }
  np = log((-tfv * tir + tpmt) / (tpmt + tir * tpv)) / log(1 + tir);
  if (scale NEQ 0)
    np = int(np * scale + 0.5) / scale;
  return(np);
}

/**
 * Translates a Cryptic Futures symbol into a descriptive structure.
 * 
 * @param Future 	 The futures symbol. 
 * @return Returns a structure. 
 * @author Mark Kruger (&#77;&#107;&#114;&#117;&#103;&#101;&#114;&#64;&#99;&#102;&#119;&#101;&#98;&#116;&#111;&#111;&#108;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, January 29, 2002 
 */
function TranslateFuture(Symbol) {
	var	TheYear				=	'';
	var	TheMonth			=	'';
	var SymbolStruct		=	StructNew();
	
	if(Symbol IS NOT '') {
		Symbol				=	replace(Symbol,'0','');
		TheYear				=	'200' &  val(Reverse(Symbol));
		Symbol				=	Replace(symbol,val(reverse(symbol)),'');
		TheMonth			=	right(symbol,1);
		switch(TheMonth)
		{
			case 'F':	{	TheMonth	=	'January';		break;		}
			case 'G':	{	TheMonth	=	'February';		break;		}
			case 'H':	{	TheMonth	=	'March';		break;		}
			case 'J':	{	TheMonth	=	'April';		break;		}
			case 'K':	{	TheMonth	=	'May';			break;		}
			case 'M':	{	TheMonth	=	'June';			break;		}
			case 'N':	{	TheMonth	=	'July';			break;		}
			case 'Q':	{	TheMonth	=	'August';		break;		}
			case 'U':	{	TheMonth	=	'September';	break;		}
			case 'V':	{	TheMonth	=	'October';		break;		}
			case 'X':	{	TheMonth	=	'November';		break;		}
			case 'Z':	{	TheMonth	=	'December';		break;		}				
		}
		
		
		Symbol				=	left(symbol,len(symbol)-1);
		SymbolStruct.Year	=	TheYear;
		SymbolStruct.Root	=	Symbol;
		SymbolStruct.Month	=	TheMonth;
	}
	else {
		SymbolStruct		=	structnew();	
		SymbolStruct.Year	=	'';
		SymbolStruct.Root	=	'';
		SymbolStruct.Month	=	'';
	}
	return(symbolStruct);
}

/**
 * Handles commodity month translation tasks.
 * Removed duplicate My case - rcamden
 * 
 * @param monthcode 	 Month, or month code, to translate. 
 * @return Returns a string. 
 * @author Mark Kruger (&#77;&#107;&#114;&#117;&#103;&#101;&#114;&#64;&#99;&#102;&#119;&#101;&#98;&#116;&#111;&#111;&#108;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1.1, April 11, 2002 
 */
function TranslateFutureMonth(monthcode) {
	var TheMonth =	'';
	switch(Monthcode)
	{
		// Translate the letter code into the month code
		case 'F':	{	TheMonth	=	'January';		break;		}
		case 'G':	{	TheMonth	=	'February';		break;		}
		case 'H':	{	TheMonth	=	'March';		break;		}
		case 'J':	{	TheMonth	=	'April';		break;		}
		case 'K':	{	TheMonth	=	'May';			break;		}
		case 'M':	{	TheMonth	=	'June';			break;		}
		case 'N':	{	TheMonth	=	'July';			break;		}
		case 'Q':	{	TheMonth	=	'August';		break;		}
		case 'U':	{	TheMonth	=	'September';	break;		}
		case 'V':	{	TheMonth	=	'October';		break;		}
		case 'X':	{	TheMonth	=	'November';		break;		}
		case 'Z':	{	TheMonth	=	'December';		break;		}
		// Translate the month description into the letter code
		case 'January':		{	TheMonth	=	'F';	break;		}
		case 'February':	{	TheMonth	=	'G';	break;		}
		case 'March':		{	TheMonth	=	'H';	break;		}
		case 'April':		{	TheMonth	=	'J';	break;		}
		case 'June':		{	TheMonth	=	'M';	break;		}
		case 'July':		{	TheMonth	=	'N';	break;		}
		case 'August':		{	TheMonth	=	'Q';	break;		}
		case 'September':	{	TheMonth	=	'U';	break;		}
		case 'October':		{	TheMonth	=	'V';	break;		}
		case 'November':	{	TheMonth	=	'X';	break;		}
		case 'December':	{	TheMonth	=	'Z';	break;		}
		// Translate 3 letter month code into letter code
		case 'Jan':			{	TheMonth	=	'F';	break;		}
		case 'Feb':			{	TheMonth	=	'G';	break;		}
		case 'Mar':			{	TheMonth	=	'H';	break;		}
		case 'Apr':			{	TheMonth	=	'J';	break;		}
		case 'May':			{	TheMonth	=	'K';	break;		}
		case 'Jun':			{	TheMonth	=	'M';	break;		}
		case 'Jul':			{	TheMonth	=	'N';	break;		}
		case 'Aug':			{	TheMonth	=	'Q';	break;		}
		case 'Sep':			{	TheMonth	=	'U';	break;		}
		case 'Oct':			{	TheMonth	=	'V';	break;		}
		case 'Nov':			{	TheMonth	=	'X';	break;		}
		case 'Dec':			{	TheMonth	=	'Z';	break;		}
	}
	
	return(TheMonth);		
}
</cfscript>
