class Idutils < Formula
  desc "ID database and query tools"
  homepage "https://www.gnu.org/software/idutils/"
  url "https://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/idutils/idutils-4.6.tar.xz"
  sha256 "8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "63d48bcd08d23874fff1f37a66c022c47c10c085549405f4fa8cdb4ba8d34b28"
    sha256 arm64_sonoma:   "cfeadacc331e01cf64d880d4f9b35a54870ea30594d638b58f245f4cda394469"
    sha256 arm64_ventura:  "c410f473b777ac344a863267348be1dc14f587c28f6c3a5845cc556ce52ba843"
    sha256 arm64_monterey: "072b4846a5c749954544e7b747d2951d4ee43a4bd6f024e817ac74743cdeefa7"
    sha256 arm64_big_sur:  "321fd582b7e17f7f912f76f0b5e8f57d16ebf9ea6c8721854c2567df8136fe28"
    sha256 sonoma:         "3107240f1d74fde8a91d009fadbdbd2a3e2e0384476735365c9d87a919421d2c"
    sha256 ventura:        "1d29ee25c018fa81e5cc297091cb8190fa0dbdb54c2ad21c8909cff989e8703c"
    sha256 monterey:       "e3fc421fedb08ac46a82fb2dd8127f4c7c03c6103d943b53a49e8220406ed157"
    sha256 big_sur:        "4e20dbb5fa6efb604aba5c3fab7b2fe948517c16569a3c27fa5b314e0d0730bf"
    sha256 catalina:       "7e27c7bad2b5d30c4ee26ffb21cf0412706e83c17d0d55b7cefd1f63c919063c"
    sha256 x86_64_linux:   "54a8af17aba2695b61bd976d6ae4bf2f13c45cec787b1c14b497080d5bac9ce9"
  end

  conflicts_with "coreutils", because: "both install `gid` and `gid.1`"

  patch :p0 do
    on_high_sierra :or_newer do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  # Fix build on Linux. Upstream issue:
  # https://savannah.gnu.org/bugs/?57429
  # Patch submitted here:
  # https://savannah.gnu.org/patch/index.php?10240
  patch :DATA

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--with-lispdir=#{elisp}", *args, *std_configure_args
    system "make", "install"
  end

  test do
    usr = if OS.mac?
      "#{MacOS.sdk_path_if_needed}/usr"
    else
      "/usr"
    end
    system bin/"mkid", "#{usr}/include"

    system bin/"lid", "FILE"
  end
end

__END__
diff --git a/lib/fflush.c b/lib/fflush.c
index 8879cab..34c6b10 100644
--- a/lib/fflush.c
+++ b/lib/fflush.c
@@ -31,7 +31,7 @@
 #undef fflush
 
 
-#if defined _IO_ftrylockfile || __GNU_LIBRARY__ == 1 /* GNU libc, BeOS, Haiku, Linux libc5 */
+##if defined _IO_ftrylockfile || defined __GLIBC__  /* GNU libc, BeOS, Haiku, Linux libc5 */
 
 /* Clear the stream's ungetc buffer, preserving the value of ftello (fp).  */
 static inline void
@@ -138,7 +138,7 @@ rpl_fflush (FILE *stream)
   if (stream == NULL || ! freading (stream))
     return fflush (stream);
 
-#if defined _IO_ftrylockfile || __GNU_LIBRARY__ == 1 /* GNU libc, BeOS, Haiku, Linux libc5 */
+##if defined _IO_ftrylockfile || defined __GLIBC__  /* GNU libc, BeOS, Haiku, Linux libc5 */
 
   clear_ungetc_buffer_preserving_position (stream);
 
diff --git a/lib/fpurge.c b/lib/fpurge.c
index 295d8dc..cc11571 100644
--- a/lib/fpurge.c
+++ b/lib/fpurge.c
@@ -61,7 +61,7 @@ fpurge (FILE *fp)
   /* Most systems provide FILE as a struct and the necessary bitmask in
      <stdio.h>, because they need it for implementing getc() and putc() as
      fast macros.  */
-# if defined _IO_ftrylockfile || __GNU_LIBRARY__ == 1 /* GNU libc, BeOS, Haiku, Linux libc5 */
+# #if defined _IO_ftrylockfile || defined __GLIBC__  /* GNU libc, BeOS, Haiku, Linux libc5 */
   fp->_IO_read_end = fp->_IO_read_ptr;
   fp->_IO_write_ptr = fp->_IO_write_base;
   /* Avoid memory leak when there is an active ungetc buffer.  */
diff --git a/lib/freading.c b/lib/freading.c
index 3fde6ea..9287506 100644
--- a/lib/freading.c
+++ b/lib/freading.c
@@ -31,7 +31,7 @@ freading (FILE *fp)
   /* Most systems provide FILE as a struct and the necessary bitmask in
      <stdio.h>, because they need it for implementing getc() and putc() as
      fast macros.  */
-# if defined _IO_ftrylockfile || __GNU_LIBRARY__ == 1 /* GNU libc, BeOS, Haiku, Linux libc5 */
+# #if defined _IO_ftrylockfile || defined __GLIBC__  /* GNU libc, BeOS, Haiku, Linux libc5 */
   return ((fp->_flags & _IO_NO_WRITES) != 0
           || ((fp->_flags & (_IO_NO_READS | _IO_CURRENTLY_PUTTING)) == 0
               && fp->_IO_read_base != NULL));
diff --git a/lib/fseeko.c b/lib/fseeko.c
index eae1b72..78b0325 100644
--- a/lib/fseeko.c
+++ b/lib/fseeko.c
@@ -40,7 +40,7 @@ fseeko (FILE *fp, off_t offset, int whence)
 #endif
 
   /* These tests are based on fpurge.c.  */
-#if defined _IO_ftrylockfile || __GNU_LIBRARY__ == 1 /* GNU libc, BeOS, Haiku, Linux libc5 */
+##if defined _IO_ftrylockfile || defined __GLIBC__  /* GNU libc, BeOS, Haiku, Linux libc5 */
   if (fp->_IO_read_end == fp->_IO_read_ptr
       && fp->_IO_write_ptr == fp->_IO_write_base
       && fp->_IO_save_base == NULL)
@@ -105,7 +105,7 @@ fseeko (FILE *fp, off_t offset, int whence)
           return -1;
         }
 
-#if defined _IO_ftrylockfile || __GNU_LIBRARY__ == 1 /* GNU libc, BeOS, Haiku, Linux libc5 */
+##if defined _IO_ftrylockfile || defined __GLIBC__  /* GNU libc, BeOS, Haiku, Linux libc5 */
       fp->_flags &= ~_IO_EOF_SEEN;
       fp->_offset = pos;
 #elif defined __sferror || defined __DragonFly__ /* FreeBSD, NetBSD, OpenBSD, DragonFly, MacOS X, Cygwin */
diff --git a/lib/fseterr.c b/lib/fseterr.c
index 30b41e1..dbf20e3 100644
--- a/lib/fseterr.c
+++ b/lib/fseterr.c
@@ -29,7 +29,7 @@ fseterr (FILE *fp)
   /* Most systems provide FILE as a struct and the necessary bitmask in
      <stdio.h>, because they need it for implementing getc() and putc() as
      fast macros.  */
-#if defined _IO_ftrylockfile || __GNU_LIBRARY__ == 1 /* GNU libc, BeOS, Haiku, Linux libc5 */
+#if defined _IO_ftrylockfile || defined __GLIBC__ /* GNU libc, BeOS, Haiku, Linux libc5 */
   fp->_flags |= _IO_ERR_SEEN;
 #elif defined __sferror || defined __DragonFly__ /* FreeBSD, NetBSD, OpenBSD, DragonFly, MacOS X, Cygwin */
   fp_->_flags |= __SERR;
diff --git a/lib/stdio.in.h b/lib/stdio.in.h
index 0481930..79720e0 100644
--- a/lib/stdio.in.h
+++ b/lib/stdio.in.h
@@ -715,7 +715,6 @@ _GL_CXXALIASWARN (gets);
 /* It is very rare that the developer ever has full control of stdin,
    so any use of gets warrants an unconditional warning.  Assume it is
    always declared, since it is required by C89.  */
-_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
 #endif
 
 
