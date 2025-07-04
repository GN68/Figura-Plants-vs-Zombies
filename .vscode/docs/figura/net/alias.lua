---@meta _
---@diagnostic disable: duplicate-set-field


---==================================================================================================================---
---  HTTPREQUESTBUILDER                                                                                              ---
---==================================================================================================================---

---@alias HttpRequestBuilder.method
---Request a representation of a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/GET)
---|>"GET"
---Request the headers that a GET request would generate.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/HEAD)
---| "HEAD"
---Request to send data to a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/POST)
---| "POST"
---Request to create or replace a resource with the request payload.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/PUT)
---| "PUT"
---Request to delete a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/DELETE)
---| "DELETE"
---Request the permitted communication options for a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/OPTIONS)
---| "OPTIONS"
---Performs a message loop-back test along the path to a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/TRACE)
---| "TRACE"
---Requests a partial modification to a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/PATCH)
---| "PATCH"

---====##### FORBIDDEN BY JAVA IMPLEMENTATION #####====---
---Request to start a two-way connection with a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods/CONNECT)
---| "CONNECT"
---====##### FORBIDDEN BY JAVA IMPLEMENTATION #####====---

---@alias HttpRequestBuilder.header string
---Provides credentials used for authenticating the user.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization)
---| "authorization"
---Provides credentials used for authenticating with a proxy server.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Proxy-Authorization)
---| "proxy-authorization"
---Holds instructions that control caching.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)
---| "cache-control"
---Conditional that only allows a request to succeed if a resource matches an ETag value in the header.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Match)
---| "if-match"
---Conditional that only allows a request to succeed if a resource does not match an ETag value in the header.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-None-Match)
---| "if-none-match"
---Conditional that only allows a request to succeed if a resource has been modified since the date in the header.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Modified-Since)
---| "if-modified-since"
---Conditional that only allows a request to succeed if a resource has not been modified since the date in the header.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Unmodified-Since)
---| "if-unmodified-since"
---Controls how to keep a connection alive when `Connection` is set to `keep-alive`.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Keep-Alive)
---| "keep-alive"
---Indicates which MIME types a client understands.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept)
---| "accept"
---Indicates which encodings or compression algorithms a client understands.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Encoding)
---| "accept-encoding"
---Indicates the natural languages/locales a client prefers.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Language)
---| "accept-language"
---Used with `TRACE` to limit the number of nodes the request can go through.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Max-Forwards)
---| "max-forwards"
---Contains cookies associated with a server.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cookie)
---| "cookie"
---Contains a list of headers the client may send when an actual request is made after a preflight request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Request-Headers)
---| "access-control-request-headers"
---Contains the method the client will use when an actual request is made after a preflight request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Request-Method)
---| "access-control-request-method"
---Contains the origin that caused a request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Origin)
---| "origin"
---Contains data about a subpart in a multipart form.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition)
---| "content-disposition"
---Contains the type of the sent data in a POST or PUT request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type)
---| "content-type"
---Contains information added by reverse proxy servers that would otherwise be lost.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Forwarded)
---| "forwarded"
---General header added by proxies for utility reasons.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Via)
---| "via"
---Contains an email address for a user that controls a requesting User-Agent.  
---If your User-Agent is automated, this should be filled so you can be contacted in case the User-Agent breaks or makes
---too many bad requests.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/From)
---| "from"
---Contains the address from which a resource was requested.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referer)
---| "referer"
---A string that lets servers identify the type and/or version of the client.
---
---Java provides a default User-Agent of `"Java-http-client/<Java Version>"`
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/User-Agent)
---| "user-agent"
---Indicates the parts of a resource a server should return.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Range)
---| "range"
---Conditional only returns partial content if it succeeds, otherwise the entire content is returned.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/If-Range)
---| "if-range"
---Signals to a server the preference for an encrypted and authenticated response.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Upgrade-Insecure-Requests)
---| "upgrade-insecure-requests"
---Indicates the relationship between the origins of a request and resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Sec-Fetch-Site)
---| "sec-fetch-site"
---Indicates the mode of the request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Sec-Fetch-Mode)
---| "sec-fetch-mode"
---Indicates a request sent due to user activation.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Sec-Fetch-User)
---| "sec-fetch-user"
---Determines how the result of a request will be used.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Sec-Fetch-Dest)
---| "sec-fetch-dest"
---Indicates the purpose for a requested resource if that purpose isn't immediate use.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Sec-Purpose)
---| "sec-purpose"
---Indicates that a request was made due to a fetch made during service worker navigation preloading.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Service-Worker-Navigation-Preload)
---| "service-worker-navigation-preload"
---Specifies the form of encoding used to safely transfer a payload to a user.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Transfer-Encoding)
---| "transfer-encoding"
---Specifies the transform encodings a client is willing to accept.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/TE)
---| "te"
---Allows a sender to include additional fields at the end of chunked messages.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Trailer)
---| "trailer"
---Identifies the alternative service that is in use.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Alt-Used)
---| "alt-used"
---Contains the date and time (in GMT) at which a message originated.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date)
---| "date"

---====##### FORBIDDEN BY JAVA IMPLEMENTATION #####====---
---Controls whether a network connection stays open after a transaction finishes.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Connection)
---| "connection"
---Indicates a client is waiting for a 100 Continue response to continue its request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expect)
---| "expect"
---Specifies the size of the message body in bytes.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Length)
---| "content-length"
---Specifies the host and port of the server a request is being sent to.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Host)
---| "host"
---Contains protocols a client suggests a server switches to.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Upgrade)
---| "upgrade"
---====##### FORBIDDEN BY JAVA IMPLEMENTATION #####====---

---====##### FORBIDDEN BY FIGURA IMPLEMENTATION #####====---
---| "x-host"
---| "x-forwarded-host"
---====##### FORBIDDEN BY FIGURA IMPLEMENTATION #####====---


---==================================================================================================================---
---  HTTPRESPONSE                                                                                                    ---
---==================================================================================================================---

---@alias HttpResponse.header string
---Defines the authentication challenges the client might use to gain access to a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/WWW-Authenticate)
---| "www-authenticate"
---Defines the authentication challenges the client might use to gain access to a resource behind a proxy server.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Proxy-Authenticate)
---| "proxy-authenticate"
---Contains the time in seconds the requested resource was in a proxy cache.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Age)
---| "age"
---Holds instructions that control caching.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)
---| "cache-control"
---Clears browsing data associated with the requesting website.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Clear-Site-Data)
---| "clear-site-data"
---Contains the date and time after which the response is considered expired.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Expires)
---| "expires"
---Contains the date and time when the server believes the resource was last modified.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Last-Modified)
---| "last-modified"
---An identifier for a specific version of a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag)
---| "etag"
---Describes the parts of a request that influenced the content of a response.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Vary)
---| "vary"
---Controls whether a network connection stays open after a transaction finishes.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Connection)
---| "connection"
---Controls how to keep a connection alive when `Connection` is set to `keep-alive`.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Keep-Alive)
---| "keep-alive"
---Sends a cookie from a server to a client.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie)
---| "set-cookie"
---Tells clients whether a server allows cross-origin HTTP requests to include credentials.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials)
---| "access-control-allow-credentials"
---Indicates what headers are allowed in response to a preflight request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Headers)
---| "access-control-allow-headers"
---Indicates what methods are allowed in response to a preflight request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Methods)
---| "access-control-allow-methods"
---Indicates whether a response can be shared with requesting code from the given origin.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin)
---| "access-control-allow-origin"
---Indicates the response headers that should be made available to scripts running in the client in response to a
---cross-origin request.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Expose-Headers)
---| "access-control-expose-headers"
---Indicates how long the results of a preflight request can be cached.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Max-Age)
---| "access-control-max-age"
---Specifies origins that are allowed to see results of Resource Timing which would otherwise be reported as 0.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Timing-Allow-Origin)
---| "timing-allow-origin"
---Specifies if the content of a response should be displayed inline or downloaded.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Disposition)
---| "content-disposition"
---Specifies the size of the message body in bytes.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Length)
---| "content-length"
---Contains the actual type of the returned content.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type)
---| "content-type"
---Contains a list of encodings that have been applied to the payload and in what order.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding)
---| "content-encoding"
---Describes the langauges/locales a resource is intended for. This is not for describing the language the resource is
---written in.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Language)
---| "content-language"
---Indicates an alternate location for a responses returned data.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Location)
---| "content-location"
---General header added by proxies for utility reasons.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Via)
---| "via"
---Indicates the URL to redirect a page to.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Location)
---| "location"
---Directs the client to reload the page or redirect to another page.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers#redirects)
---| "refresh"
---Controls how much referrer information should be included with requests.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy)
---| "referrer-policy"
---Contains a list of request methods which may be used on a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Allow)
---| "allow"
---A string that lets clients identify the software of a server.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Server)
---| "server"
---Existance of this header defines support for partial requests. The value of this header contains the unit used to
---define ranges.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Ranges)
---| "accept-ranges"
---Contains the range in a full message where a partial message belongs.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Range)
---| "content-range"
---Configures embedding cross-origin resources.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Embedder-Policy)
---| "cross-origin-embedder-policy"
---Ensures a top-level document does not share a context with cross-origin documents.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Opener-Policy)
---| "cross-origin-opener-policy"
---Requests that the client blocks no-cors cross-origin requests to a resource.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cross-Origin-Resource-Policy)
---| "cross-origin-resource-policy"
---Controls resources a User-Agent is allowed to load for a page.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy)
---| "content-security-policy"
---Allows experimenting with policies by monitoring instead of enforcing them.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only)
---| "content-security-policy-report-only"
---Allows or denies client features in a document.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Permissions-Policy)
---| "permissions-policy"
---Informs clients that the site should only be accessed through HTTPS and any further attempts should be converted.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security)
---| "strict-transport-security"
---Indicates that the MIME type in `Content-Type` should not be ignored and is correct.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Content-Type-Options)
---| "x-content-type-options"
---Indicates whether this site allows the client to render this page as an embed.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-Frame-Options)
---| "x-frame-options"
---Specifies if a cross-domain policy file is allowed.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers#security)
---| "x-permitted-cross-domain-policies"
---Contains information set by hosting environments or frameworks.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers#security)
---| "x-powered-by"
---Request the client to stop loading a page if an XSS attack is detected.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-XSS-Protection)
---| "x-xss-protection"
---Contians the endpoint for a client to send warnings or errors to.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers#server-sent_events)
---| "report-to"
---Specifies the form of encoding used to safely transfer a payload to a user.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Transfer-Encoding)
---| "transfer-encoding"
---Allows a sender to include additional fields at the end of chunked messages.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Trailer)
---| "trailer"
---Indicates that another network location can be treated as authoritative for an origin when making future requests.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Alt-Svc)
---| "alt-svc"
---Contains the date and time (in GMT) at which a message originated.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Date)
---| "date"
---Contains links as if they were placed in a `<link>` element.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Link)
---| "link"
---Indicates the amount of time a client should wait before attempting a request again.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Retry-After)
---| "retry-after"
---Contains server metrics and descriptions for a request-response cycle.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Server-Timing)
---| "server-timing"
---Removes the path restriction of service workers.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers#other)
---| "service-worker-allowed"
---Links generated code to a source map.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/SourceMap)
---| "sourcemap"
---Upgrades an established connection to a different protocol.
---
---[MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Upgrade)
---| "upgrade"
