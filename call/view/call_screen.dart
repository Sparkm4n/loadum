import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutex_admin/common/components/buttons/rounded_button.dart';
import 'package:flutex_admin/common/components/text-form-field/custom_text_field.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/style.dart';

import 'package:flutex_admin/core/service/api_service.dart';
import 'package:flutex_admin/features/call/repo/call_repo.dart';
import 'package:flutex_admin/features/call/service/twilio_voice_service.dart' hide CallState;
import '../controller/call_controller.dart';

/// ===== Loadum Brandfarben
const Color _brandPrimary = Color(0xFF3E6FCB);
const Color _brandAccent  = Color(0xFF76D9E7);
const Color _lineGray     = Color(0xFFE5E7EB);

/// Sicherer Prefix (kein RangeError)
String _safePrefix(String? text, int max) {
  if (text == null || text.isEmpty) return '—';
  final end = text.length < max ? text.length : max;
  return text.substring(0, end);
}

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  void _ensureDeps() {
    if (!Get.isRegistered<ApiClient>()) {
      Get.put(ApiClient(sharedPreferences: Get.find()), permanent: true);
    }
    if (!Get.isRegistered<TwilioVoiceService>()) {
      Get.put(TwilioVoiceService(), permanent: true);
    }
    if (!Get.isRegistered<CallRepo>()) {
      Get.put(CallRepo(apiClient: Get.find<ApiClient>()), permanent: true);
    }
    if (!Get.isRegistered<CallController>()) {
      Get.put(
        CallController(
          callRepo: Get.find<CallRepo>(),
          voice: Get.find<TwilioVoiceService>(),
        ),
        permanent: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _ensureDeps();
    Get.find<CallController>().initScreen();
  }

  /// Immer hart zurück zum Dashboard (Web-sicher). Call ggf. nebenläufig beenden.
  Future<void> _goDashboard(CallController c) async {
    if (c.isCalling || c.inCall) {
      // nebenläufig; blockiert nicht die Navigation
      () async { try { await c.endCall(); } catch (_) {} }();
    }
    Get.offAllNamed('/dashboard_screen'); // ggf. Route hier anpassen
  }

  // ---------- Quick Actions ----------
  Future<void> _openKeypad(CallController c) async {
    final ctrl = TextEditingController(text: c.phoneCtrl.text);
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Dial pad', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Phone number',
                hintText: '+1 555 123 4567',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  c.phoneCtrl.text = ctrl.text;
                  c.update();
                  Navigator.pop(context);
                },
                child: const Text('Use number'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _openMessageComposer(CallController c) async {
    final to = c.normalizedTo.isNotEmpty ? c.normalizedTo : c.phoneCtrl.text;
    final msgCtrl = TextEditingController(
      text: 'Hi! This is ${c.selectedFromNumber}. Quick update regarding your cleaning service…',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Send message', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('To: ${to.isEmpty ? '—' : to}', style: lightDefault),
            const SizedBox(height: 12),
            TextField(
              controller: msgCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                labelText: 'Message',
                hintText: 'Type your message…',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: msgCtrl.text));
                      Get.snackbar('Copied', 'Message copied to clipboard',
                          snackPosition: SnackPosition.BOTTOM);
                      Navigator.pop(context);
                    },
                    child: const Text('Copy & close'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<CallController>(
      builder: (c) {
        return WillPopScope(
          // Hardware/Browser-Back: immer hart aufs Dashboard
          onWillPop: () async { await _goDashboard(c); return false; },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              foregroundColor: const Color(0xFF0F172A),
              titleSpacing: 0,
              // AppBar-Back: sofort Dashboard
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => _goDashboard(c),
              ),
              title: const Text('Calling'),
              actions: [
                IconButton(
                  tooltip: 'Keypad',
                  icon: const Icon(Icons.dialpad_outlined),
                  onPressed: () => _openKeypad(c),
                ),
              ],
            ),

            body: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.space15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Hero (OpenPhone-Look + Loadum)
                  Container(
                    width: double.infinity,
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
                              Text(
                                'Loadum Dialer',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cleaning CRM • Reach clients fast. Log notes. Stay organized.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _brandAccent.withOpacity(.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Mobile',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _brandPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.space20),

                  // ===== Outbound line / Auto-number
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Outbound line', style: semiBoldLarge),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: c.fromNumbers.contains(c.selectedFromNumber)
                              ? c.selectedFromNumber
                              : null,
                          items: c.fromNumbers
                              .map((n) => DropdownMenuItem<String>(value: n, child: Text(n)))
                              .toList(),
                          onChanged: (c.isCalling || c.fromNumbers.isEmpty)
                              ? null
                              : (v) => c.setFromNumber(v ?? ''),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Select number to present',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              c.autoNumberingEnabled ? Icons.autorenew : Icons.call_made_outlined,
                              size: 18,
                              color: _brandPrimary,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                c.autoNumberingEnabled
                                    ? 'Auto-generated tracking number will be used.'
                                    : 'Calls will present this number to the client.',
                                style: lightSmall,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Switch.adaptive(
                              activeColor: _brandPrimary,
                              value: c.autoNumberingEnabled,
                              onChanged: c.isCalling ? null : (v) => c.toggleAutoNumbering(v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimensions.space15),

                  // ===== Phone & note
                  CustomTextField(
                    labelText: 'Phone number',
                    hintText: '+1 555 123 4567',
                    controller: c.phoneCtrl,
                    textInputType: TextInputType.phone,
                    inputAction: TextInputAction.next,
                    onChanged: c.onPhoneChanged,
                  ),
                  const SizedBox(height: Dimensions.space15),

                  CustomTextField(
                    labelText: 'Call note (optional)',
                    hintText: 'Gate code, alarm, access details…',
                    controller: c.noteCtrl,
                    textInputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    maxLines: 3,
                    onChanged: (_) {},
                  ),

                  const SizedBox(height: Dimensions.space20),

                  // ===== Details
                  _DetailsCard(controller: c),

                  const SizedBox(height: Dimensions.space15),

                  // ===== Controls
                  Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                          text: c.isCalling ? 'Calling…' : (c.inCall ? 'In call' : 'Start call'),
                          press: () {
                            if (!c.isCalling && !c.inCall) {
                              c.startCall(c.phoneCtrl.text);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _lineGray),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: (c.isCalling || c.inCall) ? () => c.endCall() : null,
                          child: const Text('End call'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // ===== Quick toggles
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _pillToggle(
                        selected: c.muted,
                        icon: c.muted ? Icons.mic_off : Icons.mic_none_outlined,
                        labelOn: 'Muted',
                        labelOff: 'Mute',
                        onTap: c.toggleMute,
                      ),
                      _pillToggle(
                        selected: c.speakerOn,
                        icon: Icons.volume_up,
                        labelOn: 'Speaker on',
                        labelOff: 'Speaker',
                        onTap: c.toggleSpeaker,
                      ),
                      _pillToggle(
                        selected: c.recordingEnabled,
                        icon: Icons.fiber_manual_record,
                        labelOn: 'Recording on',
                        labelOff: 'Record',
                        onTap: c.toggleRecording,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ===== Quick actions
                  Row(
                    children: [
                      _quickAction(
                        icon: Icons.chat_bubble_outline,
                        label: 'Send message',
                        onTap: () => _openMessageComposer(c),
                      ),
                      const SizedBox(width: 10),
                      _quickAction(
                        icon: Icons.dialpad,
                        label: 'Keypad',
                        onTap: () => _openKeypad(c),
                      ),
                      const SizedBox(width: 10),
                      _quickAction(
                        icon: Icons.person_add_alt,
                        label: 'Add contact',
                        onTap: () {
                          Get.snackbar('Contacts', 'Open Add Contact flow',
                              snackPosition: SnackPosition.BOTTOM);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: Dimensions.space20),

                  // ===== Recent calls
                  if (c.recentCalls.isNotEmpty) ...[
                    Text('Recent calls', style: semiBoldLarge),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.04),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: c.recentCalls.take(5).map((log) {
                          return Column(
                            children: [
                              ListTile(
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                leading: Icon(Icons.call_made_outlined, color: _brandPrimary),
                                title: Text('${log.toNumber} • ${log.outcome}'),
                                subtitle: Text(
                                  '${log.startedAtStr}   ·   ${log.formattedDuration}',
                                  style: lightSmall,
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.refresh),
                                  tooltip: 'Redial',
                                  onPressed: () => c.redial(log),
                                ),
                                onTap: () {
                                  c.phoneCtrl.text = log.toNumber;
                                  c.update();
                                },
                              ),
                              if (log != c.recentCalls.take(5).last)
                                const Divider(height: 1, color: _lineGray),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: Dimensions.space10),
                  Text(
                    'Tip: Save notes while you talk. Notes are linked to the client profile.',
                    style: lightSmall,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final CallController controller;
  const _DetailsCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _Chip(status: controller.statusLabel, color: cs.primary),
            const SizedBox(width: 8),
            if (controller.inCall || controller.isCalling)
              _Chip(status: controller.formattedElapsed, color: cs.secondary),
          ]),
          const SizedBox(height: 12),
          _infoRow(context, 'From', controller.selectedFromNumber),
          _infoRow(context, 'To', controller.normalizedTo.isEmpty ? '—' : controller.normalizedTo),
          _infoRow(context, 'Recording', controller.recordingEnabled ? 'On' : 'Off'),
          _infoRow(context, 'Call ID', _safePrefix(controller.currentCallId, 10)),
          if (controller.tokenExpiresAt != null)
            _infoRow(
              context,
              'Token',
              'valid until ${controller.tokenExpiresAt!.hour.toString().padLeft(2, '0')}:${controller.tokenExpiresAt!.minute.toString().padLeft(2, '0')}',
            ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String k, String v) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(k, style: lightDefault)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              v,
              style: regularDefault.copyWith(color: theme.textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String status;
  final Color color;
  const _Chip({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(.35)),
      ),
      child: Text(
        status,
        style: regularSmall.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// ===== UI-Hilfen
Widget _pillToggle({
  required bool selected,
  required IconData icon,
  required String labelOn,
  required String labelOff,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(24),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? _brandAccent.withOpacity(.18) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: selected ? _brandPrimary.withOpacity(.35) : _lineGray,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: selected ? _brandPrimary : const Color(0xFF111827)),
          const SizedBox(width: 8),
          Text(selected ? labelOn : labelOff,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    ),
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
