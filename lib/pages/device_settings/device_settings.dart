import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';

import 'package:beep/pages/device_settings/device_settings_view.dart';
import 'package:beep/pages/key_verification/key_verification_dialog.dart';
import 'package:beep/utils/localized_exception_extension.dart';
import '../../widgets/matrix.dart';

class DevicesSettings extends StatefulWidget {
  const DevicesSettings({super.key});

  @override
  DevicesSettingsController createState() => DevicesSettingsController();
}

class DevicesSettingsController extends State<DevicesSettings> {
  List<Device>? devices;
  Future<bool> loadUserDevices(BuildContext context) async {
    if (devices != null) return true;
    devices = await Matrix.of(context).client.getDevices();
    return true;
  }

  void reload() => setState(() => devices = null);

  bool loadingDeletingDevices = false;
  String? errorDeletingDevices;

  void removeDevicesAction(List<Device> devices) async {
    if (await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context)!.areYouSure,
          okLabel: L10n.of(context)!.yes,
          cancelLabel: L10n.of(context)!.cancel,
          message: L10n.of(context)!.removeDevicesDescription,
        ) ==
        OkCancelResult.cancel) return;
    final matrix = Matrix.of(context);
    final deviceIds = <String>[];
    for (final userDevice in devices) {
      deviceIds.add(userDevice.deviceId);
    }

    try {
      setState(() {
        loadingDeletingDevices = true;
        errorDeletingDevices = null;
      });
      await matrix.client.uiaRequestBackground(
        (auth) => matrix.client.deleteDevices(
          deviceIds,
          auth: auth,
        ),
      );
      reload();
    } catch (e, s) {
      Logs().w('Error while deleting devices', e, s);
      setState(() => errorDeletingDevices = e.toLocalizedString(context));
    } finally {
      setState(() => loadingDeletingDevices = false);
    }
  }

  void renameDeviceAction(Device device) async {
    final displayName = await showTextInputDialog(
      context: context,
      title: L10n.of(context)!.changeDeviceName,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          hintText: device.displayName,
        ),
      ],
    );
    if (displayName == null) return;
    final success = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context)
          .client
          .updateDevice(device.deviceId, displayName: displayName.single),
    );
    if (success.error == null) {
      reload();
    }
  }

  void verifyDeviceAction(Device device) async {
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(context)!.verifyOtherDevice,
      message: L10n.of(context)!.verifyOtherDeviceDescription,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      fullyCapitalizedForMaterial: false,
    );
    if (consent != OkCancelResult.ok) return;
    final req = await Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID!]!
        .deviceKeys[device.deviceId]!
        .startVerification();
    req.onUpdate = () {
      if ({KeyVerificationState.error, KeyVerificationState.done}
          .contains(req.state)) {
        setState(() {});
      }
    };
    await KeyVerificationDialog(request: req).show(context);
  }

  void blockDeviceAction(Device device) async {
    final key = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID!]!
        .deviceKeys[device.deviceId]!;
    if (key.directVerified) {
      await key.setVerified(false);
    }
    await key.setBlocked(true);
    setState(() {});
  }

  void unblockDeviceAction(Device device) async {
    final key = Matrix.of(context)
        .client
        .userDeviceKeys[Matrix.of(context).client.userID!]!
        .deviceKeys[device.deviceId]!;
    await key.setBlocked(false);
    setState(() {});
  }

  bool _isOwnDevice(Device userDevice) =>
      userDevice.deviceId == Matrix.of(context).client.deviceID;

  Device? get thisDevice => devices!.firstWhereOrNull(
        _isOwnDevice,
      );

  List<Device> get notThisDevice => List<Device>.from(devices!)
    ..removeWhere(_isOwnDevice)
    ..sort((a, b) => (b.lastSeenTs ?? 0).compareTo(a.lastSeenTs ?? 0));

  @override
  Widget build(BuildContext context) => DevicesSettingsView(this);
}
