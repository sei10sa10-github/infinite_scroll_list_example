# infinite_scroll_list_example

Code to try how to do infinite scroll using ScrollController and VisibilityDetector

## Link 

- [ScrollController](https://api.flutter.dev/flutter/widgets/ScrollController-class.html)
- [VisibilityDetector](https://pub.dev/packages/visibility_detector)

## Note

If I tried to use ScrollController to judge whether I should load the second page, it doesn't work well for the case that I want to initiate pre-fetch in the middle of list of items.
If I trigger the request to load the next contents at the bottom of the page, it works OK.
On the other hand, the solution using VisibilityDetector works well even for the case of the pre-fetching in the middle.
