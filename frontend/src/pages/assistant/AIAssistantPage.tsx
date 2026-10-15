import React, { useState, useRef, useEffect } from 'react';
import { apiService } from '../../services/api';
import { ChatMessage } from '../../types';
import { useAuth } from '../../context/AuthContext';
import { 
  Bot, 
  Send, 
  Mic, 
  MicOff, 
  Volume2, 
  VolumeX, 
  ShieldAlert, 
  PhoneOff, 
  Sparkles 
} from 'lucide-react';

export const AIAssistantPage: React.FC = () => {
  const { language, t } = useAuth();

  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const [isListening, setIsListening] = useState(false);
  const [provider, setProvider] = useState<'Gemini 2.5 Flash' | 'GPT-4o' | 'Claude 3.5'>('Gemini 2.5 Flash');

  const messagesEndRef = useRef<HTMLDivElement>(null);

  // Initialize welcoming message in selected language
  useEffect(() => {
    const welcomeMsg = language === 'ta'
      ? '🙏 வணக்கம்! GauShakthi AI குரல் உதவிக்கு வரவேற்கிறோம். நாட்டு மாட்டு இனங்கள், பால் தரம், பசுந்தீவனம் அல்லது அரசு மானியங்கள் பற்றி எதையும் கேட்கலாம்!'
      : language === 'hi'
      ? '🙏 नमस्ते! GauShakthi AI वॉयस सहायक में आपका स्वागत है। स्वदेशी नस्लों, दूध गुणवत्ता, हरे चारे या सरकारी सब्सिडी के बारे में कुछ भी पूछें!'
      : '🙏 Vanakkam! Welcome to GauShakthi AI Voice Assistant. Speak or type your questions about indigenous breeds, feed formulas, heat stress, or subsidies.';

    setMessages([
      {
        id: 'init-1',
        sender: 'assistant',
        text: welcomeMsg,
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

  // Speech Synthesis Audio Output (TTS)
  const speakAudio = (text: string) => {
    if ('speechSynthesis' in window && text) {
      window.speechSynthesis.cancel(); // Cancel ongoing speech
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
    const text = textToSend || input;
    if (!text.trim() || loading) return;

    const userMsg: ChatMessage = {
      id: 'usr-' + Date.now(),
      sender: 'user',
      text,
      timestamp: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
    };

    setMessages((prev) => [...prev, userMsg]);
    if (!textToSend) setInput('');
    setLoading(true);

    try {
      const response = await apiService.sendChatMessage(text, provider, language);
      setMessages((prev) => [...prev, response]);
      // Only speak out loud if mic symbol was clicked / voice mode active!
      if (speakVoice && response && response.text && !response.isError) {
        speakAudio(response.text);
      }
    } catch (err: any) {
      if (err?.name === 'CanceledError' || err?.code === 'ERR_CANCELED') {
        // Request was intentionally cancelled, do not output error bubble
        return;
      }
      console.error('Error sending assistant message:', err);
    } finally {
      setLoading(false);
    }
  };

  // Robust Speech Recognition (STT) with Browser Fallback
  const toggleListening = () => {
    const SpeechRecognition = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;

    if (!SpeechRecognition) {
      // Voice simulation fallback if SpeechRecognition API is unavailable
      setIsListening(true);
      setTimeout(() => {
        const sampleText = language === 'ta'
          ? 'காங்கேயம் மாட்டின் பால் அளவு எவ்வளவு?'
          : language === 'hi'
          ? 'कांगयम गाय का दूध उत्पादन कितना है?'
          : 'What is the milk yield of Kangayam cow?';
        setInput(sampleText);
        setIsListening(false);
        handleSend(sampleText, true);
      }, 1800);
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
        recognition.onerror = () => setIsListening(false);
        recognition.onend = () => setIsListening(false);

        recognition.start();
      } catch (e) {
        console.error('Speech recognition start failed:', e);
        setIsListening(false);
      }
    }
  };

  return (
    <div className="max-w-4xl mx-auto space-y-6">
      <div className="bg-white dark:bg-slate-900 rounded-3xl border border-slate-200 dark:border-slate-800 shadow-xl overflow-hidden flex flex-col h-[75vh]">
        {/* Chat Header */}
        <div className="p-4 bg-gradient-to-r from-emerald-800 to-teal-900 text-white flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center">
              <Bot className="w-6 h-6 text-emerald-200" />
            </div>
            <div>
              <h2 className="font-bold text-sm leading-tight">{t('voiceTitle')}</h2>
              <p className="text-[10px] text-emerald-200">{t('voiceSubtitle')}</p>
            </div>
          </div>

          <select
            value={provider}
            onChange={(e) => setProvider(e.target.value as any)}
            disabled={loading}
            className="bg-emerald-950/80 text-xs font-semibold text-emerald-100 rounded-xl px-3 py-1.5 border border-emerald-700 focus:outline-none disabled:opacity-50"
          >
            <option value="Gemini 2.5 Flash">Gemini 2.5 Flash</option>
            <option value="GPT-4o">OpenAI GPT-4o</option>
            <option value="Claude 3.5">Claude 3.5 Sonnet</option>
          </select>
        </div>

        {/* Safety Disclaimer Banner */}
        <div className="bg-amber-50 dark:bg-amber-950/50 px-4 py-2 border-b border-amber-200 dark:border-amber-800/60 text-xs text-amber-800 dark:text-amber-300 flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <PhoneOff className="w-4 h-4 text-amber-600 shrink-0" />
            <span>{t('piiBanner')}</span>
          </div>
        </div>

        {/* Messages Body */}
        <div className="flex-1 p-6 overflow-y-auto space-y-4 bg-slate-50/50 dark:bg-slate-950/50">
          {messages.map((msg) => (
            <div key={msg.id} className={`flex flex-col ${msg.sender === 'user' ? 'items-end' : 'items-start'}`}>
              <div
                className={`max-w-[80%] rounded-2xl p-4 text-xs ${
                  msg.sender === 'user'
                    ? 'bg-emerald-600 text-white rounded-br-none shadow-md font-medium'
                    : msg.isError
                    ? 'bg-rose-50 dark:bg-rose-950/20 text-rose-800 dark:text-rose-300 rounded-bl-none border border-rose-200 dark:border-rose-900 shadow-xs font-semibold'
                    : 'bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-200 rounded-bl-none border border-slate-200 dark:border-slate-700 shadow-xs'
                }`}
              >
                <p className="whitespace-pre-line leading-relaxed text-xs">{msg.text}</p>

                {msg.sender === 'assistant' && (
                  <button
                    onClick={() => speakAudio(msg.text)}
                    className="mt-3 inline-flex items-center space-x-1.5 px-2.5 py-1 rounded-lg bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 hover:bg-emerald-100 font-bold text-[11px] border border-emerald-200 dark:border-emerald-800 transition"
                  >
                    <Volume2 className="w-3.5 h-3.5 text-emerald-600 dark:text-emerald-400" />
                    <span>{language === 'ta' ? 'குரல் ஆடியோ சொல் (Audio)' : language === 'hi' ? 'आवाज सुनें (Audio)' : 'Listen Voice Output'}</span>
                  </button>
                )}
              </div>

              {msg.sender === 'assistant' && (
                <div className="flex items-center space-x-2 text-[10px] text-slate-400 mt-1 px-1">
                  <span>{msg.provider}</span>
                  <span>•</span>
                  <span>{msg.timestamp}</span>
                </div>
              )}
            </div>
          ))}

          {loading && (
            <div className="text-xs text-slate-500 p-3 bg-white dark:bg-slate-800 rounded-2xl border border-slate-200 dark:border-slate-700 w-fit flex items-center space-x-2 shadow-xs">
              <Sparkles className="w-4 h-4 animate-spin text-emerald-500" />
              <span>AI Assistant is thinking...</span>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        {/* Quick Suggestion Voice Pills */}
        <div className="px-4 py-2 bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800 overflow-x-auto whitespace-nowrap flex space-x-2 text-[11px]">
          <button
            onClick={() => handleSend(language === 'ta' ? 'காங்கேயம் மாட்டின் சிறப்பம்சங்கள் என்ன?' : language === 'hi' ? 'कांगयम गाय की विशेषताएं क्या हैं?' : 'What are Kangayam breed traits?')}
            className="px-3 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-emerald-100 border border-slate-200 dark:border-slate-700"
          >
            🐄 {language === 'ta' ? 'காங்கேயம் மாடு' : language === 'hi' ? 'कांगयम गाय' : 'Kangayam Cow'}
          </button>
          <button
            onClick={() => handleSend(language === 'ta' ? 'வெப்ப அழுத்தத்தில் மாடுகளை பாதுகாப்பது எப்படி?' : language === 'hi' ? 'गर्मी से मवेशियों का बचाव कैसे करें?' : 'How to protect cattle from heat stress?')}
            className="px-3 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-emerald-100 border border-slate-200 dark:border-slate-700"
          >
            ☀️ {language === 'ta' ? 'வெப்பத் தணிப்பு' : language === 'hi' ? 'गर्मी तनाव' : 'Heat Stress'}
          </button>
          <button
            onClick={() => handleSend(language === 'ta' ? 'பசுந்தீவன விகிதம் என்ன?' : language === 'hi' ? 'हरा चारा अनुपात क्या है?' : 'What is green fodder ratio?')}
            className="px-3 py-1 rounded-full bg-slate-100 dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:bg-emerald-100 border border-slate-200 dark:border-slate-700"
          >
            🌾 {language === 'ta' ? 'பசுந்தீவனம்' : language === 'hi' ? 'हरा चारा' : 'Green Fodder'}
          </button>
        </div>

        {/* Input Bar */}
        <div className="p-4 bg-white dark:bg-slate-900 border-t border-slate-200 dark:border-slate-800 flex items-center space-x-3">
          <button
            onClick={toggleListening}
            className={`p-3 rounded-2xl border transition flex items-center space-x-1.5 ${
              isListening
                ? 'bg-rose-500 text-white border-rose-600 animate-pulse'
                : 'bg-emerald-50 dark:bg-emerald-950/60 text-emerald-700 dark:text-emerald-300 border-emerald-200 dark:border-emerald-800 hover:bg-emerald-100'
            }`}
            title={isListening ? t('micListening') : t('micClickToSpeak')}
          >
            {isListening ? <MicOff className="w-5 h-5" /> : <Mic className="w-5 h-5" />}
            <span className="text-xs font-bold hidden sm:inline">{isListening ? 'Listening...' : 'Voice Mic'}</span>
          </button>

          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => e.key === 'Enter' && handleSend()}
            placeholder={isListening ? t('micListening') : t('askPlaceholder')}
            className="flex-1 bg-slate-100 dark:bg-slate-800 text-slate-900 dark:text-white px-4 py-3 rounded-2xl text-xs border border-slate-200 dark:border-slate-700 focus:outline-none focus:ring-2 focus:ring-emerald-500 font-medium"
          />

          <button
            onClick={() => handleSend()}
            disabled={!input.trim()}
            className="px-5 py-3 rounded-2xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs shadow-md shadow-emerald-500/20 disabled:opacity-50 transition flex items-center space-x-2"
          >
            <span>{t('send')}</span>
            <Send className="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>
  );
};
