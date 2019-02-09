PHP Extension for "Delphi for PHP"

d4pide.dll is PHP Extension designed for Delphi for PHP.
This extensions implements additional PHP functions that can be used in PHP scripts.

Functions:

1. d4p_getversion 
This function returns the version of Delphi for PHP
Example: echo d4p_getversion();

2. d4p_getroot
This functions returns the root folder of Delphi for PHP
Example: echo d4p_getroot();

3. d4p_getpackages
This function returns the list of the installed packages
Example:

               function Button3Click($sender, $params)
               {
                 $array = d4p_getpackages();
                 $count = count($array);
                  for ($i = 0; $i < $count; $i++) {
                  $this->Memo1->AddLine($array[$i]) ;
                  }
               }

4. d4p_getphpdir
This function returns the PHP root folder
Example: echo d4p_getphpdir();

5. d4p_getport
This function returns the port number of the internal web server
Example: echo d4p_getport();

6. d4p_isrunning
This function can be used to determine if Delphi for PHP is currently running
Example:
                  if (d4p_isrunning())
                  {
                    $this->Memo1->AddLine("running");
                  }


Installation:

1. Close Delphi for PHP
2. Copy d4pide.dll to Delphi for PHP \php\ext folder
3. Add following line to php.ini.template file:
   extension=d4pide.dll
4. Launch Delphi for PHP



Author:
Serhiy Perevoznyk
Belgium
http://users.chello.be/ws36637/
