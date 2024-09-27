MODULE xattr;
IMPORT SYSTEM, Out, StringList;

TYPE
  TStringList* = StringList.TStringList;

PROCEDURE -Aincludesysxattr '#include <sys/xattr.h>';  (* Include the necessary C headers for xattr *)

PROCEDURE -listxattr(path: ARRAY OF CHAR; VAR list: ARRAY OF CHAR; size: LONGINT): LONGINT
  "listxattr(path, list, size)";
PROCEDURE -getxattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR; VAR value: ARRAY OF CHAR; size: LONGINT): LONGINT
  "getxattr(path, name, value, size)";
PROCEDURE -setxattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR; value: ARRAY OF CHAR; size: LONGINT; flags: LONGINT): LONGINT
  "setxattr(path, name, value, size, flags)";
PROCEDURE -removexattr(path: ARRAY OF CHAR; name: ARRAY OF CHAR): LONGINT
  "removexattr(path, name)";

PROCEDURE zeroStr(VAR s: ARRAY OF CHAR);
VAR i: LONGINT;
BEGIN
  i := 0;
  REPEAT
    s[i] := 0X;
    INC(i)
  UNTIL i = LEN(s);
END zeroStr;

PROCEDURE listToTStringList(VAR list: ARRAY OF CHAR; size: LONGINT): TStringList;
VAR
  i, j: LONGINT;
  tag: StringList.TString;
  tlist: TStringList;
  tempStr: ARRAY 256 OF CHAR;  (* Temporary array to store extracted string *)
  tmpres: LONGINT;
BEGIN
  (* Create a new TStringList *)
  tlist := StringList.Create();

  (* Initialize pointers and traverse the list of null-terminated strings *)
  i := 0;
  WHILE i < size DO
    IF list[i] # 0X THEN
      j := 0;
      (* Extract the full null-terminated string into tempStr *)
      WHILE (list[i] # 0X) & (i < size) & (j < LEN(tempStr)-1) DO
        tempStr[j] := list[i];
        INC(i);
        INC(j);
      END;
      tempStr[j] := 0X;  (* Null-terminate the string *)

      (* Convert tempStr to TString and add to the list *)
      StringList.TStringFromString(tempStr, tag);
      tmpres := StringList.AddString(tlist, tempStr);
    END;
    INC(i);  (* Move to the next string (past the null terminator) *)
  END;
  RETURN tlist;
END listToTStringList;

PROCEDURE ListAttr*(path: ARRAY OF CHAR; VAR list: ARRAY OF CHAR; size: LONGINT): TStringList;
VAR
  res: LONGINT;
BEGIN
  zeroStr(list);
  res := listxattr(path, list, size);  (* Calls C function to populate list *)
  IF res > 0 THEN
    RETURN listToTStringList(list, res);  (* Convert the list to TStringList *)
  ELSE
    RETURN NIL;  (* If no attributes found, return NIL *)
  END;
END ListAttr;

PROCEDURE GetAttr*(path: ARRAY OF CHAR; name: ARRAY OF CHAR; VAR value: ARRAY OF CHAR; size: LONGINT): LONGINT;
VAR res: LONGINT;
BEGIN
  res := getxattr(path, name, value, size);
  RETURN res;
END GetAttr;

PROCEDURE SetAttr*(path: ARRAY OF CHAR; name: ARRAY OF CHAR; value: ARRAY OF CHAR; size: LONGINT; flags: LONGINT): LONGINT;
BEGIN
  RETURN setxattr(path, name, value, size, flags)
END SetAttr;

PROCEDURE RemoveAttr*(path: ARRAY OF CHAR; name: ARRAY OF CHAR): LONGINT;
BEGIN
  RETURN removexattr(path, name)
END RemoveAttr;

END xattr.

