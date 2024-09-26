MODULE xattr;
IMPORT SYSTEM;

PROCEDURE -Aincludesysxattr '#include <sys/xattr.h>';  (* Include the necessary C headers for xattr *)

PROCEDURE -listxattr(path: ARRAY OF CHAR; VAR list: ARRAY OF CHAR; size: LONGINT): LONGINT
  "listxattr(path, list, size)";
PROCEDURE -llistxattr(path: ARRAY OF CHAR; VAR list: ARRAY OF CHAR; size: LONGINT): LONGINT
  "llistxattr(path, list, size)";
PROCEDURE -flistxattr(fd: LONGINT; VAR list: ARRAY OF CHAR; size: LONGINT): LONGINT
  "flistxattr(fd, list, size)";

PROCEDURE -getxattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR; VAR value: ARRAY OF CHAR; size: LONGINT): LONGINT
  "getxattr(path, name, value, size)";
PROCEDURE -lgetxattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR; VAR value: ARRAY OF CHAR; size: LONGINT): LONGINT
  "lgetxattr(path, name, value, size)";
PROCEDURE -fgetxattr(fd: LONGINT; name: ARRAY OF CHAR; VAR value: ARRAY OF CHAR; size: LONGINT): LONGINT
  "fgetxattr(fd, name, value, size)";

PROCEDURE -setxattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR; value: ARRAY OF CHAR; size: LONGINT; flags: LONGINT): LONGINT
  "setxattr(path, name, value, size, flags)";
PROCEDURE -lsetxattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR; value: ARRAY OF CHAR; size: LONGINT; flags: LONGINT): LONGINT
  "lsetxattr(path, name, value, size, flags)";
PROCEDURE -fsetxattr(fd: LONGINT; name: ARRAY OF CHAR; value: ARRAY OF CHAR; size: LONGINT; flags: LONGINT): LONGINT
  "fsetxattr(fd, name, value, size, flags)";

PROCEDURE -removexattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR): LONGINT
  "removexattr(path, name)";
PROCEDURE -lremovexattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR): LONGINT
  "lremovexattr(path, name)";
PROCEDURE -fremovexattr(fd: LONGINT; name: ARRAY OF CHAR): LONGINT
  "fremovexattr(fd, name)";

PROCEDURE GetAttr*(path: ARRAY OF CHAR; name: ARRAY OF CHAR; VAR value: ARRAY OF CHAR; size: LONGINT): LONGINT;
BEGIN
  RETURN getxattr(path, name, value, size)
END GetAttr;

PROCEDURE ListAttr*(path: ARRAY OF CHAR; VAR list: ARRAY OF CHAR; size: LONGINT): LONGINT;
BEGIN
  RETURN listxattr(path, list, size)
END ListAttr;

PROCEDURE SetAttr*(path: ARRAY OF CHAR; name: ARRAY OF CHAR; value: ARRAY OF CHAR; size: LONGINT; flags: LONGINT): LONGINT;
BEGIN
  RETURN setxattr(path, name, value, size, flags)
END SetAttr;

PROCEDURE RemoveAttr*(path: ARRAY OF CHAR; name: ARRAY OF CHAR): LONGINT;
BEGIN
  RETURN removexattr(path, name)
END RemoveAttr;

END xattr.

