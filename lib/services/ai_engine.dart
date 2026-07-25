// AI Response Engine — Powered by Google Gemini AI
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:math';

// 🔑 REPLACE THIS WITH YOUR FREE GEMINI API KEY
// Get it for free at: https://aistudio.google.com/app/apikey
const String _geminiApiKey = 'AIzaSyCfOW7q1xALs1fmXlqJBcCpFpGnxhkbMg4';
const String _defaultFakeKey = 'AIzaSyCfOW7q1xALs1fmXlqJBcCpFpGnxhkbMg4';

class AIResponseEngine {
  static GenerativeModel? _model;
  static ChatSession? _chat;

  static final String _systemPrompt = '''
You are an AI Academic Mentor built into a student app called "StudentInsight AI".
You help engineering college students with academics, placement preparation, and general knowledge.
''';

  static void _initModel() {
    if (_model == null && _geminiApiKey != _defaultFakeKey) {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _geminiApiKey,
        systemInstruction: Content.system(_systemPrompt),
      );
      _chat = _model!.startChat();
    }
  }

  /// Call this for async Gemini responses.
  static Future<String> generateAsync(String input) async {
    try {
      // 1. If user hasn't added a real API key, use the smart local fallback bot!
      if (_geminiApiKey == _defaultFakeKey) {
        await Future.delayed(const Duration(milliseconds: 800)); // simulate network delay
        return _localFallbackBot(input);
      }

      // 2. Real Gemini AI call (if key is updated)
      _initModel();
      final response = await _chat!.sendMessage(Content.text(input));
      return response.text ?? 'Sorry, I could not generate a response. Please try again.';
    } on GenerativeAIException catch (e) {
      return '🔑 API Key Error!\n\nTo activate the real AI, please add your free Gemini API key in ai_engine.dart.';
    } catch (e) {
      return 'Something went wrong. Please check your internet connection and try again.';
    }
  }

  /// Fallback sync response (used during initialization)
  static String generate(String input) {
    return 'Loading AI... Please wait a moment and try again!';
  }

  // =========================================================================
  // 🧠 SMART LOCAL FALLBACK BOT (Used until real Gemini API key is added)
  // =========================================================================
  static String _localFallbackBot(String input) {
    final lower = input.toLowerCase();

    // ── General Greetings ──────────────────────────────────────────────────
    if (lower.contains('hi') || lower.contains('hello') || lower.contains('hey') || lower.contains('vanakkam')) {
      return 'Hello! 👋 I am your AI Mentor (Running in basic mode). I can help you with programming questions, study tips, placement prep, and more. Ask me anything!';
    }
    if (lower.contains('how are you')) {
      return 'I am doing great, thanks for asking! 🚀 How is your day going? Need help with any subjects?';
    }
    if (lower.contains('who are you') || lower.contains('what is your name')) {
      return 'I am StudentInsight AI 🤖, your personal academic assistant. Right now I am running in basic offline mode, but I can still answer a lot of coding and academic questions!';
    }

    // ── Generic Conversational ──────────────────────────────────────────────
    if (lower.contains('thank you') || lower.contains('thanks')) {
      return 'You are very welcome! Let me know if you need anything else. 😊';
    }
    if (lower.contains('bye') || lower.contains('goodnight')) {
      return 'Goodbye! Keep up the great work and see you soon! 👋';
    }
    if (lower.contains('what can you do') || lower.contains('help')) {
      return 'Here is what I can do for you:\n\n💻 Explain coding concepts (Java, Python, C++, DSA)\n🎯 Give placement interview tips\n📚 Help with exam preparation strategies\n🔥 Answer general knowledge questions\n\nTry asking: "Explain Binary Search" or "What is OOP?"';
    }
    if (lower.contains('joke') || lower.contains('funny')) {
      return 'Why do programmers prefer dark mode?\n\nBecause light attracts bugs! 🐛😆';
    }

    // ── Computer Science / Coding ──────────────────────────────────────────
    if (lower.contains('python')) {
      if (lower.contains('list') || lower.contains('tuple')) {
        return '🐍 **Python Lists vs Tuples:**\n\n**List** `[1, 2, 3]`:\n- Mutable (can be changed)\n- Slightly slower\n- Use when data changes.\n\n**Tuple** `(1, 2, 3)`:\n- Immutable (cannot be changed)\n- Faster memory execution\n- Use for fixed data (e.g. coordinates).';
      }
      return '🐍 **Python Basics:**\nPython is a high-level, interpreted language known for its simplicity and readability. \n\nExample of a simple loop:\n```python\nfor i in range(5):\n    print(f"Hello {i}")\n```\nGreat for ML, AI, Web (Django/FastAPI), and scripting!';
    }
    
    if (lower.contains('java')) {
      if (lower.contains('oop') || lower.contains('object')) {
        return '☕ **Java OOP Concepts (4 Pillars):**\n\n1️⃣ **Encapsulation:** Hiding data using `private` variables and `public` getters/setters.\n2️⃣ **Inheritance:** A child class extending a parent class using the `extends` keyword.\n3️⃣ **Polymorphism:** Method overloading (same name, diff params) and overriding (child replacing parent method).\n4️⃣ **Abstraction:** Hiding complex implementation using `abstract` classes or `interfaces`.';
      }
      return '☕ **Java Overview:**\nJava is a strongly-typed, object-oriented language. It runs on the JVM, making it "Write Once, Run Anywhere".\n\nBasic Hello World:\n```java\nclass Main {\n    public static void main(String[] args) {\n        System.out.println("Hello World!");\n    }\n}\n```';
    }

    if (lower.contains('dsa') || lower.contains('data structure') || lower.contains('algorithm')) {
      if (lower.contains('binary search')) {
        return '🔍 **Binary Search:**\nAn efficient `O(log n)` search algorithm that works on **sorted arrays**.\n\nIt repeatedly divides the search interval in half. If the target value is less than the middle element, it narrows the interval to the lower half. Otherwise, it narrows to the upper half.\n\n*Requires the array to be sorted first!*';
      }
      if (lower.contains('sort')) {
        return '📊 **Sorting Algorithms:**\n- **Bubble Sort:** `O(n²)` - Compares adjacent elements.\n- **Merge Sort:** `O(n log n)` - Divide and conquer, very stable.\n- **Quick Sort:** `O(n log n)` avg - Uses a pivot element, very fast in practice.\n\n*Tip:* In interviews, always mention time and space complexity!';
      }
      return '🧠 **DSA Tips:**\nData Structures and Algorithms are crucial for product-based company interviews (Amazon, Google, Zoho).\n\nFocus on:\n- Arrays & Strings (Two Pointers, Sliding Window)\n- Linked Lists\n- Trees & Graphs (BFS, DFS)\n- Dynamic Programming';
    }

    if (lower.contains('dbms') || lower.contains('sql') || lower.contains('database')) {
      return '🗄️ **DBMS / SQL Basics:**\n- **DDL (Data Definition):** CREATE, ALTER, DROP\n- **DML (Data Manipulation):** SELECT, INSERT, UPDATE, DELETE\n- **DCL (Data Control):** GRANT, REVOKE\n\n**ACID Properties:**\n- **A**tomicity (All or nothing)\n- **C**onsistency (Valid state)\n- **I**solation (Concurrent transactions are safe)\n- **D**urability (Saved permanently)';
    }

    if (lower.contains('html') || lower.contains('web') || lower.contains('css') || lower.contains('javascript')) {
      return '🌐 **Web Development:**\n- **HTML:** The structure/skeleton of the web.\n- **CSS:** The styling and design.\n- **JavaScript:** The logic and interactivity.\n\nModern frameworks include React, Vue, Angular, and Next.js. Building a small portfolio project is the best way to learn!';
    }

    // ── Placements & Career ────────────────────────────────────────────────
    if (lower.contains('placement') || lower.contains('interview') || lower.contains('resume')) {
      return '👔 **Placement Preparation Strategy:**\n\n1. **Aptitude:** Practice Quants and Logical Reasoning daily.\n2. **Coding (DSA):** Solve Leetcode Easy/Medium problems.\n3. **Core Subjects:** Brush up on OS, DBMS, OOP, and Computer Networks.\n4. **Resume:** Keep it 1-page. Highlight 2 good projects and your technical skills.\n\nNeed mock interview tips? Just ask!';
    }

    // ── Catch-all / Generic Fallback ───────────────────────────────────────
    final responses = [
      'That is an interesting question! While I am in basic mode, I recommend checking documentation or searching online for the deepest technical answer on that.',
      'I am currently running in offline basic mode, so my knowledge is slightly limited. But I am always learning! Can I help you with Java, Python, or Placement tips instead?',
      'Great question! In computer science, this often depends on your specific use case. Could you provide a bit more context?',
      'I see! If you are preparing for exams or placements, focusing on the fundamental concepts behind this will really help you.',
      'As your AI mentor, I would say: break this problem down into smaller steps. It makes complex concepts much easier to tackle!',
      'Hmm, I am operating in basic mode without a real Gemini API key right now, so I cannot generate a custom response for that. But ask me about DSA, Java, Python, or DBMS!'
    ];
    
    return responses[Random().nextInt(responses.length)];
  }
}
