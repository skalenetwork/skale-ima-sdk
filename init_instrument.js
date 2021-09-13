/**
 * @license
 * SKALE skale-ima-sdk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * @file init_instrument.js
 * @copyright SKALE Labs 2021-Present
*/

const fs = require( "fs" );
const path = require( "path" );
const os = require( "os" );


const DEFAULT_ALLOCATED_STORAGE_BYTES = '10737418240';
const REQUIRED_ENV_VARS = ['TEST_ADDRESS', 'SDK_ADDRESS'];
const CONTEXT_CONTRACT_ADDRESS = '0xD2001000000000000000000000000000000000D2';

const NGINX_SSL_CONFIG = 'listen 443 ssl;\n    ssl_certificate     /ssl/ssl_cert;\n    ssl_certificate_key /ssl/ssl_key;'


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

function addContract(config, contract) {
    config.accounts[contract.address] = {
        "balance": "0",
        "code": contract.bytecode,
        "storage": contract.storage,
        "nonce": "0"
    }
    console.log('Added contract: ' + contract.address);
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

function processNginxTemplate(templatePath, destPath, value) {
    fs.readFile(templatePath, 'utf8', function (err,data) {
        if (err) {
          return console.log(err);
        }
        var result = data.replace(/{{ ssl }}/g, value);
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

    if( process.env.SDK_ADDRESS && process.env.SDK_ADDRESS.length > 0 ) {
        addAccount(config, process.env.SDK_ADDRESS);
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

    const allocatedStorage = process.env.FS_BYTES || DEFAULT_ALLOCATED_STORAGE_BYTES;
    updateFsConfig(config, process.env.TEST_ADDRESS, allocatedStorage);

    updateContextContract(config, process.env.TEST_ADDRESS);

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


function updateNginxConfig() {
    const nginxConfigTemplatePath = normalizePath(path.join( __dirname, "conf/nginx.conf.template"));
    const nginxConfigPath = normalizePath(path.join( __dirname, "conf/nginx.conf"));

    const sslCertPath = normalizePath(path.join( __dirname, "ssl/ssl_cert"));
    const sslKeyPath = normalizePath(path.join( __dirname, "ssl/ssl_key"));
    if(!fileExists(sslCertPath) || !fileExists(sslKeyPath)) {
        processNginxTemplate(nginxConfigTemplatePath, nginxConfigPath, '');
        return;
    }
    processNginxTemplate(nginxConfigTemplatePath, nginxConfigPath, NGINX_SSL_CONFIG);
}




function updateFsConfig(config, ownerAddress, allocatedStorage) {
    const fsArtifactsPath = normalizePath(path.join( __dirname, "conf/fs-artifacts.json"));
    const fsArtifacts = jsonFileLoad(fsArtifactsPath, null, true);
    let predeployedConfig = fsArtifacts["predeployedConfig"];
    predeployedConfig['proxyAdmin']['storage']['0x0'] = ownerAddress;
    predeployedConfig['filestorageProxy']['storage']['0x0'] = allocatedStorage;
    addContract(config, predeployedConfig['filestorageProxy']);
    addContract(config, predeployedConfig['proxyAdmin']);
    addContract(config, predeployedConfig['filestorageImplementation']);
}

function updateContextContract(config, ownerAddress) {
    config.accounts[CONTEXT_CONTRACT_ADDRESS].storage['0x0'] = ownerAddress;
    console.log('Updated sChain owner in context contract!');
}


function checkEnvVars() {
    for (const envVar of REQUIRED_ENV_VARS) {
        if (!process.env[envVar]) {
            console.log( "CRITICAL ERROR: ENV VAR \"" + envVar + "\" was not found." );
            process.exit(1);
        }
    }
}


checkEnvVars();
updateSkaledConfig();
updateGanacheScript();
updateNginxConfig();