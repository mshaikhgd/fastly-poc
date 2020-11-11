if (req.request != "OPTIONS"  && req.request != "GET" && req.request != "HEAD" && req.request != "FASTLYPURGE" && req.request != "POST") {
  error 405;
}

set req.http.X-Forwarded-Server = "${ssl_cert_host}";
