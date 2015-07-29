(::::::::::
 : Test cases for utilities:node-insert-or-replace-child()
 :::::::::)

(::::::::::
 : Sample Output
 : <before>
 :   <root a="text">
 :     <e>stuff</e>
 :     <x>replace me</x>
 :   </root>
 : </before>
 : <after>
 :   <root a="bcd">
 :     <e foo="d">stuff<ns:bar xmlns:ns="some:name:space">soap</ns:bar></e>
 :     <x>yz</x>
 :   </root>
 : </after>
 ::::::::::)

(: Create sample document :)
xdmp:document-insert("/sample.xml", element root{ attribute a{ "text"}, element e{"stuff"}, element x{"replace me"}})
;
(: Print out the before :)
element before { fn:doc("/sample.xml") }
;
(: Run the tests :)
import module namespace utilities = "https://github.com/prestonmcgowan/1.0-ml--utility-functions" at "/app/lib/1.0-ml--utility-functions.xqy";
declare namespace ns = "some:name:space";
let $doc := fn:doc("/sample.xml")
return (
  (: Add Child Attribute :)
  utilities:node-insert-or-replace-child($doc, ("ns", "somens"), "/root/e", attribute foo{ "d" })
  ,
  (: Add Child Element - with a namespace, because why not :)
  utilities:node-insert-or-replace-child($doc, ("ns", "somens"), "/root/e", element ns:bar{ "soap" })
  ,
  (: Replace Attribute :)
  utilities:node-insert-or-replace-child($doc, ("ns", "somens"), "/root", attribute a{ "bcd" })
  ,
  (: Replace Element :)
  utilities:node-insert-or-replace-child($doc, ("ns", "somens"), "/root", element x{ "yz" })
)
;
(: Print out the after :)
element after { fn:doc("/sample.xml") }
