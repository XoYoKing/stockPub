

var pinyin = require("pinyin");
var alpha = pinyin('华谊', {
    style: pinyin.STYLE_FIRST_LETTER
});
console.log(alpha);
