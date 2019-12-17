xquery version "3.1";

declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="http://www.tei-c.org/tei-simple/config" at "config.xqm";
import module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config" at "pm-config.xql";

declare option output:method "html5";
declare option output:media-type "text/html";

let $query := request:get-parameter("query",  ())
let $id :=  request:get-parameter("lid", ())
let $start := request:get-parameter("start", ())
let $howmany := request:get-parameter("howmany", 5)
let $doc := request:get-parameter("doc", ())
let $cached := session:get-attribute('tei-lex.hits')
let $entries := 
    if (exists($id)) then
        doc($config:data-root || "/" || $doc)/id($id)
    else if  (exists($query) and $query != "") then
        let $searchResult := 
            doc($config:data-root || "/" || $doc)//tei:entry[ft:query(., 'lemma:' || $query)]/ancestor-or-self::tei:entry[last()]
        return (
            $searchResult,
            session:set-attribute('tei-lex.hits', $searchResult)
        )
    else if ($start and exists($cached)) then
        $cached
    else
        doc($config:data-root || "/" || $doc)//tei:entry
let $start :=  if ($start) then $start else 1
let $entriesSubset := subsequence($entries, $start, $howmany)
return (
    response:set-header("pb-total", xs:string(count($entries))),
    response:set-header("pb-start", xs:string($start)),
    <div>
        <link rel="stylesheet" type="text/css" href="transform/tei-lex-0.css"/>
    {
        for $entry in $entriesSubset
        return
            $pm-config:web-transform($entry, map { }, $config:default-odd)
    }
    </div>
)