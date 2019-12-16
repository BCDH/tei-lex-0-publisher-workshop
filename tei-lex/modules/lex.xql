xquery version "3.1";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";
import module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config" at "pm-config.xql";

declare option output:method "html5";
declare option output:media-type "text/html";

<div>
    <link rel="stylesheet" type="text/css" href="transform/tei-lex-0.css"/>
{
    let $doc := request:get-parameter("doc", ())
    for $entry in doc($config:data-root || "/" || $doc)//tei:entry
    return
        $pm-config:web-transform($entry, map { }, $config:default-odd)
}
</div>