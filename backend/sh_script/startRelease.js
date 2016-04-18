require('shelljs/global');
var fs = require('fs');
var path = require('path');

if (process.argv.length !== 3) {
    console.log(process.argv);
    console.log('parameter should include version number');
    return;
}

exec('git flow release start '+process.argv[2]);

var fileData = JSON.parse(fs.readFileSync('../package.json', 'utf8'));
fileData.version = process.argv[2];
fs.writeFile('../package.json', JSON.stringify(fileData, null, 2), function(err){
    if(err){
        console.log('release branch '+ process.argv[2]+' version update failed');
        return;
    }else{

    }
});
