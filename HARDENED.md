Mastodon Hardened
=================

Mastodon Hardened is a (hopefully) friendly fork of Mastodon with emphasis on abuse mitigation,
as well as stricter adherence to the philosophy behind AGPL free software.


## Key differences


### New timeline filtering algorithm

Mastodon Hardened uses a stricter filtering algorithm for the main timelines.  Specifically, in
contrast to Mastodon itself:

 * Anything that has a participant that is muted or blocked is filtered
 * Anything that has metadata related to any account that is muted or blocked is filtered
 * Anything that directly involves a participant which is blocking the user is filtered; this
   works as an implicit mute

The first two aspects are simply a more hardened (and arguably more correct) version of what
Mastodon itself does.

The implicit mute feature is new and is intended to be both de-escalatory as well as solve a major
usability issue where users can only see/interact with portions of a conversation due to blocks.
It is our opinion that the usability issue leads to major confusion, as the user is seeing posts
involving a user they cannot interact with.


### Block transparency

Mastodon Hardened is transparent concerning user blocks.  When a user is blocked, they will see
a lock icon on the profile of the user who has blocked them and the UI will explicitly forbid
interaction with that user.

Additionally, unlike Mastodon, blocked users may view (but not interact with) posts which they
had received prior to being blocked.

Admins may see all posts regardless.


### Block reciprocation

Mastodon Hardened adds a new account setting which blocks users reciprocally.

This is mostly intended as a mitigation against users who block a victim shortly after
performing abuse in order to guard against forensic analysis of the abuse.


### Block notification suppression

Mastodon Hardened adds a new account setting which allows for suppressing the block
notifications.  This is intended to allow a victim to block abusers without their
knowledge.

Note: Block notification suppression does mean that the abusers may be able to view
newly published statuses on multi-user servers.


### Local (unfederated) status visibility

Mastodon Hardened adds a new federation visibility setting which allows for excluding
statuses from federation.  This is mainly intended for instance-specific news that is
uninteresting when federated.


## Design goals

* Unintended redistributions of statuses to the general public should be considered
  a safety-critical issue.

* Private statuses (DMs, follower-only posts) must never be leakable to the general
  public.

* DMs must be redesigned in the UI to ensure no accidental leakages.

* Third-party applications should be blockable by the admins, so that third party
  apps which cause users to harm themselves (e.g. private status leakage to public)
  could be blocked.
