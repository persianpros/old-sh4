AC_INIT(tuxbox-apps-misc-tools,0.0.1,,tuxbox-misc-tools)
AM_INIT_AUTOMAKE(tuxbox-misc-tools,0.0.1)

TUXBOX_APPS

AC_PROG_CC
AC_PROG_CXX
AM_PROG_LIBTOOL

AC_ARG_ENABLE([multicom322], 
        [AS_HELP_STRING(--enable-multicom322,    enable multicom322 stuff)], 
        [case "${enableval}" in 
                yes) enable_multicom322=true ;; 
                no) enable_multicom322=false ;; 
                *) AC_MSG_ERROR([bad value ${enableval} for --enable-multicom322]) ;; 
        esac]) 
AM_CONDITIONAL([ENABLE_MULTICOM322], [test x$enable_multicom322 = xtrue])
AC_SUBST(MULTICOM322)

AC_ARG_ENABLE([multicom324], 
        [AS_HELP_STRING(--enable-multicom324,    enable multicom324 stuff)], 
        [case "${enableval}" in 
                yes) enable_multicom324=true ;; 
                no) enable_multicom324=false ;; 
                *) AC_MSG_ERROR([bad value ${enableval} for --enable-multicom324]) ;; 
        esac]) 
AM_CONDITIONAL([ENABLE_MULTICOM324], [test x$enable_multicom324 = xtrue])
AC_SUBST(MULTICOM324)



AC_OUTPUT([
Makefile
])
