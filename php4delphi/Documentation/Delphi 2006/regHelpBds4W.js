
/***************************************************************************
Help 2.0 system maintenance script
----------------------------------------------------------------------------
Takes the following parameters:

Action param:
0 = Remove registration information (not files)
1 = Restore or update registration information on installed file set
2 = Copy files from source media, register files to parent namespace (or create plugin)
3 = Remove registration information and listed files

Config file:
Specify file name relative to the script position.
For config file specs, see regHelp.htm.

Confirmation param:
(used when batching multiple config files; use 1 on last file)
0 = No confirmation message after applying config
1 = Show confirmation\Help launch message (per shortcut/launch param)

***************************************************************************/

var WSHShell = WScript.CreateObject ( 'WScript.Shell' );
var fo = new ActiveXObject('Scripting.FileSystemObject');
var scriptPath = fo.GetParentFolderName ( WScript.ScriptFullName ).toLowerCase() + '\\';

var args = WScript.Arguments;
if ( args.Length != 4 || args(0) > 3 )
    {
    // abort
    WSHShell.Popup ( 'ERROR: Parameters are incorrect. Please see documentation (regHelp.htm).', 0, WScript.ScriptName, 16 ) ;
    WScript.Echo ( 'ERROR: Parameters are incorrect. Please see documentation (regHelp.htm).' );
    WSHShell = '' ; WScript.Quit() ;
    }
var a = trimit(args(0));

//string vars
var mbTitle = 'Help registration utility'; //msg box title
var parentNamespace = 'borland.bds4';
//error messages
var err_closehelp = '\nPlease close your Document Explorer, then press \'OK\'\nto continue Help maintenance operations.';
var err_closehelp1 = 'The Document Explorer (dexplore.exe) must be closed\nin order to register a new Help collection.\nClose the viewer now?';
var err_closehelp2 = '\nTry again when all instances of the Document Explorer are closed.';

var c = trimit(args(1));
if ( c == '' || c == null )
    {
    WSHShell.Popup ( "Configuration file name required.", 0, mbTitle, 16 );
    WScript.Echo ( 'ERROR: Configuration file name required.' );
    WSHShell = null; WScript.Quit();
    }
var cfgFile = checkConfig(c);

//get Borland product installation path
var bdsRoot = '';
try
    {
    bdsRoot = WSHShell.RegRead('HKLM\\SOFTWARE\\Borland\\BDS\\4.0\\RootDir');
    }
catch (err_bdsroot)
    { }

if ( bdsRoot == '' || bdsRoot == 'bdsdocs' )
    {
    bdsRoot = 'C:\\Program Files\\Borland\\BDS\\4.0\\';
    WScript.Echo ( 'Could not locate BDS RootDir key. Installing to default folder: ' + bdsRoot );
    }

//collect .NET SDK registry settings and file locations
try
    {
    var sdkRoot = WSHShell.RegRead('HKLM\\Software\\Microsoft\\.NETFramework\\sdkInstallRootv1.1');
    }
catch (err_sdk11)
    {
    try
        {
        sdkRoot = WSHShell.RegRead('HKLM\\Software\\Microsoft\\.NETFramework\\sdkInstallRoot');
        }
    catch (err_sdk)
        {
        WSHShell.Popup ( 'Microsoft .NET FrameworkSDK not found.', 0, mbTitle, 16 );
        WScript.Echo ( 'ERROR: Microsoft .NET FrameworkSDK not found.' );
        WSHShell = null; WScript.Quit();
        }
    }

try
    {
    var dxLocation = WSHShell.RegRead('HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\App Paths\\dexplore.exe\\Path');
    }
catch (err_dxloc)
    {
    WSHShell.Popup ( 'Microsoft Documentation Explorer application not found.', 0, mbTitle, 16 );
    WScript.Echo ( 'ERROR: Microsoft Documentation Explorer application not found.' );
    WSHShell = null; WScript.Quit();
    }

var fin = rMain ( cfgFile );

WScript.Echo ( 'Help system maintenance complete for ' + args(1) );

var fMsg='', qFin=0, mbType=36;

WSHShell = null; WScript.Quit();


/**********************************************
organize and apply config data
*/
function rMain(f)
{
    //vars
    var retMain='';
    var cfgData, secData, keyData, valData;
    var nFiles=0, nFilters=0;
    var sCollectionData = false;
    var sFiles = false;
    var sFilters = false;
    var inamespace='', nsparent='', mergetype=''; mergetoctitle='', mergetocurl='';
    var arrFiles;
    var primaryNamespace = false;
    var langid = '';

    //collect config data
    var cfg = fo.OpenTextFile ( f, 1 );
    while ( !cfg.AtEndOfStream )
        {
        cfgData = trimit(cfg.readline());
        if ( cfgData.indexOf ( ';' ) != -1 ) { cfgData = trimit(cfgData.substr ( 0, cfgData.indexOf (';') )); }
        if ( cfgData != '' )
            {
            if ( cfgData.substr ( 0, 1 ) == '[' && cfgData.indexOf ( ']' ) != -1 )
                {
                secData = trimit ( cfgData.substr ( 1, cfgData.indexOf ( ']' ) - 1 ) ).toLowerCase();
                }
            }
        if ( secData != '' && cfgData != '' && cfgData.substr ( 0, 1 ) != '[' && cfgData.indexOf ( ']' ) == -1 )
            {
            if ( secData == 'collectiondata' )
                {
                sCollectionData = true;
                keyData = trimit(cfgData.substr ( 0, cfgData.indexOf ( '=' ))).toLowerCase();
                valData = trimit(cfgData.substr ( cfgData.indexOf ( '=' ) + 1));
                switch ( keyData )
                    {
                    case 'parent':
                        var nsparent = valData;
                        var primaryNamespace = true;
                        break;
                    case 'versioning':
                        var versioning = valData;
                        break;
                    case 'namespace':
                        var inamespace = valData;
                        break;
                    case 'description':
                        var nsdescription = valData;
                        break;
                    case 'langid':
                        var langid = valData;
                        break;
                    case 'installdest':
                        var installdest = valData;
                        break;
                    case 'installsrc':
                        var installsrc = valData;
                        break;
                    case 'mergetype':
                        var mergetype = valData.toLowerCase();
                        break;
                    case 'mergetoctitle':
                        var mergetoctitle = valData;
                        break;
                    case 'mergetocurl':
                        var mergetocurl = valData;
                        break;
                    default:
                    }
                }
            else
                {
                switch ( secData )
                    {
                    case 'files':
                        if ( nFiles == 0 ) { var arrFiles=new Array(); }
                        arrFiles[nFiles++] = trimit(cfgData);
                        break;
                    case 'filters':
                        if ( nFilters == 0 ) { var arrFilters=new Array(); }
                        arrFilters[nFilters++] = trimit(cfgData);
                        break;
                    default:
                    }
                }
            }
        }
    cfg.close();
    //END config data collection

    if ( nFiles > 0 ) { sFiles = true; }
    if ( nFilters > 0 ) { sFilters = true; }

    //halt if CollectionData or Files sections not found in configuration file
    if ( sCollectionData == false )
        {
        WSHShell.Popup ( 'ERROR: Data is incomplete in configuration file:\n' + f, 0, mbTitle, 16 );
        WScript.Echo ( 'ERROR: Data is incomplete in configuration file:\n' + f );
        WSHShell = null; WScript.Quit();
        }

    //halt if file list is empty
    if ( sFiles == false )
        {
        WSHShell.Popup ( 'ERROR: File list missing from configuration file:\n' + f, 0, mbTitle, 16 );
        WScript.Echo ( 'ERROR: File list missing from configuration file:\n' + f );
        WSHShell = null; WScript.Quit();
        }

    //set default Language ID
    if ( langid == '' ) { langid = '1033'; }

    //halt if source or dest directories not specified
    if ( ( installsrc == null || installsrc == '' ) || ( installdest == null || installdest == '' ) )
        {
        WSHShell.Popup ( 'ERROR: Installation directory not specified configuration file:\n' + f, 0, mbTitle, 16 );
        WScript.Echo ( 'ERROR: Installation directory not specified configuration file:\n' + f );
        WSHShell = null; WScript.Quit();
        }

    //use path refs (if any) in file list when copying from source?
    //check for an asterisk at end of installsrc; asterisk indicates
    //that all source files are stored in the same folder on install media,
    //and only the file names from file list are appended to installsrc path
    var useFileListPaths = true;
    if ( installsrc.substr ( installsrc.length -1, 1 ) == '*' )
        {
        useFileListPaths = false;
        installsrc = installsrc.substr ( 0, installsrc.length -1 );
        }
    installsrc = fo.GetAbsolutePathName ( installsrc ) + '\\';

    //test source folder
    if ( !fo.folderExists ( installsrc ) )
        {
        WSHShell.Popup ( 'ERROR: Help file source installation path:\n' + installdest + '\nnot found', 0, mbTitle, 16 );
        WScript.Echo ( 'ERROR: Help file source installation path:\n' + installdest + '\nnot found' );
        WSHShell = null; WScript.Quit();
        }

    //expand bds destination directory
    if ( installdest == 'bdsdocs' )
        {
        installdest = fo.GetAbsolutePathName(bdsRoot);
        }

    //expand frameworksdk destination directory
    if ( installdest == 'sdkdocs' )
        {
        installdest = fo.GetAbsolutePathName(sdkRoot);
        //if not English, add lang. folder to sdkdoc path
        //if ( langid != '' && langid != '1033' )
        //    {
        //    installdest = fo.GetAbsolutePathName(sdkRoot + '\\' + langid);
        //    }
        if ( args(0) == 3 ) { a = 0; }
        if ( args(0) == 2 ) { a = 1; }
        }

    //expand, if necessary, and test install target path; abort if not found
    if ( installdest != bdsRoot && installdest != sdkRoot && installdest.toLowerCase().substr ( 0,2 ) == 'hk' )
        {
        try
            {
            installdest = fo.GetAbsolutePathName(WSHShell.RegRead(installdest)) + '\\';
            }
        catch (err_installdest)
            {
            WSHShell.Popup ( 'ERROR: Registry key:\n' + installdest + '\nnot found', 0, mbTitle, 16 );
            WScript.Echo ( 'ERROR: Registry key:\n' + installdest + '\nnot found' );
            WSHShell = null; WScript.Quit();
            }
        }
    else
        {
        installdest = fo.GetAbsolutePathName ( installdest ) + '\\';
        }

    //for installs, folders are created on file copy; for other operations, exit if installdest not found
    if ( args(0) != 2 && !fo.folderExists ( installdest ) )
        {
        WSHShell.Popup ( 'ERROR: Help file installation path:\n' + installdest + '\nnot found', 0, mbTitle, 16 );
        WScript.Echo ( 'ERROR: Help file installation path:\n' + installdest + '\nnot found' );
        WSHShell = null; WScript.Quit();
        }

    //halt if destination directory < 2MB
    if ( args(0) != 0 && args(0) != 3 )
        {
        checkDrive ( fo.GetDrive(fo.GetDriveName(installdest)), 2000000 );
        }

    //assign default namespace to nsparent
    if ( inamespace != '' && inamespace == parentNamespace )
        { nsparent = inamespace; }

    WScript.Echo ( 'Configuration file: ' + fo.GetFileName(f) + ' [' + a + ']');

    //all but the parent namespace should have a parent specified
    var parentHXC = '', parentTOC = '';

    if ( nsparent == '' )
        {
        WSHShell.Popup ( 'ERROR: Parent namespace not specified in configuration file.', 0, mbTitle, 16 );
        WScript.Echo ( 'ERROR: Parent namespace not specified in configuration file.' );
        WSHShell = null; WScript.Quit();
        }
    else
        {
        if ( nsparent != parentNamespace && inamespace != parentNamespace )
            {
            WSHShell.Popup ( 'ERROR: Parent namespace unavailable.', 0, mbTitle, 16 );
            WScript.Echo ( 'ERROR: Parent namespace unavailable.' );
            WSHShell = null; WScript.Quit();
            }
        else
            {
            parentHXC = getNamespacePath(nsparent).toLowerCase();
            if ( parentHXC != '' )
                {
                parentTOC = parentHXC.replace ( '.hxc', '.hxt' );
                }
            }
        }

    if ( a == 3 ) { a = 0; } //param 3=file removal;
    //note: setting to 0 here allows removal of registration data prior to file removal

    //fix path references (if any) on file list items, create expanded file list
    var reSlash = new RegExp ('/','g');
    var fileList = new ActiveXObject ( 'Scripting.Dictionary' );
    var fName = '', fPath = '';
    var hxc = '', hxt = '', hxa = '';
    for ( i in arrFiles )
        {
        if ( arrFiles[i] != '' )
            {
            arrFiles[i] = arrFiles[i].replace ( reSlash, '\\' );
            while ( arrFiles[i].substr ( arrFiles[i].length ) == '\\' )
                { arrFiles[i] =  arrFiles[i].substr ( 0, arrFiles[i].length - 1 ) }
            while ( arrFiles[i].substr ( 0,1 ) == '\\' )
                { arrFiles[i] =  arrFiles[i].substr ( 1 ) }
            fName = fo.GetFileName (arrFiles[i]);
            if ( useFileListPaths == false )
                { fPath = installsrc + fName; }
            else
                { fPath = installsrc + arrFiles[i]; }
            if ( !fileList.exists ( fName.toLowerCase() ) )
                {
                fileList.Add ( fName.toLowerCase(), fPath + ',' + installdest + arrFiles[i] );
                if ( fo.GetExtensionName ( fName.toLowerCase() ) == 'hxc' )
                    { hxc = installdest + arrFiles[i]; }
                if ( fo.GetExtensionName ( fName.toLowerCase() ) == 'hxt' )
                    { hxt = installdest + arrFiles[i]; }
                if ( fo.GetExtensionName ( fName.toLowerCase() ) == 'hxa' )
                    { hxa = installdest + arrFiles[i]; }
                }
            }
        }

    //reassign arrFiles array
    var arrFiles = ( new VBArray(fileList.Keys())).toArray();
    var sep = -1;

    //file installation: if called, run before any reg ops
    var sp1='', sp2='', cleanTemp = false;
    if ( a == 2 && installdest != sdkRoot )
        {
        sp1 = '' + fo.GetParentFolderName ( scriptPath );
        sp2 = '' + fo.GetSpecialFolder(2);
        if ( sp1.toLowerCase() == sp2.toLowerCase() )
            {
            cleanTemp = true;
            }

        var file2copy='', fileDest='', copyRet=0, exAll=false;
        if ( arrFiles != null && arrFiles.length != 0 )
            {
            for ( i in arrFiles )
                {
                sep = fileList(arrFiles[i]).indexOf ( ',' );
                file2copy = fileList(arrFiles[i]).substr ( 0, sep );
                fileDest = fileList(arrFiles[i]).substr ( sep + 1 );
                copyRet = updateFile ( file2copy, fileDest, exAll, versioning );
                WScript.Echo ( 'Copied [' + copyRet + ']: ' + fo.GetFileName(file2copy) );
                if ( copyRet == 0 && exAll == false ) { exAll = true };

                if ( cleanTemp == true )
                    {
                    try
                        {
                        fo.DeleteFile ( file2copy );
                        }
                    catch ( err_tmpfiledelete )
                        { }
                    }
                }
            }
        a = 1; //reset action to perform reg functions
        }

    // ==== perform reg/rem functions ====

    // remove filters
    if ( a == 0 && arrFilters != null && arrFilters.length != 0 )
        {
        var fltName = '';
        for ( i in arrFilters )
            {
            sep = arrFilters[i].indexOf ( ',' );
            if ( sep != -1 )
                {
                fltName = trimit(arrFilters[i].substr(0,sep));
                if ( fltName.substr ( 0,1 ) == '*' )
                    { fltName = fltName.substr(1); fltNS = inamespace } else { fltNS = nsparent; };
                var fltRet = rFilter ( 0, fltNS, fltName );
                if ( fltRet == true )
                    {
                    WScript.Echo ( 'Removed filter [' + fltRet + ']: ' + fltName );
                    }
                }
            }
        }

    // remove a plugin (must occur before namespace removal)
    if ( a == 0 && inamespace != ''
        && nsparent != ''
        && parentTOC != ''
        && hxt != '' && hxa != ''
        && mergetype == 'plugin' )
        {
        var pluginRet = rPlugin ( 0, nsparent, parentTOC, inamespace, hxt, hxa, 0 );
        WScript.Echo ( 'Removed plugin [' + pluginRet + ']: ' + inamespace );
        }

    // register or remove a namespace
    var nsRemoved = false;
    if ( a < 3 && inamespace != '' && hxc != '' && fo.fileExists ( hxc ) )
        {
        if ( nsdescription == null ) { nsdescription = 'Help file'; }
        var nsRet = rNamespace ( a, inamespace, hxc, nsdescription, 0 );
        if ( a == 0 && nsRet == true ) { nsRemoved = true; }
        }

    if ( args(0) == 3 && getNamespacePath(nsparent) == '' )
        {
        nsRemoved = true;
        }

    // add or remove namespace registration on installed files
    var hxsFull='', hxiFull='', hxBase='', rspace = nsparent;
    if ( a < 3 && nsparent != ''
        && arrFiles != null && arrFiles.length != 0
        && langid != '' && nsRemoved == false )
        {
        var destDrive, dCheck;
        if ( inamespace != '' ) { rspace = inamespace; }
        for ( i in arrFiles )
            {
            sep = fileList(arrFiles[i]).indexOf ( ',' );
            hxsFull = fileList(arrFiles[i]).substr ( sep + 1 );
            if ( hxsFull != '' )
                {
                if ( fo.GetExtensionName(hxsFull).toLowerCase() == 'hxs' )
                    {
                    hxBase = fo.GetBaseName(hxsFull).toLowerCase();
                    if ( !fileList.exists ( hxBase + '.hxi' ) )
                        {
                        hxiFull = hxsFull;
                        }
                    else
                        {
                        hxiFull = hxsFull.toLowerCase().replace ( '.hxs', '.hxi' ); //
                        }
                    }
             if ( fo.fileExists ( hxsFull ) && fo.fileExists ( hxiFull ) )
                    {
                    if ( a != 0 )
                        {
                        destDrive = fo.GetDrive(fo.GetDriveName(fo.GetParentFolderName(hxiFull)));
                        dCheck = checkDrive ( destDrive, fo.GetFile(hxiFull).size * 2 );
                        }
                    else
                        { dCheck = true; }
                    if ( dCheck == true )
                        {
                        fileRet = rFile ( a, rspace, hxBase, langid, hxsFull, hxiFull );
                        WScript.Echo ( 'Registered [' + a + ']: ' + fo.GetFileName ( hxsFull ) );
                        }
                    }
                }
            hxsFull = ''; hxiFull = ''; hxBase = ''; fileRet = '';
            }
        }

    // register a plugin (must occur after registration of child namespace)
    if ( a == 1 && inamespace != ''
        && nsparent != ''
        && parentTOC != ''
        && hxt != '' && hxa != ''
        && mergetype == 'plugin' )
        {
        WScript.Echo ( hxt + ' ' + hxa );
        var pluginRet = rPlugin ( 1, nsparent, parentTOC, inamespace, hxt, hxa, 0 );
        WScript.Echo ( 'Registered plugin [' + pluginRet + ']: ' + inamespace );
        }

    // register filters
    if ( a == 1 && arrFilters != null && arrFilters.length != 0 )
        {
        var fltName = '', fltSpec = '';
        for ( i in arrFilters )
            {
            sep = arrFilters[i].indexOf ( ',' );
            if ( sep != -1 )
                {
                fltName = trimit(arrFilters[i].substr(0,sep));
                fltSpec = trimit(arrFilters[i].substr(sep + 1));
                if ( fltName.substr ( 0,1 ) == '*' )
                    { fltName = fltName.substr(1); fltNS = inamespace } else { fltNS = nsparent; };
                var fltRet = rFilter ( 1, fltNS, fltName, fltSpec );
                WScript.Echo ( 'Added filter [' + fltRet + ']: ' + fltName );
                }
            }
        }

    // insert merge TOC into parent TOC
    if ( a == 1 && mergetype == 'merge'
         && parentTOC != ''
         && mergetoctitle != ''
         && arrFiles != null && arrFiles.length != 0
         )
        {
        if ( fo.fileExists ( parentTOC ) )
            {
            //if parentTOC readonly, reset attributes so it can be rewritten
            var fPT = fo.GetFile(parentTOC);
            if ( fPT.attributes > 0 ) { fPT.attributes = 0; }
            }
        else
            {
            //WSHShell.Popup ( 'Parent TOC not found.', 0, mbTitle, 16 );
            WScript.Echo ( 'Parent TOC not found.' );
            WSHShell = null; WScript.Quit();
            }
        var foundTOCtitle = false;
        var tocBase = fo.GetParentFolderName(parentTOC) + '\\' + fo.GetBaseName(parentTOC);
        var tmpTOC = fo.CreateTextFile( tocBase + '.tmp', true );
        var toc = fo.OpenTextFile ( parentTOC, 1, false );
        while ( !toc.AtEndOfStream )
            {
            tocData = trimit(toc.readline());
            if ( tocData.indexOf ( '<HelpTOCNode Title="' + mergetoctitle + '" ' ) != -1 )
                {
                foundTOCtitle = true;
                }
            if ( tocData == '</HelpTOC>' && foundTOCtitle == 0 )
                {
                tmpTOC.write ( '<HelpTOCNode Title="' + mergetoctitle + '" ' );
                if ( mergetocurl != '' )
                    {
                    tmpTOC.write ( 'Url="' + mergetocurl + '"' );
                    }
                tmpTOC.write ( '>\n' );
                for ( i in arrFiles )
                    {
                    if ( fo.GetExtensionName(arrFiles[i]) == 'hxs' )
                        {
                        tmpTOC.writeline ( '<HelpTOCNode NodeType="TOC" Url="' + fo.GetBaseName(arrFiles[i]) + '"/>' );
                        }
                    }
                tmpTOC.writeline ( '</HelpTOCNode>\n' );
                }
            tmpTOC.writeline ( tocData );
            }
        toc.close();
        tmpTOC.close();
        if ( foundTOCtitle == false )
            {
            fo.CopyFile ( tocBase + '.tmp', parentTOC );
            WScript.Echo ( 'Updated main TOC [+]' );
            }
        fo.DeleteFile ( tocBase + '.tmp' );
        }

    // remove inserted TOC from parent TOC (merged TOC)
    if ( a == 0 && mergetype == 'merge'
        && parentTOC != ''
        && mergetoctitle != ''
        && nsRemoved == false )
        {
        if ( !fo.fileExists ( parentTOC ) )
            {
            //WSHShell.Popup ( 'Parent TOC not found.', 0, mbTitle, 16 );
            WScript.Echo ( 'Parent TOC not found.' );
            WSHShell = null; WScript.Quit();
            }
        var foundTOCtitle = false;
        var tocBase = fo.GetParentFolderName(parentTOC) + '\\' + fo.GetBaseName(parentTOC);
        var tmpTOC = fo.CreateTextFile( tocBase + '.tmp', true );
        var toc = fo.OpenTextFile ( parentTOC, 1, false );
        while ( !toc.AtEndOfStream )
            {
            tocData = trimit(toc.readline());
            if ( tocData.indexOf ( '<HelpTOCNode Title="' + mergetoctitle + '" ' ) != -1 )
                {
                foundTOCtitle = true;
                while ( !toc.AtEndOfStream && tocData != '</HelpTOCNode>' )
                    { tocData = trimit(toc.readline()); }
                if ( tocData == '</HelpTOCNode>' )
                    { tocData = trimit(toc.readline()); }
                if ( tocData == '' )
                    { tocData = trimit(toc.readline()); }
                }
            tmpTOC.writeline ( tocData );
            }
        toc.close();
        tmpTOC.close();
        if ( foundTOCtitle == true )
            {
            fo.CopyFile ( tocBase + '.tmp', parentTOC );
            WScript.Echo ( 'Updated main TOC [-]' );
            }
        fo.DeleteFile ( tocBase + '.tmp' );
        }

    // remove installed files
    if ( args(0) == 3 && installdest != sdkRoot )
        {
        var rmFile = '', delRet;
        if ( arrFiles != null && arrFiles.length != 0 )
            {
            for ( i in arrFiles )
                {
                sep = fileList(arrFiles[i]).indexOf ( ',' );
                hxsFull = fileList(arrFiles[i]).substr ( sep + 1 );
                if ( hxsFull != '' && fo.fileExists ( hxsFull ) )
                    {
                    delRet = fo.DeleteFile ( hxsFull, true );
                    WScript.Echo ( 'Deleted file: ' + arrFiles[i] );
                    }
                }
            hxsFull = '';
            }
        }

return retMain;

}

/*************************************************
expands path of specified configuration file, if necessary,
and verifies existence of the file
*/
function checkConfig(f)
{
f = fo.GetAbsolutePathName(trimit(f));
if ( !fo.FileExists ( f ) )
    {
    if ( !fo.FileExists ( scriptPath + f ) )
        {
        WSHShell.Popup ( 'Configuration file not found:\n' + f, 0, mbTitle, 16 );
        WScript.Echo ( 'Configuration file not found.' );
        WSHShell = null; WScript.Quit();
        }
    else
        {
        f = scriptPath + f;
        }
    }
return f;
}

/*************************************************
returns the path of specified namespace
(for verifying namespace and locating *.hx? files)
*/
function getNamespacePath(ns)
{
var r = '';
    try
        {
        var oRegSess = new ActiveXObject('HxDs.HxRegisterSession');
        oRegSess.CreateTransaction('');
        var oRegNS = oRegSess.GetRegistrationObject(0);
        if ( oRegNS.IsNamespace(ns) )
            {
            r = oRegNS.GetCollection(ns);
            }
        oRegSess.CommitTransaction();
        oRegNS=null;
        oRegSess=null;
        }
    catch(err_getnamespacepath)
        {
        oRegNS=null;
        oRegSess=null;
        r = '';
        }
return r;
}

/*************************************************
copies or updates files from source media
to specified position in product installation
(uses date/time stamps for comparison)
*/
function updateFile ( sf, df, q, vStr )
{
var cpRet;
var xCopy = false ;
var fsrc, fdst, dsRet, destDrive, dCheck, qVer, fxExt, sFV = '', dFV = '' ;
if ( fo.fileExists ( sf ) )
    {
    try
        {
        fsrc = fo.GetFile(sf);
        if ( fo.fileExists ( df ) )
            {
            fdst = fo.GetFile(df);
			if ( q == false )
				{
				if ( vStr == 'file' || vStr == 'extended' )
					{
					fxExt = fo.GetExtensionName ( sf ).toLowerCase();
					if ( fxExt == 'hxa' || fxExt == 'hxt'
						|| fxExt == 'hxk' || fxExt == 'hxc' )
						{
						sFV = getVersionAttrib(sf);
						dFV = getVersionAttrib(df);
						}
					else
						{
						if ( fxExt.substr ( 0, 2 ) == 'hx' )
							{
							sFV = fo.GetFileVersion(sf);
							dFV = fo.GetFileVersion(df);
							}
						}
					}
				switch ( vStr )
					{
					case 'date':
						if ( fdst.DateLastModified < fsrc.DateLastModified )
						{
						xCopy = true;
						} break;
					case 'file':
						if ( Math.abs(sFV) > Math.abs(dFV) )
						{
						xCopy = true;
						} break;                
					case 'extended':
						if ( q == false )
						{
							var sVerFull=sFV.split('.');
							var dVerFull=dFV.split('.');
							if ( sVerFull.length > 1 && dVerFull.length > 1 && sVerFull != null && dVerFull != null )
								{
								var sVerNum = Math.abs (sVerFull[0] + sVerFull[1]);
								var dVerNum = Math.abs (dVerFull[0] + dVerFull[1]);
								var sVerSku = sVerFull[2]; var dVerSku = dVerFull[2];
								var sVerLng = sVerFull[3]; var dVerLng = dVerFull[3];
								}
							if ( sVerSku != dVerSku )
								{
								qVer = WSHShell.Popup ( 'You are about to overwrite existing Help with Help from a different edition of the product. Proceed?', 0, mbTitle, 33 );
								if ( qVer == 1 )
									{
									q = true;
									xCopy = true;
									}
								else
									{
									WSHShell.Popup ( 'Help maintenance operation concluded.', 0, mbTitle, 64 );
									WScript.Echo ( 'Help maintenance operation concluded.' );
									WSHShell = null; WScript.Quit(); 
									}
								}
							if ( sVerLng != dVerLng )
								{
								qVer = WSHShell.Popup ( 'You are about to overwrite existing Help with a different localized version. Proceed?', 0, mbTitle, 33 );
								if ( qVer == 1 )
									{
									q = true;
									xCopy = true;
									}
								else
									{
									WSHShell.Popup ( 'Help maintenance operation concluded.', 0, mbTitle, 64 );
									WScript.Echo ( 'Help maintenance operation concluded.' );
									WSHShell = null; WScript.Quit(); 
									}
								}
							if ( sVerNum > dVerNum )
								{
								xCopy = true;
								}
							}
						else
							{
							xCopy = true;
							}
						break;
					default: xCopy = true;
					} // end switch
				}
			else
				{
				xCopy = true;
				}

            if ( xCopy == true )
                {
                destDrive = fo.GetDrive(fo.GetDriveName(fo.GetParentFolderName(df)));
                checkDrive ( destDrive, ( fsrc.size * 2 ) - ( fdst.size ) );
                try
                    {
                    if ( fdst.attributes > 0 ) { fdst.attributes = 0; }
                    }
                catch ( err_attrchange )
                    {
                    cpRet = -1;
                    }
                try
                    {
                    fo.copyFile ( sf, df, true );
                    if ( q == true ) { cpRet = 0; } else { cpRet = 1; }
                    }
                catch ( err_copydest )
                    {
                    cpRet = -1;
                    }
                }
            else { cpRet = -1; }
            }
        else
            {
            try
                {
                if ( !fo.folderExists(fo.GetParentFolderName(df)) )
                    {
                    createFoldersFromPath ( df );
                    }
                fo.copyFile ( sf, df, true );
                if ( q == true ) { cpRet = 0; } else { cpRet = 1; }
                }
            catch ( err_copynodest )
                {
                cpRet = -1;
                }
            }
        }
    catch ( err_updatefile )
        {
        cpRet = -1;
        }
    }
else
    {
    cpRet = -1;
    }
return cpRet;
}

/*************************************************
check filter data
*/
function checkFilter(fds)
{
fRet = true;
    if ( fds.indexOf ( '=' ) == -1
        || fds.indexOf ( ',' ) != -1
        || ( ( fds.substr ( 0, 1 ) != '"' || fds.substr ( 0, 1 ) != '(' )
            && ( fds.substr ( fds.length - 1, 1 ) != '"' || fds.substr ( fds.length - 1, 1 ) != ')' ) )
        || ( fds.substr ( 0, 1 ) == '"' && fds.substr ( fds.length - 1, 1 ) != '"' )
        || ( fds.substr ( 0, 1 ) == '(' && fds.substr ( fds.length - 1, 1 ) != ')' )
        || fds.split('(').length != fds.split(')').length )
        { fRet = false; }
    if ( fds.indexOf ( '=' ) != -1 && ( fds.split('=').length-1 ) * 4 != fds.split('"').length-1 )
        { fRet = false; }
return fRet;
}

/*************************************************
check drive readiness and space availability
*/
function checkDrive ( pDrive, spaceReq )
{
if ( !pDrive.IsReady )
    {
    WSHShell.Popup ( 'Drive ' + progDrive + ' is not available for Help installation. Halting setup.', 0, mbTitle, 16 );
    WScript.Echo ( 'Drive ' + progDrive + ' is not available for Help installation. Halting setup.' );
    WSHShell = null; WScript.Quit();
    }
if ( pDrive.FreeSpace <= spaceReq )
    {
    WSHShell.Popup ( 'Drive ' + progDrive + ' does not have sufficient space available for Help installation. Halting setup.', 0, mbTitle, 16 );
    WScript.Echo ( 'Drive ' + progDrive + ' does not have sufficient space available for Help installation. Halting setup.' );
    WSHShell = null; WScript.Quit();
    }
return true;
}

/*************************************************
register or remove plugin (rr 0 = remove)
*/
function rPlugin(rr, ns, nsHXT, ns2, ns2HXT, ns2HXA, longOpts)
{
var r = false;
    try
        {
        var oRegSess = new ActiveXObject('HxDs.HxRegisterSession');
        oRegSess.CreateTransaction('');
        var oRegPlugin = oRegSess.GetRegistrationObject(2);
        if ( rr != 0 )
            {
            oRegPlugin.RegisterHelpPlugIn(ns, nsHXT, ns2, ns2HXT, ns2HXA, longOpts);
            }
        else
            {
            oRegPlugin.RemoveHelpPlugIn(ns, nsHXT, ns2, ns2HXT, ns2HXA);
            }
        oRegSess.CommitTransaction();
        oRegPlugin=null;
        oRegSess=null;
        r = true;
        }
    catch(err_rplugin)
        {
        oRegPlugin=null;
        oRegSess=null;
        r = false;
        }
return r;
}

/*************************************************
register or remove namespace (rr 0 = remove)
*/
function rNamespace(rr,ns,colFile,colDesc)
{
var r = false;
    try
        {
        var oRegSess = new ActiveXObject('HxDs.HxRegisterSession');
        oRegSess.CreateTransaction('');
        var oRegNS = oRegSess.GetRegistrationObject(0);
        if ( rr != 0 ) { oRegNS.RegisterNamespace(ns, colFile, colDesc); }
        else { oRegNS.RemoveNamespace(ns); }
        oRegSess.CommitTransaction();
        oRegNS=null;
        oRegSess=null;
        r = true;
        }
    catch ( err_rnamespace )
        {
        oRegNS=null;
        oRegSess=null;
        r = false;
        }

return r;
}

/*************************************************
register or remove files (rr 0 = remove)
*/
function rFile (rr,ns,bn,li,xs,xi)
{
var r = false;
    try
        {
        var oRegSess = new ActiveXObject('HxDs.HxRegisterSession');
        oRegSess.CreateTransaction('');
        var oRegFiles = oRegSess.GetRegistrationObject(0);
        if ( rr != 0 )
            {
            oRegFiles.RegisterHelpFileSet( ns, bn, li, xs, xi,"","",0,0,0,0);
            }
        else
            {
            oRegFiles.RemoveHelpFile( ns, bn, li );
            }
        oRegSess.CommitTransaction();
        oRegFiles=null;
        oRegSess=null;
        r = true;
        }
    catch ( err_rfile )
        {
        oRegFiles=null;
        oRegSess=null;
        r = false;
        }
return r;
}

/*************************************************
register or remove filters (rr 0 = remove)
*/
function rFilter ( rr, ns, filterName, filterData )
{
    try
    {
        var oRegSess = new ActiveXObject('HxDs.HxRegisterSession');
        oRegSess.CreateTransaction('');
        var oRegFilter = oRegSess.GetRegistrationObject(1);
        oRegFilter.SetNamespace(ns);
        oRegFilter.SetCollectionFiltersFlag(1);
        if ( rr != 0 ) { oRegFilter.RegisterFilter( filterName, filterData ); }
        else { oRegFilter.RemoveFilter( filterName ); }
        oRegSess.CommitTransaction();
        oRegSess=null;
        oRegFilter=null;
        return true;
    }
    catch (err_rfilter)
        {
        oRegFilter=null;
        oRegSess=null;
        r = false;
        }
return r;
}

/*************************************************
create a shortcut to namespace
*/
function createHelpShortcut( ns, scLoc, dxLoc )
{
var scRet = false;
    try
        {
        var sFile = scLoc //+ '.lnk';
        if ( fo.fileExists ( sFile ) ) { fo.deleteFile ( sFile, true ); }
        var osl = WSHShell.CreateShortcut( sFile );
        osl.TargetPath = dxLoc + 'dexplore.exe';
        osl.Arguments = ' /helpcol ms-help://' + ns;
        osl.WindowStyle = 1;
        osl.IconLocation = dxLoc + "dexplore.exe, 0";
        osl.Description = ns + ' Help';
        osl.WorkingDirectory = dxLoc;
        osl.Save();
        scRet = true;
        }
    catch (err_createhelpshortcut)
        {
        scRet = false;
        }
return scRet;
}

/*************************************************
creates folders for file copy operations
*/
function createFoldersFromPath ( fp )
{
cpr = false;
var fpx = fo.GetParentFolderName(fo.GetAbsolutePathName ( fp ));
fps = fpx.split ( '\\' );
var i, cPath=fps[0] + '\\';
for ( i=1; i<fps.length; i++ )
    {
    cPath += fps[i] + '\\';
    if ( !fo.FolderExists ( cPath ) )
    try
        {
        fo.CreateFolder ( cPath );
        }
    catch ( err_createfoldersfrompath )
        {
        WSHShell.Popup ( 'ERROR: Failed to create folder:\n' + cPath, 0, WScript.ScriptName, 16 ) ;
        WScript.Echo ( 'ERROR: Failed to create folder:\n' + cPath );
        WSHShell = '' ; WScript.Quit() ;
        }
    }
if ( fo.FolderExists ( cPath ) ) { cpr = true; }
return cpr;
}

/**************************************************/
function getVersionAttrib(f)
{
var fx = fo.OpenTextFile ( f, 1, false );
var fxs = '', fv = '', fvStart = -1, fvEnd = -1, tagEnd = -1;
    while ( !fx.AtEndOfStream )
        {
		fxs = trimit(fx.readline());
		if ( fxs.indexOf ( 'FileVersion' ) != -1 )
			{
			fvStart = fxs.indexOf ( 'FileVersion' ) + 11;
			tagEnd = fxs.indexOf ( '>', fvStart );
			if ( tagEnd == -1 )
				{
				while ( !fx.AtEndOfStream && tagEnd == -1 )
					{
					fxs += trimit(fx.readline());
					tagEnd = fxs.indexOf ( '>' );
					}
				}
			fv = fxs.substr ( fvStart, tagEnd - fvStart );
			break;
			}
		}
fx.close();

if ( fv != '' && fv.indexOf ('"') != -1 && fv.indexOf ( '=' ) != -1 )
	{
	fvStart = fv.indexOf ( '"' );
	fvEnd = fv.indexOf ( '"', fvStart + 1 );
	if ( fvEnd != -1 )
		{
		fv = trimit(fv.substr ( fvStart + 1, fvEnd - fvStart - 1 ));
		}
	if ( fv.indexOf ( ' ' ) != -1 || fv.indexOf ( '=' ) != -1 || fv.indexOf ( '"' ) != -1 )
		{
		fv = '';
		}
	}
else
	{
	//no ver info found
	fv = '';
	}

return fv;

}

/**************************************************/
function trimit( s )
{
//trims leading and trailing spaces, removes any tabs from string
    var re = /\t/g; //rem tabs as well
    while ( s.charAt ( 0 ) == ' ' ) { s = s.substr ( 1 ) }
    while ( s.charAt ( s.length - 1 ) == ' ' ) { s = s.substr ( 0, s.length - 1 ) }
    s = s.replace ( re, '' );
    return s;
}
