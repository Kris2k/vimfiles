XPTemplate priority=personal+

let s:f = g:XPTfuncs()

XPTinclude
      \ _common/common


XPT once wrap	" #ifndef .. #define ..
XSET symbol=headerSymbol()
XSET symbol|post=UpperCase(V())
#ifndef `symbol^
#define `symbol^

`cursor^
#endif `$CL^ `symbol^ `$CR^

XPT #ind alias=#include_user

" XPT #include_user   " include ""
" XSET me=fileRoot()
" #include "`me^.h"

