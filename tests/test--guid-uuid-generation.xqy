(::::::::::
 : Test cases for utilities:uuid() and utilities:guid()
 :::::::::)

(: Test UUID length and uniqueness :)
xquery version "1.0-ml";
import module namespace util = 'https://github.com/prestonmcgowan/1.0-ml--utility-functions' at '/1.0-ml--utility-functions.xqy';

let $m := map:map()
for $i in (1 to 10000)
  let $id := util:uuid()
  return (
    if (fn:string-length($id) ne 32) then fn:error(xs:QName('ASSERT'), 'invalid UUID length', $id) else (),
    if (map:contains($m, $id)) then fn:error(xs:QName('ASSERT'), 'non-unique UUID generated', $id) else map:put($m, $id, ''),
    if (fn:not(fn:matches($id, "^[0-9a-f]{32}$"))) then fn:error(xs:QName('ASSERT'), 'invalid UUID characters generated', $id) else ()
  );
  
(: Test GUID length and uniqueness :)
xquery version "1.0-ml";
import module namespace util = 'https://github.com/prestonmcgowan/1.0-ml--utility-functions' at '/1.0-ml--utility-functions.xqy';

let $m := map:map()
for $i in (1 to 10000)
  let $id := util:guid()
  return (
    if (fn:string-length($id) ne 36) then fn:error(xs:QName('ASSERT'), 'invalid GUID length', $id) else (),
    if (map:contains($m, $id)) then fn:error(xs:QName('ASSERT'), 'non-unique GUID generated', $id) else map:put($m, $id, ''),
    if (fn:not(fn:matches($id, "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"))) then fn:error(xs:QName('ASSERT'), 'invalid GUID characters generated', $id) else ()
  );