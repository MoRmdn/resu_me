# Views Tracking Feature

## Overview
This feature adds a total views counter to the portfolio website that tracks and displays the number of times the page has been visited.

## Implementation Details

### Database Structure
The views data is stored in Firebase Realtime Database under the `views` path:
```json
{
  "views": {
    "total": 1234,
    "lastUpdated": 1703123456789
  }
}
```

### Database Rules
Updated `database.rules.json` to allow read/write access to the views data:
```json
"views": {
  ".read": true,
  ".write": true,
  "total": {
    ".validate": "newData.isNumber() && newData.val() >= 0"
  },
  "lastUpdated": {
    ".validate": "newData.isNumber()"
  }
}
```

### Service Methods
Added to `RealtimeDatabaseService`:
- `incrementViews()` - Safely increments the view counter using Firebase transactions
- `getTotalViews()` - Retrieves the current total views count
- `getViewsStream()` - Provides real-time updates of views count

### UI Integration
- **Location**: Views counter appears in the hero section below the location information
- **Design**: Styled as a pill-shaped container with an eye icon and formatted count
- **Formatting**: Large numbers are formatted (e.g., 1.2K, 1.5M)
- **Styling**: Uses app's color scheme with subtle background and border
- **Real-time Updates**: Automatically updates when database changes
- **Debug Mode**: Includes refresh button for testing (debug builds only)

### Tracking Logic
- Views are incremented when the `HomePage` widget initializes
- Uses Firebase transactions to prevent race conditions
- Real-time listener automatically updates the UI when database changes
- Fallback mechanism ensures views are loaded even if real-time stream fails
- Error handling ensures the app continues to work even if tracking fails

## Features
- ✅ Real-time view counting
- ✅ Safe concurrent access using Firebase transactions
- ✅ Formatted display (K/M suffixes for large numbers)
- ✅ Responsive design
- ✅ Error handling
- ✅ Consistent with app's design system

## Usage
The views counter automatically appears on the homepage and updates in real-time. No additional configuration is required.
