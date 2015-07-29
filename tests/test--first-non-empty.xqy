(::::::::::
 : Test cases for utilities:first-non-empty()
 :::::::::)

(::::::::::
 : Sample Output
 : 1
 : 1
 : 1
 : c
 : c
 : true
 : 99
 : 1
 : 1
 : 1
 : c
 : c
 : true
 : 99
 ::::::::::)
 
import module namespace utilities = "https://github.com/prestonmcgowan/1.0-ml--utility-functions" at "/app/lib/1.0-ml--utility-functions.xqy";

let $doc := element root{ element val{} }
let $a := (1)
let $b := (1,2)
let $c := (1, "c")
let $d := ("c", 1)
let $e := ("c", "d")
let $f := (fn:true(), "1")
let $z := (99 to 100000)
let $_  := ($doc//fn:data(val))
let $_a := ($doc//fn:data(val), 1)
let $_b := ($doc//fn:data(val), 1,2)
let $_c := (text{()}, 1, "c")
let $_d := (text{()}, "c", 1)
let $_e := (text{()}, "c", "d")
let $_f := ((), fn:true(), "1")
let $_z := ((), 99 to 100000)
return (
  utilities:first-non-empty($a),
  utilities:first-non-empty($b),
  utilities:first-non-empty($c),
  utilities:first-non-empty($d),
  utilities:first-non-empty($e),
  utilities:first-non-empty($f),
  utilities:first-non-empty($z),
  utilities:first-non-empty($_),
  utilities:first-non-empty($_a),
  utilities:first-non-empty($_b),
  utilities:first-non-empty($_c),
  utilities:first-non-empty($_d),
  utilities:first-non-empty($_e),
  utilities:first-non-empty($_f),
  utilities:first-non-empty($_z)
)