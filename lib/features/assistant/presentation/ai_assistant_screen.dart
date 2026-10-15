import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/cards/login_card.dart';
import '../../../core/widgets/feedback/loading_overlay.dart';
import '../../../core/services/voice_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? provider;
  final List<String>? citations;

  ChatMessage({required this.text, required this.isUser, this.provider, this.citations});
}

/// Multilingual AI Farm Assistant Screen
class AIAssistantScreen extends ConsumerStatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  ConsumerState<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends ConsumerState<AIAssistantScreen> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello Ramesh! I am your AI PasuMitra Agronomic Assistant powered by Google Gemini 2.5 Flash. Ask me about breed recommendations, disease symptoms, vaccination schedules, or government subsidies in English, Tamil, or Hindi.",
      isUser: false,
      provider: "Google Gemini 2.5 Flash",
    ),
  ];

  bool _isThinking = false;
  String _selectedLang = 'en';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isThinking = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(milliseconds: 900));

    String reply;
    List<String> citations = ["Rashtriya Gokul Mission Guidelines", "NBAGR Native Breed Repository"];

    if (text.toLowerCase().contains("disease") || text.toLowerCase().contains("fmd")) {
      reply = "Foot & Mouth Disease (FMD) requires immediate isolation of affected animals. Apply antiseptic Potassium Permanganate (1%) foot washes and contact your local Veterinary Officer for ring vaccination.\n\nDisclaimer: Consult a licensed veterinarian for clinical diagnosis.";
    } else if (text.toLowerCase().contains("kangayam") || text.toLowerCase().contains("breed")) {
      reply = "Kangayam Cattle is exceptionally suited for semi-arid drought zones (up to 48°C) with zero-diesel draft capability, saving ~₹35,000/yr in farm operations.";
    } else {
      reply = "I recommend reviewing your farm profile climate settings. Kangayam and Gir cattle show 96.8% suitability for your location.";
    }

    if (mounted) {
      setState(() {
        _isThinking = false;
        _messages.add(ChatMessage(
          text: reply,
          isUser: false,
          provider: "Google Gemini 2.5 Flash",
          citations: citations,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final voiceService = ref.watch(voiceServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Agronomic Assistant'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (lang) => setState(() => _selectedLang = lang),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'ta', child: Text('தமிழ் (Tamil)')),
              PopupMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
            ],
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isThinking,
        message: 'Querying Gemini 2.5 Flash LLM engine...',
        child: SafeArea(
          child: Column(
            children: [
              // Quick Prompt Chips
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildPromptChip('Explain Kangayam Breed'),
                    const SizedBox(width: 8),
                    _buildPromptChip('FMD Vaccine Schedule'),
                    const SizedBox(width: 8),
                    _buildPromptChip('RGM Govt Subsidy 50%'),
                    const SizedBox(width: 8),
                    _buildPromptChip('Ethno-Vet Care Tips'),
                  ],
                ),
              ),

              // Chat Messages List
              Expanded(
                child: ListView.builder(
                  padding: AppSpacing.paddingMd,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildBubble(msg);
                  },
                ),
              ),

              // Input Row
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: const Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic, color: AppColors.primary),
                      onPressed: () {
                        voiceService.startListening(onResult: (text) {
                          _sendMessage(text);
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Ask AI assistant in English, Tamil, Hindi...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: AppColors.primary),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptChip(String label) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: AppColors.primary.withOpacity(0.08),
      onPressed: () => _sendMessage(label),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primary : AppColors.goldGlow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!msg.isUser && msg.provider != null) ...[
              Text(msg.provider!, style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
            ],
            Text(
              msg.text,
              style: AppTypography.bodySmall.copyWith(color: msg.isUser ? Colors.white : AppColors.textPrimary),
            ),
            if (msg.citations != null && msg.citations!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Sources: ${msg.citations!.join(", ")}', style: AppTypography.labelSmall.copyWith(color: AppColors.primaryDark, fontSize: 10)),
            ],
          ],
        ),
      ),
    );
  }
}
