![Banner](Images/banner.png?)

# The original EeveeSpotify repository was disabled due to a [DMCA takedown](https://github.com/github/dmca/blob/master/2025/08/2025-08-14-spotify.md). This repository will not contain the IPA packages, as they are most likely the reason for the takedown.

# EeveeSpotify

This tweak makes Spotify think you have a Premium subscription, granting free listening, just like Spotilife, and provides some additional features like custom lyrics.

## How to build an EeveeSpotify IPA using Github actions
> [!NOTE]
> If this your first time, complete following steps before starting:
>
> 1. Fork this repository using the fork button on the top right
> 2. On your forked repository, go to **Repository Settings** > **Actions**, enable **Read and Write** permissions.

<details>
  <summary>How to build the EeveeSpotify IPA</summary>
  <ol>
    <li>Click on <strong>Sync fork</strong>, and if your branch is out-of-date, click on <strong>Update branch</strong>.</li>
    <li>Navigate to the <strong>Actions tab</strong> in your forked repository and select <strong>Create IPA Packages</strong> if you're on desktop/widescreen. Tap on <strong>All Workflows</strong> and select <strong>Create IPA Packages</strong> if you're on mobile/portrait.</li>
    <li>Click the <strong>Run workflow</strong> button located on the right side.</li>
    <li>Prepare a decrypted .ipa file <em>(we cannot provide this due to legal reasons)</em>, then upload it to a file provider (e.g., filebin.net, filemail.com, or Dropbox is recommended). Paste the URL of the decrypted IPA file in the provided field.</li>
    <li><strong>NOTE:</strong> Make sure to provide a direct download link to the file, not a link to a webpage. Otherwise, the process will fail.</li>
    <li>Go to the releases page of the EeveeSpotify repository (<strong>NOT</strong> the fork). Hold and copy the link of the .deb file, which corresponds to your phone's architecture.</li>
    <li>Make sure all inputs are correct, then click <strong>Run workflow</strong> to start the process.</li>
    <li>Wait for the build to finish. You can download the EeveeSpotify IPA from the releases section of your forked repo. (If you can't find the releases section, go to your forked repo and add /releases to the URL, i.e., github.com/user/EeveeSpotifyReborn/releases.)</li>
  </ol>
</details>

## The History

In January 2024, Spotilife, the only tweak to get Spotify Premium, stopped working on new Spotify versions. I decompiled Spotilife, reverse-engineered Spotify, intercepted requests, etc., and created this tweak.

## Restrictions

Please refrain from opening issues about the following features, as they are server-sided and will **NEVER** work:

- Very High audio quality
- Native playlist downloading (you can download podcast episodes though)
- Jam (hosting a Spotify Jam and joining it remotely requires Premium; only joining in-person works)
- AI DJ/Playlist
- Spotify Connect (When using Spotify Connect, the device will act as a remote control and stream directly to the connected device. This is a server-sided limitation and is beyond the control of EeveeSpotify, so it will behave as if you have a Free subscription while using this feature.)

It's possible to implement downloading locally, but it will never be included in EeveeSpotify (unless someone opens a pull request).

## Lyrics Support

EeveeSpotify replaces Spotify monthly limited lyrics with one of the following four lyrics providers:

- Genius: Offers the best quality lyrics, provides the most songs, and updates lyrics the fastest. Does not and will never be time-synced.

- LRCLIB: The most open service, offering time-synced lyrics. However, it lacks lyrics for many songs.

- Musixmatch: The service Spotify uses. Provides time-synced lyrics for many songs, but you'll need a user token to use this source. To obtain the token, download Musixmatch from the App Store, sign up, then go to Settings > Get help > Copy debug info, and paste it into EeveeSpotify alert. You can also extract the token using MITM.

- PetitLyrics: Offers plenty of time-synced Japanese and some international lyrics.

If the tweak is unable to find a song or process the lyrics, you'll see a "Couldn't load the lyrics for this song" message. The lyrics might be wrong for some songs when using Genius due to how the tweak searches songs. While I've made it work in most cases, kindly refrain from opening issues about it.

## How It Works

**Starting with version 4.0, EeveeSpotify intercepts Spotify requests to load user data, deserializes it, and modifies the parameters in real-time. This method is the best so far and works incredibly stable, so the below explanation is no longer valid for v4.0 and later.**

Upon login, Spotify fetches user data and caches it in the `offline.bnk` file in the `/Library/Application Support/PersistentCache` directory. It uses its proprietary binary format to store data, incorporating a length byte before each value, among other conventions. Certain keys, such as `player-license`, `financial-product`, `streaming-rules`, and others, determine the user abilities.

The tweak patches this file while initializing; Spotify loads it and assumes you have Premium. To be honest, it doesn't really patch due to challenges with dynamic length and varied bytes. The tweak extracts the username from the current `offline.bnk` file and inserts it into `premiumblank.bnk` (a file containing all premium values preset), replacing `offline.bnk`. Spotify may reload user data, and you'll be switched to the Free plan. When this happens, you'll see a popup with quick restart app and reset data actions.

![Hex](Images/hex.png)

Tweak also sets `trackRowsEnabled` in `SPTFreeTierArtistHubRemoteURLResolver` to `true`, so Spotify loads not just track names on the artist page, and adds a liked tracks row to the artist view models, allowing you to see the liked tracks row just like with Premium.

To open Spotify links in sideloaded app, use [OpenSpotifySafariExtension](https://github.com/BillyCurtis/OpenSpotifySafariExtension). Remember to activate it and allow access in Settings > Safari > Extensions.

## Support

EeveeSpotify has always been free and open-source project. However, I started accepting crypto donations if you'd like to support me. I really appreciate it:

USDT (TRC-20): `TK4AZZLEWrahYUkKDG8r8Pr5BmkoFjs5zU`

ETH/USDC/USDT: `0x4eFf79BdfCa9d3BC01a1d145eF343871bb0a3CdF`

BTC: `bc1qspsnjenfq6wgj9a7pmm2xe3up4622wqxlem0g5`

TON: `UQCgt8EfLdT3QOmnC11vsndUBHryi2suTcTOVCQqBgMdmg4l`

LTC: `ltc1qup3v46fm05sxd278r63957wh4qf2esehevpy76`

### Donors

Thanks to the following donors for supporting the project and funding the automatic release workflow:

- [Randy](https://github.com/randy-420)
- [HAMO](https://github.com/hamzaharoon1314)
