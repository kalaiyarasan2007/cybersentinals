// AI Response Engine — Subject-aware smart chatbot responses

class AIResponseEngine {
  static String generate(String input) {
    final lower = input.toLowerCase();

    // ── Greetings ─────────────────────────────────────────────────────────────
    if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
      return 'Hello! I am your AI Academic Mentor. How can I help you with your studies or career today?';
    }

    if (lower.contains('who are you') || lower.contains('what can you do')) {
      return 'I am an AI designed to help you manage your academic life. I can explain complex topics (Java, Python, DSA, DBMS), help with study planning, analyze your CGPA, and even conduct mock interviews!';
    }

    // ── Java ──────────────────────────────────────────────────────────────────
    if (lower.contains('java')) {
      if (lower.contains('oops') || lower.contains('oop') || lower.contains('object')) {
        return '☕ Java OOP — 4 Pillars:\n\n1. Encapsulation: Wrapping data + methods\n   private int age; → public getAge()\n\n2. Inheritance: Child extends Parent\n   class Dog extends Animal {}\n\n3. Polymorphism: One method, many forms\n   Method overloading (same name, diff params)\n   Method overriding (child redefines parent)\n\n4. Abstraction: Hide detail, show interface\n   abstract class / interface\n\n💡 Key: interface supports multiple inheritance, abstract class does not!';
      }
      if (lower.contains('collection') || lower.contains('arraylist') || lower.contains('hashmap') || lower.contains('list')) {
        return '☕ Java Collections:\n\nList (ordered, duplicates allowed):\n• ArrayList — O(1) access, O(n) insert\n• LinkedList — O(1) insert/delete\n\nMap (key→value):\n• HashMap — O(1) avg, unordered\n• TreeMap — O(log n), sorted by key\n• LinkedHashMap — preserves insertion order\n\nSet (no duplicates):\n• HashSet — O(1), unordered\n• TreeSet — O(log n), sorted\n\nExample:\nMap<String,Integer> map = new HashMap<>();\nmap.put("Java", 90);\nint val = map.get("Java"); // 90\n\n💡 Know time complexities — interviews love this!';
      }
      if (lower.contains('thread') || lower.contains('concurrent') || lower.contains('multithread')) {
        return '☕ Java Multithreading:\n\nTwo ways to create threads:\n\n// Way 1 — Extend Thread\nclass MyThread extends Thread {\n  public void run() { /* code */ }\n}\nnew MyThread().start();\n\n// Way 2 — Implement Runnable (preferred)\nclass Task implements Runnable {\n  public void run() { /* code */ }\n}\nnew Thread(new Task()).start();\n\nKey concepts:\n• synchronized — prevents race conditions\n• wait()/notify() — thread communication\n• volatile — ensures visibility across threads\n• ExecutorService — manages thread pools\n\n💡 Prefer Runnable — allows extending other classes!';
      }
      if (lower.contains('exception') || lower.contains('try') || lower.contains('catch')) {
        return '☕ Java Exception Handling:\n\ntry {\n  int x = 10 / 0; // throws ArithmeticException\n} catch (ArithmeticException e) {\n  System.out.println("Error: " + e.getMessage());\n} finally {\n  // always executes — for cleanup\n}\n\nChecked vs Unchecked:\n• Checked: must handle (IOException, SQLException)\n• Unchecked: runtime (NullPointer, ArrayIndexOutOfBounds)\n\nCustom Exception:\nclass MyEx extends RuntimeException {\n  MyEx(String msg) { super(msg); }\n}\nthrow new MyEx("Custom error!");\n\n💡 finally always runs even with return in try!';
      }
      return '☕ Java — Topics I can explain:\n\n• OOP (4 pillars — encapsulation, inheritance...)\n• Collections (ArrayList, HashMap, TreeMap...)\n• Multithreading (Runnable, synchronized...)\n• Exception Handling (try/catch/finally)\n• Streams & Lambda expressions\n• Interfaces vs Abstract classes\n• String manipulation\n• Generics\n\nAsk specifically — like:\n"Explain Java OOP" or "Java HashMap vs TreeMap"';
    }

    // ── Python ────────────────────────────────────────────────────────────────
    if (lower.contains('python')) {
      if (lower.contains('list') || lower.contains('dict') || lower.contains('tuple') || lower.contains('set')) {
        return '🐍 Python Data Structures:\n\n# List — mutable, ordered\nfruits = ["apple", "mango"]\nfruits.append("cherry")\nfruits.sort()\n\n# Dictionary — key-value\nstudent = {"name": "Kala", "cgpa": 8.4}\nstudent["age"] = 21  # add\n\n# Tuple — immutable\npoint = (10, 20)  # cannot change!\n\n# Set — unique elements\nunique = {1, 2, 3, 2}  # → {1, 2, 3}\n\nList Comprehension (very powerful!):\nsquares = [x**2 for x in range(10)]\nevens = [x for x in range(20) if x%2==0]\n\n💡 List comprehension is faster than for-loop!';
      }
      if (lower.contains('function') || lower.contains('lambda') || lower.contains('decorator')) {
        return '🐍 Python Functions:\n\n# Regular function\ndef greet(name, greeting="Hello"):\n    return f"{greeting}, {name}!"\n\n# Lambda (anonymous)\nsquare = lambda x: x ** 2\nprint(square(5))  # 25\n\n# Map and Filter\nnums = [1, 2, 3, 4, 5]\nsquared = list(map(lambda x: x**2, nums))\nevens = list(filter(lambda x: x%2==0, nums))\n\n# Decorator\ndef logger(func):\n    def wrapper(*args, **kwargs):\n        print(f"Calling {func.__name__}")\n        return func(*args, **kwargs)\n    return wrapper\n\n@logger\ndef add(a, b): return a + b\n\n💡 *args = variable positional args, **kwargs = keyword args';
      }
      return '🐍 Python — Topics I can explain:\n\n• Data Types (list, dict, tuple, set)\n• Functions (lambda, decorators, generators)\n• OOP (class, inheritance, magic methods)\n• File Handling (read, write, CSV)\n• List/Dict Comprehensions\n• Exception Handling\n• Modules (numpy, pandas, matplotlib)\n• ML with sklearn\n\nAsk like: "Python list comprehension" or "Python OOP"';
    }

    // ── DSA ───────────────────────────────────────────────────────────────────
    if (lower.contains('dsa') || lower.contains('data struct') || lower.contains('algorithm')) {
      if (lower.contains('tree') || lower.contains('bst')) {
        return '🌳 Binary Search Tree (BST):\n\n        8\n       / \\\n      3   10\n     / \\    \\\n    1   6   14\n\nProperty: Left < Root < Right\n\nOperations:\n• Search: O(log n) avg, O(n) worst\n• Insert: O(log n) avg\n• Delete: O(log n) avg\n\nTraversals:\n• Inorder (L-Root-R) → sorted: 1,3,6,8,10,14\n• Preorder (Root-L-R) → 8,3,1,6,10,14\n• Postorder (L-R-Root) → 1,6,3,14,10,8\n• Level-order (BFS) → 8,3,10,1,6,14\n\n💡 Inorder of BST = sorted array! Remember this for exams!';
      }
      if (lower.contains('sort')) {
        return '📊 Sorting Algorithms:\n\nAlgorithm | Best      | Avg       | Worst     | Space\n---------|-----------|-----------|-----------|------\nBubble   | O(n)      | O(n²)     | O(n²)     | O(1)\nSelection| O(n²)     | O(n²)     | O(n²)     | O(1)\nInsertion| O(n)      | O(n²)     | O(n²)     | O(1)\nMerge    | O(n log n)| O(n log n)| O(n log n)| O(n)\nQuick    | O(n log n)| O(n log n)| O(n²)     | O(log n)\nHeap     | O(n log n)| O(n log n)| O(n log n)| O(1)\n\nBest for interviews:\n• QuickSort — fastest in practice\n• MergeSort — stable, guaranteed O(n log n)\n• HeapSort — in-place O(n log n)\n\n💡 Stable sort preserves order of equal elements (Merge, Bubble, Insertion)';
      }
      if (lower.contains('graph') || lower.contains('bfs') || lower.contains('dfs')) {
        return '🕸️ Graph Algorithms:\n\nBFS (Breadth-First Search):\n• Use: Shortest path (unweighted)\n• Data structure: Queue\n• Time: O(V + E)\n\nDFS (Depth-First Search):\n• Use: Cycle detection, topological sort\n• Data structure: Stack (or recursion)\n• Time: O(V + E)\n\nDijkstra\'s:\n• Shortest path (weighted, no negative)\n• Use: Min-heap/priority queue\n• Time: O((V + E) log V)\n\nBellman-Ford:\n• Shortest path (handles negative weights)\n• Time: O(V × E)\n\nFloyd-Warshall:\n• All-pairs shortest path\n• Time: O(V³)\n\n💡 For interviews: know BFS for level-order, DFS for tree problems!';
      }
      return '🧠 DSA — Topics I can explain:\n\n• Arrays & Strings (two pointers, sliding window)\n• Linked List (reverse, detect cycle, merge)\n• Stack & Queue (monotonic stack, BFS)\n• Trees (BST, AVL, Heap, Trie)\n• Sorting (Quick, Merge, Heap)\n• Searching (Binary search, BFS, DFS)\n• Dynamic Programming (memoization, tabulation)\n• Graphs (BFS, DFS, Dijkstra)\n\nAsk like: "Explain BST" or "Sorting algorithms"';
    }

    // ── DBMS ──────────────────────────────────────────────────────────────────
    if (lower.contains('dbms') || lower.contains('database') || (lower.contains('sql') && !lower.contains('nosql'))) {
      if (lower.contains('join')) {
        return '🗄️ SQL Joins:\n\n-- INNER JOIN: Only matching rows from both\nSELECT s.name, c.course\nFROM students s\nINNER JOIN courses c ON s.id = c.sid;\n\n-- LEFT JOIN: All from left + matched right\nSELECT s.name, c.course\nFROM students s\nLEFT JOIN courses c ON s.id = c.sid;\n\n-- RIGHT JOIN: All from right + matched left\n\n-- FULL OUTER JOIN: All rows from both tables\n\nVisually:\nINNER = intersection only\nLEFT = left circle + intersection\nRIGHT = right circle + intersection  \nFULL = entire both circles\n\n💡 Most asked in placement interviews — know all 4!';
      }
      if (lower.contains('normal') || lower.contains('1nf') || lower.contains('2nf') || lower.contains('3nf')) {
        return '🗄️ Normalization:\n\n1NF — No repeating groups, atomic values\n• Bad: Student(ID, Subjects) where Subjects = "Java,Python"\n• Good: separate row for each subject\n\n2NF — 1NF + No partial dependency\n• Every non-key attribute depends on WHOLE primary key\n• Problem occurs when composite key has partial dependency\n\n3NF — 2NF + No transitive dependency\n• Non-key → non-key dependency removed\n• Example: Dept → Manager is transitive if Student → Dept → Manager\n\nBCNF — Stricter 3NF\n• Every determinant must be a candidate key\n\nExample decomposition:\nBefore: Student(ID, Name, DeptID, DeptName)\nAfter 3NF:\n  Student(ID, Name, DeptID)\n  Department(DeptID, DeptName)\n\n💡 Common exam question: identify and decompose to 3NF!';
      }
      if (lower.contains('acid') || lower.contains('transaction')) {
        return '🗄️ ACID Properties:\n\nA — Atomicity\n• Transaction is all-or-nothing\n• If any part fails, entire transaction rolls back\n\nC — Consistency\n• Database stays valid before and after transaction\n• All constraints, rules must be satisfied\n\nI — Isolation\n• Concurrent transactions don\'t interfere\n• Levels: Read Uncommitted → Read Committed → Repeatable Read → Serializable\n\nD — Durability\n• Committed transactions survive system failure\n• Achieved via write-ahead logging (WAL)\n\nExample: Bank Transfer\n  Debit A (-500) + Credit B (+500)\n  Must be atomic — can\'t debit without crediting!\n\n💡 ACID = guarantee of reliable transactions in RDBMS';
      }
      return '🗄️ DBMS — Topics I can explain:\n\n• ER Diagrams (entities, relationships, cardinality)\n• SQL Queries (SELECT, JOIN, GROUP BY, HAVING, subqueries)\n• Normalization (1NF, 2NF, 3NF, BCNF)\n• ACID Properties (transactions)\n• Indexing (B+ Tree, Hash Index)\n• Concurrency Control (locks, deadlock)\n• File Organization (sequential, indexed)\n\nAsk like: "SQL joins" or "DBMS normalization"';
    }

    // ── OS ────────────────────────────────────────────────────────────────────
    if (lower.contains('operating system') || lower.contains('deadlock') || lower.contains('paging') || lower.contains('semaphore') || (lower.trim() == 'os')) {
      if (lower.contains('scheduling') || lower.contains('fcfs') || lower.contains('sjf') || lower.contains('round robin')) {
        return '⚙️ CPU Scheduling Algorithms:\n\nFCFS (First Come First Served):\n• Simple, non-preemptive\n• Problem: convoy effect (long jobs block short ones)\n\nSJF (Shortest Job First):\n• Optimal for minimum avg waiting time\n• Non-preemptive version\n\nSRTF (Shortest Remaining Time First):\n• Preemptive version of SJF\n• Best avg waiting time\n\nRound Robin:\n• Each process gets time quantum (Q)\n• Best for time-sharing systems\n• Larger Q → FCFS, Smaller Q → more context switches\n\nPriority Scheduling:\n• Higher priority runs first\n• Problem: starvation (low priority may never run)\n• Solution: Aging (gradually increase priority)\n\n💡 For any scheduling problem: draw Gantt chart and calculate:\nWaiting Time = Start - Arrival\nTurnaround Time = Completion - Arrival';
      }
      if (lower.contains('deadlock')) {
        return '⚙️ OS Deadlock:\n\n4 Necessary Conditions (ALL must hold):\n1. Mutual Exclusion — resource held exclusively\n2. Hold & Wait — holds one, waits for another\n3. No Preemption — can\'t forcibly take resource\n4. Circular Wait — P1→R1→P2→R2→P1\n\nPrevention: Break any one condition\n\nAvoidance — Banker\'s Algorithm:\n• Maintain "safe state"\n• Before granting, simulate to check if safe state remains\n• Safe state = all processes can eventually complete\n\nDetection:\n• Draw Resource Allocation Graph (RAG)\n• Single instance: cycle → deadlock\n• Multiple instances: use detection algorithm\n\nRecovery:\n• Terminate one process\n• Preempt resources from a process\n\n💡 Banker\'s Algorithm steps are frequently exam questions!';
      }
      return '⚙️ OS — Topics I can explain:\n\n• Process Management (states: new→ready→running→waiting→terminated)\n• CPU Scheduling (FCFS, SJF, Round Robin, Priority)\n• Synchronization (Mutex, Semaphore, Monitors)\n• Deadlock (detection, prevention, Banker\'s algo)\n• Memory Management (paging, segmentation, virtual memory)\n• Page Replacement (FIFO, LRU, Optimal)\n• File Systems (FAT, NTFS, inodes)\n• Disk Scheduling (SSTF, SCAN, C-SCAN)\n\nAsk like: "OS scheduling" or "Deadlock in OS"';
    }

    // ── Networks ──────────────────────────────────────────────────────────────
    if (lower.contains('network') || lower.contains('tcp') || lower.contains('udp') || lower.contains('osi') || lower.contains('subnet')) {
      if (lower.contains('osi') || lower.contains('layer')) {
        return '🌐 OSI 7-Layer Model:\n\nLayer 7 — Application:  HTTP, FTP, DNS, SMTP\nLayer 6 — Presentation: SSL/TLS, JPEG, encryption\nLayer 5 — Session:       RPC, session management\nLayer 4 — Transport:     TCP, UDP (segments)\nLayer 3 — Network:       IP, ICMP, routing (packets)\nLayer 2 — Data Link:     Ethernet, MAC (frames)\nLayer 1 — Physical:      Cables, WiFi, bits\n\nMemory trick: "All People Seem To Need Data Processing"\n\nTCP/IP Model (4 layers):\n4. Application (= OSI 5+6+7)\n3. Transport (= OSI 4)\n2. Internet (= OSI 3)\n1. Network Access (= OSI 1+2)\n\n💡 Know which protocol belongs to which layer — very common question!';
      }
      if (lower.contains('tcp') || lower.contains('udp')) {
        return '🌐 TCP vs UDP:\n\nFeature       | TCP              | UDP\n-------------|-----------------|------------------\nConnection   | Connection-based | Connectionless\nReliability  | Reliable (ACKs)  | Unreliable\nOrdering     | Ordered          | Not guaranteed\nSpeed        | Slower           | Faster\nError check  | Yes (checksum)   | Basic checksum\nUse cases    | HTTP, FTP, email | DNS, video, games\n\nTCP 3-Way Handshake:\nClient → SYN → Server\nClient ← SYN-ACK ← Server\nClient → ACK → Server\n(Connection established!)\n\nTCP 4-Way Close:\nFIN → ACK → FIN → ACK\n\n💡 TCP reliable because: sequence numbers + ACKs + retransmission!';
      }
      return '🌐 Networks — Topics I can explain:\n\n• OSI Model (7 layers + protocols)\n• TCP/IP Model (4 layers)\n• TCP vs UDP differences\n• IP Addressing (IPv4, IPv6, subnetting)\n• Routing Protocols (RIP, OSPF, BGP)\n• ARP (IP → MAC resolution)\n• DNS (domain name resolution)\n• HTTP/HTTPS, FTP, SMTP\n• Network Security (firewall, VPN)\n\nAsk like: "OSI layers" or "TCP vs UDP"';
    }

    // ── Machine Learning ──────────────────────────────────────────────────────
    if (lower.contains('machine learning') || lower.contains(' ml') || lower.contains('deep learning') || lower.contains('neural network')) {
      return '🤖 Machine Learning:\n\nSupervised Learning:\n• Linear Regression — predict numbers (house price)\n• Logistic Regression — binary classification\n• Decision Tree — rule-based splits\n• Random Forest — ensemble of trees\n• SVM — find optimal hyperplane\n\nUnsupervised Learning:\n• K-Means Clustering — group similar data\n• PCA — reduce dimensions\n\nKey Concepts:\n• Overfitting → high train acc, low test acc\n  Fix: more data, dropout, regularization (L1/L2)\n• Underfitting → low acc everywhere\n  Fix: more complex model, more features\n• Train/Val/Test split: 70/15/15 or 80/10/10\n\nPython libraries:\nimport sklearn      # ML models\nimport pandas       # data manipulation  \nimport numpy        # arrays\nimport matplotlib   # plotting\n\n💡 Start with sklearn — clean API for all major algorithms!';
    }

    // ── Attendance ────────────────────────────────────────────────────────────
    if (lower.contains('attendance')) {
      return '📋 Attendance Summary:\n\nSubject              | Attendance | Status\n--------------------|------------|--------\nData Structures      | 88%        | ✅ Safe\nOperating Systems    | 92%        | ✅ Good\nDatabase Management  | 78%        | ⚠️ Low!\nComputer Networks    | 82%        | ✅ Safe\nSoftware Engineering | 95%        | ✅ Excellent\nMachine Learning     | 76%        | 🔴 Critical!\n\nOverall: 78.5% — slightly below 80%\n\nAction needed:\n• DBMS: attend next 3 classes to reach 80%\n• ML: attend next 5 classes — urgent!\n\n💡 Below 75% = not allowed to sit for exams. Don\'t let it fall!';
    }

    // ── CGPA/Marks ────────────────────────────────────────────────────────────
    if (lower.contains('cgpa') || lower.contains('gpa') || lower.contains('marks') || lower.contains('grade')) {
      return '📊 Academic Performance:\n\nCurrent CGPA: 8.4  |  Predicted Next Sem: 8.7\n\nSubject              | Marks  | Grade\n--------------------|--------|------\nData Structures      | 72/100 | A\nOperating Systems    | 85/100 | A+\nDatabase Management  | 61/100 | B (⚠️ weak!)\nComputer Networks    | 78/100 | A\nSoftware Engineering | 90/100 | O\nMachine Learning     | 68/100 | B+\n\nTo reach CGPA 9.0:\n• DBMS needs ≥ 80 in next exam\n• ML needs ≥ 75 in next exam\n• Other subjects: maintain current level\n\n💡 Focus 2 extra hours daily on DBMS and ML this week!';
    }

    // ── Placement ─────────────────────────────────────────────────────────────
    if (lower.contains('placement') || lower.contains('job') || lower.contains('interview') || lower.contains('company')) {
      return '🎯 Placement Readiness: 72%\n\nStrengths:\n✅ SE project (90 marks) — great for portfolio\n✅ 14-day coding streak\n✅ OS knowledge strong (85 marks)\n✅ Java skills (82% proficiency)\n\nImprove:\n📌 DSA — 3 LeetCode problems/day\n📌 System Design basics\n📌 SQL — practice on HackerRank\n\nTarget companies (based on your profile):\n🟢 Reach:   TCS, Infosys, Wipro\n🟡 Target:  Capgemini, HCL, Cognizant\n🔵 Stretch: Accenture, IBM\n\nInterview prep roadmap:\n1. DSA (2 months) — LeetCode Easy then Medium\n2. SQL (2 weeks) — joins, group by, subqueries\n3. OS + Networks (1 week) — concepts\n4. Java/Python coding (ongoing)\n5. Mock interviews (last 2 weeks)\n\n💡 CGPA 8.4 gives you good eligibility for most companies!';
    }

    // ── Study Plan ────────────────────────────────────────────────────────────
    if (lower.contains('study') || lower.contains('plan') || lower.contains('schedule')) {
      return '📚 Optimized Daily Study Plan:\n\n6:00 - 7:30 AM  — Morning revision\n                   Quick recap of yesterday\n\n9:00 AM - 12 PM — College classes\n                   Focus, take notes!\n\n1:00 - 2:00 PM  — Lunch + break\n\n2:00 - 4:00 PM  — Weak subjects\n                   DBMS today → ML tomorrow\n\n4:30 - 6:00 PM  — Coding practice\n                   2-3 LeetCode problems\n\n7:00 - 9:00 PM  — Assignments + revision\n\n10:00 PM        — Sleep (7-8 hours essential!)\n\nPomodoro technique:\n• 25 min focus → 5 min break (×4)\n• Then 30 min long break\n• Proven to boost retention by 40%!\n\n💡 Study DBMS and ML first each day — tackle hard things fresh!';
    }

    // ── Stress ────────────────────────────────────────────────────────────────
    if (lower.contains('stress') || lower.contains('anxious') || lower.contains('burnout') || lower.contains('tired') || lower.contains('pressure')) {
      return '💙 Academic stress is real. Here\'s what helps:\n\nImmediate (right now):\n• Take 5 deep breaths slowly\n• Drink a glass of water\n• Step outside for 10 minutes\n\nToday\'s approach:\n• Study just ONE subject today\n• Use Pomodoro (25+5 min cycles)\n• No phone during study sessions\n• Sleep by 10 PM tonight\n\nThis week:\n• Exercise 30 min daily — stress relief\n• Talk to a friend or family\n• Celebrate small wins (finished a chapter? great!)\n• Limit social media to 30 min/day\n\nRemember:\n• Your CGPA is 8.4 — you are doing well!\n• One bad day ≠ bad semester\n• Rest is productive too\n\n💙 Your mental health matters more than any grade. Take care of yourself first!';
    }

    // ── Assignment ────────────────────────────────────────────────────────────
    if (lower.contains('assignment') || lower.contains('due') || lower.contains('deadline') || lower.contains('pending')) {
      return '📝 Pending Assignments:\n\n🔴 Due Tomorrow:\n   OS Lab Report — Scheduling Algorithms\n\n🟡 Due in 3 days:\n   CN Assignment — TCP/IP Protocol Analysis\n\n🟠 Due in 5 days:\n   ML Assignment — Linear Regression\n\n🟢 Due in 6 days:\n   DBMS Mini Project — Library System\n\nSuggested order:\n1. OS Lab (urgent!)\n2. CN Assignment\n3. ML Assignment\n4. DBMS Project\n\nBreaking down OS Lab:\n• Theory section: 30 min\n• Algorithm diagrams: 20 min\n• Write-up/report: 40 min\n• Total: ~1.5 hours — very doable!\n\n💡 Start with the smallest task to build momentum!';
    }

    // ── Resume ────────────────────────────────────────────────────────────────
    if (lower.contains('resume') || lower.contains('cv') || lower.contains('portfolio')) {
      return '📄 Resume Guide for You:\n\nSections (in order):\n1. Header: Name, email, phone, LinkedIn, GitHub\n2. Education: B.E. CS, Anna University, CGPA 8.4\n3. Skills: Java (82%), Python (75%), SQL (65%), DSA\n4. Projects:\n   • DBMS Library System\n   • SE Documentation Project\n5. Achievements:\n   • 14-day coding streak\n   • OS Lab: 85/100 (top scorer)\n6. Certifications (add any online courses)\n\nKey rules:\n✅ 1 page only for freshers\n✅ Use action verbs: "Developed", "Implemented"\n✅ Quantify results: "Built app used by 200+ users"\n✅ Add GitHub with active repositories\n✅ Tailor to each job description\n\n❌ Avoid:\n• Generic objective: "Seeking a challenging position..."\n• Irrelevant hobbies\n• Spelling errors\n\n💡 A strong GitHub profile matters more than certificates!';
    }

    // ── Default ───────────────────────────────────────────────────────────────
    return '🤖 Hi! I\'m your AI Academic Mentor.\n\nI can help with:\n\n📚 Subject Questions:\n• Java (OOP, Collections, Threads)\n• Python (functions, data structures)\n• DSA (trees, sorting, graphs, DP)\n• DBMS (SQL joins, normalization, ACID)\n• OS (scheduling, deadlock, memory)\n• Networks (OSI model, TCP/UDP)\n• Machine Learning (algorithms, sklearn)\n\n🎯 Academic Support:\n• CGPA analysis and prediction\n• Attendance tracking\n• Assignment planning\n• Placement preparation\n• Resume building tips\n• Study plan creation\n• Stress management\n\nJust ask me anything! Examples:\n• "Explain Java OOP"\n• "SQL joins"\n• "OS scheduling algorithms"\n• "My attendance status"\n• "Placement tips"';
  }
}
