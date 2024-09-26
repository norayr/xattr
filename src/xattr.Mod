MODULE xattr;
IMPORT SYSTEM, Out;

TYPE
  TTag* = ARRAY 256 OF CHAR;
  TTags* = POINTER TO ARRAY OF TTag;

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
VAR res: LONGINT;
BEGIN
  res := getxattr(path, name, value, size);
  value[res] := 0X;
  RETURN res;
END GetAttr;

PROCEDURE zeroStr(VAR s: ARRAY OF CHAR);
VAR i: LONGINT;
BEGIN
  i := 0;
  REPEAT
    s[i] := 0X;
    INC(i)
  UNTIL i = LEN(s);
END zeroStr;

PROCEDURE listToTTags(VAR list: ARRAY OF CHAR; size: LONGINT): TTags;
VAR
  i, j, tagIndex: LONGINT;
  ttags: TTags;
  numTags: LONGINT;
  isEmpty: BOOLEAN;
BEGIN
  (* Step 0: Check if the list is empty or consists only of 0X characters *)
  isEmpty := TRUE;
  i := 0;
  REPEAT
    IF list[i] # 0X THEN
      isEmpty := FALSE;
    END;
    INC(i)
  UNTIL ~isEmpty OR (i = (size-1));

  IF isEmpty THEN
    Out.String("got empty list"); Out.Ln;
    RETURN NIL;  (* If the list is completely zeroed out, return NIL *)
  END;

  (* Step 1: Count the number of null-terminated strings *)
  i := 0;
  numTags := 0;
  WHILE i < size DO
    IF list[i] = 0X THEN INC(numTags) END;
    INC(i);
  END;
  Out.String("found "); Out.Int(numTags, 0); Out.String(" tags"); Out.Ln;
  (* Step 2: Allocate memory for the tags *)
  NEW(ttags, numTags);

  (* Step 3: Copy each null-terminated string into ttags *)
  i := 0;
  tagIndex := 0;
  j := 0;
  WHILE i < size DO
    IF list[i] # 0X THEN
      (* Copy each character into the current tag *)
      ttags[tagIndex][j] := list[i];
      INC(j);
    ELSE
      (* Null terminator reached; finalize current tag *)
      ttags[tagIndex][j] := 0X;
      Out.String("got tag: "); Out.String(ttags[tagIndex]); Out.Ln;
      INC(tagIndex);
      j := 0;  (* Reset index for the next tag *)
    END;
    INC(i);
  END;

  RETURN ttags;
END listToTTags;

PROCEDURE ListAttr*(path: ARRAY OF CHAR; VAR list: ARRAY OF CHAR; size: LONGINT): TTags;
VAR
  res: LONGINT;
BEGIN
  zeroStr(list);
  res := listxattr(path, list, size);  (* Calls C function to populate list *)
  Out.String("list="); Out.String(list); Out.Ln;
  Out.String("res="); Out.Int(res, 0); Out.Ln;
  IF res > 0 THEN
    RETURN listToTTags(list, res);  (* Convert the list to TTags *)
  ELSE
    RETURN NIL;  (* If no attributes found, return NIL *)
  END;
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

