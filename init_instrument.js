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
        jo.accounts[address] = {
            "balance": amount
        }
        console.log('Added address: ' + address);
    }   
}

function updateSkaledConfig() {
    console.log("Updating skaled configuration file");
    const strPathSkaledJSON = normalizePath(path.join( __dirname, "config0.json"));
    
    if(!fileExists(strPathSkaledJSON)) {
        console.log( "CRITICAL ERROR: File \"" + strPathSkaledJSON + "\" was not found." );
        process.exit(1);
    }
    
    let jo = jsonFileLoad(strPathSkaledJSON, null, true);
    
    if( process.env.CHAIN_ID_S_CHAIN && process.env.CHAIN_ID_S_CHAIN.length > 0 ) {
        jo.params.chainID = process.env.CHAIN_ID_S_CHAIN;
        console.log('Updated chainId: ' + process.env.CHAIN_ID_S_CHAIN);
    }

    if( process.env.TEST_ADDRESS && process.env.TEST_ADDRESS.length > 0 ) {
        jo.skaleConfig.sChain.schainOwner = process.env.TEST_ADDRESS;
        console.log('Updated sChain owner: ' + process.env.TEST_ADDRESS);
        addAccount(jo, process.env.TEST_ADDRESS);
    }

    if( process.env.ACCOUNT_FOR_SCHAIN && process.env.ACCOUNT_FOR_SCHAIN.length > 0 ) {
        addAccount(jo, process.env.ACCOUNT_FOR_SCHAIN);
    }

    if( process.env.SKALED_LOG_LEVEL && process.env.SKALED_LOG_LEVEL.length > 0 ) {
        jo.skaleConfig.nodeInfo.logLevel = process.env.SKALED_LOG_LEVEL;
        jo.skaleConfig.nodeInfo.logLevelProposal = process.env.SKALED_LOG_LEVEL;
        console.log('Changed skaled log level: ' + process.env.SKALED_LOG_LEVEL);
    }

    jsonFileSave( strPathSkaledJSON, jo, true );
    console.log("Done.");
}

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

updateSkaledConfig();