

Simple message router that relays messages between different protocols.

The protocols are implemented as plugins and there are three types:

- handlers: for message reception. Ex. a TCP client.
- listeners: for message generation. Ex. a TCP server.
- events: send and receive messages. Just one for now: a jabber plugin.


Sample config:


```
---

channels:
  logger:
    class: Log
    params:
    - /tmp/sample.log
  thriftrecv:
    class: ThriftListener
    params:
    - "0.0.0.0"
    - 9998
  smtp_notif:
    class: SmtpSender
    params:
    - my.smtp.sample.com
    - This is the subject.
    - this.is.the@from.com
    - - send.to1@sample.com
      - send.to2@sample.com


routes:
  - channel: !ruby/regexp /.*/
    body: !ruby/regexp /.*/
    flags: c
    route: logger
  - channel: !ruby/regexp /^thriftrecv$/
    body: !ruby/regexp /.*/
    flags: 
    route: smtp_notif
```


With this configuration, the router opens a new socket on port 9998,
and every thrift message will generate a new mail.
A log will also be saved for every message we get.




