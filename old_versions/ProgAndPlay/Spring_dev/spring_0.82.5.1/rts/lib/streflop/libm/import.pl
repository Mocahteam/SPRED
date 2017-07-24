#!/usr/bin/perl

# streflop: STandalone REproducible FLOating-Point

# This script imports the GNU libm files and convert them in such a way they can be compiled with streflop types.

# Code released according to the GNU Lesser General Public License
# Nicolas Brodu, 2006

# Please read the history and copyright information in the accompanying documentation

if ($#ARGV==-1) {
print <<ENDHELP;
Perl script to import the libm components from the GNU glibc inside this project.
Tested with glibc-2.4

Usage: ./import.pl glibc_src_dir
Where: glibc_src_dir is the source directory obtained by uncompressing the GNU libc archive.

This script copies the libm directories for generic IEEE754 math with float (32 bits), double (64 bits) and long double (80 bits). The files are then post-processed to remove all dependencies from glibc so they can be compiled standalone.
ENDHELP
exit 0;
}

$dir=$ARGV[0];
if ((! -d "$dir/sysdeps/ieee754/flt-32")
 || (! -d "$dir/sysdeps/ieee754/dbl-64")
 || (! -d "$dir/sysdeps/ieee754/ldbl-96")
 || (! -r "$dir/math/s_ldexpf.c")        # was put here for unknown reason, probably because not system-dependent
 || (! -r "$dir/math/s_ldexp.c")         # was put here for unknown reason, probably because not system-dependent
 || (! -r "$dir/math/s_nextafter.c")     # was put here for unknown reason, probably because not system-dependent
 || (! -r "$dir/math/math_private.h")
 || (! -r "$dir/sysdeps/ieee754/ieee754.h")
 || (! -r "$dir/include/features.h")
 || (! -r "$dir/string/endian.h")
 || (! -r "$dir/include/endian.h")
) {
print "Invalid glibc directory\n";
exit 1;
}

$importNotice="/* See the import.pl script for potential modifications */\n";

# Copy files
system("cp -r $dir/sysdeps/ieee754/flt-32 $dir/sysdeps/ieee754/dbl-64 $dir/sysdeps/ieee754/ldbl-96 .");
if (! -d "headers") {mkdir("headers");}
system("cp -r $dir/math/s_ldexpf.c flt-32");
system("cp -r $dir/math/s_ldexp.c $dir/math/s_nextafter.c dbl-64");
# this ldbl function is actually an alias to the dbl one in the libm. Make a hard copy here.
system("cp -r $dir/math/s_ldexp.c ldbl-96/s_ldexpl.c");
system("cp -r $dir/math/math_private.h $dir/sysdeps/ieee754/ieee754.h $dir/include/features.h $dir/string/endian.h $dir/bits/wchar.h headers/");
# Merge include files
system("cat $dir/include/endian.h >> headers/endian.h");

# remove some routines we don't need
if (-r "ldbl-96/printf_fphex.c") {unlink "ldbl-96/printf_fphex.c";}
if (-r "ldbl-96/strtold_l.c") {unlink "ldbl-96/strtold_l.c";}
if (-r "flt-32/mpn2flt.c") {unlink "flt-32/mpn2flt.c";}
if (-r "dbl-64/mpn2dbl.c") {unlink "dbl-64/mpn2dbl.c";}
if (-r "dbl-64/dbl2mpn.c") {unlink "dbl-64/dbl2mpn.c";}
if (-r "dbl-64/t_exp.c") {unlink "dbl-64/t_exp.c";}
if (-r "ldbl-96/mpn2ldbl.c") {unlink "ldbl-96/mpn2ldbl.c";}
if (-r "ldbl-96/ldbl2mpn.c") {unlink "ldbl-96/ldbl2mpn.c";}
if (-r "ldbl-96/s_nexttoward.c") {unlink "ldbl-96/s_nexttoward.c";}
if (-r "ldbl-96/s_nexttowardf.c") {unlink "ldbl-96/s_nexttowardf.c";}
if (-r "ldbl-96/math_ldbl.h") {unlink "ldbl-96/math_ldbl.h";}

# The float exp in e_expf.c uses doubles internally since revision 1.2 in the libm-ieee754 CVS attic!
# Roll back to the slower, but purely float version, and also overwrite the wrapper by a wraper to the float only version
system("cp -f w_expf.c e_expf.c flt-32");

# convert .c => .cpp for clarity
@filelist = glob("flt-32/*.c dbl-64/*.c ldbl-96/*.c");
foreach $f (@filelist) {
    $g = $f;
    $g =~ s/\.c$/.cpp/;
    rename $f, $g;
}

# create dummy math.h stub
open(FILE, ">headers/math.h");
print FILE <<MATH_H;
/* This file is stub automatically generated by import.pl */

// Include bridge, just in case math_private is not included
#include "../streflop_libm_bridge.h"

MATH_H
close FILE;

# These files in the flt directory use double but could use floats instead
foreach $f ("flt-32/s_cbrtf.cpp", "flt-32/s_llrintf.cpp", "flt-32/s_lrintf.cpp") {
    open(FILE,"<$f");
    $content = "";
    while(<FILE>) {
        # replace double by float, OK in these files
        s/double/float/g;
        $content.=$_;
    }
    close FILE;
    open(FILE,">$f");
    print FILE $content;
    close FILE;
}

# These files in the dbl directory wrongly use float, long double and float functions
foreach $f ("dbl-64/e_lgamma_r.cpp", "dbl-64/t_exp2.h", "dbl-64/s_llrint.cpp") {
    open(FILE,"<$f");
    $content = "";
    while(<FILE>) {
        s/fabsf/fabs/g;
        s/float/double/g;
        s/long double/double/g;
        $content.=$_;
    }
    close FILE;
    open(FILE,">$f");
    print FILE $content;
    close FILE;
}

# These files in the ldbl directory wrongly use lower precision types
foreach $f ("ldbl-96/e_lgammal_r.cpp", "ldbl-96/s_cbrtl.cpp", "ldbl-96/s_logbl.cpp", "ldbl-96/s_ldexpl.cpp") {
    open(FILE,"<$f");
    $content = "";
    while(<FILE>) {
        # do the substitution now
        s/long double/Extended/g;
        s/\(double\) i;/(long double) i;/g;
        s/double (_|v)/long double $1/g;
        s/const double factor/const long double factor/g;
        s/fabs(?!l)/fabsl$1/g;
        s/ldexp(?!l)/ldexpl$1/g;
        s/__finite\(/__finitel\(/g;
        s/__scalbn\(/__scalbnl\(/g;
        $content.=$_;
    }
    close FILE;
    open(FILE,">$f");
    print FILE $content;
    close FILE;
}


# DOUBLE_FROM_INT_PTR(x) could simply be *reinterpret_cast<double*>(x)
# for basic types, but may use a dedicated factory for Object wrappers
# BaseType is either the same as FloatType for plain old float/double, or it is
# the float/double type when FloatType is an Object wrapper
$xdaccessor=
 "inline Double& d() {return DOUBLE_FROM_INT_PTR(&i[0]);}\n"
."inline Double& x() {return DOUBLE_FROM_INT_PTR(&i[0]);}\n"
."inline Double& d(int idx) {return DOUBLE_FROM_INT_PTR(&i[idx*(sizeof(double)/sizeof(i))]);}\n"
."inline Double& x(int idx) {return DOUBLE_FROM_INT_PTR(&i[idx*(sizeof(double)/sizeof(i))]);}\n"
."inline const Double& d() const {return CONST_DOUBLE_FROM_INT_PTR(&i[0]);}\n"
."inline const Double& x() const {return CONST_DOUBLE_FROM_INT_PTR(&i[0]);}\n"
."inline const Double& d(int idx) const {return CONST_DOUBLE_FROM_INT_PTR(&i[idx*(sizeof(double)/sizeof(i))]);}\n"
."inline const Double& x(int idx) const {return CONST_DOUBLE_FROM_INT_PTR(&i[idx*(sizeof(double)/sizeof(i))]);}\n"
;

@filelist = glob("flt-32/* dbl-64/* ldbl-96/*");

foreach $f (@filelist) {

    open(FILE,"<$f");
    $content = "";
    $opened_namespace = 0;
    while(<FILE>) {
        # remove all system-wide includes
        if (/.*?#include(.*?)<sys\/(.*)/) {$_="//".$_;}
        # Convert all includes to local files
        s/^([ \t]*)#include([ \t]*)<(.*)>(.*)/#$1include$2\"$3\"$4/g;
        # fp environment is now handled directly by streflop (and FPUSettings.h)
        s/fenv\.h/..\/streflop_libm_bridge.h/g;
        # integer types handled by the bridge
        s/inttypes\.h/..\/streflop_libm_bridge.h/g;
        # get rid of stdlib too
        s/stdlib\.h/..\/streflop_libm_bridge.h/g;
        # and limits.h
        s/limits\.h/..\/streflop_libm_bridge.h/g;
        # float.h too
        s/float\.h/..\/streflop_libm_bridge.h/g;
        # errno.h falls back to system, remove it
        s/errno\.h/..\/streflop_libm_bridge.h/g;
        # replace all occurences of problematic union fields with objects
        # by proper C++ accessors
        s/\b(\.d(?!\[)\b|\.d\[(.*?)\])/.d($2)/g;
        s/\b(\.x(?!\[)\b|\.x\[(.*?)\])/.x($2)/g;
        s/\b(\.f(?!\[)\b|\.f\[(.*?)\])/.f($2)/g; # ieee754.h
        s/\b(->d(?!\[)\b|->d\[(.*?)\])/->d($2)/g;
        s/\b(->x(?!\[)\b|->x\[(.*?)\])/->x($2)/g;
        s/\b(->f(?!\[)\b|->f\[(.*?)\])/->f($2)/g; # ieee754.h
        # Some more occurences from arrays of such unions/structs
        s/\]\.d\b/].d()/g;
        # named field C construct is invalid (C++ would initialize first union member)
        # and we replace unions by struct + accessor anyway
        s/{ *?.i *?= *?{/{{/g;
        # volatile declaration of static const global variables poses problem with the wrapper types
        s/volatile //g;
        # Now substitute the base types by their Simple/Double/Extended aliases or wrapper
        s/long double/Extended/g; # before double
        s/\bdouble\b/Double/g;
        s/\bfloat\b/Simple/g;
        # Replace problematic int += double
        s/E(X|Y|Z)(.*?=.*?)ONE/E${1}${2}1/g;
        # problematic ?: operator with different types. This simple check catches all problematic occurences
#        if (/\?(.*?(\b0\.|\.0).*?:.*?|.*?:.*?(\b0\.|\.0).*?);/) {
#            print "$f => ?$1;\n";
#        }
        if (/\?(.*?):(.*?)\b(0\.0|10\.0|1\.0)\b/) {
            my $type = "";
            if ($f =~ /flt-32/) {$type = "Simple";}
            if ($f =~ /dbl-64/) {$type = "Double";}
            if ($f =~ /ldbl-96/) {$type = "Extended";}
            s/\?(.*?):(.*?)\b(0\.0|10\.0|1\.0)\b/?$1:$2$type($3)/g;
        }
        my $type = "";
        my $flit = "";
        if ($f =~ /flt-32/) {$type = "Simple"; $flit = "f";}
        if ($f =~ /dbl-64/) {$type = "Double"; $flit = "";}
        if ($f =~ /ldbl-96/) {$type = "Extended"; $flit = "l";}
        # replace problematic mixed-type ?: operators where an int and a float are used as arguments, incompatible with wrappers
        if (/\?(.*?)\b(0\.0|1\.0)\b(.*?):(.*?)/) {
            s/\?(.*?)\b(0\.0|1\.0)\b(.*?):(.*?)/?$1$type($2)$3:$4/g;
        }
        # These special cases are OK because no other ?: pattern use them in the 3 subdirs
        s/\?0:/?Double(0.0):/;
        s/:0;/:Double(0.0);/;
        # protect the new symbol names by namespace to avoid any conflict with system libm
        if (((/#ifdef __STDC__/) || (/.*? (__|mcr|ss32)[a-z,A-Z,_,0-9]*?\(.*?{$/) || (/Double (atan2Mp|atanMp|slow|tanMp|__exp1|__ieee754_remainder|__ieee754_sqrt)/) || (/^(Simple|Double|Extended|void|int)$/) || ((/^#ifdef BIG_ENDI$/) && ($f =~ /(uatan|mpa2|mpexp|atnat|sincos32)/)) || (/^#define MM 5$/) || (/^void __mp(log|sqrt|exp|atan)\(/) || (/^int __(b|mp)ranred\(/)) && ($opened_namespace == 0)) {
            $_ = "namespace streflop_libm {\n".$_;
            $opened_namespace = 1;
        }

        # Prevent type promotion for native aliases
        # Ex: promotion would cause computations like y = 0.5 * x to be done in double for x,y float, then cast back to float
        # We want the whole computation done in float, not temporary switching to double.
        # In some case the FPU internal precision is enough to mask the problem, but for SSE for example, the float/double
        # are using different instructions and the problem cannot be ignored (in these cases, there are differences from
        # soft float implementation)
        # Cannot replace by s/blah/$type($1)/g; because of static order initialization fiasco with wrapper types
        # So use next best option to use litteral type specification
        # => this solves the problem for native types
        # => wrappers are OK thanks to the redefinitions of the operators
        s/\b((\d+\.\d*|\d*\.\d+)((e|E)[-+]?\d+)?)(f|F|l|L)?\b/$1$flit/g;
        $content.=$_;
    }
    close FILE;
    # multi-line spanning regexp
    $content =~ s/union ?{(.*?);.*?Double.*?}/struct {\n$xdaccessor$1;}/sg;
    # close opened namespace
    if ($opened_namespace==1) {
        $content .= "}\n";
    }
    open(FILE,">$f");
    print FILE $importNotice;
    print FILE $content;
    close FILE;
}


# ieee754.h union+accessor
open(FILE,"<headers/ieee754.h");
$content = "";
while(<FILE>) {
    # Comment out decls sections
    if (/.*?__.*?_DECLS.*/) {$_="//".$_;}
    # Convert all includes to local files
    s/^([ \t]*)#include([ \t]*)<(.*)>(.*)/#$1include$2\"$3\"$4/g;
    # insert our own bridge
    if (/^#define _IEEE754_H.*/) {
        $_.="#include \"../streflop_libm_bridge.h\"\n\n";
    }
    # Protect the Simple section by a #define
    if (/.*?ieee754_float.*?/) {
        $_ = "#if defined(LIBM_COMPILING_FLT32)\n".$_;
    }
    if (/.*?IEEE754_FLOAT_BIAS.*?/) {
        $_ = $_."\n#endif\n";
    }
    # Protect the Double section by a #define
    if (/.*?ieee754_double.*?/) {
        $_ = "#if defined(LIBM_COMPILING_DBL64)\n".$_;
    }
    if (/.*?IEEE754_DOUBLE_BIAS.*?/) {
        $_ = $_."\n#endif\n";
    }
    # Protect the Extended section by a #define
    if (/.*?ieee854_long_double.*?/) {
        $_ = "#if defined(Extended)\n".$_;
        $_ = "#if defined(LIBM_COMPILING_LDBL96)\n".$_;
    }
    if (/.*?IEEE854_LONG_DOUBLE_BIAS.*?/) {
        $_ = $_."\n#endif\n";
        $_ = $_."\n#endif\n";
    }
    $content.=$_;
}
$ieeeAccessorSimple=
 "inline Simple& f() {return SIMPLE_FROM_INT_PTR(&storage[0]);}\n"
."inline const Simple& f() const {return CONST_SIMPLE_FROM_INT_PTR(&storage[0]);}\n";
$ieeeAccessorDouble=
 "inline Double& d() {return DOUBLE_FROM_INT_PTR(&storage[0]);}\n"
."inline const Double& d() const {return CONST_DOUBLE_FROM_INT_PTR(&storage[0]);}\n";
$ieeeAccessorExtended=
 "inline Extended& d() {return EXTENDED_FROM_INT_PTR(&storage[0]);}\n"
."inline const Extended& d() const {return CONST_EXTENDED_FROM_INT_PTR(&storage[0]);}\n";

# multi-line spanning regexp
$content =~ s/union(.*?ieee854_long_double.*?){.*?;/union$1\{\nint storage[sizeof(long double)\/sizeof(int)];\n$ieeeAccessorExtended/sg;
$content =~ s/union(.*?ieee754_double.*?){.*?;/union$1\{\nint storage[sizeof(double)\/sizeof(int)];\n$ieeeAccessorDouble/sg;
$content =~ s/union(.*?ieee754_float.*?){.*?;/union$1\{\nint storage[sizeof(float)\/sizeof(int)];\n$ieeeAccessorSimple/sg;
close FILE;
open(FILE,">headers/ieee754.h");
print FILE $importNotice;
print FILE $content;
close FILE;

# math_private.h needs a special treatement to define the macros for the wrapper objects
# The macros will be defined separately
open(FILE,"<headers/math_private.h");
my $flag=1;
my $precisionMode = "none";
@convert=();
MPRIV_LOOP: while(<FILE>) {
    # keep initial lines with header information and #define file protection
    # skip all lines defining macros and unions
    if (/^#define _MATH_PRIVATE_H_.*/) {
        push @convert,$_;
        push @convert,"\n/* import.pl: Skipped the macro definitions, keep only the declarations, converted to use streflop types (aliases or wrappers) */\n#include \"../streflop_libm_bridge.h\"\n\nnamespace streflop_libm {\n\n";
        # ensure strict separation of precision mode, each one does not have access to the other names
        push @convert,"#ifdef LIBM_COMPILING_FLT32\n";
        # define wrappers as the libm would do in IEEE754 mode
        push @convert,"#define __sqrtf __ieee754_sqrtf\n";
        push @convert,"#define fabsf __fabsf\n";
        push @convert,"#define copysignf __copysignf\n";
        # add missing defines
        push @convert,"extern Simple __log1pf(Simple x);\n";
        push @convert,"extern Simple __fabsf(Simple x);\n";
        push @convert,"extern Simple __atanf(Simple x);\n";
        push @convert,"extern Simple __expm1f(Simple x);\n";
        push @convert,"extern int __isinff(Simple x);\n";
        push @convert,"extern Simple __rintf(Simple x);\n";
        push @convert,"extern Simple __cosf(Simple x);\n";
        push @convert,"extern void __sincosf (Simple x, Simple *sinx, Simple *cosx);\n";
        push @convert,"extern Simple __floorf(Simple x);\n";
        push @convert,"extern Simple __scalbnf (Simple x, int n);\n";
        push @convert,"extern Simple __frexpf(Simple x, int *eptr);\n";
        push @convert,"extern Simple __ldexpf(Simple value, int exp);\n";
        push @convert,"extern int __finitef(Simple x);\n";
        push @convert,"#endif\n\n";
        push @convert,"#ifdef LIBM_COMPILING_DBL64\n";
        push @convert,"#define __sqrt __ieee754_sqrt\n";
        push @convert,"#define fabs __fabs\n";
        push @convert,"#define copysign __copysign\n";
        push @convert,"extern Double __log1p(Double x);\n";
        push @convert,"extern Double __fabs(Double x);\n";
        push @convert,"extern Double atan(Double x);\n";
        push @convert,"extern Double __expm1(Double x);\n";
        push @convert,"extern int __isinf(Double x);\n";
        push @convert,"extern Double __rint(Double x);\n";
        push @convert,"extern Double __cos(Double x);\n";
        push @convert,"extern void __sincos (Double x, Double *sinx, Double *cosx);\n";
        push @convert,"extern Double __floor(Double x);\n";
        push @convert,"extern Double __scalbn(Double x, int n);\n";
        push @convert,"extern Double __frexp(Double x, int *eptr);\n";
        push @convert,"extern Double __ldexp(Double value, int exp);\n";
        push @convert,"extern int __finite(Double x);\n";
        push @convert,"#endif\n\n";
        push @convert,"#ifdef LIBM_COMPILING_LDBL96\n";
        push @convert,"#if defined(Extended)\n";
        push @convert,"#define fabsl __fabsl\n";
        push @convert,"extern Extended __cosl(Extended x);\n";
        push @convert,"extern Extended __sinl(Extended x);\n";
        push @convert,"extern Extended __fabsl(Extended x);\n";
        push @convert,"#endif\n";
        push @convert,"#endif\n";
        push @convert,"\n";
        $flag = 0;
    }
    if (/^extern(.*)/) {
        $flag = 1;
    }
    if ($flag==0) {next MPRIV_LOOP;}


    
    # Now substitute the base types by their Simple/Double/Extended aliases or wrapper
    s/\blong double\b/Extended/g; # before double
    s/\bdouble\b/Double/g;
    s/\bfloat\b/Simple/g;
    # Protect the Extended section by a #define
    if (/.*?elementary Extended functions.*?/) {
        $_ = "#if defined(Extended)\n".$_;
    }
    if (/.*?functions of the IBM.*?/) {
        $_ = "#endif\n\n".$_;
    }
    # remove the inline aliases
    s/__GNUC_PREREQ \(.*?\)/0/;
    # end namespace protection
    if (/^#endif.*_MATH_PRIVATE_H_/) {
        $_ = "}\n\n".$_;
    }

    # now insert protection for symbols separation
    if (/^extern(.*)/) {
        $remline = $1;
        if ($remline =~ /Extended/) {
            if ($precisionMode ne "Extended") {
                if ($precisionMode ne "none") {$_ = "#endif\n".$_;}
                $_ = "#ifdef LIBM_COMPILING_LDBL96\n".$_;
                $precisionMode = "Extended";
            }
        }
        elsif ($remline =~ /Double/) {
            if ($precisionMode ne "Double") {
                if ($precisionMode ne "none") {$_ = "#endif\n".$_;}
                $_ = "#ifdef LIBM_COMPILING_DBL64\n".$_;
                $precisionMode = "Double";
            }
        }
        elsif ($remline =~ /Simple/) {
            if ($precisionMode ne "Simple") {
                if ($precisionMode ne "none") {$_ = "#endif\n".$_;}
                $_ = "#ifdef LIBM_COMPILING_FLT32\n".$_;
                $precisionMode = "Simple";
            }
        }
    } else {
        $line = $_;
        chomp $line;
        if (($line =~ /^(\s)*$/) && ($precisionMode ne "none")) {
            $_ = "#endif\n".$_;
            $precisionMode = "none";
        }
    }
    
    push @convert,$_;
}
close FILE;
open(FILE,">headers/math_private.h");
print FILE $importNotice;
print FILE @convert;
close FILE;

# features.h is nearly ready, just do not include more external defs
open(FILE,"<headers/features.h");
@convert=();
while(<FILE>) {
    # commment out external includes
    s,(.*?#.*?include.*),//$1,;
    push @convert,$_;
}
close FILE;
open(FILE,">headers/features.h");
print FILE $importNotice;
print FILE @convert;
close FILE;

# headers/endian.h
open(FILE,"<headers/endian.h");
@convert=();
while(<FILE>) {
    # change machine specific bits/endian by streflop configuration
    if (/<bits\/endian\.h>/) {
        s,<bits/endian\.h>,\"../streflop_libm_bridge.h\",;
    #keep features.h, but locally
    } elsif (/<features\.h>/) {
        s,<features\.h>,"features.h",;
    } else {
    # commment out all other external includes
    s,(.*?#.*?include.*),//$1,;
    }
    #unconditional definition of endian things
    if (/defined _LIBC/) {
        $_ = "#if 1\n//".$_;
    }
    push @convert,$_;
}
close FILE;
open(FILE,">headers/endian.h");
print FILE $importNotice;
print FILE @convert;
close FILE;


# include the bridge from mpa.h
open(FILE,"<dbl-64/mpa.h");
$content="#include \"../streflop_libm_bridge.h\"\nnamespace streflop_libm {";
while(<FILE>) {
    # special case
    s/->d\(\)/->mantissa/g;
    $content.=$_;
}
close FILE;
$mpAccessor=
 "inline Double& d(int idx) {return mantissa[idx];}\n"
."inline const Double& d(int idx) const {return mantissa[idx];}\n";
# multi-line spanning regexp
$content =~ s/Double d\[(.*?)\].*?} mp_no/Double mantissa[$1];\n$mpAccessor} mp_no/sg;
open(FILE,">dbl-64/mpa.h");
print FILE $content."}\n"; # also close namespace
close FILE;

# Generate specific Makefiles
$parentMakefile="";
foreach $dir ("flt-32", "dbl-64", "ldbl-96") {
    @objFiles = glob("$dir/*.cpp");
    $parentObjects = "$dir-objects =";
    foreach $f (@objFiles) {
        $f =~ s/\.cpp$/.o/;
        $parentObjects .= " libm/$f";
        $f =~ s/^$dir\///;
    }
    open(FILE, ">$dir/Makefile");
    my $DIR = uc($dir);
    $DIR =~ s/\-//;
    print FILE "# Makefile automatically generated by import.pl\n"
              ."include ../../Makefile.common\n"
              ."CPPFLAGS += -I../headers -DLIBM_COMPILING_$DIR=1\n"
              ."all: @objFiles\n"
              ."\techo '$dir done!'\n";
    close FILE;
    $parentMakefile .= $parentObjects."\n\n";
}

# generate Makefile rule in parent directory
@projectFiles = glob("flt-32/* dbl-64/* ldbl-96/* headers/*");
foreach $f (@projectFiles) {$f = " libm/$f";}
open(FILE, ">../Makefile.libm_objects");
print FILE "# Makefile automatically generated by libm/import.pl. Do not edit.\n\n"
            .$parentMakefile
            ."\nlibm-src =";
print FILE @projectFiles;
print FILE "\n";
close FILE;