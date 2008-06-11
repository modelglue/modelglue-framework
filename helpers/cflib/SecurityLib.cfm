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
 * Creates a 40-bit or 128-bit WEP key.
 * 
 * @param length 	 Length of the WEP key. Either 40 or 128 (default). (Optional)
 * @return Returns a string. 
 * @author Alan McCollough (&#97;&#109;&#99;&#99;&#111;&#108;&#108;&#111;&#117;&#103;&#104;&#64;&#97;&#110;&#109;&#99;&#46;&#111;&#114;&#103;) 
 * @version 1, January 12, 2006 
 */
function createWEPKey() {
	var baseKey = "";
	var key = "";
	var defaultLength = 128;
	var length = defaultLength;
	
	/* If user has passed in a specfic key length, and they want a 40-bit key,
	change the value of length to 40 instead of 128.
	Of course, a 40-bit WEP key is trivial to crack, but that is not my problem. */
	if (arrayLen(arguments) eq 1) {
		if(val(arguments[1]) eq 40)
			length = 40;
	}
	
		
	/* 
		CF generated UUIDs look like this:
		73B96C47-F5F1-0F5C-488C7C5170101FA0
		8 chars - 4 chars - 4 chars - 16 chars
		
		First off, generate a base key
	*/
	baseKey = mid(createUUID(),20,16) & mid(createUUID(),15,4) & mid(createUUID(),10,4) & mid(createUUID(),25,2);
	
	/* Create a 40-bit or 128-bit key, as the user requested */
	switch(length) {
		case "40": {
			key = mid(baseKey,10,10);
			break;
		}
		case "128": {
			key = baseKey;
			break;
		}
	} //end switch
	
	return key;
}

/**
 * Generates a password the length you specify.
 * 
 * @param numberOfCharacters 	 Lengh for the generated password. 
 * @return Returns a string. 
 * @author Tony Blackmon (&#102;&#108;&#117;&#105;&#100;&#64;&#115;&#99;&#46;&#114;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, April 25, 2002 
 */
function generatePassword(numberofCharacters) {
  var placeCharacter = "";
  var currentPlace=0;
  var group=0;
  var subGroup=0;

  for(currentPlace=1; currentPlace lte numberofCharacters; currentPlace = currentPlace+1) {
    group = randRange(1,4);
    switch(group) {
      case "1":
        subGroup = rand();
	switch(subGroup) {
          case "0":
            placeCharacter = placeCharacter & chr(randRange(33,46));
            break;
          case "1":
            placeCharacter = placeCharacter & chr(randRange(58,64));
            break;
        }
      case "2":
        placeCharacter = placeCharacter & chr(randRange(97,122));
        break;
      case "3":
        placeCharacter = placeCharacter & chr(randRange(65,90));
        break;
      case "4":
        placeCharacter = placeCharacter & chr(randRange(48,57));
        break;
    }
  }
  return placeCharacter;
}

/**
 * Decryption of the Password for an IPSWITCH IMail-Account (Tested for IMail 6).
 * The algorithm is from http://www.w00w00.org/advisories/imailpass.html.
 * Thanks to Mike Davis who discovered this algorithem.
 * 
 * @param stAccountname  	 iMail account name. (Required)
 * @param stEncryptedPassword 	 iMail encryptes password. (Required)
 * @return Returns a string. 
 * @author Stephan Scheele (&#115;&#116;&#101;&#112;&#104;&#97;&#110;&#64;&#115;&#116;&#101;&#112;&#104;&#97;&#110;&#45;&#116;&#45;&#115;&#99;&#104;&#101;&#101;&#108;&#101;&#46;&#100;&#101;) 
 * @version 1, June 26, 2002 
 */
function iMailPasswordDecryption(stAccountname, stEncryptedPassword){
  /** Building the ASCII-Encryted - Structure */
  var stASCII_Encrypted=structNew();
	/** Build the Account-Array */
  var aAccount=ArrayNew(2);  
	/** Convert every letter to ASCII */
	var stTempAccountname=LCase(stAccountname);  
 	/** Build the Password-Encryped Array */	
	var aPassword=ArrayNew(1);

  var	stTEMPEncryptedPassword=stEncryptedPassword;	
	var aASCIIResult = ArrayNew(1);
	var zaehler=1;  
  var Loop=1;
  var intASCII_difference="";
  var stringPassword="";
  
  StructInsert(stASCII_Encrypted, "00", -97); 
  StructInsert(stASCII_Encrypted, "01", -96); 
  StructInsert(stASCII_Encrypted, "02", -95); 
  StructInsert(stASCII_Encrypted, "03", -94); 
  StructInsert(stASCII_Encrypted, "04", -93); 
  StructInsert(stASCII_Encrypted, "05", -92); 
  StructInsert(stASCII_Encrypted, "06", -91); 
  StructInsert(stASCII_Encrypted, "07", -90); 
  StructInsert(stASCII_Encrypted, "08", -89); 
  StructInsert(stASCII_Encrypted, "09", -88); 
  StructInsert(stASCII_Encrypted, "0A", -87); 
  StructInsert(stASCII_Encrypted, "0B", -86); 
  StructInsert(stASCII_Encrypted, "0C", -85); 
  StructInsert(stASCII_Encrypted, "0D", -84); 
  StructInsert(stASCII_Encrypted, "0E", -83); 
  StructInsert(stASCII_Encrypted, "0F", -82); 
	StructInsert(stASCII_Encrypted, "10", -81); 
  StructInsert(stASCII_Encrypted, "11", -80); 
  StructInsert(stASCII_Encrypted, "12", -79); 
  StructInsert(stASCII_Encrypted, "13", -78); 
  StructInsert(stASCII_Encrypted, "14", -77); 
  StructInsert(stASCII_Encrypted, "15", -76); 
  StructInsert(stASCII_Encrypted, "16", -75); 
  StructInsert(stASCII_Encrypted, "17", -74); 
  StructInsert(stASCII_Encrypted, "18", -73); 
  StructInsert(stASCII_Encrypted, "19", -72); 
  StructInsert(stASCII_Encrypted, "1A", -71); 
  StructInsert(stASCII_Encrypted, "1B", -70); 
  StructInsert(stASCII_Encrypted, "1C", -69); 
  StructInsert(stASCII_Encrypted, "1D", -68); 
  StructInsert(stASCII_Encrypted, "1E", -67); 
  StructInsert(stASCII_Encrypted, "1F", -66); 
	StructInsert(stASCII_Encrypted, "20", -65); 
  StructInsert(stASCII_Encrypted, "21", -64); 
  StructInsert(stASCII_Encrypted, "22", -63); 
  StructInsert(stASCII_Encrypted, "23", -62); 
  StructInsert(stASCII_Encrypted, "24", -61); 
  StructInsert(stASCII_Encrypted, "25", -60); 
  StructInsert(stASCII_Encrypted, "26", -59); 
  StructInsert(stASCII_Encrypted, "27", -58); 
  StructInsert(stASCII_Encrypted, "28", -57); 
  StructInsert(stASCII_Encrypted, "29", -56); 
  StructInsert(stASCII_Encrypted, "2A", -55); 
  StructInsert(stASCII_Encrypted, "2B", -54); 
  StructInsert(stASCII_Encrypted, "2C", -53); 
  StructInsert(stASCII_Encrypted, "2D", -52); 
  StructInsert(stASCII_Encrypted, "2E", -51); 
  StructInsert(stASCII_Encrypted, "2F", -50); 
	StructInsert(stASCII_Encrypted, "30", -49); 
  StructInsert(stASCII_Encrypted, "31", -48); 
  StructInsert(stASCII_Encrypted, "32", -47); 
  StructInsert(stASCII_Encrypted, "33", -46); 
  StructInsert(stASCII_Encrypted, "34", -45); 
  StructInsert(stASCII_Encrypted, "35", -44); 
  StructInsert(stASCII_Encrypted, "36", -43); 
  StructInsert(stASCII_Encrypted, "37", -42); 
  StructInsert(stASCII_Encrypted, "38", -41); 
  StructInsert(stASCII_Encrypted, "39", -40); 
  StructInsert(stASCII_Encrypted, "3A", -39); 
  StructInsert(stASCII_Encrypted, "3B", -38); 
  StructInsert(stASCII_Encrypted, "3C", -37); 
  StructInsert(stASCII_Encrypted, "3D", -36); 
  StructInsert(stASCII_Encrypted, "3E", -35); 
  StructInsert(stASCII_Encrypted, "3F", -34); 
	StructInsert(stASCII_Encrypted, "40", -33); 
  StructInsert(stASCII_Encrypted, "41", -32); 
  StructInsert(stASCII_Encrypted, "42", -31); 
  StructInsert(stASCII_Encrypted, "43", -30); 
  StructInsert(stASCII_Encrypted, "44", -29); 
  StructInsert(stASCII_Encrypted, "45", -28); 
  StructInsert(stASCII_Encrypted, "46", -27); 
  StructInsert(stASCII_Encrypted, "47", -26); 
  StructInsert(stASCII_Encrypted, "48", -25); 
  StructInsert(stASCII_Encrypted, "49", -24); 
  StructInsert(stASCII_Encrypted, "4A", -23); 
  StructInsert(stASCII_Encrypted, "4B", -22); 
  StructInsert(stASCII_Encrypted, "4C", -21); 
  StructInsert(stASCII_Encrypted, "4D", -20); 
  StructInsert(stASCII_Encrypted, "4E", -19); 
  StructInsert(stASCII_Encrypted, "4F", -18); 
	StructInsert(stASCII_Encrypted, "50", -17); 
  StructInsert(stASCII_Encrypted, "51", -16); 
  StructInsert(stASCII_Encrypted, "52", -15); 
  StructInsert(stASCII_Encrypted, "53", -14); 
  StructInsert(stASCII_Encrypted, "54", -13); 
  StructInsert(stASCII_Encrypted, "55", -12); 
  StructInsert(stASCII_Encrypted, "56", -11); 
  StructInsert(stASCII_Encrypted, "57", -10); 
  StructInsert(stASCII_Encrypted, "58", -9); 
  StructInsert(stASCII_Encrypted, "59", -8); 
  StructInsert(stASCII_Encrypted, "5A", -7); 
  StructInsert(stASCII_Encrypted, "5B", -6); 
  StructInsert(stASCII_Encrypted, "5C", -5); 
  StructInsert(stASCII_Encrypted, "5D", -4); 
  StructInsert(stASCII_Encrypted, "5E", -3); 
  StructInsert(stASCII_Encrypted, "5F", -2); 
	StructInsert(stASCII_Encrypted, "60", -1); 
  StructInsert(stASCII_Encrypted, "61", 0); 
  StructInsert(stASCII_Encrypted, "62", 1); 
  StructInsert(stASCII_Encrypted, "63", 2); 
  StructInsert(stASCII_Encrypted, "64", 3); 
  StructInsert(stASCII_Encrypted, "65", 4); 
  StructInsert(stASCII_Encrypted, "66", 5); 
  StructInsert(stASCII_Encrypted, "67", 6); 
  StructInsert(stASCII_Encrypted, "68", 7); 
  StructInsert(stASCII_Encrypted, "69", 8); 
  StructInsert(stASCII_Encrypted, "6A", 9); 
  StructInsert(stASCII_Encrypted, "6B", 10); 
  StructInsert(stASCII_Encrypted, "6C", 11); 
  StructInsert(stASCII_Encrypted, "6D", 12); 
  StructInsert(stASCII_Encrypted, "6E", 13); 
  StructInsert(stASCII_Encrypted, "6F", 14); 
	StructInsert(stASCII_Encrypted, "70", 15); 
  StructInsert(stASCII_Encrypted, "71", 16); 
  StructInsert(stASCII_Encrypted, "72", 17); 
  StructInsert(stASCII_Encrypted, "73", 18); 
  StructInsert(stASCII_Encrypted, "74", 19); 
  StructInsert(stASCII_Encrypted, "75", 20); 
  StructInsert(stASCII_Encrypted, "76", 21); 
  StructInsert(stASCII_Encrypted, "77", 22); 
  StructInsert(stASCII_Encrypted, "78", 23); 
  StructInsert(stASCII_Encrypted, "79", 24); 
  StructInsert(stASCII_Encrypted, "7A", 25); 
  StructInsert(stASCII_Encrypted, "7B", 26); 
  StructInsert(stASCII_Encrypted, "7C", 27); 
  StructInsert(stASCII_Encrypted, "7D", 28); 
  StructInsert(stASCII_Encrypted, "7E", 29); 
  StructInsert(stASCII_Encrypted, "7F", 30); 
	StructInsert(stASCII_Encrypted, "80", 31); 
  StructInsert(stASCII_Encrypted, "81", 32); 
  StructInsert(stASCII_Encrypted, "82", 33); 
  StructInsert(stASCII_Encrypted, "83", 34); 
  StructInsert(stASCII_Encrypted, "84", 35); 
  StructInsert(stASCII_Encrypted, "85", 36); 
  StructInsert(stASCII_Encrypted, "86", 37); 
  StructInsert(stASCII_Encrypted, "87", 38); 
  StructInsert(stASCII_Encrypted, "88", 39); 
  StructInsert(stASCII_Encrypted, "89", 40); 
  StructInsert(stASCII_Encrypted, "8A", 41); 
  StructInsert(stASCII_Encrypted, "8B", 42); 
  StructInsert(stASCII_Encrypted, "8C", 43); 
  StructInsert(stASCII_Encrypted, "8D", 44); 
  StructInsert(stASCII_Encrypted, "8E", 45); 
  StructInsert(stASCII_Encrypted, "8F", 46); 
	StructInsert(stASCII_Encrypted, "90", 47); 
  StructInsert(stASCII_Encrypted, "91", 48); 
  StructInsert(stASCII_Encrypted, "92", 49); 
  StructInsert(stASCII_Encrypted, "93", 50); 
  StructInsert(stASCII_Encrypted, "94", 51); 
  StructInsert(stASCII_Encrypted, "95", 52); 
  StructInsert(stASCII_Encrypted, "96", 53); 
  StructInsert(stASCII_Encrypted, "97", 54); 
  StructInsert(stASCII_Encrypted, "98", 55); 
  StructInsert(stASCII_Encrypted, "99", 56); 
  StructInsert(stASCII_Encrypted, "9A", 57); 
  StructInsert(stASCII_Encrypted, "9B", 58); 
  StructInsert(stASCII_Encrypted, "9C", 59); 
  StructInsert(stASCII_Encrypted, "9D", 60); 
  StructInsert(stASCII_Encrypted, "9E", 61); 
  StructInsert(stASCII_Encrypted, "9F", 62); 
	StructInsert(stASCII_Encrypted, "A0", 63); 
  StructInsert(stASCII_Encrypted, "A1", 64); 
  StructInsert(stASCII_Encrypted, "A2", 65); 
  StructInsert(stASCII_Encrypted, "A3", 66); 
  StructInsert(stASCII_Encrypted, "A4", 67); 
  StructInsert(stASCII_Encrypted, "A5", 68); 
  StructInsert(stASCII_Encrypted, "A6", 69); 
  StructInsert(stASCII_Encrypted, "A7", 70); 
  StructInsert(stASCII_Encrypted, "A8", 71); 
  StructInsert(stASCII_Encrypted, "A9", 72); 
  StructInsert(stASCII_Encrypted, "AA", 73); 
  StructInsert(stASCII_Encrypted, "AB", 74); 
  StructInsert(stASCII_Encrypted, "AC", 75); 
  StructInsert(stASCII_Encrypted, "AD", 76); 
  StructInsert(stASCII_Encrypted, "AE", 77); 
  StructInsert(stASCII_Encrypted, "AF", 78); 
	StructInsert(stASCII_Encrypted, "B0", 79); 
  StructInsert(stASCII_Encrypted, "B1", 80); 
  StructInsert(stASCII_Encrypted, "B2", 81); 
  StructInsert(stASCII_Encrypted, "B3", 82); 
  StructInsert(stASCII_Encrypted, "B4", 83); 
  StructInsert(stASCII_Encrypted, "B5", 84); 
  StructInsert(stASCII_Encrypted, "B6", 85); 
  StructInsert(stASCII_Encrypted, "B7", 86); 
  StructInsert(stASCII_Encrypted, "B8", 87); 
  StructInsert(stASCII_Encrypted, "B9", 88); 
  StructInsert(stASCII_Encrypted, "BA", 89); 
  StructInsert(stASCII_Encrypted, "BB", 90); 
  StructInsert(stASCII_Encrypted, "BC", 91); 
  StructInsert(stASCII_Encrypted, "BD", 92); 
  StructInsert(stASCII_Encrypted, "BE", 93); 
  StructInsert(stASCII_Encrypted, "BF", 94); 
	StructInsert(stASCII_Encrypted, "C0", 95); 
  StructInsert(stASCII_Encrypted, "C1", 96); 
  StructInsert(stASCII_Encrypted, "C2", 97); 
  StructInsert(stASCII_Encrypted, "C3", 98); 
  StructInsert(stASCII_Encrypted, "C4", 99); 
  StructInsert(stASCII_Encrypted, "C5", 100);
  StructInsert(stASCII_Encrypted, "C6", 101); 
  StructInsert(stASCII_Encrypted, "C7", 102); 
  StructInsert(stASCII_Encrypted, "C8", 103); 
  StructInsert(stASCII_Encrypted, "C9", 104); 
  StructInsert(stASCII_Encrypted, "CA", 105); 
  StructInsert(stASCII_Encrypted, "CB", 106); 
  StructInsert(stASCII_Encrypted, "CC", 107); 
  StructInsert(stASCII_Encrypted, "CD", 108);   
  StructInsert(stASCII_Encrypted, "CE", 109); 
  StructInsert(stASCII_Encrypted, "CF", 110); 
	StructInsert(stASCII_Encrypted, "D0", 111); 
  StructInsert(stASCII_Encrypted, "D1", 112); 
  StructInsert(stASCII_Encrypted, "D2", 113); 
  StructInsert(stASCII_Encrypted, "D3", 114); 
  StructInsert(stASCII_Encrypted, "D4", 115); 
  StructInsert(stASCII_Encrypted, "D5", 116); 
  StructInsert(stASCII_Encrypted, "D6", 117); 
  StructInsert(stASCII_Encrypted, "D7", 118); 
  StructInsert(stASCII_Encrypted, "D8", 119); 
  StructInsert(stASCII_Encrypted, "D9", 120); 
  StructInsert(stASCII_Encrypted, "DA", 121); 
  StructInsert(stASCII_Encrypted, "DB", 122); 
  StructInsert(stASCII_Encrypted, "DC", 123); 
  StructInsert(stASCII_Encrypted, "DD", 124); 
  StructInsert(stASCII_Encrypted, "DE", 125); 
  StructInsert(stASCII_Encrypted, "DF", 126); 
	StructInsert(stASCII_Encrypted, "E0", 127); 
  StructInsert(stASCII_Encrypted, "E1", 128); 
  StructInsert(stASCII_Encrypted, "E2", 129); 
  StructInsert(stASCII_Encrypted, "E3", 130); 
  StructInsert(stASCII_Encrypted, "E4", 131); 
  StructInsert(stASCII_Encrypted, "E5", 132); 
  StructInsert(stASCII_Encrypted, "E6", 133); 
  StructInsert(stASCII_Encrypted, "E7", 134); 
  StructInsert(stASCII_Encrypted, "E8", 135); 
  StructInsert(stASCII_Encrypted, "E9", 136); 
  StructInsert(stASCII_Encrypted, "EA", 137); 
  StructInsert(stASCII_Encrypted, "EB", 138); 
  StructInsert(stASCII_Encrypted, "EC", 139); 
  StructInsert(stASCII_Encrypted, "ED", 140); 
  StructInsert(stASCII_Encrypted, "EE", 141); 
  StructInsert(stASCII_Encrypted, "EF", 142); 
	StructInsert(stASCII_Encrypted, "F0", 143); 
  StructInsert(stASCII_Encrypted, "F1", 144); 
  StructInsert(stASCII_Encrypted, "F2", 145);
  StructInsert(stASCII_Encrypted, "F3", 146); 
  StructInsert(stASCII_Encrypted, "F4", 147); 
  StructInsert(stASCII_Encrypted, "F5", 148); 
  StructInsert(stASCII_Encrypted, "F6", 149); 
  StructInsert(stASCII_Encrypted, "F7", 150); 
  StructInsert(stASCII_Encrypted, "F8", 151); 
  StructInsert(stASCII_Encrypted, "F9", 152); 
  StructInsert(stASCII_Encrypted, "FA", 153); 
  StructInsert(stASCII_Encrypted, "FB", 154); 
  StructInsert(stASCII_Encrypted, "FC", 155); 
  StructInsert(stASCII_Encrypted, "FD", 156); 
  StructInsert(stASCII_Encrypted, "FE", 157); 
  StructInsert(stASCII_Encrypted, "FF", 158); 
			
	for(Loop=1; Loop LT val((Len(stAccountname)+1)); Loop = Loop + 1){
		aAccount[1][Loop]=Asc(Left(stTempAccountname, 1));
		stTempAccountname=RemoveChars(stTempAccountname, 1, 1);
	}
			
  /** Calculate differences between the each letter and the first letter */
	for(Loop=1; Loop LT val((Len(stAccountname)+1)); Loop = Loop + 1){
		aAccount[2][Loop]=aAccount[1][1]-aAccount[1][Loop];
	}
		
	/** Calculate differences between the ASCII-value of the first letter and ASCII-value of a*/
	intASCII_difference= aAccount[1][1] - 97;
		
	/** Convert every letter to ASCII */
	for(Loop=1; Loop LT val((Len(stEncryptedPassword)/2)+1); Loop = Loop + 1){
		aPassword[Loop]=stASCII_Encrypted[Left(stTEMPEncryptedPassword, 2)];
		stTEMPEncryptedPassword=RemoveChars(stTEMPEncryptedPassword, 1, 2);
	}
	
  /** Add Differences to password-ASCII-Values AND take off intASCII_difference*/  
	for(Loop=1; Loop LT val((Len(stEncryptedPassword)/2)+1); Loop = Loop + 1){
	  aASCIIResult[Loop] = aPassword[Loop] + aAccount[2][zaehler] - intASCII_difference;
			
		/** If the AccountName is shorter then the Password the Account_Counter is put to 1 again			*/
		if (zaehler LT Val(Len(stAccountname))) zaehler = zaehler + 1;
	  	else zaehler = 1;
		}
	
	  /** Write the Passwort*/
		stringPassword="";
	
		for(Loop=1; Loop LT val((Len(stEncryptedPassword)/2)+1); Loop = Loop + 1){
		  stringPassword = stringPassword & CHR(aASCIIResult[Loop]);
		}
		
  return stringPassword;
}

/**
 * Returns true if user is authenticated.
 * 
 * @return Returns a boolean. 
 * @author Raymond Camden (&#114;&#97;&#121;&#64;&#99;&#97;&#109;&#100;&#101;&#110;&#102;&#97;&#109;&#105;&#108;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, April 29, 2002 
 */
function IsLoggedIn() {
	return getAuthUser() neq "";
}

/**
 * Checks if the URL (maybe a key) was manipulated or if the form was copied and changed.
 * 
 * @return Returns a boolean. 
 * @author Stephan Scheele (&#115;&#116;&#101;&#112;&#104;&#97;&#110;&#64;&#115;&#116;&#101;&#112;&#104;&#97;&#110;&#45;&#116;&#45;&#115;&#99;&#104;&#101;&#101;&#108;&#101;&#46;&#100;&#101;) 
 * @version 1, July 2, 2002 
 */
function isManipulated(){
	if (CGI.HTTP_REFERER eq "") return true;
	else if (REReplaceNoCase(REReplaceNoCase(CGI.HTTP_REFERER, ".*//", "","all"), "/.*", "","all")  neq CGI.HTTP_HOST) return true;
	else return false;
}

/**
 * Checks to see if the current page is being run on a secure server.
 * 
 * @param localServers 	 If the current server matches one of the servers in this list, the UDF will return true. Defaults to an empty string. (Optional)
 * @return Returns a boolean. 
 * @author Mike Hughes (&#109;&#105;&#107;&#101;&#64;&#103;&#110;&#101;&#45;&#119;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, February 17, 2004 
 */
function IsSecureSite() {
	if(arrayLen(arguments)) localServers = arguments[1]; 
	if(cgi.server_port_secure OR listFindNoCase(localServers, cgi.server_name)) return true;
	else return false;
}

/**
 * Generates an 8-character random password free of annoying similar-looking characters such as 1 or l.
 * 
 * @return Returns a string. 
 * @author Alan McCollough (&#97;&#109;&#99;&#99;&#111;&#108;&#108;&#111;&#117;&#103;&#104;&#64;&#97;&#110;&#109;&#99;&#46;&#111;&#114;&#103;) 
 * @version 1, December 18, 2001 
 */
function MakePassword()
{      
  var valid_password = 0;
  var loopindex = 0;
  var this_char = "";
  var seed = "";
  var new_password = "";
  var new_password_seed = "";
  while (valid_password eq 0){
    new_password = "";
    new_password_seed = CreateUUID();
    for(loopindex=20; loopindex LT 35; loopindex = loopindex + 2){
      this_char = inputbasen(mid(new_password_seed, loopindex,2),16);
      seed = int(inputbasen(mid(new_password_seed,loopindex/2-9,1),16) mod 3)+1;
      switch(seed){
        case "1": {
          new_password = new_password & chr(int((this_char mod 9) + 48));
          break;
        }
	case "2": {
          new_password = new_password & chr(int((this_char mod 26) + 65));
          break;
        }
        case "3": {
          new_password = new_password & chr(int((this_char mod 26) + 97));
          break;
        }
      } //end switch
    }
    valid_password = iif(refind("(O|o|0|i|l|1|I|5|S)",new_password) gt 0,0,1);	
  }
  return new_password;
}

/**
 * Produces a 128-bit condensed representation (message digest) of a message using the RSA MD5 algorithm.
 * Original custom tag code by Tim McCarthy (&#116;&#105;&#109;&#64;&#116;&#105;&#109;&#109;&#99;&#99;&#46;&#99;&#111;&#109;) - 2/2001
 * 
 * @param message 	 Text you want to hash. 
 * @return Returns a string. 
 * @author Rob Brooks-Bilson (&#116;&#105;&#109;&#64;&#116;&#105;&#109;&#109;&#99;&#99;&#46;&#99;&#111;&#109;&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, November 29, 2001 
 */
function MD5(message)
{
  Var hex_msg = "";
  Var hex_msg_len = 0;  
  Var padded_hex_msg = "";
  Var temp = "";  
  Var var1 = ArrayNew(1);
  Var f = 0;
  Var h = ArrayNew(1);
  Var i = 0;
  Var j = 0;
  Var k = ArrayNew(1);
  Var m = ArrayNew(1);
  Var n = 0;
  Var s = ArrayNew(1);  
  Var t = ArrayNew(1);
  // convert the msg to ASCII binary-coded form
  for (i=1; i LTE Len(message); i=i+1) {  
	  hex_msg = hex_msg & Right("0"&FormatBaseN(Asc(Mid(message,i,1)),16),2);
  }    

  // compute the msg length in bits
  hex_msg_len = Right(RepeatString("0",15)&FormatBaseN(8*Len(message),16),16);
  for (i=1; i LTE 8; i=i+1) {
	  temp = temp & Mid(hex_msg_len,-2*(i-8)+1,2);
  }
  hex_msg_len = temp;

  // pad the msg to make it a multiple of 512 bits long
  padded_hex_msg = hex_msg & "80" & RepeatString("0",128-((Len(hex_msg)+2+16) Mod 128)) & hex_msg_len;

  // initialize MD buffer
  h[1] = InputBaseN("0x67452301",16);
  h[2] = InputBaseN("0xefcdab89",16);
  h[3] = InputBaseN("0x98badcfe",16);
  h[4] = InputBaseN("0x10325476",16);

  var1[1] = "a";
  var1[2] = "b";
  var1[3] = "c";
  var1[4] = "d";
  // look at my crazy nested if action - courtesy of no elseif statement!
  for (i=1; i LTE 64; i=i+1) {
	  t[i] = Int(2^32*abs(sin(i)));
	  if (i LE 16){
		  if (i EQ 1){
			  k[i] = 0;
      }
      else {
        k[i] = k[i-1] + 1;
      }
		  s[i] = 5*((i-1) MOD 4) + 7;
	  }
    else {
      if (i LE 32) {
        if (i EQ 17) {
			    k[i] = 1;
        }
        else {
          k[i] = (k[i-1]+5) MOD 16;
        }
		  s[i] = 0.5*((i-1) MOD 4)*((i-1) MOD 4) + 3.5*((i-1) MOD 4) + 5;
      }
	    else {
        if(i LE 48) {
          if (i EQ 33) {
			      k[i] = 5;
          }
          else {
            k[i] = (k[i-1]+3) MOD 16;
          }
		     s[i] = 6*((i-1) MOD 4) + ((i-1) MOD 2) + 4;
	      }
        else {
          if (i EQ 49) {
            k[i] = 0;
          }
          else {
			      k[i] = (k[i-1]+7) MOD 16;
          }
		      s[i] = 0.5*((i-1) MOD 4)*((i-1) MOD 4) + 3.5*((i-1) MOD 4) + 6;
	      }
      }
    }
  }

  // process the msg 512 bits at a time
  for (n=1; n LTE Evaluate(Len(padded_hex_msg)/128); n=n+1) { 
	  a = h[1];
	  b = h[2];
	  c = h[3];
	  d = h[4];
	
	  msg_block = Mid(padded_hex_msg,128*(n-1)+1,128);

    for (i=1; i LTE 16; i=i+1) {  
	  	sub_block = "";
      for (j=1; j LTE 4; j=j+1) {  
  		  sub_block = sub_block & Mid(msg_block,8*i-2*j+1,2);
	  	}
  		m[i] = InputBaseN(sub_block,16);
	  }

    for (i=1; i LTE 64; i=i+1) {  	
	    if (i LE 16) {
		  	f = BitOr(BitAnd(Evaluate(var1[2]),Evaluate(var1[3])),BitAnd(BitNot(Evaluate(var1[2])),Evaluate(var1[4])));
  		}
      else {
        if (i LE 32) {
          f = BitOr(BitAnd(Evaluate(var1[2]),Evaluate(var1[4])),BitAnd(Evaluate(var1[3]),BitNot(Evaluate(var1[4]))));
        }
        else {
          if (i LE 48) {
            f = BitXor(BitXor(Evaluate(var1[2]),Evaluate(var1[3])),Evaluate(var1[4]));
          }
  		    else {
            f = BitXor(Evaluate(var1[3]),BitOr(Evaluate(var1[2]),BitNot(Evaluate(var1[4]))));
          }
		    }
      }
  		temp = Evaluate(var1[1]) + f + m[k[i]+1] + t[i];
	  	while ((temp LT -2^31) OR (temp GE 2^31)) {
        temp = temp - Sgn(temp)*2^32;
  		}
	  	temp = Evaluate(var1[2]) + BitOr(BitSHLN(temp,s[i]),BitSHRN(temp,32-s[i]));
      while ((temp LT -2^31) OR (temp GE 2^31)) {
  			temp = temp - Sgn(temp)*2^32;
      }
  		temp = SetVariable(var1[1],temp);
	  	temp = var1[4];
  		var1[4] = var1[3];
	  	var1[3] = var1[2];
		  var1[2] = var1[1];
  		var1[1] = temp;
 	  }
	
	  h[1] = h[1] + a;
   	h[2] = h[2] + b;
  	h[3] = h[3] + c;
	  h[4] = h[4] + d;
 	
    for (i=1; i LTE 4; i=i+1) { 
      while ((h[i] LT -2^31) OR (h[i] GE 2^31)) {
  			h[i] = h[i] - Sgn(h[i])*2^32;
	  	}
  	}
  }

  for (i=1; i LTE 4; i=i+1) { 
	  h[i] = Right(RepeatString("0",7)&UCase(FormatBaseN(h[i],16)),8);
  }

  for (i=1; i LTE 4; i=i+1) {   
	  temp = "";
    for (j=1; j LTE 4; j=j+1) { 
		  temp = temp & Mid(h[i],-2*(j-4)+1,2);
	  }
	  h[i] = temp;
  }
  Return h[1] & h[2] & h[3] & h[4];
}

/**
 * A function does RC4 encryption by using a key and the string.
 * Original source: http://www.4guysfromrolla.com/webtech/010100-1.shtml
 * 
 * @param strPwd 	 The key to use for encryption. (Required)
 * @param plaintxt 	 Text to encrypt. (Required)
 * @return Returns a string. 
 * @author Michael Krock (&#109;&#105;&#99;&#104;&#97;&#101;&#108;&#46;&#107;&#114;&#111;&#99;&#107;&#64;&#97;&#118;&#118;&#46;&#99;&#111;&#109;) 
 * @version 1, January 12, 2006 
 */
function RC4(strPwd,plaintxt) {
	var sbox = ArrayNew(1);
	var key = ArrayNew(1);
	var tempSwap = 0;
	var a = 0;
	var b = 0;
	var intLength = len(strPwd);
	var temp = 0;
	var i = 0;
	var j = 0;
	var k = 0;
	var cipherby = 0;
	var cipher = "";
	
	for(a=0; a lte 255; a=a+1) {	
		key[a + 1] = asc(mid(strPwd,(a MOD intLength)+1,1));
		sbox[a + 1] = a;
	}

	for(a=0; a lte 255; a=a+1) {	
		b = (b + sbox[a + 1] + key[a + 1]) Mod 256;		
		tempSwap = sbox[a + 1];
		sbox[a + 1] = sbox[b + 1];
		sbox[b + 1] = tempSwap;    
	}

	for(a=1; a lte len(plaintxt); a=a+1) {	
		i = (i + 1) mod 256;
		j = (j + sbox[i + 1]) Mod 256;		
		temp = sbox[i + 1];
		sbox[i + 1] = sbox[j + 1];
		sbox[j + 1] = temp;
		k = sbox[((sbox[i + 1] + sbox[j + 1]) mod 256) + 1];		
		cipherby = BitXor(asc(mid(plaintxt, a, 1)), k);
		cipher = cipher & chr(cipherby);  		
	}
	return cipher;
}

/**
 * Produces a 160-bit condensed representation (message digest) of a message using the RIPEMD-160 algorithm.
 * Original custom tag code by Tim McCarthy (&#116;&#105;&#109;&#64;&#116;&#105;&#109;&#109;&#99;&#99;&#46;&#99;&#111;&#109;) - 2/2001
 * 
 * @param message 	 Text you want to hash. 
 * @return Returns a string. 
 * @author Rob Brooks-Bilson (&#116;&#105;&#109;&#64;&#116;&#105;&#109;&#109;&#99;&#99;&#46;&#99;&#111;&#109;&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, November 29, 2001 
 */
function Ripemd160(message)
{
  Var hex_msg = "";
  Var hex_msg_len = 0;
  Var padded_hex_msg = "";
  Var msg_block = "";
  Var sub_block = "";
  Var num = 0;
  Var temp = "";
  Var rho = ArrayNew(1);
  Var pi = ArrayNew(1);
  Var shift = ArrayNew(2);
  Var a1 = 0;
  Var a2 = 0;
  Var b1 = 0;
  Var b2 = 0;
  Var c1 = 0;
  Var c2 = 0;
  Var d1 = 0;
  Var d2 = 0;
  Var e1 = 0;
  Var e2 = 0;    
  Var f1 = 0;
  Var f2 = 0;  
  Var k1 = ArrayNew(1);
  Var k2 = ArrayNew(1);
  Var r1 = ArrayNew(1);
  Var r2 = ArrayNew(1);
  Var s1 = ArrayNew(1);
  Var s2 = ArrayNew(1);
  Var var1 = ArrayNew(1);
  Var var2 = ArrayNew(1);
  Var h = ArrayNew(1);
  Var i = 0;
  Var j = 0;
  Var n = 0;
  Var t = 0;
  Var x = ArrayNew(1);
    
  // convert the msg to ASCII binary-coded form
  for (i=1; i LTE Len(message); i=i+1) {  
	  hex_msg = hex_msg & Right("0"&FormatBaseN(Asc(Mid(message,i,1)),16),2);
  }

  // compute the msg length in bits
  hex_msg_len = Right(RepeatString("0",15)&FormatBaseN(8*Len(message),16),16);
  for (i=1; i LTE 8; i=i+1) {
	  temp = temp & Mid(hex_msg_len,-2*(i-8)+1,2);
  }
  hex_msg_len = temp;

  // pad the msg to make it a multiple of 512 bits long
  padded_hex_msg = hex_msg & "80" & RepeatString("0",128-((Len(hex_msg)+2+16) Mod 128)) & hex_msg_len;

  // define permutations
  rho[1] = 7;
  rho[2] = 4;
  rho[3] = 13;
  rho[4] = 1;
  rho[5] = 10;
  rho[6] = 6;
  rho[7] = 15;
  rho[8] = 3;
  rho[9] = 12;
  rho[10] = 0;
  rho[11] = 9;
  rho[12] = 5;
  rho[13] = 2;
  rho[14] = 14;
  rho[15] = 11;
  rho[16] = 8;

  for (i=1; i LTE 16; i=i+1) {
    pi[i] = (9*(i-1)+5) Mod 16;
  }

  // define shifts
  shift[1][1] = 11;
  shift[1][2] = 14;
  shift[1][3] = 15;
  shift[1][4] = 12;
  shift[1][5] = 5;
  shift[1][6] = 8;
  shift[1][7] = 7;
  shift[1][8] = 9;
  shift[1][9] = 11;
  shift[1][10] = 13;
  shift[1][11] = 14;
  shift[1][12] = 15;
  shift[1][13] = 6;
  shift[1][14] = 7;
  shift[1][15] = 9;
  shift[1][16] = 8;
  shift[2][1] = 12;
  shift[2][2] = 13;
  shift[2][3] = 11;
  shift[2][4] = 15;
  shift[2][5] = 6;
  shift[2][6] = 9;
  shift[2][7] = 9;
  shift[2][8] = 7;
  shift[2][9] = 12;
  shift[2][10] = 15;
  shift[2][11] = 11;
  shift[2][12] = 13;
  shift[2][13] = 7;
  shift[2][14] = 8;
  shift[2][15] = 7;
  shift[2][16] = 7;
  shift[3][1] = 13;
  shift[3][2] = 15;
  shift[3][3] = 14;
  shift[3][4] = 11;
  shift[3][5] = 7;
  shift[3][6] = 7;
  shift[3][7] = 6;
  shift[3][8] = 8;
  shift[3][9] = 13;
  shift[3][10] = 14;
  shift[3][11] = 13;
  shift[3][12] = 12;
  shift[3][13] = 5;
  shift[3][14] = 5;
  shift[3][15] = 6;
  shift[3][16] = 9;
  shift[4][1] = 14;
  shift[4][2] = 11;
  shift[4][3] = 12;
  shift[4][4] = 14;
  shift[4][5] = 8;
  shift[4][6] = 6;
  shift[4][7] = 5;
  shift[4][8] = 5;
  shift[4][9] = 15;
  shift[4][10] = 12;
  shift[4][11] = 15;
  shift[4][12] = 14;
  shift[4][13] = 9;
  shift[4][14] = 9;
  shift[4][15] = 8;
  shift[4][16] = 6;
  shift[5][1] = 15;
  shift[5][2] = 12;
  shift[5][3] = 13;
  shift[5][4] = 13;
  shift[5][5] = 9;
  shift[5][6] = 5;
  shift[5][7] = 8;
  shift[5][8] = 6;
  shift[5][9] = 14;
  shift[5][10] = 11;
  shift[5][11] = 12;
  shift[5][12] = 11;
  shift[5][13] = 8;
  shift[5][14] = 6;
  shift[5][15] = 5;
  shift[5][16] = 5;

  for (i=1; i LTE 16; i=i+1) {
	  // define constants
  	k1[i] = 0;
  	k1[i+16] = Int(2^30*Sqr(2));
  	k1[i+32] = Int(2^30*Sqr(3));
  	k1[i+48] = Int(2^30*Sqr(5));
  	k1[i+64] = Int(2^30*Sqr(7));
  	
  	k2[i] = Int(2^30*2^(1/3));
  	k2[i+16] = Int(2^30*3^(1/3));
  	k2[i+32] = Int(2^30*5^(1/3));
  	k2[i+48] = Int(2^30*7^(1/3));
  	k2[i+64] = 0;
  	
  	// define word order
  	r1[i] = i-1;
  	r1[i+16] = rho[i];
  	r1[i+32] = rho[rho[i]+1];
  	r1[i+48] = rho[rho[rho[i]+1]+1];
  	r1[i+64] = rho[rho[rho[rho[i]+1]+1]+1];
  	
  	r2[i] = pi[i];
  	r2[i+16] = rho[pi[i]+1];
  	r2[i+32] = rho[rho[pi[i]+1]+1];
  	r2[i+48] = rho[rho[rho[pi[i]+1]+1]+1];
  	r2[i+64] = rho[rho[rho[rho[pi[i]+1]+1]+1]+1];
  	
  	// define rotations
  	s1[i] = shift[1][r1[i]+1];
  	s1[i+16] = shift[2][r1[i+16]+1];
  	s1[i+32] = shift[3][r1[i+32]+1];
  	s1[i+48] = shift[4][r1[i+48]+1];
  	s1[i+64] = shift[5][r1[i+64]+1];
  	
  	s2[i] = shift[1][r2[i]+1];
  	s2[i+16] = shift[2][r2[i+16]+1];
  	s2[i+32] = shift[3][r2[i+32]+1];
  	s2[i+48] = shift[4][r2[i+48]+1];
  	s2[i+64] = shift[5][r2[i+64]+1];
  }	

  // define buffers
  h[1] = InputBaseN("0x67452301",16);
  h[2] = InputBaseN("0xefcdab89",16);
  h[3] = InputBaseN("0x98badcfe",16);
  h[4] = InputBaseN("0x10325476",16);
  h[5] = InputBaseN("0xc3d2e1f0",16);
  
  var1[1] = "a1";
  var1[2] = "b1";
  var1[3] = "c1";
  var1[4] = "d1";
  var1[5] = "e1";
  
  var2[1] = "a2";
  var2[2] = "b2";
  var2[3] = "c2";
  var2[4] = "d2";
  var2[5] = "e2";

  // process msg in 16-word blocks
  for (n=1; n LTE Evaluate(Len(padded_hex_msg)/128); n=n+1) {
  	a1 = h[1];
  	b1 = h[2];
  	c1 = h[3];
  	d1 = h[4];
  	e1 = h[5];
	
  	a2 = h[1];
  	b2 = h[2];
  	c2 = h[3];
  	d2 = h[4];
  	e2 = h[5];
	
	  msg_block = Mid(padded_hex_msg,128*(n-1)+1,128);
    for (i=1; i LTE 16; i=i+1) {
  		sub_block = "";
      for (j=1; j LTE 4; j=j+1) {
  			sub_block = sub_block & Mid(msg_block,8*i-2*j+1,2);
  		}
  		x[i] = InputBaseN(sub_block,16);
  	}
  	
    for (j=1; j LTE 80; j=j+1) {
  		// nonlinear functions
      if (j LE 16) {
  			f1 = BitXor(BitXor(Evaluate(var1[2]),Evaluate(var1[3])),Evaluate(var1[4]));
  			f2 = BitXor(Evaluate(var2[2]),BitOr(Evaluate(var2[3]),BitNot(Evaluate(var2[4]))));
      }
      else {
        if (j LE 32) {
  			  f1 = BitOr(BitAnd(Evaluate(var1[2]),Evaluate(var1[3])),BitAnd(BitNot(Evaluate(var1[2])),Evaluate(var1[4])));
  			  f2 = BitOr(BitAnd(Evaluate(var2[2]),Evaluate(var2[4])),BitAnd(Evaluate(var2[3]),BitNot(Evaluate(var2[4]))));
        }  
        else {
          if (j LE 48) {
  			    f1 = BitXor(BitOr(Evaluate(var1[2]),BitNot(Evaluate(var1[3]))),Evaluate(var1[4]));
  			    f2 = BitXor(BitOr(Evaluate(var2[2]),BitNot(Evaluate(var2[3]))),Evaluate(var2[4]));
          }
          else {
            if (j LE 64) {
              f1 = BitOr(BitAnd(Evaluate(var1[2]),Evaluate(var1[4])),BitAnd(Evaluate(var1[3]),BitNot(Evaluate(var1[4]))));
    			    f2 = BitOr(BitAnd(Evaluate(var2[2]),Evaluate(var2[3])),BitAnd(BitNot(Evaluate(var2[2])),Evaluate(var2[4])));
            }
  	    	  else {
              f1 = BitXor(Evaluate(var1[2]),BitOr(Evaluate(var1[3]),BitNot(Evaluate(var1[4]))));
      			  f2 = BitXor(BitXor(Evaluate(var2[2]),Evaluate(var2[3])),Evaluate(var2[4]));
            }
          }
        }
  		}
  		
  		temp = Evaluate(var1[1]) + f1 + x[r1[j]+1] + k1[j];
      while ((temp LT -2^31) OR (temp GE 2^31)) {
  			temp = temp - Sgn(temp)*2^32;
  		}
  		temp = BitOr(BitSHLN(temp,s1[j]),BitSHRN(temp,32-s1[j])) + Evaluate(var1[5]);
      while ((temp LT -2^31) OR (temp GE 2^31)) {
  			temp = temp - Sgn(temp)*2^32;
  		}
  		temp = SetVariable(var1[1],temp);
  		temp = SetVariable(var1[3],BitOr(BitSHLN(Evaluate(var1[3]),10),BitSHRN(Evaluate(var1[3]),32-10)));
  		
  		temp = var1[5];
  		var1[5] = var1[4];
  		var1[4] = var1[3];
  		var1[3] = var1[2];
  		var1[2] = var1[1];
  		var1[1] = temp;
  		
  		temp = Evaluate(var2[1]) + f2 + x[r2[j]+1] + k2[j];
      while ((temp LT -2^31) OR (temp GE 2^31)) {
  			temp = temp - Sgn(temp)*2^32;
  		}
  		temp = BitOr(BitSHLN(temp,s2[j]),BitSHRN(temp,32-s2[j])) + Evaluate(var2[5]);
      while ((temp LT -2^31) OR (temp GE 2^31)) {
  			temp = temp - Sgn(temp)*2^32;
  		}
  		temp = SetVariable(var2[1],temp);
  		temp = SetVariable(var2[3],BitOr(BitSHLN(Evaluate(var2[3]),10),BitSHRN(Evaluate(var2[3]),32-10)));
  		
  		temp = var2[5];
  		var2[5] = var2[4];
  		var2[4] = var2[3];
  		var2[3] = var2[2];
  		var2[2] = var2[1];
  		var2[1] = temp;
	  }
	
  t = h[2] + c1 + d2;
  h[2] = h[3] + d1 + e2;
  h[3] = h[4] + e1 + a2;
  h[4] = h[5] + a1 + b2;
  h[5] = h[1] + b1 + c2;
  h[1] = t;
	
  for (i=1; i LTE 5; i=i+1) {
    while ((h[i] LT -2^31) OR (h[i] GE 2^31)) {
      h[i] = h[i] - Sgn(h[i])*2^32;
		}
	}
	
  }
  for (i=1; i LTE 5; i=i+1) {
	  h[i] = Right(RepeatString("0",7)&UCase(FormatBaseN(h[i],16)),8);
  }

  for (i=1; i LTE 5; i=i+1) {
  	temp = "";
    for (j=1; j LTE 4; j=j+1) {
  		temp = temp & Mid(h[i],-2*(j-4)+1,2);
	  }
	  h[i] = temp;
  }

  Return h[1] & h[2] & h[3] & h[4] & h[5];
}

/**
 * Caesar-cypher encryption that replaces each English letter with the one 13 places forward or back along the alphabet.
 * 
 * @param string 	 String you wish to rot13 encrypt. 
 * @return Returns a string. 
 * @author Rob Brooks-Bilson (&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1.0, August 23, 2001 
 */
function rot13(string)
{
  var i=0;
  var j=0;
  var k=0;
  var out="";
  for (i=1; i LTE Len(String); i=i+1){
    j=Asc(Mid(string, i, 1));
    if(j GTE 65 AND j LTE 90){
      j=((J-52) MOD 26)+65;
    }
    else if(j GTE 97 AND j LTE 122){
      j=((j-84) MOD 26)+97;
    }
    out=out&Chr(j);
  }
  return out;
}

/**
 * This function validates user permissions against required permissions using Bit, List or custom validation.
 * 
 * @param model 	 String, "bit" or "list" (Required)
 * @param requiredPermission 	 Permissions required for access. (Required)
 * @param userPermissions 	 Permissions of the user. (Required)
 * @return Returns a boolean. 
 * @author Rob Rusher (&#114;&#111;&#98;&#64;&#114;&#111;&#98;&#114;&#117;&#115;&#104;&#101;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, September 27, 2002 
 */
function Secure(model, requiredPermission, userPermissions) {
	var permitted = false;
	// Switch to appropriate security model
	switch( model ) {
		// Bit Validation
		case "bit":
		{
			if ( BitAnd( userPermissions, requiredPermission ) ) {
				permitted = true;
			}
			break;
		}
		// List Validation
		case "list":
		{
			if ( ListFindNoCase( userPermissions, requiredPermission ) ) {
				permitted = true;
			}
			break;
		}
		default: {
			// Define custom validation here.
			permitted = true;
		}
	}
	
	return (permitted);
}

/**
 * This function validates user permissions against required permissions using either Bit, List or custom validation.
 * 
 * @param mode 	 String, "bit" or "list" (Required)
 * @param requiredPermission 	 Permissions required for access. (Required)
 * @param userPermissions 	 Permissions of the user. (Required)
 * @param failureXFA 	 Fusebox XFA (Optional)
 * @return Returns a boolean. 
 * @author Rob Rusher (&#114;&#111;&#98;&#64;&#114;&#111;&#98;&#114;&#117;&#115;&#104;&#101;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, October 15, 2002 
 */
function SecureMX(model, requiredPermission, userPermissions) {
	var permitted = false;
	// Switch to appropriate security model
	switch( model ) {
		// Bit Validation
		case "bit":
		{
			if ( BitAnd( userPermissions, requiredPermission ) ) {
				permitted = true;
			}
			break;
		}
		// List Validation
		case "list":
		{
			if ( ListFindNoCase( userPermissions, requiredPermission ) ) {
				permitted = true;
			}
			break;
		}
		// Define custom validation here
		default:
		{
			include( model & ".cfm" );
			permitted = true;
		}
	}
	
	// If not permitted and an Exit FuseAction is defined
	if ( NOT permitted and isDefined( "attributes.failureXFA" ) ) {
		location( "#request.self#?fuseaction=#attributes.failureXFA#", 1 );
	}
	
	return (permitted);
}

/**
 * Produces a 160-bit condensed representation (message digest) of message using the Secure Hash Algorithm (SHA-1).
 * Original custom tag code by Tim McCarthy (&#116;&#105;&#109;&#64;&#116;&#105;&#109;&#109;&#99;&#99;&#46;&#99;&#111;&#109;) - 2/2001
 * 
 * @param message 	 Text you want to hash. 
 * @return Returns a string. 
 * @author Rob Brooks-Bilson (&#116;&#105;&#109;&#64;&#116;&#105;&#109;&#109;&#99;&#99;&#46;&#99;&#111;&#109;&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1, November 28, 2001 
 */
function sha1(message)
{
  Var hex_msg = "";
  Var hex_msg_len = 0;
  Var padded_hex_msg = "";
  Var msg_block = "";
  Var num = 0;
  Var temp = "";
  Var h = ArrayNew(1);
  Var w = ArrayNew(1);
  Var a = "";
  Var b = "";
  Var c = "";
  Var d = "";
  Var e = "";
  Var f = "";
  Var i = 0;
  Var k = "";
  Var n = 0;
  Var t = 0;
  // convert the msg to ASCII binary-coded form
  for (i=1; i LTE Len(message); i=i+1) {  
	  hex_msg = hex_msg & Right("0"&FormatBaseN(Asc(Mid(message,i,1)),16),2);
  }
  // compute the msg length in bits
  hex_msg_len = FormatBaseN(8*Len(message),16);
  // pad the msg to make it a multiple of 512 bits long
  padded_hex_msg = hex_msg & "80" & RepeatString("0",128-((Len(hex_msg)+2+16) Mod 128)) & RepeatString("0",16-Len(hex_msg_len)) & hex_msg_len;
  // initialize the buffers
  h[1] = InputBaseN("0x67452301",16);
  h[2] = InputBaseN("0xefcdab89",16);
  h[3] = InputBaseN("0x98badcfe",16);
  h[4] = InputBaseN("0x10325476",16);
  h[5] = InputBaseN("0xc3d2e1f0",16);
  // process the msg 512 bits at a time
  for (n=1; n LTE Evaluate(Len(padded_hex_msg)/128); n=n+1) {  
	  msg_block = Mid(padded_hex_msg,128*(n-1)+1,128);
    a = h[1];
	  b = h[2];
    c = h[3];
    d = h[4];
    e = h[5];
    for (t=0; t LTE 79; t=t+1) {  
      // nonlinear functions and constants
      // this code mess is courtesy of the lack of an elseif() function
      if (t LE 19) {
			  f = BitOr(BitAnd(b,c),BitAnd(BitNot(b),d));
			  k = InputBaseN("0x5a827999",16);
      }
      else {
        if (t LE 39) {
          f = BitXor(BitXor(b,c),d);
			    k = InputBaseN("0x6ed9eba1",16);
        }
        else {
          if (t LE 59) {
            f = BitOr(BitOr(BitAnd(b,c),BitAnd(b,d)),BitAnd(c,d));
			      k = InputBaseN("0x8f1bbcdc",16);
          }
          else {
			      f = BitXor(BitXor(b,c),d);
			      k = InputBaseN("0xca62c1d6",16);
	        }	
        }
      }  
		  // transform the msg block from 16 32-bit words to 80 32-bit words
		  if (t LE 15) {
	      w[t+1] = InputBaseN(Mid(msg_block,8*t+1,8),16);
      }
      else {
        num = BitXor(BitXor(BitXor(w[t-3+1],w[t-8+1]),w[t-14+1]),w[t-16+1]);
  			w[t+1] = BitOr(BitSHLN(num,1),BitSHRN(num,32-1));
	  	}
		  temp = BitOr(BitSHLN(a,5),BitSHRN(a,32-5)) + f + e + w[t+1] + k;
  		e = d;
	  	d = c;
  		c = BitOr(BitSHLN(b,30),BitSHRN(b,32-30));
	  	b = a;
		  a = temp;
  		num = a;
    
      while ((num LT -2^31) OR (num GE 2^31)) {    
		  	num = num - Sgn(num)*2^32;
      }
  		a = num;
	  }	
	
    h[1] = h[1] + a;
    h[2] = h[2] + b;
  	h[3] = h[3] + c;
	  h[4] = h[4] + d;
  	h[5] = h[5] + e;
	
    for (i=1; i LTE 5; i=i+1) {
      while ((h[i] LT -2^31) OR (h[i] GE 2^31)) {
        h[i] = h[i] - Sgn(h[i])*2^32;
      }
    }
  }
  for (i=1; i LTE 5; i=i+1) {  
	  h[i] = RepeatString("0",8-Len(FormatBaseN(h[i],16))) & UCase(FormatBaseN(h[i],16));
  }
  Return h[1] & h[2] & h[3] & h[4] & h[5];
}

/**
 * Produces a 256-bit condensed representation (message digest) of message using the Secure Hash Algorithm (SHA-256).
 * Original custom tag code by Tim McCarthy (&#116;&#105;&#109;&#64;&#116;&#105;&#109;&#109;&#99;&#99;&#46;&#99;&#111;&#109;) - 8/2001
 * 
 * @param message 	 Text you want to hash. 
 * @return Returns a string. 
 * @author Rob Brooks-Bilson (&#116;&#105;&#109;&#64;&#116;&#105;&#109;&#109;&#99;&#99;&#46;&#99;&#111;&#109;&#114;&#98;&#105;&#108;&#115;&#64;&#97;&#109;&#107;&#111;&#114;&#46;&#99;&#111;&#109;) 
 * @version 1.0, November 28, 2001 
 */
function sha256(message){
  // convert the msg to ASCII binary-coded form
  var hex_msg="";
  // compute the msg length in bits
  var hex_msg_len=FormatBaseN(8*Len(message),16);
  var padded_hex_msg="";
  var prime=ArrayNew(1);  
  var msg_block="";
  var bgsig0=0;
  var	bgsig1=0;
  var ch=0;
  var maj=0;
  var t1=0;
  var t2=0;
  var a=0;
  var b=0;
  var c=0;
  var d=0;
  var e=0;
  var f=0;
  var g=0;
  var h=ArrayNew(1);
  var i=0;
  var k=ArrayNew(1);
  var n=0;
  var t=0;
  var w=ArrayNew(1);  
  var hh=0;

  for (i=1; i LTE Len(message); i=i+1) {
    hex_msg = hex_msg & Right("0"&FormatBaseN(Asc(Mid(message,i,1)),16),2);
  }
  // pad the msg to make it a multiple of 512 bits long --->
  padded_hex_msg = hex_msg & "80" & RepeatString("0",128-((Len(hex_msg)+2+16) Mod 128)) & RepeatString("0",16-Len(hex_msg_len)) & hex_msg_len;

  // first sixty-four prime numbers
  prime[1] = 2;
  prime[2] = 3;
  prime[3] = 5;
  prime[4] = 7;
  prime[5] = 11;
  prime[6] = 13;
  prime[7] = 17;
  prime[8] = 19;
  prime[9] = 23;
  prime[10] = 29;
  prime[11] = 31;
  prime[12] = 37;
  prime[13] = 41;
  prime[14] = 43;
  prime[15] = 47;
  prime[16] = 53;
  prime[17] = 59;
  prime[18] = 61;
  prime[19] = 67;
  prime[20] = 71;
  prime[21] = 73;
  prime[22] = 79;
  prime[23] = 83;
  prime[24] = 89;
  prime[25] = 97;
  prime[26] = 101;
  prime[27] = 103;
  prime[28] = 107;
  prime[29] = 109;
  prime[30] = 113;
  prime[31] = 127;
  prime[32] = 131;
  prime[33] = 137;
  prime[34] = 139;
  prime[35] = 149;
  prime[36] = 151;
  prime[37] = 157;
  prime[38] = 163;
  prime[39] = 167;
  prime[40] = 173;
  prime[41] = 179;
  prime[42] = 181;
  prime[43] = 191;
  prime[44] = 193;
  prime[45] = 197;
  prime[46] = 199;
  prime[47] = 211;
  prime[48] = 223;
  prime[49] = 227;
  prime[50] = 229;
  prime[51] = 233;
  prime[52] = 239;
  prime[53] = 241;
  prime[54] = 251;
  prime[55] = 257;
  prime[56] = 263;
  prime[57] = 269;
  prime[58] = 271;
  prime[59] = 277;
  prime[60] = 281;
  prime[61] = 283;
  prime[62] = 293;
  prime[63] = 307;
  prime[64] = 311;

  // constants
  for (i=1; i LTE 64; i=i+1) {
	  k[i] = Int(prime[i]^(1/3)*2^32);
  }

  // initial hash values
  for (i=1; i LTE 8; i=i+1) {
    h[i] = Int(Sqr(prime[i])*2^32);
    while ((h[i] LT -2^31) OR (h[i] GE 2^31)) {
      h[i] = h[i] - Sgn(h[i])*2^32;
    }
  }

  // process the msg 512 bits at a time
  for (n=1; n LTE (Len(padded_hex_msg)/128); n=n+1) {
	  // initialize the eight working variables
  	a = h[1];
  	b = h[2];
  	c = h[3];
  	d = h[4];
  	e = h[5];
  	f = h[6];
    g = h[7];
  	hh = h[8];
	
	  // nonlinear functions and message schedule
	  msg_block = Mid(padded_hex_msg,128*(n-1)+1,128);
    
    for (t=0; t LTE 63; t=t+1) {
  		if (t LE 15) {
  			w[t+1] = InputBaseN(Mid(msg_block,8*t+1,8),16);
  		} 
      else {
  			smsig0 = BitXor(BitXor(BitOr(BitSHRN(w[t-15+1],7),BitSHLN(w[t-15+1],32-7)),BitOr(BitSHRN(w[t-15+1],18),BitSHLN(w[t-15+1],32-18))),BitSHRN(w[t-15+1],3));
  			smsig1 = BitXor(BitXor(BitOr(BitSHRN(w[t-2+1],17),BitSHLN(w[t-2+1],32-17)),BitOr(BitSHRN(w[t-2+1],19),BitSHLN(w[t-2+1],32-19))),BitSHRN(w[t-2+1],10));
  			w[t+1] = smsig1 + w[t-7+1] + smsig0 + w[t-16+1];
  		}
      while ((w[t+1] LT -2^31) OR (w[t+1] GE 2^31)) {
  			w[t+1] = w[t+1] - Sgn(w[t+1])*2^32;
  		}
  		
  		bgsig0 = BitXor(BitXor(BitOr(BitSHRN(a,2),BitSHLN(a,32-2)),BitOr(BitSHRN(a,13),BitSHLN(a,32-13))),BitOr(BitSHRN(a,22),BitSHLN(a,32-22)));
  		bgsig1 = BitXor(BitXor(BitOr(BitSHRN(e,6),BitSHLN(e,32-6)),BitOr(BitSHRN(e,11),BitSHLN(e,32-11))),BitOr(BitSHRN(e,25),BitSHLN(e,32-25)));
  		ch = BitXor(BitAnd(e,f),BitAnd(BitNot(e),g));
  		maj = BitXor(BitXor(BitAnd(a,b),BitAnd(a,c)),BitAnd(b,c));
  		
  		t1 = hh + bgsig1 + ch + k[t+1] + w[t+1];
  		t2 = bgsig0 + maj;
  		hh = g;
  		g = f;
  		f = e;
  		e = d + t1;
  		d = c;
  		c = b;
  		b = a;
  		a = t1 + t2;
  		
      while ((a LT -2^31) OR (a GE 2^31)) {
  			a = a - Sgn(a)*2^32;
      }
      while ((e LT -2^31) OR (e GE 2^31)) {
  			e = e - Sgn(e)*2^32;
      }
  	  }
  	
  	h[1] = h[1] + a;
  	h[2] = h[2] + b;
  	h[3] = h[3] + c;
  	h[4] = h[4] + d;
  	h[5] = h[5] + e;
  	h[6] = h[6] + f;
  	h[7] = h[7] + g;
  	h[8] = h[8] + hh;
  	
    for (i=1; i LTE 8; i=i+1) {
      while ((h[i] LT -2^31) OR (h[i] GE 2^31)) {
  		  h[i] = h[i] - Sgn(h[i])*2^32;
  		}
  	}
  }

  for (i=1; i LTE 8; i=i+1) {
	  h[i] = RepeatString("0",8-Len(FormatBaseN(h[i],16))) & UCase(FormatBaseN(h[i],16));
  }

  return (h[1] & h[2] & h[3] & h[4] & h[5] & h[6] & h[7] & h[8]);
}

/**
 * Clean variables, such as form input, to modify values that may have been entered to perform e-mail injection.
 * 
 * @param str 	 String to parse. (Required)
 * @return Returns a string. 
 * @author Tony Brandner (&#116;&#111;&#110;&#121;&#64;&#98;&#114;&#97;&#110;&#100;&#110;&#101;&#114;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, February 3, 2006 
 */
function trimFalseEmailHeaders(str) {
	str = replaceNoCase(str, "Content-Type:", "content-type;", "ALL" );
	str = replaceNoCase(str, "MIME-Version:", "mime-version;", "ALL" );
	str = replaceNoCase(str, "To: ", "to; ", "ALL" );
	str = replaceNoCase(str, "From: ", "from; ", "ALL" );
	str = replaceNoCase(str, "bcc: ", "bcc; ", "ALL" );
	str = replaceNoCase(str, "Subject: ", "subject; ", "ALL" );
	return str;
}

/**
 * Used along with URLHash to verify the URL integrity.
 * 
 * @author John Bartlett (&#106;&#98;&#97;&#114;&#116;&#108;&#101;&#116;&#116;&#64;&#115;&#116;&#114;&#97;&#110;&#103;&#101;&#106;&#111;&#117;&#114;&#110;&#101;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, January 7, 2002 
 */
function URLCheckHash()
{
  var tmp=CGI.Query_String;
  var listL=0;
  var loop=0;
  var URLVar="";
  var HashData="";

  if (IsDefined("URL.Hash"))
  {
    if (URL.Hash NEQ "")
    {
      listL=ListLen(tmp,"&");
      URLVar=ListGetAt(tmp,ListL,"&");
      if (Left(UCase(URLVar),5) EQ "HASH=")
      {
        tmp=ListDeleteAt(tmp,ListL,"&");
      }
      HashData=cgi.Server_Name & cgi.Remote_Addr & cgi.Script_Name & tmp;
      if (URL.Hash EQ Hash(HashData)) return 1;
      else return 0;
    } else return 0;
  } else return 0;
}

/**
 * Add security by encrypting and decrypting URL variables. See URLEncrypt.
 * Mod by David Heard - added decode
 * 
 * @param nKey 	 The encryption key to use. (Required)
 * @param QueryString 	 Defaults to CGI.Query_String (Optional)
 * @return Writes to the URL scope. 
 * @author Timothy Heald (&#116;&#104;&#101;&#97;&#108;&#100;&#64;&#115;&#99;&#104;&#111;&#111;&#108;&#108;&#105;&#110;&#107;&#46;&#110;&#101;&#116;) 
 * @version 3, October 9, 2002 
 */
function urlDecrypt(key){
	var queryString = cgi.path_info;
	var scope = "url";
	var stuff = "";
	var oldcheck = "";
	var newcheck = "";
	var i = 0;
	var thisPair = "";
	var thisName = "";
	var thisValue = "";

	// see if a scope is provided if it is set it otherwise set it to url
	if(arrayLen(arguments) gt 1){
		scope = arguments[2];
	}

	if ((right(queryString,3) neq "htm") or (findNoCase("&",queryString) neq 0) or (findNoCase("=",queryString) neq 0)){
		stuff = '<FONT color="red">not encrypted, or corrupted url</FONT>';
	} else {
	
		// remove /index.htm
		querystring = replace(queryString, right(queryString,10),'');
		
		// remove the leading slash
		querystring = replace(queryString, left(queryString,1),'');
		
		// grab the old checksum
           if (len(querystring) GT 2) {
               oldcheck = right(querystring, 2);
               querystring = rereplace(querystring, "(.*)..", "\1");
           } 
           
           // check the checksum
           newcheck = left(hash(querystring & key),2);
           if (newcheck NEQ oldcheck) {
               return querystring;
           }
           
           //decrypt the passed value
		queryString = cfusion_decrypt(queryString, key);
		
			// set the variables
			for(i = 0; i lt listLen(queryString, '&'); i = i + 1){
				
				// Break up the list into seprate name=value pairs
				thisPair = listGetAt(queryString, i + 1, '&');
				
				// Get the name
				thisName = listGetAt(thisPair, 1, '=');
				
				// Get the value
				thisValue = listGetAt(thisPair, 2, '=');
				
				// Set the name with the scope
				thisName = scope & '.' & thisName;
				
				// Set the variable
				setVariable(thisName, thisValue);
			}
		
	}
	
	return stuff;
}

/**
 * Add security by encrypting and decrypting URL variables.
 * 
 * @param cQueryString 	 Query string to encrypt. (Required)
 * @param nKey 	 Key to use for encryption. (Required)
 * @return Returns an encrypted query string. 
 * @author Timothy Heald (&#116;&#104;&#101;&#97;&#108;&#100;&#64;&#115;&#99;&#104;&#111;&#111;&#108;&#108;&#105;&#110;&#107;&#46;&#110;&#101;&#116;) 
 * @version 2, February 19, 2003 
 */
function urlEncrypt(queryString, key){
	// encode the string
	var uue = cfusion_encrypt(queryString, key);
        
	// make a checksum of the endoed string
	var checksum = left(hash(uue & key),2);
        
	// assemble the URL
	queryString = "/" & uue & checksum &"/index.htm";
		
	return queryString;
}

/**
 * URL Security tool to prevent a user from changing any part of a URL.
 * 
 * @param URLValue 	 The string to hash. 
 * @return Returns a string. 
 * @author John Bartlett (&#106;&#98;&#97;&#114;&#116;&#108;&#101;&#116;&#116;&#64;&#115;&#116;&#114;&#97;&#110;&#103;&#101;&#106;&#111;&#117;&#114;&#110;&#101;&#121;&#46;&#99;&#111;&#109;) 
 * @version 1, January 7, 2002 
 */
function URLHash(URLValue)
{
  var HashData =cgi.Server_Name & cgi.Remote_Addr & cgi.Script_Name & URLValue;
  return URLValue & "&hash=" & LCase(Hash(HashData));
}
</cfscript>

<!---
 Get the authenticated username from the cgi.auth_user or cgi.remote_user without the domain information.
 
 @return Returns a string. 
 @author Mike Tangorre (&#109;&#116;&#97;&#110;&#103;&#111;&#114;&#114;&#101;&#64;&#103;&#109;&#97;&#105;&#108;&#46;&#99;&#111;&#109;) 
 @version 1, April 9, 2007 
--->
<cffunction name="getAuthUsername" returntype="string" output="false">
	
	<cfset var username = "" />
	
	<cfif len(trim(cgi.auth_user))>
	
		<cfset username = trim(cgi.auth_user) />
	
	<cfelseif len(trim(cgi.remote_user))>
	
		<cfset username = trim(cgi.remote_user) />
	
	<cfelse>
	
		<!--- no string to work with --->
		<cfreturn trim(username) />
	
	</cfif>
	
	<!--- check username@some.domain --->
	<cfif find("@",username)>
	
		<cfreturn listFirst(username,"@") />
	
	<!--- check domain\username --->
	<cfelseif find("\",username)>
	
		<cfreturn listLast(username,"\") />
	
	<!--- no domain --->
	<cfelse>
	
		<cfreturn trim(username) />
	
	</cfif>
	
</cffunction>

<!---
 Checks the compelxity of a password.
 
 @param password 	 Password to check. (Required)
 @param charOpts 	 Character options. See description. Default is alpha,digit,punct. (Optional)
 @param typeRequired 	 Number of charOpts that must be valid. Default is 2. (Optional)
 @param length 	 Minimum length of password. Default is 8. (Optional)
 @return Returns a boolean. 
 @author Scott Stroz (&#115;&#99;&#111;&#116;&#116;&#64;&#102;&#114;&#111;&#110;&#116;&#97;&#108;&#103;&#114;&#101;&#121;&#46;&#99;&#111;&#109;) 
 @version 1, April 22, 2004 
--->
<cffunction name="passwordCheck">
	<cfargument name="password" required="true" type="string">
	<cfargument name="CharOpts" required="false" type="string" default="alpha,digit,punct">
	<cfargument name="typesRequired" required="false" type="numeric" default="2">
	<cfargument name="length" required="false" type="numeric" default="8">


	<!--- Initialize variables --->
	<cfset var TypesCount = 0>
	<cfset var i = "">
	<cfset var charClass = "">
	<cfset var checks = structNew()>
	<cfset var numReq = "">
	<cfset var reqCompare = "">
	<cfset var j = "">
	
	<!--- Use regular expressions to check for the presence banned characters such as tab, space, backspace, etc  and password length--->
	<cfif ReFind("[[:cntrl:] ]",password) OR len(password) LT length>
		<cfreturn false>
	</cfif>


	<!--- Loop through the list 'mustHave' --->
	<cfloop list="#charOpts#" index="i">
		<cfset charClass = listGetat(i,1,' ')>
		<!--- Check to see if item in list should be included or excluded --->
		<cfif listgetat(i,1,"_") eq "no">
			<cfset regex = "[^[:#listgetat(charClass,2,'_')#:]]">
		<cfelse>
			<cfset regex = "[[:#charClass#:]]">
		</cfif>
		
		<!--- If regex found, set variable to position found --->
		<cfset checks["check#replace(charClass,' ','_','all')#"] = ReFind(regex,password)>

		<!--- If regex not found set valid to false --->
		<cfif checks["check#replace(charClass,' ','_','all')#"] GT 0>
			<cfset typesCount = typesCount + 1>
		</cfif>

		<cfif listLen(i, ' ') GT 1>
			<cfset numReq = listgetat(i,2,' ')>
			<cfset reqCompare = 0>
			<cfloop from="1" to="#len(password)#" index="j">
				<cfif REFind(regex,mid(password,j,1))>
					<cfset reqCompare = reqCompare + 1>
				</cfif>
			</cfloop>
			<cfif reqCompare LT numReq>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfloop>

	<!--- Check that retrieved values match with the give criteria --->
	<cfif typesCount LT typesRequired>
		<cfreturn false>
	</cfif>
	
	<cfreturn true>
	
</cffunction>
