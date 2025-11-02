import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/divider/custom_divider.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';

import 'package:flutex_admin/features/call/controller/call_controller.dart';
import 'package:flutex_admin/features/call/repo/call_repo.dart';
import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/features/call/service/twilio_voice_service.dart' hide CallState;

/// ===== Loadum Brandfarben (wie im CallScreen)
const Color _brandPrimary = Color(0xFF3E6FCB);
const Color _brandAccent  = Color(0xFF76D9E7);
const Color _lineGray     = Color(0xFFE5E7EB);

class CallDialerScreen extends StatefulWidget {
  const CallDialerScreen({super.key, this.initialNumber});
  final String? initialNumber;

  @override
  State<CallDialerScreen> createState() => _CallDialerScreenState();
}

class _CallDialerScreenState extends State<CallDialerScreen> {
  @override
  void initState() {
    super.initState();

    // DI sicherstellen (wie im CallScreen)
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()), permanent: true);
    }
    if (!Get.isRegistered<CallRepo>()) {
      Get.put(CallRepo(apiClient: Get.find()), permanent: true);
    }
    if (!Get.isRegistered<TwilioVoiceService>()) {
      Get.put(TwilioVoiceService(), permanent: true);
    }
    if (!Get.isRegistered<CallController>()) {
      Get.put(CallController(callRepo: Get.find(), voice: Get.find<TwilioVoiceService>()), permanent: true);
    }

    final c = Get.find<CallController>();
    if ((widget.initialNumber ?? '').isNotEmpty) {
      c.phoneCtrl.text = widget.initialNumber!;
    }
  }

  /// Immer hart zum Dashboard, Call ggf. nebenläufig beenden
  Future<void> _goDashboard(CallController c) async {
    if (c.isCalling || c.inCall) {
      () async { try { await c.endCall(); } catch (_) {} }();
    }
    Get.offAllNamed('/dashboard_screen'); // ggf. an deine Route anpassen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<CallController>(
      builder: (c) {
        return WillPopScope(
          onWillPop: () async { await _goDashboard(c); return false; },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              foregroundColor: const Color(0xFF0F172A),
              titleSpacing: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => _goDashboard(c),
              ),
              title: const Text('Call client'),
              actions: [
                IconButton(
                  tooltip: 'Paste from clipboard',
                  icon: const Icon(Icons.content_paste_go_outlined),
                  onPressed: () async {
                    final data = await Clipboard.getData('text/plain');
                    final txt = (data?.text ?? '').trim();
                    if (txt.isNotEmpty) {
                      c.phoneCtrl.text = txt;
                      c.update();
                    }
                  },
                ),
              ],
            ),

            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.space15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Brand banner (OpenPhone-ähnlich, klar & kompakt)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.03),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('LOADUM Voice',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0F172A),
                                  )),
                              const SizedBox(height: 6),
                              Text('Call clients with your business identity.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF6B7280),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _brandAccent.withOpacity(.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Dialer',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _brandPrimary,
                                fontWeight: FontWeight.w700,
                              )),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: Dimensions.space20),

                  // Phone number
                  CustomTextField(
                    labelText: 'Phone number',
                    controller: c.phoneCtrl,
                    focusNode: c.phoneFocus,
                    textInputType: TextInputType.phone,
                    inputAction: TextInputAction.done,
                    onChanged: c.onPhoneChanged,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a phone number' : null,
                  ),

                  const SizedBox(height: Dimensions.space10),
                  const CustomDivider(),
                  const SizedBox(height: Dimensions.space10),

                  // Primary CTA
                  RoundedButton(
                    text: c.isCalling
                        ? 'Calling…'
                        : (c.inCall ? 'In call' : 'Call'),
                    press: () {
                      if (c.isCalling || c.inCall) return;
                      c.startCall(c.phoneCtrl.text);
                    },
                  ),

                  const SizedBox(height: Dimensions.space10),

                  // Call controls (sichtbar bei Aufbau oder Verbunden)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: (c.isCalling || c.inCall)
                        ? Container(
                      key: const ValueKey('controls'),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.06),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _chip(theme, 'Status', _statusText(c.callState), _brandPrimary),
                              const SizedBox(width: 8),
                              _chip(
                                theme,
                                'Elapsed',
                                c.formattedElapsed,
                                _brandAccent,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _controlButton(
                                icon: c.muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                                label: c.muted ? 'Unmute' : 'Mute',
                                onTap: c.toggleMute,
                                selected: c.muted,
                              ),
                              _controlButton(
                                icon: c.speakerOn ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
                                label: c.speakerOn ? 'Speaker off' : 'Speaker',
                                onTap: c.toggleSpeaker,
                                selected: c.speakerOn,
                              ),
                              _controlButton(
                                icon: c.recordingEnabled ? Icons.fiber_manual_record : Icons.fiber_manual_record_outlined,
                                label: c.recordingEnabled ? 'Stop Rec' : 'Record',
                                onTap: c.toggleRecording,
                                selected: c.recordingEnabled,
                              ),
                              _controlButton(
                                icon: Icons.call_end_rounded,
                                label: 'Hang up',
                                onTap: c.hangup,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),

                  const SizedBox(height: 12),

                  // Schnellzugriffe (optional, klein & dezent)
                  Row(
                    children: [
                      _quickAction(
                        icon: Icons.content_copy,
                        label: 'Copy number',
                        onTap: () async {
                          final n = c.phoneCtrl.text.trim();
                          if (n.isNotEmpty) {
                            await Clipboard.setData(ClipboardData(text: n));
                            Get.snackbar('Copied', 'Phone number copied',
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      _quickAction(
                        icon: Icons.backspace_outlined,
                        label: 'Clear',
                        onTap: () { c.phoneCtrl.clear(); c.update(); },
                      ),
                      const SizedBox(width: 10),
                      _quickAction(
                        icon: Icons.history,
                        label: 'Redial last',
                        onTap: () {
                          if (c.recentCalls.isNotEmpty) {
                            c.redial(c.recentCalls.first);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _statusText(CallState s) {
    switch (s) {
      case CallState.idle: return 'Idle';
      case CallState.connecting: return 'Connecting…';
      case CallState.ringing: return 'Ringing…';
      case CallState.connected: return 'Connected';
      case CallState.reconnecting: return 'Reconnecting…';
      case CallState.ended: return 'Ended';
      case CallState.failed: return 'Failed';
    }
  }

  Widget _chip(ThemeData theme, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(.35)),
      ),
      child: Row(
        children: [
          Text('$label: ', style: theme.textTheme.labelMedium),
          Text(
            value,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
    Color? color,
  }) {
    final base = color ?? ColorResources.blueGreyColor;
    return Column(
      children: [
        InkResponse(
          onTap: onTap,
          radius: 32,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: (selected ? _brandAccent : base).withOpacity(.12),
            child: Icon(icon, color: selected ? _brandPrimary : base),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: lightSmall),
      ],
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _lineGray),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.02), blurRadius: 8)],
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: _brandPrimary),
              const SizedBox(height: 6),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
