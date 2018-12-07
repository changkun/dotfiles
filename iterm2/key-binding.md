# Key bindings

To jump between words and start/end of lines in iTerm2 follow these steps:

- iTerm2 -> Preferences (⌘ + ,)
- Open the “Keys” tab
- Add the following Global Shortcut Keys

## Move cursor one word left

- Keyboard Combination: ⌥ + ←
- Action: Send Hex Code
- Code: 0x1b 0x62

## Move cursor one word right

- Keyboard Combination: ⌥ + →
- Action: Send Hex Code
- Code: 0x1b 0x66

## Move cursor to beginning of line

- Keyboard Combination: ⌘ + ←
- Action: Send Hex Code
- Code: 0x01

## Move cursor to end of line

- Keyboard Combination: ⌘ + →
- Action: Send Hex Code
- Code: 0x05

## Delete word

- Keyboard Combination: ⌥ + ←Delete
- Action: Send Hex Code
- Code: 0x1b 0x08

## Delete line

- Keyboard Combination: ⌘ + ←Delete
- Action: Send Hex Code
- Code: 0x15

## Undo

- Keyboard Combination: ⌘ + z
- Action: Send Hex Code
- Code: 0x1f

## Don't forget to remove the previous bindings:

- Open the “Profiles” tab
- Click the sub-tab ”Keys”
- Remove the mappings for key combinations ⌥ + ← and ⌥ + →