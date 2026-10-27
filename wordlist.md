# Word list

The standard terms used in these guides. Check every draft against this list:
use the term in the first column, and use it only in the sense given under
**Meaning**. When a draft describes something on the list in other words, or
uses a listed term in a way that contradicts its meaning, change it to match.

Add a term when the guides start using it, and give it a provenance.

## Provenance

| Value | Meaning |
|---|---|
| official | Appears in the MeshCore app's interface, its store listing, or its release notes. |
| convention | Not official, but widely used for this across the MeshCore community. |
| local | Our own term, adopted for these guides. |
| proposed | Suggested for these guides but not yet agreed. |
| unknown | Origin not established. |

## Terms

| Term | Meaning | Provenance | Notes |
|---|---|---|---|
| MeshCore app | The MeshCore companion app for iOS and Android, by Liam Cottle. | official | Use "the MeshCore app" on first mention in a chapter, then "the app". |
| radio | The LoRa device, running MeshCore companion firmware, that the app connects to. | official | The store listing says "LoRa radio". Avoid "device" alone, which can also mean the phone. |
| phone | The iOS or Android device running the app. | proposed | Use for tablets too. |
| node | Any radio on the mesh: yours, another person's, a repeater, a room server, or a sensor. | convention | |
| mesh | The network formed by all the nodes in range of each other. | convention | Lowercase. |
| header | The row across the top of the Contacts, Channels, and Map screens. Shows the radio's name and battery level and holds the advert icon, Settings icon, and row menu. | local | Not present on every screen in the app. |
| search bar | The search field on the main screens. | local | Which screens show it and what it searches are not yet confirmed. |
| content area | The middle of the main screen, showing whichever screen is chosen in the tab bar. | local | |
| tab bar | The row at the bottom of the main screen that switches between the Contacts, Channels, and Map screens. | local | Each button on it is a tab. Avoid "bottom menu", "navigation bar". |
| contact's details screen | The screen that opens when you tap a contact's row on the Contacts screen. | local | No header on this screen. |
| Contacts screen | The screen listing saved contacts. | local | The tab is labeled **Contacts** (official). The app's release notes say "Contacts tab"; this guide calls the view a screen and the button a tab. |
| Channels screen | The screen listing joined channels. | local | Tab labeled **Channels** (official). Same screen/tab distinction as Contacts screen. |
| Map screen | The screen showing the locations of contacts that share one. | local | Tab labeled **Map** (official). Different from **Internet Map** in the header's row menu. |
| screen | Any full-page view in the app. | local | |
| advert icon | The signal-shaped icon in the header that sends an advert. | convention | The app's release notes call it "the signal icon". |
| Settings icon | The gear icon in the header that opens **Settings**. | convention | **Settings** itself is official. |
| row menu | The three-dot (⋮) button at the right end of a row, and the menu it opens. The header has one, and so does each row on the Contacts and Channels screens. | local | Write "the row menu (⋮)". Say whose row when it isn't clear: "the header's row menu", "a contact's row menu". Avoid "⋮ menu", "three-dot menu", "overflow menu", "kebab menu", "more menu". |
| quick actions menu | The menu a contact's or channel's row menu opens, with common actions for that item. | local | Don't use it for the header's row menu, which holds items you can't reach anywhere else. |
| status line | The radio's name and battery level shown in the header. | proposed | Not currently used in the guides. |
| advert | A packet that announces a node to the mesh. Noun and verb. | official | From the menu labels **Advert Zero Hop**, **Advert Flood Routed**. Avoid "advertisement", "beacon", "ping". |
| zero-hop advert | An advert heard only by nodes in direct radio range. | official | Derived from **Advert Zero Hop**. |
| flood advert | An advert that repeaters pass across the mesh. | official | Derived from **Advert Flood Routed**. |
| contact | A node saved on the Contacts screen. | official | |
| discovered node | A node the radio has heard an advert from but that isn't saved as a contact. | proposed | The app's menu item is **Discover Contacts**. |
| contact type | Which kind of node a contact is: companion, repeater, room server, or sensor. | official | Lowercase in running text. |
| companion | A person's radio running companion firmware, used with the app. | official | From "Companion firmware". Avoid "client", "chat node". |
| repeater | A fixed node that relays packets to extend the mesh. | official | |
| room server | A node that stores messages for a group so people who were offline can catch up. | official | Two words, lowercase. |
| sensor | A node that reports readings such as temperature or battery voltage. | unknown | Used by community guides; not found in official sources yet. |
| channel | A shared conversation that everyone with the channel's key can read. | official | |
| public channel | The channel every radio has by default. | unknown | |
| hashtag channel | A channel joined by name, such as `#nodakmesh`. | official | Release notes: "hashtag channel joining". |
| private channel | A channel joined with a shared secret key. | convention | Shown with a lock icon. |
| direct message | A message sent to one contact. | official | Avoid "DM", "private message". |
| conversation | The view of messages with one contact or in one channel. | proposed | Avoid "chat window", "thread". |
| composer | The message box and **Send** button at the bottom of a conversation. | official | Release notes: "message composer". |
| hop | One relay of a packet by a repeater. | official | |
| path | The route a message takes through repeaters. | official | The app has a "path viewer". |
| tap | Touch an item briefly. | local | Avoid "click", "press". |
| touch and hold | Touch an item and keep your finger still until a menu or selection appears. | convention | Apple and Android user documentation both use this term. Avoid "long-press", "press and hold", "tap and hold", "long-tap". |
| swipe | Slide a finger across the screen. | local | |
| drag | Touch the screen and move your finger without lifting it, for example to move around a map. | convention | Apple and Android both use this term. Avoid "pan", "slide". |
| pinch | Touch the screen with two fingers and move them together to zoom out, or apart to zoom in. | convention | Apple and Android both use this term. Avoid "pinch-zoom", "spread". |
| enable / disable | Switch a setting on or off. | local | Avoid "turn on / turn off", "toggle". |
| text field | A box where you enter text, such as the search bar or a message box. Tapping it brings up the keyboard. | convention | Apple and Material Design (Android) both use this term. Avoid "input box", "text box", "input field". |
