shell-utils
===========

Various shell (bash) utilities to aid Linux life

skype-notify.sh
---------------

Use to trigger libnotify with some filtering.

Provide three arguments:
    - event title (i.e. "Message received")
    - user name (see "%sname" in Skype)
    - notification message (possibly "%smessage" in Skype)

From Skype options (Skype -> Options -> Notifications) check the event
(i.e. "Message received") and add this kind of script:
skype-notify.sh "You got message!" "%sname" "%smessage"

If the message matches your filters (check internals of
'''skype-notify.sh''') you will see notification poping-up.

add-timely-headers.sh
---------------------

Add Time.ly headers to PHP files within current working directory.
