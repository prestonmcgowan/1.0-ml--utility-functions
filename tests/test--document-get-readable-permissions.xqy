(::::::::::
 : Test cases for document-get-readable-permissions()
 :::::::::)
  
xquery version "1.0-ml";
import module namespace util = 'https://github.com/prestonmcgowan/1.0-ml--utility-functions' at '/1.0-ml--utility-functions.xqy';
declare namespace sec = "http://marklogic.com/xdmp/security";

declare function local:test-hr-permissions($uri as xs:string, $permissions as element(sec:permission)*) as xs:boolean {
  let $perm-count := 0
  let $insert := xdmp:invoke-function(function() {
      xdmp:document-insert($uri, <test></test>, $permissions),
      xdmp:commit()
    }, 
    <options xmlns="xdmp:eval">
      <isolation>different-transaction</isolation>
      <transaction-mode>update</transaction-mode>
    </options>)
  let $perms := xdmp:document-get-permissions($uri)
  let $hr-perms := util:document-get-readable-permissions($uri)
  let $delete := xdmp:document-delete($uri)
  let $log := xdmp:log(($perms, $hr-perms), "debug")
  let $test :=
    if (map:keys($hr-perms)) then
      for $role in map:keys($hr-perms)
        let $role-id := xdmp:role($role)
        let $actual-perms := map:get($hr-perms, $role)
        let $expected-perms := $perms[sec:role-id/text() eq $role-id]/sec:capability/text()
        let $_ := xdmp:set($perm-count, $perm-count + fn:count($actual-perms))
        return 
          for $p in $expected-perms
          return $expected-perms eq $p
    else fn:empty($perms)
  return ($test ne fn:false()) and ($perm-count eq fn:count($perms)) 
};

(: Test default permissions :)
local:test-hr-permissions("/test/test-permissions-doc.xml", xdmp:default-permissions("/test/test-permissions-doc.xml")),
(: Test set permissions :)
local:test-hr-permissions("/test/test-permissions-doc-2.xml", (
  xdmp:permission("admin", "insert"),
  xdmp:permission("admin", "update"),
  xdmp:permission("admin", "read"))
),
(: Test empty permissions :)
local:test-hr-permissions("/test/test-permissions-doc-3.xml", ())
