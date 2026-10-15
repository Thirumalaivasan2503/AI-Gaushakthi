import React, { useState, useRef, useEffect } from 'react';
import { apiService } from '../../services/api';
import { ChatMessage } from '../../types';
import { useAuth } from '../../context/AuthContext';
import { 
  Bot, 
  X, 
  Send, 
  Mic, 
  MicOff, 
  Sparkles, 
  ShieldAlert,
  PhoneOff,
  Volume2
} from 'lucide-react';

interface VoiceAssistantDrawerProps {
  isOpen: boolean;
  onClose: () => void;
}

export const VoiceAssistantDrawer: React.FC<VoiceAssistantDrawerProps> = ({ isOpen, onClose }) => {
  const { language, t } = useAuth();
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const [isListening, setIsListening] = useState(false);
  const [loading, setLoading] = useState(false);

  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Initialize initial message in selected language
  useEffect(() => {
    const initialText = language === 'ta'
      ? '🙏 வணக்கம்! గౌಶಕ್ತಿ (GauShakthi) AI குரல் உதவிக்கு வரவேற்கிறோம். நாட்டு மாட்டு இனங்கள், பால் தரம், பசுந்தீவனம் அல்லது அரசு மானியங்கள் பற்றி எதையும் கேட்கலாம்!'
      : language === 'hi'
      ? '🙏 नमस्ते! GauShakthi AI वॉयस सहायक में आपका स्वागत है। स्वदेशी नस्लों, दूध गुणवत्ता, हरे चारे या सरकारी सब्सिडी के बारे में कुछ भी पूछें!'
      : '🙏 Vanakkam! Welcome to GauShakthi AI Voice Assistant. Ask me about indigenous breeds (Kangayam, Umblachery, Bargur), feed nutrition, heat stress prevention, or government subsidies!';

    setMessages([
      {
        id: 'init-1',
        sender: 'assistant',
        text: initialText,
        timestamp: 'Just now',
        provider: 'Gemini 2.5 Flash',
        piiMasked: true,
        medicalDisclaimer: true,
      },
    ]);
  }, [language]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // Web Speech Text-to-Speech (TTS)
  const speakText = (text: string) => {
    if ('speechSynthesis' in window && text) {
      window.speechSynthesis.cancel(); // Stop prior audio
      const cleanText = text.replace(/[*_#]/g, '');
      const utterance = new SpeechSynthesisUtterance(cleanText);
      utterance.rate = 0.95;

      if (language === 'ta') utterance.lang = 'ta-IN';
      else if (language === 'hi') utterance.lang = 'hi-IN';
      else utterance.lang = 'en-IN';

      window.speechSynthesis.speak(utterance);
    }
  };

  const handleSend = async (textToSend?: string, speakVoice: boolean = false) => {
    const messageText = textToSend || input;
    if (!messageText.trim() || loading) return;

    const userMsg: ChatMessage = {
      id: 'usr-' + Date.now(),
      sender: 'user',
      text: messageText,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    };

    setMessages((prev) => [...prev, userMsg]);
    if (!textToSend) setInput('');
    setLoading(true);

    try {
      const response = await apiService.sendChatMessage(messageText, 'Gemini 2.5 Flash', language);
      setMessages((prev) => [...prev, response]);
      // Only speak out loud if mic symbol was clicked / voice mode active!
      if (speakVoice && response && response.text && !response.isError) {
        speakText(response.text);
      }
    } catch (err: any) {
      if (err?.name === 'CanceledError' || err?.code === 'ERR_CANCELED') {
        // Request was aborted, do not output error bubble
        return;
      }
      console.error('Error sending message:', err);
    } finally {
      setLoading(false);
    }
  };

  // Robust Speech Recognition (STT) with language binding
  const toggleListening = () => {
    const SpeechRecognition = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;

    if (!SpeechRecognition) {
      // Fallback voice simulation for browsers without Web Speech API
      setIsListening(true);
      setTimeout(() => {
        const sampleQuery = language === 'ta'
          ? 'காங்கேயம் மாட்டின் பால் அளவு எவ்வளவு?'
          : language === 'hi'
          ? 'कांगयम गाय का दूध उत्पादन कितना है?'
          : 'What is the milk yield of Kangayam cow?';
        setInput(sampleQuery);
        setIsListening(false);
        handleSend(sampleQuery, true);
      }, 2000);
      return;
    }

    if (isListening) {
      setIsListening(false);
    } else {
      try {
        const recognition = new SpeechRecognition();
        recognition.lang = language === 'ta' ? 'ta-IN' : language === 'hi' ? 'hi-IN' : 'en-IN';
        recognition.continuous = false;
        recognition.interimResults = false;

        recognition.onstart = () => setIsListening(true);
        recognition.onresult = (event: any) => {
          const transcript = event.results[0][0].transcript;
          if (transcript) {
            setInput(transcript);
            setIsListening(false);
            handleSend(transcript, true);
          }
        };

        recognition.onerror = (err: any) => {
          console.warn('Speech Recognition notice:', err);
          setIsListening(false);
        };
        recognition.onend = () => setIsListening(false);

        recognition.start();
      } catch (e) {
        console.error('Speech recognition start failed:', e);
        setIsListening(false);
      }
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 overflow-hidden">
      <div className="absolute inset-0 bg-slate-950/60 backdrop-blur-xs transition-opacity" onClick={onClose} />

      <div className="fixed inset-y-0 right-0 max-w-full flex pl-10">
        <div className="w-screen max-w-md bg-white dark:bg-slate-900 shadow-2xl flex flex-col border-l border-slate-200 dark:border-slate-800">
          
          {/* Drawer Header */}
          <div className="p-4 bg-gradient-to-r from-emerald-700 to-teal-800 text-white flex items-center justify-between">
            <div className="flex items-center space-x-2">
              <div className="w-9 h-9 rounded-xl bg-white/10 flex items-center justify-center">
                <Bot className="w-5 h-5 text-emerald-200" />
              </div>
              <div>
                <h3 className="font-bold text-sm leading-tight">{t('voiceTitle')}</h3>
                <p className="text-[10px] text-emerald-200">{t('voiceSubtitle')}</p>
              </div>
            </div>

            <button onClick={onClose} className="p-1.5 rounded-lg hover:bg-white/10 text-emerald-100">
              <X className="w-5 h-5" />
            </button>
          </div>

          {/* Safety & PII Banner */}
          <div className="bg-amber-50 dark:bg-amber-950/40 px-3 py-1.5 border-b border-amber-200 dark:border-amber-800/60 flex items-center justify-between text-[11px] text-amber-800 dark:text-amber-300">
            <div className="flex items-center space-x-1.5">
              <PhoneOff className="w-3.5 h-3.5 text-amber-600 shrink-0" />
              <span>{t('piiBanner')}</span>
            </div>
          </div>

          {/* Chat Messages Log */}
          <div className="flex-1 p-4 overflow-y-auto space-y-3 bg-slate-50/50 dark:bg-slate-950/50">
            {messages.map((msg) => (
              <div
                key={msg.id}
                className={`flex flex-col ${msg.sender === 'user' ? 'items-end' : 'items-start'}`}
              >
                <div
                  className={`max-w-[85%] rounded-2xl p-3 text-xs ${
                    msg.sender === 'user'
                      ? 'bg-emerald-600 text-white rounded-br-none shadow-sm'
                      : msg.isError
                      ? 'bg-rose-50 dark:bg-rose-950/20 text-rose-800 dark:text-rose-300 rounded-bl-none border border-rose-200 dark:border-rose-900 shadow-xs font-semibold'
                      : 'bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-200 rounded-bl-none border border-slate-200 dark:border-slate-700 shadow-xs'
                  }`}
                >
                  <p className="whitespace-pre-line leading-relaxed">{msg.text}</p>
                  {msg.sender === 'assistant' && (
                    <button
                      onClick={() => speakText(msg.text)}
                      className="mt-2 text-[10px] flex items-center space-x-1 text-emerald-600 dark:text-emerald-400 hover:underline font-bold"
                    >
                      <Volume2 className="w-3 h-3" />
                      <span>{language === 'ta' ? 'குரல் ஆடியோ சொல்' : language === 'hi' ? 'आवाज सुनें' : 'Listen Audio'}</span>
                    </button>
                  )}
                </div>

                {msg.sender === 'assistant' && msg.medicalDisclaimer && (
                  <span className="text-[10px] text-slate-400 dark:text-slate-500 mt-1 flex items-center space-x-1">
                    <ShieldAlert className="w-3 h-3 text-amber-500" />
                    <span>{t('disclaimer')}</span>
                  </span>
                )}

                <span className="text-[9px] text-slate-400 mt-0.5 px-1">{msg.timestamp}</span>
              </div>
            ))}
            {loading && (
              <div className="flex items-center space-x-2 text-xs text-slate-400 p-2">
                <Sparkles className="w-4 h-4 text-emerald-500 animate-spin" />
                <span>AI processing...</span>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>

          {/* Quick Suggestion Pills */}
          <div className="px-3 py-2 bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800 overflow-x-auto whitespace-nowrap flex space-x-2 text-[11px]">
            <button
              onClick={() => !loading && handleSend(language === 'ta' ? 'காங்கேயம் மாட்டின் சிறப்பம்சங்கள் என்ன?' : language === 'hi' ? 'कांगयम गाय की विशेषताएं क्या हैं?' : 'What are Kangayam breed traits?')}
              disabled={loading}
              className="px-2.5 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-emerald-100 border border-slate-200 dark:border-slate-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              🐄 {language === 'ta' ? 'காங்கேயம் மாடு' : language === 'hi' ? 'कांगयम गाय' : 'Kangayam Cow'}
            </button>
            <button
              onClick={() => !loading && handleSend(language === 'ta' ? 'வெப்ப அழுத்தத்தில் மாடுகளை பாதுகாப்பது எப்படி?' : language === 'hi' ? 'गर्मी से मवेशियों का बचाव कैसे करें?' : 'How to protect cattle from heat stress?')}
              disabled={loading}
              className="px-2.5 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-emerald-100 border border-slate-200 dark:border-slate-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              ☀️ {language === 'ta' ? 'வெப்பத் தணிப்பு' : language === 'hi' ? 'गर्मी तनाव' : 'Heat Stress'}
            </button>
          </div>

          {/* Input Footer */}
          <div className="p-3 bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800 flex items-center space-x-2">
            <button
              onClick={toggleListening}
              disabled={loading}
              className={`p-2.5 rounded-xl border transition disabled:opacity-50 disabled:cursor-not-allowed ${
                isListening
                  ? 'bg-rose-500 text-white border-rose-600 animate-pulse'
                  : 'bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-700 hover:bg-slate-200'
              }`}
              title={isListening ? t('micListening') : t('micClickToSpeak')}
            >
              {isListening ? <MicOff className="w-4 h-4" /> : <Mic className="w-4 h-4" />}
            </button>

            <input
              type="text"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && !loading && handleSend()}
              disabled={loading}
              placeholder={isListening ? t('micListening') : t('askPlaceholder')}
              className="flex-1 bg-slate-100 dark:bg-slate-800 text-slate-900 dark:text-white px-3 py-2 rounded-xl text-xs border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-emerald-500 disabled:opacity-50"
            />

            <button
              onClick={() => handleSend()}
              disabled={loading || !input.trim()}
              className="p-2.5 rounded-xl bg-emerald-600 text-white hover:bg-emerald-700 disabled:opacity-50 disabled:cursor-not-allowed transition shadow-md shadow-emerald-500/20 font-semibold text-xs"
            >
              {t('send')}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
