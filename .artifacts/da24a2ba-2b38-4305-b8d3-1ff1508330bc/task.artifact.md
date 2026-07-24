# Tasks - Project Cleanup & Feature Enhancements

## Phase 1: Git Repository Cleanup
- [x] Update root `.gitignore` with Flutter/Android/iOS exclusions
- [x] Remove problematic folders from Git tracking (`git rm --cached`)
- [x] Create a new Git commit for the cleanup
- [x] Verify repository size

## Phase 2: Data Architecture & Persistence
- [x] Implement `SharedPreferences` service for data persistence
- [x] Update `studentProvider` to persist user data
- [x] Update `subjectsProvider` for manual marks entry
- [x] Create `skillsProvider` for user skills

## Phase 3: Dashboard & Analytics Updates
- [x] Remove AI Insight card from `DashboardScreen`
- [x] Implement `CGPACalculatorDialog`
- [x] Link `_StatCard` items to input dialogs
- [x] Update `AnalyticsScreen` to use user-provided marks

## Phase 4: Placement & Mock Interview
- [x] Implement interactive Mock Interview flow in `PlacementScreen`
- [x] Add skill management UI to `ProfileScreen` or `PlacementScreen`

## Phase 5: Timetable & Profile
- [x] Clear default timetable data
- [x] Update `ProfileScreen` to allow editing skills

## Phase 6: AI Mentor Enhancements
- [x] Refine `AIResponseEngine` for better conversational experience
