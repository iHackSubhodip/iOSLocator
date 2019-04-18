# iOSLocator

### This iOS app can track the location of a user and posts it to a backend server. The app should contain an activity with 2 buttons:

### 1. Start Tracking
### 2. Stop Tracking


### When "Start Tracking" is clicked, the app begins to track location coordinates of the user.

### If the distance from the last posted location exceeds the distance threshold (e.g. 100m) or if the time since the last posted location's timestamp exceeds the time threshold (e.g. 2 mins), then the location should be posted. 

### The app should run in the background, even when the devices screen is turned off. It should consider real world conditions like lossy network connection, etc. i.e. location history should not be lost.

### "Stop Tracking" should stop tracking the user's location.
