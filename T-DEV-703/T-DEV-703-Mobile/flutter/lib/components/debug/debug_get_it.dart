import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bite/services/debug/debug_get_it.dart'; // Adjust import path

class GetItDebugWidget extends StatelessWidget {
  final List<String> registeredTypeNames;
  late final Map<String, Object> registeredSingletons;

  GetItDebugWidget({required this.registeredTypeNames, super.key}) {
    registeredSingletons = Map.from(DebugGetIt.registeredInstances);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key("GetItDebugWidget"),
      child: const SizedBox.shrink(),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<String>('registeredTypeNames', registeredTypeNames));
    properties.add(DiagnosticsProperty<Map<String, Object>>('registeredSingletons', registeredSingletons));
  }
}