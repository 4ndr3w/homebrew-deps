require 'formula'

class Gtest <Formula
  skip_clean "lib"
  url 'https://github.com/google/googletest/archive/release-1.7.0.zip'
  homepage 'https://github.com/google/googletest'
  sha256 'b58cb7547a28b2c718d1e38aee18a3659c9e3ff52440297e965f5edffe34b6d0'
  
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def patches
    # This is necessary to get gtest to function wtih libc++
    # Otherwise, every catkin package has to export that flag.
    # The patch only changes the default behavior.
    DATA
  end

  def install
    system "glibtoolize"
    system "aclocal"
    system "autoheader"
    system "automake --add-missing"
    system "autoconf"
    system "./configure", "CPPFLAGS=-DGTEST_HAS_TR1_TUPLE=0", "--prefix=#{prefix}", "--disable-dependency-tracking"
    inreplace 'scripts/gtest-config', '`dirname $0`', '$bindir'
    system "make"
    lib.install Dir['lib/*.la']
    lib.install Dir['lib/.libs/*.dylib']
    (include / 'gtest').install Dir["include/gtest/*"]
  end
end

__END__
diff --git a/include/gtest/gtest.h b/include/gtest/gtest.h
index 6fa0a39..7f8656f 100644
--- a/include/gtest/gtest.h
+++ b/include/gtest/gtest.h
@@ -55,6 +55,10 @@
 #include <ostream>
 #include <vector>
 
+#ifndef GTEST_HAS_TR1_TUPLE
+#define GTEST_HAS_TR1_TUPLE 0
+#endif
+
 #include "gtest/internal/gtest-internal.h"
 #include "gtest/internal/gtest-string.h"
 #include "gtest/gtest-death-test.h"
