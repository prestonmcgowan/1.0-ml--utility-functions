xquery version "1.0-ml";

module namespace utilities = "https://github.com/prestonmcgowan/1.0-ml--utility-functions";

import module namespace functx = "http://www.functx.com" at "/MarkLogic/functx/functx-1.0-nodoc-2007-01.xqy";

declare option xdmp:mapping "false";

(: Insert or Replace Child Node
 : Instead of writing the same if/then/else logic block, create a reusable function to do either
 : depending on the availability of the XPath and provided child node.
 :
 : Be like xdmp:node-replace and xdmp:node-insert-child return ()
 :)
declare function utilities:node-insert-or-replace-child($document, $namespaces, $xpath, $child) as empty-sequence() {
  let $base-xpath-str := "$document"||$xpath
  let $xpath-str := 
    switch (xdmp:node-kind($child))
      case "element"   return $base-xpath-str||"/"||fn:node-name($child)
      case "attribute" return $base-xpath-str||"/@"||fn:node-name($child)
      default return ()
  let $parent-node := xdmp:with-namespaces($namespaces, xdmp:unpath($base-xpath-str))
  let $child-node  := xdmp:with-namespaces($namespaces, xdmp:unpath($xpath-str))
  return
    if (fn:empty($parent-node)) then () (: empty parent, return () :)
    else if (fn:empty($child-node)) then xdmp:node-insert-child($parent-node, $child)
    else xdmp:node-replace($child-node, $child)
};

(: Random Hexadecimal
 : Generates a randomized hexadecimal value N characters long.  Given a sequence of
 : sizes, will generate a sequence of cooresponding hex values.
 :
 : Used to generate GUIDs
 :)
declare private function utilities:random-hex($sizes as xs:integer+) as xs:string+ {
  for $i in $sizes return 
    fn:string-join(for $n in 1 to $i
      return xdmp:integer-to-hex(xdmp:random(15)), "")
};

(: Generate GUID
 : Generates a randomized 128 bit Globally Unique Identifier.  The GUID generated is represented
 : by a 32 digit hexadecimal string grouped into 5 blocks.
 :)
declare function utilities:guid() as xs:string {
  fn:string-join(utilities:random-hex((8,4,4,4,12)),"-")
};

(: Generate UUID
 : Generates a randomized 32 hexadecimal digit UUID string.
 :)
declare function utilities:uuid() as xs:string {
  fn:string-join(
    for $i in 1 to 2
      let $v := xdmp:integer-to-hex(xdmp:random())
      let $len := fn:string-length($v)
      return
        if ($len eq 32) then $v
        else functx:pad-string-to-length($v, '0', 16) 
    , ''
  )
};