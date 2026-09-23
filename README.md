# cordova-plugin-barcodescanner-binary-qr

Cordova BarcodeScanner with **binary/gzip QR** support.

This is an [Ecologium](https://github.com/ecologium) fork of [`@red-mobile/cordova-plugin-barcodescanner`](https://www.npmjs.com/package/@red-mobile/cordova-plugin-barcodescanner) 9.1.0 ([okhiroyuki/cordova-plugin-barcodescanner](https://github.com/okhiroyuki/cordova-plugin-barcodescanner)). Gzip/binary QR decoding is ported from [ecologium/phonegap-plugin-barcodescanner](https://github.com/ecologium/phonegap-plugin-barcodescanner) (`73c340d4`).

The JS API is unchanged: `cordova.plugins.barcodeScanner`. `@ionic-native/barcode-scanner` keeps working.

## Binary / gzip QR

On a successful Android scan the plugin reads ZXing `SCAN_RESULT_BYTES`, unpacks the nibble-padded payload, and gunzips it (`GZIPInputStream`).

- If unzip succeeds, `result.text` is the decompressed UTF-8 string (Testo/Sauermann binary QR).
- If there are no raw bytes, or unzip fails, `result.text` is the normal `SCAN_RESULT` string (plain QR/barcodes).

This path is Android-only. iOS leftover code (`CDVBarcodeScanner.mm`) uses AVFoundation `stringValue` and cannot decode binary QR.

## Installation

Requires Cordova 10+ and cordova-android 9+.

```
cordova plugin add https://github.com/ecologium/cordova-plugin-barcodescanner-binary-qr.git
```

Optional variable: AndroidX legacy support library v4. Default is `1.0.0`. See [AndroidX versions](https://developer.android.com/jetpack/androidx/versions).

```
cordova plugin add https://github.com/ecologium/cordova-plugin-barcodescanner-binary-qr.git --variable ANDROIDX_LEGACY_SUPPORT_V4_VERSION="1.0.0"
```

### Uninstall

```
cordova plugin remove cordova-plugin-barcodescanner-binary-qr
```

### Supported Platforms

- Android

The Android scan UI ships as a prebuilt AAR (`barcodescanner-release-2.1.7.aar`). Plugman does not support library-project refs; update that AAR if you change the library project.

## Using the plugin

The plugin creates `cordova.plugins.barcodeScanner` with `scan(success, fail)`.

| Barcode Type | Android |
|--------------|:-------:|
| QR_CODE      |    ✔    |
| DATA_MATRIX  |    ✔    |
| UPC_A        |    ✔    |
| UPC_E        |    ✔    |
| EAN_8        |    ✔    |
| EAN_13       |    ✔    |
| CODE_39      |    ✔    |
| CODE_93      |    ✔    |
| CODE_128     |    ✔    |
| CODABAR      |    ✔    |
| ITF          |    ✔    |
| RSS14        |    ✔    |
| PDF_417      |    ✔    |
| RSS_EXPANDED |    ✔    |
| MSI          |    ✖    |
| AZTEC        |    ✔    |

`success` receives `{ text, format, cancelled }`. `text` is the barcode string, or the gunzipped payload for binary QR.

```js
cordova.plugins.barcodeScanner.scan(
  function (result) {
    alert("We got a barcode\n" +
          "Result: " + result.text + "\n" +
          "Format: " + result.format + "\n" +
          "Cancelled: " + result.cancelled);
  },
  function (error) {
    alert("Scanning failed: " + error);
  },
  {
    preferFrontCamera: true,
    showFlipCameraButton: true,
    showTorchButton: true,
    torchOn: true,
    saveHistory: true,
    prompt: "Place a barcode inside the scan area",
    resultDisplayDuration: 500,
    formats: "QR_CODE,PDF_417",
    orientation: "landscape",
    disableSuccessBeep: false
  }
);
```

## Encoding a Barcode

`cordova.plugins.barcodeScanner.encode(type, data, success, fail)`.

Supported encoding types:

* TEXT_TYPE
* EMAIL_TYPE
* PHONE_TYPE
* SMS_TYPE

```js
cordova.plugins.barcodeScanner.encode(
  cordova.plugins.barcodeScanner.Encode.TEXT_TYPE,
  "http://www.nytimes.com",
  function (success) {
    alert("encode success: " + success);
  },
  function (fail) {
    alert("encoding failed: " + fail);
  }
);
```

## Lineage

- [@red-mobile/cordova-plugin-barcodescanner](https://www.npmjs.com/package/@red-mobile/cordova-plugin-barcodescanner) 9.1.0 — Gradle/AndroidX base
- [phonegap-plugin-barcodescanner](https://github.com/phonegap/phonegap-plugin-barcodescanner) — original Cordova plugin
- [ecologium/phonegap-plugin-barcodescanner@73c340d4](https://github.com/ecologium/phonegap-plugin-barcodescanner) — gzip/binary QR Java
