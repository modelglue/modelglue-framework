<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


<form action="/code/css/forms/" method="post" enctype="multipart/form-data">
    <p><strong>Bold</strong> fields are required.</p>
    <fieldset><legend>Personal Information</legend>
      <div class="notes">

        <h4>Personal Information</h4>
        <p class="last">Please enter your name and address as they are listed for your debit card, credit card, or bank account.</p>
       </div>
      <div class="required error">
        <p class="error">Required.</p>
        <label for="first_name">First Name:</label>
        <input type="text" name="first_name" id="first_name" class="inputText" size="10" maxlength="100" value="" />

      </div>
      <div class="required error">
        <p class="error">Required.</p>
        <label for="last_name">Last Name:</label>
        <input type="text" name="last_name" id="last_name" class="inputText" size="10" maxlength="100" value="" />
      </div>
      <div class="optional">
        
        <label for="address_1">Address:</label>

        <input type="text" name="address_1" id="address_1" class="inputText" size="10" maxlength="100" value="" />
        <input type="text" name="address_2" id="address_2" class="inputText" size="10" maxlength="100" value="" />
      </div>
      <div class="optional">
        
        <label for="city">City:</label>
        <input type="text" name="city" id="city" class="inputText" size="10" maxlength="100" value="" />
      </div>
      <div class="optional">

        
        <label for="state">State:</label>
        
<select name="state" id="state" class="selectOne"><option value="">Select a State/Province</option><option value="">---------------</option><option value="AL">AL - Alabama</option><option value="AK">AK - Alaska</option><option value="AZ">AZ - Arizona</option><option value="AR">AR - Arkansas</option><option value="CA">CA - California</option><option value="CO">CO - Colorado</option><option value="CT">CT - Connecticut</option><option value="DE">DE - Delaware</option><option value="DC">DC - District of Columbia</option><option value="FL">FL - Florida</option><option value="GA">GA - Georgia</option><option value="HI">HI - Hawaii</option><option value="ID">ID - Idaho</option><option value="IL">IL - Illinois</option><option value="IN">IN - Indiana</option><option value="IA">IA - Iowa</option><option value="KS">KS - Kansas</option><option value="KY">KY - Kentucky</option><option value="LA">LA - Louisiana</option><option value="ME">ME - Maine</option><option value="MD">MD - Maryland</option><option value="MA">MA - Massachusetts</option><option value="MI">MI - Michigan</option><option value="MN">MN - Minnesota</option><option value="MS">MS - Mississippi</option><option value="MO">MO - Missouri</option><option value="MT">MT - Montana</option><option value="NE">NE - Nebraska</option><option value="NV">NV - Nevada</option><option value="NH">NH - New Hampshire</option><option value="NJ">NJ - New Jersey</option><option value="NM">NM - New Mexico</option><option value="NY">NY - New York</option><option value="NC">NC - North Carolina</option><option value="ND">ND - North Dakota</option><option value="OH">OH - Ohio</option><option value="OK">OK - Oklahoma</option><option value="OR">OR - Oregon</option><option value="PA">PA - Pennsylvania</option><option value="RI">RI - Rhode Island</option><option value="SC">SC - South Carolina</option><option value="SD">SD - South Dakota</option><option value="TN">TN - Tennessee</option><option value="TX">TX - Texas</option><option value="UT">UT - Utah</option><option value="VT">VT - Vermont</option><option value="VA">VA - Virginia</option><option value="WA">WA - Washington</option><option value="WV">WV - West Virginia</option><option value="WI">WI - Wisconsin</option><option value="WY">WY - Wyoming</option><option value="">---------------</option><option value="AE">AE - Armed Forces Africa</option><option value="AA">AA - Armed Forces Americas (except Canada)</option><option value="AE">AE - Armed Forces Canada</option><option value="AE">AE - Armed Forces Europe</option><option value="AE">AE - Armed Forces Middle East</option><option value="AP">AP - Armed Forces Pacific</option><option value="">---------------</option><option value="AB">AB - Alberta</option><option value="BC">BC - British Columbia</option><option value="MB">MB - Manitoba</option><option value="NB">NB - New Brunswick</option><option value="NL">NL - Newfoundland and Labrador</option><option value="NT">NT - Northwest Territories</option><option value="NS">NS - Nova Scotia</option><option value="NU">NU - Nunavut</option><option value="ON">ON - Ontario</option><option value="PE">PE - Prince Edward Island</option><option value="QC">QC - Quebec</option><option value="SK">SK - Saskatchewan</option><option value="YT">YT - Yukon</option><option value="">---------------</option><option value="AS">AS - American Samoa</option><option value="FM">FM - Federated States of Micronesia</option><option value="GU">GU - Guam</option><option value="MH">MH - Marshall Islands</option><option value="MP">MP - Northern Mariana Islands</option><option value="PW">PW - Palau</option><option value="PR">PR - Puerto Rico</option><option value="VI">VI - Virgin Islands</option><option value="">---------------</option><option value="XX">XX - Other State/Province/Territory</option></select>

      </div>
      <div class="optional">
        
        <label for="postal">Zip/Postal Code:</label>
        <input type="text" name="postal" id="postal" class="inputText" size="10" maxlength="50" value="" />
      </div>
      <div class="optional">
        
        <label for="country">Country:</label>

        
<select name="country" id="country" class="selectOne"><option value="Select a Country"> Select a Country</option><option value="">---------------</option><option value="United States" selected="selected">US - United States</option><option value="Canada">CA - Canada</option><option value="">---------------</option><option value="Afghanistan">AF - Afghanistan</option><option value="Albania">AL - Albania</option><option value="Algeria">DZ - Algeria</option><option value="American Samoa">AS - American Samoa</option><option value="Andorra">AD - Andorra</option><option value="Angola">AO - Angola</option><option value="Anguilla">AI - Anguilla</option><option value="Antarctica">AQ - Antarctica</option><option value="Antigua and Barbuda">AG - Antigua and Barbuda</option><option value="Argentina">AR - Argentina</option><option value="Armenia">AM - Armenia</option><option value="Aruba">AW - Aruba</option><option value="Australia">AU - Australia</option><option value="Austria">AT - Austria</option><option value="Azerbaijan">AZ - Azerbaijan</option><option value="Bahamas">BS - Bahamas</option><option value="Bahrain">BH - Bahrain</option><option value="Bangladesh">BD - Bangladesh</option><option value="Barbados">BB - Barbados</option><option value="Belarus">BY - Belarus</option><option value="Belgium">BE - Belgium</option><option value="Belize">BZ - Belize</option><option value="Benin">BJ - Benin</option><option value="Bermuda">BM - Bermuda</option><option value="Bhutan">BT - Bhutan</option><option value="Bolivia">BO - Bolivia</option><option value="Bosnia and Herzegovina">BA - Bosnia and Herzegovina</option><option value="Botswana">BW - Botswana</option><option value="Bouvet Island">BV - Bouvet Island</option><option value="Brazil">BR - Brazil</option><option value="British Indian Ocean Territory">IO - British Indian Ocean Territory</option><option value="Brunei Darussalam">BN - Brunei Darussalam</option><option value="Bulgaria">BG - Bulgaria</option><option value="Burkina Faso">BF - Burkina Faso</option><option value="Burundi">BI - Burundi</option><option value="Cambodia">KH - Cambodia</option><option value="Cameroon">CM - Cameroon</option><option value="Cape Verde">CV - Cape Verde</option><option value="Cayman Islands">KY - Cayman Islands</option><option value="Central African Republic">CF - Central African Republic</option><option value="Chad">TD - Chad</option><option value="Chile">CL - Chile</option><option value="China">CN - China</option><option value="Christmas Island">CX - Christmas Island</option><option value="Cocos (Keeling) Islands">CC - Cocos (Keeling) Islands</option><option value="Colombia">CO - Colombia</option><option value="Comoros">KM - Comoros</option><option value="Congo">CG - Congo</option><option value="Congo, Democratic Republic of the">CD - Congo, Democratic Republic of the</option><option value="Cook Islands">CK - Cook Islands</option><option value="Costa Rica">CR - Costa Rica</option><option value="Cote d'Ivoire">CI - Cote d'Ivoire</option><option value="Croatia">HR - Croatia</option><option value="Cuba">CU - Cuba</option><option value="Cyprus">CY - Cyprus</option><option value="Czech Republic">CZ - Czech Republic</option><option value="Denmark">DK - Denmark</option><option value="Djibouti">DJ - Djibouti</option><option value="Dominica">DM - Dominica</option><option value="Dominican Republic">DO - Dominican Republic</option><option value="East Timor">TP - East Timor</option><option value="Ecuador">EC - Ecuador</option><option value="Egypt">EG - Egypt</option><option value="El Salvador">SV - El Salvador</option><option value="Equatorial Guinea">GQ - Equatorial Guinea</option><option value="Eritrea">ER - Eritrea</option><option value="Estonia">EE - Estonia</option><option value="Ethiopia">ET - Ethiopia</option><option value="Falkland Islands (Malvinas)">FK - Falkland Islands (Malvinas)</option><option value="Faroe Islands">FO - Faroe Islands</option><option value="Fiji">FJ - Fiji</option><option value="Finland">FI - Finland</option><option value="France">FR - France</option><option value="French Guiana">GF - French Guiana</option><option value="French Polynesia">PF - French Polynesia</option><option value="French Southern Territories">TF - French Southern Territories</option><option value="Gabon">GA - Gabon</option><option value="Gambia">GM - Gambia</option><option value="Georgia">GE - Georgia</option><option value="Germany">DE - Germany</option><option value="Ghana">GH - Ghana</option><option value="Gibraltar">GI - Gibraltar</option><option value="Greece">GR - Greece</option><option value="Greenland">GL - Greenland</option><option value="Grenada">GD - Grenada</option><option value="Guadeloupe">GP - Guadeloupe</option><option value="Guam">GU - Guam</option><option value="Guatemala">GT - Guatemala</option><option value="Guinea">GN - Guinea</option><option value="Guinea-Bissau">GW - Guinea-Bissau</option><option value="Guyana">GY - Guyana</option><option value="Haiti">HT - Haiti</option><option value="Heard Island and McDonald Islands">HM - Heard Island and McDonald Islands</option><option value="Holy See (Vatican City)">VA - Holy See (Vatican City)</option><option value="Honduras">HN - Honduras</option><option value="Hong Kong">HK - Hong Kong</option><option value="Hungary">HU - Hungary</option><option value="Iceland">IS - Iceland</option><option value="India">IN - India</option><option value="Indonesia">ID - Indonesia</option><option value="Iran, Islamic Republic of">IR - Iran, Islamic Republic of</option><option value="Iraq">IQ - Iraq</option><option value="Ireland">IE - Ireland</option><option value="Israel">IL - Israel</option><option value="Italy">IT - Italy</option><option value="Jamaica">JM - Jamaica</option><option value="Japan">JP - Japan</option><option value="Jordan">JO - Jordan</option><option value="Kazakstan">KZ - Kazakstan</option><option value="Kenya">KE - Kenya</option><option value="Kiribati">KI - Kiribati</option><option value="Korea, Democratic People's Republic of">KP - Korea, Democratic People's Republic of</option><option value="Korea, Republic of">KR - Korea, Republic of</option><option value="Kuwait">KW - Kuwait</option><option value="Kyrgyzstan">KG - Kyrgyzstan</option><option value="Lao People's Democratic Republic">LA - Lao People's Democratic Republic</option><option value="Latvia">LV - Latvia</option><option value="Lebanon">LB - Lebanon</option><option value="Lesotho">LS - Lesotho</option><option value="Liberia">LR - Liberia</option><option value="Libyan Arab Jamahiriya">LY - Libyan Arab Jamahiriya</option><option value="Liechtenstein">LI - Liechtenstein</option><option value="Lithuania">LT - Lithuania</option><option value="Luxembourg">LU - Luxembourg</option><option value="Macau">MO - Macau</option><option value="Macedonia, The Former Yugoslav Republic of">MK - Macedonia, The Former Yugoslav Republic of</option><option value="Madagascar">MG - Madagascar</option><option value="Malawi">MW - Malawi</option><option value="Malaysia">MY - Malaysia</option><option value="Maldives">MV - Maldives</option><option value="Mali">ML - Mali</option><option value="Malta">MT - Malta</option><option value="Marshall Islands">MH - Marshall Islands</option><option value="Martinique">MQ - Martinique</option><option value="Mauritania">MR - Mauritania</option><option value="Mauritius">MU - Mauritius</option><option value="Mayotte">YT - Mayotte</option><option value="Mexico">MX - Mexico</option><option value="Micronesia, Federated States of">FM - Micronesia, Federated States of</option><option value="Moldova, Republic of">MD - Moldova, Republic of</option><option value="Monaco">MC - Monaco</option><option value="Mongolia">MN - Mongolia</option><option value="Montserrat">MS - Montserrat</option><option value="Morocco">MA - Morocco</option><option value="Mozambique">MZ - Mozambique</option><option value="Myanmar">MM - Myanmar</option><option value="Namibia">NA - Namibia</option><option value="Nauru">NR - Nauru</option><option value="Nepal">NP - Nepal</option><option value="Netherlands">NL - Netherlands</option><option value="Netherlands Antilles">AN - Netherlands Antilles</option><option value="New Caledonia">NC - New Caledonia</option><option value="New Zealand">NZ - New Zealand</option><option value="Nicaragua">NI - Nicaragua</option><option value="Niger">NE - Niger</option><option value="Nigeria">NG - Nigeria</option><option value="Niue">NU - Niue</option><option value="Norfolk Island">NF - Norfolk Island</option><option value="Northern Mariana Islands">MP - Northern Mariana Islands</option><option value="Norway">NO - Norway</option><option value="Oman">OM - Oman</option><option value="Pakistan">PK - Pakistan</option><option value="Palau">PW - Palau</option><option value="Palestinian Territory, Occupied">PS - Palestinian Territory, Occupied</option><option value="PANAMA">PA - PANAMA</option><option value="Papua New Guinea">PG - Papua New Guinea</option><option value="Paraguay">PY - Paraguay</option><option value="Peru">PE - Peru</option><option value="Philippines">PH - Philippines</option><option value="Pitcairn">PN - Pitcairn</option><option value="Poland">PL - Poland</option><option value="Portugal">PT - Portugal</option><option value="Puerto Rico">PR - Puerto Rico</option><option value="Qatar">QA - Qatar</option><option value="Reunion">RE - Reunion</option><option value="R  omania">RO - R  omania</option><option value="Russian Federation">RU - Russian Federation</option><option value="Rwanda">RW - Rwanda</option><option value="Saint Helena">SH - Saint Helena</option><option value="Saint Kitts and Nevis">KN - Saint Kitts and Nevis</option><option value="Saint Lucia">LC - Saint Lucia</option><option value="Saint Pierre and Miquelon">PM - Saint Pierre and Miquelon</option><option value="Saint Vincent and the Grenadines">VC - Saint Vincent and the Grenadines</option><option value="Samoa">WS - Samoa</option><option value="San Marino">SM - San Marino</option><option value="Sao Tome and Principe">ST - Sao Tome and Principe</option><option value="Saudi Arabia">SA - Saudi Arabia</option><option value="Senegal">SN - Senegal</option><option value="Seychelles">SC - Seychelles</option><option value="Sierra Leone">SL - Sierra Leone</option><option value="Singapore">SG - Singapore</option><option value="Slovakia">SK - Slovakia</option><option value="Slovenia">SI - Slovenia</option><option value="Solomon Islands">SB - Solomon Islands</option><option value="Somalia">SO - Somalia</option><option value="South Africa">ZA - South Africa</option><option value="South Georgia and the South Sandwich Islands">GS - South Georgia and the South Sandwich Islands</option><option value="Spain">ES - Spain</option><option value="Sri Lanka">LK - Sri Lanka</option><option value="Sudan">SD - Sudan</option><option value="Suriname">SR - Suriname</option><option value="Svalbard and Jan Mayen">SJ - Svalbard and Jan Mayen</option><option value="Swaziland">SZ - Swaziland</option><option value="Sweden">SE - Sweden</option><option value="Switzerland">CH - Switzerland</option><option value="Syrian Arab Republic">SY - Syrian Arab Republic</option><option value="Taiwan, Province of China">TW - Taiwan, Province of China</option><option value="Tajikistan">TJ - Tajikistan</option><option value="Tanzania, United Republic of">TZ - Tanzania, United Republic of</option><option value="Thailand">TH - Thailand</option><option value="Togo">TG - Togo</option><option value="Tokelau">TK - Tokelau</option><option value="Tonga">TO - Tonga</option><option value="Trinidad and Tobago">TT - Trinidad and Tobago</option><option value="Tunisia">TN - Tunisia</option><option value="Turkey">TR - Turkey</option><option value="Turkmenistan">TM - Turkmenistan</option><option value="Turks and Caicos Islands">TC - Turks and Caicos Islands</option><option value="Tuvalu">TV - Tuvalu</option><option value="Uganda">UG - Uganda</option><option value="Ukraine">UA - Ukraine</option><option value="United Arab Emirates">AE - United Arab Emirates</option><option value="United Kingdom">GB - United Kingdom</option><option value="United States Minor Outlying Islands">UM - United States Minor Outlying Islands</option><option value="Uruguay">UY - Uruguay</option><option value="Uzbekistan">UZ - Uzbekistan</option><option value="Vanuatu">VU - Vanuatu</option><option value="Venezuela">VE - Venezuela</option><option value="Viet Nam">VN - Viet Nam</option><option value="Virgin Islands, British">VG - Virgin Islands, British</option><option value="Virgin Islands, U.S.">VI - Virgin Islands, U.S.</option><option value="Wallis and Futuna">WF - Wallis and Futuna</option><option value="Western Sahara">EH - Western Sahara</option><option value="Yemen">YE - Yemen</option><option value="Yugoslavia">YU - Yugoslavia</option><option value="Zambia">ZM - Zambia</option><option value="Zimbabwe">ZW - Zimbabwe</option></select>

 
      </div>
    </fieldset>

    <fieldset><legend>Contact Information</legend>
      <div class="notes">
        <h4>Contact Information</h4>
        <p>Please enter your full email address, for example, <strong>name@domain.com</strong></p>

        <p>It is important that you provide a valid, working email address that you have access to as it must be verified before you can use your account.</p>
        <p>Please enter a land line number, not a mobile phone number.</p>
        <p class="last">Your phone number will not be shared or used for telemarketing. Your information is protected by our <a href="/legal/privacy_policy/" title="View our Privacy Policy">Privacy Policy</a>.</p>
      </div>
      <div class="optional">
        <fieldset><legend>How to Contact You?</legend>

          <label for="how_contact_phone" class="labelRadio compact"><input type="radio" name="how_contact" id="how_contact_phone" class="inputRadio" value="Phone" /> Phone</label>
          <label for="how_contact_email" class="labelRadio compact"><input type="radio" name="how_contact" id="how_contact_email" class="inputRadio" value="Email" checked="checked" /> Email</label>
        </fieldset>
      </div>
      <div class="required error">
        <p class="error">Required.</p>

        <label for="email">Email:</label>
        <input type="text" name="email" id="email" class="inputText" size="10" maxlength="250" value="" />
        <small>We will never sell or disclose your email address to anyone.  Once your account is setup, you may add additional email addresses.</small>
      </div>
      <div class="required error">
        <p class="error">Required.</p>
        <label for="confirm_email">Re-enter Email:</label>

        <input type="text" name="confirm_email" id="confirm_email" class="inputText" size="10" maxlength="250" value="" />
        <small>Must match the email address you just entered above.</small>
      </div>
      <div class="optional">
        
        <label for="phone">Phone:</label>
        <input type="text" name="phone" id="phone" class="inputText" size="10" maxlength="50" value="" />
      </div>
      <div class="optional">

        
        <label for="fax">Fax:</label>
        <input type="text" name="fax" id="fax" class="inputText" size="10" maxlength="50" value="" />
      </div>
      <div class="optional error">
        <p class="error">You must either select one of the available message subjects or enter your own.</p>
        <fieldset><legend>Message Subject:</legend>
          <label for="subject_help" class="labelRadio"><input type="radio" name="message_subject" id="subject_help" class="inputRadio" value="Help, my brother/sister is driving me crazy!" /> Help, my brother/sister is driving me crazy!</label>

          <label for="subject_retire" class="labelRadio"><input type="radio" name="message_subject" id="subject_retire" class="inputRadio" value="How can I tell my father/mother, it's time for them to retire?" /> How can I tell my father/mother, it's time for them to retire?</label>
          <label for="subject_partner" class="labelRadio"><input type="radio" name="message_subject" id="subject_partner" class="inputRadio" value="I'm exasperated with an awkward partner!" /> I'm exasperated with an awkward partner!</label>
          <label for="subject_interfere" class="labelRadio"><input type="radio" name="message_subject" id="subject_interfere" class="inputRadio" value="How do I stop my family members from interfering?" /> How do I stop my family members from interfering?</label>
          <label for="subject_other" class="labelRadio"><input type="radio" name="message_subject" id="subject_other" class="inputRadio" onclick="this.form.message_subject_other.focus()" onfocus="this.form.message_subject_other.focus()" value="" checked="checked"  /> Other:</label>
          <input type="text" name="message_subject_other" id="message_subject_other" class="inputText" value="" />

        </fieldset>
      </div>
      <div class="required">
        
        <label for="note_narrow">Your Message:</label>
        <textarea name="note_narrow" id="note_narrow" class="inputTextarea" rows="10" cols="21"></textarea>
        <small>Must be 250 characters or less.</small>
      </div>

      <div class="required wide error">
        <p class="error">Required.</p>
        <label for="note_wide">Your Message:</label>
        <textarea name="note_wide" id="note_wide" class="inputTextarea" rows="10" cols="21"></textarea>
        <small>We'd love to get your feedback on any of the products or services we offer or on your experience with us.</small>
      </div>
      <div class="optional">

        
        <label for="image">Image:</label>
        <input type="file" name="image" id="image" class="inputFile" />
        <label for="delete_image" class="labelCheckbox"><input type="checkbox" name="delete_image" id="delete_image" class="inputCheckbox" value="1" /> Delete</label>
        <small>We only accept JPG files.</small>
      </div>
      <div class="required error">
        <p class="error">Please select at least one.</p>

        <label for="availability_select">What is your current availability?</label>
        <select name="availability_select" id="availability_select" class="selectMultiple" size="3" multiple="multiple">
          <option value="Part-time">Part-time</option>
          <option value="Full-time (Days)">Full-time (Days)</option>
          <option value="Full-time (Swing)">Full-time (Swing)</option>
          <option value="Full-time (Graveyard)">Full-time (Graveyard)</option>

          <option value="Weekends Only">Weekends Only</option>
        </select>
        <small>Use the <kbd>CTRL</kbd> key to select more than one.</small>
      </div>
      <div class="required error">
        <p class="error">Please select at least one.</p>

        <fieldset><legend>Availability:</legend>
          <label for="availability_checkbox_0" class="labelCheckbox"><input type="checkbox" name="availability_checkbox" id="availability_checkbox_0" class="inputCheckbox" value="Part-time" /> Part-time</label>
          <label for="availability_checkbox_1" class="labelCheckbox"><input type="checkbox" name="availability_checkbox" id="availability_checkbox_1" class="inputCheckbox" value="Full-time (Days)" /> Full-time (Days)</label>
          <label for="availability_checkbox_2" class="labelCheckbox"><input type="checkbox" name="availability_checkbox" id="availability_checkbox_2" class="inputCheckbox" value="Full-time (Swing)" /> Full-time (Swing)</label>
          <label for="availability_checkbox_3" class="labelCheckbox"><input type="checkbox" name="availability_checkbox" id="availability_checkbox_3" class="inputCheckbox" value="Full-time (Graveyard)" /> Full-time (Graveyard)</label>

          <label for="availability_checkbox_4" class="labelCheckbox"><input type="checkbox" name="availability_checkbox" id="availability_checkbox_4" class="inputCheckbox" value="Weekends Only" /> Weekends Only</label>
        </fieldset>
      </div>
    </fieldset>
    
    <fieldset><legend>Login Information</legend>
      <div class="notes">
        <h4>Login Information</h4>

        <p>Your username and password must both be at least 8 characters long and are case-sensitive. Please do not enter accented characters.</p>
        <p>We recommend that your password is not a word you can find in the dictionary, includes both capital and lower case letters, and contains at least one special character (1-9, !, *, _, etc.).</p>
        <p class="last">Your password will be encrypted and stored in our system.  Due to the encryption, we <strong>cannot</strong> retrieve your password for you.  If you lose or forget your password, we offer the ability to reset it.</p>
      </div>
      <div class="required error">
        <p class="error">Required.</p>

        <label for="username">Username:</label>
        <input type="text" name="username" id="username" class="inputText" size="10" maxlength="20" value="" />
        <small>May only contain letters, numbers, and underscore (_) and 8-20 characters long.</small>
      </div>
      <div class="required error">
        <p class="error">Required.</p>
        <label for="password">Password:</label>

        <input type="password" name="password" id="password" class="inputPassword" size="10" maxlength="25" value="" />
        <small>Must be 8-25 characters long.</small>
      </div>
      <div class="required error">
        <p class="error">Required.</p>
        <label for="confirm_password">Please re-enter your password:</label>
        <input type="password" name="confirm_password" id="confirm_password" class="inputPassword" size="10" maxlength="25" value="" />

        <small>Must match the password you entered just above.</small>
      </div>
      <div class="optional">
        <label for="remember" class="labelCheckbox"><input type="checkbox" name="remember" id="remember" class="inputCheckbox" value="1" /> Remember Me</label>
        <small>If you don't want to bother with having to login every time you visit the site, then checking &quot;Remember Me&quot; will place a unique identifier only our site can read that we'll use to identify you and log you in automatically each time you visit.</small>

      </div>
    </fieldset>

    <fieldset><legend>Verification</legend>
      <input type="hidden" name="captcha_hash" value="723E5F48827F88DBDFF230C1BC07D95C" />
      <input type="hidden" name="captcha_file" value="863ADF26-1372-507C-AEE4D18618EB942B.jpg" />
      <div class="notes">
        <h4>Verification Information</h4>

        <p class="last">Type the characters you see in this picture.  This ensures that a person, not an automated program, is creating this account.</p>
      </div>
      <div class="required">
        <label for="captcha">Picture:</label>
        <img src="/images/captcha/863ADF26-1372-507C-AEE4D18618EB942B.jpg" border="0" alt="" />
      </div>
      <div class="required error">
        <p class="error">Required.</p>

        <label for="captcha">Characters:</label>
        <input type="text" name="captcha" id="captcha" class="inputText" size="10" maxlength="25" value="" />
      </div>
    </fieldset>

    <fieldset>
      <div class="submit">
        <div>
          <input type="submit" class="inputSubmit" value="Submit &raquo;" />

          <input type="submit" class="inputSubmit" value="Cancel" />
        </div>
      </div>
    </fieldset>
  </form>
