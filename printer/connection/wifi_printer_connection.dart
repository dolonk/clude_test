import 'dart:io';
import 'dart:typed_data';

class WifiPrinterConnection {
  final String ipAddress;
  final int port;
  final Duration timeout;

  WifiPrinterConnection({
    required this.ipAddress,
    this.port = 9100, // standard printer port
    this.timeout = const Duration(seconds: 5),
  });

  /// Send pre-encoded ESC/P bytes via TCP socket
  Future<void> sendBytes(Uint8List bytes) async {
    Socket? socket;
    try {
      socket = await Socket.connect(ipAddress, port, timeout: timeout);

      socket.add(bytes);
      await socket.flush();
    } on SocketException catch (e) {
      throw PrinterException('WiFi connect failed: ${e.message}');
    } catch (e) {
      throw PrinterException('WiFi send failed: $e');
    } finally {
      await socket?.close();
    }
  }

  /// Test connection
  Future<bool> isReachable() async {
    try {
      final socket = await Socket.connect(ipAddress, port, timeout: const Duration(seconds: 3));
      await socket.close();
      return true;
    } catch (_) {
      return false;
    }
  }
}

class PrinterException implements Exception {
  final String message;
  const PrinterException(this.message);

  @override
  String toString() => 'PrinterException: $message';
}
