const fs = require( "fs" );
const path = require( "path" );
const os = require( "os" );

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

function normalizePath( strPath ) {
    strPath = strPath.replace( /^~/, os.homedir() );
    strPath = path.normalize( strPath );
    strPath = path.resolve( strPath );
    return strPath;
}

function fileExists( strPath ) {
    try {
        if( fs.existsSync( strPath ) ) {
            const stats = fs.statSync( strPath );
            if( stats.isFile() )
                return true;
        }
    } catch ( err ) {}
    return false;
}

function fileLoad( strPath, strDefault ) {
    strDefault = strDefault || "";
    if( !fileExists( strPath ) )
        return strDefault;
    try {
        const s = fs.readFileSync( strPath );
        return s;
    } catch ( err ) {}
    return strDefault;
}

function fileSave( strPath, s ) {
    try {
        fs.writeFileSync( strPath, s );
        return true;
    } catch ( err ) {}
    return false;
}

function jsonFileLoad( strPath, joDefault, bLogOutput ) {
    if( bLogOutput == undefined || bLogOutput == null )
        bLogOutput = false;
    joDefault = joDefault || {};
    if( bLogOutput )
        console.log( "Will load JSON file \"" + strPath + "\"..." );
    if( !fileExists( strPath ) ) {
        if( bLogOutput )
            console.log( "Cannot load JSON file \"" + strPath + "\", it does not exist" );
        return joDefault;
    }
    try {
        const s = fs.readFileSync( strPath );
        if( bLogOutput )
            console.log( "Did loaded content of JSON file \"" + strPath + "\", will parse it..." );
        const jo = JSON.parse( s );
        if( bLogOutput )
            console.log("Done, loaded content of JSON file \"" + strPath + "\"." );
        return jo;
    } catch ( err ) {
        if( bLogOutput )
            console.log( "CRITICAL ERROR: failed to load JSON file \"" + strPath + "\": " + err.toString() );
    }
    return joDefault;
}

function jsonFileSave( strPath, jo, bLogOutput ) {
    if( bLogOutput == undefined || bLogOutput == null )
        bLogOutput = false;
    if( bLogOutput )
        console.log( "Will save JSON file \"" + strPath + "\"..." );
    try {
        const s = JSON.stringify( jo, null, 4 );
        fs.writeFileSync( strPath, s );
        if( bLogOutput )
            console.log( "Done, saved content of JSON file \"" + strPath + "\"." );
        return true;
    } catch ( err ) {
        if( bLogOutput )
            console.log( "CRITICAL ERROR: failed to save JSON file \"" + strPath + "\": " + err.toString() );
    }
    return false;
}

function addAccount(config, address, amount="1000000000000000000000000000000") {
    if (address in config.accounts) {
        console.log('Address ' + address + ' is already in accounts section');
    } else {
        config.accounts[address] = {
            "balance": amount
        }
        console.log('Added address: ' + address);
    }   
}


function processGanacheTemplate(templatePath, destPath, value) {
    fs.readFile(templatePath, 'utf8', function (err,data) {
        if (err) {
          return console.log(err);
        }
        var result = data.replace(/{{ additionalAccounts }}/g, value);
        fs.writeFile(destPath, result, 'utf8', function (err) {
           if (err) return console.log(err);
        });
    });
}

function updateSkaledConfig() {
    console.log("Updating skaled configuration file");
    const strPathSkaledJSON = normalizePath(path.join( __dirname, "config0.json"));
    const additionalAccountsPath = normalizePath(path.join( __dirname, "additional_accounts.json"));
    
    if(!fileExists(strPathSkaledJSON)) {
        console.log( "CRITICAL ERROR: File \"" + strPathSkaledJSON + "\" was not found." );
        process.exit(1);
    }
    
    let config = jsonFileLoad(strPathSkaledJSON, null, true);
    
    if( process.env.CHAIN_ID_S_CHAIN && process.env.CHAIN_ID_S_CHAIN.length > 0 ) {
        config.params.chainID = process.env.CHAIN_ID_S_CHAIN;
        console.log('Updated chainId: ' + process.env.CHAIN_ID_S_CHAIN);
    }

    if( process.env.TEST_ADDRESS && process.env.TEST_ADDRESS.length > 0 ) {
        config.skaleConfig.sChain.schainOwner = process.env.TEST_ADDRESS;
        console.log('Updated sChain owner: ' + process.env.TEST_ADDRESS);
        addAccount(config, process.env.TEST_ADDRESS);
    }

    if( process.env.ACCOUNT_FOR_SCHAIN && process.env.ACCOUNT_FOR_SCHAIN.length > 0 ) {
        addAccount(config, process.env.ACCOUNT_FOR_SCHAIN);
    }

    if(fileExists(additionalAccountsPath)) {
        let additionalAccounts = jsonFileLoad(additionalAccountsPath, null, true);
        for (const account of additionalAccounts) {
            addAccount(config, account.address);
        }
    }

    if( process.env.SKALED_LOG_LEVEL && process.env.SKALED_LOG_LEVEL.length > 0 ) {
        config.skaleConfig.nodeInfo.logLevel = process.env.SKALED_LOG_LEVEL;
        config.skaleConfig.nodeInfo.logLevelProposal = process.env.SKALED_LOG_LEVEL;
        console.log('Changed skaled log level: ' + process.env.SKALED_LOG_LEVEL);
    }

    jsonFileSave( strPathSkaledJSON, config, true );
    console.log("Done.");
}

function updateGanacheScript() {
    const additionalAccountsPath = normalizePath(path.join( __dirname, "additional_accounts.json"));
    const runGanacheTemplatePath = normalizePath(path.join( __dirname, "scripts/run_ganache.sh.template"));
    const runGanacheScriptPath = normalizePath(path.join( __dirname, "scripts/run_ganache.sh"));
    if(!fileExists(additionalAccountsPath)) {
        processGanacheTemplate(runGanacheTemplatePath, runGanacheScriptPath, '\\');
        return;
    }

    let additionalAccounts = jsonFileLoad(additionalAccountsPath, null, true);
    let accountsGanache = []
    for (const account of additionalAccounts) {
        accountsGanache.push('--account="' + account.private_key + ',100000000000000000000000000" \\')
    }
    const accountsGanacheStr = accountsGanache.join('\n')
    processGanacheTemplate(runGanacheTemplatePath, runGanacheScriptPath, accountsGanacheStr);
}

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

updateSkaledConfig();
updateGanacheScript();