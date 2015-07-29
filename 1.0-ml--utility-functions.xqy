xquery version "1.0-ml";

module namespace utilities = "https://github.com/prestonmcgowan/1.0-ml--utility-functions";


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

(: Find the first non-empty value and return it
 : We do cast each value to a string find the first non-empty.
 : I also tried this as a recursive function, and it had a few more expression calls
 : and did not seem to make a difference in performance.
 :
 : Recursive version:
 : declare function utilities:first-non-empty($values) {
 :   if (fn:count($values) le 0) then ()
 :   else if (fn:string-length(fn:string($values[1])) gt 0) then $values[1]
 :   else local:first-non-empty-1($values[2 to fn:last()])
 : };
 :)
declare function utilities:first-non-empty($values) {
  $values[fn:string-length(fn:string(.)) gt 0][1]
};