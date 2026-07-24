# Implementation Plan - Project Cleanup & Feature Enhancements

This plan addresses both the Git repository size issue and the comprehensive feature updates requested for the student dashboard, placement module, and AI mentor.

## User Review Required

> [!IMPORTANT]
> - **Data Persistence**: I will implement local persistence using `SharedPreferences` for the user-provided data (CGPA, attendance, skills, etc.).
> - **Mock Interview**: This will be implemented as an interactive chat-based experience within the app.
> - **Git History**: The cleanup uses `git rm --cached`. If the repo size is still too large for GitHub (due to history), we may need to use `git filter-repo`.

## Proposed Changes

### Phase 1: Git Repository Cleanup
**Goal**: Reduce repository size to allow pushing to GitHub.

#### [MODIFY] [.gitignore](file:///D:/Asset-Manager/Asset-Manager/.gitignore)
- Add comprehensive Flutter, Android, iOS, and IDE exclusions.

#### [ACTION] Untrack problematic folders
- Run `git rm -r --cached` on `build/`, `.dart_tool/`, `.idea/`, `.gradle/`, `android/.gradle/`, `ios/Pods/`.

---

### Phase 2: Data Architecture & Persistence
**Goal**: Transition from static sample data to user-editable state.

#### [MODIFY] [providers.dart](file:///D:/Asset-Manager/Asset-Manager/lib/providers/providers.dart)
- Update `studentProvider`, `subjectsProvider`, and `timetableProvider` to load/save data from `SharedPreferences`.
- Add a `skillsProvider` to manage user skills.

---

### Phase 3: Dashboard & Analytics Updates
**Goal**: Make the dashboard user-driven and remove hardcoded AI insights.

#### [MODIFY] [dashboard_screen.dart](file:///D:/Asset-Manager/Asset-Manager/lib/screens/dashboard/dashboard_screen.dart)
- **Remove**: `_buildAICard` (AI Insight).
- **Enhance**: Add tap handlers to `_StatCard` for CGPA, Attendance, Placement, and Streak.
- **New Widget**: `CGPACalculatorDialog` to calculate and save CGPA based on credits and marks.

#### [MODIFY] [analytics_screen.dart](file:///D:/Asset-Manager/Asset-Manager/lib/screens/analytics/analytics_screen.dart)
- Update tabs to use real user data from `subjectsProvider`.
- Add an "Edit Marks" functionality for each subject.

---

### Phase 4: Placement & Mock Interview
**Goal**: Implement interactive mock interview and editable skills.

#### [MODIFY] [placement_screen.dart](file:///D:/Asset-Manager/Asset-Manager/lib/screens/analytics/placement_screen.dart)
- Use `skillsProvider` for the technical skills section.
- Implement an interactive **Mock Interview** flow:
    - AI asks technical/HR questions.
    - User selects/types answers.
    - AI provides immediate feedback and corrections.

---

### Phase 5: Timetable & Profile
**Goal**: Ensure all data is user-provided.

#### [MODIFY] [timetable_screen.dart](file:///D:/Asset-Manager/Asset-Manager/lib/screens/timetable/timetable_screen.dart)
- Clear default `SampleData.timetable`.
- Improve the "Add Class" flow to ensure it's the primary way to populate the timetable.

#### [MODIFY] [profile_screen.dart](file:///D:/Asset-Manager/Asset-Manager/lib/screens/profile/profile_screen.dart)
- Add "Edit Skills" button and functionality.

---

### Phase 6: AI Mentor Enhancements
**Goal**: Improve conversational capabilities.

#### [MODIFY] [ai_engine.dart](file:///D:/Asset-Manager/Asset-Manager/lib/services/ai_engine.dart)
- Refine response logic to be more conversational and context-aware.

## Verification Plan

### Automated Tests
- Verify repository size using `git count-objects -vH`.
- Verify that build folders are ignored using `git check-ignore`.

### Manual Verification
- Test CGPA calculation logic.
- Verify that changes to attendance/marks reflect in the Analytics dashboard.
- Walk through a Mock Interview session.
- Verify that data persists after app restart.
