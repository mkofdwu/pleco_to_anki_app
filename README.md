# pleco_to_anki

Import Pleco flashcards into AnkiDroid in the click of a button.

This is a more accessible improvement over the [python script](https://github.com/mkofdwu/pleco_to_anki) I wrote 3 years ago.

<img src="./example/app.jpg" width="300" />
<img src="./example/screenshot.jpg" width="300" />

## Usage

- You need to have Ankidroid installed and set up
- From Pleco, export the flashcards you want (menu > import/export > export cards).
  - Set the format to text file and character set to simplified, and check **only** 'card definitions' and 'dictionary definitions'.
- Export to somewhere in Downloads/Documents folder. Note down the file location.
- Download and install the latest release of pleco_to_anki
- Grant permissions to access Anki database when prompted
- Select which deck to add the pleco flashcards into
- Click the big button
- Choose the Pleco export file
- The flashcards should be added to Anki!
- When you later add more flashcards in Pleco, just repeat the same process. Words that are already in Anki will not be added again.

## Issues

Parsing of the pleco export file does not have a clear solution, and at times there will be (possibly unsolvable) issues. This may result in text not laid out properly.

## Building

- Set up [flutter](https://flutter.dev)
- `flutter build apk`