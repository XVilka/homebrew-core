class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/releases/download/pkcs11-helper-1.26/pkcs11-helper-1.26.0.tar.bz2"
  sha256 "e886ec3ad17667a3694b11a71317c584839562f74b29c609d54c002973b387be"
  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "7bfe86fac0370ae0e6e10f9b5dff360e6aef757aa23f9484d4027be8a7490b25" => :catalina
    sha256 "c1f7cd0ecece3f42d6e26888f4bc2dadbf8276f5ddbbafc566515abb19494a9f" => :mojave
    sha256 "847249ed020552d1cd72935407e19b47d1b421e6d2c61761587af9598ac84afb" => :high_sierra
    sha256 "7e4e2e52985c686dbd0cde59940c59741129694adddfbd64308f5fccfc35e055" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <pkcs11-helper-1.0/pkcs11h-core.h>

      int main() {
        printf("Version: %08x", pkcs11h_getVersion ());
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}",
                   "-lpkcs11-helper", "-o", "test"
    system "./test"
  end
end
